-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from foodbankny_foodbanks) w
-- group by w.status::text;

ALTER TABLE foodbankny_foodbanks
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

UPDATE foodbankny_foodbanks as t
SET hash =  md5(CAST((t.*)AS text)),
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = name,
	factype = (CASE
				WHEN program_type ~* 'pantry' THEN 'Food Pantry'
				WHEN program_type ~* 'Soup Kitchen' THEN 'Soup Kitchen'
				when program_tupe ~* 'senior' THEN 'Senior Center'
			  END),
	facsubgrp = (CASE
				when program_tupe ~* 'senior' THEN 'Senior Services'
				else 'Soup Kitchens and Food Pantries'
			  END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = name,
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'Non-public',
	overabbrev = 'Non-public', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

DELETE FROM foodbankny_foodbanks 
WHERE factype ~* 'Senior Center'; 