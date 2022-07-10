IMG_NAME=docker.tutorials:git-https-private-pat
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd
read -p "Please enter your PAT to clone github repository: " PAT
echo "\n"

SOURCE=github.com/OttoHung/private-test.git
REPO_NAME=private-test

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
#
# Username and password must be provided by `--secret` to access 
# private repository.
#
# For security concern, **DO NOT** hard-coding username and password
# in the command prompt.
#
# Secret is used to install npm packages in docker deamon.
pat=${PAT} \
docker buildx build \
   --build-arg REPO=${SOURCE} \
   --build-arg REPO_NAME=${REPO_NAME} \
   --secret id=npm,src=$HOME/.npmrc \
   --secret id=pat \
   -t ${IMG_NAME} \
   -f ./dockerfiles/git/https/private/Dockerfile .
   