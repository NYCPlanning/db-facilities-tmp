--select w.status::text, count(*) 
--from (select geo::json->'status' as status from moeo_socialservicesiteloactions) w
--group by w.status::text;

-- remove programs without sufficient information to group
DELETE FROM moeo_socialservicesiteloactions
WHERE PROGRAM_NAME = 'CONDOM DISTRIBUTION SERVICES'
OR PROGRAM_NAME = 'GROWING UP NYC INITIATIVE SUPPORT SERVICES'
OR PROGRAM_NAME = 'PLANNING AND EVALUATION [BASE]'
OR PROGRAM_NAME = 'TO BE DETERMINED - UNKNOWN';

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
            facname = provider_name||program_name,
            factype = program_name,
            facsubgrp = (CASE
                            WHEN program_name LIKE '%JOB%'
                            OR program_name LIKE '%VOCATIONAL%' 
                            OR program_name = 'ASSISTED COMPETITIVE EMPLOYMENT' 
                                THEN 'Workforce Development'
                            WHEN program_name = 'DROP-IN CENTERS' 
                            OR program_name LIKE '%FOOD%'
                                THEN 'Soup Kitchens and Food Pantries'
                            WHEN program_name = 'NY NY III SUPPORTED HOUSING' 
                                THEN 'Residential Health Care'
                            WHEN program_name = 'CASE MANAGEMENT' 
                            OR program_name = 'HOMEMAKER SERVICES'
                                THEN 'Programs for People with Disabilities'
                            WHEN program_name = 'HOMEBASE HOMELESSNESS PREVENTION' 
                            OR program_name = 'HOMELESS PLACEMENT SERVICES (NON-LICENSED PROGRAM)'
                            OR program_name = 'RAPID RE-HOUSING'
                            OR program_name LIKE '%TRANSITIONAL%'
                                THEN 'Non-residential Housing and Homeless Services'
                            WHEN UPPER(program_name) LIKE '%MENTAL HEALTH%'
                            OR UPPER(program_name) LIKE '%CRISIS%'
                            OR UPPER(program_name) LIKE '%NON-MEDICAID%'
                            OR UPPER(program_name) LIKE '%NON-MEDICAL%'
                            OR UPPER(program_name) LIKE '%PSYCHOSOCIAL%'
                            OR program_name = 'AFFIRMATIVE BUSINESS/INDUSTRY'
                            OR program_name = 'ASSERTIVE COMMUNITY TREATMENT'
                            OR program_name = 'COORDINATED CHILDREN''S SERVICES INITIATIVE'
                            OR program_name = 'FAMILY SUPPORT SERVICES'
                            OR program_name = 'HOME BASED FAMILY TREATMENT'
                            OR program_name = 'MICA NETWORK'
                            OR program_name = 'SELF-HELP'
                            OR program_name = 'SINGLE POINT OF ACCESS'
                                THEN 'Mental Health'
                            WHEN UPPER(program_name) LIKE '%LEGAL SERVICES%'
                            OR program_name = 'CUSTOMIZED ASSISTANCE SERVICES (CAS)'
                                THEN 'Legal and Intervention Services'
                            WHEN UPPER(program_name) LIKE '%CHECK%'
                            OR UPPER(program_name) LIKE '%EARLY INTERVENTION SERVICES: ROUTINE%'
                            OR UPPER(program_name) LIKE '%HIV TESTING%'
                            OR UPPER(program_name) LIKE '%PEP CENTERS%'
                            OR program_name = 'CHLAMYDIA SCREENING PROGRAM'
                            OR program_name = 'CLINIC TREATMENT'
                            OR program_name = 'COMMUNITY RESIDENTIAL'
                            OR program_name = 'COUNCIL LINKAGE PROGRAMS'
                            OR program_name = 'EVIDENCE-BASED INTERVENTIONS IN CLINICAL SETTINGS'
                            OR program_name = 'SCHOOL BASED HEALTH CENTER FAMILY PLANNING - TEENAGE PREGNANCY INITIATIVE'
                                THEN 'Hospitals and Clinics'
                            WHEN UPPER(program_name) LIKE '%ADVOCACY%'
                            OR UPPER(program_name) LIKE '%GAMBLING%'
                            OR (UPPER(program_name) LIKE '%PREVENT%'
                            AND program_name <> 'ABUSE PREVENTION'
                            AND program_name <> 'HOMEBASE HOMELESSNESS PREVENTION'
                            AND program_name <> 'HIV TESTING AND STATUS NEUTRAL PREVENTION AND CARE NAVIGATION IN BROOKLYN')
                            OR UPPER(program_name) LIKE '%PREP%'
                            OR (UPPER(program_name) LIKE '%OUTREACH%'
                            AND program_name <> 'CPEP CRISIS OUTREACH')
                            OR PROGRAM_NAME = 'ADDRESSING HEALTH DISPARITIES IMPACTING LESBIAN, GAY, BISEXUAL AND TRANSGENDER POPULATIONS'
                            OR PROGRAM_NAME = 'ASTHMA COUNSELOR PROGRAM (EAST HARLEM)'
                            OR PROGRAM_NAME = 'EARLY INTERVENTION SERVICES: PRIORITY POPULATIONS TESTING IN NON-CLINICAL SETTINGS'
                            OR PROGRAM_NAME = 'EARLY INTERVENTION SERVICES: SOCIAL NETWORK STRATEGY TESTING IN NON-CLINICAL SETTINGS'
                            OR PROGRAM_NAME = 'EVENTS TO PROMOTE THE HEALTH & WELLNESS OF BLACK MEN WHO HAVE SEX WITH MEN'
                            OR PROGRAM_NAME = 'FAITH-BASED INITIATIVE'
                            OR PROGRAM_NAME = 'HARM REDUCTION SERVICES'
                            OR PROGRAM_NAME = 'HEALTH EDUCATION AND RISK REDUCTION'
                            OR PROGRAM_NAME = 'HEP-C PEER NAVIGATION [574]'
                            OR PROGRAM_NAME = 'LGBTQ COALITION'
                            OR PROGRAM_NAME = 'NURSE-FAMILY PARTNERSHIP SERVICES'
                            OR PROGRAM_NAME = 'POLICY, COMMUNITY RESILIENCE AND RESPONSE'
                            OR PROGRAM_NAME = 'SCHOOL'
                            OR PROGRAM_NAME = 'TRAINING [574]'
                                THEN 'Health Promotion and Disease Prevention'
                            WHEN program_name = 'EARLY LEARN NYC: NEW YORK CITY''S EARLY CARE AND EDUCATION SERVICES'
                                THEN 'Child Care'
                            WHEN UPPER(program_name) LIKE '%MEDICALLY%'
                            OR UPPER(program_name) LIKE '%METH%'
                                THEN 'Chemical Dependency'
                            WHEN program_name = 'SUMMER CAMP'
                                THEN 'Camps'
                            WHEN program_name = 'FOSTER CARE'
                                THEN 'Foster Care Services and Residential Care'
                            ELSE 'Other Health Care'               
                        END ),
            facgroup = NULL,
            facdomain = NULL,
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
            overabbrev = agency_name, 
            overlevel = NULL, 
            capacity = NULL, 
            captype = NULL, 
            proptype = NULL
;