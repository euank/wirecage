#!/usr/bin/env bash
# Test commands for the current API-driven wirecagesrv and wirecage flow.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SERVER_PUBLIC_KEY="$SCRIPT_DIR/server-public.key"
AUTH_TOKEN="wirecage-local-test"

SERVER_PUBKEY=$(cat "$SERVER_PUBLIC_KEY")

echo "════════════════════════════════════════════════════════════════"
echo "  WireGuard Server and Client Test Commands"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Server Public Key: $SERVER_PUBKEY"
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "1. START THE SERVER (in one terminal):"
echo "────────────────────────────────────────────────────────────────"
echo ""
cat <<EOF
./target/release/wirecagesrv \\
  --private-key-file testdata/server-private.key \\
  --auth-token $AUTH_TOKEN \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-listen 127.0.0.1:51820 \\
  --api-listen 127.0.0.1:18443
EOF
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "2. REGISTER A CLIENT (in another terminal):"
echo "────────────────────────────────────────────────────────────────"
echo ""
cat <<EOF
curl -s -X POST http://127.0.0.1:18443/v1/register \\
  -H "Content-Type: application/json" \\
  -d '{"token":"$AUTH_TOKEN"}'
EOF
echo ""

echo "Save the JSON and extract:"
cat <<EOF
CLIENT_PRIVATE_KEY=<client_private_key from JSON>
CLIENT_ADDRESS=<client_address without /24>
SERVER_PUBLIC_KEY=<server_public_key from JSON>
EOF
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "3. TEST WITH CLIENT:"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "# HTTP test:"
cat <<EOF
./target/release/wirecage \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-public-key \$SERVER_PUBLIC_KEY \\
  --wg-private-key-file /path/to/client.key \\
  --wg-address \$CLIENT_ADDRESS \\
  --no-overlay \\
  -- curl -v http://example.com
EOF
echo ""

echo "# Interactive shell:"
cat <<EOF
./target/release/wirecage \\
  --wg-endpoint 127.0.0.1:51820 \\
  --wg-public-key \$SERVER_PUBLIC_KEY \\
  --wg-private-key-file /path/to/client.key \\
  --wg-address \$CLIENT_ADDRESS \\
  -- bash
EOF
echo ""

echo "────────────────────────────────────────────────────────────────"
echo "3. NETWORK CONFIGURATION:"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "Server IP:     10.200.100.1"
echo "Client IP:     allocated dynamically by /v1/register"
echo "Server Port:   51820"
echo "Subnet:        10.200.100.0/24"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo ""
echo "💡 Quick test: Run 'bash testdata/run-test.sh' to auto-start"
echo ""
