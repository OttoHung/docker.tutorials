IMG_NAME=docker.tutorials:build-path-git-ssh-public-workspaces

## BuildKit cannot be used in this case because it is not supported yet.
export DOCKER_BUILDKIT=0

# By using this to build docker image, a `Dockerfile` is 
# required at root directory.
REPO=git@github.com:OttoHung/docker.tutorials#main

echo "Start to build docker image from: ${REPO}"

# Build docker image from public git repository via HTTPS
#
# The path of `Dockerfile` is not required because this 
# approach gathers `Dockerfile` from root directory.
#
# Without BuildKit, the npm token cannot be passed to 
# `Dockerfile` to download modules. As a result, this
# script will fail on execution.
docker build \
        --no-cache \
        -t ${IMG_NAME} \
        ${REPO}
