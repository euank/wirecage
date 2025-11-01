use anyhow::{Context, Result};
use nix::mount::{mount, umount2, MntFlags, MsFlags};
use nix::sched::{unshare, CloneFlags};
use std::path::{Path, PathBuf};
use tracing::debug;

pub struct OverlayGuard {
    tmpdir: PathBuf,
}

impl Drop for OverlayGuard {
    fn drop(&mut self) {
        if let Err(e) = std::fs::remove_dir_all(&self.tmpdir) {
            tracing::warn!("failed to cleanup overlay tmpdir: {}", e);
        }
    }
}

pub fn setup_etc_overlay(gateway: &str) -> Result<OverlayGuard> {
    // Check if /etc exists and is a directory
    if !Path::new("/etc").is_dir() {
        anyhow::bail!("/etc is not a directory");
    }

    // Create temporary directory for overlay
    let tmpdir = tempfile::Builder::new()
        .prefix("overlay-")
        .tempdir()
        .context("failed to create temp directory")?;
    
    let tmpdir_path = tmpdir.into_path();

    let workdir = tmpdir_path.join("work");
    let layerdir = tmpdir_path.join("layer");

    std::fs::create_dir_all(&workdir)
        .context("failed to create work directory")?;
    std::fs::create_dir_all(&layerdir)
        .context("failed to create layer directory")?;

    // Create resolv.conf in layer
    std::fs::write(
        layerdir.join("resolv.conf"),
        format!("nameserver {}\n", gateway),
    )
    .context("failed to write resolv.conf")?;

    // Switch to a new mount namespace
    unshare(CloneFlags::CLONE_NEWNS | CloneFlags::CLONE_FS)
        .context("failed to unshare mount namespace")?;

    // Make root filesystem private
    mount(
        None::<&str>,
        "/",
        None::<&str>,
        MsFlags::MS_PRIVATE | MsFlags::MS_REC,
        None::<&str>,
    )
    .context("failed to make root filesystem private")?;

    // Mount overlay filesystem
    let mount_opts = format!(
        "lowerdir=/etc,upperdir={},workdir={}",
        layerdir.display(),
        workdir.display()
    );

    debug!("mounting overlay with opts: {}", mount_opts);

    mount(
        Some("overlay"),
        "/etc",
        Some("overlay"),
        MsFlags::empty(),
        Some(mount_opts.as_str()),
    )
    .context("failed to mount overlay filesystem")?;

    Ok(OverlayGuard { tmpdir: tmpdir_path })
}
