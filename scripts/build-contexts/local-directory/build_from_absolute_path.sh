IMG_NAME=docker.tutorials:absolute-path
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image from absolute file path.
# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon.
## Failed because tidle(~) cannot be recognised by docker build
## Please use `$HOME` instead
docker buildx build \
    --build-context repo=$HOME/Documents/repos/docker.tutorials \
    --build-context app=$HOME/Documents/repos/docker.tutorials/workspaces/greeting \
    --secret id=npm,src=$HOME/.npmrc \
    --no-cache \
    -t ${IMG_NAME} \
    -f ./dockerfiles/build-contexts/local-directory/Dockerfile .
