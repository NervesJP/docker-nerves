# docker-nerves

Dockerfile for Nerves development

## Description

[Nerves](https://www.nerves-project.org/) is now, young, and cool IoT framework with functional language [Elixir](https://elixir-lang.org/).

This Dockerfile enables you to acquire the development environment for Nerves with minimal steps. The Docker solution provides following contributions.

- If you are new to Nerves, you can easily try out its development. Since it is possible to provide a unified environment, it will be convenient for hands-on training.
- Even if you are already using Nerves, you can quickly try out the latest development environment. Docker does not affect your host environment.
- [The Docker Hub repository here](https://hub.docker.com/r/nervesjp/nerves) publishes the pre-built image. You can try it right away by just pulling it (but it may not always be up to date).
- You can also experience a better development environment by using the Visual Studio Code and its extension. See more information: [https://github.com/NervesJP/nerves-devcontainer](https://github.com/NervesJP/nerves-devcontainer)

## Quick start

### from [Docker Hub repository](https://hub.docker.com/r/nervesjp/nerves)

You can try the Nerves development with pre-built image.

```Shell
$ docker pull nervesjp/nerves
$ docker run -it -w /workspace nervesjp/nerves
root@6e304327bd2e:/workspace# 
```

### from [GitHub repository](https://github.com/NervesJP/docker-nerves)

You can build Docker image locally, and customize it to your needs.

```Shell
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

Each version number is for a pre-built image on Docker Hub. If you built Docker locally, please check them as described in parentheses.

### v0.1.x on Docker Hub

- Debian 10.6 (`cat /etc/debian_version`)
- Erlang/OTP 23.1.4 (`erl -V`)
- Elixir 1.11.2-otp-23 (`elixir -v`)
- Nerves 1.7.0 (`ls ~/.mix/*`)
  - hex 0.20.6
  - rebar 2.6.4 / 3.14.2
  - nerves_bootstrap 1.10.0
- fwup 1.8.2 (`fwup --version`)

## Tips

### Mount volumes on host

Since a filesystem into Docker image will disappear when an image rebuild/execute, it is useful to mount a volume on host to keep files of Nerves project. `-v ${PWD}:/workspace` can mount current directory on host to Docker image.

```Shell
$ docker run -it -w /workspace -v ${PWD}:/workspace docker-nerves 
```

It is also efficient to mount ElixirNerves related setting directories, such as `.hex/`, `.nerves/` and `.ssh/`.  
Following is an example to bind setting files between `${HOME}` on both the host and the image.

```Shell
$ docker run -it -w /workspace -v ${PWD}:/workspace \\
  -v ~/.hex:/root/.hex -v ~/.nerves:/root/.nerves -v ~/.ssh:/root/.ssh docker-nerves 
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

Docker has restrict policies to avoid effecting host environment. Therefore, `mix burn` cannot be operated from Docker image because there is no right to access `/dev` to on host as a root user.

One way to burn Nerves firmware is just operating `fwup` on the host. `fwup` is an utility for constructing/burning Nerves firmware.  
https://github.com/fhunleth/fwup

After installing `fwup` on the host according to [this step](https://github.com/fhunleth/fwup#installing), please do following command on the host terminal (e.g., PowerShell **as Administrator**, Terminal.app).

```Shell
$ cd <your_nerves_project_dir>
$ fwup _build/${MIX_TARGET}_dev/nerves/images/<project_name>.fw
```

Please let us know if you have a cool solution! ([issue#1](https://github.com/NervesJP/docker-nerves/issues/1))

## Links

- Elixir Forum Topic: [Nerves development environment with Docker (and VS Code) - Nerves Forum / Chat / Discussions - Elixir Programming Language Forum](https://elixirforum.com/t/nerves-development-environment-with-docker-and-vs-code/35973)
- [Qiita article (in Japanese)](https://qiita.com/takasehideki/items/27005ba9c0d9eb693ea9)
