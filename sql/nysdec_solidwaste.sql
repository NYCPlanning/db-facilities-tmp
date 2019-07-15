--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysdec_solidwaste) w
--group by w.status::text;

ALTER TABLE nysdec_solidwaste
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

update nysdec_solidwaste as t
SET hash =  md5(CAST((t.*)AS text)),
    address = (CASE 
                        WHEN the_geom is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE location_address             
                    END),
	facname = facility_name,
	factype = (CASE
                    WHEN activity_desc LIKE '%C&D%' THEN 'Construction and Demolition Processing'
                    WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
                    WHEN activity_desc LIKE '%Other%' THEN 'Other Solid Waste Processing'
                    WHEN activity_desc LIKE '%RHRF%' THEN 'Recyclables Handling and Recovery'
                    WHEN activity_desc LIKE '%medical%' THEN 'Regulated Medical Waste'
                    WHEN activity_desc LIKE '%Transfer%' THEN 'Transfer Station'
                    ELSE initcap(trim(split_part(split_part(activity_desc,';',1),'-',1),' '))
		        END),
	facsubgrp = (CASE
                    WHEN activity_desc LIKE '%Transfer%' THEN 'Solid Waste Transfer and Carting'
                    ELSE 'Solid Waste Processing'
	            END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE
                WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
                WHEN owner_name IS NOT NULL THEN owner_name
                ELSE 'Unknown'
		     END),
	opabbrev = (CASE
                    WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
                    ELSE 'Non-public'
		        END),
	optype = (CASE
                    WHEN owner_type = 'Municipal' THEN 'Public'
                    ELSE 'Non-public'
		        END),
	overagency = (CASE
                            WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
                            ELSE 'NYS Department of Environmental Conservation'
		                END),
	overabbrev = (CASE
                            WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
                            ELSE 'NYSDEC'
		                END), 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;