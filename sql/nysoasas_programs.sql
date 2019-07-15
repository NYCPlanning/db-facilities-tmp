--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE nysoasas_programs
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

update nysoasas_programs as t
SET hash =  md5(CAST((t.*)AS text)),
    address = (CASE 
                        WHEN the_geom is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = program_name,
	factype = service_type,
	facsubgrp = 'Chemical Dependency',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = provider_name,
	opabbrev = NULL,
	optype = 'Non-public',
	overagency = 'NYS Office of Alcoholism and Substance Abuse Services',
	overabbrev = 'NYSOASAS',
	overlevel = 'State',
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;





