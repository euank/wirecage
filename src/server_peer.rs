use boringtun::noise::Tunn;
use std::net::{IpAddr, SocketAddr};

pub struct Peer {
    pub tunnel: Tunn,
    pub allowed_ips: Vec<String>,
    pub endpoint: Option<SocketAddr>,
}

impl Peer {
    pub fn new(tunnel: Tunn, allowed_ips: Vec<String>) -> Self {
        Self {
            tunnel,
            allowed_ips,
            endpoint: None,
        }
    }

    pub fn owns_ip(&self, ip: &IpAddr) -> bool {
        for allowed in &self.allowed_ips {
            // Parse CIDR notation
            if let Some((network, prefix)) = allowed.split_once('/') {
                if let Ok(network_ip) = network.parse::<IpAddr>() {
                    // Simple check: for /32 or /128, exact match
                    if (prefix == "32" || prefix == "128") && &network_ip == ip {
                        return true;
                    }
                    // For other prefixes, would need proper CIDR matching
                    // For now, simple prefix match
                    if ip.to_string().starts_with(network) {
                        return true;
                    }
                }
            }
        }
        false
    }
}
