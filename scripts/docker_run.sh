read -p "Please enter the tag: " TAG

docker run -p 5478:5478 docker.tutorials:${TAG}
