IMG_NAME=docker.tutorials:git-ssh-clone
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd

SOURCE=git@github.com:OttoHung/private-test.git
SOURCE_FOLDER_NAME=private-test
HOSTING_NAME=github.com

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
# Secret is used to install npm packages in docker deamon.
docker buildx build \
   --build-arg REPO=${SOURCE} \
   --build-arg REPO_NAME=${SOURCE_FOLDER_NAME} \
   --build-arg HOSTING=${HOSTING_NAME} \
   --secret id=npm,src=$HOME/.npmrc \
   --ssh default=$SSH_AUTH_SOCK \
   --no-cache \
   -t ${IMG_NAME} \
   -f ./dockerfiles/git/ssh/Dockerfile .
   