# db-facilities-tmp [![CircleCI](https://circleci.com/gh/NYCPlanning/db-facilities-tmp.svg?style=svg)](https://circleci.com/gh/NYCPlanning/db-facilities-tmp)

## Development environment
#### `sh 00_initialize.sh` __Create dataloading environment__
1. navigate to the db-facilities-tmp directory

        cd db-facilities-tmp

        docker run -itd --name=facdb\
                --network=host\
                -v `pwd`:/home/db-facilities\
                -w /home/db-facilities\
                -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5433/postgres"\
                sptkl/docker-dataloading:latest /bin/bash -c "pip3 install -e .; bash"
        
2. create the database container
        
        docker run -itd --name=db\
                -p 5433:5432\
                mdillon/postgis

3.  create geocoding microservice

        docker run -itd -p 5000:5000 sptkl/api-geosupport

#### `sh 01_dataloading.sh` __Conduct dataloading__

1. this command will load all 50 input datasets into the database container

#### `sh 02_build.sh` __Build__

1. this command will transform all input datasets into the `facilities` table

#### `sh 03_geocode.sh` __Build__
1. this command will perform geocoding for records that do not have geometries using GeoSupport

#### `sh 04_build.sh` __Build__
1. this command will assign geometries for records that do not have geometries using spatial join and perform quality check for `facilities` table

#### `sh 05_export.sh` __Export__

1. this command will export the finished `facilities` table into shape files, csv along with QAQC tables

#### `sh 06_backup.sh` __Backup__

1. this command will create a `pg_dump` file and upload the `facilities` table to the digital ocean publishing database

### _Note:_

You can run the above 4 step scripts to generate the facilities database, however, you can also skip through all steps and do a database restore.

        curl -O https://github.com/NYCPlanning/db-facilities-tmp/raw/dev/output/facilities.gz
        gunzip < facilities.gz | psql -p {YOUR_PORT} -U {YOUR_USER} -d {YOUR_DATABASE} -h {YOUR_HOST}

## Building Instructions: 
1. enter docker environment

        docker exec -it facdb bash
        
2. access postgres 

        docker exec -it db psql -U postgres

3. run any pipelines in etl from root directory: (note this would run both the .py and .sql file)
        
        docker exec facdb cook recipe run <name of recipe>

4. Check local recipes:

        docker exec facdb cook recipe ls local

5. Check recipes in postgres:

        docker exec facdb cook recipe ls pg

6. check local/postgres differences:

        docker exec facdb cook recipe ls diff

## About Source Data:
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
