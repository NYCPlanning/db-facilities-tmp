# db-facilities-tmp

## Development environment
#### __Dataloading environment__
        
        docker run -itd --name=facdb\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip install -e .; bash"
                
1. navigate to the db-facilities-tmp directory
        ```
        cd db-facilities-tmp
        ```
        
#### __Postgis__


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

#### __Geocoding__

1. first pull geosupport api repo 

        git clone git@github.com:NYCPlanning/api-geosupport.git

2.  navigate to the api-geosupport directory

        cd api-geosupport

3. run the following docker command:

        
        docker run -itd --name=geo\
                -v `pwd`:/src/app\
                -w /src/app\
                -p 5000:5000\
                sptkl/docker-geosupport:19a-api python app.py
        
4. Test out the api by navigating to the following addresses: 

        http://0.0.0.0:5000/1b?house_number=120&street_name=broadway&borough=MN
        
        http://0.0.0.0:5000/1b?house_number=120&street_name=broadway&zipcode=10271

## Building Instructions: 
1. enter docker environment

        docker exec -it facdb bash
        
2. access postgres 

        docker exec -it db bash
        psql -U postgres to access postgres

3. run any pipelines in etl from root directory: (note this would run both the .py and .sql file)

        cook recipe run <name of recipe>

4. Check local recipes: 

        cook recipe ls local

5. Check recipes in postgres: 

        cook recipe ls pg

6. check local/postgres differences:

        cook recipe ls diff