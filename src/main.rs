mod args;
mod namespace;
mod network;
mod network_new;
mod overlay;
mod wireguard;

use anyhow::{Context, Result};
use clap::Parser;
use std::os::unix::process::CommandExt;
use std::process::Command;
use tracing::debug;

use args::Args;
use namespace::Stage;

fn main() -> Result<()> {
    let args = Args::parse();

    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| {
                    tracing_subscriber::EnvFilter::new(&args.log_level)
                }),
        )
        .init();

    // Determine which stage we're at based on argv[0]
    let stage = Stage::from_argv0()?;

    match stage {
        Stage::One => stage_one(args),
        Stage::Two => stage_two(args),
    }
}

fn stage_one(args: Args) -> Result<()> {
    debug!("at first stage, launching second stage in a new user namespace...");

    // Determine target UID/GID
    let (uid, gid) = args.resolve_target_user()?;

    // Get current UID/GID before we clone
    let current_uid = nix::unistd::getuid();
    let current_gid = nix::unistd::getgid();

    // Use clone with CLONE_NEWUSER to create child in new user namespace
    use nix::sched::{clone, CloneFlags};
    use nix::sys::signal::Signal;

    const STACK_SIZE: usize = 1024 * 1024;
    let mut stack = vec![0u8; STACK_SIZE];

    let flags = CloneFlags::CLONE_NEWUSER;

    let child_pid = unsafe {
        clone(
            Box::new(|| {
                // Child process - we're now in a new user namespace
                // Wait for parent to write uid/gid maps
                std::thread::sleep(std::time::Duration::from_millis(50));

                // Exec into stage 2
                let err = Command::new("/proc/self/exe")
                    .args(std::env::args().skip(1))
                    .env("WIRECAGE_STAGE", "2")
                    .env("WIRECAGE_UID", uid.to_string())
                    .env("WIRECAGE_GID", gid.to_string())
                    .exec();

                eprintln!("exec failed: {}", err);
                1 // Return error code
            }),
            &mut stack,
            flags,
            Some(Signal::SIGCHLD as i32),
        )?
    };

    // Parent process: set up uid_map and gid_map for child
    debug!("parent: setting up uid/gid maps for child {}", child_pid);

    // Write uid_map
    std::fs::write(
        format!("/proc/{}/uid_map", child_pid),
        format!("0 {} 1", current_uid),
    )?;

    // Disable setgroups
    std::fs::write(
        format!("/proc/{}/setgroups", child_pid),
        "deny",
    )?;

    // Write gid_map
    std::fs::write(
        format!("/proc/{}/gid_map", child_pid),
        format!("0 {} 1", current_gid),
    )?;

    // Wait for child
    match nix::sys::wait::waitpid(child_pid, None)? {
        nix::sys::wait::WaitStatus::Exited(_, code) => {
            std::process::exit(code);
        }
        nix::sys::wait::WaitStatus::Signaled(_, sig, _) => {
            std::process::exit(128 + sig as i32);
        }
        _ => {
            std::process::exit(1);
        }
    }
}

fn stage_two(args: Args) -> Result<()> {
    debug!("at second stage");

    // Validate required arguments
    args.validate()?;

    // Read private key
    let private_key = std::fs::read_to_string(&args.wg_private_key_file)
        .context("failed to read private key file")?
        .trim()
        .to_string();

    // Create channels for communication between host WireGuard and child TUN
    use tokio::sync::mpsc;
    let (tun_to_wg_tx, tun_to_wg_rx) = mpsc::channel(100);
    let (wg_to_tun_tx, wg_to_tun_rx) = mpsc::channel(100);

    // Start WireGuard in HOST namespace in a dedicated thread
    // This thread will stay in the host network namespace
    debug!("starting WireGuard in host namespace");
    let args_wg = args.clone();
    let private_key_wg = private_key.clone();
    let wg_handle = std::thread::spawn(move || {
        // This thread is in the host network namespace and will stay there
        let runtime = tokio::runtime::Builder::new_multi_thread()
            .worker_threads(2)
            .enable_all()
            .build()
            .unwrap();

        runtime.block_on(async move {
            debug!("WireGuard runtime started");
            if let Err(e) = network_new::run_wireguard_host(&args_wg, &private_key_wg, tun_to_wg_rx, wg_to_tun_tx).await {
                tracing::error!("WireGuard host error: {}", e);
            }
        });
    });

    // Give WireGuard time to initialize
    std::thread::sleep(std::time::Duration::from_millis(200));

    // Now create network namespace (we enter a NEW network namespace)
    debug!("creating network namespace");
    namespace::setup_network_namespace(&args)?;

    // Create and configure TUN interface in new namespace
    let tun_device = namespace::setup_network_interface(&args)?;

    // Set up overlay filesystem for /etc
    let _overlay_guard = if !args.no_overlay {
        debug!("overlaying /etc...");
        Some(overlay::setup_etc_overlay(&args.gateway)?)
    } else {
        None
    };

    // Start TUN/network stack in CHILD namespace
    debug!("starting TUN child in network namespace");
    let args_tun = args.clone();
    let _tun_handle = std::thread::spawn(move || {
        let runtime = tokio::runtime::Builder::new_multi_thread()
            .worker_threads(2)
            .enable_all()
            .build()
            .unwrap();

        runtime.block_on(async move {
            if let Err(e) = network_new::run_tun_child(&args_tun, tun_to_wg_tx, wg_to_tun_rx, tun_device).await {
                tracing::error!("TUN child error: {}", e);
            }
        });
    });

    // Give network stack time to initialize
    std::thread::sleep(std::time::Duration::from_millis(100));

    // Get command to run
    let command = args.get_command();

    // We're already running as the correct user:
    // - We're UID 0 in the user namespace
    // - UID 0 maps to the original host UID (from stage 1)
    // - So we're effectively running as the user who invoked wirecage
    debug!("running as uid {} gid {} in namespace (maps to host uid {} gid {})",
           nix::unistd::getuid(), nix::unistd::getgid(), args.uid, args.gid);

    // Prepare environment
    let mut env = std::env::vars().collect::<Vec<_>>();
    env.push(("PS1".to_string(), "wirecage # ".to_string()));
    env.push(("wirecage".to_string(), "1".to_string()));

    debug!("spawning command: {:?}", command);

    // Spawn the target command (don't exec - we need to keep WireGuard thread alive!)
    let mut child = Command::new(&command[0])
        .args(&command[1..])
        .env_clear()
        .envs(env)
        .spawn()
        .context("failed to spawn command")?;

    // Wait for child to complete
    let status = child.wait().context("failed to wait for child")?;

    wg_handle.join();
    // Exit with the same code as the child
    std::process::exit(status.code().unwrap_or(1))
}
