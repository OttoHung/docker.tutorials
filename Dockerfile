# syntax=docker/dockerfile:1

# Use DOCKER_BUILDKIT=1 in the command line prompt to speed up the build time
FROM node:14.17.1 AS baseBuild

WORKDIR /app
# There are files under workspaces/multiple-build-contexts/dist to app direcotry only
COPY ["./", "/app"]

# For investigating the context in the image, please use docker run -it ${imageName}:${tag} sh
CMD ["node", "workspaces/multiple-build-contexts/dist/server.js" ]
# Or use:
# CMD ["node", "./server.js"]

# For investigating the context in the image, please use docker run -it --entrypoint sh ${imageName}:${tag}
# ENTRYPOINT ["/bin/sh", "-c", "node ./server.js"]
# Or use:
# ENTRYPOINT ["node", "./server.js"]