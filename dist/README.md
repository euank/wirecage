# WireCage - Static Binaries

**Statically linked x86_64 Linux binaries** - no dependencies required!

## Binaries

- `wirecagesrv` (2.3 MB) - WireGuard VPN server
- `wirecage` (3.5 MB) - WireGuard VPN client

Both binaries are:
- ✅ Statically linked (musl libc)
- ✅ Stripped for minimal size
- ✅ Position-independent executable (PIE)
- ✅ No external dependencies
- ✅ Portable across Linux distributions

## Verification

```bash
# Verify they're static
ldd wirecagesrv  # Should output "statically linked"
ldd wirecage     # Should output "statically linked"

# Check file type
file wirecagesrv
file wirecage
```

## Usage

### Server (wirecagesrv)

Start the VPN server:

```bash
sudo ./wirecagesrv \
  --private-key-file /path/to/server-private.key \
  --listen-addr 0.0.0.0:51820 \
  --peer <client-public-key>,10.200.100.2/32
```

**Requirements:**
- Root/CAP_NET_ADMIN (for TUN interface creation)
- Kernel support for TUN devices
- iptables (for NAT)

### Client (wirecage)

Connect to VPN server:

```bash
./wirecage \
  --wg-endpoint <server-ip>:51820 \
  --wg-public-key <server-public-key> \
  --wg-private-key-file /path/to/client-private.key \
  --wg-address 10.200.100.2 \
  -- <command>
```

Example:
```bash
./wirecage \
  --wg-endpoint vpn.example.com:51820 \
  --wg-public-key "base64key==" \
  --wg-private-key-file ~/.wirecage/private.key \
  --wg-address 10.200.100.2 \
  -- curl https://api.ipify.org
```

**Requirements:**
- User namespaces enabled (standard on most modern Linux)
- No root required for the client!

## Deployment

These binaries can be deployed anywhere on x86_64 Linux:

```bash
# Copy to server
scp wirecagesrv root@server:/usr/local/bin/

# Make executable
chmod +x /usr/local/bin/wirecagesrv

# Run
/usr/local/bin/wirecagesrv --help
```

## Building from Source

To rebuild static binaries:

```bash
rustup target add x86_64-unknown-linux-musl
cargo build --release --target x86_64-unknown-linux-musl
strip target/x86_64-unknown-linux-musl/release/wirecage{,srv}
```

## License

See main repository for license information.

## Security Notes

⚠️ **These are test/example keys included in the repository**

For production:
1. Generate new keys: `wg genkey > private.key && wg pubkey < private.key > public.key`
2. Protect private keys: `chmod 600 private.key`
3. Never commit private keys to version control
4. Use proper firewall rules
5. Keep binaries updated

## Architecture

- **Server**: Userspace WireGuard using boringtun
- **Client**: Namespace-isolated networking with WireGuard tunnel
- **Language**: Rust (memory-safe, no runtime dependencies)
- **Async Runtime**: Tokio
- **Crypto**: WireGuard (boringtun implementation)

Built: $(date)
Target: x86_64-unknown-linux-musl
