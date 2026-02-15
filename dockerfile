FROM rust:1.75-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    protobuf-compiler \
    ca-certificates \
    git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --depth=1 https://github.com/anza-xyz/agave.git

