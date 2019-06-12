--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE hhc_hospitals
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

update hhc_hospitals as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = facility_name,
	factype = facility_type,
	facsubgrp = (CASE
                        WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
                        ELSE 'Hospitals and Clinics'
                END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Health and Hospitals Corporation',
	opabbrev = 'NYCHHC',
	optype = 'Public',
	overagency = 'NYS Department of Health',
	overabbrev = 'NYSDOH', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;
