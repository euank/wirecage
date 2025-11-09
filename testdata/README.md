# WireGuard Test Keys

This directory contains test keys for running wirecagesrv and wirecage.

## Files

- `server-private.key` - Server private key
- `server-public.key` - Server public key  
- `client-private.key` - Client private key
- `client-public.key` - Client public key

## ⚠️ WARNING

**These keys are for testing only! Do not use in production.**

Generate new keys for production use:
```bash
wg genkey > my-private.key
wg pubkey < my-private.key > my-public.key
```
