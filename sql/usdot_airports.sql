
-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from usdot_airports) w
-- group by w.status::text;

ALTER TABLE usdot_airports
    ADD hash text, 
    ADD facname text,
    ADD factype text,
    ADD facsubgrp text,
    ADD facgroup text,
    ADD facdomain text, 
    ADD servarea text,
    ADD opname text,
    ADD opabbrev text,
    ADD optype text,
    ADD overagency text,
    ADD overabbrev text,
    ADD overlevel text,
    ADD capacity text,
    ADD captype text,
    ADD proptype text; 
    
update usdot_airports as t
SET hash =  md5(CAST((t.*)AS text)),
    wkb_geometry = (CASE
                    WHEN wkb_geometry is NULL 
                    THEN ST_GeometryFromText(location, 4326)
                    ELSE wkb_geometry
					END),
	address = geo_street_name,
    facname = fac_name,
    factype = fac_type,
    facsubgrp = 'Airports and Heliports', 
    facgroup = NULL,
    facdomain = NULL,
    servarea = NULL,
    opname = (CASE
                WHEN owner_type = 'Pr' THEN fac_name
                ELSE 'Public'
                END),
    opabbrev = (CASE
                WHEN owner_type = 'Pr' THEN 'Non-public'
                ELSE 'Public'
                END),
    optype = (CASE
                WHEN owner_type = 'Pr' THEN 'Non-public'
                ELSE 'Public'
                END),
    overagency = 'US Department of Transportation',
    overabbrev = 'USDOT' ,
    overlevel = NULL, 
    capacity = NULL, 
    captype = NULL, 
    proptype = NULL
    ;
