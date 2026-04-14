#!/usr/bin/env bash
# Host-local end-to-end smoke test for the named-server client UX.
#
# This test:
# 1. Starts wirecagesrv on the host
# 2. Uses `wirecage add-server` to create a local TOML config
# 3. Uses `wirecage run <name>` to auto-register and jail commands
# 4. Verifies outbound HTTP/TCP connectivity through the VPN dataplane
# 5. Verifies end-to-end TCP port forwarding back to a client-side service

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVER_NAME="test-server"
TEST_CONFIG_HOME="/tmp/wirecage-config-home"
SERVER_PRIVKEY_FILE="/tmp/wirecage-test-server.key"
AUTH_TOKEN="wirecage-test-token"
WG_SERVER_PORT="51820"
API_PORT="18443"
SERVER_HTTP_PORT="18080"
FORWARD_PORT="19080"
CLIENT_SERVICE_PORT="8081"
HOST_TEST_IP=""
WIRECAGE_CLIENT_KEY=""
WIRECAGE_CLIENT_PUBKEY=""

cleanup() {
    echo -e "${YELLOW}Cleaning up...${NC}"

    if [ -f /tmp/wirecagesrv.pid ]; then
        kill "$(cat /tmp/wirecagesrv.pid)" 2>/dev/null || true
        wait "$(cat /tmp/wirecagesrv.pid)" 2>/dev/null || true
        rm -f /tmp/wirecagesrv.pid
    fi

    if [ -f /tmp/wirecage-client.pid ]; then
        kill "$(cat /tmp/wirecage-client.pid)" 2>/dev/null || true
        wait "$(cat /tmp/wirecage-client.pid)" 2>/dev/null || true
        rm -f /tmp/wirecage-client.pid
    fi

    if [ -f /tmp/wirecage-server-http.pid ]; then
        kill "$(cat /tmp/wirecage-server-http.pid)" 2>/dev/null || true
        wait "$(cat /tmp/wirecage-server-http.pid)" 2>/dev/null || true
        rm -f /tmp/wirecage-server-http.pid
    fi

    jobs -p | xargs -r kill 2>/dev/null || true
    wait 2>/dev/null || true

    rm -rf "$TEST_CONFIG_HOME"
    rm -f "$SERVER_PRIVKEY_FILE"
    rm -f /tmp/wirecagesrv.log /tmp/test-http.log /tmp/test-tcp.log /tmp/test-forward.log
    rm -f /tmp/wirecage-client.log /tmp/wirecage-client-prime.log /tmp/wirecage-client-ready /tmp/pf-response.json
    rm -rf /tmp/wirecage-server-www

    echo -e "${YELLOW}Cleanup complete${NC}"
}

trap cleanup EXIT INT TERM

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_fail() { echo -e "${RED}[✗]${NC} $1"; }

dump_diagnostics() {
    echo "  wirecagesrv log:"
    sed -n '1,220p' /tmp/wirecagesrv.log 2>/dev/null | sed 's/^/    /' || true
    echo "  wirecage client log:"
    sed -n '1,220p' /tmp/wirecage-client.log 2>/dev/null | sed 's/^/    /' || true
    echo "  wirecage client prime log:"
    sed -n '1,120p' /tmp/wirecage-client-prime.log 2>/dev/null | sed 's/^/    /' || true
}

wc_cmd() {
    XDG_CONFIG_HOME="$TEST_CONFIG_HOME" ./target/release/wirecage "$@"
}

check_prerequisites() {
    log_info "Checking prerequisites..."

    if [ ! -f "./target/release/wirecage" ]; then
        log_error "wirecage binary not found. Run: cargo build --release"
        exit 1
    fi

    if [ ! -f "./target/release/wirecagesrv" ]; then
        log_error "wirecagesrv binary not found. Run: cargo build --release"
        exit 1
    fi

    for cmd in wg curl python3 nc jq ip grep; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done

    log_success "Prerequisites check passed"
}

detect_host_test_ip() {
    log_info "Detecting a non-loopback host IP for dataplane tests..."
    HOST_TEST_IP="$(ip route get 1.1.1.1 | sed -n 's/.* src \([0-9.]*\).*/\1/p' | head -n1)"

    if [ -z "$HOST_TEST_IP" ]; then
        log_error "Could not determine a non-loopback host IP"
        exit 1
    fi

    log_success "Using host IP $HOST_TEST_IP for smoke tests"
}

generate_server_key() {
    log_info "Generating server WireGuard key..."
    umask 077
    wg genkey > "$SERVER_PRIVKEY_FILE"
    chmod 600 "$SERVER_PRIVKEY_FILE"
    log_success "Server key generated"
}

start_server() {
    log_info "Starting wirecagesrv on the host..."

    ./target/release/wirecagesrv \
        --private-key-file "$SERVER_PRIVKEY_FILE" \
        --auth-token "$AUTH_TOKEN" \
        --wg-endpoint "127.0.0.1:$WG_SERVER_PORT" \
        --wg-listen "127.0.0.1:$WG_SERVER_PORT" \
        --api-listen "127.0.0.1:$API_PORT" \
        > /tmp/wirecagesrv.log 2>&1 &

    echo $! > /tmp/wirecagesrv.pid
    sleep 2

    if ! kill -0 "$(cat /tmp/wirecagesrv.pid)" 2>/dev/null; then
        log_error "wirecagesrv failed to start"
        cat /tmp/wirecagesrv.log
        exit 1
    fi

    log_success "wirecagesrv started (PID: $(cat /tmp/wirecagesrv.pid))"
}

configure_named_server() {
    log_info "Writing the local WireCage config through add-server..."
    rm -rf "$TEST_CONFIG_HOME"

    wc_cmd add-server "$SERVER_NAME" "http://127.0.0.1:$API_PORT" --token "$AUTH_TOKEN" >/tmp/wirecage-add-server.log 2>&1

    local config_file="$TEST_CONFIG_HOME/wirecage/config.toml"
    if [ ! -f "$config_file" ]; then
        log_error "Expected config file was not created"
        cat /tmp/wirecage-add-server.log
        exit 1
    fi

    if grep -q '\[servers.test-server\]' "$config_file" && grep -q "api_url = \"http://127.0.0.1:$API_PORT\"" "$config_file"; then
        log_success "Named server config written to $config_file"
    else
        log_error "Config file did not contain the expected server entry"
        cat "$config_file"
        exit 1
    fi
}

discover_client_key() {
    WIRECAGE_CLIENT_KEY="$TEST_CONFIG_HOME/wirecage/keys/${SERVER_NAME}.key"
    if [ ! -f "$WIRECAGE_CLIENT_KEY" ]; then
        log_error "Expected client key was not created at $WIRECAGE_CLIENT_KEY"
        exit 1
    fi

    WIRECAGE_CLIENT_PUBKEY="$(wg pubkey < "$WIRECAGE_CLIENT_KEY")"
    if [ -z "$WIRECAGE_CLIENT_PUBKEY" ]; then
        log_error "Failed to derive client public key"
        exit 1
    fi
}

start_server_http_service() {
    log_info "Starting host-side HTTP service for outbound dataplane tests..."

    mkdir -p /tmp/wirecage-server-www
    echo "<h1>WireCage Test Server</h1><p>Connection successful!</p>" > /tmp/wirecage-server-www/index.html

    python3 -m http.server "$SERVER_HTTP_PORT" --bind "$HOST_TEST_IP" -d /tmp/wirecage-server-www >/tmp/wirecage-server-http.log 2>&1 &
    echo $! > /tmp/wirecage-server-http.pid
    sleep 2

    if ! kill -0 "$(cat /tmp/wirecage-server-http.pid)" 2>/dev/null; then
        log_error "Host-side HTTP service failed to start"
        cat /tmp/wirecage-server-http.log
        exit 1
    fi

    log_success "Host-side HTTP service started on $HOST_TEST_IP:$SERVER_HTTP_PORT"
}

start_client_service() {
    log_info "Starting client-side TCP responder under wirecage..."

    wc_cmd run "$SERVER_NAME" -- bash -lc "
        set -euo pipefail
        python3 - <<'PY' >/tmp/wirecage-client-http.log 2>&1 &
import socket
import time

listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
listener.bind(('0.0.0.0', $CLIENT_SERVICE_PORT))
listener.listen(5)

while True:
    conn, _ = listener.accept()
    with conn:
        conn.settimeout(5)
        try:
            conn.recv(4096)
        except Exception:
            pass
        conn.sendall(b'PORT_FORWARD_OK\n')
        time.sleep(1)
PY
        server_pid=\$!
        trap 'kill \$server_pid 2>/dev/null || true' EXIT
        for _ in \$(seq 1 20); do
            if nc -z -w 2 $HOST_TEST_IP $SERVER_HTTP_PORT >/tmp/wirecage-client-prime.log 2>&1; then
                echo ready >/tmp/wirecage-client-ready
                wait \$server_pid
                exit 0
            fi
            sleep 1
        done
        echo 'Failed to prime client tunnel' >&2
        exit 1
    " > /tmp/wirecage-client.log 2>&1 &

    echo $! > /tmp/wirecage-client.pid

    for _ in $(seq 1 20); do
        if [ -f /tmp/wirecage-client-ready ]; then
            break
        fi
        if ! kill -0 "$(cat /tmp/wirecage-client.pid)" 2>/dev/null; then
            log_error "Client-side service exited while priming"
            cat /tmp/wirecage-client.log
            exit 1
        fi
        sleep 1
    done

    if [ ! -f /tmp/wirecage-client-ready ]; then
        log_error "Client-side service failed to establish the tunnel"
        cat /tmp/wirecage-client.log
        cat /tmp/wirecage-client-prime.log 2>/dev/null || true
        exit 1
    fi

    discover_client_key
    log_success "Client-side service is running"
}

create_port_forward() {
    log_info "Creating end-to-end TCP port forward..."
    local status

    status=$(curl -sS -o /tmp/pf-response.json -w '%{http_code}' -X POST "http://127.0.0.1:$API_PORT/v1/portforward" \
        -H "Content-Type: application/json" \
        -d "{\"token\":\"$AUTH_TOKEN\",\"client_public_key\":\"$WIRECAGE_CLIENT_PUBKEY\",\"protocol\":\"tcp\",\"public_port\":$FORWARD_PORT,\"target_port\":$CLIENT_SERVICE_PORT}")

    if [[ "$status" != "201" ]]; then
        log_error "Failed to create port forward (HTTP $status)"
        cat /tmp/pf-response.json
        exit 1
    fi

    if ! jq -e ".public_port == $FORWARD_PORT and .target_port == $CLIENT_SERVICE_PORT and .protocol == \"tcp\"" /tmp/pf-response.json >/dev/null; then
        log_error "Unexpected port-forward response"
        cat /tmp/pf-response.json
        exit 1
    fi

    sleep 1
    log_success "TCP port forward created"
}

run_tests() {
    log_info "Running host-local smoke tests..."
    local failures=0

    echo ""
    log_info "Test 1: HTTP GET via wirecage run $SERVER_NAME"
    if timeout 20 env XDG_CONFIG_HOME="$TEST_CONFIG_HOME" ./target/release/wirecage run "$SERVER_NAME" -- curl -fsS --max-time 5 "http://$HOST_TEST_IP:$SERVER_HTTP_PORT/" > /tmp/test-http.log 2>&1; then
        log_success "HTTP test passed"
        head -5 /tmp/test-http.log | sed 's/^/  /'
    else
        log_fail "HTTP test failed"
        cat /tmp/test-http.log | sed 's/^/  /'
        failures=$((failures + 1))
    fi

    discover_client_key

    echo ""
    log_info "Test 2: Raw TCP request via wirecage run $SERVER_NAME"
    if timeout 20 env XDG_CONFIG_HOME="$TEST_CONFIG_HOME" ./target/release/wirecage run "$SERVER_NAME" -- bash -c "printf 'GET / HTTP/1.0\r\nHost: test\r\n\r\n' | nc -w 2 $HOST_TEST_IP $SERVER_HTTP_PORT" > /tmp/test-tcp.log 2>&1; then
        log_success "TCP connectivity test passed"
        head -5 /tmp/test-tcp.log | sed 's/^/  /'
    else
        log_fail "TCP connectivity test failed"
        cat /tmp/test-tcp.log | sed 's/^/  /'
        failures=$((failures + 1))
    fi

    echo ""
    start_client_service
    create_port_forward

    echo ""
    log_info "Test 3: End-to-end TCP port forward via $HOST_TEST_IP:$FORWARD_PORT"
    if bash -lc "printf 'ping\n' | nc -w 5 $HOST_TEST_IP $FORWARD_PORT" > /tmp/test-forward.log 2>&1; then
        if grep -q "PORT_FORWARD_OK" /tmp/test-forward.log; then
            log_success "Port-forward connectivity test passed"
            head -5 /tmp/test-forward.log | sed 's/^/  /'
        else
            log_fail "Port-forward response did not match expected client content"
            cat /tmp/test-forward.log | sed 's/^/  /'
            dump_diagnostics
            failures=$((failures + 1))
        fi
    else
        log_fail "Port-forward connectivity test failed"
        cat /tmp/test-forward.log | sed 's/^/  /'
        dump_diagnostics
        failures=$((failures + 1))
    fi

    echo ""
    if [ "$failures" -eq 0 ]; then
        log_success "All smoke tests passed"
        return 0
    fi

    log_fail "$failures smoke test(s) failed"
    return 1
}

main() {
    echo ""
    echo "======================================"
    echo "  WireCage Host-Local Smoke Test"
    echo "======================================"
    echo ""

    check_prerequisites
    detect_host_test_ip
    generate_server_key
    start_server
    configure_named_server
    start_server_http_service

    echo ""
    echo "======================================"
    echo "  Running Tests"
    echo "======================================"

    if run_tests; then
        echo ""
        echo -e "${GREEN}╔════════════════════════════════╗${NC}"
        echo -e "${GREEN}║     Smoke Tests PASSED!       ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════╝${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}╔════════════════════════════════╗${NC}"
        echo -e "${RED}║     Smoke Tests FAILED!       ║${NC}"
        echo -e "${RED}╚════════════════════════════════╝${NC}"
        exit 1
    fi
}

main
