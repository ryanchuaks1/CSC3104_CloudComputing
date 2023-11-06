docker-compose down
DOCKER_BUILDKIT=1 docker-compose up -d --build
docker rmi $(docker images -f "dangling=true" -q) 2> /dev/null