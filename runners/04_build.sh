psql $DATAFLOWS_DB_ENGINE -f sql/assign_geo.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_bin_centroid.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_xy.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_geo_boundaries.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_boro.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_address.sql
psql $DATAFLOWS_DB_ENGINE -f sql/formatting.sql
psql $DATAFLOWS_DB_ENGINE -f sql/qc_views.sql