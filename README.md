# db-facilities-tmp

## Development environment
+ __Dataloading environment__

        ```
        docker run -itd --name=factdb\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip install -e .; bash"
        ```
        
1. The lib folder need to be within the etl folder to enable all py functions work
2. Install the usdress package
        ```
        pip install usdress
        ```
3. Install the latest dataflows package to enable add_computed_field() function
        ```
        pip install dataflows -U
4. Install the shapely package to enable geocoding functions
        ```
        pip install shapely
        ```
        ```
+ __Postgis__

        ```
        docker run -itd --name=db\
                --network=host\
                -p 5433:5432\
                mdillon/postgis 
        ```
        
        or
        
        
        ```
        docker run -itd --name=db\
                -p 5433:5432\
                mdillon/postgis 
        ```
+ __Geocoding__

        ```
        docker run -itd --name=geo\
                --network=host\
                -p 5000:5000
                sptkl/docker-geosupport:19a-api
        ```
