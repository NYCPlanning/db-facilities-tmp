--select w.status::text, count(*) 
--from (select geo::json->'status' as status from bpl_libraries) w
--group by w.status::text;

ALTER TABLE bpl_libraries
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

update bpl_libraries as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = title,
	factype = 'Public Libraries',
	facsubgrp = 'Public Libraries',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'Brooklyn Public Library',
	opabbrev = 'BPL',
	optype = 'Non-public',
	overagency = 'Brooklyn Public Library',
	overabbrev = 'BPL', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;