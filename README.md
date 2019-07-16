# db-facilities-tmp [![CircleCI](https://circleci.com/gh/NYCPlanning/db-facilities-tmp.svg?style=svg)](https://circleci.com/gh/NYCPlanning/db-facilities-tmp)

## Development environment
#### __Dataloading environment__
        
        docker run -itd --name=facdb\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip3 install -e .; bash"
                
1. navigate to the db-facilities-tmp directory

        cd db-facilities-tmp
        
#### __Postgis__

        docker run -itd --name=db\
                -p 5433:5432\
                mdillon/postgis 

#### __Geocoding__

1. run the following docker command: 

        docker run -itd -p 5000:5000 sptkl/api-geosupport

4. Test out the api by navigating to the following addresses: 

        http://0.0.0.0:5000/1b?house_number=120&street_name=broadway&borough=MN
        
        http://0.0.0.0:5000/1b?house_number=120&street_name=broadway&zipcode=10271

## Building Instructions: 
1. enter docker environment

        docker exec -it facdb bash
        
2. access postgres 

        docker exec -it db bash
        psql -U postgres

3. run any pipelines in etl from root directory: (note this would run both the .py and .sql file)

        cook recipe run <name of recipe>

4. Check local recipes: 

        cook recipe ls local

5. Check recipes in postgres: 

        cook recipe ls pg

6. check local/postgres differences:

        cook recipe ls diff

## Data loading:
All FacDB datasets are loaded from various sources and staged in a centralized database. Most of them are downloaded directly from NYC open data while others are received from various city agencies via email or maintained by us manually. You can find data loading script for each dataset in [NYCPlanning/db-data-recipes](https://github.com/NYCPlanning/db-data-recipes/tree/master/recipes) GitHub Repository.
1. we receive the following datasets from their owners, various city agencies __via email__:

    - `acs_daycareheadstart`
    - `dot_bridgehouses`
    - `dot_ferryterminals`
    - `dot_mannedfacilities`
    - `dot_pedplazas`
    - `dot_publicparking`
    - `dsny_mtsgaragemaintenance`
    - `moeo_socialservicesiteloactions`
2. we update the data loading scripts for the following datasets manually caused their open data __URLs change__ over time:

    - `dpr_parksproperties`
    - `usdot_ports`
    - `usnps_parks`
3. we __webscrape__ the following datasets from their open data source:

    - `foodbankny_foodbanks`
    - `nysdoccs_corrections`
    - `nycdoc_corrections`
    - `hra_centers`
    - `uscourts_courts`
4. we maintain the following datasets in [NYCPlanning/db-data-recipes](https://github.com/NYCPlanning/db-data-recipes/tree/master/recipes) __GitHub Repository__:

    - `dcp_pops`
    - `dcp_sfpsd`
    - `fbop_corrections`
    - `nycourts_courts`
    - `nysed_activeinstitutions`
