IMG_NAME=docker.tutorials:parent-dir
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

cd dockerfiles

# Secret is used to install npm packages in docker deamon
docker buildx build \
   --build-context repo=../ \
   --build-context app=../workspaces/greeting \
   --secret id=npm,src=$HOME/.npmrc \
   -t ${IMG_NAME} \
   -f ../dockerfiles/build-contexts/local-directory/Dockerfile .
