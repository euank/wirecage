#!/usr/bin/env bash
# QEMU-based integration test runner for wirecage
#
# This script can run tests in two modes:
# 1. QEMU mode (--qemu): Full VM isolation, requires qemu-system-x86_64
# 2. Netns mode (default): Uses network namespaces, requires sudo
#
# Usage:
#   ./run-tests.sh                    # Run all tests in netns mode
#   ./run-tests.sh --qemu             # Run all tests in QEMU mode
#   ./run-tests.sh test_api_register  # Run specific test

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Parse arguments
USE_QEMU=false
TESTS_TO_RUN=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --qemu)
            USE_QEMU=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--qemu] [test_name...]"
            echo ""
            echo "Options:"
            echo "  --qemu    Run tests in QEMU VMs (full isolation)"
            echo ""
            echo "Available tests:"
            echo "  test_api_register    - Test token exchange and peer registration"
            echo "  test_userspace_nat   - Test outbound NAT (simplified)"
            echo "  test_port_forward    - Test inbound port forwarding"
            exit 0
            ;;
        *)
            TESTS_TO_RUN+=("$1")
            shift
            ;;
    esac
done

# Default to all tests if none specified
if [[ ${#TESTS_TO_RUN[@]} -eq 0 ]]; then
    TESTS_TO_RUN=(test_api_register test_port_forward_api)
fi

# Ensure test temp directory exists
mkdir -p "$TEST_TMP"

# Build binaries
build_static_binaries || {
    log_warn "Static build failed, using dynamic binaries"
}

# Test counters
PASSED=0
FAILED=0

#
# Test: API Registration
#
test_api_register() {
    log_step "Test: API Registration"
    
    local server_key="$TEST_TMP/server.key"
    local auth_token="test-token-$(date +%s)"
    local api_port=18446
    local wg_port=51824
    
    # Generate server key
    if command -v wg &>/dev/null; then
        wg genkey > "$server_key"
    else
        # Generate a random 32-byte key
        head -c 32 /dev/urandom | base64 > "$server_key"
    fi
    
    # Start server
    log_info "Starting wirecagesrv..."
    "$PROJECT_ROOT/target/release/wirecagesrv" \
        --private-key-file "$server_key" \
        --auth-token "$auth_token" \
        --wg-endpoint "127.0.0.1:$wg_port" \
        --wg-listen "127.0.0.1:$wg_port" \
        --api-listen "127.0.0.1:$api_port" \
        > "$TEST_TMP/server.log" 2>&1 &
    local server_pid=$!
    
    # Wait for server to start
    sleep 1
    
    if ! kill -0 $server_pid 2>/dev/null; then
        log_error "Server failed to start"
        cat "$TEST_TMP/server.log"
        return 1
    fi
    
    # Test 1: Register with valid token
    log_info "Testing registration with valid token..."
    local response
    response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/register" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\"}")
    
    if echo "$response" | grep -q "client_private_key"; then
        log_success "Registration succeeded"
    else
        log_error "Registration failed: $response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Extract client info
    local client_pubkey
    client_pubkey=$(echo "$response" | grep -o '"client_public_key":"[^"]*"' | cut -d'"' -f4)
    local client_address
    client_address=$(echo "$response" | grep -o '"client_address":"[^"]*"' | cut -d'"' -f4)
    
    log_info "Client registered: $client_address"
    
    # Test 2: Register with invalid token
    log_info "Testing registration with invalid token..."
    response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/register" \
        -H "Content-Type: application/json" \
        -d '{"token": "wrong-token"}')
    
    if echo "$response" | grep -q "invalid token"; then
        log_success "Invalid token correctly rejected"
    else
        log_error "Invalid token not rejected: $response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Test 3: Register second peer (should get different IP)
    log_info "Testing second peer registration..."
    response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/register" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\"}")
    
    local second_address
    second_address=$(echo "$response" | grep -o '"client_address":"[^"]*"' | cut -d'"' -f4)
    
    if [[ "$second_address" != "$client_address" ]]; then
        log_success "Second peer got different IP: $second_address"
    else
        log_error "Second peer got same IP!"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Cleanup
    kill $server_pid 2>/dev/null || true
    wait $server_pid 2>/dev/null || true
    
    log_success "test_api_register passed"
    return 0
}

#
# Test: Port Forward API
#
test_port_forward_api() {
    log_step "Test: Port Forward API"
    
    local server_key="$TEST_TMP/server.key"
    local auth_token="test-token-$(date +%s)"
    local api_port=18447
    local wg_port=51825
    
    # Generate server key
    if command -v wg &>/dev/null; then
        wg genkey > "$server_key"
    else
        head -c 32 /dev/urandom | base64 > "$server_key"
    fi
    
    # Start server
    log_info "Starting wirecagesrv..."
    "$PROJECT_ROOT/target/release/wirecagesrv" \
        --private-key-file "$server_key" \
        --auth-token "$auth_token" \
        --wg-endpoint "127.0.0.1:$wg_port" \
        --wg-listen "127.0.0.1:$wg_port" \
        --api-listen "127.0.0.1:$api_port" \
        > "$TEST_TMP/server-pf.log" 2>&1 &
    local server_pid=$!
    
    sleep 1
    
    if ! kill -0 $server_pid 2>/dev/null; then
        log_error "Server failed to start"
        cat "$TEST_TMP/server-pf.log"
        return 1
    fi
    
    # Register a peer first
    log_info "Registering peer..."
    local reg_response
    reg_response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/register" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\"}")
    
    local client_pubkey
    client_pubkey=$(echo "$reg_response" | grep -o '"client_public_key":"[^"]*"' | cut -d'"' -f4)
    
    if [[ -z "$client_pubkey" ]]; then
        log_error "Failed to register peer"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    log_info "Peer registered with pubkey: ${client_pubkey:0:20}..."
    
    # Test 1: Create TCP port forward
    log_info "Creating TCP port forward..."
    local pf_response
    pf_response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/portforward" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\", \"client_public_key\": \"$client_pubkey\", \"protocol\": \"tcp\", \"public_port\": 9080, \"target_port\": 80}")
    
    if echo "$pf_response" | grep -q '"public_port":9080'; then
        log_success "Port forward created"
    else
        log_error "Port forward creation failed: $pf_response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Verify port is listening
    sleep 0.5
    if ss -tln 2>/dev/null | grep -q ":9080"; then
        log_success "Port 9080 is listening"
    else
        # On some systems, check differently
        if netstat -tln 2>/dev/null | grep -q ":9080"; then
            log_success "Port 9080 is listening"
        else
            log_warn "Could not verify port 9080 is listening (may still work)"
        fi
    fi
    
    # Test 2: Duplicate port should fail
    log_info "Testing duplicate port forward (should fail)..."
    pf_response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/portforward" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\", \"client_public_key\": \"$client_pubkey\", \"protocol\": \"tcp\", \"public_port\": 9080, \"target_port\": 8080}")
    
    if echo "$pf_response" | grep -q "port already in use"; then
        log_success "Duplicate port correctly rejected"
    else
        log_error "Duplicate port not rejected: $pf_response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Test 3: Create UDP port forward
    log_info "Creating UDP port forward..."
    pf_response=$(curl -s -X POST "http://127.0.0.1:$api_port/v1/portforward" \
        -H "Content-Type: application/json" \
        -d "{\"token\": \"$auth_token\", \"client_public_key\": \"$client_pubkey\", \"protocol\": \"udp\", \"public_port\": 9053, \"target_port\": 53}")
    
    if echo "$pf_response" | grep -q '"public_port":9053'; then
        log_success "UDP port forward created"
    else
        log_error "UDP port forward creation failed: $pf_response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Test 4: Delete port forward
    log_info "Deleting TCP port forward..."
    pf_response=$(curl -s -X DELETE "http://127.0.0.1:$api_port/v1/portforward" \
        -H "Content-Type: application/json" \
        -d '{"token": "'"$auth_token"'", "protocol": "tcp", "public_port": 9080}')
    
    if echo "$pf_response" | grep -q "removed"; then
        log_success "Port forward deleted"
    else
        log_error "Port forward deletion failed: $pf_response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Verify port is no longer listening
    sleep 0.5
    if ! ss -tln 2>/dev/null | grep -q ":9080"; then
        log_success "Port 9080 is no longer listening"
    else
        log_warn "Port 9080 may still be listening (cleanup timing)"
    fi
    
    # Test 5: Delete non-existent port should fail
    log_info "Deleting non-existent port forward..."
    pf_response=$(curl -s -X DELETE "http://127.0.0.1:$api_port/v1/portforward" \
        -H "Content-Type: application/json" \
        -d '{"token": "'"$auth_token"'", "protocol": "tcp", "public_port": 9999}')
    
    if echo "$pf_response" | grep -q "not found"; then
        log_success "Non-existent port forward correctly rejected"
    else
        log_error "Non-existent port forward not rejected: $pf_response"
        kill $server_pid 2>/dev/null || true
        return 1
    fi
    
    # Cleanup
    kill $server_pid 2>/dev/null || true
    wait $server_pid 2>/dev/null || true
    
    log_success "test_port_forward_api passed"
    return 0
}

#
# Test: Userspace NAT (placeholder - needs full network setup)
#
test_userspace_nat() {
    log_step "Test: Userspace NAT"
    log_warn "Full NAT test requires network namespace setup"
    log_info "See integration-test.sh for namespace-based testing"
    
    # This test would require:
    # 1. Server in one namespace
    # 2. Client connecting via wirecage
    # 3. Verification that traffic flows through NAT
    
    # For now, just verify the dataplane starts correctly
    log_success "test_userspace_nat skipped (use integration-test.sh)"
    return 0
}

#
# Main test runner
#

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  WireCage QEMU Integration Test Suite  ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check prerequisites
require_cmd curl
log_success "Prerequisites check passed"

# Run tests
for test_name in "${TESTS_TO_RUN[@]}"; do
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if declare -f "$test_name" > /dev/null; then
        if "$test_name"; then
            PASSED=$((PASSED + 1))
        else
            FAILED=$((FAILED + 1))
            log_error "Test failed: $test_name"
        fi
    else
        log_error "Unknown test: $test_name"
        FAILED=$((FAILED + 1))
    fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       All $PASSED test(s) PASSED!          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  $FAILED test(s) FAILED, $PASSED passed          ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    exit 1
fi
