--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;

ALTER TABLE nycdoc_corrections
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

UPDATE nycdoc_corrections as t
SET hash = md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE WHEN geo_street_name = 'HAZEN STREET' THEN NULL
						 ELSE wkb_geometry
					END),
    address = (CASE 
                        WHEN wkb_geometry is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address1
                    END),
	facname = name,
	factype = 'Correctional Facility',
	facsubgrp = 'Detention and Correctional',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Correction',
	opabbrev = 'NYCDOC',
	optype = 'Public',
	overagency = 'NYC Department of Correction',
	overabbrev = 'NYCDOC',
	overlevel = NULL,
	capacity = NULL,
	captype = NULL,
	proptype = NULL;