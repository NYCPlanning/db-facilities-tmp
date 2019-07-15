--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE nysdoccs_corrections
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

update nysdoccs_corrections as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = facility_name,
	factype = 'Detention and Correctional',
	facsubgrp = 'Detention and Correctional',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYS Department of Corrections and Community Supervision',
	opabbrev = 'NYSDOCCS',
	optype = 'Public',
	overagency = 'NYS Department of Corrections and Community Supervision',
	overabbrev = 'NYSDOCCS',
	overlevel = NULL,
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;

