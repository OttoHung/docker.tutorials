IMG_NAME=docker.tutorials:build-path-git-https-public
export DOCKER_BUILDKIT=1

# By using this to build docker image, a `Dockerfile` is 
# required at root directory.
REPO=git@github.com/OttoHung/docker.tutorials#main

echo "Start to build docker image from: ${REPO}"

# Build docker image from public git repository via HTTPS
#
# The path of `Dockerfile` is not required because this 
# approach gathers `Dockerfile` from repository.
docker build \
        --secret id=npm,src=$HOME/.npmrc \
        --no-cache \
        -t ${IMG_NAME} \
        ${REPO}
