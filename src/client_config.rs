use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::time::Duration;

use anyhow::{Context, Result};
use base64::Engine;
use reqwest::blocking::Client;
use serde::{Deserialize, Serialize};
use x25519_dalek::{PublicKey, StaticSecret};

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ConfigFile {
    #[serde(default = "default_version")]
    pub version: u32,
    #[serde(default)]
    pub servers: BTreeMap<String, ServerConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ServerConfig {
    pub api_url: String,
    #[serde(default)]
    pub token: Option<String>,
}

#[derive(Debug, Clone)]
pub struct KeyMaterial {
    pub private_key_path: PathBuf,
    pub private_key_b64: String,
    pub public_key_b64: String,
}

#[derive(Debug, Clone, Deserialize)]
pub struct RegisterResponse {
    pub client_address: String,
    pub server_public_key: String,
    pub server_endpoint: String,
}

#[derive(Debug, Serialize)]
struct RegisterRequest<'a> {
    token: &'a str,
    client_public_key: &'a str,
}

fn default_version() -> u32 {
    1
}

pub fn config_root() -> Result<PathBuf> {
    if let Ok(path) = std::env::var("XDG_CONFIG_HOME") {
        return Ok(PathBuf::from(path).join("wirecage"));
    }

    let home = std::env::var("HOME").context("HOME is not set and XDG_CONFIG_HOME is unavailable")?;
    Ok(PathBuf::from(home).join(".config").join("wirecage"))
}

pub fn config_path() -> Result<PathBuf> {
    Ok(config_root()?.join("config.toml"))
}

pub fn load_config() -> Result<ConfigFile> {
    let path = config_path()?;
    if !path.exists() {
        return Ok(ConfigFile {
            version: default_version(),
            servers: BTreeMap::new(),
        });
    }

    let contents = fs::read_to_string(&path).with_context(|| format!("failed to read {}", path.display()))?;
    let config: ConfigFile =
        toml::from_str(&contents).with_context(|| format!("failed to parse {}", path.display()))?;
    Ok(config)
}

pub fn save_config(config: &ConfigFile) -> Result<PathBuf> {
    let root = config_root()?;
    fs::create_dir_all(&root).with_context(|| format!("failed to create {}", root.display()))?;

    let path = root.join("config.toml");
    let contents = toml::to_string_pretty(config).context("failed to serialize config")?;
    fs::write(&path, contents).with_context(|| format!("failed to write {}", path.display()))?;
    set_owner_only_permissions(&path)?;
    Ok(path)
}

pub fn add_server(name: &str, api_url: &str, token: Option<String>) -> Result<PathBuf> {
    let mut config = load_config()?;
    config.version = default_version();
    config.servers.insert(
        name.to_string(),
        ServerConfig {
            api_url: normalize_api_url(api_url),
            token,
        },
    );
    save_config(&config)
}

pub fn get_server(name: &str) -> Result<ServerConfig> {
    let config = load_config()?;
    let path = config_path()?;
    config
        .servers
        .get(name)
        .cloned()
        .with_context(|| format!("server `{}` not found in {}", name, path.display()))
}

pub fn ensure_client_key(server_name: &str) -> Result<KeyMaterial> {
    let root = config_root()?;
    let key_dir = root.join("keys");
    fs::create_dir_all(&key_dir).with_context(|| format!("failed to create {}", key_dir.display()))?;

    let private_key_path = key_dir.join(format!("{}.key", sanitize_name(server_name)));
    if !private_key_path.exists() {
        let secret = StaticSecret::random_from_rng(rand::thread_rng());
        let private_key_b64 = base64::engine::general_purpose::STANDARD.encode(secret.to_bytes());
        fs::write(&private_key_path, format!("{}\n", private_key_b64))
            .with_context(|| format!("failed to write {}", private_key_path.display()))?;
    }
    set_owner_only_permissions(&private_key_path)?;

    let private_key_b64 = fs::read_to_string(&private_key_path)
        .with_context(|| format!("failed to read {}", private_key_path.display()))?
        .trim()
        .to_string();

    let private_key_bytes = base64::engine::general_purpose::STANDARD
        .decode(private_key_b64.as_bytes())
        .context("client private key is not valid base64")?;
    if private_key_bytes.len() != 32 {
        anyhow::bail!("client private key must be 32 bytes");
    }

    let mut arr = [0u8; 32];
    arr.copy_from_slice(&private_key_bytes);
    let secret = StaticSecret::from(arr);
    let public = PublicKey::from(&secret);
    let public_key_b64 = base64::engine::general_purpose::STANDARD.encode(public.as_bytes());

    Ok(KeyMaterial {
        private_key_path,
        private_key_b64,
        public_key_b64,
    })
}

pub fn register_with_server(server: &ServerConfig, client_public_key: &str) -> Result<RegisterResponse> {
    let url = format!("{}/v1/register", normalize_api_url(&server.api_url));
    let token = server.token.clone().unwrap_or_default();
    let http = Client::builder()
        .timeout(Duration::from_secs(10))
        .build()
        .context("failed to build HTTP client")?;

    let response = http
        .post(url)
        .json(&RegisterRequest {
            token: &token,
            client_public_key,
        })
        .send()
        .context("registration request failed")?;

    let status = response.status();
    if !status.is_success() {
        let body = response.text().unwrap_or_else(|_| "<unreadable response body>".to_string());
        anyhow::bail!("registration failed with {}: {}", status, body);
    }

    response.json().context("failed to decode registration response")
}

pub fn strip_mask(client_address: &str) -> &str {
    client_address.split('/').next().unwrap_or(client_address)
}

fn sanitize_name(name: &str) -> String {
    name.chars()
        .map(|c| if c.is_ascii_alphanumeric() || c == '-' || c == '_' { c } else { '_' })
        .collect()
}

fn normalize_api_url(api_url: &str) -> String {
    api_url.trim_end_matches('/').to_string()
}

fn set_owner_only_permissions(path: &Path) -> Result<()> {
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        fs::set_permissions(path, fs::Permissions::from_mode(0o600))
            .with_context(|| format!("failed to chmod 600 {}", path.display()))?;
    }

    Ok(())
}

#[allow(dead_code)]
fn _is_config_path(path: &Path) -> bool {
    path.file_name().and_then(|s| s.to_str()) == Some("config.toml")
}
