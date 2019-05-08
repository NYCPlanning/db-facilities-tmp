--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dca_operatingbusinesses) w
--group by w.status::text;

ALTER TABLE dca_operatingbusinesses
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

update dca_operatingbusinesses as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = initcap(Business_Name),
	factype = (CASE 
			        WHEN industry LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			        WHEN industry LIKE '%Tow%' THEN 'Tow Truck Company'
			        ELSE CONCAT('Commercial ', industry)
		        END),
	-- facsubgrp = 
				-- (CASE
					-- WHEN discipline LIKE '%Museum%' THEN 'Museums'
					-- ELSE 'Other Cultural Institutions'
				-- END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(Business_Name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Cultural Affairs',
	overabbrev = 'NYCDCLA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;