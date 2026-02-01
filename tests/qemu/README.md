# QEMU Integration Tests

This directory contains QEMU-based integration tests for wirecage.

## Why QEMU?

- **Full isolation**: Each test runs in its own VM, no host network interference
- **No root required**: QEMU user-mode networking works without privileges
- **Reproducible**: Same kernel/environment every time
- **Realistic**: Tests the actual network stack, not mocked interfaces

## Prerequisites

- `qemu-system-x86_64`
- A Linux kernel image (automatically downloaded if not present)
- Rust toolchain with `x86_64-unknown-linux-musl` target

## Running Tests

```bash
# Run all QEMU tests
./tests/qemu/run-tests.sh

# Run specific test
./tests/qemu/run-tests.sh test_userspace_nat
```

## Test Structure

- `run-tests.sh` - Main test runner
- `build-initramfs.sh` - Builds minimal initramfs with test binaries
- `test_*.sh` - Individual test scripts
- `common.sh` - Shared test utilities

## Tests

| Test | Description |
|------|-------------|
| `test_api_register` | Token exchange and peer registration |
| `test_userspace_nat` | Outbound NAT (client → internet) |
| `test_port_forward` | Inbound port forwarding (internet → client) |
