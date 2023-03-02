FROM lukemathwalker/cargo-chef:latest-rust-1.67.1 AS chef
WORKDIR /app
RUN apt-get update && apt-get install lld clang -y

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release --bin subs

FROM debian:bullseye-slim AS runtime
WORKDIR /app
RUN apt-get update -y \
        && apt-get install -y --no-install-recommends openssl ca-certificates \
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/subs subs
COPY configuration configuration
ENV APP_ENVIRONMENT production

ENTRYPOINT [ "./subs" ]