--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysdoh_healthfacilities) w
--group by w.status::text;

ALTER TABLE nysdoh_healthfacilities
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

update nysdoh_healthfacilities as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry IS NULL AND facility_location != 'None'
					        THEN ST_SetSRID(ST_Point(facility_longitude::DOUBLE PRECISION, 
												 facility_latitude::DOUBLE PRECISION), 4326)
				        ELSE wkb_geometry
				    END),
	address = (CASE 
                        WHEN the_geom is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE facility_address_1             
                    END),
	facname = facility_name,
	factype = (CASE
                    WHEN description LIKE '%Residential%'
                        THEN 'Residential Health Care'
                    ELSE description
		        END),
	facsubgrp = (CASE
                    WHEN description LIKE '%Residential%'
                        OR description LIKE '%Hospice%'
                        THEN 'Residential Health Care'
                    WHEN description LIKE '%Adult Day Health%'
                        THEN 'Other Health Care'
                    WHEN description LIKE '%Home%'
                        THEN 'Other Health Care'
                    ELSE 'Hospitals and Clinics'
		        END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE
                    WHEN operator_name = 'City of New York' THEN 'NYC Department of Health and Mental Hygiene'
                    WHEN operator_name = 'New York City Health and Hospital Corporation' 
						THEN 'NYC Health and Hospitals Corporation'
                    WHEN ownership_type = 'State' THEN 'NYS Department of Health'
                    ELSE operator_name
		        END),
	opabbrev = (CASE
                    WHEN operator_name = 'City of New York' THEN 'NYCDOHMH'
                    WHEN operator_name = 'New York City Health and Hospitals Corporation' THEN 'NYCHHC'
                    WHEN ownership_type = 'State' THEN 'NYSDOH'
                    ELSE 'Non-public'
		        END),
	optype = (CASE
                    WHEN operator_name = 'City of New York' THEN 'Public'
                    WHEN operator_name = 'New York City Health and Hospital Corporation' THEN 'Public'
                    WHEN ownership_type = 'State' THEN 'Public'
                    ELSE 'Non-public'
		        END),
	overagency = 'NYS Department of Health',
	overabbrev = 'NYSDOH', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;