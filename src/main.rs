mod args;
mod client_config;
mod namespace;
mod network_new;
mod overlay;
mod wireguard;

use anyhow::{Context, Result};
use clap::Parser;
use std::os::unix::process::CommandExt;
use std::process::Command;
use tracing::{debug, info};

use args::{Cli, Commands, RunArgs};
use namespace::Stage;

fn main() -> Result<()> {
    let cli = Cli::parse();

    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new(log_level_for(&cli))),
        )
        .init();

    match cli.command {
        Commands::AddServer(args) => {
            let path = client_config::add_server(&args.name, &args.api_url, args.token)?;
            info!("Saved server `{}` to {}", args.name, path.display());
            Ok(())
        }
        Commands::Run(args) => {
            let stage = Stage::from_argv0()?;
            match stage {
                Stage::One => stage_one(args),
                Stage::Two => stage_two(args),
            }
        }
    }
}

fn log_level_for(cli: &Cli) -> &str {
    match &cli.command {
        Commands::AddServer(_) => "info",
        Commands::Run(args) => &args.log_level,
    }
}

fn stage_one(args: RunArgs) -> Result<()> {
    debug!("at first stage, resolving server configuration and preparing new user namespace...");

    let server = client_config::get_server(&args.server)?;
    let key = client_config::ensure_client_key(&args.server)?;
    let registration = client_config::register_with_server(&server, &key.public_key_b64)?;
    let wg_address = client_config::strip_mask(&registration.client_address).to_string();

    let (uid, gid) = args.resolve_target_user()?;
    let current_uid = nix::unistd::getuid();
    let current_gid = nix::unistd::getgid();

    use nix::sched::{clone, CloneFlags};
    use nix::sys::signal::Signal;

    const STACK_SIZE: usize = 1024 * 1024;
    let mut stack = vec![0u8; STACK_SIZE];

    let child_pid = unsafe {
        clone(
            Box::new(|| {
                std::thread::sleep(std::time::Duration::from_millis(50));

                let err = Command::new("/proc/self/exe")
                    .args(std::env::args().skip(1))
                    .env("WIRECAGE_STAGE", "2")
                    .env("WIRECAGE_UID", uid.to_string())
                    .env("WIRECAGE_GID", gid.to_string())
                    .env("WIRECAGE_WG_PUBLIC_KEY", registration.server_public_key.clone())
                    .env("WIRECAGE_WG_PRIVATE_KEY_FILE", key.private_key_path.display().to_string())
                    .env("WIRECAGE_WG_ENDPOINT", registration.server_endpoint.clone())
                    .env("WIRECAGE_WG_ADDRESS", wg_address.clone())
                    .exec();

                eprintln!("exec failed: {}", err);
                1
            }),
            &mut stack,
            CloneFlags::CLONE_NEWUSER,
            Some(Signal::SIGCHLD as i32),
        )?
    };

    debug!("parent: setting up uid/gid maps for child {}", child_pid);

    std::fs::write(
        format!("/proc/{}/uid_map", child_pid),
        format!("0 {} 1", current_uid),
    )?;
    std::fs::write(format!("/proc/{}/setgroups", child_pid), "deny")?;
    std::fs::write(
        format!("/proc/{}/gid_map", child_pid),
        format!("0 {} 1", current_gid),
    )?;

    match nix::sys::wait::waitpid(child_pid, None)? {
        nix::sys::wait::WaitStatus::Exited(_, code) => std::process::exit(code),
        nix::sys::wait::WaitStatus::Signaled(_, sig, _) => std::process::exit(128 + sig as i32),
        _ => std::process::exit(1),
    }
}

fn stage_two(args: RunArgs) -> Result<()> {
    debug!("at second stage");

    args.validate_runtime()?;

    let private_key = std::fs::read_to_string(args.wg_private_key_file())
        .context("failed to read private key file")?
        .trim()
        .to_string();

    use tokio::sync::mpsc;
    let (tun_to_wg_tx, tun_to_wg_rx) = mpsc::channel(100);
    let (wg_to_tun_tx, wg_to_tun_rx) = mpsc::channel(100);

    debug!("starting WireGuard in host namespace");
    let args_wg = args.clone();
    let private_key_wg = private_key.clone();
    let _wg_handle = std::thread::spawn(move || {
        let runtime = tokio::runtime::Builder::new_multi_thread()
            .worker_threads(2)
            .enable_all()
            .build()
            .unwrap();

        runtime.block_on(async move {
            debug!("WireGuard runtime started");
            if let Err(e) = network_new::run_wireguard_host(
                &args_wg,
                &private_key_wg,
                tun_to_wg_rx,
                wg_to_tun_tx,
            )
            .await
            {
                tracing::error!("WireGuard host error: {}", e);
            }
        });
    });

    std::thread::sleep(std::time::Duration::from_millis(200));

    debug!("creating network namespace");
    namespace::setup_network_namespace(&args)?;
    let tun_device = namespace::setup_network_interface(&args)?;

    let _overlay_guard = if !args.no_overlay {
        debug!("overlaying /etc...");
        Some(overlay::setup_etc_overlay(&args.gateway)?)
    } else {
        None
    };

    debug!("starting TUN child in network namespace");
    let args_tun = args.clone();
    let _tun_handle = std::thread::spawn(move || {
        let runtime = tokio::runtime::Builder::new_multi_thread()
            .worker_threads(2)
            .enable_all()
            .build()
            .unwrap();

        runtime.block_on(async move {
            if let Err(e) =
                network_new::run_tun_child(&args_tun, tun_to_wg_tx, wg_to_tun_rx, tun_device).await
            {
                tracing::error!("TUN child error: {}", e);
            }
        });
    });

    std::thread::sleep(std::time::Duration::from_millis(100));

    let command = args.get_command();

    debug!(
        "running as uid {} gid {} in namespace (maps to host uid {} gid {})",
        nix::unistd::getuid(),
        nix::unistd::getgid(),
        args.uid,
        args.gid
    );

    let mut env = std::env::vars().collect::<Vec<_>>();
    env.push(("PS1".to_string(), "wirecage # ".to_string()));
    env.push(("wirecage".to_string(), "1".to_string()));

    debug!("spawning command: {:?}", command);

    let mut child = Command::new(&command[0])
        .args(&command[1..])
        .env_clear()
        .envs(env)
        .spawn()
        .context("failed to spawn command")?;

    let status = child.wait().context("failed to wait for child")?;
    debug!("child exited with status: {:?}", status);
    std::process::exit(status.code().unwrap_or(1))
}
