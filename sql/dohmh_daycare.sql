--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dohmh_daycare) w
--group by w.status::text;

-- Update inspection_date with None value to '01/01/2000' temporarily
UPDATE dohmh_daycare
SET inspection_date = (CASE WHEN UPPER(inspection_date) = 'NONE' THEN '01/01/2000'
							ELSE inspection_date
						END);
						
-- Delete duplicates, only keep the records for each unique Day Care ID with the latest inspectation date
DELETE FROM dohmh_daycare
WHERE ogc_fid NOT IN(
WITH date AS(
SELECT day_care_id, MAX(inspection_date::date) as latest_date
FROM dohmh_daycare
GROUP BY day_care_id
)
SELECT min(ogc_fid) as orc_fid
FROM dohmh_daycare dc, date d
WHERE dc.day_care_id = d.day_care_id
AND dc.inspection_date::date = d.latest_date
GROUP BY dc.day_care_id
);

ALTER TABLE dohmh_daycare
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
	ADD	proptype text,
	ADD address text;

update dohmh_daycare as t
SET hash =  md5(CAST((t.*)AS text)),
    address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE hnum || ' ' || sname           
                END),
	inspection_date = (CASE WHEN inspection_date::text = '01/01/2000' THEN 'None'
								ELSE inspection_date::text
							END),
	facname = (CASE
				WHEN center_name LIKE '%SBCC%' THEN initcap(legal_name)
				WHEN center_name LIKE '%SCHOOL BASED CHILD CARE%' THEN initcap(legal_name)
				ELSE initcap(center_name)
			END),
	factype = (CASE
		
					WHEN (facility_type ~* 'camp') AND (program_type ~* 'All Age Camp') 
						THEN 'Camp - All Age'
		
					WHEN (facility_type ~* 'camp') AND (program_type ~* 'School Age Camp') 
						THEN 'Camp - School Age'
		
					WHEN (program_type ~* 'Preschool Camp') 
						THEN 'Camp - Preschool Age'
		
					WHEN ((facility_type = 'GDC') AND (program_type = 'Child Care - Infants/Toddlers' OR program_type = 'INFANT TODDLER'))
					OR ((facility_type = 'GDC') AND (program_type = 'Child Care - Pre School' OR program_type = 'PRESCHOOL'))
						THEN 'Day Care'
		
					WHEN (facility_type = 'SBCC') AND (program_type = 'PRESCHOOL')
						THEN 'School Based Child Care - Preschool'
		
					WHEN (facility_type = 'SBCC') AND (program_type = 'INFANT TODDLER')
						THEN 'School Based Child Care - Infants/Toddlers'
						
					WHEN facility_type = 'SBCC'
						THEN 'School Based Child Care - Age Unspecified'
		
					WHEN facility_type = 'GDC'
						THEN 'Group Day Care - Age Unspecified'
						
					ELSE CONCAT(facility_type,' - ',program_type)
				END),
				
	facsubgrp = (CASE
					WHEN (facility_type ~* 'CAMP' OR program_type ILIKE '%CAMP%')
						THEN 'Camps'
					
					ELSE 'Day Care'
				END),

	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(legal_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Health and Mental Hygiene',
	overabbrev = 'NYCDOHMH', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

-- Deduplicate for factype 'Day Care', only keep one record for facilities having the same legal_name, hnum, sname
DELETE FROM dohmh_daycare
WHERE ogc_fid IN(
	SELECT ogc_fid FROM dohmh_daycare
	WHERE factype = 'Day Care'
	AND ogc_fid NOT IN(
		SELECT MIN(ogc_fid) as ogc_fid
		FROM dohmh_daycare
		WHERE factype = 'Day Care'
		GROUP BY legal_name, hnum, sname
	)
)
;

-- Use DOE or ACS as the primary source and drop duplicate (same bin with similar name) DOHMH record

-- REMOVE daycare center duplicates from DOHMH based on acs_daycareheadstart
WITH flag AS(
    WITH match AS(
        SELECT TRIM(
            REPLACE(
            REPLACE(
            UPPER(a.program_name),'-',' '),'  ', '')
            ) AS acs_name, 
            TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(d.legal_name),'INC', ''),'LLC', ''),',',''),'.',''),'-',' '),'THE',''),'  ', '')
            ) AS dohmh_name, 
            d.day_care_id
        FROM acs_daycareheadstart a, dohmh_daycare d
        WHERE a.geo_bin = d.geo_bin
        AND a.geo_bin != ''
                )
    SELECT day_care_id, string_to_array(acs_name, ' ')&&string_to_array(dohmh_name, ' ') AS similarity_flag
    FROM match)
DELETE FROM dohmh_daycare
WHERE day_care_id IN(
SELECT day_care_id 
FROM flag
WHERE similarity_flag = True
);

-- REMOVE PREK duplicates from DOHMH based on doe_universalprek
WITH flag AS(
    WITH match AS(
        SELECT TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(a.name),'SCHOOL',' '),'INC',' '),'LLC',' '),'THE',' '),'-',' '),',',' '),'.',' '),'  ', '')
            ) AS doe_name, 
            TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(d.legal_name),'INC', ''),'LLC', ''),',',''),'.',' '),'-',' '),'THE',''),'  ', '')
            ) AS dohmh_name, 
            d.day_care_id
        FROM doe_universalprek a, dohmh_daycare d
        WHERE a.geo_bin = d.geo_bin
        AND a.geo_bin != '')
    SELECT day_care_id,string_to_array(doe_name, ' ')&&string_to_array(dohmh_name, ' ') AS similarity_flag
    FROM match)
DELETE FROM dohmh_daycare
WHERE day_care_id IN(
SELECT day_care_id 
FROM flag
WHERE similarity_flag = True
);