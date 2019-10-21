--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;
DELETE FROM nysparks_historicplaces
WHERE county !~*'NEW YORK|RICHMOND|QUEENS|KINGS|BRONX';

ALTER TABLE nysparks_historicplaces
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

update nysparks_historicplaces as t
SET hash =  md5(CAST((t.*)AS text)),
    address = NULL,
	facname = resource_name,
	factype = 'State Historic Place',
	facsubgrp = 'Historical Sites',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = NULL,
	opabbrev = NULL,
	optype = 'Non-public',
	overagency = 'The New York State Office of Parks, Recreation and Historic Preservation',
	overabbrev = 'NYSOPRHP',
	overlevel = 'State',
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;





