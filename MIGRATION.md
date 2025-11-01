# Migration from Go to Rust

## Summary

The wirecage client has been completely rewritten in Rust to solve the namespace inheritance race condition that existed in the Go version.

## The Problem

In the Go version, when stage 2 created a network namespace with `unshare(CLONE_NEWNET)`, it created the namespace on the current OS thread (after `runtime.LockOSThread()`). However, when launching stage 3 with `exec.Command()`, Go's runtime would fork the process from a different internal "execer" thread that hadn't called `unshare()`. This meant stage 3 would randomly inherit either:

- The correct network namespace (if lucky)
- The original host network namespace (if unlucky)

This caused the "only seeing lo, not wirecage interface" bug.

## The Solution

Rust doesn't have hidden threading like Go. The rewrite:

1. **Eliminates stage 3 entirely** - Since there's no threading issue, we can exec the target command directly from stage 2
2. **Direct system calls** - Uses `nix` crate for direct `unshare()`, `setns()`, `clone()` calls
3. **Predictable behavior** - Single-threaded execution means namespaces are always inherited correctly

## File Structure

```
src/
├── main.rs         - Entry point, stage 1 & 2 logic
├── args.rs         - Command-line argument parsing
├── namespace.rs    - Namespace creation and network setup
├── network.rs      - Network stack and packet forwarding
├── wireguard.rs    - WireGuard tunnel management
├── overlay.rs      - Overlay filesystem for /etc
└── server.rs       - Placeholder for wirecagesrv
```

## Building

```bash
cargo build --release
```

Binary location: `target/release/wirecage`

## Testing

Test with the same command line as before:

```bash
./target/release/wirecage \
  --wg-public-key <KEY> \
  --wg-private-key-file <FILE> \
  --wg-endpoint <HOST:PORT> \
  --wg-address <IP> \
  -- ip a
```

You should now **always** see the `wirecage` interface, never just `lo`.

## Key Dependencies

- **nix** (0.29): Safe Rust bindings to POSIX/Linux syscalls
- **boringtun** (0.6): Pure Rust WireGuard implementation  
- **tun** (0.6): TUN/TAP device interface
- **rtnetlink** (0.14): Netlink for network configuration
- **tokio** (1.42): Async runtime for I/O
- **clap** (4.5): CLI argument parsing

## What's Different

### Removed
- All Go wireguard-go dependencies
- gvisor network stack
- Stage 3 subprocess

### Added
- boringtun (Rust WireGuard)
- Direct packet forwarding between TUN and WireGuard
- Cleaner error handling with anyhow

### Unchanged
- Command-line interface (same arguments)
- Two-stage execution model (stage 1 → stage 2)
- User namespace setup
- Overlay filesystem functionality
- Network namespace isolation

## Performance

The Rust version should be similar or better in performance:
- No Go runtime overhead
- More efficient system call handling
- Direct memory management

## Future Work

- [ ] Complete wirecagesrv rewrite
- [ ] Add comprehensive tests
- [ ] Benchmark against Go version
- [ ] Add more network stack features
- [ ] Better error messages
