
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dfta_contracts) w
--group by w.status::text;

ALTER TABLE dfta_contracts
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

update dfta_contracts as t
SET hash =  md5(CAST((t.*)AS text)),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE program_address          
                END),
	facname = initcap(sponsor_name), 
	factype = (CASE
					WHEN (contract_type LIKE '%INNOVATIVE%' AND RIGHT(provider_id,2) <> '01') or
						 (contract_type LIKE '%NEIGHBORHOOD%' AND RIGHT(provider_id,2) <> '01') THEN 'Satellite Senior Centers'
					WHEN contract_type LIKE '%INNOVATIVE%' THEN 'Innovative Senior Centers'
					WHEN contract_type LIKE '%NEIGHBORHOOD%' THEN 'Neighborhood Senior Centers'
					WHEN contract_type LIKE '%MEALS%' THEN  initcap(contract_type)
					ELSE 'Senior Services'
				END),
	facsubgrp = 'Senior Services',
	facgroup = 'Human Services',
	facdomain = 'Health and Human Services',
	servarea = NULL,
	opname = initcap(sponsor_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department for the Aging',
	overabbrev = 'NYCDFTA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;