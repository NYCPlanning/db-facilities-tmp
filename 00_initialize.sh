# Initialize containers
docker run -itd --name=facdb\
            --network=host\
            -v `pwd`:/home/db-facilities\
            -w /home/db-facilities\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
            sptkl/docker-dataloading:latest /bin/bash -c "pip3 install -e .; bash"

docker run -itd --name=db\
            -p 5433:5432\
            mdillon/postgis

docker exec facdb sh runners/00_initialize.sh