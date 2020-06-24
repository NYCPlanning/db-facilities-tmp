#!/bin/bash
source config.sh

display "create table and create stored procedure"
psql $BUILD_ENGINE -f sql/create.sql
psql $BUILD_ENGINE -f sql/load_to_facilities.sql

display "Load individual tables and assign facility classification"
psql $BUILD_ENGINE -f sql/load_and_combine.sql
psql $BUILD_ENGINE -f sql/assign_classification.sql
psql $BUILD_ENGINE -f sql/assign_overlevel.sql

display "geocoding ...."
docker run --rm\
    -v $(pwd):/src\
    -w /src\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/docker-geosupport:latest bash -c "
        python3 facdb/geocode/geocode.py
    "

display "backfill spatial boundries"
psql $BUILD_ENGINE -f sql/assign_geo.sql
psql $BUILD_ENGINE -f sql/assign_bin_centroid.sql
psql $BUILD_ENGINE -f sql/assign_lot_centroid.sql
psql $BUILD_ENGINE -f sql/assign_geo_boundaries.sql
psql $BUILD_ENGINE -f sql/assign_boro.sql
psql $BUILD_ENGINE -f sql/assign_city.sql
psql $BUILD_ENGINE -f sql/assign_zipcode.sql
psql $BUILD_ENGINE -f sql/assign_address.sql
psql $BUILD_ENGINE -f sql/assign_xy.sql
psql $BUILD_ENGINE -f sql/assign_lonlat.sql
psql $BUILD_ENGINE -f sql/formatting.sql
psql $BUILD_ENGINE -f sql/deduplicate.sql
psql $BUILD_ENGINE -f sql/geo_rejects.sql
psql $BUILD_ENGINE -f sql/qc_views.sql