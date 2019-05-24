
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dcp_pops) w
--group by w.status::text;

ALTER TABLE dcp_pops
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

update dcp_pops as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_SetSRID(ST_Point(
				        		longitude::DOUBLE PRECISION, 
				        		latitude::DOUBLE PRECISION), 
				        		4326)
				        ELSE wkb_geometry
					END),
	facname = (CASE
					WHEN building_name IS NOT NULL AND building_name <> '' THEN building_name
					ELSE building_address_with_zip_code
				END),
	factype = 'Privately Owned Public Space',
	facsubgrp = 'Privately Owned Public Space',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'Not Available',
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of City Planning',
	overabbrev = 'NYCDCP',
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;


