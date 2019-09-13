# Initialize containers
[ ! "$(docker ps -a | grep facdb)" ]\
     && docker run -itd --name=facdb\
            --network=host\
            -v `pwd`:/home/db-facilities\
            -w /home/db-facilities\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
            sptkl/docker-dataloading:latest /bin/bash -c "pip3 install -e .; bash"


# Create a postgres database container db
DB_CONTAINER_NAME=fdb

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            --shm-size=1g\
            --cpus=2\
            -p 5433:5432\
            mdillon/postgis

## Wait for database to get ready, this might take 5 seconds of trys
docker start $DB_CONTAINER_NAME
until docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres; do
    echo "Waiting for postgres container..."
    sleep 0.5
done

docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec fdb psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"

[ ! "$(docker ps -a | grep geo)" ]\
     && docker run -d --name=geo\
            -p 5000:5000\
            -e PORT=5000\
            sptkl/api-geosupport:latest

docker exec facdb sh runners/00_initialize.sh