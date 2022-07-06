IMG_NAME=docker.tutorials:git-https
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# compress project
REPO=https://github.com/OttoHung/docker.tutorials.git#main

# Alternatively, the following command line prompt is 
# used to buid docker image in `dockerfiles` folder
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   -t ${IMG_NAME} \
   -f ./dockerfiles/greeting_git .
