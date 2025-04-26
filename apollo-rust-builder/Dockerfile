# Fixing to a specific SHA rather than a mutable tag, stops rebuilds completely
# changing the contents of the container without us realising.
FROM rockylinux:8-minimal@sha256:c584db6d77f40a71ab2364b55be18c154b8e92ba48189e2d82ba0aef64ffee32

# renovate: datasource=github-releases depName=rust-lang/rust
ARG RUST_VERSION=1.85.1
# renovate: datasource=github-releases depName=mikefarah/yq extractVersion=^v(?<version>.*)$
ARG YQ_VERSION=4.44.6
# renovate: datasource=github-releases depName=volta-cli/volta extractVersion=^v(?<version>.*)$
ARG VOLTA_VERSION=2.0.1
# Don't set this to bump automatically as it should move as the version does that's bundled with Alpine
ARG NODE_VERSION=20.15.1
ARG TARGETPLATFORM

# Set Cargo and Volta environment variables
ENV VOLTA_HOME=/root/.volta
ENV PATH="${VOLTA_HOME}/bin:/root/.cargo/bin:${PATH}"

# Upgrade system dependencies
RUN microdnf upgrade

# Install required packages
RUN microdnf install --nodocs --noplugins yum-utils && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    microdnf install --nodocs --noplugins perl-core openssl-devel cmake git make openssh-clients ca-certificates sudo  \
          unzip jq wget gcc gcc-c++ elfutils-devel docker-ce docker-ce-cli containerd.io && \
    microdnf clean all && \
    rm -rf /var/cache/yum

# Add yq
RUN wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETPLATFORM/\//_} -O /usr/bin/yq && chmod +x /usr/bin/yq

# Install RustUp and add specific target
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --default-toolchain=$RUST_VERSION --profile=minimal
RUN case $TARGETPLATFORM in \
        linux/amd64) \
            rustup target add x86_64-unknown-linux-gnu \
            ;; \
        linux/arm64) \
            rustup target add aarch64-unknown-linux-gnu \
            ;; \
        *) \
            echo "TARGETPLATFORM $TARGETPLATFORM not recognised, not installing a target" \
            ;; \
    esac

# Install Volta (and Node)
RUN curl https://get.volta.sh | bash -s -- --version $VOLTA_VERSION
RUN volta install node@$NODE_VERSION
