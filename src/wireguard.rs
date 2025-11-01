use anyhow::{Context, Result};
use base64::Engine;
use boringtun::noise::{Tunn, TunnResult};
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::UdpSocket;
use tokio::sync::Mutex;
use tracing::{debug, error};

pub struct WireGuardTunnel {
    tunnel: Arc<Mutex<Box<Tunn>>>,
    socket: Arc<UdpSocket>,
    endpoint: SocketAddr,
}

impl WireGuardTunnel {
    pub async fn new(
        private_key: &str,
        public_key: &str,
        endpoint: &str,
        _local_ip: &str,
    ) -> Result<Self> {
        // Decode keys
        let private_key_bytes = base64::engine::general_purpose::STANDARD
            .decode(private_key.trim())
            .context("invalid private key base64")?;

        let public_key_bytes = base64::engine::general_purpose::STANDARD
            .decode(public_key.trim())
            .context("invalid public key base64")?;

        if private_key_bytes.len() != 32 {
            anyhow::bail!("private key must be 32 bytes");
        }
        if public_key_bytes.len() != 32 {
            anyhow::bail!("public key must be 32 bytes");
        }

        let mut priv_key = [0u8; 32];
        priv_key.copy_from_slice(&private_key_bytes);

        let mut pub_key = [0u8; 32];
        pub_key.copy_from_slice(&public_key_bytes);

        // Parse endpoint
        let endpoint: SocketAddr = endpoint
            .parse()
            .context("invalid endpoint address")?;

        // Create tunnel
        let tunnel = Tunn::new(
            priv_key.into(),
            pub_key.into(),
            None,
            None,
            0,
            None,
        )
        .map_err(|e| anyhow::anyhow!("failed to create WireGuard tunnel: {}", e))?;

        // Bind UDP socket
        let socket = UdpSocket::bind("0.0.0.0:0").await
            .context("failed to bind UDP socket")?;

        debug!("WireGuard tunnel created, endpoint: {}", endpoint);

        Ok(Self {
            tunnel: Arc::new(Mutex::new(Box::new(tunnel))),
            socket: Arc::new(socket),
            endpoint,
        })
    }

    pub async fn send_packet(&self, packet: &[u8]) -> Result<()> {
        let mut tunnel = self.tunnel.lock().await;
        let mut out_buf = vec![0u8; packet.len() + 148]; // WireGuard overhead

        match tunnel.encapsulate(packet, &mut out_buf) {
            TunnResult::WriteToNetwork(data) => {
                self.socket.send_to(data, self.endpoint).await
                    .context("failed to send to WireGuard endpoint")?;
                Ok(())
            }
            TunnResult::Err(e) => {
                error!("WireGuard encapsulation error: {:?}", e);
                anyhow::bail!("encapsulation error: {:?}", e)
            }
            _ => Ok(()),
        }
    }

    pub async fn receive_packet(&self, buf: &mut [u8]) -> Result<Option<Vec<u8>>> {
        let mut recv_buf = vec![0u8; 2048];
        
        match tokio::time::timeout(
            std::time::Duration::from_millis(100),
            self.socket.recv_from(&mut recv_buf)
        ).await {
            Ok(Ok((len, _addr))) => {
                let mut tunnel = self.tunnel.lock().await;
                match tunnel.decapsulate(None, &recv_buf[..len], buf) {
                    TunnResult::WriteToTunnelV4(data, _) | TunnResult::WriteToTunnelV6(data, _) => {
                        Ok(Some(data.to_vec()))
                    }
                    TunnResult::Err(e) => {
                        debug!("WireGuard decapsulation error: {:?}", e);
                        Ok(None)
                    }
                    _ => Ok(None),
                }
            }
            Ok(Err(e)) => Err(e.into()),
            Err(_) => Ok(None), // Timeout
        }
    }

    pub fn clone_socket(&self) -> Arc<UdpSocket> {
        Arc::clone(&self.socket)
    }

    pub fn clone_tunnel(&self) -> Arc<Mutex<Box<Tunn>>> {
        Arc::clone(&self.tunnel)
    }

    pub fn endpoint(&self) -> SocketAddr {
        self.endpoint
    }
}
