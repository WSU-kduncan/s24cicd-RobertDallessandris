#! /bin/bash

# Kill and delete old container process
docker stop webserv
docker system prune --force
# pull fresh image
docker pull rdalless/ceg3120:latest
# run new container
docker run -d -p 80:80 --name webserv --restart always rdalless/ceg3120:latest

