IMG_NAME=docker.tutorials:build-path-tarball
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# compressed project
TARBALL=https://github.com/OttoHung/docker.tutorials/archive/refs/tags/tarball-v2.tar.gz

# Secret is used to install npm packages in docker deamon.
## This cannot find the Dockerfile in the tarball as the official states.
## TODO: To look for a correct way to use this feature.
docker build \
   --secret id=npm,src=$HOME/.npmrc \
   --no-cache \
   -t ${IMG_NAME} \
   -f Dockerfile \
   ${TARBALL}