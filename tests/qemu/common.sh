#!/usr/bin/env bash
# Common utilities for QEMU integration tests

set -euo pipefail

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_TMP="${TEST_TMP:-/tmp/wirecage-qemu-test}"
KERNEL_DIR="$TEST_TMP/kernel"
INITRAMFS_DIR="$TEST_TMP/initramfs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $*"; }

# Check if command exists
require_cmd() {
    if ! command -v "$1" &>/dev/null; then
        log_error "Required command not found: $1"
        exit 1
    fi
}

# Download kernel if needed
ensure_kernel() {
    local kernel_path="$KERNEL_DIR/vmlinuz"
    
    if [[ -f "$kernel_path" ]]; then
        return 0
    fi
    
    log_info "Downloading test kernel..."
    mkdir -p "$KERNEL_DIR"
    
    # Use Alpine's kernel - it's small and works well for testing
    local kernel_url="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/netboot/vmlinuz-lts"
    
    if command -v curl &>/dev/null; then
        curl -fsSL -o "$kernel_path" "$kernel_url"
    elif command -v wget &>/dev/null; then
        wget -q -O "$kernel_path" "$kernel_url"
    else
        log_error "Neither curl nor wget available"
        exit 1
    fi
    
    log_success "Kernel downloaded"
}

# Build static binaries for musl target
build_static_binaries() {
    log_info "Building static binaries..."
    
    cd "$PROJECT_ROOT"
    
    # Check if musl target is available
    if ! rustup target list --installed | grep -q x86_64-unknown-linux-musl; then
        log_info "Adding musl target..."
        rustup target add x86_64-unknown-linux-musl
    fi
    
    # Build with musl for static linking
    cargo build --release --target x86_64-unknown-linux-musl --bin wirecage --bin wirecagesrv 2>/dev/null || {
        # Fall back to regular build if musl fails
        log_warn "musl build failed, using regular build"
        cargo build --release --bin wirecage --bin wirecagesrv
    }
    
    log_success "Binaries built"
}

# Create minimal initramfs
create_initramfs() {
    local output="$1"
    local include_server="${2:-false}"
    
    log_info "Creating initramfs..."
    
    local initramfs_work="$INITRAMFS_DIR/work"
    rm -rf "$initramfs_work"
    mkdir -p "$initramfs_work"/{bin,sbin,dev,proc,sys,etc,tmp,run}
    
    # Copy binaries
    local bin_dir="$PROJECT_ROOT/target/x86_64-unknown-linux-musl/release"
    if [[ ! -f "$bin_dir/wirecage" ]]; then
        bin_dir="$PROJECT_ROOT/target/release"
    fi
    
    cp "$bin_dir/wirecage" "$initramfs_work/bin/"
    if [[ "$include_server" == "true" ]]; then
        cp "$bin_dir/wirecagesrv" "$initramfs_work/bin/"
    fi
    
    # Copy busybox for basic utilities (if available)
    if command -v busybox &>/dev/null; then
        cp "$(which busybox)" "$initramfs_work/bin/"
        # Create symlinks for common utilities
        for cmd in sh ash cat echo ls ip ping nc curl sleep mkdir chmod; do
            ln -sf busybox "$initramfs_work/bin/$cmd" 2>/dev/null || true
        done
    fi
    
    # Create init script
    cat > "$initramfs_work/init" << 'INIT_EOF'
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t devtmpfs dev /dev

# Configure network
ip link set lo up

# Run test command from kernel cmdline
TEST_CMD=$(cat /proc/cmdline | sed 's/.*test_cmd="\([^"]*\)".*/\1/')
if [ -n "$TEST_CMD" ]; then
    echo "Running test: $TEST_CMD"
    eval "$TEST_CMD"
    echo "TEST_EXIT_CODE=$?"
fi

# Power off
echo o > /proc/sysrq-trigger
INIT_EOF
    chmod +x "$initramfs_work/init"
    
    # Create initramfs
    (cd "$initramfs_work" && find . | cpio -o -H newc 2>/dev/null | gzip > "$output")
    
    log_success "Initramfs created: $output"
}

# Run QEMU with given initramfs and command
run_qemu() {
    local initramfs="$1"
    local test_cmd="$2"
    local timeout="${3:-30}"
    local output_file="$TEST_TMP/qemu-output.log"
    
    ensure_kernel
    
    log_step "Running QEMU test..."
    
    timeout "$timeout" qemu-system-x86_64 \
        -kernel "$KERNEL_DIR/vmlinuz" \
        -initrd "$initramfs" \
        -append "console=ttyS0 quiet panic=-1 test_cmd=\"$test_cmd\"" \
        -nographic \
        -no-reboot \
        -m 256M \
        -enable-kvm 2>/dev/null || true \
        -net nic,model=virtio \
        -net user,hostfwd=tcp::15820-:51820,hostfwd=tcp::18443-:8443 \
        2>&1 | tee "$output_file"
    
    # Check for test result
    if grep -q "TEST_EXIT_CODE=0" "$output_file"; then
        return 0
    else
        return 1
    fi
}

# Run test in network namespace (simpler alternative to full QEMU)
run_in_netns() {
    local ns_name="$1"
    shift
    
    # Create namespace if it doesn't exist
    if ! ip netns list | grep -q "^$ns_name"; then
        sudo ip netns add "$ns_name"
        sudo ip netns exec "$ns_name" ip link set lo up
    fi
    
    sudo ip netns exec "$ns_name" "$@"
}

# Cleanup
cleanup_test() {
    log_info "Cleaning up..."
    
    # Kill any background processes
    jobs -p 2>/dev/null | xargs -r kill 2>/dev/null || true
    
    # Remove test temp directory (optional, keep for debugging)
    # rm -rf "$TEST_TMP"
}

trap cleanup_test EXIT
