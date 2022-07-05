IMG_NAME=docker.tutorials:workspaces

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
cd workspaces
docker build -t ${IMG_NAME} -f ../Dockerfile_build_context .
