IMG_NAME=docker.tutorials:run-at-module-layer
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image by context in the module under "/workspaces"
# Secret is used to install npm packages in docker deamon.
cd workspaces
cd greeting

docker build \
        --secret id=npm,src=$HOME/.npmrc \
        --no-cache \
        -t ${IMG_NAME} \
        -f ../../dockerfiles/execution-location/Dockerfile .
