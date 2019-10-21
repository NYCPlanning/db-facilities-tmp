UPDATE facilities
SET longitude = (CASE
                    WHEN longitude IS NULL THEN ST_X(geom)::text
                    ELSE longitude
                END),
    latitude = (CASE
                    WHEN latitude IS NULL THEN ST_Y(geom)::text
                    ELSE latitude
                END);