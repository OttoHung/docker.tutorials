# syntax=docker/dockerfile:1.4
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from a specific workspace
## In this case, greeting service will be included

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
## *-alpine doesn't have git installed
FROM node:14.17.1-alpine AS sourceStage
ARG REPO
WORKDIR /source

RUN apk update && apk upgrade \
    && apk add --no-cache git
RUN --mount=type=secret,id=pat \
    PAT="$(cat /run/secrets/pat)"; \
    git clone https://${PAT}@${REPO}

FROM node:14.17.1-alpine AS buildStage
WORKDIR /build
ARG REPO_NAME
COPY --from=sourceStage ["/source/${REPO_NAME}", "/build"]

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
COPY --from=buildStage ["/build/workspaces/greeting", "/module/workspaces/greeting"]


## In this build, all source files are discarded to reduce the size of image
FROM node:14.17.1-alpine AS appBuild
WORKDIR /app
COPY --from=moduleStage ["/module/node_modules", "/app/node_modules"]
COPY --from=moduleStage ["/module/package.json", "/app"]
COPY --from=moduleStage ["/module/LICENSE", "/app"]

## THis line must be executed before others to eliminate build error(xxx is not a directory)
COPY --from=moduleStage ["/module/workspaces/greeting/dist", "/app/workspaces/greeting/dist"]

COPY --from=moduleStage ["/module/workspaces/greeting/package.json", "/app/workspaces/greeting"]
EXPOSE 5478

## To use `ENTRYPOINT` due to this image should be started up
## from `server.js` file
ENTRYPOINT [ "node", "workspaces/greeting/dist/server.js"]
