#!/bin/bash
source config.sh
DATE=$(date "+%Y-%m-%d")

echo "export FacDB outputs\n"
apt update
apt install -y zip curl
mkdir -p output
# Facilities data table
psql $BUILD_ENGINE -c "\copy (SELECT * FROM facilities) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/facilities.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM facilities_wo_dedupe) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/facilities_wo_dedupe.csv
# QC reports
psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_operator) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_operator.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_oversight) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_oversight.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_classification) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_classification.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_captype) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_captype.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_capvalues) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_capvalues.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_proptype) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_proptype.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_mapped_datasource) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_mapped_datasource.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_mapped_subgroup) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_mapped_subgroup.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM qc_diff) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_diff.csv

psql $BUILD_ENGINE -c "\copy (SELECT * FROM geo_rejects) 
TO STDOUT DELIMITER ',' CSV HEADER;" > output/geo_rejects.csv

psql $BUILD_ENGINE -c "\copy (select * from geo_result where xcoord is not null and ycoord is not null)
TO STDOUT DELIMITER ',' CSV HEADER;" > output/geo_result.csv

# Facilities shapefile
source ./url_parse.sh $BUILD_ENGINE
DATE=$(date "+%Y-%m-%d")

mkdir -p output/facilities && 
    (cd output/facilities
    pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f facilities $BUILD_DB \
    "SELECT * FROM facilities WHERE geom IS NOT NULL;"
    echo "$DATE" > version.txt
    zip facilities.zip *
    ls | grep -v facilities.zip | xargs rm
    )

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
./mc rm -r --force spaces/edm-publishing/db-facilities/latest
./mc rm -r --force spaces/edm-publishing/db-facilities/$DATE
./mc cp -r output spaces/edm-publishing/db-facilities/latest
./mc cp -r output spaces/edm-publishing/db-facilities/$DATE