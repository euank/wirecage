package main

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"log"
	"log/slog"
	"net"
	"net/http"
	_ "net/http/pprof"
	"net/netip"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"github.com/alexflint/go-arg"
	"go.euank.com/wireguard/conn"
	"go.euank.com/wireguard/device"
	"go.euank.com/wireguard/tun/netstack"
	"golang.org/x/crypto/curve25519"
)

type Config struct {
	ListenPort  int    `arg:"--port" default:"51820" help:"port to listen on (UDP)"`
	PrivateKey  string `arg:"--private-key" help:"WireGuard private key (base64)"`
	PrivKeyFile string `arg:"--private-key-file" help:"file containing WireGuard private key"`
	Network     string `arg:"--network" default:"10.0.0.0/8" help:"network to assign to clients"`
	ServerIP    string `arg:"--server-ip" default:"10.0.0.1" help:"server IP within the WireGuard network"`
	LogLevel    string `arg:"--log-level" default:"info" help:"log level (debug, info, warn, error)"`
	PublicKey   string `arg:"--public-key" help:"server's own public key (for display)"`
	PprofAddr   string `arg:"--pprof" default:"" help:"pprof HTTP server address (e.g. localhost:6060)"`
}

type Server struct {
	config      Config
	device      *device.Device
	netstack    *netstack.Net
	udpListener net.PacketConn
}

func main() {
	var config Config
	arg.MustParse(&config)

	// Set up logging
	var logLevel slog.Level
	switch strings.ToLower(config.LogLevel) {
	case "debug":
		logLevel = slog.LevelDebug
	case "info":
		logLevel = slog.LevelInfo
	case "warn", "warning":
		logLevel = slog.LevelWarn
	case "error":
		logLevel = slog.LevelError
	default:
		log.Fatalf("invalid log level %q", config.LogLevel)
	}

	slog.SetDefault(slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{
		Level: logLevel,
	})))

	// Handle private key - generate one if not specified
	if config.PrivateKey == "" && config.PrivKeyFile == "" {
		slog.Info("no private key specified, generating a new one...")
		privateKey, publicKey, err := generateWireGuardKeys()
		if err != nil {
			log.Fatalf("failed to generate WireGuard keys: %v", err)
		}
		config.PrivateKey = privateKey
		config.PublicKey = publicKey

		fmt.Printf("Generated new WireGuard key pair:\n")
		fmt.Printf("Private key: %s\n", privateKey)
		fmt.Printf("Public key:  %s\n", publicKey)
		fmt.Printf("\nClients can connect using this public key: %s\n", publicKey)
		fmt.Printf("Save the private key securely - you'll need it to restart the server.\n\n")
	} else if config.PrivKeyFile != "" {
		keyBytes, err := os.ReadFile(config.PrivKeyFile)
		if err != nil {
			log.Fatalf("failed to read private key file: %v", err)
		}
		config.PrivateKey = strings.TrimSpace(string(keyBytes))

		// Derive public key from private key if not provided
		if config.PublicKey == "" {
			publicKey, err := derivePublicKey(config.PrivateKey)
			if err != nil {
				log.Fatalf("failed to derive public key: %v", err)
			}
			config.PublicKey = publicKey
		}
	} else {
		// Private key provided directly, derive public key if not provided
		if config.PublicKey == "" {
			publicKey, err := derivePublicKey(config.PrivateKey)
			if err != nil {
				log.Fatalf("failed to derive public key: %v", err)
			}
			config.PublicKey = publicKey
		}
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Start pprof server if requested
	if config.PprofAddr != "" {
		go func() {
			slog.Info("starting pprof server", "addr", config.PprofAddr)
			if err := http.ListenAndServe(config.PprofAddr, nil); err != nil {
				slog.Error("pprof server error", "err", err)
			}
		}()
	}

	server := &Server{
		config: config,
	}

	if err := server.Start(ctx); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}

	// Handle graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	slog.Info("wirecagesrv started", "port", config.ListenPort, "serverIP", config.ServerIP)
	if config.PublicKey != "" {
		slog.Info("server public key", "key", config.PublicKey)
	}
	<-sigChan

	slog.Info("shutting down...")
	cancel()
	server.Stop()
}

func (s *Server) Start(ctx context.Context) error {
	// Create userspace WireGuard server
	if err := s.setupWireGuardServer(ctx); err != nil {
		return fmt.Errorf("failed to setup WireGuard server: %w", err)
	}

	// Set up gvisor stack for NAT functionality
	if err := s.setupNATStack(); err != nil {
		return fmt.Errorf("failed to setup NAT stack: %w", err)
	}

	if err := s.startListeners(); err != nil {
		return fmt.Errorf("failed to start listeners: %w", err)
	}

	slog.Info("WireGuard server started with userspace stack")
	return nil
}

func (s *Server) setupWireGuardServer(ctx context.Context) error {
	// Create netstack TUN for the server
	tun, netstack, err := netstack.CreateNetTUN(
		[]netip.Addr{netip.MustParseAddr(s.config.ServerIP)},
		[]netip.Addr{netip.MustParseAddr("1.1.1.1"), netip.MustParseAddr("8.8.8.8")},
		1500,
	)
	if err != nil {
		return fmt.Errorf("failed to create netstack TUN: %w", err)
	}

	s.netstack = netstack

	// Parse private key
	var privKey device.NoisePrivateKey
	privKeyBytes, err := base64.StdEncoding.DecodeString(s.config.PrivateKey)
	if err != nil {
		return fmt.Errorf("invalid private key: %w", err)
	}
	copy(privKey[:], privKeyBytes)

	// Create WireGuard device
	s.device = device.NewDevice(ctx, tun, conn.NewDefaultBind(), slog.Default())

	// Configure device as server
	err = s.device.IpcSet(ctx, fmt.Sprintf(`private_key=%s
listen_port=%d`, hex.EncodeToString(privKey[:]), s.config.ListenPort))
	if err != nil {
		return fmt.Errorf("failed to configure WireGuard device: %w", err)
	}

	// Bring up the device
	if err := s.device.Up(ctx); err != nil {
		return fmt.Errorf("failed to bring up WireGuard device: %w", err)
	}

	return nil
}

func (s *Server) setupNATStack() error {
	// The NAT functionality is handled through the netstack.Net
	// We'll set up listeners that will proxy connections from the WireGuard clients to the internet
	go s.handleWireGuardTraffic()
	return nil
}

func (s *Server) handleWireGuardTraffic() {
	// This function sets up NAT by creating a transparent proxy
	// that forwards traffic from WireGuard clients to the internet

	slog.Info("setting up NAT for WireGuard clients")

	// Start HTTP proxy for web traffic
	go s.startHTTPProxy()

	// Handle DNS queries
	go s.handleDNS()
}

func (s *Server) startHTTPProxy() {
	// Listen for HTTP CONNECT requests on port 8080 within the WireGuard network
	listener, err := s.netstack.ListenTCP(&net.TCPAddr{
		IP:   net.ParseIP(s.config.ServerIP),
		Port: 8080,
	})
	if err != nil {
		slog.Error("failed to start HTTP proxy", "err", err)
		return
	}
	defer listener.Close()

	slog.Info("HTTP proxy listening", "addr", listener.Addr())

	for {
		conn, err := listener.Accept()
		if err != nil {
			slog.Debug("HTTP proxy accept error", "err", err)
			continue
		}

		go s.handleHTTPProxyConnection(conn)
	}
}

func (s *Server) handleDNS() {
	// Listen for DNS queries on port 53 within the WireGuard network
	listener, err := s.netstack.ListenTCP(&net.TCPAddr{
		IP:   net.ParseIP(s.config.ServerIP),
		Port: 53,
	})
	if err != nil {
		slog.Error("failed to start DNS server", "err", err)
		return
	}
	defer listener.Close()

	slog.Info("DNS server listening", "addr", listener.Addr())

	for {
		conn, err := listener.Accept()
		if err != nil {
			slog.Debug("DNS accept error", "err", err)
			continue
		}

		go s.handleDNSConnection(conn)
	}
}

func (s *Server) handleDNSConnection(clientConn net.Conn) {
	defer clientConn.Close()

	buffer := make([]byte, 512) // DNS packets are typically small
	n, err := clientConn.Read(buffer)
	if err != nil {
		slog.Debug("DNS read error", "err", err)
		return
	}

	s.forwardDNSQuery(buffer[:n], clientConn)
}

func (s *Server) handleHTTPProxyConnection(clientConn net.Conn) {
	defer clientConn.Close()

	// Read the HTTP CONNECT request
	buffer := make([]byte, 4096)
	n, err := clientConn.Read(buffer)
	if err != nil {
		slog.Debug("failed to read HTTP request", "err", err)
		return
	}

	request := string(buffer[:n])
	slog.Debug("HTTP proxy request", "request", request[:min(len(request), 200)])

	// Simple HTTP CONNECT parsing (this is very basic)
	lines := strings.Split(request, "\n")
	if len(lines) == 0 || !strings.HasPrefix(lines[0], "CONNECT ") {
		clientConn.Write([]byte("HTTP/1.1 400 Bad Request\r\n\r\n"))
		return
	}

	// Extract target host:port from CONNECT line
	parts := strings.Split(lines[0], " ")
	if len(parts) < 2 {
		clientConn.Write([]byte("HTTP/1.1 400 Bad Request\r\n\r\n"))
		return
	}

	targetAddr := parts[1]

	// Connect to the target
	targetConn, err := net.Dial("tcp", targetAddr)
	if err != nil {
		slog.Debug("failed to connect to target", "target", targetAddr, "err", err)
		clientConn.Write([]byte("HTTP/1.1 502 Bad Gateway\r\n\r\n"))
		return
	}
	defer targetConn.Close()

	// Send success response
	clientConn.Write([]byte("HTTP/1.1 200 Connection Established\r\n\r\n"))

	// Start bidirectional copying
	go func() {
		defer clientConn.Close()
		defer targetConn.Close()
		copyData(targetConn, clientConn)
	}()

	copyData(clientConn, targetConn)
}

func (s *Server) forwardDNSQuery(query []byte, clientConn net.Conn) {
	// Forward DNS query to a real DNS server (e.g., 1.1.1.1)
	conn, err := net.Dial("udp", "1.1.1.1:53")
	if err != nil {
		slog.Debug("failed to connect to DNS server", "err", err)
		return
	}
	defer conn.Close()

	// Forward the query
	_, err = conn.Write(query)
	if err != nil {
		slog.Debug("failed to write DNS query", "err", err)
		return
	}

	// Read the response
	response := make([]byte, 512)
	n, err := conn.Read(response)
	if err != nil {
		slog.Debug("failed to read DNS response", "err", err)
		return
	}

	// Send response back to client
	_, err = clientConn.Write(response[:n])
	if err != nil {
		slog.Debug("failed to send DNS response", "err", err)
	}
}

func copyData(dst, src net.Conn) {
	buffer := make([]byte, 32*1024)
	for {
		n, err := src.Read(buffer)
		if err != nil {
			return
		}

		_, err = dst.Write(buffer[:n])
		if err != nil {
			return
		}
	}
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func (s *Server) startListeners() error {
	var err error
	// Listen on UDP for WireGuard traffic (will be handled by the device itself)
	s.udpListener, err = net.ListenUDP("udp", &net.UDPAddr{
		IP:   net.IPv4(0, 0, 0, 0),
		Port: s.config.ListenPort,
	})
	if err != nil {
		return fmt.Errorf("failed to listen on UDP: %w", err)
	}

	slog.Info("listening on ports", "udp", s.config.ListenPort, "tcp", s.config.ListenPort)
	return nil
}

func (s *Server) Stop() {
	slog.Info("stopping server...")

	if s.device != nil {
		s.device.Close()
	}

	if s.udpListener != nil {
		s.udpListener.Close()
	}

	slog.Info("server stopped")
}

// AddPeer adds a new peer to the WireGuard server
func (s *Server) AddPeer(ctx context.Context, publicKey, allowedIPs string) error {
	config := fmt.Sprintf(`public_key=%s
allowed_ip=%s`, publicKey, allowedIPs)

	err := s.device.IpcSet(ctx, config)
	if err != nil {
		return fmt.Errorf("failed to add peer: %w", err)
	}

	slog.Info("added peer", "publicKey", publicKey, "allowedIPs", allowedIPs)
	return nil
}

// RemovePeer removes a peer from the WireGuard server
func (s *Server) RemovePeer(ctx context.Context, publicKey string) error {
	config := fmt.Sprintf(`public_key=%s
remove=true`, publicKey)

	err := s.device.IpcSet(ctx, config)
	if err != nil {
		return fmt.Errorf("failed to remove peer: %w", err)
	}

	slog.Info("removed peer", "publicKey", publicKey)
	return nil
}

// generateWireGuardKeys generates a new WireGuard private/public key pair
func generateWireGuardKeys() (privateKeyB64, publicKeyB64 string, err error) {
	// Generate 32 random bytes for the private key
	var privateKey [32]byte
	_, err = rand.Read(privateKey[:])
	if err != nil {
		return "", "", fmt.Errorf("failed to generate random private key: %w", err)
	}

	// Apply WireGuard key clamping (curve25519 requirements)
	privateKey[0] &= 248
	privateKey[31] &= 127
	privateKey[31] |= 64

	// Derive the public key from the private key
	publicKey, err := curve25519.X25519(privateKey[:], curve25519.Basepoint)
	if err != nil {
		return "", "", fmt.Errorf("failed to derive public key: %w", err)
	}

	// Base64 encode both keys
	privateKeyB64 = base64.StdEncoding.EncodeToString(privateKey[:])
	publicKeyB64 = base64.StdEncoding.EncodeToString(publicKey)

	return privateKeyB64, publicKeyB64, nil
}

// derivePublicKey derives the public key from a base64-encoded private key
func derivePublicKey(privateKeyB64 string) (string, error) {
	// Decode the private key from base64
	privateKeyBytes, err := base64.StdEncoding.DecodeString(privateKeyB64)
	if err != nil {
		return "", fmt.Errorf("invalid private key base64 encoding: %w", err)
	}

	if len(privateKeyBytes) != 32 {
		return "", fmt.Errorf("private key must be 32 bytes, got %d", len(privateKeyBytes))
	}

	// Derive the public key
	publicKey, err := curve25519.X25519(privateKeyBytes, curve25519.Basepoint)
	if err != nil {
		return "", fmt.Errorf("failed to derive public key: %w", err)
	}

	// Base64 encode the public key
	return base64.StdEncoding.EncodeToString(publicKey), nil
}
