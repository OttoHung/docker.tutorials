IMG_NAME=docker.tutorials:git-ssh
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

# The branch name must be provided for --build-context to clone repository
REPO=git@github.com:OttoHung/docker.tutorial.git#main

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
#
# `--ssh` must be provided to access private repository.
#
# If the private key is encrypted by passphrass, please do use
# `$SSH_AUTH_SOCK` to pass the SSH agent socket to `buildx`
#
# If the private key is not encrypted by passphrass, 
# `--ssh ${SSH_KEY_ID_FOR_DOCKERFILE}=${PATH_TO_PRIVATE_KEY}}` is 
# the alternative way to load a specific private key without including
# everything. For security concern, it is recommended to encrypt private 
# key by passphrass.
#
# The name of build context must be lowercase.
# Secret is used to install npm packages in docker deamon.
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --ssh default=$SSH_AUTH_SOCK \
   --no-cache \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/git/ssh/Dockerfile .

## Caution:
## This approach doesn't work due to `Buildx` clones the remote repository
## before executing `RUN` instruction and there is no interface to assign
## secrets to the clone process.
##
## Solution:
## The most secured way to clone a git repository via SSH is using `--ssh` 
## to pass ssh agent or configuration to docker deamon then execute 
## `git clone` with the `RUN` instruction.