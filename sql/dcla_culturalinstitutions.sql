
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dcla_culturalinstitutions) w
--group by w.status::text;

ALTER TABLE dcla_culturalinstitutions
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

update dcla_culturalinstitutions as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry IS NULL
					        THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
												 	 latitude::DOUBLE PRECISION), 4326)
				        ELSE wkb_geometry
				    END),
	facname = organization_name, 
	factype = (CASE
					WHEN discipline IS NOT NULL THEN discipline
					ELSE 'Unspecified Discipline'
				END),
	facsubgrp = (CASE
					WHEN discipline LIKE '%Museum%' THEN 'Museums'
					ELSE 'Other Cultural Institutions'
				END),
	facgroup = 'Cultural Institutions',
	facdomain = 'Libraries and Cultural Programs',
	servarea = NULL,
	opname = organization_name,
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Cultural Affairs', 
	overabbrev = 'NYCDCLA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;