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
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --ssh default=$SSH_AUTH_SOCK \
   -t ${IMG_NAME} \
   -f ./dockerfiles/build-contexts/git/ssh/Dockerfile .
