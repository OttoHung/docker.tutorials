# syntax=docker/dockerfile:1

## This docker file build image from all contexts

## Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1 AS baseBuild

WORKDIR /build
## There are files under workspaces/multiple-build-contexts/dist to app direcotry only
COPY ["./", "/build"]
RUN yarn build


FROM node:14.17.1 AS appBuild
WORKDIR /app
COPY --from=baseBuild ["/build", "/app"]
EXPOSE 5478

## For investigating the context in the image, please use docker run -it ${imageName}:${tag} sh
## This can receive SIGTERM
CMD ["node", "workspaces/multi-build-contexts/dist/server.js" ]
# Or use:
# CMD ["node", "./server.js"]

## For investigating the context in the image, please use docker run -it --entrypoint sh ${imageName}:${tag}
## This can receive SIGTERM
# ENTRYPOINT ["/bin/sh", "-c", "node workspaces/multi-build-contexts/dist/server.js"]
# Or use:
# ENTRYPOINT ["node", "workspaces/multi-build-contexts/dist/server.js"]