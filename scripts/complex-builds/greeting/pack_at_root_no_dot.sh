IMG_NAME=docker.tutorials:root-no-dot
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image at root directory
# The name of build context must be lowercase
docker buildx build \
    --build-context repo=. \
    --build-context greeting=workspaces/greeting \
    -t ${IMG_NAME} \
    -f ./dockerfiles/greeting .
