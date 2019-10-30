# create table and create stored procedure
docker exec fdb psql -h localhost -U postgres -f sql/create.sql
docker exec fdb psql -h localhost -U postgres -f sql/load_to_facilities.sql

# Load individual tables and assign facility classification
docker exec fdb psql -h localhost -U postgres -f sql/load_and_combine.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_classification.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_overlevel.sql

# geocoding ....
docker exec facdb bash -c "python3 facdb/geocode/geocode.py"

# backfill spatial boundries
docker exec fdb psql -h localhost -U postgres -f sql/assign_geo.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_bin_centroid.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_lot_centroid.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_geo_boundaries.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_boro.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_address.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_xy.sql
docker exec fdb psql -h localhost -U postgres -f sql/assign_lonlat.sql
docker exec fdb psql -h localhost -U postgres -f sql/formatting.sql
docker exec fdb psql -h localhost -U postgres -f sql/qc_views.sql