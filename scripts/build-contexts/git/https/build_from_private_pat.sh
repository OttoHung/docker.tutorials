IMG_NAME=docker.tutorials:bc-git-https-private-pat
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd
read -p "Please enter your PAT to clone github repository: " PAT
echo "\n"

# The branch name must be provided for --build-context to clone repository
REPO=https://${PAT}@github.com/OttoHung/private-test.git#main

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
#
# Username and password must be provided by `--secret` to access 
# private repository.
#
# For security concern, **DO NOT** hard-coding username and password
# in the command prompt.
#
# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon.
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --no-cache \
   -t ${IMG_NAME} \
   -f ./dockerfiles/execution-location/Dockerfile .
