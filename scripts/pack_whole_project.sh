IMG_NAME=docker.tutorials:whole_project

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
docker build -t ${IMG_NAME} .
