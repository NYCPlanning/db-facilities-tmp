--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE doe_busroutesgarages
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

update doe_busroutesgarages as t
SET hash =  md5(CAST((t.*)AS text)),
	address = (CASE 
	                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
	                        THEN geo_house_number || ' ' || geo_street_name
	                    ELSE garage__street_address         
	                END),
	facname = initcap(vendor_name),
	factype = 'School Bus Depot',
	facsubgrp = 'Bus Depots and Terminals',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(vendor_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Education',
	overabbrev = 'NYCDOE', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;