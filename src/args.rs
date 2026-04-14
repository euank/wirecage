use anyhow::{Context, Result};
use clap::{Args as ClapArgs, Parser, Subcommand};

#[derive(Parser, Debug, Clone)]
#[command(name = "wirecage")]
#[command(about = "Run commands in a network namespace with WireGuard routing")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand, Debug, Clone)]
pub enum Commands {
    /// Add or update a named server in the local config
    AddServer(AddServerArgs),
    /// Run a command jailed through a named WireCage server
    Run(RunArgs),
}

#[derive(ClapArgs, Debug, Clone)]
pub struct AddServerArgs {
    /// Local name for the server
    pub name: String,

    /// Base API URL, for example https://server-host.com or http://127.0.0.1:8443
    pub api_url: String,

    /// Optional registration token stored in the local config
    #[arg(long)]
    pub token: Option<String>,
}

#[derive(ClapArgs, Debug, Clone)]
pub struct RunArgs {
    /// Name of the configured server to use
    pub server: String,

    #[arg(long, default_value = "wirecage", help = "name of the TUN device")]
    pub tun: String,

    #[arg(
        long,
        default_value = "10.1.2.1",
        help = "IP address of the gateway that intercepts and proxies network packets"
    )]
    pub gateway: String,

    #[arg(long, hide = true, default_value = "0", env = "WIRECAGE_UID")]
    pub uid: u32,

    #[arg(long, hide = true, default_value = "0", env = "WIRECAGE_GID")]
    pub gid: u32,

    #[arg(long, help = "run command as this user (username or id)")]
    pub user: Option<String>,

    #[arg(
        long,
        env = "WIRECAGE_NO_OVERLAY",
        help = "do not mount any overlay filesystems"
    )]
    pub no_overlay: bool,

    #[arg(
        long,
        default_value = "info",
        help = "log level (debug, info, warn, error)"
    )]
    pub log_level: String,

    #[arg(long = "wg-public-key", hide = true, env = "WIRECAGE_WG_PUBLIC_KEY")]
    pub wg_public_key: Option<String>,

    #[arg(long = "wg-private-key-file", hide = true, env = "WIRECAGE_WG_PRIVATE_KEY_FILE")]
    pub wg_private_key_file: Option<String>,

    #[arg(long = "wg-endpoint", hide = true, env = "WIRECAGE_WG_ENDPOINT")]
    pub wg_endpoint: Option<String>,

    #[arg(long = "wg-address", hide = true, env = "WIRECAGE_WG_ADDRESS")]
    pub wg_address: Option<String>,

    #[arg(trailing_var_arg = true, help = "command to run")]
    pub command: Vec<String>,
}

impl RunArgs {
    pub fn resolve_target_user(&self) -> Result<(u32, u32)> {
        if let Some(ref username) = self.user {
            if let Ok(uid) = username.parse::<u32>() {
                let user = nix::unistd::User::from_uid(nix::unistd::Uid::from_raw(uid))
                    .context("failed to lookup user")?
                    .context("user not found")?;
                Ok((user.uid.as_raw(), user.gid.as_raw()))
            } else {
                let user = nix::unistd::User::from_name(username)
                    .context("failed to lookup user")?
                    .context("user not found")?;
                Ok((user.uid.as_raw(), user.gid.as_raw()))
            }
        } else {
            Ok((
                nix::unistd::geteuid().as_raw(),
                nix::unistd::getegid().as_raw(),
            ))
        }
    }

    pub fn validate_runtime(&self) -> Result<()> {
        if self
            .wg_endpoint
            .as_deref()
            .is_none_or(|value| value.is_empty())
        {
            anyhow::bail!("resolved WireGuard endpoint is missing");
        }
        if self
            .wg_public_key
            .as_deref()
            .is_none_or(|value| value.is_empty())
        {
            anyhow::bail!("resolved WireGuard public key is missing");
        }
        if self
            .wg_private_key_file
            .as_deref()
            .is_none_or(|value| value.is_empty())
        {
            anyhow::bail!("resolved WireGuard private key path is missing");
        }
        if self
            .wg_address
            .as_deref()
            .is_none_or(|value| value.is_empty())
        {
            anyhow::bail!("resolved WireGuard client address is missing");
        }
        Ok(())
    }

    pub fn get_command(&self) -> Vec<String> {
        if self.command.is_empty() {
            vec!["/bin/sh".to_string()]
        } else {
            self.command.clone()
        }
    }

    pub fn wg_public_key(&self) -> &str {
        self.wg_public_key
            .as_deref()
            .expect("wg public key must be resolved before use")
    }

    pub fn wg_private_key_file(&self) -> &str {
        self.wg_private_key_file
            .as_deref()
            .expect("wg private key path must be resolved before use")
    }

    pub fn wg_endpoint(&self) -> &str {
        self.wg_endpoint
            .as_deref()
            .expect("wg endpoint must be resolved before use")
    }

    pub fn wg_address(&self) -> &str {
        self.wg_address
            .as_deref()
            .expect("wg address must be resolved before use")
    }
}
