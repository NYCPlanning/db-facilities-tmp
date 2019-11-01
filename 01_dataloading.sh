#!/bin/bash
source config.sh

# Fast load spatial tableds
docker run --rm\
            --network=host\
             -v `pwd`:/home/db-facilities\
            -w /home/db-facilities/facdb/fast_load\
            -e BUILD_ENGINE=postgresql://postgres@localhost:$CONTAINER_PORT/postgres\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py

# run all the recipes
for f in facdb/recipes/*
do 
    name=$(basename $f .py) 
    docker exec $ETL_CONTAINER_NAME python $f
    docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/$name.sql
done