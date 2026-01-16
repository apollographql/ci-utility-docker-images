# renovate: datasource=github-releases depName=nodejs/node extractVersion=^v(?<version>.*)$
ARG NODE_VERSION=20.20.0

FROM node:${NODE_VERSION}-alpine AS node

# Fixing to a specific SHA rather than a mutable tag, stops rebuilds completely
# changing the contents of the container without us realising.
FROM rust:1-alpine@sha256:f6c22e0a256c05d44fca23bf530120b5d4a6249a393734884281ca80782329bc

ARG TARGETPLATFORM

COPY --from=node /usr/lib/* /usr/lib/
COPY --from=node /usr/local/lib/* /usr/local/lib/
COPY --from=node /usr/local/include/* /usr/local/include/
COPY --from=node /usr/local/bin/* /usr/local/bin/

# Update packages and package manager to keep us current
RUN apk update && apk upgrade

# Add tools to enable `musl` compilation and other utilities when building in Rust
RUN apk add musl-dev curl cmake openssl gcc perl cmake git make openssh-client ca-certificates sudo \
    jq g++ elfutils docker python3

# Add the specific `musl` target to make sure we don't build for `glibc` by accident
RUN case $TARGETPLATFORM in \
        linux/amd64) \
            rustup target add x86_64-unknown-linux-musl \
            ;; \
        linux/arm64) \
            rustup target add aarch64-unknown-linux-musl \
            ;; \
        *) \
            echo "TARGETPLATFORM $TARGETPLATFORM not recognised, not installing a target" \
            ;; \
    esac
