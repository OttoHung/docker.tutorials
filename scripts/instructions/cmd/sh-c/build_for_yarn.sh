IMG_NAME=docker.tutorials:cmd-yarn-sh
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# Build docker image from whole project
# Secret is used to install npm packages in docker deamon.
docker build \
        --secret id=npm,src=$HOME/.npmrc \
        -t ${IMG_NAME} \
        -f Dockerfile_cmd_yarn_sh .
