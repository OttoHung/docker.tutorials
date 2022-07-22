IMG_NAME=ghcr.io/ottohung/private-test:demo
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd


docker buildx build \
        --build-context image=docker-image://${IMG_NAME} \
        --no-cache \
        -t docker.tutorials:private-image \
        -f dockerfiles/build-contexts/docker-image/Dockerfile .