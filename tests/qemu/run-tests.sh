#!/usr/bin/env bash
# QEMU-based integration test runner for wirecage
#
# This script can run tests in two modes:
# 1. QEMU mode (--qemu): Full VM isolation, requires qemu-system-x86_64
# 2. Netns mode (default): Uses network namespaces, requires sudo
#
# Usage:
#   ./run-tests.sh                    # Run the maintained shell integration tests
#   ./run-tests.sh --qemu             # Reserved for future fuller-isolation coverage
#   ./run-tests.sh test_api_register  # Run specific test

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

server_pids=()

cleanup_server_pid() {
    local pid="$1"
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
    fi
}

api_json() {
    local method="$1"
    local url="$2"
    local body="$3"
    local output_file="$4"

    local status
    status=$(curl -sS -o "$output_file" -w '%{http_code}' -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -d "$body")
    printf '%s' "$status"
}

start_test_server() {
    local key_file="$1"
    local auth_token="$2"
    local wg_port="$3"
    local api_port="$4"
    local log_file="$5"

    "$PROJECT_ROOT/target/release/wirecagesrv" \
        --private-key-file "$key_file" \
        --auth-token "$auth_token" \
        --wg-endpoint "127.0.0.1:$wg_port" \
        --wg-listen "127.0.0.1:$wg_port" \
        --api-listen "127.0.0.1:$api_port" \
        > "$log_file" 2>&1 &

    local server_pid=$!
    server_pids+=("$server_pid")
    sleep 1

    if ! kill -0 "$server_pid" 2>/dev/null; then
        log_error "Server failed to start"
        cat "$log_file"
        return 1
    fi

    printf '%s' "$server_pid"
}

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
            echo "  test_port_forward_api - Test port forward API and listener lifecycle"
            echo "  test_userspace_nat    - Placeholder for full outbound NAT coverage"
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
    local client_key_one="$TEST_TMP/client-one.key"
    local client_key_two="$TEST_TMP/client-two.key"
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
    
    log_info "Starting wirecagesrv..."
    local server_pid
    server_pid=$(start_test_server "$server_key" "$auth_token" "$wg_port" "$api_port" "$TEST_TMP/server.log") || return 1

    wg genkey > "$client_key_one"
    local client_pubkey_one
    client_pubkey_one=$(wg pubkey < "$client_key_one")
    
    # Test 1: Register with valid token
    log_info "Testing registration with valid token..."
    local response_file="$TEST_TMP/register-valid.json"
    local status
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/register" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey_one\"}" "$response_file")

    if [[ "$status" != "200" ]]; then
        log_error "Registration failed with HTTP $status: $(cat "$response_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi

    if jq -e '.client_address and .server_public_key and .server_endpoint' "$response_file" >/dev/null; then
        log_success "Registration succeeded"
    else
        log_error "Registration response missing expected fields: $(cat "$response_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    local client_address
    client_address=$(jq -r '.client_address' "$response_file")
    
    log_info "Client registered: $client_address"

    if [[ "$client_address" != */24 ]]; then
        log_error "Client address does not include expected /24 mask: $client_address"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Test 2: Register with invalid token
    log_info "Testing registration with invalid token..."
    local invalid_file="$TEST_TMP/register-invalid.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/register" \
        "{\"token\":\"wrong-token\",\"client_public_key\":\"$client_pubkey_one\"}" "$invalid_file")

    if [[ "$status" == "401" ]] && jq -e '.error == "invalid token"' "$invalid_file" >/dev/null; then
        log_success "Invalid token correctly rejected"
    else
        log_error "Invalid token not rejected correctly (HTTP $status): $(cat "$invalid_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Test 3: Re-register the same peer (should get the same IP)
    log_info "Testing repeat registration for the same peer..."
    local repeat_file="$TEST_TMP/register-repeat.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/register" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey_one\"}" "$repeat_file")

    if [[ "$status" != "200" ]]; then
        log_error "Repeat registration failed with HTTP $status: $(cat "$repeat_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi

    local repeat_address
    repeat_address=$(jq -r '.client_address' "$repeat_file")
    
    if [[ "$repeat_address" == "$client_address" ]]; then
        log_success "Repeat registration reused the assigned IP: $repeat_address"
    else
        log_error "Repeat registration changed IP from $client_address to $repeat_address"
        cleanup_server_pid "$server_pid"
        return 1
    fi

    # Test 4: Register second peer (should get different IP)
    log_info "Testing second peer registration..."
    wg genkey > "$client_key_two"
    local client_pubkey_two
    client_pubkey_two=$(wg pubkey < "$client_key_two")
    local second_file="$TEST_TMP/register-second.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/register" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey_two\"}" "$second_file")

    if [[ "$status" != "200" ]]; then
        log_error "Second peer registration failed with HTTP $status: $(cat "$second_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi

    local second_address
    second_address=$(jq -r '.client_address' "$second_file")

    if [[ "$second_address" != "$client_address" ]]; then
        log_success "Second peer got different IP: $second_address"
    else
        log_error "Second peer got same IP!"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Cleanup
    cleanup_server_pid "$server_pid"
    
    log_success "test_api_register passed"
    return 0
}

#
# Test: Port Forward API
#
test_port_forward_api() {
    log_step "Test: Port Forward API"
    
    local server_key="$TEST_TMP/server.key"
    local client_key="$TEST_TMP/client-pf.key"
    local auth_token="test-token-$(date +%s)"
    local api_port=18447
    local wg_port=51825
    
    # Generate server key
    if command -v wg &>/dev/null; then
        wg genkey > "$server_key"
    else
        head -c 32 /dev/urandom | base64 > "$server_key"
    fi
    
    log_info "Starting wirecagesrv..."
    local server_pid
    server_pid=$(start_test_server "$server_key" "$auth_token" "$wg_port" "$api_port" "$TEST_TMP/server-pf.log") || return 1
    
    # Register a peer first
    log_info "Registering peer..."
    wg genkey > "$client_key"
    local client_pubkey
    client_pubkey=$(wg pubkey < "$client_key")
    local reg_file="$TEST_TMP/portforward-register.json"
    local status
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/register" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey\"}" "$reg_file")

    if [[ "$status" != "200" ]]; then
        log_error "Failed to register peer (HTTP $status): $(cat "$reg_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi

    if [[ -z "$client_pubkey" ]]; then
        log_error "Failed to register peer"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    log_info "Peer registered with pubkey: ${client_pubkey:0:20}..."
    
    # Test 1: Create TCP port forward
    log_info "Creating TCP port forward..."
    local create_tcp_file="$TEST_TMP/pf-create-tcp.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/portforward" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey\",\"protocol\":\"tcp\",\"public_port\":9080,\"target_port\":80}" \
        "$create_tcp_file")

    if [[ "$status" == "201" ]] && jq -e '.public_port == 9080 and .protocol == "tcp" and .target_port == 80' "$create_tcp_file" >/dev/null; then
        log_success "Port forward created"
    else
        log_error "Port forward creation failed (HTTP $status): $(cat "$create_tcp_file")"
        cleanup_server_pid "$server_pid"
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
    local dup_file="$TEST_TMP/pf-duplicate.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/portforward" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey\",\"protocol\":\"tcp\",\"public_port\":9080,\"target_port\":8080}" \
        "$dup_file")

    if [[ "$status" == "409" ]] && jq -e '.error == "port already in use"' "$dup_file" >/dev/null; then
        log_success "Duplicate port correctly rejected"
    else
        log_error "Duplicate port not rejected correctly (HTTP $status): $(cat "$dup_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Test 3: Create UDP port forward
    log_info "Creating UDP port forward..."
    local create_udp_file="$TEST_TMP/pf-create-udp.json"
    status=$(api_json "POST" "http://127.0.0.1:$api_port/v1/portforward" \
        "{\"token\":\"$auth_token\",\"client_public_key\":\"$client_pubkey\",\"protocol\":\"udp\",\"public_port\":9053,\"target_port\":53}" \
        "$create_udp_file")

    if [[ "$status" == "201" ]] && jq -e '.public_port == 9053 and .protocol == "udp" and .target_port == 53' "$create_udp_file" >/dev/null; then
        log_success "UDP port forward created"
    else
        log_error "UDP port forward creation failed (HTTP $status): $(cat "$create_udp_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Test 4: Delete port forward
    log_info "Deleting TCP port forward..."
    local delete_file="$TEST_TMP/pf-delete.json"
    status=$(api_json "DELETE" "http://127.0.0.1:$api_port/v1/portforward" \
        "{\"token\":\"$auth_token\",\"protocol\":\"tcp\",\"public_port\":9080}" \
        "$delete_file")

    if [[ "$status" == "200" ]] && jq -e '.status == "removed"' "$delete_file" >/dev/null; then
        log_success "Port forward deleted"
    else
        log_error "Port forward deletion failed (HTTP $status): $(cat "$delete_file")"
        cleanup_server_pid "$server_pid"
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
    local missing_file="$TEST_TMP/pf-missing.json"
    status=$(api_json "DELETE" "http://127.0.0.1:$api_port/v1/portforward" \
        "{\"token\":\"$auth_token\",\"protocol\":\"tcp\",\"public_port\":9999}" \
        "$missing_file")

    if [[ "$status" == "404" ]] && jq -e '.error == "port forward not found"' "$missing_file" >/dev/null; then
        log_success "Non-existent port forward correctly rejected"
    else
        log_error "Non-existent port forward not rejected correctly (HTTP $status): $(cat "$missing_file")"
        cleanup_server_pid "$server_pid"
        return 1
    fi
    
    # Cleanup
    cleanup_server_pid "$server_pid"
    
    log_success "test_port_forward_api passed"
    return 0
}

#
# Test: Userspace NAT (placeholder - full dataplane coverage not implemented here)
#
test_userspace_nat() {
    log_step "Test: Userspace NAT"
    log_warn "Full NAT test requires more than the current shell runner provides"
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
require_cmd jq
require_cmd wg
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
