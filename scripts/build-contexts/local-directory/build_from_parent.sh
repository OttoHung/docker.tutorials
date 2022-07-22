IMG_NAME=docker.tutorials:parent-dir
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

## Please note that `resources` directory is not on github and 
## it is an example indicating how to access build context in
## parent folder. In this code snippet, it jumps into `dockerfiles`
## directory and execute `docker build` command prompt to simulate 
## how to access build context in the parent directory.
cd dockerfiles

# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon
docker buildx build \
   --build-context repo=../ \
   --build-context app=../workspaces/greeting \
   --secret id=npm,src=$HOME/.npmrc \
   --no-cache \
   -t ${IMG_NAME} \
   -f ../dockerfiles/build-contexts/local-directory/Dockerfile .
