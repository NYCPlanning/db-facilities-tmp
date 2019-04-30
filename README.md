# db-facilities-tmp

## Development environment
+ __Dataloading environment__
        ```
        docker run -itd --name=etl\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip install .; bash"
        ```
+ __Postgis__
        ```
        docker run -itd --name=db\
                --network=host\
                -p 5433:5432\
                mdillon/postgis 
        ```
+ __Geocoding__
        ```
        docker run -itd --name=geo\
                --network=host\
                -p 5000:5000
                sptkl/docker-geosupport:19a=api
        ```