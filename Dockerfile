# Stage 0: Build
FROM rust:latest as builder
RUN USER=root cargo new --bin saltedpb-me-api
WORKDIR /saltedpb-me-api

# Copy over manifests and build
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release --target=x86_64-unknown-linux-musl
RUN rm src/*.rs target/x86_64-unknown-linux-musl/release/deps/saltedpb_me_api*

# Copy over source and build
COPY ./src ./src
RUN cargo build --release --target=x86_64-unknown-linux-musl

# Stage 1: Deploy
FROM scratch as deployment
COPY --from=builder /saltedpb-me-api/target/x86_64-unknown-linux-musl/release/saltedpb-me-api .
CMD ["./saltedpb-me-api"]