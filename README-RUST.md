# Wirecage - Rust Implementation

This is a complete Rust rewrite of wirecage, fixing the namespace inheritance issues present in the Go version.

## Why Rust?

The Go implementation had a fundamental issue: Go's multi-threaded runtime caused namespace inheritance problems. When creating a subprocess, Go's internal "execer" thread would fork from a different OS thread than the one that created the network namespace, causing the subprocess to randomly see either the correct or wrong network namespace.

Rust provides:
- Single-threaded execution by default
- Direct control over system calls like `clone()`, `unshare()`, and `setns()`
- No hidden goroutine scheduler interfering with namespace operations
- Predictable namespace inheritance

## Building

```bash
cargo build --release
```

The binary will be at `target/release/wirecage`.

## Usage

Same as the Go version:

```bash
wirecage \
  --wg-public-key <SERVER_PUBLIC_KEY> \
  --wg-private-key-file <PRIVATE_KEY_FILE> \
  --wg-endpoint <SERVER_IP:PORT> \
  --wg-address <YOUR_VPN_IP> \
  -- <command>
```

## Architecture

The Rust implementation uses a two-stage approach:

### Stage 1
- Parse command-line arguments
- Determine target UID/GID
- Fork into a new user namespace with proper uid_map/gid_map

### Stage 2
- Create network namespace with `unshare(CLONE_NEWNET)`
- Create TUN device
- Configure network interfaces and routing
- Set up overlay filesystem for `/etc/resolv.conf`
- Initialize WireGuard tunnel using `boringtun`
- Forward packets between TUN device and WireGuard
- Drop privileges if needed
- Exec target command

## Key Differences from Go Version

1. **No Stage 3**: Since Rust doesn't have Go's threading issues, we don't need a third stage to work around namespace inheritance problems

2. **Direct System Calls**: Uses `nix` crate for direct, safe system call access without runtime interference

3. **WireGuard**: Uses `boringtun` (pure Rust WireGuard implementation) instead of Go's wireguard-go

4. **Async Runtime**: Uses Tokio for async I/O but keeps it isolated from the namespace setup

## Dependencies

- `nix`: Safe Rust bindings to Linux system calls
- `boringtun`: WireGuard implementation in Rust
- `tun`: TUN/TAP device interface
- `rtnetlink`: Netlink interface for network configuration
- `tokio`: Async runtime for I/O operations
- `clap`: Command-line argument parsing
- `anyhow`: Error handling

## Status

✅ Namespace management  
✅ TUN device creation  
✅ Network configuration  
✅ Overlay filesystem  
✅ WireGuard tunnel setup  
✅ Packet forwarding  
⚠️ Testing in progress

## License

Same as the original wirecage project.
