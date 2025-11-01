use anyhow::{Context, Result};
use nix::sched::{unshare, CloneFlags};
use tracing::debug;

use crate::args::Args;

pub enum Stage {
    One,
    Two,
}

impl Stage {
    pub fn from_argv0() -> Result<Self> {
        // Check environment variable to determine stage
        match std::env::var("WIRECAGE_STAGE") {
            Ok(ref s) if s == "2" => Ok(Stage::Two),
            _ => Ok(Stage::One),
        }
    }
}

pub fn setup_network_namespace(_args: &Args) -> Result<()> {
    // Create a new network namespace
    debug!("creating network namespace");
    unshare(CloneFlags::CLONE_NEWNET)
        .context("failed to unshare network namespace")?;

    // Note: TUN device will be created by the network stack
    // We just set up the namespace here
    
    Ok(())
}

pub fn setup_network_interface(args: &Args) -> Result<std::sync::Arc<std::sync::Mutex<tun::platform::Device>>> {
    // Create TUN device
    debug!("creating and configuring TUN device: {}", args.tun);
    let mut config = tun::Configuration::default();
    config
        .name(&args.tun)
        .up();

    #[cfg(target_os = "linux")]
    config.platform(|config| {
        config.packet_information(false);
    });

    let tun = tun::create(&config)
        .context("failed to create TUN device")?;

    // Set up networking using rtnetlink
    setup_network_config(args)?;
    
    // Return device wrapped in Arc<Mutex> so it can be shared with network stack
    Ok(std::sync::Arc::new(std::sync::Mutex::new(tun)))
}

fn setup_network_config(args: &Args) -> Result<()> {
    use futures::stream::TryStreamExt;
    use rtnetlink::new_connection;

    let rt = tokio::runtime::Runtime::new()?;
    
    rt.block_on(async {
        let (connection, handle, _) = new_connection()
            .context("failed to create netlink connection")?;
        
        tokio::spawn(connection);

        // Find the TUN device
        let mut links = handle.link().get().match_name(args.tun.clone()).execute();
        let link = links
            .try_next()
            .await?
            .context("TUN device not found")?;
        
        let link_index = link.header.index;
        debug!("TUN device index: {}", link_index);

        // Bring the link up
        handle
            .link()
            .set(link_index)
            .up()
            .execute()
            .await
            .context("failed to bring up TUN device")?;

        // Use the WireGuard address as the TUN IP (not the subnet arg)
        // The server's allowed_ips must match this
        let wg_addr: std::net::IpAddr = args.wg_address.parse()
            .context("invalid wg-address")?;
        
        let addr = wg_addr;
        let prefix_len = match addr {
            std::net::IpAddr::V4(_) => 24,
            std::net::IpAddr::V6(_) => 64,
        };
        
        debug!("Setting TUN IP to WireGuard address: {}/{}", addr, prefix_len);

        handle
            .address()
            .add(link_index, addr, prefix_len)
            .execute()
            .await
            .context("failed to add address to TUN device")?;

        // Add default IPv4 route
        handle
            .route()
            .add()
            .v4()
            .destination_prefix(std::net::Ipv4Addr::new(0, 0, 0, 0), 0)
            .output_interface(link_index)
            .execute()
            .await
            .context("failed to add default IPv4 route")?;

        // Try to add default IPv6 route (ignore errors)
        let _ = handle
            .route()
            .add()
            .v6()
            .destination_prefix(std::net::Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 0), 0)
            .output_interface(link_index)
            .execute()
            .await;

        // Find and bring up loopback
        let mut lo_links = handle.link().get().match_name("lo".to_string()).execute();
        if let Ok(Some(lo_link)) = lo_links.try_next().await {
            let _ = handle
                .link()
                .set(lo_link.header.index)
                .up()
                .execute()
                .await;
        }

        Ok::<(), anyhow::Error>(())
    })?;

    Ok(())
}
