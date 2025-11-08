use clap::Parser;

#[derive(Parser, Debug, Clone)]
#[command(name = "wirecagesrv")]
#[command(about = "WireGuard VPN Server - routes client traffic to the internet")]
pub struct ServerArgs {
    #[arg(long, help = "Path to server private key file")]
    pub private_key_file: String,

    #[arg(long, default_value = "0.0.0.0:51820", help = "Listen address and port")]
    pub listen_addr: String,

    #[arg(long, default_value = "10.200.100.1", help = "Server IP address")]
    pub subnet: String,

    #[arg(long, default_value = "10.200.100.0/24", help = "Full subnet CIDR")]
    pub subnet_cidr: String,

    #[arg(long, default_value = "wg-srv", help = "TUN interface name")]
    pub tun_name: String,

    #[arg(long, help = "Outbound network interface (auto-detected if not specified)")]
    pub outbound_interface: Option<String>,

    #[arg(long = "peer", value_parser = parse_peer, help = "Peer in format: pubkey,ip (can be specified multiple times)")]
    pub peers: Vec<PeerConfig>,
}

#[derive(Debug, Clone)]
pub struct PeerConfig {
    pub public_key: String,
    pub allowed_ips: Vec<String>,
}

fn parse_peer(s: &str) -> Result<PeerConfig, String> {
    let parts: Vec<&str> = s.split(',').collect();
    if parts.len() != 2 {
        return Err("Peer format must be: pubkey,ip".to_string());
    }

    Ok(PeerConfig {
        public_key: parts[0].to_string(),
        allowed_ips: vec![parts[1].to_string()],
    })
}
