# Client And Server Status

## Current Architecture

`wirecage` is the active client binary. It creates a user namespace, keeps the WireGuard socket in the host namespace, creates a separate network namespace for the target command, and bridges packets between the namespace TUN device and the host-side WireGuard tunnel.

`wirecagesrv` is the active server binary. It lives under `src/srv/` and implements:

- userspace WireGuard packet handling
- an HTTP or HTTPS registration API
- dynamic peer allocation and IP assignment
- userspace outbound NAT for client traffic
- API-driven TCP and UDP port forwarding

## Findings

- The live server implementation is `src/srv/main.rs` plus the `src/srv/*` modules. That is the `wirecagesrv` binary declared in `Cargo.toml`.
- The repo still contains an older rootful server prototype in `src/server.rs` and `src/server_args.rs`. It is not the binary built by Cargo today, but several scripts and comments had drifted toward that obsolete CLI.
- The current server is API-driven. Clients are expected to register with `/v1/register` and use the returned WireGuard material instead of preconfiguring peers on the command line.
- Port forwarding is implemented in the active server, so comments that still described it as future work were stale.
- The repo’s maintained integration coverage is strongest around server API behavior. Full end-to-end dataplane coverage exists only as a namespace-based smoke test and a placeholder note in the `tests/qemu` runner.

## Current Test State

- `tests/qemu/run-tests.sh` currently runs `test_api_register` and `test_port_forward_api` by default.
- Those tests exercise the current `wirecagesrv` API and listener lifecycle directly against the built binary.
- `test_userspace_nat` in that runner is still a placeholder and does not verify the full client-to-server dataplane.
- `integration-test.sh` is the current namespace-based smoke test for the API-driven flow. It is the closest thing in-repo to an end-to-end client/server connectivity check, but it is still a shell script rather than a fast automated test integrated into `cargo test`.

## Repo Hygiene Changes

- README wording now matches the current `wirecagesrv` capabilities.
- Legacy server files are explicitly marked as legacy so they do not look like the active entrypoint.
- Stale helper scripts were updated to use the registration API rather than the removed static-peer CLI.
