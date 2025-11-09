// WireGuard Server - userspace VPN server using boringtun
// Routes client traffic to the internet with NAT

mod server_args;
mod server_peer;

use anyhow::{Context, Result};
use base64::Engine;
use boringtun::noise::{Tunn, TunnResult};
use clap::Parser;
use server_args::ServerArgs;
use server_peer::Peer;
use std::collections::HashMap;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::UdpSocket;
use tokio::sync::Mutex;
use tracing::{debug, error, info, warn};

const MAX_PACKET: usize = 65536;

pub struct WireGuardServer {
    socket: Arc<UdpSocket>,
    peers: Arc<Mutex<HashMap<[u8; 32], Peer>>>,
    tun_write: Arc<Mutex<tokio::io::WriteHalf<tun::AsyncDevice>>>,
}

impl WireGuardServer {
    pub async fn new(
        args: &ServerArgs,
    ) -> Result<(Self, tokio::io::ReadHalf<tun::AsyncDevice>)> {
        info!("Starting WireGuard server");

        // Load server private key (async to avoid blocking runtime thread)
        let private_key = tokio::fs::read_to_string(&args.private_key_file)
            .await
            .context("failed to read server private key")?
            .trim()
            .to_string();

        let private_key_bytes = base64::engine::general_purpose::STANDARD
            .decode(private_key.trim())
            .context("invalid private key encoding")?;

        if private_key_bytes.len() != 32 {
            anyhow::bail!("private key must be 32 bytes");
        }

        let mut server_priv_key = [0u8; 32];
        server_priv_key.copy_from_slice(&private_key_bytes);

        // Create UDP socket
        let socket = UdpSocket::bind(&args.listen_addr)
            .await
            .context("failed to bind UDP socket")?;

        info!("WireGuard server listening on {}", socket.local_addr()?);

        // Set up peers
        let mut peers = HashMap::new();
        for peer_cfg in &args.peers {
            let pub_key_bytes = base64::engine::general_purpose::STANDARD
                .decode(peer_cfg.public_key.trim())
                .context("invalid peer public key")?;

            if pub_key_bytes.len() != 32 {
                anyhow::bail!("peer public key must be 32 bytes");
            }

            let mut peer_pub_key = [0u8; 32];
            peer_pub_key.copy_from_slice(&pub_key_bytes);

            // Create tunnel for this peer
            let tunnel = Tunn::new(
                server_priv_key.into(),
                peer_pub_key.into(),
                None,
                None,
                0,
                None,
            )
            .map_err(|e| anyhow::anyhow!("failed to create tunnel: {}", e))?;

            let peer = Peer::new(tunnel, peer_cfg.allowed_ips.clone());
            
            info!(
                "Added peer with public key {} (allowed IPs: {:?})",
                peer_cfg.public_key, peer_cfg.allowed_ips
            );
            debug!("Peer allowed_ips stored as: {:?}", peer.allowed_ips);

            peers.insert(peer_pub_key, peer);
        }

        // Create TUN interface
        let tun_device = Self::create_tun(&args.tun_name, &args.subnet, &args.subnet_cidr)?;
        
        // Verify interface is up before splitting
        info!("Verifying TUN interface state...");
        let link_check = std::process::Command::new("ip")
            .args(["link", "show", &args.tun_name])
            .output()
            .context("failed to check interface state")?;
        info!("Interface state: {}", String::from_utf8_lossy(&link_check.stdout).trim());
        
        // Split TUN into read/write halves to avoid lock contention
        let (tun_read, tun_write) = tokio::io::split(tun_device);
        
        // Re-verify route after split
        info!("Re-verifying route after split...");
        let route_check = std::process::Command::new("ip")
            .args(["route", "show", &args.subnet_cidr])
            .output()
            .context("failed to verify route after split")?;
        let routes = String::from_utf8_lossy(&route_check.stdout);
        info!("Route after split: {}", routes.trim());
        if routes.trim().is_empty() {
            error!("Route disappeared after split!");
        }

        let server = Self {
            socket: Arc::new(socket),
            peers: Arc::new(Mutex::new(peers)),
            tun_write: Arc::new(Mutex::new(tun_write)),
        };

        Ok((server, tun_read))
    }

    fn create_tun(name: &str, subnet: &str, subnet_cidr: &str) -> Result<tun::AsyncDevice> {
        info!("Creating TUN interface: {}", name);

        // Parse subnet address (e.g., "10.200.100.1")
        let addr: std::net::Ipv4Addr = subnet.parse().context("invalid subnet address")?;
        let octets = addr.octets();

        let mut config = tun::Configuration::default();
        config
            .name(name)
            .address((octets[0], octets[1], octets[2], octets[3]))
            .netmask((255, 255, 255, 0))
            .up();

        #[cfg(target_os = "linux")]
        config.platform(|config| {
            config.packet_information(false);
        });

        let dev = tun::create_as_async(&config).context("failed to create TUN device")?;

        info!("TUN interface {} created with address {}", name, subnet);

        // Add/replace route for the subnet through this TUN interface
        // Use 'replace' instead of 'add' to handle existing routes
        info!("Adding route for {} via {}", subnet_cidr, name);
        let output = std::process::Command::new("ip")
            .args(["route", "replace", subnet_cidr, "dev", name])
            .output()
            .context("failed to execute 'ip route replace' command")?;
        
        if output.status.success() {
            info!("✓ Route added: {} dev {}", subnet_cidr, name);
            
            // Verify the route was actually added
            let verify = std::process::Command::new("ip")
                .args(["route", "show", subnet_cidr])
                .output()
                .context("failed to verify route")?;
            
            let routes = String::from_utf8_lossy(&verify.stdout);
            info!("Route verification for {}:", subnet_cidr);
            info!("  {}", routes.trim());
            
            if !routes.contains(name) {
                error!("Route was added but is not showing the correct device!");
                error!("  Expected: dev {}", name);
                error!("  Got: {}", routes.trim());
            }
        } else {
            let stderr = String::from_utf8_lossy(&output.stderr);
            let stdout = String::from_utf8_lossy(&output.stdout);
            
            // Log any errors
            error!("Failed to set route: {} dev {}", subnet_cidr, name);
            error!("  Exit code: {:?}", output.status.code());
            error!("  Stderr: {}", stderr.trim());
            error!("  Stdout: {}", stdout.trim());
            anyhow::bail!("Failed to set route for TUN interface");
        }

        Ok(dev)
    }

    pub async fn run(self: Arc<Self>, tun_read: tokio::io::ReadHalf<tun::AsyncDevice>) -> Result<()> {
        info!("WireGuard server running");

        // Spawn TUN read task with read half
        let self_clone = Arc::clone(&self);
        tokio::spawn(async move {
            if let Err(e) = self_clone.run_tun_to_network(tun_read).await {
                error!("TUN->Network task failed: {}", e);
            }
        });

        // Run UDP receive task in main thread
        self.run_network_to_tun().await
    }

    // Read from TUN, encrypt, send to appropriate peer
    async fn run_tun_to_network(
        self: Arc<Self>,
        mut tun_read: tokio::io::ReadHalf<tun::AsyncDevice>,
    ) -> Result<()> {
        use tokio::io::AsyncReadExt;
        let mut buf = vec![0u8; MAX_PACKET];
        let mut encrypted_buf = vec![0u8; MAX_PACKET]; // Reuse buffer

        loop {
            let len = tun_read.read(&mut buf).await?;

            let packet = &buf[..len];

            if packet.is_empty() {
                continue;
            }

            // Determine destination IP from packet
            if packet.len() < 20 {
                debug!("Packet too short to parse");
                continue;
            }

            let version = packet[0] >> 4;
            let dest_ip = if version == 4 && packet.len() >= 20 {
                std::net::IpAddr::V4(std::net::Ipv4Addr::new(
                    packet[16],
                    packet[17],
                    packet[18],
                    packet[19],
                ))
            } else if version == 6 && packet.len() >= 40 {
                // IPv6 destination is at bytes 24-39
                let mut addr = [0u8; 16];
                addr.copy_from_slice(&packet[24..40]);
                std::net::IpAddr::V6(std::net::Ipv6Addr::from(addr))
            } else {
                debug!("Unknown IP version: {}", version);
                continue;
            };

            debug!("TUN packet {} bytes to {}", len, dest_ip);

            // Find peer responsible for this IP (quick lookup without holding lock)
            let peer_info = {
                let peers = self.peers.lock().await;
                let mut result = None;
                for (pub_key, peer) in peers.iter() {
                    debug!("Checking if peer owns IP {}: allowed_ips={:?}", dest_ip, peer.allowed_ips);
                    if peer.owns_ip(&dest_ip) {
                        debug!("Peer {:02x?}... owns {}", &pub_key[..4], dest_ip);
                        result = Some((*pub_key, peer.endpoint));
                        break;
                    }
                }
                result
            };
            
            let (peer_key, endpoint) = match peer_info {
                Some((k, Some(e))) => (k, e),
                _ => {
                    debug!("No peer found for destination IP: {}", dest_ip);
                    continue;
                }
            };

            {
                // Encrypt packet (hold lock only during encryption, not during send)
                let encrypted_len = {
                    let mut peers = self.peers.lock().await;
                    if let Some(peer) = peers.get_mut(&peer_key) {
                        match peer.tunnel.encapsulate(packet, &mut encrypted_buf) {
                            TunnResult::WriteToNetwork(encrypted) => encrypted.len(),
                            TunnResult::Done => {
                                debug!("Encapsulation returned Done");
                                0
                            }
                            TunnResult::Err(e) => {
                                warn!("Encapsulation error: {:?}", e);
                                0
                            }
                            _ => 0,
                        }
                    } else {
                        0
                    }
                };

                // Send without holding lock
                if encrypted_len > 0 {
                    debug!("Sending {} encrypted bytes to {}", encrypted_len, endpoint);
                    if let Err(e) = self.socket.send_to(&encrypted_buf[..encrypted_len], endpoint).await {
                        warn!("Failed to send to {}: {}", endpoint, e);
                    }
                }
            }
        }
    }

    // Receive from UDP, decrypt, write to TUN
    async fn run_network_to_tun(self: Arc<Self>) -> Result<()> {
        let mut buf = vec![0u8; MAX_PACKET];

        loop {
            let (len, addr) = self.socket.recv_from(&mut buf).await?;

            debug!("Received {} bytes from {}", len, addr);

            // Handle packet inline - decapsulation is fast, no need to spawn
            // This avoids task explosion under load
            if let Err(e) = self.handle_packet(&buf[..len], addr).await {
                debug!("Error handling packet from {}: {}", addr, e);
            }
        }
    }

    async fn handle_packet(&self, packet: &[u8], addr: SocketAddr) -> Result<()> {
        let mut dst = vec![0u8; MAX_PACKET];

        // Fast path: try peer with matching endpoint first
        let endpoint_key = {
            let peers = self.peers.lock().await;
            peers.iter()
                .find_map(|(k, p)| if p.endpoint == Some(addr) { Some(*k) } else { None })
        };

        if let Some(key) = endpoint_key {
            let mut peers = self.peers.lock().await;
            if let Some(peer) = peers.get_mut(&key) {
                match peer.tunnel.decapsulate(None, packet, &mut dst) {
                    TunnResult::Done => {
                        debug!("Handshake processed for peer (fast path)");
                        peer.endpoint = Some(addr);
                        return Ok(());
                    }
                    TunnResult::WriteToNetwork(response) => {
                        debug!("Sending handshake response {} bytes (fast path)", response.len());
                        peer.endpoint = Some(addr);
                        drop(peers);
                        self.socket.send_to(response, addr).await?;
                        return Ok(());
                    }
                    TunnResult::WriteToTunnelV4(decrypted, _) | TunnResult::WriteToTunnelV6(decrypted, _) => {
                        debug!("Decrypted {} bytes (fast path)", decrypted.len());
                        peer.endpoint = Some(addr);
                        drop(peers);
                        
                        use tokio::io::AsyncWriteExt;
                        let mut tun = self.tun_write.lock().await;
                        tun.write_all(decrypted).await?;
                        return Ok(());
                    }
                    TunnResult::Err(_) => {
                        // Fall through to full scan
                    }
                }
            }
        }

        // Slow path: try all peers
        // Get peer keys first (short lock), then lock per-peer during crypto
        // This reduces lock contention compared to holding the global lock
        let peer_keys: Vec<[u8; 32]> = {
            let peers = self.peers.lock().await;
            peers.keys().copied().collect()
        };

        for pub_key in peer_keys {
            // Lock only this peer during decapsulation
            let result = {
                let mut peers = self.peers.lock().await;
                if let Some(peer) = peers.get_mut(&pub_key) {
                    let res = peer.tunnel.decapsulate(None, packet, &mut dst);
                    // Update endpoint if successful
                    match &res {
                        TunnResult::Done | TunnResult::WriteToNetwork(_) 
                        | TunnResult::WriteToTunnelV4(_, _) | TunnResult::WriteToTunnelV6(_, _) => {
                            peer.endpoint = Some(addr);
                        }
                        _ => {}
                    }
                    Some(res)
                } else {
                    None
                }
            }; // Lock released here

            // Handle result outside lock
            match result {
                Some(TunnResult::Done) => {
                    debug!("Handshake processed for peer {:02x?}...", &pub_key[..4]);
                    return Ok(());
                }
                Some(TunnResult::WriteToNetwork(response)) => {
                    debug!("Sending handshake response {} bytes to {}", response.len(), addr);
                    self.socket.send_to(response, addr).await?;
                    return Ok(());
                }
                Some(TunnResult::WriteToTunnelV4(decrypted, _)) | Some(TunnResult::WriteToTunnelV6(decrypted, _)) => {
                    debug!("Decrypted {} bytes from peer", decrypted.len());
                    
                    use tokio::io::AsyncWriteExt;
                    let mut tun = self.tun_write.lock().await;
                    tun.write_all(decrypted).await?;
                    return Ok(());
                }
                Some(TunnResult::Err(_)) | None => {
                    // This peer couldn't decrypt it, try next
                    continue;
                }
            }
        }

        debug!("No peer could process packet from {}", addr);
        Ok(())
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| {
                    tracing_subscriber::EnvFilter::new("info")
                        // Suppress noisy boringtun timer warnings
                        .add_directive("boringtun::noise::timers=error".parse().unwrap())
                }),
        )
        .init();

    let args = ServerArgs::parse();

    // Create server
    let (server, tun_read) = WireGuardServer::new(&args).await?;
    let server = Arc::new(server);

    // Set up IP forwarding and NAT (blocking syscalls, run in blocking thread)
    let args_clone = args.clone();
    tokio::task::spawn_blocking(move || setup_ip_forwarding(&args_clone))
        .await
        .context("spawn_blocking failed")??;
    
    let args_clone = args.clone();
    tokio::task::spawn_blocking(move || setup_nat(&args_clone))
        .await
        .context("spawn_blocking failed")??;

    // systemd-networkd often deletes routes on TUN interfaces it doesn't manage
    // Add/re-add the route after NAT setup to ensure it sticks
    info!("Ensuring route is present after NAT setup...");
    let route_output = std::process::Command::new("ip")
        .args(["route", "replace", &args.subnet_cidr, "dev", &args.tun_name])
        .output()
        .context("failed to add route after NAT setup")?;
    
    if !route_output.status.success() {
        let stderr = String::from_utf8_lossy(&route_output.stderr);
        error!("Failed to add route after NAT: {}", stderr);
    }
    
    // Verify it's there
    let route_check = std::process::Command::new("ip")
        .args(["route", "show", &args.subnet_cidr])
        .output()
        .context("failed to verify route after NAT")?;
    let routes = String::from_utf8_lossy(&route_check.stdout);
    if routes.trim().is_empty() {
        error!("Route still missing after re-add attempt!");
        error!("systemd-networkd may be interfering. Consider:");
        error!("  1. Create /etc/systemd/network/99-ignore-wg.network with:");
        error!("     [Match]");
        error!("     Name=wg-*");
        error!("     [Link]");
        error!("     Unmanaged=yes");
        error!("  2. Or disable systemd-networkd: systemctl disable systemd-networkd");
    } else {
        info!("✓ Route confirmed: {}", routes.trim());
    }

    // Set up cleanup handler
    let args_clone = args.clone();
    ctrlc::set_handler(move || {
        info!("Received Ctrl+C, cleaning up...");
        if let Err(e) = cleanup_nat(&args_clone) {
            error!("Failed to cleanup NAT: {}", e);
        }
        std::process::exit(0);
    })
    .context("failed to set Ctrl+C handler")?;

    server.run(tun_read).await
}

fn setup_ip_forwarding(_args: &ServerArgs) -> Result<()> {
    info!("Enabling IP forwarding");
    std::fs::write("/proc/sys/net/ipv4/ip_forward", "1")
        .context("failed to enable IP forwarding - are you running as root?")?;
    Ok(())
}

fn setup_nat(args: &ServerArgs) -> Result<()> {
    info!("Setting up NAT rules");

    // Determine outbound interface
    let outbound_iface = if let Some(ref iface) = args.outbound_interface {
        iface.clone()
    } else {
        // Try to auto-detect default interface
        get_default_interface()?
    };

    info!("Using outbound interface: {}", outbound_iface);

    // Helper to verify route is still present
    let verify_route = || {
        let output = std::process::Command::new("ip")
            .args(["route", "show", &args.subnet_cidr])
            .output()
            .ok()?;
        let routes = String::from_utf8_lossy(&output.stdout);
        if routes.contains(&args.tun_name) {
            Some(())
        } else {
            None
        }
    };

    // Set up iptables rules
    let subnet = &args.subnet_cidr;
    let tun_name = &args.tun_name;

    // MASQUERADE rule for NAT
    info!("Adding MASQUERADE rule...");
    std::process::Command::new("iptables")
        .args([
            "-t", "nat",
            "-A", "POSTROUTING",
            "-s", subnet,
            "-o", &outbound_iface,
            "-j", "MASQUERADE",
        ])
        .output()
        .context("failed to add MASQUERADE rule")?;
    
    if verify_route().is_none() {
        warn!("Route disappeared after MASQUERADE rule!");
    }

    // FORWARD rules
    info!("Adding FORWARD rule (inbound)...");
    std::process::Command::new("iptables")
        .args([
            "-A", "FORWARD",
            "-i", tun_name,
            "-j", "ACCEPT",
        ])
        .output()
        .context("failed to add FORWARD rule (in)")?;
    
    if verify_route().is_none() {
        warn!("Route disappeared after FORWARD (in) rule!");
    }

    info!("Adding FORWARD rule (outbound)...");
    std::process::Command::new("iptables")
        .args([
            "-A", "FORWARD",
            "-o", tun_name,
            "-j", "ACCEPT",
        ])
        .output()
        .context("failed to add FORWARD rule (out)")?;
    
    if verify_route().is_none() {
        warn!("Route disappeared after FORWARD (out) rule!");
    }

    info!("NAT rules configured");
    Ok(())
}

fn cleanup_nat(args: &ServerArgs) -> Result<()> {
    info!("Cleaning up NAT rules");

    let default_iface = get_default_interface().unwrap_or_else(|_| "eth0".to_string());
    let outbound_iface = args.outbound_interface.as_ref()
        .map(|s| s.as_str())
        .unwrap_or(&default_iface);

    let subnet = &args.subnet_cidr;
    let tun_name = &args.tun_name;

    // Remove rules (ignore errors on cleanup)
    let _ = std::process::Command::new("iptables")
        .args([
            "-t", "nat",
            "-D", "POSTROUTING",
            "-s", subnet,
            "-o", outbound_iface,
            "-j", "MASQUERADE",
        ])
        .output();

    let _ = std::process::Command::new("iptables")
        .args(["-D", "FORWARD", "-i", tun_name, "-j", "ACCEPT"])
        .output();

    let _ = std::process::Command::new("iptables")
        .args(["-D", "FORWARD", "-o", tun_name, "-j", "ACCEPT"])
        .output();

    Ok(())
}

fn get_default_interface() -> Result<String> {
    // Parse ip route to get default interface
    // Note: This function may be called from spawn_blocking context
    let output = std::process::Command::new("ip")
        .args(["route", "show", "default"])
        .output()
        .context("failed to run 'ip route'")?;

    let stdout = String::from_utf8_lossy(&output.stdout);
    
    // Parse line like: "default via 192.168.1.1 dev eth0 proto dhcp metric 100"
    if let Some(iface) = stdout.split_whitespace()
        .skip_while(|&w| w != "dev")
        .nth(1) {
        return Ok(iface.to_string());
    }

    anyhow::bail!("could not determine default interface")
}
