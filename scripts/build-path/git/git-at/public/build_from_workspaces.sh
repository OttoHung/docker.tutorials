IMG_NAME=docker.tutorials:build-path-git-at-public-workspaces

## BuildKit cannot be used in this case because it is not supported yet.
export DOCKER_BUILDKIT=0

SUB_DIR=workspaces

## In this case, Buildkit doesn't support `SSH` but `git@`.
## So that the URL of repository must use slash (/) as the
## delimiter.

# By using this to build docker image, a `Dockerfile` is 
# required at the `workspaces` directory.
#
## Cannot clone repo via this URL.
## Error:
##      'git@github.com/OttoHung/docker.tutorials' does not appear to be 
##      a git repository fatal: Could not read from remote repository.
##      Please make sure you have the correct access rights and the 
##      repository exists.
REPO=git@github.com/OttoHung/docker.tutorials#main:${SUB_DIR}

echo "Start to build docker image from: ${REPO}"

# Build docker image from public git repository via git@
#
# The path of `Dockerfile` is not required because this 
# approach gathers `Dockerfile` from `workspaces` repository.
docker build \
        --no-cache \
        -t ${IMG_NAME} \
        ${REPO}
