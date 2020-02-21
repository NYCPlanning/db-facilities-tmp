#!/bin/bash
source config.sh

# create table and create stored procedure
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/create.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/load_to_facilities.sql

# Load individual tables and assign facility classification
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/load_and_combine.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_classification.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_overlevel.sql

# geocoding ....
docker exec $ETL_CONTAINER_NAME bash -c "python3 facdb/geocode/geocode.py"

# backfill spatial boundries
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_geo.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_bin_centroid.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_lot_centroid.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_geo_boundaries.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_boro.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_city.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_zipcode.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_address.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_xy.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/assign_lonlat.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/formatting.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/deduplicate.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/geo_rejects.sql
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/qc_views.sql