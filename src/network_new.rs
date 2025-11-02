use anyhow::Result;
use std::sync::Arc;
use tokio::sync::mpsc;
use tracing::{debug, error};

use crate::args::Args;
use crate::wireguard::WireGuardTunnel;

/// Packet to send from TUN (in child namespace) to WireGuard (in host namespace)
type TunToWgPacket = Vec<u8>;

/// Packet to send from WireGuard (in host namespace) to TUN (in child namespace)
type WgToTunPacket = Vec<u8>;

/// Run WireGuard in the HOST network namespace
/// This runs before we create the child network namespace
pub async fn run_wireguard_host(
    args: &Args,
    private_key: &str,
    tun_to_wg_rx: mpsc::Receiver<TunToWgPacket>,
    wg_to_tun_tx: mpsc::Sender<WgToTunPacket>,
) -> Result<()> {
    debug!("WireGuard host process starting");

    // Create WireGuard tunnel in host namespace
    let wg_tunnel = WireGuardTunnel::new_simple(
        private_key,
        &args.wg_public_key,
        &args.wg_endpoint,
    )
    .await?;

    let wg_tunnel_tx = wg_tunnel.clone_tunnel();
    let wg_socket_tx = wg_tunnel.clone_socket();
    let wg_endpoint = wg_tunnel.endpoint();

    let wg_tunnel_rx = wg_tunnel.clone_tunnel();
    let wg_socket_rx = wg_tunnel.clone_socket();

    // Task: Forward packets from TUN (via channel) to WireGuard socket
    let mut tun_to_wg_rx = tun_to_wg_rx;
    tokio::spawn(async move {
        debug!("TUN->WG forwarder started (host namespace)");
        while let Some(packet) = tun_to_wg_rx.recv().await {
            debug!("TUN->WG: received {} bytes from channel", packet.len());

            // Retry encapsulation if handshake is in progress
            let mut retries = 0;
            loop {
                let mut tunnel = wg_tunnel_tx.lock().await;
                let mut out_buf = vec![0u8; packet.len() + 148];

                match tunnel.encapsulate(&packet, &mut out_buf) {
                    boringtun::noise::TunnResult::WriteToNetwork(data) => {
                        debug!("TUN->WG: sending {} bytes to WireGuard", data.len());
                        if let Err(e) = wg_socket_tx.send_to(data, wg_endpoint).await {
                            error!("TUN->WG: send error: {}", e);
                        }
                        break; // Success, move to next packet
                    }
                    boringtun::noise::TunnResult::Done => {
                        debug!("TUN->WG: handshake in progress (retry {})", retries);
                        retries += 1;
                        if retries > 20 {
                            error!("TUN->WG: gave up waiting for handshake");
                            break;
                        }
                        drop(tunnel); // Release lock before sleeping
                        tokio::time::sleep(std::time::Duration::from_millis(50)).await;
                        // Retry
                    }
                    boringtun::noise::TunnResult::Err(e) => {
                        error!("TUN->WG: encapsulation error: {:?}", e);
                        break;
                    }
                    _ => {
                        break;
                    }
                }
            }
        }
        debug!("TUN->WG forwarder ended");
    });

    // Task: Forward packets from WireGuard socket to TUN (via channel)
    let recv_handle = tokio::spawn(async move {
        let local_addr = wg_socket_rx.local_addr().unwrap();
        debug!(
            "WG->TUN forwarder started (host namespace), listening on {}",
            local_addr
        );
        let mut recv_buf = vec![0u8; 2048];
        let mut decap_buf = vec![0u8; 2048];
        let mut counter = 0u32;

        loop {
            counter += 1;
            debug!("WG->TUN: calling recv_from (attempt {})...", counter);
            match tokio::time::timeout(
                std::time::Duration::from_secs(2),
                wg_socket_rx.recv_from(&mut recv_buf),
            )
            .await
            {
                Ok(Ok((n, addr))) => {
                    debug!("WG->TUN: received {} bytes from {}", n, addr);

                    let mut tunnel = wg_tunnel_rx.lock().await;
                    match tunnel.decapsulate(None, &recv_buf[..n], &mut decap_buf) {
                        boringtun::noise::TunnResult::WriteToTunnelV4(data, _)
                        | boringtun::noise::TunnResult::WriteToTunnelV6(data, _) => {
                            debug!(
                                "WG->TUN: decapsulated {} bytes IP packet, sending to channel",
                                data.len()
                            );
                            if let Err(e) = wg_to_tun_tx.send(data.to_vec()).await {
                                error!("WG->TUN: channel send error: {}", e);
                                break;
                            } else {
                                debug!("WG->TUN: sent to channel successfully");
                            }
                        }
                        boringtun::noise::TunnResult::WriteToNetwork(data) => {
                            debug!(
                                "WG->TUN: got WireGuard protocol message, sending back {} bytes",
                                data.len()
                            );
                            if let Err(e) = wg_socket_rx.send_to(data, addr).await {
                                error!("WG->TUN: failed to send protocol message: {}", e);
                            }
                        }
                        boringtun::noise::TunnResult::Err(e) => {
                            error!("WG->TUN: decapsulation error: {:?}", e);
                        }
                        result => {
                            debug!("WG->TUN: decapsulation result: {:?}", result);
                        }
                    }
                }
                Ok(Err(e)) => {
                    error!("WG->TUN: recv error: {}", e);
                    break;
                }
                Err(_timeout) => {
                    debug!("WG->TUN: recv timeout (no packet in 2s)");
                }
            }
        }
        debug!("WG->TUN forwarder ended");
    });

    // Timer task for WireGuard keepalives
    let wg_tunnel_timer = wg_tunnel.clone_tunnel();
    let wg_socket_timer = wg_tunnel.clone_socket();
    let wg_endpoint_timer = wg_tunnel.endpoint();

    let timer_handle = tokio::spawn(async move {
        debug!("WireGuard timer started");
        let mut interval = tokio::time::interval(std::time::Duration::from_millis(250));
        loop {
            interval.tick().await;
            debug!("Timer: tick");

            let mut tunnel = wg_tunnel_timer.lock().await;
            let mut out_buf = vec![0u8; 148];

            match tunnel.update_timers(&mut out_buf) {
                boringtun::noise::TunnResult::WriteToNetwork(data) => {
                    debug!("Timer: sending {} bytes", data.len());
                    let _ = wg_socket_timer.send_to(data, wg_endpoint_timer).await;
                }
                boringtun::noise::TunnResult::Done => {}
                _ => {}
            }
        }
    });

    // Keep all tasks running
    debug!("WireGuard: waiting for tasks to complete");
    tokio::select! {
        result = recv_handle => {
            error!("WG->TUN recv task ended: {:?}", result);
        }
        result = timer_handle => {
            error!("Timer task ended: {:?}", result);
        }
    }
    Ok(())
}

/// Run TUN device and smoltcp stack in CHILD network namespace
/// This runs after entering the new network namespace
pub async fn run_tun_child(
    _args: &Args,
    tun_to_wg_tx: mpsc::Sender<TunToWgPacket>,
    wg_to_tun_rx: mpsc::Receiver<WgToTunPacket>,
    tun_device: Arc<std::sync::Mutex<tun::platform::Device>>,
) -> Result<()> {
    debug!("TUN child process starting (in network namespace)");

    // Create separate file descriptors for read and write
    // Sharing a single FD between reader/writer causes blocking issues
    let (tun_read_fd, tun_write_fd) = {
        let tun = tun_device.lock().unwrap();
        use std::os::unix::io::AsRawFd;
        let fd = tun.as_raw_fd();

        // Duplicate FD for writer
        let write_fd = unsafe { libc::dup(fd) };
        if write_fd < 0 {
            panic!("failed to duplicate TUN fd for writer");
        }

        // Set non-blocking mode on both
        unsafe {
            let flags = libc::fcntl(fd, libc::F_GETFL);
            libc::fcntl(fd, libc::F_SETFL, flags | libc::O_NONBLOCK);
            let flags = libc::fcntl(write_fd, libc::F_GETFL);
            libc::fcntl(write_fd, libc::F_SETFL, flags | libc::O_NONBLOCK);
        }

        (fd, write_fd)
    };

    // Task: Read from TUN, send to WireGuard (using raw FD)
    tokio::task::spawn_blocking(move || {
        debug!("TUN reader started (blocking)");
        let mut buf = vec![0u8; 2048];
        loop {
            let n = unsafe {
                libc::read(
                    tun_read_fd,
                    buf.as_mut_ptr() as *mut libc::c_void,
                    buf.len(),
                )
            };

            if n > 0 {
                debug!("TUN: read {} bytes", n);
                let packet = buf[..n as usize].to_vec();
                if tun_to_wg_tx.blocking_send(packet).is_err() {
                    error!("TUN: failed to send to channel");
                    break;
                }
            } else if n == 0 {
                debug!("TUN: EOF");
                break;
            } else {
                let err = std::io::Error::last_os_error();
                if err.kind() == std::io::ErrorKind::WouldBlock {
                    std::thread::sleep(std::time::Duration::from_millis(10));
                    continue;
                }
                error!("TUN: read error: {}", err);
                break;
            }
        }
    });

    // Task: Receive from WireGuard, write to TUN (using raw FD)
    let mut wg_to_tun_rx = wg_to_tun_rx;
    tokio::task::spawn_blocking(move || {
        debug!("TUN writer started (blocking)");
        let mut count = 0u32;
        loop {
            match wg_to_tun_rx.blocking_recv() {
                Some(packet) => {
                    count += 1;
                    debug!("TUN: writing {} bytes (packet #{})", packet.len(), count);

                    let written = unsafe {
                        libc::write(
                            tun_write_fd,
                            packet.as_ptr() as *const libc::c_void,
                            packet.len(),
                        )
                    };

                    if written < 0 {
                        let err = std::io::Error::last_os_error();
                        error!("TUN: write error: {}", err);
                        break;
                    } else if written != packet.len() as isize {
                        error!("TUN: partial write: {} of {} bytes", written, packet.len());
                    } else {
                        debug!("TUN: write successful ({} bytes)", written);
                    }
                }
                None => {
                    debug!("TUN writer channel closed");
                    break;
                }
            }
        }
    });

    // Keep running
    tokio::signal::ctrl_c().await?;
    Ok(())
}
