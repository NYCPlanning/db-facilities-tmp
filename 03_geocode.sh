docker run --rm\
            --network=host\
            -v `pwd`/etl/geocode.py:/home/etl/geocode.py\
            -v `pwd`/etl/requirements.txt:/home/etl/requirements.txt\
            -w /home/etl\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
            sptkl/docker-geosupport:19b2 bash -c "pip install -r requirements.txt; python3 geocode.py"