# Docker Tutorials

This tutorial shows up how to do a complex builds


# What version of Docker is this tutorial target?

All of the examples and use cases are working against `Dockerfile` 
1.4 and `Buildx` v0.8+. Please ensure the version of `Dockerfile` 
and `Buildx` before starting this tutorial. If you would like to 
install or upgrade the Docker, please go to 
[Install Docker Engine](https://docs.docker.com/engine/install/) page. 


# Preface

Until `Dockerfile` 1.4, the build context from a local repository for 
the docker image is given from a path in the docker build command as:
```bash
docker build .
```
It results in many `COPY` and `ADD` instructions being written in the 
`Dockerfile` and reduces the readability of code when the developers 
would like to pack an image from a mono repo. Also, the build context 
could not be in the parent directory either. Fortunately, `Docker` 
supports multiple build context flag in `Dockerfile 1.4`. This 
reduces the complexity of `Dockerfile` and provides more flexibility 
in organising build contexts in the code with CI/CD pipeline.


# What is the Build Context flag?

Build context flag allows developers to define four types of build 
contexts, including `local directory`, `Git repository`, 
`HTTP URL to tarball` and `Docker image`.

The syntax of the build context flag is:
```bash
docker build --build-context ${name}=${sourceOfContext}
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
  --build-context ${context2}=${sourceOfContext2}
```


## Load build context from a Local Directory

Build context flag accepts relative file path and absolute file 
path when the user would like to build an image from the files 
in a local directory.

To load build context from a relative file path:
```bash
docker build --build-context greetingService=./workspaces/greeting
```
Or
```base
docker build --build-context greetingService=workspaces/greeting
```

If the `Dockerfile` is not in the root directory as follows:
```bash
.
+-- dockerfile
|   +-- greeting
|   +-- calculator
+-- workspaces
|   +-- greeting
|   +-- calculator
+-- package.json
+-- README.md
```
Then the file path can be typed in the following format:
```bash
docker build --build-context greetingService=../workspaces/greeting
```




- `local directory`:
  The absolute and relative paths are supported as well as the 
  directory is in the parent folder.
  - `--build-context multiBuild=~/repo/docker.tutorials/workspaces/multi-build-contexts`
  - `--build-context multiBuild=/workspaces/multi-build-contexts`
  - `--build-context multiBuild=./workspaces/multi-build-contexts`
  - `--build-context multiBuild=../multi-build-contexts`
- a


# CLI Commands for building and validating the docker image

Build an image with a tag:
```bash
docker build -t ${imageName}:${tag} .
```

Investigate the content of an image when the container uses `CMD` instruction 
to execute a command:
```bash
docker run -it ${imageName}:${tag} sh
```

Or access the content of an image by `--entrypoint` when the container uses
`Entrypoint` instruction to execute a command:
```bash
docker run -it --entrypoint sh ${imageName}:${tag}
```

Or writing the build history into a file:
```bash
docker image history --no-trunc ${imageName}:${tag} > ${fileName}
```

To create a container by the image for a service:
```bash
docker run -p ${port}:${port} ${imageName}:${tag}
```


# Reference

- [Dockerfiles now Support Multiple Build Contexts](https://www.docker.com/blog/dockerfiles-now-support-multiple-build-contexts/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker build](https://docs.docker.com/engine/reference/commandline/build/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)