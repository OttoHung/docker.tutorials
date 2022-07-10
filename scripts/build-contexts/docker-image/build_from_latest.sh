IMG_NAME=docker.tutorials:docker-image-latest
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

SOURCE=ghcr.io/ottohung/docker.tutorials:git-https

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
# The name of build context must be lowercase.
docker buildx build \
   --build-context docker_tutorial=docker-image://${SOURCE} \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/docker-image/Dockerfile .
   