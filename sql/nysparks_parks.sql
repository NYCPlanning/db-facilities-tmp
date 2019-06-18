--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE nysparks_parks
	ADD hash text,
    ADD wkb_geometry geometry, 
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

update nysparks_parks as t
SET hash =  md5(CAST((t.*)AS text)), 
    wkb_geometry = ST_SetSRID(ST_Point(
            longitude::DOUBLE PRECISION, 
            latitude::DOUBLE PRECISION), 
            4326),
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





