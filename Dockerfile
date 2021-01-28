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
RUN wget https://github.com/fhunleth/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb && \
    apt-get install -y ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm ./fwup_${FWUP_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
# Install Mix environment for Nerves
RUN mix archive.install hex nerves_bootstrap 1.10.1 --force

CMD ["/bin/bash"]
