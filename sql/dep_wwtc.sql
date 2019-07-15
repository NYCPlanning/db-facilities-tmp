
-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from dep_wwtc) w
-- group by w.status::text;

ALTER TABLE dep_wwtc
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

update dep_wwtc as t
SET hash =  md5(CAST((t.*)AS text)),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE split_part(address, ',', 1)          
                END),
	facname = name,
	factype = 'Waste Water Treatment Plant' ,
	facsubgrp = 'Wastewater and Pollution Control',	
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Environmental Protection', 
	opabbrev = 'NYCDEP',
	optype = 'Public',
	overagency = 'NYC Department of Environmental Protection', 
	overabbrev = 'NYCDEP', 
	overlevel = NULL,
	capacity = NULL,
	captype = NULL,
	proptype = NULL
;