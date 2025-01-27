# syntax=docker/dockerfile:1.4

FROM ubuntu:22.04 AS base

# Default is UTC and should probably be kept as such
ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive
ENV LOCAL_BIN=/usr/local/bin
ENV GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Basic packages
RUN apt-get update && apt-get install --install-recommends -y \
    sudo \
    git \
    vim \
    curl \
    wget \
    gnupg \
    openssl \
    rsync \
    unzip \
    lsb-release

# tricore-gcc
RUN wget -O /tmp/tricore-gcc.zip https://github.com/NoMore201/tricore-gcc-toolchain/releases/download/11.3.1-20250101/tricore-gcc-11.3.1-20250101-linux.zip \
    && mkdir -p /opt/tricore \
    && unzip /tmp/tricore-gcc.zip -d /opt/tricore \
    && rm /tmp/tricore-gcc.zip \
    && chmod -R 755 /opt/tricore

# Create a vscode user to avoid running as root.
ARG USERNAME=toor
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USER_HOME=/home/$USERNAME
ARG SHELL=/usr/bin/bash

# Versions
ARG CMAKE_VERSION=3.27.6
ARG JUST_VERSION=1.14.0
ARG LLVM_VERSION=17

# Apt keys for LLVM
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 33FD364EE38841BEE544889E322C5409CCD28BA2

RUN apt-get update && apt-get install --no-install-recommends -y \
    clang-format-${LLVM_VERSION} \
    # Build essentials
    gcc-11 \
    g++-11 \
    gdb \
    build-essential \
    software-properties-common \
    libpthread-stubs0-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# CMAKE
RUN set -ex \
    && curl -sL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    | tar --strip-components=1 -xz -C /usr/local

# Just
RUN set -ex \
    && curl -SL "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz" -o "just.tar.gz" \
    && tar -zxf ./just.tar.gz --directory $LOCAL_BIN/ just \
    && chmod +x $LOCAL_BIN/just \
    && rm ./just.tar.gz

# Add user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID --create-home --shell $SHELL $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && echo "source <(just --completions bash)" >> /etc/profile.d/just.sh

ENV PATH="$PATH:/opt/tricore/bin"

# Set user
USER $USERNAME
WORKDIR $USER_HOME

WORKDIR ${USER_HOME}/workspace
ENTRYPOINT ["/bin/bash", "--login"]
