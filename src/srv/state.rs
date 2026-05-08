//! Shared state for wirecagesrv - peer registry, IP pool, and configuration

use std::collections::HashMap;
use std::collections::HashSet;
use std::net::Ipv4Addr;
use std::sync::Arc;
use parking_lot::RwLock;

use super::flow::{PortForwardRule, Protocol};

/// Configuration for the server
#[derive(Clone)]
pub struct ServerConfig {
    pub server_public_key: [u8; 32],
    pub subnet: Ipv4Addr,
    pub subnet_mask: u8,
    pub auth_token: String,
}

/// A registered peer
#[derive(Clone)]
pub struct PeerInfo {
    pub public_key: [u8; 32],
    pub assigned_ip: Ipv4Addr,
}

/// IP address pool for dynamic allocation
pub struct IpPool {
    subnet: Ipv4Addr,
    mask: u8,
    allocated: HashSet<Ipv4Addr>,
    next_offset: u32,
}

impl IpPool {
    pub fn new(subnet: Ipv4Addr, mask: u8) -> Self {
        Self {
            subnet,
            mask,
            allocated: HashSet::new(),
            next_offset: 2, // Start at .2 (server is .1)
        }
    }

    /// Allocate the next available IP
    pub fn allocate(&mut self) -> Option<Ipv4Addr> {
        let max_hosts = 1u32 << (32 - self.mask);
        let base = u32::from(self.subnet) & !(max_hosts - 1);
        
        // Try sequential allocation first
        for _ in 0..max_hosts {
            let ip = Ipv4Addr::from(base + self.next_offset);
            self.next_offset = (self.next_offset + 1) % max_hosts;
            if self.next_offset < 2 {
                self.next_offset = 2; // Skip .0 and .1
            }
            
            if !self.allocated.contains(&ip) {
                self.allocated.insert(ip);
                return Some(ip);
            }
        }
        None
    }

}

/// Peer registry - maps public keys to peer info
pub struct PeerRegistry {
    by_pubkey: HashMap<[u8; 32], PeerInfo>,
    by_ip: HashMap<Ipv4Addr, [u8; 32]>,
}

impl PeerRegistry {
    pub fn new() -> Self {
        Self {
            by_pubkey: HashMap::new(),
            by_ip: HashMap::new(),
        }
    }

    pub fn add(&mut self, info: PeerInfo) {
        let pubkey = info.public_key;
        let ip = info.assigned_ip;
        self.by_ip.insert(ip, pubkey);
        self.by_pubkey.insert(pubkey, info);
    }

    pub fn get_by_pubkey(&self, pubkey: &[u8; 32]) -> Option<&PeerInfo> {
        self.by_pubkey.get(pubkey)
    }

    pub fn iter(&self) -> impl Iterator<Item = &PeerInfo> {
        self.by_pubkey.values()
    }
}

impl Default for PeerRegistry {
    fn default() -> Self {
        Self::new()
    }
}

/// Port forward registry - maps public ports to forwarding rules
pub struct PortForwardRegistry {
    /// TCP port -> rule
    tcp_rules: HashMap<u16, PortForwardRule>,
    /// UDP port -> rule
    udp_rules: HashMap<u16, PortForwardRule>,
    /// Rules by peer pubkey for cleanup
    by_peer: HashMap<[u8; 32], Vec<u16>>,
}

impl PortForwardRegistry {
    pub fn new() -> Self {
        Self {
            tcp_rules: HashMap::new(),
            udp_rules: HashMap::new(),
            by_peer: HashMap::new(),
        }
    }

    /// Add a port forward rule
    pub fn add(&mut self, rule: PortForwardRule) -> Result<(), &'static str> {
        let rules = match rule.protocol {
            Protocol::Tcp => &mut self.tcp_rules,
            Protocol::Udp => &mut self.udp_rules,
        };

        if rules.contains_key(&rule.public_port) {
            return Err("port already in use");
        }

        let port = rule.public_port;
        let pubkey = rule.peer_pubkey;
        rules.insert(port, rule);

        self.by_peer.entry(pubkey).or_default().push(port);
        Ok(())
    }

    /// Remove a port forward rule
    pub fn remove(&mut self, protocol: Protocol, port: u16) -> Option<PortForwardRule> {
        let rules = match protocol {
            Protocol::Tcp => &mut self.tcp_rules,
            Protocol::Udp => &mut self.udp_rules,
        };

        if let Some(rule) = rules.remove(&port) {
            if let Some(ports) = self.by_peer.get_mut(&rule.peer_pubkey) {
                ports.retain(|p| *p != port);
            }
            Some(rule)
        } else {
            None
        }
    }

}

impl Default for PortForwardRegistry {
    fn default() -> Self {
        Self::new()
    }
}

/// Shared server state
pub struct SharedState {
    pub config: ServerConfig,
    pub ip_pool: RwLock<IpPool>,
    pub peers: RwLock<PeerRegistry>,
    pub port_forwards: RwLock<PortForwardRegistry>,
}

impl SharedState {
    pub fn new(config: ServerConfig) -> Arc<Self> {
        let ip_pool = IpPool::new(config.subnet, config.subnet_mask);
        Arc::new(Self {
            config,
            ip_pool: RwLock::new(ip_pool),
            peers: RwLock::new(PeerRegistry::new()),
            port_forwards: RwLock::new(PortForwardRegistry::new()),
        })
    }
}
