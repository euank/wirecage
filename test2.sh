#!/usr/bin/env bash
set -ux

./target/release/wirecage --log-level=debug --wg-endpoint "209.251.245.16:51820" --wg-public-key "fHDk+22yah18ytcDFl97kVucKkdhvW3Ykx9qX2DdxUU=" --wg-private-key-file "/home/esk/dev/router.nix/secrets/s" --wg-address "10.101.107.2" -- ping -W 1 -c 1 1.1.1.1 || echo -e "\nPing Fail"

./target/release/wirecage --log-level=debug --wg-endpoint "209.251.245.16:51820" --wg-public-key "fHDk+22yah18ytcDFl97kVucKkdhvW3Ykx9qX2DdxUU=" --wg-private-key-file "/home/esk/dev/router.nix/secrets/s" --wg-address "10.101.107.2" -- curl -m 1 -v  -4 http://example.com || echo -e "\nIpv4 curl Fail"

./target/release/wirecage --log-level=debug --wg-endpoint "209.251.245.16:51820" --wg-public-key "fHDk+22yah18ytcDFl97kVucKkdhvW3Ykx9qX2DdxUU=" --wg-private-key-file "/home/esk/dev/router.nix/secrets/s" --wg-address "10.101.107.2" -- curl -m 1 -v  -6 http://example.com || echo -e "\nIpv6 curl Fail"
