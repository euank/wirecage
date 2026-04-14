#!/usr/bin/env bash
# Quick local smoke test using the current API-driven wirecagesrv flow.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

AUTH_TOKEN="wirecage-local-test"
WG_PORT="51820"
API_PORT="18443"
CLIENT_KEY_FILE="/tmp/wirecage-local-client.key"
REGISTER_JSON="/tmp/wirecage-local-register.json"

echo "Starting WireGuard server..."
./target/release/wirecagesrv \
  --private-key-file testdata/server-private.key \
  --auth-token "$AUTH_TOKEN" \
  --wg-endpoint "127.0.0.1:$WG_PORT" \
  --wg-listen "127.0.0.1:$WG_PORT" \
  --api-listen "127.0.0.1:$API_PORT" &

SERVER_PID=$!

# Ensure cleanup on exit
trap "echo 'Stopping server...'; kill $SERVER_PID 2>/dev/null || true; rm -f '$CLIENT_KEY_FILE' '$REGISTER_JSON'" EXIT

echo "Waiting for server to start..."
sleep 3

echo "Registering a client..."
curl -fsS -X POST "http://127.0.0.1:$API_PORT/v1/register" \
  -H "Content-Type: application/json" \
  -d "{\"token\":\"$AUTH_TOKEN\"}" \
  > "$REGISTER_JSON"

readarray -t REGISTERED < <(python3 - "$REGISTER_JSON" "$CLIENT_KEY_FILE" <<'PY'
import json
import pathlib
import sys

data = json.loads(pathlib.Path(sys.argv[1]).read_text())
pathlib.Path(sys.argv[2]).write_text(data["client_private_key"] + "\n")
print(data["client_address"].split("/")[0])
print(data["server_public_key"])
PY
)

CLIENT_WG_IP="${REGISTERED[0]}"
SERVER_PUBKEY="${REGISTERED[1]}"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Running HTTP smoke test through WireGuard tunnel..."
echo "════════════════════════════════════════════════════════════════"
echo ""

./target/release/wirecage \
  --wg-endpoint "127.0.0.1:$WG_PORT" \
  --wg-public-key "$SERVER_PUBKEY" \
  --wg-private-key-file "$CLIENT_KEY_FILE" \
  --wg-address "$CLIENT_WG_IP" \
  --no-overlay \
  -- curl -fsS --max-time 10 http://example.com

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Test completed!"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Keep server running for manual testing
echo "Server is still running (PID: $SERVER_PID)"
echo "Press Ctrl+C to stop"
wait $SERVER_PID
