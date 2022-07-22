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
#
# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon.
pat=${PAT} \
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --secret id=pat \
   --no-cache \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/git/https/private/Dockerfile .


## Caution:
## This approach doesn't work due to `Buildx` clones the remote repository
## before executing `RUN` instruction and there is no interface to assign
## secrets to the clone process.
##
## Solution:
## The most secured way to clone a private repository is use the PAT from
## --screte and execute `git clone` with the `RUN` instruction