UPDATE facilities
SET longitude = (CASE
                    WHEN geom IS NOT NULL THEN ST_X(geom)::text
                    ELSE longitude
                END),
    latitude = (CASE
                    WHEN geom IS NOT NULL THEN ST_Y(geom)::text
                    ELSE latitude
                END);