--select w.status::text, count(*) 
--from (select geo::json->'status' as status from bpl_libraries) w
--group by w.status::text;

ALTER TABLE nycha_communitycenters
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
	ADD proptype text;

update nycha_communitycenters as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
					WHEN wkb_geometry IS NULL 
						AND longitude != '' AND latitude != ''
					THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
											 latitude::DOUBLE PRECISION), 4326)
					ELSE wkb_geometry
				END),
	facname = development,
	factype = 'NYCHA Community Center - '|| program_type,
	facsubgrp = 'Community Centers and Community School Programs',
	facgroup = NULL,
	facdomain = NULL,
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
