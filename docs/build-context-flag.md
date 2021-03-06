# Build docker image from multiple build contexts <!-- omit in toc -->

- [What version of Docker is this tutorial targeting?](#what-version-of-docker-is-this-tutorial-targeting)
- [Why do we need the Build Context flag?](#why-do-we-need-the-build-context-flag)
- [What is the Build Context flag?](#what-is-the-build-context-flag)
  - [Load build context from a Local Directory](#load-build-context-from-a-local-directory)
  - [Load build context from a Git repository](#load-build-context-from-a-git-repository)
    - [Clone the git repository via HTTPS](#clone-the-git-repository-via-https)
    - [Clone the git repository via SSH](#clone-the-git-repository-via-ssh)
  - [Load build context from a tarball via HTTP URL](#load-build-context-from-a-tarball-via-http-url)
  - [Load build context from a docker image](#load-build-context-from-a-docker-image)
- [Reference](#reference)


# What version of Docker is this tutorial targeting?

All of the examples and use cases are working against `Dockerfile` 
1.4 and `Buildx` v0.8+. Please ensure the version of `Dockerfile` 
and `Buildx` before starting this tutorial. If you would like to 
install or upgrade the Docker Engine, please refers to   
[Install Docker Engine](https://docs.docker.com/engine/install/) page. 


# Why do we need the Build Context flag?

To build an image by docker, the single build context from a local 
repository is given from a path in the docker build command as:
```bash
docker build -t ${imageName}:${tag} .
```
However, this is not allowed to access files outside of specified 
build context by using `../` parent selector for security 
reasons. This leads to the build context must be at the root 
directory if the developers would like to build an image for 
multiple different projects and it results in many `COPY` and 
`ADD` instructions being written in the `Dockerfile` to achieve 
this goal, which reduce the readability of code. Fortunately, 
`Dockerfile 1.4` and `Buildx v0.8+` support multiple build context flags 
right now. This reduces the complexity of `Dockerfile` and provides 
more flexibility in organising build contexts in the code with CI/CD 
pipeline.


# What is the Build Context flag?

Build context flag allows developers to define four types of build 
contexts, including `local directory`, `Git repository`, 
`HTTP URL to tarball` and `Docker image`.

The syntax of the build context flag is:
```bash
docker buildx build \
  --build-context ${name}=${pathToContext} \
  -t ${imageName}:${tag} \
  .
```
`${name}` is the name of the build context, must be lowercase, 
which will be used in the Dockerfile and the `${pathToContext}` 
is the location of the build context from `local directory`, 
`Git repository`, `HTTP URL to tarball` or `Docker image`.

Also, `Dockerfile 1.4` supports multiple build contexts for an 
image by using:
```bash
docker build \
  --build-context ${context1}=${pathToContext1} \
  --build-context ${context2}=${pathToContext2} \
  -t ${imageName}:${tag} \
  .
```

By using build context flags, developers have the ability to 
copy the context outside of the build directory.


## Load build context from a Local Directory

Build context flag accepts relative file path and absolute file 
path when the user would like to build an image from the files 
in a local directory.

To load build context from a relative file path:
```bash
docker buildx build \
  --build-context app=./workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/local-directory/build_from_root.sh)
> 
Or
```base
docker buildx build \
  --build-context app=workspaces/greeting \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/local-directory/build_from_root_no_dot.sh)

If the build context is not in the same directory as follows:
```bash
.
+-- resources
|   +-- icons
+-- docker.tutorials
|   +-- dockerfiles
|       +-- greeting
|       +-- calculator
|   +-- workspaces
|       +-- greeting
|       +-- calculator
|   +-- package.json
|   +-- README.md
```
The absolute file path could be fit in this case:
```bash
docker buildx build \
  --build-context resources=/Users/Documents/resources/icons \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/local-directory/build_from_absolute_path.sh)
>
> Note: Please do not use `tidle(~)` in the file path. `Buildx` cannot 
> find the build context in this form.
> 

Alternatively, the build context can be accessed by notating double-dot(`..`) when 
the directory is in the parent folder of current location:
```bash
docker buildx build \
   --build-context resources=../resources/icons \
   -t ${imageName} \
```
> [Learn More](../scripts/build-contexts/local-directory/build_from_parent.sh)
> 

## Load build context from a Git repository

### Clone the git repository via HTTPS

It is quite simple to load build context from a Git repository by 
specifying the URL of the repository and tagging the branch name with 
harsh(`#`) at the end of the URL as:
```bash
docker buildx build \
  --build-context repo=https://github.com/OttoHung/docker.tutorial.git#main \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/git/https/build_from_public.sh) 
> 

The build context will be cloned to a directory with the name of the 
repository in the `WORKDIR`. For example, the name of repository is 
`docker.tutorials` and the build context will be stored in a directory 
named `docker.tutorials` in this case:
```
.
+-- ${WORKDIR}
|   +-- docker.tutorials
|       +-- README.md
|       +-- node_modules
|       +-- LICENSE
+-- bin
+-- usr
```

However, `Buildx` cannot clone a private repository when the access is 
unauthenticated with an error message returned as 
`fatal: could not read Username for 'https://github.com': terminal prompts disabled`. [[Learn More](../scripts//build-contexts/git/https/build_from_private.sh)]
It looks like `Buildx` clones the repository before 
executing instructions and there is no other way to provide access 
tokens to `Buildx` currently. The solution for this circumstance could use the 
following `RUN` instruction to clone the remote repository which is much safer
than using Personal Acess Token (PAT) in the URL.
```dockerfile
RUN --mount=type=secret,id=${SECRET_ID} \
    PAT=$(cat /run/secrets/${SECRET_ID}) \
    git clone https://${PAT}@${REPO_URL}.git
```
> [Learn More](../dockerfiles//git/https/private/Dockerfile)

### Clone the git repository via SSH

By assiging a SSH URL to `Buildx` like:
```bash
docker buildx build \
  --build-context repo=git@github.com:OttoHung/docker.tutorials.git#main \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/git/ssh/build.sh) 
> 
However, the remote repository cannot be cloned and an error message 
returned as 
`unsupported context source **git@github.com** for ${BUILD_CONTEXT_NAME}`.

To resolve this issue, it is recommended using `--ssh` with `Buildx` to 
clone the repository by `RUN --mount=type=ssh git clone ${GIT_REPO_URL}`.
[[Learn More](../dockerfiles/git/ssh//Dockerfile)]

Then the build context will be cloned into the same folder structure listed 
at [Clone the git repository via HTTPS](#clone-the-git-repository-via-https)


## Load build context from a tarball via HTTP URL

Build context flag also supports downloading tarball(`*.tar` or `*.tar.gz`) 
via a HTTP URL as:
```bash
docker buildx build \
  --build-context dockerTutorial=https://github.com/OttoHung/docker.tutorials/archive/refs/tags/tarball.tar.gz \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/tarball/build_from_http.sh)
> 

Once the tarball file has been downloaded, it is required to unpack tarball 
before copying the contents to other work directory. On macOS, `tar -xzf` 
could be used to unpack the tarball.
[[Learn More](../dockerfiles/build-contexts/tarball/Dockerfile)]

It is recommended double-checking the directory name is as same as the 
tarball name before making a tarball. If the names of both are different, 
such as the tarball packed by GitHub Release, the folder name must be given 
to the `dockerfile` to copy the contents because the tarball name is not 
the same.


## Load build context from a docker image

`Dockerfile 1.4` supports that the docker image can be loaded by `FROM` 
instruction with the URL of the image as:
```dockerfile
FROM https://ghcr.io/OttoHung/greeting:latest
```
Or specifying the name of the docker image:
```dockerfile
FROM alpine:3.15
```
> [Learn More](../dockerfiles/build-contexts/docker-image/Dockerfile)
> 

In command prompt, the docker image must 
go with `docker-image://` prefix to tell what docker image to load. 
For example:
```bash
docker buildx build
  --build-context alpine=docker-image://alpine:3.15 \
  -t ${imageName}:${tag} \
  .
```
> [Learn More](../scripts/build-contexts/docker-image/build_from_latest.sh)
> 

Also, image digest following up the tag of image can be used to specify 
a particular version for the image as:
```shell
ghcr.io/ottohung/docker.tutorials:git-https@sha256:b9f33235036f68d3d510a8800e27e3b6514142119cbd5f4862f0506d8cc8552d
```
> [Learn More](../scripts/build-contexts/docker-image/build_from_version.sh)
> 

The benefit of using build context flag for docker image is we can specifying 
multiple docker images, sucn as base image and image for app, from command 
prompt dynamically. So that we don't need to modify `dockerfile` when we would 
like to choose other base image for the build.
```bash
docker buildx build
  --build-context baseImage=docker-image://alpine:3.15 \
  --build-context appImage=docker-image://node:14.17.1-alpine \
```


# Reference

- [Dockerfiles now Support Multiple Build Contexts](https://www.docker.com/blog/dockerfiles-now-support-multiple-build-contexts/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Build context](https://docs.docker.com/engine/reference/commandline/buildx_build/#build-context)
- [Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/#new-docker-build-secret-information)
- 