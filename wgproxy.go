package main

import (
	"context"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"io"
	"log/slog"
	"net"
	"net/netip"
	"sync"

	"go.euank.com/wireguard/conn"
	"go.euank.com/wireguard/device"
	"go.euank.com/wireguard/tun/netstack"
)

type wireguardProxy struct {
	dev  *device.Device
	tnet *netstack.Net
}

func newWgProxy(ctx context.Context, ourIP, privateKey, publicKey string, endpoint string) (*wireguardProxy, error) {
	tun, tnet, err := netstack.CreateNetTUN(
		[]netip.Addr{netip.MustParseAddr(ourIP)},
		[]netip.Addr{netip.MustParseAddr("1.1.1.1")},
		1500,
	)
	if err != nil {
		return nil, err
	}

	var privKey device.NoisePrivateKey
	privKeyBytes, err := base64.StdEncoding.DecodeString(privateKey)
	if err != nil {
		return nil, fmt.Errorf("invalid priv key: %w", err)
	}
	copy(privKey[:], privKeyBytes)

	var pubKey device.NoisePublicKey
	pubKeyBytes, err := base64.StdEncoding.DecodeString(publicKey)
	if err != nil {
		return nil, fmt.Errorf("invalid priv key: %w", err)
	}
	copy(pubKey[:], pubKeyBytes)

	dev := device.NewDevice(ctx, tun, conn.NewDefaultBind(), slog.Default())

	err = dev.IpcSet(ctx, fmt.Sprintf(`private_key=%s
public_key=%s
allowed_ip=0.0.0.0/0
endpoint=%s`, hex.EncodeToString(privKey[:]), hex.EncodeToString(pubKey[:]), endpoint))
	if err != nil {
		return nil, err
	}

	err = dev.Up(ctx)
	if err != nil {
		return nil, err
	}

	return &wireguardProxy{
		dev:  dev,
		tnet: tnet,
	}, nil
}

func (wg *wireguardProxy) ProxyConn(ctx context.Context, network string, addr netip.AddrPort, subprocess net.Conn) {
	var conn net.Conn
	var err error
	switch network {
	case "tcp":
		conn, err = wg.tnet.DialContextTCPAddrPort(ctx, addr)
	case "udp":
		conn, err = wg.tnet.DialUDPAddrPort(netip.AddrPort{}, addr)
	default:
		panic(network)
	}
	if err != nil {
		slog.Debug("error dialing", "addr", addr, "err", err)
		// TODO: report errors not related to destination being unreachable
		if err := subprocess.Close(); err != nil {
			slog.Debug("error proxying conn", "network", network, "to", addr, "err", err)
		}
		return
	}
	slog.Debug("proxy start", "addr", addr)
	defer slog.Debug("proxy done", "addr", addr)
	var wait sync.WaitGroup
	wait.Add(2)
	go func() {
		defer wait.Done()
		proxyBytes(subprocess, conn)
		subprocess.(CloseWriter).CloseWrite()
	}()
	go func() {
		defer wait.Done()
		proxyBytes(conn, subprocess)
		conn.(CloseWriter).CloseWrite()
	}()
	wait.Wait()
}

// proxyBytes copies data between the world and the subprocess
func proxyBytes(w io.Writer, r io.Reader) {
	n, err := io.Copy(w, r)
	if err != nil {
		slog.Error("error copying bytes", "err", err, "n", n)
	} else {
		slog.Debug("copied bytes", "n", n)
	}
}

type CloseWriter interface {
	CloseWrite() error
}

var _ CloseWriter = &net.TCPConn{}
