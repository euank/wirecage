FROM rust:1-bookworm AS builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release --bin wirecagesrv

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/wirecagesrv /usr/local/bin/wirecagesrv

ENV RUST_LOG=info
ENV WG_PRIVATE_KEY_FILE=/run/wirecage/server.key

EXPOSE 8443/tcp
EXPOSE 51820/udp

ENTRYPOINT ["/usr/local/bin/wirecagesrv"]
