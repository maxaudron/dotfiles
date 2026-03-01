use anyhow::Result;
use tracing::debug;

fn main() -> Result<()> {
    tracing_subscriber::fmt::init();
    debug!("starting");

    Ok(())
}
