IMG_NAME=docker.tutorials:root-no-dot
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image at root directory
# The name of build context must be lowercase
# Secret is used to install npm packages in docker deamon.
docker buildx build \
    --build-context repo=. \
    --build-context app=workspaces/greeting \
    --secret id=npm,src=$HOME/.npmrc \
    -t ${IMG_NAME} \
    -f ./dockerfiles/build-contexts/local-directory/Dockerfile .
