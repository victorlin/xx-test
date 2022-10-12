# Use xx for cross-compilation
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Define a builder stage image that runs natively for faster compilation.
# TODO: don't need python here if not using pip in this stage
FROM --platform=$BUILDPLATFORM python:3.7-slim-buster

# Execute subsequent RUN statements with bash for handy modern shell features.
SHELL ["/bin/bash", "-c"]

# copy xx scripts to builder stage
COPY --from=xx / /

# Used for platform-specific instructions
ARG TARGETPLATFORM

# Add system deps for building
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    lld \
    curl \
    make \
    pkg-config \
    dpkg-dev

# Install packages that generate binaries for the target architecture.
# https://github.com/tonistiigi/xx#building-on-debian
RUN xx-apt-get install -y \
    binutils \
    gcc \
    libc6-dev \
    zlib1g-dev

# vcftools
WORKDIR /build/vcftools
RUN curl -fsSL https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz \
    | tar xzvpf - --no-same-owner --strip-components=2
RUN ./configure --host=$(xx-clang --print-target-triple) --prefix=$PWD/built && make && make install
