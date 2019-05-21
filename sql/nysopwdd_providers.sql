--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysopwdd_providers) w
--group by w.status::text;

ALTER TABLE nysopwdd_providers
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

update nysopwdd_providers as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = initcap(Service_Provider_Agency),
	factype = 'Programs for People with Disabilities',
	facsubgrp = 'Programs for People with Disabilities',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(Service_Provider_Agency),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYS Office for People With Developmental Disabilities',
	overabbrev = 'NYSOPWDD', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;