use anyhow::{Context, Result};
use base64::Engine;
use boringtun::noise::Tunn;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::UdpSocket;
use tokio::sync::Mutex;
use tracing::debug;

pub struct WireGuardTunnel {
    tunnel: Arc<Mutex<Box<Tunn>>>,
    socket: Arc<UdpSocket>,
    endpoint: SocketAddr,
}

impl WireGuardTunnel {
    pub async fn new_simple(
        private_key: &str,
        public_key: &str,
        endpoint: &str,
        _local_ip: &str,
    ) -> Result<Self> {
        // Decode keys
        let private_key_bytes = base64::engine::general_purpose::STANDARD
            .decode(private_key.trim())
            .context("invalid private key")?;

        let public_key_bytes = base64::engine::general_purpose::STANDARD
            .decode(public_key.trim())
            .context("invalid public key")?;

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
        let endpoint: SocketAddr = endpoint.parse().context("invalid endpoint")?;

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

        // Create UDP socket
        let socket = UdpSocket::bind("0.0.0.0:0").await
            .context("failed to bind UDP socket")?;

        let local_addr = socket.local_addr()?;
        debug!("WireGuard tunnel created, local: {}, endpoint: {}", local_addr, endpoint);

        Ok(Self {
            tunnel: Arc::new(Mutex::new(Box::new(tunnel))),
            socket: Arc::new(socket),
            endpoint,
        })
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
