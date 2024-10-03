# Fixing to a specific SHA rather than a mutable tag, stops rebuilds completely
# changing the contents of the container without us realising.

# renovate: datasource=github-releases depName=rust-lang/rust extractVersion=^v(?<version>.*)$
ARG RUST_VERSION=1.80.1

FROM rust:${RUST_VERSION}-alpine3.19@sha256:b3ac1f65cf33390407c9b90558eb41e7a8311c47d836fca5800960f1aa2d11d5

# Update packages and package manager to keep us current
RUN apk update && apk upgrade

# Add tools to enable `musl` compilation and other utilities when building in Rust
RUN apk add musl-dev curl cmake openssl gcc nodejs

# Add the specific `musl` target to make sure we don't build for `glibc` by accident
RUN case $TARGETPLATFORM in \
        linux/amd64) \
            rustup add target x86_64-unknown-linux-musl \
            ;; \
        linux/arm64) \
            rustup add target aarch64-unknown-linux-musl \
            ;; \
        *) \
            echo "TARGETPLATFORM $TARGETPLATFORM not recognised, not installing a target" \
            ;; \
    esac
