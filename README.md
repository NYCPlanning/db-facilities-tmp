# db-facilities 
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/NYCPlanning/db-facilities?label=version)
![Build](https://github.com/NYCPlanning/db-facilities/workflows/Build/badge.svg)

## Instructions:
1. `./01_dataloading.sh`
2. `./02_build.sh`
3. `./03_export.sh`
4. `./04_archive.sh`

## Download: 
+ [facilities.csv](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/facilities.csv)
+ [facilities.zip](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/facilities/facilities.zip)
+ [geo_rejects](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/geo_rejects.csv)
+ [qc_captype](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_captype.csv)
+ [qc_classification](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_classification.csv)
+ [qc_diff](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_diff.csv)
+ [qc_mapped](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_mapped.csv)
+ [qc_operator](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_operator.csv)
+ [qc_oversight](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_oversight.csv)
+ [qc_proptype](https://edm-publishing.nyc3.digitaloceanspaces.com/db-facilities/latest/output/qc_proptype.csv)

## GitHub Actions Build Log

### 2020/12/18 -- Molly
+ Build with reprojected COLP data and updated filters

### 2020/12/03 -- Molly
+ Building draft after merging clean-up step
+ Switch clean-up to delete facdb_build

### 2020/11/30 -- Molly
+ See issue #311
+ Building draft without full set of updated inputs
