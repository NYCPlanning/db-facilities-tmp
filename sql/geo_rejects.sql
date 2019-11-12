-- Output the records not having geoms
DROP TABLE IF EXISTS geo_rejects;
SELECT * INTO geo_rejects
FROM facilities
WHERE geom IS NULL;

ALTER TABLE facilities
DROP column grc,
DROP column grc2;