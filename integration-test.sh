#!/usr/bin/env bash
# Integration test for wirecage
# Sets up a local WireGuard server in a network namespace and tests connectivity

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test configuration
SERVER_NS="wirecage-test-server"
CLIENT_PRIVKEY_FILE="/tmp/wirecage-test-client.key"
SERVER_PRIVKEY_FILE="/tmp/wirecage-test-server.key"
SERVER_PUBKEY_FILE="/tmp/wirecage-test-server.pub"
CLIENT_PUBKEY_FILE="/tmp/wirecage-test-client.pub"
WG_SERVER_IP="10.200.100.1"
WG_CLIENT_IP="10.200.100.2"
WG_SERVER_PORT="51820"
SERVER_VETH="veth-srv"
HOST_VETH="veth-host"
HOST_VETH_IP="192.168.100.1"
SERVER_VETH_IP="192.168.100.2"

# Cleanup function
cleanup() {
    echo -e "${YELLOW}Cleaning up...${NC}"
    
    # Kill wirecagesrv
    if [ -f /tmp/wirecagesrv.pid ]; then
        sudo kill $(cat /tmp/wirecagesrv.pid) 2>/dev/null || true
        rm -f /tmp/wirecagesrv.pid
    fi
    
    # Kill background processes
    jobs -p | xargs -r kill 2>/dev/null || true
    wait 2>/dev/null || true
    
    # Delete network namespace
    sudo ip netns del "$SERVER_NS" 2>/dev/null || true
    
    # Clean up veth pairs
    sudo ip link del "$HOST_VETH" 2>/dev/null || true
    
    # Remove temporary files
    rm -f "$CLIENT_PRIVKEY_FILE" "$SERVER_PRIVKEY_FILE" "$SERVER_PUBKEY_FILE" "$CLIENT_PUBKEY_FILE"
    rm -f /tmp/wg-test.conf /tmp/wirecagesrv.log
    
    echo -e "${YELLOW}Cleanup complete${NC}"
}

# Set up cleanup trap
trap cleanup EXIT INT TERM

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_fail() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check prerequisites
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
    
    if ! command -v wg &> /dev/null; then
        log_error "wg command not found. Install wireguard-tools"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Generate WireGuard keys
generate_keys() {
    log_info "Generating WireGuard keys..."
    
    # Generate server keys
    wg genkey > "$SERVER_PRIVKEY_FILE"
    wg pubkey < "$SERVER_PRIVKEY_FILE" > "$SERVER_PUBKEY_FILE"
    
    # Generate client keys
    wg genkey > "$CLIENT_PRIVKEY_FILE"
    wg pubkey < "$CLIENT_PRIVKEY_FILE" > "$CLIENT_PUBKEY_FILE"
    
    chmod 600 "$SERVER_PRIVKEY_FILE" "$CLIENT_PRIVKEY_FILE"
    
    log_success "Keys generated"
}

# Set up server network namespace
setup_server_namespace() {
    log_info "Setting up server network namespace..."
    
    # Create namespace
    sudo ip netns add "$SERVER_NS"
    
    # Create veth pair to connect host and server namespace
    sudo ip link add "$HOST_VETH" type veth peer name "$SERVER_VETH"
    
    # Move server end to namespace
    sudo ip link set "$SERVER_VETH" netns "$SERVER_NS"
    
    # Configure host end
    sudo ip addr add "$HOST_VETH_IP/24" dev "$HOST_VETH"
    sudo ip link set "$HOST_VETH" up
    
    # Configure server end inside namespace
    sudo ip netns exec "$SERVER_NS" ip addr add "$SERVER_VETH_IP/24" dev "$SERVER_VETH"
    sudo ip netns exec "$SERVER_NS" ip link set "$SERVER_VETH" up
    sudo ip netns exec "$SERVER_NS" ip link set lo up
    
    log_success "Server namespace created"
}

# Set up WireGuard server using wirecagesrv
setup_wireguard_server() {
    log_info "Setting up WireGuard server (wirecagesrv)..."
    
    local client_pubkey=$(cat "$CLIENT_PUBKEY_FILE")
    
    # Start wirecagesrv in the server namespace
    sudo ip netns exec "$SERVER_NS" \
        ./target/release/wirecagesrv \
        --private-key-file "$SERVER_PRIVKEY_FILE" \
        --listen-addr "$SERVER_VETH_IP:$WG_SERVER_PORT" \
        --subnet "$WG_SERVER_IP" \
        --subnet-cidr "10.200.100.0/24" \
        --tun-name wg-srv \
        --peer "$client_pubkey,$WG_CLIENT_IP/32" \
        > /tmp/wirecagesrv.log 2>&1 &
    
    echo $! > /tmp/wirecagesrv.pid
    
    # Give server time to start
    sleep 2
    
    if ! kill -0 $(cat /tmp/wirecagesrv.pid) 2>/dev/null; then
        log_error "wirecagesrv failed to start"
        cat /tmp/wirecagesrv.log
        return 1
    fi
    
    log_success "WireGuard server started (PID: $(cat /tmp/wirecagesrv.pid))"
    
    # Verify server is running
    echo "  Server log:"
    head -10 /tmp/wirecagesrv.log | sed 's/^/    /'
}

# Start test HTTP server in server namespace
start_http_server() {
    log_info "Starting HTTP server in server namespace..."
    
    # Create a test directory with content
    mkdir -p /tmp/wirecage-www
    echo "<h1>WireCage Test Server</h1><p>Connection successful!</p>" > /tmp/wirecage-www/index.html
    
    # Start a simple HTTP server on port 8080 in the server namespace
    # Bind to 0.0.0.0 since the WG interface might take a moment to be fully ready
    sudo ip netns exec "$SERVER_NS" sh -c "cd /tmp/wirecage-www && python3 -m http.server 8080 --bind 0.0.0.0" >/dev/null 2>&1 &
    
    # Give it time to start
    sleep 2
    
    # Verify it's running
    if sudo ip netns exec "$SERVER_NS" ss -tuln | grep -q ":8080"; then
        log_success "HTTP server started and listening on port 8080"
    else
        log_error "HTTP server failed to start"
        # Try to see what went wrong
        sudo ip netns exec "$SERVER_NS" ss -tuln
        return 1
    fi
}

# Run connectivity tests
run_tests() {
    log_info "Running connectivity tests..."
    
    local server_pubkey=$(cat "$SERVER_PUBKEY_FILE")
    local server_endpoint="$SERVER_VETH_IP:$WG_SERVER_PORT"  # Connect to the server namespace IP, not host
    local failures=0
    
    # Pre-flight check: Can we reach the WireGuard server endpoint?
    echo ""
    log_info "Pre-flight: Testing connectivity to $server_endpoint"
    if nc -uz -w 1 $SERVER_VETH_IP $WG_SERVER_PORT 2>/dev/null; then
        log_success "UDP port $WG_SERVER_PORT is reachable"
    else
        log_fail "Cannot reach UDP port $WG_SERVER_PORT - WireGuard server may not be accessible"
    fi
    
    # Test 1: Ping
    echo ""
    log_info "Test 1: Ping $WG_SERVER_IP"
    if timeout 10 ./target/release/wirecage \
        --log-level=debug \
        --wg-endpoint "$server_endpoint" \
        --wg-public-key "$server_pubkey" \
        --wg-private-key-file "$CLIENT_PRIVKEY_FILE" \
        --wg-address "$WG_CLIENT_IP" \
        --no-overlay \
        -- ping -W 2 -c 3 "$WG_SERVER_IP" > /tmp/test-ping.log 2>&1; then
        log_success "Ping test passed"
        echo "  Sample output:"
        tail -3 /tmp/test-ping.log | sed 's/^/  /'
    else
        log_fail "Ping test failed"
        echo "  Output:"
        tail -10 /tmp/test-ping.log | sed 's/^/  /'
        echo "  WireGuard server status:"
        sudo ip netns exec "$SERVER_NS" wg show wg-test | sed 's/^/  /'
        failures=$((failures + 1))
    fi
    
    # Test 2: HTTP connectivity
    echo ""
    log_info "Test 2: HTTP GET to http://$WG_SERVER_IP:8080"
    if timeout 5 ./target/release/wirecage \
        --log-level=info \
        --wg-endpoint "$server_endpoint" \
        --wg-public-key "$server_pubkey" \
        --wg-private-key-file "$CLIENT_PRIVKEY_FILE" \
        --wg-address "$WG_CLIENT_IP" \
        --no-overlay \
        -- curl -s -m 2 "http://$WG_SERVER_IP:8080/" > /tmp/test-http.log 2>&1; then
        log_success "HTTP test passed"
        echo "  Response preview:"
        head -5 /tmp/test-http.log | sed 's/^/  /'
    else
        log_fail "HTTP test failed"
        echo "  Output:"
        cat /tmp/test-http.log | sed 's/^/  /'
        failures=$((failures + 1))
    fi
    
    # Test 3: TCP connectivity (nc/telnet style)
    echo ""
    log_info "Test 3: TCP connection to $WG_SERVER_IP:8080"
    if timeout 5 ./target/release/wirecage \
        --log-level=info \
        --wg-endpoint "$server_endpoint" \
        --wg-public-key "$server_pubkey" \
        --wg-private-key-file "$CLIENT_PRIVKEY_FILE" \
        --wg-address "$WG_CLIENT_IP" \
        --no-overlay \
        -- bash -c "echo -e 'GET / HTTP/1.0\r\n\r\n' | nc -w 2 $WG_SERVER_IP 8080" > /tmp/test-tcp.log 2>&1; then
        log_success "TCP connection test passed"
        echo "  Response preview:"
        head -3 /tmp/test-tcp.log | sed 's/^/  /'
    else
        log_fail "TCP connection test failed"
        echo "  Output:"
        cat /tmp/test-tcp.log | sed 's/^/  /'
        failures=$((failures + 1))
    fi
    
    echo ""
    if [ $failures -eq 0 ]; then
        log_success "All tests passed! ✓"
        return 0
    else
        log_fail "$failures test(s) failed"
        return 1
    fi
}

# Main execution
main() {
    echo ""
    echo "======================================"
    echo "  WireCage Integration Test Suite"
    echo "======================================"
    echo ""
    
    check_prerequisites
    generate_keys
    setup_server_namespace
    setup_wireguard_server
    start_http_server
    
    echo ""
    echo "======================================"
    echo "  Running Tests"
    echo "======================================"
    
    if run_tests; then
        echo ""
        echo -e "${GREEN}╔════════════════════════════════╗${NC}"
        echo -e "${GREEN}║   Integration Tests PASSED!   ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════╝${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}╔════════════════════════════════╗${NC}"
        echo -e "${RED}║   Integration Tests FAILED!   ║${NC}"
        echo -e "${RED}╚════════════════════════════════╝${NC}"
        exit 1
    fi
}

# Run main
main
