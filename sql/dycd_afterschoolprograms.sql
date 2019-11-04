--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;

ALTER TABLE dycd_afterschoolprograms
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

UPDATE dycd_afterschoolprograms as t
SET hash = md5(CAST((t.*)AS text)),
    wkb_geometry = (CASE
                        WHEN wkb_geometry is NULL
                        THEN ST_GeomFromText('POINT ('||reverse(split_part(reverse(location_1),'(', 1)), 4326)
                        ELSE wkb_geometry
                    END),
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE regexp_replace(split_part(location_1, '(', 1), '.{6}$', '')            
                    END),
	facname = site_name,
	program = REPLACE(program, 'NDA Immigrats', 'NDA Immigrants' ),
	factype = program || ' ' || program_type,
	facsubgrp = 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services', 
	facgroup = NULL, 
	facdomain = NULL,
	servarea = NULL, 
	opname = agency, 
	opabbrev = NULL, 
	optype = 'Non-public', 
	overagency = 'NYC Department of Youth and Community Development', 
	overabbrev = 'NYCDYCD', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL;