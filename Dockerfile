# Stage 0: Build
FROM rust:latest as builder
RUN USER=root cargo new --bin saltedpb-me-api
WORKDIR /saltedpb-me-api

# Copy over manifests and build
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release 
RUN rm src/*.rs target/release/deps/saltedpb_me_api*

# Copy over source and build
COPY ./src ./src
RUN cargo build --release

# Stage 1: Deploy
FROM rust:latest as deployment
COPY --from=builder /saltedpb-me-api/target/release/saltedpb-me-api .
CMD ["./saltedpb-me-api"]