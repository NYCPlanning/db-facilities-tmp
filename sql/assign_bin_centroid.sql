/** Reassign geometry attributes based on bin centroids for records
having bin and bbl combination existing in doitt_buildingcentroids **/
UPDATE facilities f
SET geom = b.wkb_geometry,
FROM doitt_buildingcentroids b
WHERE f.bin = b.bin
AND f.bbl = b.base_bbl;