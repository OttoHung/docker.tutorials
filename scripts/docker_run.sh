# This script is a helper to run docker container without extra typing
# This is not an `on purpose` redundant script for this repo.
read -p "Please enter the tag: " TAG

docker run -p 5478:5478 docker.tutorials:${TAG}
