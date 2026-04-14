//! wirecagesrv - WireGuard VPN server with userspace NAT
//!
//! Features:
//! - Userspace WireGuard (no kernel module needed)
//! - Userspace NAT via smoltcp (no iptables needed for NAT mode)
//! - HTTPS API for dynamic peer registration with token auth
//! - Inbound TCP/UDP port forwarding managed through the API

mod api;
mod dataplane;
mod flow;
mod state;
mod wg;

use std::net::Ipv4Addr;
use std::sync::Arc;

use anyhow::{Context, Result};
use base64::Engine;
use clap::Parser;
use tokio::sync::mpsc;
use tracing::{error, info};
use x25519_dalek::{PublicKey, StaticSecret};

use state::{ServerConfig, SharedState};
use wg::WgIo;

#[derive(Parser, Debug, Clone)]
#[command(name = "wirecagesrv")]
#[command(about = "WireGuard VPN Server with userspace NAT and HTTPS API")]
struct Args {
    /// Path to server private key file (base64-encoded 32-byte key)
    #[arg(long, env = "WG_PRIVATE_KEY_FILE")]
    private_key_file: String,

    /// WireGuard listen address and port
    #[arg(long, default_value = "0.0.0.0:51820")]
    wg_listen: String,

    /// API listen address and port
    #[arg(long, default_value = "0.0.0.0:8443")]
    api_listen: String,

    /// Server IP address within the VPN subnet
    #[arg(long, default_value = "10.200.100.1")]
    server_ip: String,

    /// VPN subnet mask (CIDR notation, just the number)
    #[arg(long, default_value = "24")]
    subnet_mask: u8,

    /// Authentication token for the API (required)
    #[arg(long, env = "AUTH_TOKEN")]
    auth_token: String,

    /// Public endpoint for clients (host:port), e.g., "vpn.example.com:51820"
    #[arg(long, env = "WG_ENDPOINT")]
    wg_endpoint: String,

    /// TLS certificate file for HTTPS API (optional, uses HTTP if not provided)
    #[arg(long)]
    tls_cert: Option<String>,

    /// TLS private key file for HTTPS API (optional)
    #[arg(long)]
    tls_key: Option<String>,
}

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize logging
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| {
                tracing_subscriber::EnvFilter::new("info")
                    .add_directive("gotatun::noise::timers=error".parse().unwrap())
            }),
        )
        .init();

    let args = Args::parse();

    // Load server private key
    let private_key_b64 = tokio::fs::read_to_string(&args.private_key_file)
        .await
        .context("failed to read server private key file")?;

    let private_key_bytes = base64::engine::general_purpose::STANDARD
        .decode(private_key_b64.trim())
        .context("invalid private key encoding")?;

    if private_key_bytes.len() != 32 {
        anyhow::bail!("private key must be 32 bytes");
    }

    let mut server_private_key = [0u8; 32];
    server_private_key.copy_from_slice(&private_key_bytes);

    // Derive public key
    let secret = StaticSecret::from(server_private_key);
    let public = PublicKey::from(&secret);
    let server_public_key = *public.as_bytes();

    info!(
        "Server public key: {}",
        base64::engine::general_purpose::STANDARD.encode(server_public_key)
    );

    // Parse server IP
    let server_ip: Ipv4Addr = args.server_ip.parse().context("invalid server IP")?;

    // Create shared state
    let config = ServerConfig {
        server_private_key,
        server_public_key,
        listen_addr: args.wg_listen.clone(),
        api_listen_addr: args.api_listen.clone(),
        subnet: server_ip,
        subnet_mask: args.subnet_mask,
        auth_token: args.auth_token.clone(),
        tls_cert_path: args.tls_cert.clone(),
        tls_key_path: args.tls_key.clone(),
    };

    let shared_state = SharedState::new(config);

    // Create WireGuard IO
    let wg_io = Arc::new(
        WgIo::new(&args.wg_listen, server_private_key, Arc::clone(&shared_state))
            .await
            .context("failed to create WireGuard IO")?,
    );

    // Create channel for WG -> dataplane communication
    let (wg_to_dataplane_tx, wg_to_dataplane_rx) = mpsc::channel(1000);

    // Create channel for API -> dataplane port forward events
    let (port_forward_tx, port_forward_rx) = mpsc::channel(100);

    // Spawn WireGuard receive task
    let wg_io_recv = Arc::clone(&wg_io);
    tokio::spawn(async move {
        if let Err(e) = wg_io_recv.run_receive(wg_to_dataplane_tx).await {
            error!("WireGuard receive task failed: {}", e);
        }
    });

    // Spawn dataplane task
    let wg_io_dataplane = Arc::clone(&wg_io);
    tokio::spawn(async move {
        if let Err(e) =
            dataplane::run_dataplane(wg_io_dataplane, wg_to_dataplane_rx, server_ip, port_forward_rx)
                .await
        {
            error!("Dataplane task failed: {}", e);
        }
    });

    // Create and run API server
    let router = api::create_router(
        Arc::clone(&shared_state),
        args.wg_endpoint.clone(),
        port_forward_tx,
    );

    info!("API server listening on {}", args.api_listen);

    if args.tls_cert.is_some() && args.tls_key.is_some() {
        // HTTPS mode
        let tls_config = axum_server::tls_rustls::RustlsConfig::from_pem_file(
            args.tls_cert.as_ref().unwrap(),
            args.tls_key.as_ref().unwrap(),
        )
        .await
        .context("failed to load TLS config")?;

        let addr: std::net::SocketAddr = args.api_listen.parse().context("invalid API listen address")?;
        axum_server::bind_rustls(addr, tls_config)
            .serve(router.into_make_service())
            .await
            .context("API server failed")?;
    } else {
        // HTTP mode (for development/testing)
        info!("Running API in HTTP mode (no TLS configured)");
        let listener = tokio::net::TcpListener::bind(&args.api_listen)
            .await
            .context("failed to bind API listener")?;
        axum::serve(listener, router)
            .await
            .context("API server failed")?;
    }

    Ok(())
}
