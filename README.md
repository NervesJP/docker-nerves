# docker-nerves

Dockerfile for Nerves development

## Description

[Nerves](https://www.nerves-project.org/) is now, young, and cool IoT framework with functional language [Elixir](https://elixir-lang.org/).

This Dockerfile enables you to acquire the development environment for Nerves with minimal steps. The Docker solution provides following contributions.

- If you are new to Nerves, you can easily try out its development. Since it is possible to provide a unified environment, it will be convenient for hands-on training.
- Even if you are already using Nerves, you can quickly try out the latest development environment. Docker does not affect your host environment.
- [The Docker Hub repository here](https://hub.docker.com/r/nervesjp/nerves) publishes the pre-built image. You can try it right away by just pulling it (but it may not always be up to date).

You can also experience a better development environment by using the Visual Studio Code and its extension.
*See more information:*
[https://github.com/NervesJP/nerves-devcontainer](https://github.com/NervesJP/nerves-devcontainer)

## Quick start

### from [Docker Hub repository](https://hub.docker.com/r/nervesjp/nerves)

You can try the Nerves development with pre-built image.

```bash
$ docker pull nervesjp/nerves
$ docker run -it -w /workspace nervesjp/nerves
root@6e304327bd2e:/workspace#
```

### from [GitHub repository](https://github.com/NervesJP/docker-nerves)

You can build Docker image locally, and customize it to your needs.

```bash
$ git clone https://github.com/NervesJP/docker-nerves
$ cd docker-nerves

$ docker build -t docker-nerves .

$ docker run -it -w /workspace docker-nerves
root@9bc88d0fc7b8:/workspace# pwd
/workspace

root@9bc88d0fc7b8:/workspace# echo ${HOME}
/root

root@9bc88d0fc7b8:/workspace# ls ~/.mix/*
/root/.mix/rebar  /root/.mix/rebar3

/root/.mix/archives:
hex-0.20.6  nerves_bootstrap-1.10.0
```

## Expected tools/versions to be installed

Each version number is for a pre-built image on Docker Hub. If you built the Docker container locally, please check them as described in parentheses.

| Name | check method(s) | v0.2 | v0.1.x |
|:---|:---|:---:|:---:|
| Debian | `cat /etc/debian_version` | 10.6 | 10.6 |
| Erlang/OTP | `erl -V` <br> `mix hex.info` | 23.1.4 | 23.1.4 |
| Elixir | `elixir -v` | 1.11.2-otp-23 | 1.11.2-otp-23 |
| Nerves | `mix nerves.info` | 1.7.1 | 1.7.0 |
| nerves_bootstrap | `ls ~/.mix/*` | 1.10.0 | 1.10.0 |
| hex | `ls ~/.mix/*` | 0.20.6 | 0.20.6 |
| rebar/rebar3 | `rebar -V` <br> `rebar3 -v` | 2.6.4/3.14.2 | 2.6.4/3.14.2 |
| fwup | `fwup --version` | 1.8.2 | 1.8.2 |

## Tips

There are many types of Dockerfile instructions, but this repository is intended to provide only the smallest and most common features. Feel free to customize it for your convenience. If you have a proposal that may be useful in common, please suggest it in Issue or PR.

This section follows some convenient ways to use the Docker environment for Nerves.
Docker offers many features as [CLI options](https://docs.docker.com/engine/reference/commandline/docker/).

### Mount volumes on host

Since a filesystem into Docker image will disappear when an image rebuild/execute, it is useful to mount a volume on host to keep files of Nerves project. `-v ${PWD}:/workspace` can mount current directory on host to Docker image.

```bash
$ docker run -it -w /workspace -v ${PWD}:/workspace docker-nerves
```

It is also efficient to mount Elixir/Nerves related setting directories, such as `.hex/`, `.nerves/` and `.ssh/`.
Following is an example to bind setting files between `${HOME}` on both the host and the image.

```bash
$ docker run -it -w /workspace -v ${PWD}:/workspace \\
  -v ~/.hex:/root/.hex -v ~/.nerves:/root/.nerves -v ~/.ssh:/root/.ssh docker-nerves
```

### Set environment variables for Nerves development

If your [target of Nerves](https://hexdocs.pm/nerves/targets.html) has been decided and fixed, locking the environment variable `${MIX_TARGET}` is efficient for your development. Here is an example of setting to `rpi3` when running the Docker container.

```bash
$ docker run -it -w /workspace -e MIX_TARGET=rpi3 docker-nerves

root@deda9932d7e3:/workspace# echo $MIX_TARGET
rpi3
```

`--env-file` is also efficient if you want to set several variables, e.g., to configure WiFi information with them for vintage_net_wifi. You can learn the detail from ["Connect to a target device" on this article](https://dev.to/mnishiguchi/elixir-nerves-get-started-with-led-blinking-on-raspberry-pi-2l1i).

```bash
$ cat env.list
MIX_TARGET=rpi3
WIFI_SSID=xxxxxxxx
WIFI_PSK=yyyyyyyy

$ docker run -it -w /workspace --env-file env.list docker-nerves

root@cf815278594a:/workspace# echo $MIX_TARGET
rpi3

root@cf815278594a:/workspace# echo $WIFI_SSID
xxxxxxxx

root@cf815278594a:/workspace# echo $WIFI_PSK
yyyyyyyy
```

## Branches and Releases/Tags policy and relationship with Docker Hub Tags

This [GitHub repository](https://github.com/NervesJP/docker-nerves) is associated to [Docker Hub](https://hub.docker.com/r/nervesjp/nerves) to be automatically built images.
Followings are our policy to maintain them, and relationship between [Branches](https://github.com/NervesJP/docker-nerves/branches) / [Releases (Tags)](https://github.com/NervesJP/docker-nerves/releases) and [Docker Hub Tags](https://hub.docker.com/r/nervesjp/nerves/tags).

- `main`: Latest version of maintenance. It is associated with `:latest` Docker tag.
- `dev`: Work in Progress to improve Dockerfile. It is associated with `:dev` Docker tag.
- `vX.Y`: Releases of Dockerfile and pre-built image. Functional improvements (e.g., bumping of tool versions) have been done to them from previous release. They are associated with `:X.Y` Docker tags.
- `doc`: Only modification of documentation. It is not associated with Docker tag.

## Current limitation(s)

### burn Nerves firmware to microSD card

Docker has restrict policies to avoid effecting host environment. And also, it is not possible to pass through a USB device (or a serial port) to a container as it requires support at the hypervisor level both in [Windows](https://docs.docker.com/docker-for-windows/faqs/#can-i-pass-through-a-usb-device-to-a-container) and [MacOS](https://docs.docker.com/docker-for-mac/faqs/#can-i-pass-through-a-usb-device-to-a-container) as the host.
Therefore, `mix burn` cannot be operated from Docker image because there is no right to access `/dev` to on host as a root user.

One way to burn Nerves firmware is just operating `fwup` on the host. `fwup` is an utility for constructing/burning Nerves firmware.
https://github.com/fhunleth/fwup

After installing `fwup` on the host according to [this step](https://github.com/fhunleth/fwup#installing), please do following command on the host terminal (e.g., PowerShell **as Administrator**, Terminal.app).

```bash
$ cd <your_nerves_project_dir>
$ fwup _build/${MIX_TARGET}_dev/nerves/images/<project_name>.fw
```

If you are using Linux as the host, you may be able to access microSD from the Docker environment along with the `privileged` option.
You may need to use a different `/dev/` address for your purposes.

```bash
$ docker run -it -w /workspace -v ${PWD}:/workspace \\
  -v /dev/sdb:/dev/sdb --privileged docker-nerves
```

Please let us know if you have a cool solution! ([issue#1](https://github.com/NervesJP/docker-nerves/issues/1))

## Links

- Elixir Forum Topic: [Nerves development environment with Docker (and VS Code) - Nerves Forum / Chat / Discussions - Elixir Programming Language Forum](https://elixirforum.com/t/nerves-development-environment-with-docker-and-vs-code/35973)
- [Qiita article (in Japanese)](https://qiita.com/takasehideki/items/27005ba9c0d9eb693ea9)
