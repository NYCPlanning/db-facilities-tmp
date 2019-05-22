
select w.status::text, count(*) 
from (select geo::json->'status' as status from qpl_libraries) w
group by w.status::text;

ALTER TABLE qpl_libraries
    ADD hash text, 
    ADD facname text,
    ADD factype text,
    ADD facsubgrp text,
    ADD facgroup text,
    ADD facdomain text, 
    ADD servarea text,
    ADD opname text,
    ADD opabbrev text,
    ADD optype text,
    ADD overagency text,
    ADD overabbrev text,
    ADD overlevel text,
    ADD capacity text,
    ADD captype text,
    ADD proptype text;

update qpl_libraries as t
SET hash =  md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				            THEN ST_SetSRID(ST_Point(longitude, latitude), 4326)
				        ELSE wkb_geometry
				    END),
    facname = name,
    factype = 'Public Library',
    facsubgrp = 'Public Libraries', 
    facgroup = NULL,
    facdomain = NULL,
    servarea = NULL,
    opname = 'Queens Public Library', 
    opabbrev = NULL,
    optype = 'Public',
    overagency = 'Queens Public Library',
    overabbrev = 'QPL', 
    overlevel = NULL, 
    capacity = NULL, 
    captype = NULL, 
    proptype = NULL
;
