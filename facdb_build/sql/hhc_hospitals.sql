--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE hhc_hospitals
	ADD hash text, 
	ADD facname text,
	ADD factype text,
	ADD facsubgrp text,
	ADD facgroup text,
	ADD facdomain text,
	ADD servarea text,
	ADD opname text,
	ADD opabbrev text,
	ADD optype text,
	ADD overagency text,
	ADD overabbrev text,
	ADD overlevel text,
	ADD capacity text,
	ADD captype text,
	ADD proptype text;

update hhc_hospitals as t
SET hash =  md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE
				        WHEN wkb_geometry IS NULL
					        THEN ST_SetSRID(ST_Point(
								split_part(REPLACE(reverse(split_part(reverse(location_1),
											'(', 1)),')',''), ',', 2)::DOUBLE PRECISION,
								split_part(REPLACE(reverse(split_part(reverse(location_1),
											'(', 1)),')',''), ',', 1)::DOUBLE PRECISION), 4326)
				        ELSE wkb_geometry
				    END),
    address = (CASE 
					WHEN geo_street_name is not NULL and geo_house_number is not NULL
						THEN geo_house_number || ' ' || geo_street_name
					ELSE regexp_replace(split_part(location_1, '(', 1), '.{6}$', '')
				END),
	geo_bbl = (CASE
				WHEN geo_bbl IS NULL AND bbl ~ '\y(\d{10})\y' THEN bbl
				ELSE geo_bbl
			END),
	facname = facility_name,
	factype = facility_type,
	facsubgrp = (CASE
                        WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
                        ELSE 'Hospitals and Clinics'
                END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Health and Hospitals Corporation',
	opabbrev = 'NYCHHC',
	optype = 'Public',
	overagency = 'NYS Department of Health',
	overabbrev = 'NYSDOH', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

DELETE FROM hhc_hospitals
WHERE factype = 'Nursing Home';