//! WireGuard IO layer for wirecagesrv
//!
//! Handles:
//! - UDP socket for WireGuard protocol
//! - Encryption/decryption via gotatun
//! - Dynamic peer management

use std::collections::HashMap;
use std::net::SocketAddr;
use std::sync::Arc;
use anyhow::{Context, Result};
use base64::Engine;
use gotatun::noise::{Tunn, TunnResult};
use gotatun::packet::Packet;
use parking_lot::RwLock;
use tokio::net::UdpSocket;
use tokio::sync::mpsc;
use tracing::{debug, info, warn};
use zerocopy::IntoBytes;

use super::state::SharedState;

const MAX_PACKET: usize = 65536;

/// A WireGuard peer with tunnel state
pub struct WgPeer {
    pub tunnel: parking_lot::Mutex<Tunn>,
    pub endpoint: RwLock<Option<SocketAddr>>,
}

impl WgPeer {
    pub fn new(server_private_key: [u8; 32], peer_public_key: [u8; 32]) -> Self {
        let tunnel = Tunn::new(
            server_private_key.into(),
            peer_public_key.into(),
            None,
            None,
            0,
            None,
        );
        Self {
            tunnel: parking_lot::Mutex::new(tunnel),
            endpoint: RwLock::new(None),
        }
    }
}

/// Packet from WireGuard to dataplane (decrypted)
#[derive(Debug)]
pub struct WgToDataplane {
    pub peer_pubkey: [u8; 32],
    pub ip_packet: Vec<u8>,
}

/// Packet from dataplane to WireGuard (to encrypt and send)
#[derive(Debug)]
pub struct DataplaneToWg {
    pub peer_pubkey: [u8; 32],
    pub ip_packet: Vec<u8>,
}

/// WireGuard IO handler
pub struct WgIo {
    socket: Arc<UdpSocket>,
    server_private_key: [u8; 32],
    peers: Arc<RwLock<HashMap<[u8; 32], Arc<WgPeer>>>>,
    shared_state: Arc<SharedState>,
}

impl WgIo {
    pub async fn new(
        listen_addr: &str,
        server_private_key: [u8; 32],
        shared_state: Arc<SharedState>,
    ) -> Result<Self> {
        let socket = UdpSocket::bind(listen_addr)
            .await
            .context("failed to bind WireGuard UDP socket")?;

        info!("WireGuard listening on {}", socket.local_addr()?);

        Ok(Self {
            socket: Arc::new(socket),
            server_private_key,
            peers: Arc::new(RwLock::new(HashMap::new())),
            shared_state,
        })
    }

    /// Add a peer dynamically
    pub fn add_peer(&self, peer_public_key: [u8; 32]) {
        let peer = Arc::new(WgPeer::new(self.server_private_key, peer_public_key));
        self.peers.write().insert(peer_public_key, peer);
        info!(
            "Added WireGuard peer: {}",
            base64::engine::general_purpose::STANDARD.encode(peer_public_key)
        );
    }

    /// Remove a peer
    pub fn remove_peer(&self, peer_public_key: &[u8; 32]) {
        self.peers.write().remove(peer_public_key);
    }

    /// Get socket for sending
    pub fn socket(&self) -> Arc<UdpSocket> {
        Arc::clone(&self.socket)
    }

    /// Get peers map
    pub fn peers(&self) -> Arc<RwLock<HashMap<[u8; 32], Arc<WgPeer>>>> {
        Arc::clone(&self.peers)
    }

    /// Get shared state
    pub fn shared_state(&self) -> Arc<SharedState> {
        Arc::clone(&self.shared_state)
    }

    /// Run the receive loop - decrypts incoming WG packets and sends to dataplane
    pub async fn run_receive(
        self: Arc<Self>,
        to_dataplane: mpsc::Sender<WgToDataplane>,
    ) -> Result<()> {
        let mut buf = vec![0u8; MAX_PACKET];

        loop {
            let (len, addr) = self.socket.recv_from(&mut buf).await?;
            let packet_data = &buf[..len];

            if let Err(e) = self.handle_incoming(packet_data, addr, &to_dataplane).await {
                debug!("Error handling incoming packet from {}: {}", addr, e);
            }
        }
    }

    async fn handle_incoming(
        &self,
        packet_data: &[u8],
        addr: SocketAddr,
        to_dataplane: &mpsc::Sender<WgToDataplane>,
    ) -> Result<()> {
        // Check registered peers from shared state and ensure WgPeer exists
        self.sync_peers_from_state();

        let peer_keys: Vec<([u8; 32], Arc<WgPeer>)> = {
            let peers = self.peers.read();
            peers.iter().map(|(k, v)| (*k, Arc::clone(v))).collect()
        };

        for (pubkey, peer) in peer_keys {
            let packet = Packet::from_bytes(bytes::BytesMut::from(packet_data));
            let wg_packet = match packet.try_into_wg() {
                Ok(p) => p,
                Err(_) => return Ok(()),
            };

            // Process packet under lock, extract result data before any await
            let result = {
                let mut tunnel = peer.tunnel.lock();
                match tunnel.handle_incoming_packet(wg_packet) {
                    TunnResult::Done => {
                        *peer.endpoint.write() = Some(addr);
                        Some((None, None)) // Done, no response needed
                    }
                    TunnResult::WriteToNetwork(response) => {
                        *peer.endpoint.write() = Some(addr);
                        let response_packet: Packet = response.into();
                        Some((Some(response_packet.as_bytes().to_vec()), None))
                    }
                    TunnResult::WriteToTunnel(decrypted) => {
                        *peer.endpoint.write() = Some(addr);
                        Some((None, Some(decrypted.as_bytes().to_vec())))
                    }
                    TunnResult::Err(_) => None, // Try next peer
                }
            };

            match result {
                Some((Some(response_bytes), None)) => {
                    self.socket.send_to(&response_bytes, addr).await?;
                    return Ok(());
                }
                Some((None, Some(decrypted_bytes))) => {
                    let msg = WgToDataplane {
                        peer_pubkey: pubkey,
                        ip_packet: decrypted_bytes,
                    };
                    if to_dataplane.send(msg).await.is_err() {
                        warn!("Dataplane channel closed");
                    }
                    return Ok(());
                }
                Some((None, None)) => {
                    return Ok(());
                }
                None => continue, // Try next peer
                _ => continue,
            }
        }

        debug!("No peer could decrypt packet from {}", addr);
        Ok(())
    }

    /// Sync peers from shared state registry
    fn sync_peers_from_state(&self) {
        let state_peers = self.shared_state.peers.read();
        let mut wg_peers = self.peers.write();

        for peer_info in state_peers.iter() {
            if !wg_peers.contains_key(&peer_info.public_key) {
                let peer = Arc::new(WgPeer::new(self.server_private_key, peer_info.public_key));
                wg_peers.insert(peer_info.public_key, peer);
                info!(
                    "Synced new peer: {}",
                    base64::engine::general_purpose::STANDARD.encode(peer_info.public_key)
                );
            }
        }
    }

    /// Send an encrypted packet to a peer
    pub async fn send_to_peer(&self, peer_pubkey: &[u8; 32], ip_packet: &[u8]) -> Result<()> {
        // Get peer and extract what we need before any await
        let (endpoint, encrypted_packet) = {
            let peers = self.peers.read();
            let peer = peers.get(peer_pubkey).context("peer not found")?;

            let endpoint = peer.endpoint.read().context("peer has no endpoint")?;

            let packet = Packet::from_bytes(bytes::BytesMut::from(ip_packet));
            let mut tunnel = peer.tunnel.lock();

            let encrypted = if let Some(wg_packet) = tunnel.handle_outgoing_packet(packet) {
                let out_packet: Packet = wg_packet.into();
                Some(out_packet.as_bytes().to_vec())
            } else {
                None
            };

            (endpoint, encrypted)
        };

        if let Some(data) = encrypted_packet {
            self.socket.send_to(&data, endpoint).await?;
        }

        Ok(())
    }
}
