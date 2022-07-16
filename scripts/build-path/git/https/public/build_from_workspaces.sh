IMG_NAME=docker.tutorials:build-path-git-https-public-workspaces

## BuildKit cannot be used in this case because it is not supported yet.
export DOCKER_BUILDKIT=0

SUB_DIR=workspaces

# By using this to build docker image, a `Dockerfile` is 
# required in the `${SUB_DIR}` directory.
REPO=https://github.com/OttoHung/docker.tutorials.git#main:${SUB_DIR}

echo "Start to build docker image from: ${REPO}"

# Build docker image from public git repository via HTTPS
#
# The path of `Dockerfile` is not required because this 
# approach gathers `Dockerfile` from `workspaces` directory.
docker build \
        --no-cache \
        -t ${IMG_NAME} \
        ${REPO}
