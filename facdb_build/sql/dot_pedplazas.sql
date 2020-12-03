--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dot_pedplazas) w
--group by w.status::text;

ALTER TABLE dot_pedplazas
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

update dot_pedplazas as t
SET hash =  md5(CAST((t.*)AS text)), 
    wkb_geometry = (CASE
						WHEN wkb_geometry is NULL 
						THEN ST_Centroid(ST_GeometryFromText(polygon_location, 4326))
						ELSE ST_Centroid(wkb_geometry)
					END),
	address = fromstreet || 'and' || tostreet,
	facname = plazaname,
	factype = 'Pedestrian Plaza',
	facsubgrp = 'Streetscapes, Plazas, and Malls',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Transportation',
	opabbrev = 'NYCDOT',
	optype = 'Public',
	overagency = 'NYC Department of Transportation',
	overabbrev = 'NYCDOT', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;