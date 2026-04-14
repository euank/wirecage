# WireGuard Test Keys

This directory contains test keys and helper scripts for local `wirecagesrv` and `wirecage` smoke tests.

## Files

- `server-private.key` - Server private key for local test startup
- `server-public.key` - Matching server public key
- `client-private.key` - Legacy client key kept for reference
- `client-public.key` - Legacy client public key kept for reference

The active server flow is API-driven: `wirecagesrv` allocates peers through `/v1/register` and returns a fresh client private key. The helper scripts in this directory use that API instead of passing static peers to the server.

## ⚠️ WARNING

**These keys are for testing only! Do not use in production.**

Generate new keys for production use:
```bash
wg genkey > my-private.key
wg pubkey < my-private.key > my-public.key
```
