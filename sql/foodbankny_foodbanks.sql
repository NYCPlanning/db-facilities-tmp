--select w.status::text, count(*) 
--from (select geo::json->'status' as status from foodbankny_foodbanks) w
--group by w.status::text;

ALTER TABLE foodbankny_foodbanks
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

update foodbankny_foodbanks as t
SET hash =  md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_SetSRID(ST_Point(
				        		lng::DOUBLE PRECISION, 
				        		lat::DOUBLE PRECISION), 
				        		4326)
				        ELSE wkb_geometry
					END),
	facname = title,
	factype = (CASE
				WHEN categories = '64' THEN 'Food Pantry'
				WHEN categories = '65' THEN 'Soup Kitchen'
				WHEN categories = '63' THEN 'Senior Services'
				WHEN categories = '66' THEN 'Financial Assistance and Social Services'
				WHEN categories = '67' THEN 'Soup Kitchens and Food Pantries'
			  END),
	facsubgrp = 'Soup Kitchens and Food Pantries',	
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = title,
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'Non-public',
	overabbrev = 'Non-public', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;