#!/bin/bash
source config.sh

pg_dump $BUILD_ENGINE -t facilities -O | psql $EDM_DATA
DATE=$(date "+%Y/%m/%d");
psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS facilities;";
psql $EDM_DATA -c "ALTER TABLE facilities SET SCHEMA facilities;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS facilities.\"$DATE\";";
psql $EDM_DATA -c "ALTER TABLE facilities.facilities RENAME TO \"$DATE\";";
psql $EDM_DATA -c "DROP VIEW IF EXISTS facilities.latest;";
psql $EDM_DATA -c "CREATE VIEW facilities.latest AS (SELECT '$DATE' as v, * FROM facilities.\"$DATE\");";