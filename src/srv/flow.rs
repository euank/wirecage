//! Flow abstraction for NAT and port forwarding
//!
//! A "flow" represents a bidirectional connection between:
//! - A WireGuard client (via smoltcp socket)
//! - An internet destination (via tokio socket)

use std::net::Ipv4Addr;
use std::time::Instant;

/// Direction of a flow
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum FlowDirection {
    /// Client initiated connection to internet (NAT outbound)
    Outbound,
    /// Internet connection to client via a forwarded server port
    Inbound,
}

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

impl FlowKey {
    pub fn new_outbound(
        protocol: Protocol,
        client_ip: Ipv4Addr,
        client_port: u16,
        dest_ip: Ipv4Addr,
        dest_port: u16,
    ) -> Self {
        Self {
            protocol,
            client_ip,
            client_port,
            remote_ip: dest_ip,
            remote_port: dest_port,
        }
    }
}

/// Flow specification - describes what a flow does
#[derive(Debug, Clone)]
pub struct FlowSpec {
    pub key: FlowKey,
    pub direction: FlowDirection,
    pub peer_pubkey: [u8; 32],
    pub created_at: Instant,
    pub last_activity: Instant,
}

impl FlowSpec {
    pub fn new_outbound(key: FlowKey, peer_pubkey: [u8; 32]) -> Self {
        let now = Instant::now();
        Self {
            key,
            direction: FlowDirection::Outbound,
            peer_pubkey,
            created_at: now,
            last_activity: now,
        }
    }
}

/// Configuration for flow timeouts
#[derive(Debug, Clone)]
pub struct FlowConfig {
    pub tcp_idle_timeout_secs: u64,
    pub udp_idle_timeout_secs: u64,
    pub tcp_connect_timeout_secs: u64,
    pub max_tcp_flows: usize,
    pub max_udp_flows: usize,
}

impl Default for FlowConfig {
    fn default() -> Self {
        Self {
            tcp_idle_timeout_secs: 300, // 5 minutes
            udp_idle_timeout_secs: 60,  // 1 minute
            tcp_connect_timeout_secs: 10,
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
