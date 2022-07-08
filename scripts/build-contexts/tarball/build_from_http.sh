IMG_NAME=docker.tutorials:tarball
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# compress project
TARBALL=https://github.com/OttoHung/docker.tutorials/archive/refs/tags/tarball.tar.gz
# It's the best practice to get the file name from URL by $(basename ${TARBALL})
# hard-coding file name when the file name in URL is a mapping
TARBALL_NAME=docker.tutorials-tarball.tar.gz

# In this tutorial, the extracted directory name is not as same as the name of tarball.
# To copy the files from the tarball, the extracted folder name is required.
# If the extracted folder name is as same as the name of tarball, this variable
# is not required.
# --build-arg must be declared and referenced in the `Dockerfile`
SOURCE_NAME=docker.tutorials-tarball

# Alternatively, the following command line prompt is 
# used to buid docker image in `dockerfiles` folder
docker buildx build \
   --build-context tarball=${TARBALL} \
   --build-arg tarball_name=${TARBALL_NAME} \
   --build-arg SOURCE_NAME=${SOURCE_NAME} \
   --secret id=npm,src=$HOME/.npmrc \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/tarball/Dockerfile .
