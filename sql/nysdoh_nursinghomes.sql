--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nysdoh_nursinghomes) w
--group by w.status::text;

DELETE FROM nysdoh_nursinghomes
WHERE "bed_type/service_category" != 'Total Residential Beds' 
AND "bed_type/service_category" != 'Total Adult Day Health Care Capacity'
OR ("bed_type/service_category" = 'Total Adult Day Health Care Capacity'
AND total_capacity = '0')
;

ALTER TABLE nysdoh_nursinghomes
    ADD hash text,
    ADD facname text,
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

update nysdoh_nursinghomes as t
SET hash =  md5(CAST((t.*)AS text)),
address = (CASE 
                        WHEN the_geom is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE street_address             
                    END), 
    facname = facility_name,
    factype = (CASE
                WHEN "bed_type/service_category" = 'Total Residential Beds' THEN 'Nursing Home'
                WHEN "bed_type/service_category" = 'Total Adult Day Health Care Capacity' THEN 'Adult Day Care'
            END),
	facsubgrp = (CASE
                    WHEN "bed_type/service_category" = 'Total Residential Beds' THEN 'Residential Health Care'
                    WHEN "bed_type/service_category" = 'Total Adult Day Health Care Capacity' THEN 'Other Health Care'
                END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = facility_name,
	opabbrev = NULL,
	optype = 'Non-public',
	overagency = 'NYS Department of Health',
	overabbrev = 'NYSDOH', 
	overlevel = NULL, 
	capacity = total_capacity, 
	captype = (CASE
                    WHEN "bed_type/service_category" = 'Total Residential Beds' THEN 'beds'
                    WHEN "bed_type/service_category" = 'Total Adult Day Health Care Capacity' THEN 'seats'
                END), 
	proptype = NULL
;