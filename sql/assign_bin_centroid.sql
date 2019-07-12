/** Reassign geometry attributes based on bin centroids for records
having bin and bbl combination existing in doitt_buildingfootprints **/
UPDATE facilities f
SET geom = b.wkb_geometry,
	latitude = ST_Y(b.wkb_geometry)::text,
	longitude = ST_X(b.wkb_geometry)::text,
	xcoord = ST_X(ST_TRANSFORM(wkb_geometry, 2263)),
	ycoord = ST_Y(ST_TRANSFORM(wkb_geometry, 2263))
FROM doitt_buildingfootprints b
WHERE f.bin = b.bin
AND f.bbl = b.base_bbl;