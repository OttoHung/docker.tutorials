IMG_NAME=docker.tutorials:whole_project
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
docker buildx build \
    --secret id=npm,src=$HOME/.npmrc \
    -t ${IMG_NAME} .
