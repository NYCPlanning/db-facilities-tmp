UPDATE facilities
SET xcoord = ST_X(ST_TRANSFORM(geom, 2263)),
    ycoord = ST_Y(ST_TRANSFORM(geom, 2263)),
    longitude = (CASE
                    WHEN longitude IS NULL THEN ST_X(geom)::text
                    ELSE longitude
                END),
    latitude = (CASE
                    WHEN latitude IS NULL THEN ST_Y(geom)::text
                    ELSE latitude
                END)
;