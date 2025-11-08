# WireGuard Server Implementation Plan

## Overview
Implement a userspace WireGuard server (`wirecagesrv`) using boringtun that can act as a VPN server, forwarding client traffic to the internet with NAT.

## Goals
- Accept WireGuard connections from wirecage clients
- Route all client traffic through the server
- Perform NAT/masquerading to forward traffic to internet
- Support multiple concurrent clients
- Use same boringtun library as client for consistency

## Architecture

### Components

1. **UDP Socket Listener**
   - Bind to configurable port (default: 51820)
   - Receive encrypted WireGuard packets from clients
   - Send encrypted responses back

2. **WireGuard Tunnel Manager**
   - Use boringtun `Tunn` for each peer
   - Handle handshakes and keepalives
   - Encrypt/decrypt packets per peer

3. **TUN Interface**
   - Create TUN device for routing decrypted packets
   - Assign server IP address (e.g., 10.200.100.1/24)
   - Route packets between WireGuard tunnels and TUN

4. **IP Forwarding & NAT**
   - Enable IP forwarding in kernel
   - Set up iptables rules for NAT/masquerading
   - Track connections per client

5. **Configuration Management**
   - Server private key
   - Server listen address and port
   - Peer configurations (public key, allowed IPs)
   - Network settings (subnet, DNS, etc.)

### Data Flow

```
Internet <-> [Physical Interface + NAT] <-> [TUN Interface] <-> [WireGuard Tunnel] <-> [UDP Socket] <-> Client
```

**Inbound (Client -> Internet):**
1. Client sends encrypted UDP packet to server
2. Server receives on UDP socket
3. Decrypt with boringtun, get IP packet
4. Write IP packet to TUN interface
5. Kernel routes packet, applies NAT
6. Packet goes to internet via physical interface

**Outbound (Internet -> Client):**
1. Response arrives at physical interface
2. Kernel routes to TUN (reverse NAT)
3. Read IP packet from TUN
4. Determine destination client by IP
5. Encrypt with boringtun for that peer
6. Send UDP packet to client endpoint

## Implementation Steps

### Phase 1: Basic Server Structure
- [ ] Create `src/server.rs` with CLI argument parsing
  - Server private key file
  - Listen address/port
  - Peer configuration (can start with single peer)
  - Server subnet (e.g., 10.200.100.0/24)
  
- [ ] Set up UDP socket binding
- [ ] Load server private key

### Phase 2: WireGuard Integration
- [ ] Create peer management structure
  ```rust
  struct Peer {
      tunnel: Tunn,
      allowed_ips: Vec<IpNet>,
      endpoint: Option<SocketAddr>,
      last_handshake: Option<Instant>,
  }
  ```

- [ ] Implement packet reception loop
  - Receive UDP packets
  - Match to peer (try decrypting with each peer's tunnel)
  - Update peer endpoint on successful decrypt

- [ ] Handle WireGuard handshake packets

### Phase 3: TUN Interface Setup
- [ ] Create TUN device (requires CAP_NET_ADMIN)
  - Use existing `tun` crate
  - Assign server IP to TUN
  - Set MTU appropriately (1420 for WireGuard)

- [ ] Implement bidirectional packet routing:
  - **TUN -> Tunnel:** Read from TUN, encrypt, send to peer
  - **Tunnel -> TUN:** Decrypt from peer, write to TUN

### Phase 4: IP Forwarding & NAT
- [ ] Enable IP forwarding
  ```rust
  std::fs::write("/proc/sys/net/ipv4/ip_forward", "1")?;
  ```

- [ ] Set up iptables NAT rules
  ```bash
  iptables -t nat -A POSTROUTING -s 10.200.100.0/24 -o eth0 -j MASQUERADE
  iptables -A FORWARD -i wg-srv -j ACCEPT
  iptables -A FORWARD -o wg-srv -j ACCEPT
  ```
  - Determine outbound interface dynamically
  - Clean up rules on shutdown

### Phase 5: Multi-peer Support
- [ ] Support multiple peers from config file
  ```toml
  [server]
  private_key_file = "/path/to/key"
  listen_addr = "0.0.0.0:51820"
  subnet = "10.200.100.0/24"
  
  [[peer]]
  public_key = "..."
  allowed_ips = ["10.200.100.2/32"]
  
  [[peer]]
  public_key = "..."
  allowed_ips = ["10.200.100.3/32"]
  ```

- [ ] IP allocation/tracking per peer
- [ ] Concurrent packet handling (tokio tasks)

### Phase 6: Robustness & Features
- [ ] Graceful shutdown (cleanup TUN, iptables)
- [ ] Logging and metrics
  - Connection status per peer
  - Bandwidth usage
  - Handshake failures
  
- [ ] Keepalive handling
- [ ] MTU/MSS clamping if needed
- [ ] Optional DNS server configuration

## Configuration Format

### Command-line (MVP)
```bash
wirecagesrv \
  --private-key-file /path/to/server.key \
  --listen 0.0.0.0:51820 \
  --subnet 10.200.100.0/24 \
  --peer <pubkey> --peer-ip 10.200.100.2/32 \
  --outbound-interface eth0
```

### Config file (future)
```toml
[server]
private_key_file = "/etc/wirecage/server.key"
listen_addr = "0.0.0.0:51820"
subnet = "10.200.100.0/24"
outbound_interface = "eth0"  # auto-detect if not specified

[[peer]]
public_key = "base64key=="
allowed_ips = ["10.200.100.2/32"]

[[peer]]
public_key = "anotherkey=="
allowed_ips = ["10.200.100.3/32"]
```

## Technical Considerations

### Threading Model
- Main tokio runtime with multiple tasks:
  - UDP receive task
  - TUN read task  
  - TUN write task (from queue)
  - Per-peer timers for keepalive

### Packet Routing Logic
- Use HashMap to map client IPs to peer tunnels
- Lock-free where possible (Arc<Mutex<>> for peer state)
- Channels for passing packets between tasks

### NAT Implementation
- Option 1: Use iptables (simpler, kernel handles it)
- Option 2: Userspace NAT (more portable, more complex)
- **Recommendation:** Start with iptables

### Privilege Requirements
- Creating TUN interface requires CAP_NET_ADMIN
- Setting up iptables rules requires root
- **Approach:** Require root, or use capabilities

### Error Handling
- Failed handshakes: log and continue
- Peer endpoint changes: update dynamically
- TUN read/write errors: retry with backoff
- Malformed packets: drop and log

## Testing Strategy

1. **Unit tests:** Peer management, IP allocation
2. **Integration tests:** 
   - Single client connection
   - Multi-client scenarios
   - Packet forwarding verification
3. **Manual testing:**
   - Use wirecage client to connect
   - Verify internet access (ping, curl)
   - Test multiple concurrent clients

## Future Enhancements
- IPv6 support
- Built-in DNS server
- Web UI for monitoring
- Dynamic peer addition/removal
- Rate limiting per peer
- Traffic shaping
- Config reload without restart

## Open Questions
1. Should we support multiple subnets or just one?
2. Config file format: TOML, YAML, or JSON?
3. Should iptables rules persist across restarts?
4. How to handle IP allocation (static vs dynamic)?
5. Should we implement userspace NAT for portability?

## Dependencies
- `boringtun`: WireGuard protocol
- `tun`: TUN device creation
- `tokio`: Async runtime
- `anyhow`: Error handling
- `clap`: CLI parsing
- `serde`/`toml`: Config file parsing (future)
- `ipnet`: IP network handling
- `tracing`: Logging

## Estimated Effort
- Phase 1-2: Basic structure + WireGuard - **2-3 hours**
- Phase 3-4: TUN + NAT - **3-4 hours**
- Phase 5: Multi-peer - **2 hours**
- Phase 6: Polish - **2-3 hours**
- Testing: **2 hours**

**Total: ~12-15 hours of development**
