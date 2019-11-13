-- Output the records not having geoms
DROP TABLE IF EXISTS geo_rejects;
SELECT facname, addressnum, streetname,
address, datasource, uid, grc, grc2,reason_code
INTO geo_rejects
FROM facilities
WHERE geom IS NULL
ORDER BY datasource, facname ASC;

ALTER TABLE facilities
DROP column grc,
DROP column grc2
DROP column reason_code;