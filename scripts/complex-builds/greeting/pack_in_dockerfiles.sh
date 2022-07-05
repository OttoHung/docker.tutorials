IMG_NAME=docker.tutorials:parent-dir
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

cd dockerfiles

# Alternatively, the following command line prompt is 
# used to buid docker image in `dockerfiles` folder
docker buildx build \
   --build-context repo=../ \
   --build-context greeting=../workspaces/greeting \
   -t ${IMG_NAME} \
   -f greeting .
