IMG_NAME=docker.tutorials:entrypoint-yarn-sh
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
docker build -t ${IMG_NAME} -f Dockerfile_entrypoint_yarn_sh .
