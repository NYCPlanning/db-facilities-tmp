--select w.status::text, count(*) 
--from (select geo::json->'status' as status from fdny_firehouses) w
--group by w.status::text;

ALTER TABLE fdny_firehouses
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

update fdny_firehouses as t
SET hash =  md5(CAST((t.*)AS text)),
	address = (CASE 
						WHEN geo_street_name is not NULL and geo_house_number is not NULL 
							THEN geo_house_number || ' ' || geo_street_name
						ELSE t.address         
					END),
	facname = facilityname,
	factype = 'Firehouse',
	facsubgrp = 'Fire Services',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Fire Department',
	opabbrev = 'FDNY',
	optype = 'Public',
	overagency = 'NYC Fire Department',
	overabbrev = 'FDNY', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;