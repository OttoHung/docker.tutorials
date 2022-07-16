IMG_NAME=docker.tutorials:build-path-git-at-public
export DOCKER_BUILDKIT=1

## In this case, Buildkit doesn't support `SSH` but `git@`.
## So that the URL of repository must use slash (/) as the
## delimiter.

# By using this to build docker image, a `Dockerfile` is 
# required at root directory.
REPO=git@github.com/OttoHung/docker.tutorials#main

echo "Start to build docker image from: ${REPO}"

# Build docker image from public git repository via git@
#
# The path of `Dockerfile` is not required because this 
# approach gathers `Dockerfile` from root repository.
docker build \
        --secret id=npm,src=$HOME/.npmrc \
        --no-cache \
        -t ${IMG_NAME} \
        ${REPO}
