IMG_NAME=docker.tutorials:greeting-from-project

# Build docker image from whole project
docker build -t ${IMG_NAME} -f Dockerfile_greeting .

# SSH to docker image to list the strucutre in the docker file
docker run -it --entrypoint sh ${IMG_NAME}
