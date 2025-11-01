#!/bin/bash
set -euo pipefail

echo "Building wirecage (Rust version)..."
cargo build --release

echo ""
echo "Build complete!"
echo "Binary location: target/release/wirecage"
echo ""
echo "Usage example:"
echo "  ./target/release/wirecage \\"
echo "    --wg-public-key <SERVER_PUBLIC_KEY> \\"
echo "    --wg-private-key-file <PRIVATE_KEY_FILE> \\"
echo "    --wg-endpoint <SERVER_IP:PORT> \\"
echo "    --wg-address <YOUR_VPN_IP> \\"
echo "    -- ip a"
