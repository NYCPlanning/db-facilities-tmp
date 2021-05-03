DROP TABLE IF EXISTS lookup_city_zip_borough;
CREATE TABLE lookup_city_zip_borough (
    zipcode INTEGER,
    city TEXT,
    boro TEXT
);
\COPY lookup_city_zip_borough FROM 'facdb/data/lookup_city_zip_borough.csv' DELIMITER ',' CSV HEADER;
