# Docker Tutorials <!-- omit in toc -->

This tutorial shows up how to build a docker image.


# Table of Content <!-- omit in toc -->

- [CLI Commands for building and inspecting the docker image](#cli-commands-for-building-and-inspecting-the-docker-image)
  - [Build docker image with tag](#build-docker-image-with-tag)
  - [Investigate image content](#investigate-image-content)
  - [Write build image log to a file](#write-build-image-log-to-a-file)
  - [Ceate a container for a service](#ceate-a-container-for-a-service)
- [Pitfalls](#pitfalls)
  - [Using `["/bin/sh", "-c"]` in `CMD` or `ENTRYPOINT` when you want to receive the system signals](#using-binsh--c-in-cmd-or-entrypoint-when-you-want-to-receive-the-system-signals)
  - [Using `yarn` script in `CMD` or `ENTRYPOINT` when you want to receive the system signals](#using-yarn-script-in-cmd-or-entrypoint-when-you-want-to-receive-the-system-signals)
  - [Build context is always built from the root directory](#build-context-is-always-built-from-the-root-directory)
    - [Execute `docker build` in the root directory](#execute-docker-build-in-the-root-directory)
    - [Execute `docker build` in the workspace directory](#execute-docker-build-in-the-workspace-directory)
    - [Conclusion](#conclusion)
- [Best practice](#best-practice)
- [Reference](#reference)



# CLI Commands for building and inspecting the docker image

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

Alternatively, running the container in the background by executing:
```bash
docker run -d -p ${port}:${port} ${imageName}:${tag}
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
`Ctrl+C`, from the command prompt when the `CMD` and `ENTRYPOINT` 
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

However, the `dist/server.js` is executed in `serve` script cannot 
receive system signal, such as `Ctrl+C`, from the command prompt when 
the `CMD` and `ENTRYPOINT` instructions use the `yarn` script. As a 
result, please do not use `yarn` script when you would like to receive 
system signals.


## Build context is always built from the root directory

This may be true if the `docker build` command is executed at the root 
directory, but it may not be true if the command is executed in the sub
directory or other directories. There are two examples explaining what 
is the difference as follows:

### Execute `docker build` in the root directory

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

### Execute `docker build` in the workspace directory

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

- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Overriding Dockerfile image defaults](https://docs.docker.com/engine/reference/run/#overriding-dockerfile-image-defaults)
- [Use volumes](https://docs.docker.com/storage/volumes/)
- [Document build secrets passed via environment variables](https://github.com/docker/buildx/issues/927)
  