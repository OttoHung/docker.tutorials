IMG_NAME=docker.tutorials:greeting-from-project

# Build docker image from whole project
docker build -t ${IMG_NAME} -f Dockerfile_greeting .
