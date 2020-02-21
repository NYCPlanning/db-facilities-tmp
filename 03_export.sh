#!/bin/bash
source config.sh

echo "export FacDB outputs\n"

docker exec $DB_CONTAINER_NAME mkdir -p output

# Facilities data table
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM facilities)
                                TO '/home/db-facilities/output/facilities.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM facilities_wo_dedupe)
                                TO '/home/db-facilities/output/facilities_wo_dedupe.csv'
                                DELIMITER ',' CSV HEADER;"
# Facilities shapefile
docker exec $DB_CONTAINER_NAME pgsql2shp -u postgres -h localhost -f \
    /home/db-facilities/output/facilities postgres \
    'SELECT *
    FROM facilities
    WHERE geom IS NOT NULL;'

# QC reports
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_operator) 
                                TO '/home/db-facilities/output/qc_operator.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_oversight) 
                                TO '/home/db-facilities/output/qc_oversight.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_classification) 
                                TO '/home/db-facilities/output/qc_classification.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_captype) 
                                TO '/home/db-facilities/output/qc_captype.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_capvalues) 
                                TO '/home/db-facilities/output/qc_capvalues.csv' 
                                DELIMITER ',' CSV HEADER;"
                                
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_proptype) 
                                TO '/home/db-facilities/output/qc_proptype.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_mapped_datasource)
                                TO '/home/db-facilities/output/qc_mapped_datasource.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (select * from qc_mapped_subgroup)
                                TO '/home/db-facilities/output/qc_mapped_subgroup.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (select * from qc_diff)
                                TO '/home/db-facilities/output/qc_diff.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (select * from geo_rejects)
                                TO '/home/db-facilities/output/geo_rejects.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (select * from geo_result where xcoord is not null and ycoord is not null)
                                TO '/home/db-facilities/output/geo_result.csv'
                                DELIMITER ',' CSV HEADER;"
echo "Build is done!"