# Integration Tests

This directory contains the maintained shell-based integration tests for `wirecage` and `wirecagesrv`.

## Modes

- **Netns mode (default)**: Starts the current binaries directly on the host and exercises the HTTP API and listener lifecycle.
- **QEMU mode (`--qemu`)**: Intended for fuller isolation, but the current runner does not have separate maintained QEMU-only test cases.

## Prerequisites

- `qemu-system-x86_64`
- A Linux kernel image (automatically downloaded if not present)
- Rust toolchain with `x86_64-unknown-linux-musl` target

## Running Tests

```bash
# Run all maintained integration tests
./tests/qemu/run-tests.sh

# Run a specific test
./tests/qemu/run-tests.sh test_api_register
```

## Current Tests

- `test_api_register`: Starts `wirecagesrv`, registers peers through `/v1/register`, and verifies auth/IP allocation behavior.
- `test_port_forward_api`: Starts `wirecagesrv`, creates and removes forwarded listeners through `/v1/portforward`, and checks listener lifecycle behavior.
- `test_userspace_nat`: Placeholder only. It currently documents the intended full dataplane coverage but does not execute it.

For a namespace-based end-to-end smoke test of the current API-driven server flow, use [`integration-test.sh`](/home/esk/dev/wirecage/integration-test.sh).
