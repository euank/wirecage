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

ENV PORT=8080
ENV RUST_LOG=info
ENV WG_PRIVATE_KEY_FILE=/run/wirecage/server.key

ENTRYPOINT ["/bin/sh", "-c", "set -eu; : \"${WG_PRIVATE_KEY_B64:?WG_PRIVATE_KEY_B64 secret is required}\"; : \"${AUTH_TOKEN:?AUTH_TOKEN secret is required}\"; mkdir -p \"$(dirname \"$WG_PRIVATE_KEY_FILE\")\"; printf '%s\n' \"$WG_PRIVATE_KEY_B64\" > \"$WG_PRIVATE_KEY_FILE\"; chmod 600 \"$WG_PRIVATE_KEY_FILE\"; export WG_ENDPOINT=\"${WG_ENDPOINT:-${FLY_APP_NAME}.fly.dev:51820}\"; exec /usr/local/bin/wirecagesrv --api-listen \"0.0.0.0:${PORT}\" --wg-listen \"${WG_LISTEN:-0.0.0.0:51820}\""]
