psql $DATAFLOWS_DB_ENGINE -f sql/load_and_combine.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_classification.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_overlevel.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_overlevel.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_bin_centroid.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_xy.sql
psql $DATAFLOWS_DB_ENGINE -f sql/spatialjoins.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_boro.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_address.sql
psql $DATAFLOWS_DB_ENGINE -f sql/qc_views.sql