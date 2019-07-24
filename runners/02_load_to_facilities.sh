psql $DATAFLOWS_DB_ENGINE -f sql/load_and_combine.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_classification.sql
psql $DATAFLOWS_DB_ENGINE -f sql/assign_overlevel.sql