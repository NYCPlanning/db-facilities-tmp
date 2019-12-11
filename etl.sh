#!/bin/bash
source config.sh
NAME=nycdoc_corrections

docker exec $ETL_CONTAINER_NAME python facdb/recipes/$NAME.py
docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -f sql/$NAME.sql