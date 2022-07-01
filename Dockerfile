# syntax=docker/dockerfile:1
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from all contexts

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1 AS baseBuild

WORKDIR /build
## There are files under workspaces/greeting/dist to app direcotry only
COPY ["./", "/build"]

## Due to docker cannot access private repository and download packages from private 
## package registry, it's not recommended to run `yarn install` in dockerfile.
## Also, the access token should not be used in the docker build because it can be
## retrieved from history.

RUN yarn build


FROM node:14.17.1 AS appBuild
WORKDIR /app
COPY --from=baseBuild ["/build", "/app"]
EXPOSE 5478

CMD ["node", "workspaces/greeting/dist/server.js" ]
