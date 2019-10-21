--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;
DELETE FROM nysdec_lands
WHERE county !~*'NEW YORK|RICHMOND|QUEENS|KINGS|BRONX';

ALTER TABLE nysdec_lands
	ADD hash text,
	ADD facname text,
	ADD factype text,
	ADD facsubgrp text,
	ADD facgroup text,
	ADD facdomain text, 
	ADD servarea text,
	ADD opname text,
	ADD opabbrev text,
	ADD optype text,
	ADD overagency text,
	ADD overabbrev text,
	ADD overlevel text,
	ADD capacity text,
	ADD captype text,
	ADD proptype text, 
	ADD address text;

UPDATE nysdec_lands as t
SET hash = md5(CAST((t.*)AS text)),
	wkb_geometry = ST_SetSRID(ST_Centroid(wkb_geometry), 4326),
	address = NULL,
	facname = initcap(facility),
	factype = (CASE
					WHEN category = 'NRA' THEN 'Natural Resource Area'
					ELSE initcap(category)
				END),
	facsubgrp = 'Preserves and Conservation Areas',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYS Department of Environmental Conservation',
	opabbrev = 'NYSDEC',
	optype = 'Public',
	overagency = 'NYS Department of Environmental Conservation',
	overabbrev = 'NYSDEC',
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL,
	proptype = NULL;