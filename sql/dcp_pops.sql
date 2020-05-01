
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
	ADD	proptype text, 
	ADD address text;

update dcp_pops as t
SET hash =  pops_number, 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL
				        THEN ST_TRANSFORM(ST_SetSRID(ST_Point(
				        		xcoordinate::DOUBLE PRECISION, 
				        		ycoordinate::DOUBLE PRECISION), 
				        		2263), 4326)
				        ELSE wkb_geometry
					END),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE hnum || ' ' || sname           
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


