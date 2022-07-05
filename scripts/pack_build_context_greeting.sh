IMG_NAME=docker.tutorials:greeting

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
cd dockerfiles
docker build -t ${IMG_NAME} -f ../Dockerfile_build_context ../workspaces/greeting
