IMG_NAME=docker.tutorials:docker-image-version
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

SOURCE=ghcr.io/ottohung/docker.tutorials:git-https@sha256:b9f33235036f68d3d510a8800e27e3b6514142119cbd5f4862f0506d8cc8552d

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
docker buildx build \
   --build-context docker_tutorial=docker-image://${SOURCE} \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/docker-image/Dockerfile .
   