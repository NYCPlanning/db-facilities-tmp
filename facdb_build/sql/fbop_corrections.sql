
-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from fbop_corrections) w
-- group by w.status::text;

ALTER TABLE fbop_corrections
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

update fbop_corrections as t
SET hash =  md5(CAST((t.*)AS text)), 
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = nametitle,
	factype = 'Detention Center' ,
	facsubgrp = 'Detention and Correctional', 
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'Federal Bureau of Prisons', 
	opabbrev = 'FBOP',
	optype = 'Public',
	overagency = 'Federal Bureau of Prisons', 
	overabbrev = 'FBOP', 
	overlevel = NULL,
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;