use anyhow::{Context, Result};
use std::collections::HashMap;
use std::net::{IpAddr, SocketAddr};
use std::sync::Arc;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpStream, UdpSocket};
use tokio::sync::Mutex;
use tracing::{debug, error};

use crate::args::Args;
use crate::wireguard::WireGuardTunnel;

pub async fn run_network_stack(args: &Args, private_key: &str) -> Result<()> {
    // Create WireGuard tunnel
    let wg_tunnel = WireGuardTunnel::new(
        private_key,
        &args.wg_public_key,
        &args.wg_endpoint,
        &args.wg_address,
    )
    .await?;

    // Open TUN device for reading packets from subprocess
    // Note: Device was already created and configured in namespace setup
    let mut config = tun::Configuration::default();
    config.name(&args.tun);

    #[cfg(target_os = "linux")]
    config.platform(|config| {
        config.packet_information(false);
    });

    // Open the existing device
    let device = tun::create_as_async(&config)
        .context("failed to open TUN device")?;

    let (mut tun_reader, mut tun_writer) = tokio::io::split(device);

    // Spawn task to forward packets from TUN to WireGuard
    let wg_tunnel_tx = wg_tunnel.clone_tunnel();
    let wg_socket_tx = wg_tunnel.clone_socket();
    let wg_endpoint = wg_tunnel.endpoint();
    
    tokio::spawn(async move {
        let mut packet_buf = vec![0u8; 2048];
        debug!("TUN->WG forwarder started");
        loop {
            match tun_reader.read(&mut packet_buf).await {
                Ok(n) if n > 0 => {
                    debug!("TUN->WG: read {} bytes from TUN", n);
                    
                    // Encapsulate and send via WireGuard
                    let mut tunnel = wg_tunnel_tx.lock().await;
                    let mut out_buf = vec![0u8; n + 148];
                    
                    match tunnel.encapsulate(&packet_buf[..n], &mut out_buf) {
                        boringtun::noise::TunnResult::WriteToNetwork(data) => {
                            debug!("TUN->WG: sending {} bytes to WireGuard endpoint", data.len());
                            if let Err(e) = wg_socket_tx.send_to(data, wg_endpoint).await {
                                error!("TUN->WG: failed to send to WireGuard: {}", e);
                            } else {
                                debug!("TUN->WG: sent successfully");
                            }
                        }
                        boringtun::noise::TunnResult::Err(e) => {
                            error!("TUN->WG: WireGuard encapsulation error: {:?}", e);
                        }
                        result => {
                            debug!("TUN->WG: encapsulation result: {:?}", result);
                        }
                    }
                }
                Ok(_) => {}
                Err(e) => {
                    error!("error reading from TUN: {}", e);
                    break;
                }
            }
        }
    });

    // Spawn task to forward packets from WireGuard to TUN
    let wg_tunnel_rx = wg_tunnel.clone_tunnel();
    let wg_socket_rx = wg_tunnel.clone_socket();
    
    tokio::spawn(async move {
        let mut recv_buf = vec![0u8; 2048];
        let mut decap_buf = vec![0u8; 2048];
        debug!("WG->TUN forwarder started");
        
        loop {
            match wg_socket_rx.recv_from(&mut recv_buf).await {
                Ok((n, addr)) => {
                    debug!("WG->TUN: received {} bytes from WireGuard (from {})", n, addr);
                    
                    let mut tunnel = wg_tunnel_rx.lock().await;
                    match tunnel.decapsulate(None, &recv_buf[..n], &mut decap_buf) {
                        boringtun::noise::TunnResult::WriteToTunnelV4(data, _) |
                        boringtun::noise::TunnResult::WriteToTunnelV6(data, _) => {
                            debug!("WG->TUN: decapsulated {} bytes, writing to TUN", data.len());
                            if let Err(e) = tun_writer.write_all(data).await {
                                error!("WG->TUN: failed to write to TUN: {}", e);
                            } else {
                                debug!("WG->TUN: wrote {} bytes to TUN successfully", data.len());
                            }
                        }
                        boringtun::noise::TunnResult::Err(e) => {
                            error!("WG->TUN: WireGuard decapsulation error: {:?}", e);
                        }
                        result => {
                            debug!("WG->TUN: decapsulation result: {:?}", result);
                        }
                    }
                }
                Err(e) => {
                    error!("error receiving from WireGuard: {}", e);
                    break;
                }
            }
        }
    });

    // Keep running
    tokio::signal::ctrl_c().await?;
    
    Ok(())
}

async fn proxy_tcp_connection(
    mut local: TcpStream,
    remote_addr: SocketAddr,
) -> Result<()> {
    let mut remote = TcpStream::connect(remote_addr).await
        .context("failed to connect to remote")?;

    let (mut local_r, mut local_w) = local.split();
    let (mut remote_r, mut remote_w) = remote.split();

    tokio::select! {
        result = tokio::io::copy(&mut local_r, &mut remote_w) => {
            result?;
        }
        result = tokio::io::copy(&mut remote_r, &mut local_w) => {
            result?;
        }
    }

    Ok(())
}
