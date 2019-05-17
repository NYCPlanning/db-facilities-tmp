--select w.status::text, count(*) 
--from (select geo::json->'status' as status from usnps_parks) w
--group by w.status::text;

ALTER TABLE usnps_parks
	ADD hash text, 
	ADD	facname text,
	ADD	factype text,
	ADD	facsubgrp text,
	ADD	facgroup text,
	ADD	facdomain text, 
	ADD	servarea text,
	ADD	opname text,
	ADD	opabbrev text,
	ADD	optype text,
	ADD	overagency text,
	ADD	overabbrev text,
	ADD	overlevel text,
	ADD	capacity text,
	ADD	captype text,
	ADD	proptype text;

update usnps_parks as t
SET hash =  md5(CAST((t.*)AS text)), 
    the_geom = (CASE
                    WHEN the_geom = ''
                        THEN ST_AsText(ST_Centroid(multipolygon))
                    ELSE the_geom
                END),
	facname = unit_name,
	factype = unit_type,
	facsubgrp = 'Historical Sites',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'National Park Service',
	opabbrev = 'USNPS',
	optype = 'Public',
	overagency = 'National Park Service',
	overabbrev = 'USNPS',
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;