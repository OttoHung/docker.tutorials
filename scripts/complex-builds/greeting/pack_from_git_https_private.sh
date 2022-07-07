IMG_NAME=docker.tutorials:git-https-private
export DOCKER_BUILDKIT=1

echo "Start to build docker image from: " && pwd
echo -p "Please enter your username to clone github repository" USER_NAME
echo -p "Please enter your password to clone github repository" PASSWORD

# The branch name must be provided for --build-context to clone repository
REPO=https://github.com/OttoHung/private-test.git#main

# Tilde(~) doesn't work for `buildx`, please use `$HOME` instead.
#
# Username and password must be provided by `--secret` to access 
# private repository.
#
# For security concern, **DO NOT** hard-coding username and password
# in the command prompt.
docker buildx build \
   --build-context repo=${REPO} \
   --secret id=npm,src=$HOME/.npmrc \
   --secret id=credential,username=${USER_NAME} \
   --secret id=credential,pwd=${PASSWORD} \
   -t ${IMG_NAME} \
   -f ./dockerfiles/greeting_git_https_private .
