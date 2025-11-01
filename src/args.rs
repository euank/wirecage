use anyhow::{Context, Result};
use clap::Parser;

#[derive(Parser, Debug, Clone)]
#[command(name = "wirecage")]
#[command(about = "Run commands in a network namespace with WireGuard routing")]
pub struct Args {
    #[arg(long, default_value = "wirecage", help = "name of the TUN device")]
    pub tun: String,

    #[arg(
        long,
        default_value = "10.1.2.100/24",
        help = "IP address of the network interface that the subprocess will see"
    )]
    pub subnet: String,

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

    #[arg(long, default_value = "info", help = "log level (debug, info, warn, error)")]
    pub log_level: String,

    #[arg(long = "wg-public-key", help = "wireguard server public key")]
    pub wg_public_key: String,

    #[arg(long = "wg-private-key-file", help = "wireguard private key file")]
    pub wg_private_key_file: String,

    #[arg(long = "wg-endpoint", help = "wireguard server endpoint")]
    pub wg_endpoint: String,

    #[arg(
        long = "wg-address",
        help = "our wireguard address (i.e. the 'allowed_ips' the server has for this peer)"
    )]
    pub wg_address: String,

    #[arg(trailing_var_arg = true, help = "command to run")]
    pub command: Vec<String>,
}

impl Args {
    pub fn resolve_target_user(&self) -> Result<(u32, u32)> {
        if let Some(ref username) = self.user {
            // Try to parse as UID first
            if let Ok(uid) = username.parse::<u32>() {
                // If it's a number, look up the user by UID
                let user = nix::unistd::User::from_uid(nix::unistd::Uid::from_raw(uid))
                    .context("failed to lookup user")?
                    .context("user not found")?;
                Ok((user.uid.as_raw(), user.gid.as_raw()))
            } else {
                // Look up by username
                let user = nix::unistd::User::from_name(username)
                    .context("failed to lookup user")?
                    .context("user not found")?;
                Ok((user.uid.as_raw(), user.gid.as_raw()))
            }
        } else {
            // Use current user
            Ok((
                nix::unistd::geteuid().as_raw(),
                nix::unistd::getegid().as_raw(),
            ))
        }
    }

    pub fn validate(&self) -> Result<()> {
        if self.wg_endpoint.is_empty() {
            anyhow::bail!("--wg-endpoint is required");
        }
        if self.wg_public_key.is_empty() {
            anyhow::bail!("--wg-public-key is required");
        }
        if self.wg_private_key_file.is_empty() {
            anyhow::bail!("--wg-private-key-file is required");
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
}
