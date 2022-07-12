# syntax=docker/dockerfile:1.4
## The above line indicates what version of Dockerfile is.

## This docker file build image from a specific workspace
## In this case, greeting service will be included

#####################################################################
# Caution:
#   This dockerfile cannot build image due to buildx download git 
#   repository before executing instructions and the SSH key only can
#   be loaded in the `RUN` instruction after the git repository has 
#   been downloaded.
#   Alternatively, using `RUN` instruction to clone git repository as:
#       `RUN --mount=type=ssh git clone ${SSH_URL}`
#   
#   By using `--ssh` in the command prompt, the SSH keys won't be 
#   stored in the image based on experiment.
#####################################################################

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
## *-alpine doesn't have git installed
FROM node:14.17.1-alpine AS sourceStage
WORKDIR /source

## alpine doesn't have openssh-client and git
RUN apk update && apk upgrade \
    apk add --no-cache openssh-client git

## This must be run before cloning the git repository
RUN mkdir -p -m 0700 ~/.ssh \
    && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

## This doens't work because `buildx` cannot clone git repository due to 
## this is no way to provide the SSH keys to the clone process.
## Based on the experiment, the clone process is commenced before executing
## the first instructions.
COPY --from=repo ["./", "/source"]

FROM node:14.17.1-alpine AS buildStage
WORKDIR /build

COPY --from=sourceStage ["/source", "/build"]
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
COPY --from=moduleBuild ["/module", "/app"]

EXPOSE 5478

## To use `ENTRYPOINT` due to this image should be started up
## from `server.js` file
ENTRYPOINT [ "node", "workspaces/greeting/dist/server.js"]
