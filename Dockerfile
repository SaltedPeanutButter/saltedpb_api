# Stage 0: Build
FROM rust:slim-buster as builder

# Add musl target
RUN rustup target add x86_64-unknown-linux-musl

# Create blank projects
RUN USER=root cargo new saltedpb_api

# Build dependencies
COPY ./Cargo.toml ./Cargo.lock /saltedpb_api/
WORKDIR /saltedpb_api
RUN cargo build --target x86_64-unknown-linux-musl --release

# Build the rest of the source
COPY src/ /saltedpb_api/src/
RUN touch /saltedpb_api/src/main.rs
RUN cargo build --target x86_64-unknown-linux-musl --release

# Stage 1: Deploy
FROM alpine:latest
COPY --from=builder /saltedpb_api/target/x86_64-unknown-linux-musl/release/saltedpb_api /usr/local/bin/
CMD [ "/usr/local/bin/saltedpb_api" ]
