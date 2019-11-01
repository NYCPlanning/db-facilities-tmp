#!/bin/bash
source config.sh
# Initialize containers
[ ! "$(docker ps -a | grep $ETL_CONTAINER_NAME)" ]\
     && docker run -it --name=$ETL_CONTAINER_NAME\
            --network=host\
            -v `pwd`:/home/db-facilities\
            -w /home/db-facilities\
            -e BUILD_ENGINE=postgresql://postgres@localhost:$CONTAINER_PORT/postgres\
            --env-file .env\
            -d sptkl/docker-geosupport:19c bash

docker exec $ETL_CONTAINER_NAME pip3 install -e .

# Create a postgres database container db
[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
          -v `pwd`:/home/db-facilities\
               -w /home/db-facilities\
               --shm-size=1g\
               -e BUILD_ENGINE=postgresql://postgres@localhost:$CONTAINER_PORT/postgres\
               --env-file .env\
               -p $CONTAINER_PORT:5432\
               mdillon/postgis

## Wait for database to get ready, this might take 5 seconds of trys
docker start $DB_CONTAINER_NAME
until docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres; do
    echo "Waiting for postgres container..."
    sleep 0.5
done

docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"