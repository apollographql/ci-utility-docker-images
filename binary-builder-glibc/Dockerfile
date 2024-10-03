# Fixing to a specific SHA rather than a mutable tag, stops rebuilds completely
# changing the contents of the container without us realising.
FROM rockylinux:9@sha256:d7be1c094cc5845ee815d4632fe377514ee6ebcf8efaed6892889657e5ddaaa6

# renovate: datasource=github-releases depName=rust-lang/rust extractVersion=^v(?<version>.*)$
ARG RUST_VERSION=1.80.1
# Don't set this to bump automatically as it should move as the version does that's bundled with Alpine
ARG NODE_VERSION=20.15.1

# Add .cargo/bin to PATH
ENV VOLTA_HOME=/root/.volta
ENV PATH="$VOLTA_HOME/bin:/root/.cargo/bin:${PATH}"

# First update all the installed packages
RUN yum -y update

# Add the Development Tools
RUN yum groupinstall -y "Development Tools"

# Add some extra utilities for building in Rust
RUN yum install -y perl-core openssl-devel cmake

# Install RustUp and add specific target
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --default-toolchain=$RUST_VERSION

RUN case $TARGETPLATFORM in \
        linux/amd64) \
            rustup add target x86_64-unknown-linux-gnu \
            ;; \
        linux/arm64) \
            rustup add target aarch64-unknown-linux-gnu \
            ;; \
        *) \
            echo "TARGETPLATFORM $TARGETPLATFORM not recognised, not installing a target" \
            ;; \
    esac

# Install Volta (and Node)
RUN curl https://get.volta.sh | bash
RUN volta install node@$NODE_VERSION
