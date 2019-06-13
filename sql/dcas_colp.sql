--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dcas_colp) w
--group by w.status::text;

ALTER TABLE dcas_colp
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

update dcas_colp as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = initcap(vendor_name),
	factype = 'School Bus Depot',
	facsubgrp = 'Bus Depots and Terminals',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(vendor_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Education',
	overabbrev = 'NYCDOE', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;