
# Build this docker file with the parenting folder as the build context!

# Use the official rust image with xwin (https://github.com/Jake-Shadle/xwin) as base.
#
FROM docker.io/library/rust:1.84.0-slim-bookworm AS builder-base

ENV KEYRINGS /usr/local/share/keyrings

RUN set -eux; \
  mkdir -p $KEYRINGS; \
  apt-get update && apt-get install -y gpg curl; \
  # clang/lld/llvm
  curl --fail https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > $KEYRINGS/llvm.gpg; \
  echo "deb [signed-by=$KEYRINGS/llvm.gpg] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-18 main" > /etc/apt/sources.list.d/llvm.list;

RUN set -eux; \
  # Skipping all of the recommended reduces total images size by ~300MiB
  apt-get update && apt-get install --no-install-recommends -y \
  clang-18 \
  # llvm-ar
  llvm-18 \
  lld-18 \
  git \
  # Unpack xwin
  tar; \
  # ensure that clang/clang++ are callable directly
  ln -s clang-18 /usr/bin/clang && ln -s clang /usr/bin/clang++ && ln -s lld-18 /usr/bin/ld.lld; \
  # We also need to setup symlinks ourselves for the MSVC shims because they aren't in the debian packages
  ln -s clang-18 /usr/bin/clang-cl && ln -s llvm-ar-18 /usr/bin/llvm-lib && ln -s lld-link-18 /usr/bin/lld-link; \
  # Verify the symlinks are correct
  clang++ -v; \
  ld.lld -v; \
  # Doesn't have an actual -v/--version flag, but it still exits with 0
  llvm-lib -v; \
  clang-cl -v; \
  lld-link --version; \
  # Use clang instead of gcc when compiling and linking binaries targeting the host (eg proc macros, build files)
  update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
  update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100; \
  update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld 100; \
  apt-get remove -y --auto-remove; \
  rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
  xwin_version="0.5.2"; \
  xwin_prefix="xwin-$xwin_version-x86_64-unknown-linux-musl"; \
  # Install xwin to cargo/bin via github release. Note you could also just use `cargo install xwin`.
  curl --fail -L https://github.com/Jake-Shadle/xwin/releases/download/$xwin_version/$xwin_prefix.tar.gz | tar -xzv -C /usr/local/cargo/bin --strip-components=1 $xwin_prefix/xwin; \
  # Splat the CRT and SDK files to /xwin/crt and /xwin/sdk respectively
  xwin --accept-license splat --output /xwin; \
  # Remove unneeded files to reduce image size
  rm -rf .xwin-cache /usr/local/cargo/bin/xwin;


# Note that we're using the full target triple for each variable instead of the
# simple CC/CXX/AR shorthands to avoid issues when compiling any C/C++ code for
# build dependencies that need to compile and execute in the host environment
ENV CC_x86_64_pc_windows_msvc="clang-cl" \
  CXX_x86_64_pc_windows_msvc="clang-cl" \
  AR_x86_64_pc_windows_msvc="llvm-lib" \
  # Note that we only disable unused-command-line-argument here since clang-cl
  # doesn't implement all of the options supported by cl, but the ones it doesn't
  # are _generally_ not interesting.
  CL_FLAGS="-Wno-unused-command-line-argument -fuse-ld=lld-link -I/xwin/crt/include -I/xwin/sdk/include/ucrt -I/xwin/sdk/include/um -I/xwin/sdk/include/shared" \
  # Let cargo know what linker to invoke if you haven't already specified it
  # in a .cargo/config.toml file
  CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_LINKER="lld-link" \
  CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUSTFLAGS="-Lnative=/xwin/crt/lib/x86_64 -Lnative=/xwin/sdk/lib/um/x86_64 -Lnative=/xwin/sdk/lib/ucrt/x86_64"

# These are separate since docker/podman won't transform environment variables defined in the same ENV block
ENV CFLAGS_x86_64_pc_windows_msvc="$CL_FLAGS" \
  CXXFLAGS_x86_64_pc_windows_msvc="$CL_FLAGS"

RUN rustup target add x86_64-pc-windows-msvc

WORKDIR /build

FROM builder-base AS builder

RUN git clone https://github.com/AkhilTThomas/tricore-gdb-das \
  && cd tricore-gdb-das && cargo build --release --target x86_64-pc-windows-msvc

# Extract the AURIX flasher tool from the installer.
FROM ubuntu:jammy AS extractor

RUN apt-get update
RUN apt-get install --no-install-recommends -y innoextract
WORKDIR "/root"
# Copy Aurix flasher setup.
COPY ["AURIXFlasherSoftwareTool-setup_3.0.2_20241218-1439.exe", "."]
# Extract Aurix flasher.
# This will extract to pwd/app.
RUN innoextract AURIXFlasherSoftwareTool-setup_3.0.2_20241218-1439.exe

# ------------------ Final container image  ------------------ 
FROM ubuntu:jammy AS runner

# Silences interactive installers.
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone.
ENV TZ=Europe/Berlin
ENV LOCAL_BIN=/usr/local/bin
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

# Add user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID --create-home --shell $SHELL $USERNAME \
  && mkdir -p /etc/sudoers.d \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  # add user to plugdev group which should have access to the attached devices
  && usermod -aG plugdev $USERNAME

RUN dpkg --add-architecture i386 && apt update && apt-get install -y wget
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

# Virtual X server to make applications not crash without display.
RUN apt-get update && apt-get install --no-install-recommends -y \
  xvfb \
  binutils \
  # Make etc.
  build-essential \
  # Wine.
  winehq-stable \
  # Mutli-architecture libraries required to build wineftd2xx.
  gcc-multilib \
  # Compiler for wineftd2xx.
  wine-stable-dev \
  # msiextract tool used to extract the AurixFlasher installer.
  msitools \
  sudo \
  unzip \
  wget \
  curl \
  # Build essentials
  gcc-11 \
  g++-11 \
  gdb \
  software-properties-common \
  libpthread-stubs0-dev \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  vim \
  usbutils \
  git \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG AGREE_INFINEON_TERMS=1
RUN if [ "${AGREE_INFINEON_TERMS}" -ne "1" ]; then echo "This installation ships an AurixFlasher and DAS installation. Agree with these conditions by setting environment variable AGREE_INFINEON_TERMS to 1" && exit 1; fi

WORKDIR "$USER_HOME"
# Copy DAS setup and install script.
COPY ["DAS_V8_1_4_SETUP.exe", "."]
COPY ["DAS_V8_1_4_installer_script.qs", "."]

# Set user
USER $USERNAME
# Install DAS, this will accept the DAS license agreement, notice and terms of use.
RUN wine DAS_V8_1_4_SETUP.exe --script DAS_V8_1_4_installer_script.qs -d --al

COPY --from=extractor "root/app" "$USER_HOME/.wine/dosdevices/c:/Infineon/AURIXFlasherSoftwareTool"

# Install wine mono required for AurixFlasher.
RUN wget -O ./wine-mono-9.1.0-x86.msi https://dl.winehq.org/wine/wine-mono/9.1.0/wine-mono-9.1.0-x86.msi \
  && msiexec /i wine-mono-9.1.0-x86.msi

# Build FTD2XX DLL shim.
COPY ["wineftd2xx", "$USER_HOME/wineftd2xx/"]
WORKDIR "$USER_HOME/wineftd2xx"
RUN sudo chmod +x winelibdir && sudo make
RUN sudo make install

# The DAS installer places TAS server executables in both directories, so we place the DLL in both directories.
RUN cp "$USER_HOME/wineftd2xx/ftd2xx.dll.so" "$USER_HOME/.wine/dosdevices/c:/DAS64/servers/ftd2xx.dll"
RUN cp "$USER_HOME/wineftd2xx/ftd2xx.dll.so" "$USER_HOME/.wine/dosdevices/c:/windows/system32/ftd2xx.dll"

WORKDIR "$USER_HOME/.wine/dosdevices/c:/"
COPY --from=builder /build/tricore-gdb-das/target/x86_64-pc-windows-msvc/release/tricore-gdb-das.exe .

# Wine debug channels https://wiki.winehq.org/Debug_Channels
# Turn on "+relay" for only one application: "win-daemon.exe:+relay"
# FTD2XX dll logging: "trace+ftd2xx"
# Disables all Wine debug logging.
ENV WINEDEBUG="-all"

# DAS home directory.
ENV DAS_HOME="C:\\DAS64"

# AurixFlasher path.
ENV AURIX_FLASHER_PATH="C:\\Infineon\\AURIXFlasherSoftwareTool\\AURIXFlasher.exe"

# tricore-gcc
ENV PATH="$PATH:/opt/tricore/bin"
RUN wget -O /tmp/tricore-gcc.zip https://github.com/NoMore201/tricore-gcc-toolchain/releases/download/11.3.1-20250101/tricore-gcc-11.3.1-20250101-linux.zip \
  && sudo mkdir -p /opt/tricore \
  && sudo unzip /tmp/tricore-gcc.zip -d /opt/tricore \
  && rm /tmp/tricore-gcc.zip \
  && sudo chmod -R 755 /opt/tricore

# CMAKE
RUN set -ex \
  && wget -qO /tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
  && sudo tar --strip-components=1 -xz -C /usr/local -f /tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
  && rm -f /tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz

# Just
RUN set -ex \
  && wget -qO /tmp/just.tar.gz "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
  && sudo tar -zxf /tmp/just.tar.gz --directory $LOCAL_BIN/ just \
  && sudo chmod +x $LOCAL_BIN/just \
  && rm -f /tmp/just.tar.gz

WORKDIR $USER_HOME

WORKDIR ${USER_HOME}/workspace
ENTRYPOINT ["/bin/bash", "--login"]


