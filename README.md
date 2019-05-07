# db-facilities-tmp

## Development environment
#### __Dataloading environment__
        
        docker run -itd --name=facdb\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip install -e .; bash"
                
1. The lib folder need to be within the etl folder to enable all py functions work
2. Install the usdress package
        ```
        pip install usdress
        ```
3. Install the latest dataflows package to enable add_computed_field() function
        ```
        pip install dataflows -U
        ```
4. Install the shapely package to enable geocoding functions
        ```
        pip install shapely
        ```
        
#### __Postgis__

        docker run -itd --name=db\
                --network=host\
                -p 5433:5432\
                mdillon/postgis 

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

2. run any pipelines in etl from root directory: 

        python  etl/example_data.py

3. if you don't want to run it in an interative shell: 

        docker exec facdb etl/example_data.py
