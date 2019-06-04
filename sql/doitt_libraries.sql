
-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from doitt_libraries) w
-- group by w.status::text;

ALTER TABLE doitt_libraries
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

update doitt_libraries as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = name,
	factype = 'Public Library',
	facsubgrp = 'Public Libraries',	
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE
				WHEN system = 'QPL' THEN 'Queens Public Libraries'
				WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
				WHEN system = 'NYPL' THEN 'New York Public Libraries'
				END),
	opabbrev = system,
	optype = 'Non-public',
	overagency = (CASE
				WHEN system = 'QPL' THEN 'Queens Public Libraries'
				WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
				WHEN system = 'NYPL' THEN 'New York Public Libraries'
				END),
	overabbrev = system, 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;