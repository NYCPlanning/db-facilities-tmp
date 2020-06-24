#!/bin/bash
source config.sh

pg_dump $BUILD_ENGINE | psql $EDM_DATA
DATE=$(date "+%Y/%m/%d");
psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS facilities;";
psql $EDM_DATA -c "ALTER TABLE facilities SET SCHEMA facilities;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS facilities.\"$DATE\";";
psql $EDM_DATA -c "ALTER TABLE facilities.facilities RENAME TO \"$DATE\";";
psql $EDM_DATA -c "DROP TABLE IF EXISTS facilities.latest;";
psql $EDM_DATA -c "SELECT * INTO facilities.latest FROM facilities.\"$DATE\";";