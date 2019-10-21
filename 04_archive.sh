docker exec fdb bash -c '
        pg_dump -t facilities --no-owner -U postgres -d postgres | psql $EDM_DATA
        DATE=$(date "+%Y/%m/%d");
        psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS facilities;";
        psql $EDM_DATA -c "ALTER TABLE facilities SET SCHEMA facilities;";
        psql $EDM_DATA -c "DROP TABLE IF EXISTS facilities.\"$DATE\";";
        psql $EDM_DATA -c "ALTER TABLE facilities.facilities RENAME TO \"$DATE\";";
    '