IMG_NAME=docker.tutorials:home
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image at root directory
# The name of build context must be lowercase
## Failed because tidle(~) cannot be recognised by docker build
## Please use `$HOME`` instead
docker buildx build \
    --build-context repo=$HOME/repo/docker.tutorials \
    --build-context greeting=$HOME/repo/docker.tutorials/workspaces/greeting \
    -t ${IMG_NAME} \
    -f ./dockerfiles/greeting .
