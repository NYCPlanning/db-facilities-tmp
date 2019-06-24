#!/bin/bash
start=$(date +'%T')

echo "export FacDB outputs"

# Facilities data table
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM facilities) 
                                TO '/home/db-facilities/output/facilities.csv' 
                                DELIMITER ',' CSV HEADER;"
# Facilities shapefile
pgsql2shp -U $DBUSER -p $PORT -h HOST -f \
    /home/db-facilities/output/facilities $DBNAME \
    'SELECT * 
    FROM facilities
    WHERE geom IS NOT NULL;'

# QC reports
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_operator) 
                                TO '/home/db-facilities/output/qc_operator.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_oversight) 
                                TO '/home/db-facilities/output/qc_oversight.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_classification) 
                                TO '/home/db-facilities/output/qc_classification.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_captype) 
                                TO '/home/db-facilities/output/qc_captype.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_capvalues) 
                                TO '/home/db-facilities/output/qc_capvalues.csv' 
                                DELIMITER ',' CSV HEADER;"
                                
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_proptype) 
                                TO '/home/db-facilities/output/qc_proptype.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM qc_mapped) 
                                TO '/home/db-facilities/output/qc_mapped.csv' 
                                DELIMITER ',' CSV HEADER;"
echo "Build is done!"