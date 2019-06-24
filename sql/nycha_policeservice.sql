
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dfta_contracts) w
--group by w.status::text;

ALTER TABLE nycha_policeservice
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

update nycha_policeservice as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = initcap(psa),
	factype = 'NYCHA Police Service',
	facsubgrp = 'Police Services',
	facgroup = 'Public Safety',
	facdomain = 'Public Safety, Emergency Services, and Administration of Justice',
	servarea = NULL,
	opname = 'NYC Housing Authority',
	opabbrev = 'NYCHA',
	optype = 'Public',
	overagency = 'NYC Housing Authority',
	overabbrev = 'NYCHA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;