> :warning:
> The examples in this document are not verified yet.
> The verification and example code will be added onward.


# Docker Tutorials

This tutorial shows up how to do a complex builds


# What version of Docker is this tutorial target?

All of the examples and use cases are working against `Dockerfile` 
1.4 and `Buildx` v0.8+. Please ensure the version of `Dockerfile` 
and `Buildx` before starting this tutorial. If you would like to 
install or upgrade the Docker, please go to 
[Install Docker Engine](https://docs.docker.com/engine/install/) page. 


# Why do we need Build Context flag?

To build an image by docker, the single build context from a local 
repository is given from a path in the docker build command as:
```bash
docker build -t ${imageName}:${tag} .
```
However, this is not allowed to access files outsite of specified 
build context by using the `../` parent selector for security 
reason. This leads to the build context must be at the root 
directory if the developers would like to build image for multiple 
different project and it results in many `COPY` and `ADD` 
instructions being written in the `Dockerfile` to achive the goal 
and these reduce the readability of code. Fortunately, `Docker` 
supports multiple build context flags in `Dockerfile 1.4`. This 
reduces the complexity of `Dockerfile` and provides more 
flexibility in organising build contexts in the code with CI/CD 
pipeline.


# What is the Build Context flag?

Build context flag allows developers to define four types of build 
contexts, including `local directory`, `Git repository`, 
`HTTP URL to tarball` and `Docker image`.

The syntax of the build context flag is:
```bash
docker buildx build \
  --build-context ${name}=${sourceOfContext} \
  -t ${imageName}:${tag} \
  .
```
`${name}` is the name of the build context which will be used in 
the Dockerfile and the `${sourceOfContext}` is the location of 
the build context from `local directory`, `Git repository`, 
`HTTP URL to tarball` or `Docker image`.

Also, `Dockerfile 1.4` supports multiple build contexts for an 
image by using:
```bash
docker build \
  --build-context ${context1}=${sourceOfContext1} \
  --build-context ${context2}=${sourceOfContext2} \
  -t ${imageName}:${tag} \
  .
```


## Load build context from a Local Directory

Build context flag accepts relative file path and absolute file 
path when the user would like to build an image from the files 
in a local directory.

To load build context from a relative file path:
```bash
docker buildx build \
  --build-context greetingService=./workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```
Or
```base
docker buildx build \
  --build-context greetingService=workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```

If the `Dockerfile` is not in the same directory as the context 
directory as follows:
```bash
.
+-- dockerfiles
|   +-- greeting
|   +-- calculator
+-- workspaces
|   +-- greeting
|   +-- calculator
+-- package.json
+-- README.md
```
Then the file path can be typed in the following format:
In the Unix-liked system, tilde(~) represents the path to the 
user's home directory and this can be used as a part of the file 
path in the build context flag as:
```bash
docker buildx build \
  --build-context greetingService=~/docker.tutorials/workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```
This can be interpreted into an absolute file path as:
```bash
docker buildx build \
  --build-context greetingService=${userHomePath}/docker.tutorials/workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```


## Load build context from a Git repository

It is quite simple to load build context from a Git repository by 
specifying the URL of the repository as:
```bash
docker buildx build \
  --build-context dockerTutorial=https://github.com/OttoHung/docker.tutorial.git \
  -t ${imageName}:${tag} \
  .
```
Or access the repository via ssh by:
```bash
docker buildx build \
  --build-context dockerTutorial=git@github.com:OttoHung/docker.tutorial.git \
  -t ${imageName}:${tag} \
  .
```

By using this way, the whole repository is the build context for the 
`Dockerfile`. If the build context is a private repository, please 
ensure docker has permission to access the resources, such as 
configuring SSH key, Personal Access Token(PAT) or other access tokens.


## Load build context from a tarball via HTTP URL

Build context flag also supports tarball(*.tar) and it can be loaded 
via HTTP URL as:
```bash
docker buildx build \
  --build-context dockerTutorial=https://github.com/OttoHung/docker.tutorials/archive/refs/tags/tutorials.tar.gz \
  -t ${imageName}:${tag} \
  .
```


## Load build context from a docker image

Before `Dockerfile` 1.4, the docker image can be loaded by `FROM` 
instruction with the URL of the image in the `Dockerfile` as:
```dockerfile
FROM https://ghcr.io/OttoHung/greeting:latest
```
Or
```dockerfile
FROM alpine:3.15
```

By using the build context flag, the docker image goes with 
`docker-image://` prefix to tell what docker image to load. For
example:
```bash
docker buildx build
  --build-context alpine=docker-image://alpine:3.15 \
  -t ${imageName}:${tag} \
  .
```

> To Do: test how to use `docker-image://` with `GHCR.io`


# CLI Commands for building and validating the docker image

## Build docker image with tag

Build an image with a tag:
```bash
docker build -t ${imageName}:${tag} .
```


## Investigate image content

Investigate the content of an image when the container uses `CMD` instruction 
to execute a command:
```bash
docker run -it ${imageName}:${tag} sh
```
Or
```bash
docker run -it --entrypoint sh ${imageName}:${tag}
```

However, only `--entrypoint` flag works when the container uses
`Entrypoint` instruction to execute a command.


## Write build image log to a file

To write the build history into a file:
```bash
docker image history --no-trunc ${imageName}:${tag} > ${fileName}
```


## Ceate a container for a service

To create a container by the image for a service:
```bash
docker run -p ${port}:${port} ${imageName}:${tag}
```


# Pitfalls

## **DO NOT** use `/bin/sh` and `-c` in `CMD` and `ENTRYPOINT` when you want to receive the system signals

In the execution form of `CMD` and `ENTRYPOINT`, it allows users to use 
`["executable" "param1" "param2"]` to execute a command. It means there 
are two ways to use the execution form like:
```dockerfile
CMD ["node", "dist/server.js"]
```
```dockerfile
ENTRYPOINT ["node", "dist/server.js"]
```
or
```dockerfile
CMD ["/bin/sh", "-c", "node dist/server.js"]
```
```dockerfile
ENTRYPOINT ["/bin/sh", "-c" , "node dist/server.js"]
```

However, the `dist/server.js` cannot receive system signal, such as `Ctrl+C`
, from the command line prompt when the `CMD` and `ENTRYPOINT` 
instructions go with `/bin/sh` to initiate `dist/server.js`. As a result, 
please do not to use `/bin/sh` and `-c` when you would like to receive 
system signals.


## **DO NOT** use `yarn run ${scriptName}` in `CMD` and `ENTRYPOINT` when you want to receive the system signals

`yarn` is also working in the `CMD` and `ENTRYPOINT` instruction when 
the base image includes `yarn` or it has been installed in the build 
image process. To run a `yarn` script, it can be done as follows:
```dockerfile
CMD ["yarn", "greeting", "serve"]
```
```dockerfile
ENTRYPOINT ["yarn", "greeting", "serve"]
```
or
```dockerfile
CMD ["/bin/sh", "-c", "yarn greeting serve"]
```
```dockerfile
ENTRYPOINT ["/bin/sh", "-c", "yarn greeting serve"]
```

However, the `dist/server.js` cannot receive system signal, such as `Ctrl+C`
, from the command line prompt when the `CMD` and `ENTRYPOINT` 
instructions use the `yarn` script. As a result, 
please do not to use `yarn` script when you would like to receive 
system signals.

# Reference

- [Dockerfiles now Support Multiple Build Contexts](https://www.docker.com/blog/dockerfiles-now-support-multiple-build-contexts/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker build](https://docs.docker.com/engine/reference/commandline/build/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Overriding Dockerfile image defaults](https://docs.docker.com/engine/reference/run/#overriding-dockerfile-image-defaults)