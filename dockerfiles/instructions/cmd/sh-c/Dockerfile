# syntax=docker/dockerfile:1
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from all contexts

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1-alpine AS baseBuild

WORKDIR /build
## There are files under workspaces/greeting/dist to app direcotry only
COPY ["./", "/build"]

## In order to install modules from private package registry, access token must
## be loaded by secret. Due to root is not accessible, the best practice is 
## using project location to save access token temporaryly.
## And run `install` command at the same layer to get the access to access token.
## Based on https://docs.docker.com/develop/develop-images/build_enhancements/#new-docker-build-secret-information,
## this secret won't store at the final image at all.
RUN --mount=type=secret,id=npm,target=/build/.npmrc \
    yarn install
RUN yarn build


FROM node:14.17.1-alpine AS appBuild
WORKDIR /app
COPY --from=baseBuild ["/build", "/app"]

EXPOSE 5478

## Failed to receive system signal
CMD ["/bin/sh", "-c", "node workspaces/greeting/dist/server.js" ]
