IMG_NAME=docker.tutorials:root

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
docker build -t ${IMG_NAME} -f Dockerfile_build_context .
