# wirecage

Force any application to route through a wireguard VPN with no chance of leaks.

No root required (assuming unprivileged user namespaces are enabled).

## Quickstart

You can run any command and force it to route through wireguard.

Want to run firefox through a vpn without affecting your other software? Put it in a wirecage:

```shell
./wirecage \
  --wg-endpoint "<wireguard server endpoint>" \
  --wg-public-key "<base64 wireguard server public key>" \
  --wg-private-key-file "/path/to/wireguard/private/key" \
  --wg-address "<our wireguard ip>" \
  -- firefox
```

Create a profile and browse around, and you'll see that you appear to be coming from your wireguard server's IP :)

You can also run simple tools like curl:

```shell
./wirecage \
  --wg-endpoint "<wireguard server endpoint>" \
  --wg-public-key "<base64 wireguard server public key>" \
  --wg-private-key-file "/path/to/wireguard/private/key" \
  --wg-address "<our wireguard ip>" \
  -- curl -4 https://api.myip.com

{"ip": "<wireguard server ip>"}
```

You can also open a shell and look around:

```shell
wirecage \
  ... \
  bash

# ip addr

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: wirecage: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    inet 10.1.2.100/24 brd 10.1.2.255 scope global wirecage
```

As you can see, the only route is to a tun interface, and that interface will
route straight to wireguard, ensuring proper network isolation.

## Ubuntu 23.10 and later

On Ubuntu 23.10 and later you will need to run the following in order to use wirecage:

```shell
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```

What this does is disable a [recent kernel feature that restricts unpriveleged user namespaces](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces).

## How it works

[boringtun](https://github.com/cloudflare/boringtun) for userspace wireguard, a network namespace to contain the process, and [smoltcp](https://github.com/smoltcp-rs/smoltcp) for the network stack itself.

Note: this project was created with LLM assistance. A human has reviewed all the code and verified it's not too wild.

Per the license, there is no warranty.

## wirecagesrv - Userspace VPN Server

The project also includes `wirecagesrv`, a userspace WireGuard VPN server with:

- **Userspace NAT**: Routes client traffic to the internet without iptables
- **HTTPS API**: Dynamic peer provisioning via token authentication
- **No root required**: Runs entirely in userspace (except for binding privileged ports)

### Server Quickstart

```shell
# Generate a server key
wg genkey > server.key

# Start the server
./wirecagesrv \
  --private-key-file server.key \
  --auth-token "your-secret-token" \
  --wg-endpoint "vpn.example.com:51820"
```

### Client Registration

Clients can register via the API to get a WireGuard configuration:

```shell
curl -X POST http://localhost:8443/v1/register \
  -H "Content-Type: application/json" \
  -d '{"token": "your-secret-token"}'
```

Response includes a complete WireGuard config file.

### Port Forwarding (Remote Listening)

Clients can request the server to listen on a public port and forward incoming connections back to them (like ngrok):

```shell
# Create a port forward (TCP port 8080 -> client's port 80)
curl -X POST http://localhost:8443/v1/portforward \
  -H "Content-Type: application/json" \
  -d '{
    "token": "your-secret-token",
    "client_public_key": "<client-public-key-from-registration>",
    "protocol": "tcp",
    "public_port": 8080,
    "target_port": 80
  }'
```

Now anyone connecting to `server:8080` will be forwarded to the VPN client's port 80.

```shell
# Remove a port forward
curl -X DELETE http://localhost:8443/v1/portforward \
  -H "Content-Type: application/json" \
  -d '{
    "token": "your-secret-token",
    "protocol": "tcp",
    "public_port": 8080
  }'
```

### Server Options

| Option | Default | Description |
|--------|---------|-------------|
| `--private-key-file` | (required) | Path to server's WireGuard private key |
| `--auth-token` | (required) | Token for API authentication |
| `--wg-endpoint` | (required) | Public endpoint clients will connect to |
| `--wg-listen` | `0.0.0.0:51820` | WireGuard UDP listen address |
| `--api-listen` | `0.0.0.0:8443` | API HTTP(S) listen address |
| `--server-ip` | `10.200.100.1` | Server's IP in the VPN subnet |
| `--subnet-mask` | `24` | VPN subnet CIDR mask |
| `--tls-cert` | (optional) | TLS certificate for HTTPS |
| `--tls-key` | (optional) | TLS private key for HTTPS |

## Caveats

- You need access to `/dev/net/tun`
- ICMP echo is temporarily not supported
- Server NAT currently supports TCP and UDP only
