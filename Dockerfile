# docker-elixir 1.11.3
# https://hub.docker.com/_/elixir
FROM elixir:1.11.3

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
ENV FWUP_VERSION="1.8.3"
RUN wget https://github.com/fwup-home/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb && \
    apt-get install -y ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
# Install Mix environment for Nerves
RUN mix archive.install hex nerves_bootstrap 1.10.2 --force

# Download archives of Nerves artifacts on Docker build process
RUN mkdir -p ~/.nerves/dl
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/nerves_system_rpi0/releases/download/v1.14.0/nerves_system_rpi0-portable-1.14.0-261E47F.tar.gz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/toolchains/releases/download/v1.4.1/nerves_toolchain_armv6_nerves_linux_gnueabihf-linux_x86_64-1.4.1-B107BAC.tar.xz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/nerves_system_rpi3/releases/download/v1.14.0/nerves_system_rpi3-portable-1.14.0-F310513.tar.gz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/toolchains/releases/download/v1.4.1/nerves_toolchain_armv7_nerves_linux_gnueabihf-linux_x86_64-1.4.1-4C8725A.tar.xz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/nerves_system_rpi4/releases/download/v1.14.0/nerves_system_rpi4-portable-1.14.0-5CF0E29.tar.gz
RUN wget -q -P ~/.nerves/dl/ https://github.com/nerves-project/toolchains/releases/download/v1.4.1/nerves_toolchain_aarch64_nerves_linux_gnu-linux_x86_64-1.4.1-6E027A9.tar.xz

CMD ["/bin/bash"]
