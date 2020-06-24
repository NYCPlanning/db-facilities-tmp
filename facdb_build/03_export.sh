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
SHP_export facilities

Upload latest
Upload $DATE