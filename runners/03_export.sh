#!/bin/bash
start=$(date +'%T')

proto="$(echo $DATAFLOWS_DB_ENGINE | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url=$(echo $DATAFLOWS_DB_ENGINE | sed -e s,$proto,,g)

DBUSER="$(echo $url | grep @ | cut -d@ -f1)"
host_tmp=$(echo $url | sed -e s,$DBUSER@,,g | cut -d/ -f1)
PORT="$(echo $host_tmp | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
HOST=$(echo $host_tmp | grep : | cut -d: -f1)
DBNAME="$(echo $url | grep / | cut -d/ -f2-)"

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