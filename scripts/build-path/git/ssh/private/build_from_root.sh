IMG_NAME=docker.tutorials:build-path-git-ssh-private
export DOCKER_BUILDKIT=1

# By using this to build docker image, a `Dockerfile` is 
# required at root directory.
#
## This build will fail because the SSH key is not
## provided. It's not recommended adding SSH key via 
## `Dockerfile` because it can be seen in the build log 
## as plain text.
## The best practice is using `--ssh` to pass SSH clinet 
## agent to docker deamon and use `git clone` in the 
## `Dockerfile`.
REPO=git@github.com:OttoHung/private-test.git#main

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
