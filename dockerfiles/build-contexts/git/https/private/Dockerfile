# syntax=docker/dockerfile:1.4
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from a specific workspace
## In this case, greeting service will be included

#####################################################################
# Caution:
#   This dockerfile cannot build image due to buildx download git 
#   repository before executing instructions and the username and 
#   password only can be loaded in the `RUN` instruction after the git 
#   repository has been downloaded.
#   Alternatively, using `RUN` instruction to clone git repository as:
#   RUN --mount=type=secret,id=pat \
#       PAT="$(cat /run/secrets/pat)"; \
#       git clone https://${PAT}@${REPO}
#   
#   By using `--secret` in the command prompt, the username and password 
#   won't be stored in the image based on experiment.
#####################################################################


## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
## *-alpine doesn't have git installed
FROM node:14.17.1-alpine AS sourceStage
WORKDIR /source

## This doesn't work because the repository clone process is commenced before 
## executing instructions. To resolve this issue, please use the following 
## instruction instead:
##   RUN --mount=type=secret,id=pat \
##       PAT="$(cat /run/secrets/pat)"; \
##       git clone https://${PAT}@${REPO}
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
COPY --from=buildStage ["/module/workspaces/greeting/dist", "/module/workspaces/greeting/dist"]

COPY --from=buildStage ["/module/workspaces/greeting/package.json", "/module/workspaces/greeting"]


## In this build, all source files are discarded to reduce the size of image
FROM node:14.17.1-alpine AS appStage
WORKDIR /app
RUN apk --no-cache add curl
COPY --from=moduleStage ["/module", "/app"]

EXPOSE 5478

HEALTHCHECK CMD ["/bin/sh", "-c", "curl --fail 0.0.0.0:5478 || exit 1"]

## To use `ENTRYPOINT` due to this image should be started up
## from `server.js` file
ENTRYPOINT [ "node", "workspaces/greeting/dist/server.js"]
