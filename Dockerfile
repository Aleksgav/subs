FROM rust:1.67.1

WORKDIR /app
RUN apt-get update && apt-get install lld clang -y
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release
ENV APP_ENVIRONMENT production

ENTRYPOINT [ "./target/release/subs" ]
