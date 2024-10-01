# The SHA below is rust:1.80.1-alpine3.19, fixing to a specific SHA
# rather than a mutable tag, stops rebuilds completely changing the
# contents of the container without us realising.
FROM rust@sha256:a21d54019c66e3a1e7512651e9a7de99b08f28d49b023ed7220b7fe4d3b9f24e

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
