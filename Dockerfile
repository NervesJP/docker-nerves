# docker-elixir 1.11.2
# https://hub.docker.com/_/elixir
FROM elixir:1.11.2

ENV DEBCONF_NOWARNINGS yes

# Install libraries for Nerves development
RUN apt-get update && \
    apt-get install -y build-essential automake autoconf git squashfs-tools ssh-askpass pkg-config curl && \
    rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this section to install libraries for customizing Nerves System
#RUN apt-get update && \
#    apt-get install -y libssl-dev libncurses5-dev bc m4 unzip cmake python && \
#    rm -rf /var/lib/apt/lists/*

# Install fwup (https://github.com/fhunleth/fwup)
ENV FWUP_VERSION="1.8.2"
RUN wget https://github.com/fhunleth/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb && \
    apt-get install -y ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
# Create (fake) symbolic link for Windows environment
RUN ln -s fwup /usr/bin/fwup.exe

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
# Install Mix environment for Nerves
RUN mix archive.install hex nerves_bootstrap --force

# Download archives of Nerves artifacts on Docker build process
RUN mkdir -p ~/.nerves/dl
# Alghough the latest version of nerves_system_rpi4 is now v1.13.1, we found
# the issue about WiFi connection to 5GHz AP on this version.
# So we decided to download both versions to avoid confusion on ALGYAN hands-on.
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/nerves_system_rpi4/releases/download/v1.13.0/nerves_system_rpi4-portable-1.13.0-366303C.tar.gz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/toolchains/releases/download/v1.3.2/nerves_toolchain_arm_unknown_linux_gnueabihf-linux_x86_64-1.3.2-E31F29C.tar.xz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/nerves_system_rpi4/releases/download/v1.13.1/nerves_system_rpi4-portable-1.13.1-C916C86.tar.gz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/toolchains/releases/download/v1.3.2/nerves_toolchain_aarch64_unknown_linux_gnu-linux_x86_64-1.3.2-7C57FE3.tar.xz

# Append some environmental variables for hands-on
RUN echo "export PS1=\"\n\[\033[0;32m\]\u@\h \[\033[0;33m\]\w\n\\[\033[0m\]# \[\033[0m\]\"" >> ~/.bashrc
RUN echo "export MIX_TARGET=rpi4" >> ~/.bashrc

CMD ["/bin/bash"]