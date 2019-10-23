echo "export FacDB outputs\n"

docker exec fdb mkdir -p output

# Facilities data table
docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM facilities) 
                                TO '/home/db-facilities/output/facilities.csv' 
                                DELIMITER ',' CSV HEADER;"
# Facilities shapefile
docker exec fdb pgsql2shp -u postgres -h localhost -f \
    /home/db-facilities/output/facilities postgres \
    'SELECT *
    FROM facilities
    WHERE geom IS NOT NULL;'

# QC reports
docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_operator) 
                                TO '/home/db-facilities/output/qc_operator.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_oversight) 
                                TO '/home/db-facilities/output/qc_oversight.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_classification) 
                                TO '/home/db-facilities/output/qc_classification.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_captype) 
                                TO '/home/db-facilities/output/qc_captype.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_capvalues) 
                                TO '/home/db-facilities/output/qc_capvalues.csv' 
                                DELIMITER ',' CSV HEADER;"
                                
docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_proptype) 
                                TO '/home/db-facilities/output/qc_proptype.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (SELECT * FROM qc_mapped) 
                                TO '/home/db-facilities/output/qc_mapped.csv' 
                                DELIMITER ',' CSV HEADER;"

docker exec fdb psql -h localhost -U postgres -c "\copy (select * from geo_result where xcoord is not null and ycoord is not null) 
                                TO '/home/db-facilities/output/geo_result.csv' 
                                DELIMITER ',' CSV HEADER;"
echo "Build is done!"