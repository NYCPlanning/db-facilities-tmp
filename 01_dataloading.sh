#!/bin/bash
source config.sh

# Initialize containers
[ ! "$(docker ps -a | grep $ETL_CONTAINER_NAME)" ]\
     && docker run -it --name=$ETL_CONTAINER_NAME\
            --network=host\
            -v `pwd`:/home/db-facilities\
            -w /home/db-facilities\
            --env-file .env\
            -d sptkl/docker-geosupport:latest bash

docker exec $ETL_CONTAINER_NAME pip3 install -e .

# Fast load spatial tableds
docker run --rm\
            --network=host\
             -v `pwd`:/home/db-facilities\
            -w /home/db-facilities/facdb/fast_load\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py

# run all the recipes
for f in facdb/recipes/*
do 
    name=$(basename $f .py) 
    docker exec $ETL_CONTAINER_NAME python $f
    psql $BUILD_ENGINE -f sql/$name.sql
done