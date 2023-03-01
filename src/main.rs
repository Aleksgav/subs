#![warn(clippy::all, clippy::pedantic)]

use secrecy::ExposeSecret;
use sqlx::postgres::PgPoolOptions;
use std::net::TcpListener;

use subs::configuration::get_configuration;
use subs::startup::run;
use subs::telemetry::{get_subscriber, init_subsciriber};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("subs".into(), "info".into(), std::io::stdout);
    init_subsciriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration");
    let connection_pool = PgPoolOptions::new()
        .acquire_timeout(std::time::Duration::from_secs(2))
        .connect_lazy(configuration.database.connection_string().expose_secret())
        .expect("Failed to connect to Postgres.");
    let address = format!(
        "{}:{}",
        configuration.application.host, configuration.application.port,
    );
    let listener = TcpListener::bind(address)?;

    run(listener, connection_pool)?.await?;

    Ok(())
}
