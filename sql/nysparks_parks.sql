--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;
DELETE FROM nysparks_parks
WHERE county !~*'NEW YORK|RICHMOND|QUEENS|KINGS|BRONX';

ALTER TABLE nysparks_parks
	ADD datasource text,
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

update nysparks_parks as t
SET hash =  md5(CAST((t.*)AS text)),
	datasource = 'nysparks_parks',
	address = NULL,
	facname = name,
	factype = category,
	facsubgrp = (CASE
			WHEN category LIKE '%Preserve%' THEN 'Preserves and Conservation Areas'
			ELSE 'Parks'
		END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = NULL,
	opabbrev = NULL,
	optype = 'Public',
	overagency = 'The New York State Office of Parks, Recreation and Historic Preservation',
	overabbrev = 'NYSOPRHP',
	overlevel = 'State',
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;





