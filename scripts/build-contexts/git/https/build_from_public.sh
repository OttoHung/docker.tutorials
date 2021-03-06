IMG_NAME=docker.tutorials:git-https
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# compress project
REPO=https://github.com/OttoHung/docker.tutorials.git#main

# Tilde(~) doesn't work in `Dockerfile`, please use $HOME instead
# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon.
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --no-cache \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/git/https/public/Dockerfile .
