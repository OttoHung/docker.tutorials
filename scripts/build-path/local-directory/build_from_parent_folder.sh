IMG_NAME=docker.tutorials:parent-directory
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image by context in parent directory
cd dockerfiles

# Secret is used to install npm packages in docker deamon.
docker build \
        --secret id=npm,src=$HOME/.npmrc \
        --no-cache \
        -t ${IMG_NAME} \
        -f ../dockerfiles/execution-location/Dockerfile \
        ../workspaces/greeting
