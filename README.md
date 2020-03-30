# db-facilities ![CI](https://github.com/NYCPlanning/db-facilities-tmp/workflows/CI/badge.svg)
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
All FacDB datasets are loaded from [various sources](https://docs.google.com/spreadsheets/d/1xi0EvGpHpH-BqX-I5tgCgoE1OeeXZJAQLBLXpOmKWlk/edit?usp=sharing) and staged in a centralized database. Most of them are downloaded directly from NYC open data while others are received from various city agencies via email or maintained by us manually. You can find data loading script for each dataset in [NYCPlanning/db-data-recipes](https://github.com/NYCPlanning/db-data-recipes/tree/master/recipes) GitHub Repository.
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

## Download: 
+ [facilities.csv](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/facilities.csv)
+ [facilities.zip](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/facilities/facilities.zip)
+ [geo_rejects](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/geo_rejects.csv)
+ [qc_captype](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_captype.csv)
+ [qc_capvalues](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_capvalues.csv)
+ [qc_classification](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_classification.csv)
+ [qc_diff](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_diff.csv)
+ [qc_mapped_datasource](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_mapped_datasource.csv)
+ [qc_mapped_subgroup](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_mapped_subgroup.csv)
+ [qc_operator](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_operator.csv)
+ [qc_oversight](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_oversight.csv)
+ [qc_proptype](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_proptype.csv)