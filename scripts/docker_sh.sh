# This script is a helper to run docker container without extra typing
# This is not an `on purpose` redundant script for this repo.
read -p "Please enter the tag: " TAG

docker run -it --entrypoint sh docker.tutorials:${TAG}