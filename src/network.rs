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

pub async fn run_network_stack(
    args: &Args, 
    private_key: &str,
    wg_socket_fd: std::os::unix::io::RawFd,
    tun_device: std::sync::Arc<std::sync::Mutex<tun::platform::Device>>
) -> Result<()> {
    debug!("network stack starting with pre-created UDP socket");
    
    // Create WireGuard tunnel using the pre-created socket from host namespace
    let wg_tunnel = WireGuardTunnel::new_from_fd(
        private_key,
        &args.wg_public_key,
        &args.wg_endpoint,
        &args.wg_address,
        wg_socket_fd,
    )
    .await?;

    // Convert the sync TUN device to async
    // The device was already created and configured in namespace setup
    let device = {
        let tun = tun_device.lock().unwrap();
        // Get the file descriptor
        use std::os::unix::io::AsRawFd;
        let fd = tun.as_raw_fd();
        
        // Duplicate the FD for async use
        let dup_fd = unsafe { libc::dup(fd) };
        if dup_fd < 0 {
            anyhow::bail!("failed to duplicate TUN fd");
        }
        
        // Create async device from the duplicated FD
        unsafe {
            use std::os::unix::io::FromRawFd;
            let file = std::fs::File::from_raw_fd(dup_fd);
            tokio::fs::File::from_std(file)
        }
    };

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
                        boringtun::noise::TunnResult::Done => {
                            debug!("TUN->WG: handshake in progress, packet buffered");
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
    
    // Spawn timer task to maintain WireGuard keepalives
    let wg_tunnel_timer = wg_tunnel.clone_tunnel();
    let wg_socket_timer = wg_tunnel.clone_socket();
    let wg_endpoint_timer = wg_tunnel.endpoint();
    
    tokio::spawn(async move {
        debug!("WireGuard timer started");
        let mut interval = tokio::time::interval(std::time::Duration::from_millis(250));
        loop {
            interval.tick().await;
            
            let mut tunnel = wg_tunnel_timer.lock().await;
            let mut out_buf = vec![0u8; 148];
            
            // Update timers - this may generate handshake packets
            match tunnel.update_timers(&mut out_buf) {
                boringtun::noise::TunnResult::WriteToNetwork(data) => {
                    debug!("Timer: sending {} bytes (keepalive/handshake)", data.len());
                    let _ = wg_socket_timer.send_to(data, wg_endpoint_timer).await;
                }
                boringtun::noise::TunnResult::Done => {}
                result => {
                    debug!("Timer: update_timers result: {:?}", result);
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
