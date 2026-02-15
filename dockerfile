FROM rust:1.75-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    protobuf-compiler \
    ca-certificates \
    clang \
    llvm \
    llvm-dev \
    libclang-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone --depth=1 https://github.com/anza-xyz/agave.git
WORKDIR /build/agave
RUN cargo build --release -p agave-validator

WORKDIR /build
RUN git clone --depth=1 https://github.com/rpcpool/yellowstone-grpc.git
WORKDIR /build/yellowstone-grpc/yellowstone-grpc-geyser
RUN cargo build --release


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    libudev1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder \
  /build/agave/target/release/agave-validator \
  /usr/local/bin/agave-validator

COPY --from=builder \
  /build/yellowstone-grpc/target/release/libyellowstone_grpc_geyser.so \
  /app/libyellowstone_grpc_geyser.so

COPY geyser-plugin-config.json /app/geyser-plugin-config.json

RUN mkdir -p /app/ledger

ENTRYPOINT ["agave-validator"]
CMD ["--ledger", "/app/ledger", "--geyser-plugin-config", "/app/geyser-plugin-config.json"]

