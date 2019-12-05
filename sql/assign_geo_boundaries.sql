-- Spatially assign geo attributes where record has geometry but the geom bound info is NULL
-- community district
UPDATE facilities a
SET commboard = b.borocd::text
FROM dcp_cdboundaries b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.commboard IS NULL;

-- nta
UPDATE facilities a
SET nta = b.ntacode::text
FROM dcp_ntaboundaries b
WHERE ST_Within(a.geom, ST_SetSRID(b.wkb_geometry, 4326))
AND a.geom IS NOT NULL
AND a.nta IS NULL;

-- census tracts
UPDATE facilities a
SET censtract = NULLIF(censtract, '000000');

UPDATE facilities a
SET censtract = b.ct2010::text
FROM dcp_censustracts b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.censtract IS NULL;

-- school districts
UPDATE facilities a
SET schooldist = b.schooldist::text
FROM dcp_school_districts b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.schooldist IS NULL;

-- zipcode
UPDATE facilities a
SET zipcode = b.zipcode::text
FROM doitt_zipcodeboundaries b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.zipcode IS NULL;

-- borough code
UPDATE facilities a
SET borocode = b.borocode::text
FROM dcp_boroboundaries_wi b
WHERE ST_Within(a.geom, ST_SetSRID(b.wkb_geometry, 4326))
AND a.geom IS NOT NULL
AND a.borocode IS NULL OR a.borocode = '0';

-- council districts
UPDATE facilities a
SET council = b.coundist::text
FROM dcp_councildistricts b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.council IS NULL;

--polict precinct 
UPDATE facilities a
SET policeprct = b.precinct::text
FROM dcp_policeprecincts b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.policeprct IS NULL;

--BBL
UPDATE facilities a
SET bbl = b.bbl::text
FROM dcp_mappluto b
WHERE ST_Within(a.geom,b.wkb_geometry)
AND a.geom IS NOT NULL
AND a.bbl IS NULL;

-- remove points out of NYC
DELETE FROM facilities WHERE geom IS NOT NULL AND
facilities.uid NOT IN (
    SELECT a.uid FROM
      facilities a, (
           SELECT ST_Union(wkb_geometry) As geom FROM dcp_boroboundaries_wi
      ) b
      WHERE ST_Contains(ST_SetSRID(b.geom, 4326), a.geom)
 );