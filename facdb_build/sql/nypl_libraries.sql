
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nypl_libraries) w
--group by w.status::text;

ALTER TABLE nypl_libraries
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
	
update nypl_libraries as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL
				        THEN ST_SetSRID(ST_Point(
				        		lon::DOUBLE PRECISION, 
				        		lat::DOUBLE PRECISION), 
				        		4326)
				        ELSE wkb_geometry
					END),
	address = (CASE 
                        WHEN wkb_geometry is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = name,
	factype = 'Public Library',
	facsubgrp = 'Public Libraries',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'New York Public Library',
	opabbrev = 'NYPL',
	optype = 'Non-public',
	overagency = 'New York Public Library',
	overabbrev = 'NYPL',
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

