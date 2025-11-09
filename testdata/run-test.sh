#!/usr/bin/env bash
# Quick test runner - starts server and runs a ping test

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

SERVER_PUBKEY=$(cat testdata/server-public.key)
CLIENT_PUBKEY=$(cat testdata/client-public.key)

echo "Starting WireGuard server..."
sudo ./target/release/wirecagesrv \
  --private-key-file testdata/server-private.key \
  --listen-addr 127.0.0.1:51820 \
  --peer "$CLIENT_PUBKEY,10.200.100.2/32" &

SERVER_PID=$!

# Ensure cleanup on exit
trap "echo 'Stopping server...'; sudo kill $SERVER_PID 2>/dev/null || true" EXIT

echo "Waiting for server to start..."
sleep 3

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Running ping test through WireGuard tunnel..."
echo "════════════════════════════════════════════════════════════════"
echo ""

./target/release/wirecage \
  --wg-endpoint 127.0.0.1:51820 \
  --wg-public-key "$SERVER_PUBKEY" \
  --wg-private-key-file testdata/client-private.key \
  --wg-address 10.200.100.2 \
  --no-overlay \
  -- ping -c 3 1.1.1.1

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Test completed!"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Keep server running for manual testing
echo "Server is still running (PID: $SERVER_PID)"
echo "Press Ctrl+C to stop"
wait $SERVER_PID
