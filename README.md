# docker-nerves
Docker image for Nerves development

## Quick start

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

### v0.1

- Debian 10.6
- Erlang/OTP 23.1.3
- Elixir 1.11.2-otp-23
- Nerves 1.7.0
    - hex 0.20.6
    - rebar 2.6.4 / 3.14.2
    - nerves_bootstrap 1.10.0
- fwup 1.8.2

## Tips

### Mount volumes on host

Since a filesystem into Docker image will disappear when an image rebuild/execute, it is useful to mount a volume on host to keep files of Nerves project. `-v ${PWD}:/workspace` can mount current directory on host to Docker image.

```Shell
$ docker run -it -w /workspace -v ${PWD}:/workspace docker-nerves 
```

It is also efficient to mount Nerves related setting files, such as `~/.ssh/` and `~/.nerves`. Following is an example to share setting files between host and image.

```Shell
$ docker run -it -w /workspace -v ${PWD}:/workspace  -v ~/.ssh:/root/.ssh -v ~/.nerves:/root/.nerves docker-nerves 
```

## Current limitation(s)

### burn Nerves firmware to microSD card

Docker has restrict policies to avoid effecting host environment. Therefore, `mix burn` cannot be operated from Docker image because there is no right to access `/dev` to on host as a root user.

One way to burn Nerves firmware is just operating `fwup` on the host. `fwup` is an utility for constructing/burning Nerves firmware.  
https://github.com/fhunleth/fwup

After installing `fwup` on the host according to [this step](https://github.com/fhunleth/fwup#installing), please do following command on the host terminal.

```Shell
$ cd <your_nerves_project_dir>
$ fwup _build/${MIX_TARGET}_dev/nerves/images/<project_name>.fw
```

Please let us know if you have a cool solution!
