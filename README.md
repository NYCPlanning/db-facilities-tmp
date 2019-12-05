# db-facilities-tmp [![CircleCI](https://circleci.com/gh/NYCPlanning/db-facilities-tmp.svg?style=svg)](https://circleci.com/gh/NYCPlanning/db-facilities-tmp)

## Instructions:
1. `./01_dataloading.sh` change CONTAINER_PORT number to something else if port is used
2. `./02_build.sh`
3. `./03_export.sh`
4. `./04_archive.sh`
5. `./05_cleanup.sh` note: the clean up step will remove both `facdb-$USER` and `fdb-USER` container

In the case you only want to run one datasource pipeline:
- Set the `NAME` in `etl.sh` file as the datasource you select
- Run `./etl.sh`

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
