--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysopwdd_providers) w
--group by w.status::text;

ALTER TABLE nysopwdd_providers
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

update nysopwdd_providers as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = initcap(Service_Provider_Agency),
	factype = 'Programs for People with Disabilities',
			-- (CASE
			-- 	WHEN 	
			-- 	Intermediate_Care_Facilities_ICFs
			-- 	Individual_Residential_Alternative_IRA
			-- 	Family_Care
			-- 	Consolidated_Supports_And_Services
			-- 	Individual_Support_Services_ISSs
			-- 	Day_Training
			-- 	Day_Treatment
			-- 	Senior_Geriatric_Services
			-- 	Day_Habilitation
			-- 	Work_Shop
			-- 	Prevocational
			-- 	Supported_Employment_Enrollments
			-- 	Community_Habilitation
			-- 	Family_Support_Services
			-- 	Care_at_Home_Waiver_Services
			-- 	Developmental_Centers_And_Special_Population_Services
			-- END),
	facsubgrp = 'Programs for People with Disabilities',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(Service_Provider_Agency),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYS Office for People With Developmental Disabilities',
	overabbrev = 'NYSOPWDD', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;