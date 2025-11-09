#!/usr/bin/env bash
# Build statically linked binaries for distribution

set -euo pipefail

echo "Building static binaries with musl..."

# Check if musl target is installed
if ! rustup target list | grep -q "x86_64-unknown-linux-musl (installed)"; then
    echo "Installing musl target..."
    rustup target add x86_64-unknown-linux-musl
fi

# Build both binaries
echo "Building wirecagesrv..."
cargo build --release --target x86_64-unknown-linux-musl --bin wirecagesrv

echo "Building wirecage..."
cargo build --release --target x86_64-unknown-linux-musl --bin wirecage

# Create dist directory
mkdir -p dist

# Copy binaries
echo "Copying binaries to dist/..."
cp target/x86_64-unknown-linux-musl/release/wirecagesrv dist/
cp target/x86_64-unknown-linux-musl/release/wirecage dist/

# Strip binaries (already done by profile.release.strip, but ensure)
strip dist/wirecagesrv 2>/dev/null || true
strip dist/wirecage 2>/dev/null || true

# Create README if not exists
if [ ! -f dist/README.md ]; then
    cat > dist/README.md <<'EOF'
# WireCage - Static Binaries

Statically linked x86_64 Linux binaries - portable across distributions!

See main repository for full documentation.
EOF
fi

# Create tarball
echo "Creating tarball..."
cd dist
tar czf wirecage-static-x86_64-linux.tar.gz wirecage wirecagesrv README.md
cd ..

# Generate checksums
echo "Generating checksums..."
sha256sum dist/wirecage-static-x86_64-linux.tar.gz dist/wirecagesrv dist/wirecage > dist/SHA256SUMS

echo ""
echo "✓ Build complete!"
echo ""
echo "Distribution files in dist/:"
ls -lh dist/
echo ""
echo "Verify static linking:"
ldd dist/wirecagesrv || echo "  wirecagesrv: statically linked ✓"
ldd dist/wirecage || echo "  wirecage: statically linked ✓"
echo ""
echo "SHA256 checksums:"
cat dist/SHA256SUMS
