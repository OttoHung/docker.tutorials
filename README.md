# Docker Tutorials

This tutorial shows up how to do a complex builds


# What version of Docker is this tutorial target?

All of the examples and use cases are working against Dockerfile 1.4 and Buildx 
v0.8. Please ensure the version of Dockerfile and Buildx before starting this 
tutorial. If you would like to install or upgrade the Docker, please go to 
[Install Docker Engine](https://docs.docker.com/engine/install/) page. 


# Preface

Until Dockerfile 1.4, the build context for the docker image is given from a 
path in the docker build command as:
```bash
docker build .
```


# Useful Commands

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