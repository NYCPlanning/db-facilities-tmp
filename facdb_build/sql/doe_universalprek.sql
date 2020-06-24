--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_universalprek) w
--group by w.status::text;

ALTER TABLE doe_universalprek
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

update doe_universalprek as t
SET hash =  md5(CAST((t.*)AS text)),
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = name,
	factype = (CASE
                WHEN type = 'DOE' THEN 'DOE Universal Pre-K'
                WHEN type = 'CHARTER' OR type = 'Charter' THEN 'DOE Universal Pre-K - Charter '
                WHEN type = 'NYCEEC' THEN 'Early Education Program'
				WHEN type = 'PKC' THEN 'Pre-K Center'
		    END),
	facsubgrp = 'DOE Universal Pre-Kindergarten',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE
                WHEN type = 'DOE' THEN 'NYC Department of Education'
                WHEN type = 'CHARTER' OR type = 'NYCEEC' THEN name
                ELSE 'Unknown'
		    END),
	opabbrev = (CASE
                    WHEN type = 'DOE' THEN 'NYCDOE'
                    WHEN type = 'CHARTER' THEN 'Charter'
                    WHEN type = 'NYCEEC' THEN 'Non-public'
                    ELSE 'Unknown'
		        END),
	optype = (CASE
                WHEN type = 'DOE' THEN 'Public'
                ELSE 'Non-public'
		    END),
	overagency = 'NYC Department of Education',
	overabbrev = 'NYCDOE', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;