//! Userspace NAT dataplane
//!
//! This module implements transparent L4 proxy NAT:
//! - Parses TCP/UDP from decrypted WireGuard packets
//! - Creates real outbound tokio sockets to destinations
//! - Tracks connection state and relays data back

use std::collections::{HashMap, VecDeque};
use std::net::{Ipv4Addr, SocketAddr, SocketAddrV4};
use std::sync::Arc;
use std::time::{Duration, Instant};

use anyhow::Result;
use smoltcp::iface::{Config as SmolConfig, Interface, SocketHandle, SocketSet};
use smoltcp::phy::{Device, DeviceCapabilities, Medium, RxToken, TxToken};
use smoltcp::socket::tcp;
use smoltcp::time::Instant as SmolInstant;
use smoltcp::wire::{
    HardwareAddress, IpAddress, IpCidr, IpProtocol, Ipv4Address, Ipv4Cidr, Ipv4Packet, TcpPacket,
    UdpPacket,
};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream, UdpSocket as TokioUdpSocket};
use tokio::sync::mpsc;
use tracing::{debug, error, info, trace, warn};

use super::api::PortForwardEvent;
use super::flow::{FlowConfig, FlowKey, PortForwardRule, Protocol};
use super::wg::{WgIo, WgToDataplane};

const SMOLTCP_MTU: usize = 1420;
const SMOLTCP_SOCKET_BUFFER: usize = 256 * 1024;
const WAN_READ_BUFFER: usize = 16 * 1024;
/// Message from WAN socket back to dataplane
#[derive(Debug)]
enum WanToDataplane {
    // Outbound NAT: data from internet to send to client
    TcpData {
        flow_key: FlowKey,
        data: Vec<u8>,
    },
    TcpClosed {
        flow_key: FlowKey,
    },
    UdpData {
        flow_key: FlowKey,
        data: Vec<u8>,
    },
    // Inbound port forward: data from internet client to send to VPN client
    InboundTcpData {
        flow_key: InboundFlowKey,
        data: Vec<u8>,
    },
    InboundTcpClosed {
        flow_key: InboundFlowKey,
    },
}

/// Message for inbound connections (port forwarding)
#[derive(Debug)]
enum InboundEvent {
    TcpConnection {
        rule: PortForwardRule,
        stream: TcpStream,
        remote_addr: SocketAddr,
    },
    UdpPacket {
        rule: PortForwardRule,
        data: Vec<u8>,
        remote_addr: SocketAddr,
    },
}

/// Key for inbound flows (from internet to client)
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct InboundFlowKey {
    protocol: Protocol,
    remote_ip: Ipv4Addr,
    remote_port: u16,
    public_port: u16,
}

/// Inbound TCP flow (internet -> client)
struct InboundTcpFlow {
    socket: SocketHandle,
    wan_tx: mpsc::Sender<Vec<u8>>,
    pending_to_client: VecDeque<Vec<u8>>,
    last_activity: Instant,
    wan_closed: bool,
}

type SmolTcpFlow = InboundTcpFlow;

/// Active UDP flow state
struct UdpFlow {
    peer_pubkey: [u8; 32],
    client_ip: Ipv4Addr,
    client_port: u16,
    remote_ip: Ipv4Addr,
    remote_port: u16,
    wan_tx: mpsc::Sender<Vec<u8>>,
    last_activity: Instant,
}

struct SmolDevice {
    rx: VecDeque<Vec<u8>>,
    tx: VecDeque<Vec<u8>>,
}

impl SmolDevice {
    fn new() -> Self {
        Self {
            rx: VecDeque::new(),
            tx: VecDeque::new(),
        }
    }

    fn push_rx(&mut self, packet: Vec<u8>) {
        self.rx.push_back(packet);
    }

    fn drain_tx(&mut self) -> Vec<Vec<u8>> {
        self.tx.drain(..).collect()
    }
}

struct SmolRxToken {
    buffer: Vec<u8>,
}

impl RxToken for SmolRxToken {
    fn consume<R, F>(mut self, f: F) -> R
    where
        F: FnOnce(&mut [u8]) -> R,
    {
        f(&mut self.buffer)
    }
}

struct SmolTxToken<'a> {
    tx: &'a mut VecDeque<Vec<u8>>,
}

impl<'a> TxToken for SmolTxToken<'a> {
    fn consume<R, F>(self, len: usize, f: F) -> R
    where
        F: FnOnce(&mut [u8]) -> R,
    {
        let mut buffer = vec![0u8; len];
        let result = f(&mut buffer);
        self.tx.push_back(buffer);
        result
    }
}

impl Device for SmolDevice {
    type RxToken<'a>
        = SmolRxToken
    where
        Self: 'a;
    type TxToken<'a>
        = SmolTxToken<'a>
    where
        Self: 'a;

    fn receive(
        &mut self,
        _timestamp: SmolInstant,
    ) -> Option<(Self::RxToken<'_>, Self::TxToken<'_>)> {
        self.rx
            .pop_front()
            .map(|buffer| (SmolRxToken { buffer }, SmolTxToken { tx: &mut self.tx }))
    }

    fn transmit(&mut self, _timestamp: SmolInstant) -> Option<Self::TxToken<'_>> {
        Some(SmolTxToken { tx: &mut self.tx })
    }

    fn capabilities(&self) -> DeviceCapabilities {
        let mut caps = DeviceCapabilities::default();
        caps.medium = Medium::Ip;
        caps.max_transmission_unit = SMOLTCP_MTU;
        caps.max_burst_size = Some(64);
        caps
    }
}

/// The NAT dataplane
pub struct Dataplane {
    wg_io: Arc<WgIo>,
    tcp_flows: HashMap<FlowKey, SmolTcpFlow>,
    tcp_listen_sockets: HashMap<u16, Vec<SocketHandle>>,
    smol_iface: Interface,
    smol_sockets: SocketSet<'static>,
    smol_device: SmolDevice,
    smol_start: Instant,
    peer_by_ip: HashMap<Ipv4Addr, [u8; 32]>,
    udp_flows: HashMap<FlowKey, UdpFlow>,
    inbound_tcp_flows: HashMap<InboundFlowKey, InboundTcpFlow>,
    config: FlowConfig,
    wan_rx: mpsc::Receiver<WanToDataplane>,
    wan_tx_template: mpsc::Sender<WanToDataplane>,
    inbound_rx: mpsc::Receiver<InboundEvent>,
    inbound_tx: mpsc::Sender<InboundEvent>,
    // Track active listeners so we can stop them
    tcp_listeners: HashMap<u16, tokio::task::JoinHandle<()>>,
    udp_listeners: HashMap<u16, tokio::task::JoinHandle<()>>,
}

impl Dataplane {
    pub fn new(wg_io: Arc<WgIo>, server_ip: Ipv4Addr) -> Self {
        let (wan_tx, wan_rx) = mpsc::channel(10000);
        let (inbound_tx, inbound_rx) = mpsc::channel(1000);
        let mut smol_device = SmolDevice::new();
        let mut smol_config = SmolConfig::new(HardwareAddress::Ip);
        smol_config.random_seed = rand::random();
        let smol_start = Instant::now();
        let mut smol_iface =
            Interface::new(smol_config, &mut smol_device, SmolInstant::from_millis(0));
        let smol_server_ip = Ipv4Address::from_bytes(&server_ip.octets());
        smol_iface.update_ip_addrs(|addrs| {
            addrs
                .push(IpCidr::Ipv4(Ipv4Cidr::new(smol_server_ip, 32)))
                .expect("smoltcp interface address table full");
        });
        smol_iface
            .routes_mut()
            .add_default_ipv4_route(smol_server_ip)
            .expect("smoltcp route table full");
        smol_iface.set_any_ip(true);

        Self {
            wg_io,
            tcp_flows: HashMap::new(),
            tcp_listen_sockets: HashMap::new(),
            smol_iface,
            smol_sockets: SocketSet::new(Vec::new()),
            smol_device,
            smol_start,
            peer_by_ip: HashMap::new(),
            udp_flows: HashMap::new(),
            inbound_tcp_flows: HashMap::new(),
            config: FlowConfig::default(),
            wan_rx,
            wan_tx_template: wan_tx,
            inbound_rx,
            inbound_tx,
            tcp_listeners: HashMap::new(),
            udp_listeners: HashMap::new(),
        }
    }

    /// Run the dataplane - main event loop
    pub async fn run(
        mut self,
        mut from_wg: mpsc::Receiver<WgToDataplane>,
        mut port_forward_rx: mpsc::Receiver<PortForwardEvent>,
    ) -> Result<()> {
        info!("Dataplane starting");

        let mut cleanup_interval = tokio::time::interval(Duration::from_secs(10));
        let mut tcp_timer = tokio::time::interval(Duration::from_millis(50));

        loop {
            tokio::select! {
                // Receive decrypted packets from WireGuard
                Some(msg) = from_wg.recv() => {
                    self.handle_wg_packet(msg).await;
                }

                // Receive data from WAN sockets (outbound NAT responses)
                Some(wan_msg) = self.wan_rx.recv() => {
                    self.handle_wan_message(wan_msg).await;
                }

                // Receive inbound connections (port forwarding)
                Some(inbound) = self.inbound_rx.recv() => {
                    self.handle_inbound_event(inbound).await;
                }

                // Receive port forward configuration changes
                Some(event) = port_forward_rx.recv() => {
                    self.handle_port_forward_event(event).await;
                }

                // Periodic cleanup
                _ = cleanup_interval.tick() => {
                    self.cleanup_expired_flows();
                }

                _ = tcp_timer.tick() => {
                    self.poll_smol_tcp().await;
                }
            }
        }
    }

    /// Handle port forward configuration events from API
    async fn handle_port_forward_event(&mut self, event: PortForwardEvent) {
        match event {
            PortForwardEvent::Added(rule) => {
                self.start_port_forward_listener(rule).await;
            }
            PortForwardEvent::Removed { protocol, port } => {
                self.stop_port_forward_listener(protocol, port);
            }
        }
    }

    /// Start a listener for a port forward rule
    async fn start_port_forward_listener(&mut self, rule: PortForwardRule) {
        let port = rule.public_port;
        let protocol = rule.protocol;
        let inbound_tx = self.inbound_tx.clone();

        match protocol {
            Protocol::Tcp => {
                let handle = tokio::spawn(async move {
                    Self::run_tcp_listener(port, rule, inbound_tx).await;
                });
                self.tcp_listeners.insert(port, handle);
                info!("Started TCP listener on port {}", port);
            }
            Protocol::Udp => {
                let handle = tokio::spawn(async move {
                    Self::run_udp_listener(port, rule, inbound_tx).await;
                });
                self.udp_listeners.insert(port, handle);
                info!("Started UDP listener on port {}", port);
            }
        }
    }

    /// Stop a port forward listener
    fn stop_port_forward_listener(&mut self, protocol: Protocol, port: u16) {
        match protocol {
            Protocol::Tcp => {
                if let Some(handle) = self.tcp_listeners.remove(&port) {
                    handle.abort();
                    info!("Stopped TCP listener on port {}", port);
                }
            }
            Protocol::Udp => {
                if let Some(handle) = self.udp_listeners.remove(&port) {
                    handle.abort();
                    info!("Stopped UDP listener on port {}", port);
                }
            }
        }
    }

    /// Run TCP listener for port forwarding
    async fn run_tcp_listener(
        port: u16,
        rule: PortForwardRule,
        inbound_tx: mpsc::Sender<InboundEvent>,
    ) {
        let addr = format!("0.0.0.0:{}", port);
        let listener = match TcpListener::bind(&addr).await {
            Ok(l) => l,
            Err(e) => {
                error!("Failed to bind TCP listener on port {}: {}", port, e);
                return;
            }
        };

        info!("TCP port forward listening on {}", addr);

        loop {
            match listener.accept().await {
                Ok((stream, remote_addr)) => {
                    info!(
                        "Inbound TCP connection from {} on port {}",
                        remote_addr, port
                    );
                    if inbound_tx
                        .send(InboundEvent::TcpConnection {
                            rule: rule.clone(),
                            stream,
                            remote_addr,
                        })
                        .await
                        .is_err()
                    {
                        break;
                    }
                }
                Err(e) => {
                    error!("TCP accept error on port {}: {}", port, e);
                }
            }
        }
    }

    /// Run UDP listener for port forwarding
    async fn run_udp_listener(
        port: u16,
        rule: PortForwardRule,
        inbound_tx: mpsc::Sender<InboundEvent>,
    ) {
        let addr = format!("0.0.0.0:{}", port);
        let socket = match TokioUdpSocket::bind(&addr).await {
            Ok(s) => s,
            Err(e) => {
                error!("Failed to bind UDP listener on port {}: {}", port, e);
                return;
            }
        };

        info!("UDP port forward listening on {}", addr);

        let mut buf = vec![0u8; 65535];
        loop {
            match socket.recv_from(&mut buf).await {
                Ok((n, remote_addr)) => {
                    trace!(
                        "Inbound UDP packet from {} on port {} ({} bytes)",
                        remote_addr,
                        port,
                        n
                    );
                    if inbound_tx
                        .send(InboundEvent::UdpPacket {
                            rule: rule.clone(),
                            data: buf[..n].to_vec(),
                            remote_addr,
                        })
                        .await
                        .is_err()
                    {
                        break;
                    }
                }
                Err(e) => {
                    error!("UDP recv error on port {}: {}", port, e);
                }
            }
        }
    }

    /// Handle inbound connection/packet from port forward listener
    async fn handle_inbound_event(&mut self, event: InboundEvent) {
        match event {
            InboundEvent::TcpConnection {
                rule,
                stream,
                remote_addr,
            } => {
                self.handle_inbound_tcp(rule, stream, remote_addr).await;
            }
            InboundEvent::UdpPacket {
                rule,
                data,
                remote_addr,
            } => {
                self.handle_inbound_udp(rule, data, remote_addr).await;
            }
        }
    }

    /// Handle inbound TCP connection - create flow to VPN client
    async fn handle_inbound_tcp(
        &mut self,
        rule: PortForwardRule,
        stream: TcpStream,
        remote_addr: SocketAddr,
    ) {
        let remote_ip = match remote_addr {
            SocketAddr::V4(v4) => *v4.ip(),
            SocketAddr::V6(_) => {
                debug!("IPv6 not supported for port forwarding");
                return;
            }
        };
        let remote_port = remote_addr.port();

        let flow_key = InboundFlowKey {
            protocol: Protocol::Tcp,
            remote_ip,
            remote_port,
            public_port: rule.public_port,
        };
        self.peer_by_ip.insert(rule.peer_ip, rule.peer_pubkey);

        let (wan_tx, mut wan_rx) = mpsc::channel::<Vec<u8>>(100);

        let rx_buffer = tcp::SocketBuffer::new(vec![0; SMOLTCP_SOCKET_BUFFER]);
        let tx_buffer = tcp::SocketBuffer::new(vec![0; SMOLTCP_SOCKET_BUFFER]);
        let mut socket = tcp::Socket::new(rx_buffer, tx_buffer);
        let remote_endpoint = SocketAddrV4::new(rule.peer_ip, rule.target_port);
        let local_endpoint = SocketAddrV4::new(remote_ip, remote_port);

        if let Err(e) = socket.connect(self.smol_iface.context(), remote_endpoint, local_endpoint) {
            warn!(
                "Failed to open smoltcp inbound TCP flow {}:{} -> {}:{}: {:?}",
                remote_ip, remote_port, rule.peer_ip, rule.target_port, e
            );
            return;
        }

        let socket = self.smol_sockets.add(socket);
        let flow = InboundTcpFlow {
            socket,
            wan_tx,
            pending_to_client: VecDeque::new(),
            last_activity: Instant::now(),
            wan_closed: false,
        };

        self.inbound_tcp_flows.insert(flow_key, flow);
        self.poll_smol_tcp().await;

        // Split the TCP stream for bidirectional relay
        let (mut read_half, mut write_half) = stream.into_split();

        // Channel for VPN client -> internet client data
        let wan_tx_back = self.wan_tx_template.clone();
        let flow_key_for_reader = flow_key;

        // Reader task: forward data from internet client to dataplane
        // (dataplane will then send to VPN client as TCP packets)
        tokio::spawn(async move {
            let mut buf = vec![0u8; WAN_READ_BUFFER];
            loop {
                match read_half.read(&mut buf).await {
                    Ok(0) => {
                        // Connection closed
                        let _ = wan_tx_back
                            .send(WanToDataplane::InboundTcpClosed {
                                flow_key: flow_key_for_reader,
                            })
                            .await;
                        break;
                    }
                    Ok(n) => {
                        // Forward data to dataplane
                        if wan_tx_back
                            .send(WanToDataplane::InboundTcpData {
                                flow_key: flow_key_for_reader,
                                data: buf[..n].to_vec(),
                            })
                            .await
                            .is_err()
                        {
                            break;
                        }
                    }
                    Err(e) => {
                        debug!("Inbound TCP read error: {}", e);
                        let _ = wan_tx_back
                            .send(WanToDataplane::InboundTcpClosed {
                                flow_key: flow_key_for_reader,
                            })
                            .await;
                        break;
                    }
                }
            }
        });

        // Writer task: forward data from VPN client to internet client
        tokio::spawn(async move {
            while let Some(data) = wan_rx.recv().await {
                if let Err(e) = write_half.write_all(&data).await {
                    debug!("Inbound TCP write error: {}", e);
                    break;
                }
            }
        });

        info!(
            "Created inbound TCP flow: {}:{} -> {}:{}",
            remote_ip, remote_port, rule.peer_ip, rule.target_port
        );
    }

    /// Handle inbound UDP packet
    async fn handle_inbound_udp(
        &mut self,
        rule: PortForwardRule,
        data: Vec<u8>,
        remote_addr: SocketAddr,
    ) {
        let remote_ip = match remote_addr {
            SocketAddr::V4(v4) => *v4.ip(),
            SocketAddr::V6(_) => return,
        };

        // Forward UDP packet to VPN client
        let packet = build_udp_packet(
            remote_ip,
            rule.peer_ip,
            remote_addr.port(),
            rule.target_port,
            &data,
        );

        self.send_to_client(&rule.peer_pubkey, &packet).await;

        trace!(
            "Forwarded inbound UDP: {}:{} -> {}:{} ({} bytes)",
            remote_ip,
            remote_addr.port(),
            rule.peer_ip,
            rule.target_port,
            data.len()
        );
    }

    async fn handle_wg_packet(&mut self, msg: WgToDataplane) {
        let packet = &msg.ip_packet;

        if packet.len() < 20 {
            return;
        }

        let Ok(ipv4) = Ipv4Packet::new_checked(packet) else {
            return;
        };

        let src_ip = Ipv4Addr::from(ipv4.src_addr());
        let dst_ip = Ipv4Addr::from(ipv4.dst_addr());
        self.peer_by_ip.insert(src_ip, msg.peer_pubkey);

        match ipv4.next_header() {
            IpProtocol::Tcp => {
                self.handle_tcp_packet(&msg.peer_pubkey, src_ip, dst_ip, packet, ipv4.payload())
                    .await;
            }
            IpProtocol::Udp => {
                self.handle_udp_packet(&msg.peer_pubkey, src_ip, dst_ip, ipv4.payload())
                    .await;
            }
            proto => {
                trace!("Ignoring protocol {:?}", proto);
            }
        }
    }

    async fn handle_tcp_packet(
        &mut self,
        peer_pubkey: &[u8; 32],
        src_ip: Ipv4Addr,
        dst_ip: Ipv4Addr,
        ip_packet: &[u8],
        tcp_data: &[u8],
    ) {
        let Ok(tcp) = TcpPacket::new_checked(tcp_data) else {
            return;
        };

        let src_port = tcp.src_port();
        let dst_port = tcp.dst_port();
        trace!(
            "TCP {}:{} -> {}:{} flags: SYN={} ACK={} FIN={} RST={}",
            src_ip,
            src_port,
            dst_ip,
            dst_port,
            tcp.syn(),
            tcp.ack(),
            tcp.fin(),
            tcp.rst()
        );

        self.handle_outbound_tcp_packet(
            *peer_pubkey,
            src_ip,
            src_port,
            dst_ip,
            dst_port,
            !self.is_inbound_smol_packet(dst_ip, dst_port),
            ip_packet,
        )
        .await;
    }

    fn is_inbound_smol_packet(&self, dst_ip: Ipv4Addr, dst_port: u16) -> bool {
        self.inbound_tcp_flows
            .keys()
            .any(|key| key.remote_ip == dst_ip && key.remote_port == dst_port)
    }

    async fn handle_outbound_tcp_packet(
        &mut self,
        peer_pubkey: [u8; 32],
        src_ip: Ipv4Addr,
        src_port: u16,
        dst_ip: Ipv4Addr,
        dst_port: u16,
        ensure_listener: bool,
        ip_packet: &[u8],
    ) {
        self.peer_by_ip.insert(src_ip, peer_pubkey);
        let flow_key = FlowKey {
            protocol: Protocol::Tcp,
            client_ip: src_ip,
            client_port: src_port,
            remote_ip: dst_ip,
            remote_port: dst_port,
        };
        if !self.tcp_flows.contains_key(&flow_key)
            && self.tcp_flows.len() >= self.config.max_tcp_flows
        {
            warn!("Max TCP flows reached, dropping TCP packet");
            return;
        }

        if ensure_listener {
            self.ensure_smol_listener(dst_port);
        }
        self.smol_device.push_rx(ip_packet.to_vec());
        self.poll_smol_tcp().await;
    }

    fn ensure_smol_listener(&mut self, port: u16) {
        let has_listener = self.tcp_listen_sockets.get(&port).map_or(false, |handles| {
            handles.iter().any(|handle| {
                let socket = self.smol_sockets.get::<tcp::Socket>(*handle);
                socket.is_listening()
            })
        });

        if has_listener {
            return;
        }

        let rx_buffer = tcp::SocketBuffer::new(vec![0; SMOLTCP_SOCKET_BUFFER]);
        let tx_buffer = tcp::SocketBuffer::new(vec![0; SMOLTCP_SOCKET_BUFFER]);
        let mut socket = tcp::Socket::new(rx_buffer, tx_buffer);
        if let Err(e) = socket.listen(port) {
            warn!(
                "Failed to listen with smoltcp on TCP port {}: {:?}",
                port, e
            );
            return;
        }

        let handle = self.smol_sockets.add(socket);
        self.tcp_listen_sockets
            .entry(port)
            .or_default()
            .push(handle);
        trace!("Added smoltcp TCP listener on port {}", port);
    }

    async fn poll_smol_tcp(&mut self) {
        let now = self.smol_now();
        self.smol_iface
            .poll(now, &mut self.smol_device, &mut self.smol_sockets);
        self.promote_smol_tcp_accepts().await;
        self.drain_smol_tcp_to_wan();
        self.drain_inbound_smol_tcp_to_wan();
        self.flush_pending_wan_to_smol();
        self.flush_pending_inbound_wan_to_smol();
        self.smol_iface
            .poll(now, &mut self.smol_device, &mut self.smol_sockets);
        self.drain_smol_tx().await;
        self.cleanup_closed_smol_tcp();
        self.cleanup_closed_inbound_smol_tcp();
    }

    fn smol_now(&self) -> SmolInstant {
        SmolInstant::from_millis(self.smol_start.elapsed().as_millis() as i64)
    }

    async fn promote_smol_tcp_accepts(&mut self) {
        let mut accepted = Vec::new();
        let ports: Vec<u16> = self.tcp_listen_sockets.keys().copied().collect();

        for port in ports {
            let Some(handles) = self.tcp_listen_sockets.get_mut(&port) else {
                continue;
            };

            let mut remaining = Vec::with_capacity(handles.len());
            for handle in handles.drain(..) {
                let socket = self.smol_sockets.get_mut::<tcp::Socket>(handle);
                if socket.is_active() && !socket.is_listening() {
                    let Some(local) = socket.local_endpoint() else {
                        remaining.push(handle);
                        continue;
                    };
                    let Some(remote) = socket.remote_endpoint() else {
                        remaining.push(handle);
                        continue;
                    };

                    let IpAddress::Ipv4(client_addr) = remote.addr else {
                        socket.abort();
                        remaining.push(handle);
                        continue;
                    };
                    let IpAddress::Ipv4(dest_addr) = local.addr else {
                        socket.abort();
                        remaining.push(handle);
                        continue;
                    };

                    accepted.push((
                        port,
                        handle,
                        Ipv4Addr::from(client_addr),
                        remote.port,
                        Ipv4Addr::from(dest_addr),
                        local.port,
                    ));
                } else {
                    remaining.push(handle);
                }
            }

            *handles = remaining;
        }

        for (port, handle, client_ip, client_port, remote_ip, remote_port) in accepted {
            let flow_key = FlowKey {
                protocol: Protocol::Tcp,
                client_ip,
                client_port,
                remote_ip,
                remote_port,
            };

            if self.tcp_flows.contains_key(&flow_key) {
                self.smol_sockets.get_mut::<tcp::Socket>(handle).abort();
                continue;
            }

            if !self.peer_by_ip.contains_key(&client_ip) {
                warn!("Accepted TCP flow from unknown peer IP {}", client_ip);
                self.smol_sockets.get_mut::<tcp::Socket>(handle).abort();
                continue;
            }

            let (wan_tx, wan_rx) = mpsc::channel::<Vec<u8>>(100);
            self.tcp_flows.insert(
                flow_key,
                SmolTcpFlow {
                    socket: handle,
                    wan_tx,
                    pending_to_client: VecDeque::new(),
                    last_activity: Instant::now(),
                    wan_closed: false,
                },
            );

            info!(
                "Accepted smoltcp TCP flow {}:{} -> {}:{}",
                client_ip, client_port, remote_ip, remote_port
            );

            let remote_addr = SocketAddrV4::new(remote_ip, remote_port);
            let wan_tx_back = self.wan_tx_template.clone();
            tokio::spawn(async move {
                Self::run_tcp_wan_task(flow_key, remote_addr, wan_rx, wan_tx_back).await;
            });

            self.ensure_smol_listener(port);
        }
    }

    fn drain_smol_tcp_to_wan(&mut self) {
        let mut buf = vec![0u8; WAN_READ_BUFFER];
        let flow_keys: Vec<FlowKey> = self.tcp_flows.keys().copied().collect();

        for flow_key in flow_keys {
            let Some(flow) = self.tcp_flows.get_mut(&flow_key) else {
                continue;
            };
            let socket = self.smol_sockets.get_mut::<tcp::Socket>(flow.socket);

            while socket.can_recv() {
                let Ok(permit) = flow.wan_tx.try_reserve() else {
                    trace!("WAN TCP channel full for {:?}", flow_key);
                    break;
                };

                match socket.recv_slice(&mut buf) {
                    Ok(0) => break,
                    Ok(n) => {
                        flow.last_activity = Instant::now();
                        permit.send(buf[..n].to_vec());
                    }
                    Err(e) => {
                        debug!("smoltcp TCP recv error for {:?}: {:?}", flow_key, e);
                        break;
                    }
                }
            }
        }
    }

    fn drain_inbound_smol_tcp_to_wan(&mut self) {
        let mut buf = vec![0u8; WAN_READ_BUFFER];
        let flow_keys: Vec<InboundFlowKey> = self.inbound_tcp_flows.keys().copied().collect();

        for flow_key in flow_keys {
            let Some(flow) = self.inbound_tcp_flows.get_mut(&flow_key) else {
                continue;
            };
            let socket = self.smol_sockets.get_mut::<tcp::Socket>(flow.socket);

            while socket.can_recv() {
                let Ok(permit) = flow.wan_tx.try_reserve() else {
                    trace!("Inbound WAN TCP channel full for {:?}", flow_key);
                    break;
                };

                match socket.recv_slice(&mut buf) {
                    Ok(0) => break,
                    Ok(n) => {
                        flow.last_activity = Instant::now();
                        permit.send(buf[..n].to_vec());
                    }
                    Err(e) => {
                        debug!("inbound smoltcp TCP recv error for {:?}: {:?}", flow_key, e);
                        break;
                    }
                }
            }
        }
    }

    fn flush_pending_wan_to_smol(&mut self) {
        let flow_keys: Vec<FlowKey> = self.tcp_flows.keys().copied().collect();

        for flow_key in flow_keys {
            let Some(flow) = self.tcp_flows.get_mut(&flow_key) else {
                continue;
            };
            let socket = self.smol_sockets.get_mut::<tcp::Socket>(flow.socket);

            while socket.can_send() {
                let Some(mut data) = flow.pending_to_client.pop_front() else {
                    break;
                };
                match socket.send_slice(&data) {
                    Ok(0) => {
                        flow.pending_to_client.push_front(data);
                        break;
                    }
                    Ok(n) if n == data.len() => {
                        flow.last_activity = Instant::now();
                    }
                    Ok(n) => {
                        data.drain(..n);
                        flow.pending_to_client.push_front(data);
                        flow.last_activity = Instant::now();
                        break;
                    }
                    Err(e) => {
                        debug!("smoltcp TCP send error for {:?}: {:?}", flow_key, e);
                        flow.pending_to_client.push_front(data);
                        break;
                    }
                }
            }

            if flow.wan_closed && flow.pending_to_client.is_empty() {
                socket.close();
            }
        }
    }

    fn flush_pending_inbound_wan_to_smol(&mut self) {
        let flow_keys: Vec<InboundFlowKey> = self.inbound_tcp_flows.keys().copied().collect();

        for flow_key in flow_keys {
            let Some(flow) = self.inbound_tcp_flows.get_mut(&flow_key) else {
                continue;
            };
            let socket = self.smol_sockets.get_mut::<tcp::Socket>(flow.socket);

            while socket.can_send() {
                let Some(mut data) = flow.pending_to_client.pop_front() else {
                    break;
                };
                match socket.send_slice(&data) {
                    Ok(0) => {
                        flow.pending_to_client.push_front(data);
                        break;
                    }
                    Ok(n) if n == data.len() => {
                        flow.last_activity = Instant::now();
                    }
                    Ok(n) => {
                        data.drain(..n);
                        flow.pending_to_client.push_front(data);
                        flow.last_activity = Instant::now();
                        break;
                    }
                    Err(e) => {
                        debug!("inbound smoltcp TCP send error for {:?}: {:?}", flow_key, e);
                        flow.pending_to_client.push_front(data);
                        break;
                    }
                }
            }

            if flow.wan_closed && flow.pending_to_client.is_empty() {
                socket.close();
            }
        }
    }

    async fn drain_smol_tx(&mut self) {
        let packets = self.smol_device.drain_tx();
        for packet in packets {
            let Some(peer_pubkey) = self.peer_for_packet(&packet) else {
                debug!("Dropping smoltcp packet without known peer");
                continue;
            };
            self.send_to_client(&peer_pubkey, &packet).await;
        }
    }

    fn peer_for_packet(&self, packet: &[u8]) -> Option<[u8; 32]> {
        let ipv4 = Ipv4Packet::new_checked(packet).ok()?;
        let dst_ip = Ipv4Addr::from(ipv4.dst_addr());
        self.peer_by_ip.get(&dst_ip).copied()
    }

    fn cleanup_closed_smol_tcp(&mut self) {
        let closed: Vec<FlowKey> = self
            .tcp_flows
            .iter()
            .filter_map(|(flow_key, flow)| {
                let socket = self.smol_sockets.get::<tcp::Socket>(flow.socket);
                if !socket.is_open() {
                    Some(*flow_key)
                } else {
                    None
                }
            })
            .collect();

        for flow_key in closed {
            if let Some(flow) = self.tcp_flows.remove(&flow_key) {
                self.smol_sockets.remove(flow.socket);
            }
        }
    }

    fn cleanup_closed_inbound_smol_tcp(&mut self) {
        let closed: Vec<InboundFlowKey> = self
            .inbound_tcp_flows
            .iter()
            .filter_map(|(flow_key, flow)| {
                let socket = self.smol_sockets.get::<tcp::Socket>(flow.socket);
                if !socket.is_open() {
                    Some(*flow_key)
                } else {
                    None
                }
            })
            .collect();

        for flow_key in closed {
            if let Some(flow) = self.inbound_tcp_flows.remove(&flow_key) {
                self.smol_sockets.remove(flow.socket);
            }
        }
    }

    async fn run_tcp_wan_task(
        flow_key: FlowKey,
        remote_addr: SocketAddrV4,
        mut from_client: mpsc::Receiver<Vec<u8>>,
        to_dataplane: mpsc::Sender<WanToDataplane>,
    ) {
        // Connect to remote
        let stream =
            match tokio::time::timeout(Duration::from_secs(10), TcpStream::connect(remote_addr))
                .await
            {
                Ok(Ok(s)) => s,
                Ok(Err(e)) => {
                    debug!("TCP connect failed: {}", e);
                    let _ = to_dataplane
                        .send(WanToDataplane::TcpClosed { flow_key })
                        .await;
                    return;
                }
                Err(_) => {
                    debug!("TCP connect timeout");
                    let _ = to_dataplane
                        .send(WanToDataplane::TcpClosed { flow_key })
                        .await;
                    return;
                }
            };

        info!("TCP connected to {}", remote_addr);

        let (mut read_half, mut write_half) = stream.into_split();

        // Spawn reader task
        let to_dataplane_clone = to_dataplane.clone();
        let flow_key_clone = flow_key;
        tokio::spawn(async move {
            let mut buf = vec![0u8; WAN_READ_BUFFER];
            loop {
                match read_half.read(&mut buf).await {
                    Ok(0) => {
                        let _ = to_dataplane_clone
                            .send(WanToDataplane::TcpClosed {
                                flow_key: flow_key_clone,
                            })
                            .await;
                        break;
                    }
                    Ok(n) => {
                        let _ = to_dataplane_clone
                            .send(WanToDataplane::TcpData {
                                flow_key: flow_key_clone,
                                data: buf[..n].to_vec(),
                            })
                            .await;
                    }
                    Err(e) => {
                        debug!("TCP read error: {}", e);
                        let _ = to_dataplane_clone
                            .send(WanToDataplane::TcpClosed {
                                flow_key: flow_key_clone,
                            })
                            .await;
                        break;
                    }
                }
            }
        });

        // Writer loop - forward data from client to WAN
        while let Some(data) = from_client.recv().await {
            if let Err(e) = write_half.write_all(&data).await {
                debug!("TCP write error: {}", e);
                break;
            }
        }
    }

    async fn handle_udp_packet(
        &mut self,
        peer_pubkey: &[u8; 32],
        src_ip: Ipv4Addr,
        dst_ip: Ipv4Addr,
        udp_data: &[u8],
    ) {
        let Ok(udp) = UdpPacket::new_checked(udp_data) else {
            return;
        };

        let src_port = udp.src_port();
        let dst_port = udp.dst_port();
        let payload = udp.payload();

        let flow_key = FlowKey {
            protocol: Protocol::Udp,
            client_ip: src_ip,
            client_port: src_port,
            remote_ip: dst_ip,
            remote_port: dst_port,
        };

        trace!(
            "UDP {}:{} -> {}:{} ({} bytes)",
            src_ip,
            src_port,
            dst_ip,
            dst_port,
            payload.len()
        );

        // Get or create flow
        if !self.udp_flows.contains_key(&flow_key) {
            if self.udp_flows.len() >= self.config.max_udp_flows {
                warn!("Max UDP flows reached");
                return;
            }

            let remote_addr = SocketAddrV4::new(dst_ip, dst_port);
            info!("New UDP flow to {}", remote_addr);

            // Create WAN socket
            let wan_socket = match TokioUdpSocket::bind("0.0.0.0:0").await {
                Ok(s) => s,
                Err(e) => {
                    error!("Failed to bind UDP socket: {}", e);
                    return;
                }
            };

            if let Err(e) = wan_socket.connect(SocketAddr::V4(remote_addr)).await {
                error!("Failed to connect UDP socket: {}", e);
                return;
            }

            let (wan_tx, wan_rx) = mpsc::channel::<Vec<u8>>(100);

            let flow = UdpFlow {
                peer_pubkey: *peer_pubkey,
                client_ip: src_ip,
                client_port: src_port,
                remote_ip: dst_ip,
                remote_port: dst_port,
                wan_tx,
                last_activity: Instant::now(),
            };

            self.udp_flows.insert(flow_key, flow);

            // Spawn WAN task
            let wan_tx_back = self.wan_tx_template.clone();

            tokio::spawn(async move {
                Self::run_udp_wan_task(flow_key, wan_socket, wan_rx, wan_tx_back).await;
            });
        }

        // Forward packet
        if let Some(flow) = self.udp_flows.get_mut(&flow_key) {
            flow.last_activity = Instant::now();
            if flow.wan_tx.try_send(payload.to_vec()).is_err() {
                warn!("UDP WAN channel full");
            }
        }
    }

    async fn run_udp_wan_task(
        flow_key: FlowKey,
        socket: TokioUdpSocket,
        mut from_client: mpsc::Receiver<Vec<u8>>,
        to_dataplane: mpsc::Sender<WanToDataplane>,
    ) {
        let socket = Arc::new(socket);
        let socket_recv = Arc::clone(&socket);

        // Spawn receiver
        let to_dataplane_clone = to_dataplane.clone();
        tokio::spawn(async move {
            let mut buf = vec![0u8; 65535];
            loop {
                match socket_recv.recv(&mut buf).await {
                    Ok(n) => {
                        let _ = to_dataplane_clone
                            .send(WanToDataplane::UdpData {
                                flow_key,
                                data: buf[..n].to_vec(),
                            })
                            .await;
                    }
                    Err(e) => {
                        debug!("UDP recv error: {}", e);
                        break;
                    }
                }
            }
        });

        // Send loop
        while let Some(data) = from_client.recv().await {
            if let Err(e) = socket.send(&data).await {
                debug!("UDP send error: {}", e);
                break;
            }
        }
    }

    async fn handle_wan_message(&mut self, msg: WanToDataplane) {
        match msg {
            WanToDataplane::TcpData { flow_key, data } => {
                if let Some(flow) = self.tcp_flows.get_mut(&flow_key) {
                    flow.last_activity = Instant::now();
                    flow.pending_to_client.push_back(data);
                    self.poll_smol_tcp().await;
                }
            }
            WanToDataplane::TcpClosed { flow_key } => {
                if let Some(flow) = self.tcp_flows.get_mut(&flow_key) {
                    flow.wan_closed = true;
                    self.poll_smol_tcp().await;
                }
            }
            WanToDataplane::UdpData { flow_key, data } => {
                if let Some(flow) = self.udp_flows.get_mut(&flow_key) {
                    flow.last_activity = Instant::now();
                    self.send_udp_response(&flow_key, &data).await;
                }
            }
            WanToDataplane::InboundTcpData { flow_key, data } => {
                if let Some(flow) = self.inbound_tcp_flows.get_mut(&flow_key) {
                    flow.last_activity = Instant::now();
                    flow.pending_to_client.push_back(data);
                    self.poll_smol_tcp().await;
                }
            }
            WanToDataplane::InboundTcpClosed { flow_key } => {
                if let Some(flow) = self.inbound_tcp_flows.get_mut(&flow_key) {
                    flow.wan_closed = true;
                    self.poll_smol_tcp().await;
                }
            }
        }
    }

    async fn send_udp_response(&self, flow_key: &FlowKey, data: &[u8]) {
        let Some(flow) = self.udp_flows.get(flow_key) else {
            return;
        };

        let packet = build_udp_packet(
            flow.remote_ip,
            flow.client_ip,
            flow.remote_port,
            flow.client_port,
            data,
        );

        self.send_to_client(&flow.peer_pubkey, &packet).await;
    }

    async fn send_to_client(&self, peer_pubkey: &[u8; 32], packet: &[u8]) {
        if let Err(e) = self.wg_io.send_to_peer(peer_pubkey, packet).await {
            debug!("Failed to send to client: {}", e);
        }
    }

    fn cleanup_expired_flows(&mut self) {
        let now = Instant::now();
        let tcp_timeout = Duration::from_secs(self.config.tcp_idle_timeout_secs);
        let udp_timeout = Duration::from_secs(self.config.udp_idle_timeout_secs);

        let expired_tcp: Vec<FlowKey> = self
            .tcp_flows
            .iter()
            .filter_map(|(flow_key, flow)| {
                (now.duration_since(flow.last_activity) >= tcp_timeout).then_some(*flow_key)
            })
            .collect();

        for flow_key in expired_tcp {
            if let Some(flow) = self.tcp_flows.remove(&flow_key) {
                self.smol_sockets
                    .get_mut::<tcp::Socket>(flow.socket)
                    .abort();
                self.smol_sockets.remove(flow.socket);
            }
        }

        let expired_inbound_tcp: Vec<InboundFlowKey> = self
            .inbound_tcp_flows
            .iter()
            .filter_map(|(flow_key, flow)| {
                (now.duration_since(flow.last_activity) >= tcp_timeout).then_some(*flow_key)
            })
            .collect();

        for flow_key in expired_inbound_tcp {
            if let Some(flow) = self.inbound_tcp_flows.remove(&flow_key) {
                self.smol_sockets
                    .get_mut::<tcp::Socket>(flow.socket)
                    .abort();
                self.smol_sockets.remove(flow.socket);
            }
        }

        self.udp_flows
            .retain(|_, flow| now.duration_since(flow.last_activity) < udp_timeout);
    }
}

/// Build a UDP packet with IP header
fn build_udp_packet(
    src_ip: Ipv4Addr,
    dst_ip: Ipv4Addr,
    src_port: u16,
    dst_port: u16,
    payload: &[u8],
) -> Vec<u8> {
    let udp_len = 8 + payload.len();
    let total_len = 20 + udp_len;

    let mut packet = vec![0u8; total_len];

    // IP header
    packet[0] = 0x45;
    packet[1] = 0;
    packet[2..4].copy_from_slice(&(total_len as u16).to_be_bytes());
    packet[4..6].copy_from_slice(&rand::random::<u16>().to_be_bytes());
    packet[6] = 0x40;
    packet[7] = 0;
    packet[8] = 64;
    packet[9] = 17; // Protocol: UDP
    packet[12..16].copy_from_slice(&src_ip.octets());
    packet[16..20].copy_from_slice(&dst_ip.octets());

    let ip_checksum = ip_checksum(&packet[0..20]);
    packet[10..12].copy_from_slice(&ip_checksum.to_be_bytes());

    // UDP header
    let udp = &mut packet[20..];
    udp[0..2].copy_from_slice(&src_port.to_be_bytes());
    udp[2..4].copy_from_slice(&dst_port.to_be_bytes());
    udp[4..6].copy_from_slice(&(udp_len as u16).to_be_bytes());
    // Checksum at 6-7 (optional for UDP over IPv4, set to 0)
    udp[6..8].copy_from_slice(&0u16.to_be_bytes());

    // Payload
    udp[8..8 + payload.len()].copy_from_slice(payload);

    packet
}

fn ip_checksum(header: &[u8]) -> u16 {
    let mut sum: u32 = 0;
    for i in (0..header.len()).step_by(2) {
        if i == 10 {
            continue; // Skip checksum field
        }
        let word = if i + 1 < header.len() {
            ((header[i] as u32) << 8) | (header[i + 1] as u32)
        } else {
            (header[i] as u32) << 8
        };
        sum = sum.wrapping_add(word);
    }
    while sum >> 16 != 0 {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    !(sum as u16)
}

/// Start the dataplane with WireGuard IO
pub async fn run_dataplane(
    wg_io: Arc<WgIo>,
    from_wg: mpsc::Receiver<WgToDataplane>,
    server_ip: Ipv4Addr,
    port_forward_rx: mpsc::Receiver<PortForwardEvent>,
) -> Result<()> {
    let dataplane = Dataplane::new(wg_io, server_ip);
    dataplane.run(from_wg, port_forward_rx).await
}
