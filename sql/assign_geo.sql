UPDATE geo_result a
SET xcoord = nullif(xcoord, ''),
    ycoord = nullif(ycoord, '');

UPDATE facilities a
SET xcoord = b.xcoord,
    ycoord = b.ycoord,
    geom = ST_Transform(ST_SetSRID(ST_Point(
                b.xcoord::DOUBLE PRECISION,
                b.ycoord::DOUBLE PRECISION), 2263), 4326)
FROM geo_result b
WHERE a.uid = b.uid
AND b.xcoord IS NOT NULL AND b.ycoord IS NOT NULL;