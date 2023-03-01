#![warn(clippy::all, clippy::pedantic)]

use sqlx::PgPool;
use std::net::TcpListener;

use secrecy::ExposeSecret;
use subs::configuration::get_configuration;
use subs::startup::run;
use subs::telemetry::{get_subscriber, init_subsciriber};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("subs".into(), "info".into(), std::io::stdout);
    init_subsciriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration");
    let connection_pool =
        PgPool::connect(configuration.database.connection_string().expose_secret())
            .await
            .expect("Failed to connect to Postgres.");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;

    run(listener, connection_pool)?.await?;

    Ok(())
}
