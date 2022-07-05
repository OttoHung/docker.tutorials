# Docker Tutorials

This tutorial shows up how to build a docker image with the complex 
build configurations.


# What version of Docker is this tutorial targeting?

All of the examples and use cases are working against `Dockerfile` 
1.4 and `Buildx` v0.8+. Please ensure the version of `Dockerfile` 
and `Buildx` before starting this tutorial. If you would like to 
install or upgrade the Docker, please go to 
[Install Docker Engine](https://docs.docker.com/engine/install/) page. 


# Why do we need the Build Context flag?

To build an image by docker, the single build context from a local 
repository is given from a path in the docker build command as:
```bash
docker build -t ${imageName}:${tag} .
```
However, this is not allowed to access files outside of specified 
build context by using the `../` parent selector for security 
reasons. This leads to the build context must be at the root 
directory if the developers would like to build an image for 
multiple different projects and it results in many `COPY` and 
`ADD` instructions being written in the `Dockerfile` to achieve 
the goal and these reduce the readability of code. Fortunately, 
`Docker` supports multiple build context flags in `Dockerfile 1.4`. 
This reduces the complexity of `Dockerfile` and provides more 
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

## Using `["/bin/sh", "-c"]` in `CMD` or `ENTRYPOINT` when you want to receive the system signals

In the execution form of `CMD` and `ENTRYPOINT`, it allows users to use 
`["executable" "param1" "param2"]` to execute a command. It means there 
are two ways to use the execution form:
```dockerfile
CMD ["node", "dist/server.js"]
```
> [Learn More](Dockerfile)
> 
```dockerfile
ENTRYPOINT ["node", "dist/server.js"]
```
> [Learn More](Dockerfile_greeting)
> 
or
```dockerfile
CMD ["/bin/sh", "-c", "node dist/server.js"]
```
> [Learn More](Dockerfile_cmd_sh)
> 
```dockerfile
ENTRYPOINT ["/bin/sh", "-c" , "node dist/server.js"]
```
> [Learn More](Dockerfile_entrypoint_sh)
> 

However, the `dist/server.js` cannot receive system signals, such as 
`Ctrl+C`, from the command line prompt when the `CMD` and `ENTRYPOINT` 
instructions go with `/bin/sh` to initiate `dist/server.js`. As a 
result, please do not use `/bin/sh` and `-c` when you would like 
to receive system signals.


## Using `yarn` script in `CMD` or `ENTRYPOINT` when you want to receive the system signals

`yarn` can be used in the `CMD` and `ENTRYPOINT` instruction when 
the base image includes `yarn` or it has been installed in the build 
image process. To run a `yarn` script to enable `dist/server.js`, it 
can be done as follows:
```dockerfile
CMD ["yarn", "greeting", "serve"]
```
> [Learn More](Dockerfile_cmd_yarn)
> 
```dockerfile
ENTRYPOINT ["yarn", "greeting", "serve"]
```
> [Learn More](Dockerfile_entrypoint_yarn)
> 
or
```dockerfile
CMD ["/bin/sh", "-c", "yarn greeting serve"]
```
> [Learn More](Dockerfile_cmd_yarn_sh)
> 
```dockerfile
ENTRYPOINT ["/bin/sh", "-c", "yarn greeting serve"]
```
> [Learn More](Dockerfile_entrypoint_yarn_sh)
> 

However, the `dist/server.js` excuedted in `serve` script cannot receive 
system signal, such as `Ctrl+C`, from the command line prompt when the 
`CMD` and `ENTRYPOINT` instructions use the `yarn` script. As a result, 
please do not use `yarn` script when you would like to receive system 
signals.


## Build context is always built from the root directory

This may be true if the `docker build` command is executed at the root 
directory, but it may not be true if the command is executed in the sub
directory or other directories. There are two examples explaining what 
is the difference as follows:

### Execute `docker build` in root directory

It's easy to build a docker image in the root directory as executing:
```bash
docker run -t docker.tutorials:root .
```
> [Learn More](scripts/pack_build_context_root.sh)
> 
Then this image contains everything under the root directory.
```bash
~/Documents/repos/docker.tutorials - (main) $ docker run -it docker.tutorials:root sh
# ls
Dockerfile                Dockerfile_cmd_yarn       Dockerfile_entrypoint_yarn     LICENSE      jest.config.ts  scripts        yarn.lock
Dockerfile_build_context  Dockerfile_cmd_yarn_sh    Dockerfile_entrypoint_yarn_sh  README.md    node_modules    tsconfig.json
Dockerfile_cmd_sh         Dockerfile_entrypoint_sh  Dockerfile_greeting            dockerfiles  package.json    workspaces
```

### Execute `docker build` in workspace directory

In this case, the location of `Dockerfile` must be given in the command line 
prompt because there is no `Dockerfile` in `workspaces` directory as follows:
```bash
docker run -t docker.tutorials:workspaces -f ../Dockerfile_build_context .
```
> [Learn More](scripts/pack_build_context_workspace.sh)

Then the image contains the directory in `workspaces` only.
```bash
~/Documents/repos/docker.tutorials - (main) $ docker run -it docker.tutorials:workspaces sh
# ls
greeting
```

### Conclusion

As a result, the path, `.`, of build context is based on where the docker 
command is executed, not where the docker file is allocated. If the 
build context is specified with a file path, the build context is from 
that path. For example, building image from `workspaces/greeting` folder 
when executing `docker build` command in `dockerfiles` directory.
```bash
docker build -t docker.tutorials:greeting -f ../Dockerfile_build_context ../workspaces/greeting
```
> [Learn More](scripts/pack_build_context_greeting.sh)
> 
The image contains the files under `workspaces/greeting` only as follows:
```bash
~/Documents/repos/docker.tutorials - (main) $ docker run -it docker.tutorials:greeting sh
# ls
dist  package.json  src  tsconfig.json
```


# Best practice

- Always pick up the smallest size of the base image, such as [distroless container image](https://github.com/GoogleContainerTools/distroless).
- Always use multiple-stage builds to reduce the size of the image
- Always combining `RUN` instruction and minimizing the usage of `ADD`, `COPY` and `FROM` to reduce the size of the image
- Utilizing caching to speed up the build process
- Ignoring non-releasable files or resources
- Always using `volumes` to store data


# Reference

- [Dockerfiles now Support Multiple Build Contexts](https://www.docker.com/blog/dockerfiles-now-support-multiple-build-contexts/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker build](https://docs.docker.com/engine/reference/commandline/build/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Overriding Dockerfile image defaults](https://docs.docker.com/engine/reference/run/#overriding-dockerfile-image-defaults)
- [Use volumes](https://docs.docker.com/storage/volumes/)