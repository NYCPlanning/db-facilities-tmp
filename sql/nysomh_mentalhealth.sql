--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysomh_mentalhealth) w
--group by w.status::text;
ALTER TABLE nysomh_mentalhealth
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

update nysomh_mentalhealth as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = program_name, 
	factype = program_category_description,
	facsubgrp = 'Mental Health',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE
			        WHEN program_type_description LIKE '%State%' THEN 'NYS Office of Mental Health'
			        WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYC Health and Hospitals Corporation'
			        ELSE Agency_Name
		        END),
	opabbrev = (CASE
			        WHEN program_type_description LIKE '%State%' THEN 'NYSOMH'
			        WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYCHHC'
			        ELSE 'Non-public'
		        END),
	optype = (CASE
					WHEN program_type_description LIKE '%State%' THEN 'Public'
					WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'Public'
					ELSE 'Non-public'
				END),
	overagency = 'NYS Office of Mental Health',  
	overabbrev = 'NYSOMH',  
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;