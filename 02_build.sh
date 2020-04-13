#!/bin/bash
source config.sh

# create table and create stored procedure
psql $BUILD_ENGINE -f sql/create.sql
psql $BUILD_ENGINE -f sql/load_to_facilities.sql

# Load individual tables and assign facility classification
psql $BUILD_ENGINE -f sql/load_and_combine.sql
psql $BUILD_ENGINE -f sql/assign_classification.sql
psql $BUILD_ENGINE -f sql/assign_overlevel.sql

# geocoding ....
docker exec $ETL_CONTAINER_NAME bash -c "python3 facdb/geocode/geocode.py"

# backfill spatial boundries
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