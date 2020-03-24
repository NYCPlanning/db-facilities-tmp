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
    wkb_geometry = (CASE
						WHEN wkb_geometry is NULL
						THEN ST_GeomFromText(location, 4326)
						ELSE wkb_geometry
					END),
	address = (CASE 
					WHEN wkb_geometry is not NULL 
						THEN geo_house_number || ' ' || geo_street_name
					ELSE street_address             
				END), 
    facname = facility_name,
    factype = (CASE
                WHEN "bed_type" = 'NHBEDSAV' THEN 'Nursing Home'
                WHEN "bed_type" = 'ADHCPSLOTSAV' THEN 'Adult Day Care'
            END),
	facsubgrp = (CASE
                    WHEN "bed_type" = 'NHBEDSAV' THEN 'Residential Health Care'
                    else 'Other Health Care'
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
                    WHEN "bed_type" = 'Total Residential Beds' THEN 'beds'
                    WHEN "bed_type" = 'Total Adult Day Health Care Capacity' THEN 'seats'
                END), 
	proptype = NULL
;