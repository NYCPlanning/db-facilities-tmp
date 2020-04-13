--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dot_ferryterminals) w
--group by w.status::text;

ALTER TABLE dot_ferryterminals
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

update dot_ferryterminals as t
SET hash =  md5(CAST((t.*)AS text)), 
	address = geo_street_name,
	facname = name,
	factype = (CASE WHEN UPPER(name) LIKE '%TERMINAL%' THEN 'Ferry Terminal'
					WHEN UPPER(name) LIKE '%LANDING%' THEN 'Ferry Landing'
				END),
	facsubgrp = 'Ports and Ferry Landings',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Transportation',
	opabbrev = 'NYCDOT',
	optype = 'Public',
	overagency = 'NYC Department of Transportation',
	overabbrev = 'NYCDOT', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;