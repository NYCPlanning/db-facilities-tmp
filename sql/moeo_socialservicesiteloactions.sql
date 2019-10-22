--select w.status::text, count(*) 
--from (select geo::json->'status' as status from moeo_socialservicesiteloactions) w
--group by w.status::text;

-- remove programs without sufficient information to group
DELETE FROM moeo_socialservicesiteloactions
WHERE program_name = 'CONDOM DISTRIBUTION SERVICES'
OR program_name = 'GROWING UP NYC INITIATIVE SUPPORT SERVICES'
OR program_name = 'PLANNING AND EVALUATION [BASE]'
OR program_name = 'TO BE DETERMINED - UNKNOWN';

-- deduplicate by facname and site_address_1
WITH tmp AS(
SELECT MIN(ogc_fid) AS ogc_fid
FROM moeo_socialservicesiteloactions
GROUP BY program_name||provider_name, site_address_1
)
DELETE FROM moeo_socialservicesiteloactions
WHERE ogc_fid NOT IN (
SELECT ogc_fid
FROM tmp)
;

ALTER TABLE moeo_socialservicesiteloactions
	ADD hash text, 
	ADD	facname text,
	ADD	servarea text,
	ADD	opname text,
	ADD	opabbrev text,
	ADD	optype text,
	ADD	overagency text,
	ADD	overabbrev text,
	ADD	overlevel text,
	ADD	capacity text,
	ADD	captype text,
	ADD	proptype text,
	ADD address text;

update moeo_socialservicesiteloactions as t
SET hash =  md5(CAST((t.*)AS text)), 
            wkb_geometry = (CASE
                                WHEN wkb_geometry IS NULL 
                                AND longitude IS NOT NULL AND latitude IS NOT NULL
                                AND longitude != 'Error' AND latitude != 'Error'
                                    THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
                                                            latitude::DOUBLE PRECISION), 4326)
                                ELSE wkb_geometry
                            END),
            address = (CASE 
		                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
		                        THEN geo_house_number || ' ' || geo_street_name
		                    ELSE site_address_1          
		                END),
            facname = provider_name || ' ' || program_name,
            factype = (CASE 
                            WHEN factype IS NULL THEN initcap(program_name)
                            ELSE factype
                        END),
            facsubgrp = (CASE 
                            WHEN facsubgrp IS NULL THEN
                                CASE
                                WHEN program_name = 'JOBS & INTERNSHIPS' THEN 'Workforce Development'
                                WHEN program_name = 'GERIATRIC MENTAL HEALTH' THEN 'Mental Health'
                                ELSE 'Other Health Care'
                                END
                            ELSE facsubgrp
                        END),
            servarea = NULL,
            opname = provider_name,
            opabbrev = NULL,
            optype = 'Non-public',
            overagency = (CASE
                            WHEN agency_name = 'DYCD' THEN 'NYC Department of Youth and Community Development'
                            WHEN agency_name = 'ACS' THEN 'NYC Administration for Childrens Services'
                            WHEN agency_name = 'DFTA' THEN 'NYC Department for the Aging'
                            WHEN agency_name = 'DOHMH' THEN 'NYC Department of Health and Mental Hygiene'
                            WHEN agency_name = 'HRA' THEN 'NYC Human Resources Administration'
                        END),
            overabbrev = 'NYC'||agency_name, 
            overlevel = NULL, 
            capacity = NULL, 
            captype = NULL, 
            proptype = NULL
;

DELETE FROM moeo_socialservicesiteloactions
WHERE factype ~* 'Home Delivered Meals'
OR factype ~* 'senior center';