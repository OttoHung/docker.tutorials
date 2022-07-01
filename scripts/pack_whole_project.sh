IMG_NAME=docker.tutorials:whole_project

# Build docker image from whole project
docker build -t ${IMG_NAME} .

# SSH to docker image to list the strucutre in the docker file
docker run -it ${IMG_NAME} sh
