//! HTTPS API for wirecagesrv
//!
//! Provides endpoints for:
//! - Token-based authentication and WireGuard config provisioning
//! - Port forwarding rule management

use std::sync::Arc;

use axum::{
    extract::State,
    http::StatusCode,
    response::IntoResponse,
    routing::{delete, post},
    Json, Router,
};
use base64::Engine;
use serde::{Deserialize, Serialize};
use tokio::sync::mpsc;
use tracing::{error, info, warn};
use x25519_dalek::{PublicKey, StaticSecret};

use super::flow::{PortForwardRule, Protocol};
use super::state::{PeerInfo, SharedState};

/// Request to register a new peer
#[derive(Debug, Deserialize)]
pub struct RegisterRequest {
    pub token: String,
}

/// Response with WireGuard configuration
#[derive(Debug, Serialize)]
pub struct RegisterResponse {
    pub client_private_key: String,
    pub client_public_key: String,
    pub client_address: String,
    pub server_public_key: String,
    pub server_endpoint: String,
    pub wg_config: String,
}

/// Error response
#[derive(Debug, Serialize)]
pub struct ErrorResponse {
    pub error: String,
}

/// Request to create a port forward
#[derive(Debug, Deserialize)]
pub struct PortForwardRequest {
    pub token: String,
    pub client_public_key: String,
    pub protocol: String, // "tcp" or "udp"
    pub public_port: u16,
    pub target_port: u16,
}

/// Response for port forward creation
#[derive(Debug, Serialize)]
pub struct PortForwardResponse {
    pub public_port: u16,
    pub protocol: String,
    pub target_port: u16,
}

/// Request to delete a port forward
#[derive(Debug, Deserialize)]
pub struct PortForwardDeleteRequest {
    pub token: String,
    pub protocol: String,
    pub public_port: u16,
}

/// Message to notify dataplane of new port forward
#[derive(Debug, Clone)]
pub enum PortForwardEvent {
    Added(PortForwardRule),
    Removed { protocol: Protocol, port: u16 },
}

/// App state for axum
pub type ApiState = Arc<ApiContext>;

pub struct ApiContext {
    pub shared: Arc<SharedState>,
    pub wg_endpoint: String,
    pub port_forward_tx: mpsc::Sender<PortForwardEvent>,
}

/// Create the API router
pub fn create_router(
    shared: Arc<SharedState>,
    wg_endpoint: String,
    port_forward_tx: mpsc::Sender<PortForwardEvent>,
) -> Router {
    let ctx = Arc::new(ApiContext {
        shared,
        wg_endpoint,
        port_forward_tx,
    });

    Router::new()
        .route("/v1/register", post(register_handler))
        .route("/v1/portforward", post(portforward_create_handler))
        .route("/v1/portforward", delete(portforward_delete_handler))
        .with_state(ctx)
}

/// Handler for POST /v1/register
async fn register_handler(
    State(ctx): State<ApiState>,
    Json(req): Json<RegisterRequest>,
) -> impl IntoResponse {
    // Constant-time token comparison to prevent timing attacks
    if !constant_time_eq(req.token.as_bytes(), ctx.shared.config.auth_token.as_bytes()) {
        warn!("Invalid token attempt");
        return (
            StatusCode::UNAUTHORIZED,
            Json(serde_json::json!({"error": "invalid token"})),
        );
    }

    // Generate client keypair
    let client_secret = StaticSecret::random_from_rng(rand::thread_rng());
    let client_public = PublicKey::from(&client_secret);

    let client_private_key_b64 = base64::engine::general_purpose::STANDARD.encode(client_secret.as_bytes());
    let client_public_key_b64 = base64::engine::general_purpose::STANDARD.encode(client_public.as_bytes());
    let server_public_key_b64 = base64::engine::general_purpose::STANDARD.encode(&ctx.shared.config.server_public_key);

    // Allocate IP
    let assigned_ip = {
        let mut pool = ctx.shared.ip_pool.write();
        match pool.allocate() {
            Some(ip) => ip,
            None => {
                return (
                    StatusCode::SERVICE_UNAVAILABLE,
                    Json(serde_json::json!({"error": "no IPs available"})),
                );
            }
        }
    };

    // Create peer info
    let peer_info = PeerInfo {
        public_key: *client_public.as_bytes(),
        assigned_ip,
        allowed_ips: vec![format!("{}/32", assigned_ip)],
        created_at: std::time::Instant::now(),
    };

    // Register peer
    {
        let mut peers = ctx.shared.peers.write();
        peers.add(peer_info);
    }

    let client_address = format!("{}/24", assigned_ip);

    // Generate WireGuard config file content
    let wg_config = format!(
        "[Interface]\n\
         PrivateKey = {}\n\
         Address = {}\n\
         \n\
         [Peer]\n\
         PublicKey = {}\n\
         Endpoint = {}\n\
         AllowedIPs = 0.0.0.0/0\n\
         PersistentKeepalive = 25\n",
        client_private_key_b64,
        client_address,
        server_public_key_b64,
        ctx.wg_endpoint,
    );

    info!("Registered new peer with IP {}", assigned_ip);

    (
        StatusCode::OK,
        Json(serde_json::json!({
            "client_private_key": client_private_key_b64,
            "client_public_key": client_public_key_b64,
            "client_address": client_address,
            "server_public_key": server_public_key_b64,
            "server_endpoint": ctx.wg_endpoint,
            "wg_config": wg_config,
        })),
    )
}

/// Handler for POST /v1/portforward
async fn portforward_create_handler(
    State(ctx): State<ApiState>,
    Json(req): Json<PortForwardRequest>,
) -> impl IntoResponse {
    // Validate token
    if !constant_time_eq(req.token.as_bytes(), ctx.shared.config.auth_token.as_bytes()) {
        warn!("Invalid token attempt for port forward");
        return (
            StatusCode::UNAUTHORIZED,
            Json(serde_json::json!({"error": "invalid token"})),
        );
    }

    // Parse protocol
    let protocol = match req.protocol.to_lowercase().as_str() {
        "tcp" => Protocol::Tcp,
        "udp" => Protocol::Udp,
        _ => {
            return (
                StatusCode::BAD_REQUEST,
                Json(serde_json::json!({"error": "protocol must be 'tcp' or 'udp'"})),
            );
        }
    };

    // Parse client public key
    let pubkey_bytes = match base64::engine::general_purpose::STANDARD.decode(&req.client_public_key)
    {
        Ok(bytes) if bytes.len() == 32 => {
            let mut arr = [0u8; 32];
            arr.copy_from_slice(&bytes);
            arr
        }
        _ => {
            return (
                StatusCode::BAD_REQUEST,
                Json(serde_json::json!({"error": "invalid client public key"})),
            );
        }
    };

    // Look up peer to get their IP
    let peer_ip = {
        let peers = ctx.shared.peers.read();
        match peers.get_by_pubkey(&pubkey_bytes) {
            Some(peer) => peer.assigned_ip,
            None => {
                return (
                    StatusCode::NOT_FOUND,
                    Json(serde_json::json!({"error": "peer not found"})),
                );
            }
        }
    };

    // Validate port range (don't allow privileged ports unless we want to)
    if req.public_port < 1024 {
        return (
            StatusCode::BAD_REQUEST,
            Json(serde_json::json!({"error": "public port must be >= 1024"})),
        );
    }

    // Create the rule
    let rule = PortForwardRule {
        protocol,
        public_port: req.public_port,
        peer_pubkey: pubkey_bytes,
        peer_ip,
        target_port: req.target_port,
    };

    // Add to registry
    {
        let mut registry = ctx.shared.port_forwards.write();
        if let Err(e) = registry.add(rule.clone()) {
            return (
                StatusCode::CONFLICT,
                Json(serde_json::json!({"error": e})),
            );
        }
    }

    // Notify dataplane
    if let Err(e) = ctx.port_forward_tx.send(PortForwardEvent::Added(rule)).await {
        error!("Failed to notify dataplane of port forward: {}", e);
    }

    info!(
        "Created port forward: {} port {} -> {}:{}",
        req.protocol, req.public_port, peer_ip, req.target_port
    );

    (
        StatusCode::CREATED,
        Json(serde_json::json!({
            "public_port": req.public_port,
            "protocol": req.protocol,
            "target_port": req.target_port,
            "peer_ip": peer_ip.to_string(),
        })),
    )
}

/// Handler for DELETE /v1/portforward
async fn portforward_delete_handler(
    State(ctx): State<ApiState>,
    Json(req): Json<PortForwardDeleteRequest>,
) -> impl IntoResponse {
    // Validate token
    if !constant_time_eq(req.token.as_bytes(), ctx.shared.config.auth_token.as_bytes()) {
        warn!("Invalid token attempt for port forward delete");
        return (
            StatusCode::UNAUTHORIZED,
            Json(serde_json::json!({"error": "invalid token"})),
        );
    }

    // Parse protocol
    let protocol = match req.protocol.to_lowercase().as_str() {
        "tcp" => Protocol::Tcp,
        "udp" => Protocol::Udp,
        _ => {
            return (
                StatusCode::BAD_REQUEST,
                Json(serde_json::json!({"error": "protocol must be 'tcp' or 'udp'"})),
            );
        }
    };

    // Remove from registry
    let removed = {
        let mut registry = ctx.shared.port_forwards.write();
        registry.remove(protocol, req.public_port)
    };

    if removed.is_none() {
        return (
            StatusCode::NOT_FOUND,
            Json(serde_json::json!({"error": "port forward not found"})),
        );
    }

    // Notify dataplane
    if let Err(e) = ctx
        .port_forward_tx
        .send(PortForwardEvent::Removed {
            protocol,
            port: req.public_port,
        })
        .await
    {
        error!("Failed to notify dataplane of port forward removal: {}", e);
    }

    info!(
        "Removed port forward: {} port {}",
        req.protocol, req.public_port
    );

    (
        StatusCode::OK,
        Json(serde_json::json!({"status": "removed"})),
    )
}

/// Constant-time byte comparison
fn constant_time_eq(a: &[u8], b: &[u8]) -> bool {
    if a.len() != b.len() {
        return false;
    }
    let mut diff = 0u8;
    for (x, y) in a.iter().zip(b.iter()) {
        diff |= x ^ y;
    }
    diff == 0
}
