#!/bin/bash
source config.sh
urlparse $BUILD_ENGINE

display "export FacDB outputs"
mkdir -p output && 
    ( 
        cd output
        CSV_export facilities &
        CSV_export facilities_wo_dedupe &
        CSV_export qc_operator &
        CSV_export qc_oversight &
        CSV_export qc_classification &
        CSV_export qc_captype &
        CSV_export qc_proptype &
        CSV_export qc_mapped &
        CSV_export qc_diff &
        CSV_export geo_rejects &
        CSV_export geo_result 

        wait
    )
display "csv export complete"

display "Export Facilities shapefile"
mkdir -p output/facilities && 
    (
        cd output/facilities
        pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f facilities $BUILD_DB \
        "SELECT * FROM facilities WHERE geom IS NOT NULL;"
        echo "$DATE" > version.txt
        zip facilities.zip *
        ls | grep -v facilities.zip | xargs rm
    )

Upload latest
Upload $DATE