/** assign tax lot centroids for record missing geometry **/
UPDATE facilities f
SET geom = (CASE 
                WHEN f.geom IS NULL THEN ST_centroid(wkb_geometry)
                ELSE f.geom
            END)
FROM dcp_mappluto p
WHERE f.bbl = p.bbl::text;