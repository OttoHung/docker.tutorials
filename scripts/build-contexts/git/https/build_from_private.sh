IMG_NAME=docker.tutorials:git-https-private
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd
read -p "Please enter your PAT to clone github repository: " PAT
echo "\n"

# The branch name must be provided for --build-context to clone repository
REPO=https://github.com/OttoHung/private-test.git#main

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
#
# Username and password must be provided by `--secret` to access 
# private repository.
#
# For security concern, **DO NOT** hard-coding username and password
# in the command prompt.
pat=${PAT} \
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --secret id=pat \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/git/https/private/Dockerfile .