IMG_NAME=docker.tutorials:greeting-from-project

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
docker build -t ${IMG_NAME} -f Dockerfile_greeting .
