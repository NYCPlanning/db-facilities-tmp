
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from sbs_workforce1) w
--group by w.status::text;

ALTER TABLE sbs_workforce1
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

update sbs_workforce1 as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = name,
	factype = location_type,			
	facsubgrp = 'Workforce Development',	
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Small Business Services',
	opabbrev = 'NYCSBS',
	optype = 'Public',
	overagency = 'NYC Department of Small Business Services',
	overabbrev = 'NYCSBS', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;