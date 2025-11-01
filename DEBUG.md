# Debugging Wirecage Network Traffic

## Enable Debug Logging

Run with debug logging:
```bash
RUST_LOG=debug ./target/release/wirecage ... -- <command>
```

Or even more verbose:
```bash
RUST_LOG=trace ./target/release/wirecage ... -- <command>
```

## Check Network Stack

### 1. Verify TUN Device Exists and is UP
```bash
./target/release/wirecage ... -- ip link show wirecage
```

Should show: `state UP`

### 2. Check Routing Table
```bash
./target/release/wirecage ... -- ip route
```

Should show default route via wirecage device.

### 3. Check if Packets are Being Read from TUN
Add this to your test:
```bash
./target/release/wirecage ... -- bash -c 'ping -c 3 1.1.1.1 & sleep 1; ip -s link show wirecage'
```

Look for RX/TX counters - they should be non-zero.

## Packet Capture

### Capture on TUN Device (inside namespace)
```bash
./target/release/wirecage ... -- tcpdump -i wirecage -nn -v
```

### Capture WireGuard Traffic (outside namespace)
In another terminal:
```bash
sudo tcpdump -i any udp port <WG_PORT> -nn -v
```

## Common Issues

### 1. TUN Device DOWN
- Check: `ip link show wirecage`
- Fix: Device should be UP after setup

### 2. No Packets on TUN
- Issue: Routing not configured
- Check: `ip route` should show default via wirecage

### 3. Packets on TUN but No WireGuard Traffic
- Issue: WireGuard tunnel not established
- Check debug logs for "WireGuard tunnel created"
- Check for handshake errors

### 4. WireGuard Traffic but No Response
- Issue: Server not responding or firewall blocking
- Check: `sudo tcpdump -i any udp port <WG_PORT>`
- Verify server public key is correct

### 5. Network Stack Not Running
- Issue: Tokio runtime panicked
- Check logs for "network stack error"

## Manual Testing

### Test Basic Connectivity
```bash
# Inside namespace
./target/release/wirecage ... -- bash

# Then inside the shell:
ip addr show wirecage
ip route
ping -c 1 10.1.2.1  # Gateway
ping -c 1 8.8.8.8   # Should fail (not implemented yet)
```

## Debug Output to Look For

Good signs:
```
DEBUG wirecage: creating network namespace
DEBUG wirecage: creating and configuring TUN device: wirecage
DEBUG wirecage: TUN device index: X
DEBUG wirecage: WireGuard tunnel created, endpoint: X.X.X.X:XXXX
DEBUG wirecage: read N bytes from TUN
DEBUG wirecage: received N bytes from WireGuard
DEBUG wirecage: wrote N bytes to TUN
```

Bad signs:
```
ERROR ... failed to ...
thread 'tokio-runtime-worker' panicked
network stack error: ...
```

## Step-by-Step Debug Process

1. **Verify namespace setup**
   ```bash
   RUST_LOG=debug ./target/release/wirecage ... -- ip link
   ```
   Should see wirecage interface UP

2. **Test TUN reads**
   ```bash
   RUST_LOG=debug ./target/release/wirecage ... -- ping -c 1 1.1.1.1
   ```
   Look for "read X bytes from TUN" in logs

3. **Test WireGuard encapsulation**
   Check logs for "WireGuard encapsulation" messages

4. **Capture actual traffic**
   ```bash
   ./target/release/wirecage ... -- tcpdump -i wirecage -c 10
   ```
   Then in another terminal, trigger traffic

## Known Limitations

- ICMP might not work without proper forwarding
- UDP might need connection tracking
- TCP should work if WireGuard is configured correctly
