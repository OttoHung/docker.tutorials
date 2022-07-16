# syntax=docker/dockerfile:1
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from all contexts

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1-alpine AS sourceStage

WORKDIR /source
## There are files under workspaces/greeting/dist to app direcotry only
COPY ["./", "/source"]

CMD ["/bin/sh", "-c", "ls -R"]
