//! Flow abstraction for NAT and port forwarding
//!
//! A "flow" represents a bidirectional connection between:
//! - A WireGuard client (via smoltcp socket)
//! - An internet destination (via tokio socket)

use std::net::Ipv4Addr;
/// Protocol type
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Protocol {
    Tcp,
    Udp,
}

/// Unique identifier for a flow (5-tuple)
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct FlowKey {
    pub protocol: Protocol,
    pub client_ip: Ipv4Addr,
    pub client_port: u16,
    pub remote_ip: Ipv4Addr,
    pub remote_port: u16,
}

/// Configuration for flow timeouts
#[derive(Debug, Clone)]
pub struct FlowConfig {
    pub tcp_idle_timeout_secs: u64,
    pub udp_idle_timeout_secs: u64,
    pub max_tcp_flows: usize,
    pub max_udp_flows: usize,
}

impl Default for FlowConfig {
    fn default() -> Self {
        Self {
            tcp_idle_timeout_secs: 300, // 5 minutes
            udp_idle_timeout_secs: 60,  // 1 minute
            max_tcp_flows: 10000,
            max_udp_flows: 10000,
        }
    }
}

/// Port forwarding rule for server-side remote listening
#[derive(Debug, Clone)]
pub struct PortForwardRule {
    pub protocol: Protocol,
    pub public_port: u16,
    pub peer_pubkey: [u8; 32],
    pub peer_ip: Ipv4Addr,
    pub target_port: u16,
}
