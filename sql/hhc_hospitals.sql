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
					        THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
												 	 latitude::DOUBLE PRECISION), 4326)
				        ELSE wkb_geometry
				    END),
    address = (CASE 
                    WHEN wkb_geometry is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE split_part(location_1, ',', 1)       
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

UPDATE hhc_hospitals a
SET wkb_geometry = (CASE
				WHEN b.wkb_geometry IS NULL
					THEN ST_GeomFromText('POINT ('||split_part(b.address, '(', 2), 4326)
				ELSE b.wkb_geometry
			END)
FROM hhc_hospitals b
WHERE a.hash = b.hash
AND b.wkb_geometry IS NULL
