#!/usr/bin/env bash
# Test commands for wirecagesrv and wirecage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SERVER_PRIVATE_KEY="$SCRIPT_DIR/server-private.key"
SERVER_PUBLIC_KEY="$SCRIPT_DIR/server-public.key"
CLIENT_PRIVATE_KEY="$SCRIPT_DIR/client-private.key"
CLIENT_PUBLIC_KEY="$SCRIPT_DIR/client-public.key"

SERVER_PUBKEY=$(cat "$SERVER_PUBLIC_KEY")
CLIENT_PUBKEY=$(cat "$CLIENT_PUBLIC_KEY")

echo "════════════════════════════════════════════════════════════════"
echo "  WireGuard Server and Client Test Commands"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Server Public Key: $SERVER_PUBKEY"
echo "Client Public Key: $CLIENT_PUBKEY"
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "1. START THE SERVER (in one terminal):"
echo "────────────────────────────────────────────────────────────────"
echo ""
cat <<EOF
sudo ./target/release/wirecagesrv \\
  --private-key-file testdata/server-private.key \\
  --listen-addr 0.0.0.0:51820 \\
  --peer $CLIENT_PUBKEY,10.200.100.2/32
EOF
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "2. TEST WITH CLIENT (in another terminal):"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "# Ping test:"
cat <<EOF
./target/release/wirecage \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-public-key $SERVER_PUBKEY \\
  --wg-private-key-file testdata/client-private.key \\
  --wg-address 10.200.100.2 \\
  --no-overlay \\
  -- ping -c 3 1.1.1.1
EOF
echo ""

echo "# HTTP test:"
cat <<EOF
./target/release/wirecage \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-public-key $SERVER_PUBKEY \\
  --wg-private-key-file testdata/client-private.key \\
  --wg-address 10.200.100.2 \\
  --no-overlay \\
  -- curl -v http://example.com
EOF
echo ""

echo "# Interactive shell:"
cat <<EOF
./target/release/wirecage \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-public-key $SERVER_PUBKEY \\
  --wg-private-key-file testdata/client-private.key \\
  --wg-address 10.200.100.2 \\
  -- bash
EOF
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "3. NETWORK CONFIGURATION:"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "Server IP:     10.200.100.1"
echo "Client IP:     10.200.100.2"
echo "Server Port:   51820"
echo "Subnet:        10.200.100.0/24"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo ""
echo "💡 Quick test: Run 'bash testdata/run-test.sh' to auto-start"
echo ""
