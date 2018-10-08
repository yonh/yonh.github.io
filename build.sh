#!/bin/bash

docker exec -it blog-hugo rm -rf /opt/docs
docker exec -it blog-hugo hugo -d docs
docker-compose restart
