# syntax=docker/dockerfile:1.4
## The above line indicates what version of Dockerfile is in use.

## This docker file build image from a specific workspace
## In this case, greeting service will be included

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
## *-alpine doesn't have git installed
FROM image AS sourceStage
EXPOSE 5478

## To use `ENTRYPOINT` due to this image should be started up
## from `server.js` file
ENTRYPOINT [ "node", "workspaces/greeting/dist/server.js"]
