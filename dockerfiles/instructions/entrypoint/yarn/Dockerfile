# syntax=docker/dockerfile:1
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from a specific workspace
## In this case, greeting service will be included

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1-alpine AS buildStage

WORKDIR /build
## There are files under workspaces/greeting/dist to app direcotry only
# COPY --from=sourceStage ["/source", "/build"]
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


FROM node:14.17.1-alpine AS moduleStage
WORKDIR /module
COPY --from=buildStage ["/build/node_modules", "/module/node_modules"]
COPY --from=buildStage ["/build/package.json", "/module"]
COPY --from=buildStage ["/build/LICENSE", "/module"]

## THis line must be executed before others to eliminate build error(xxx is not a directory)
COPY --from=buildStage ["/build/workspaces/greeting/dist", "/module/workspaces/greeting/dist"]

COPY --from=buildStage ["/build/workspaces/greeting/package.json", "/module/workspaces/greeting"]


## In this build, all source files are discarded to reduce the size of image
FROM node:14.17.1-alpine AS appStage
WORKDIR /app
RUN apk --no-cache add curl
COPY --from=moduleStage ["/module", "/app"]

EXPOSE 5478

HEALTHCHECK CMD ["/bin/sh", "-c", "curl --fail 0.0.0.0:5478 || exit 1"]

## To use `ENTRYPOINT` due to this image should be started up
## from `server.js` file
##
## Failed to recive system signals
ENTRYPOINT ["yarn", "greeting", "serve"]
