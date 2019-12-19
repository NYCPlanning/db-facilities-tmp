-- remove po boxes
DELETE from facilities 
where address ~* 'PO BOX|P.O. BOX|P. O. BOX|P.O.BOX|P.O BOX';

-- convert facname to all caps
UPDATE facilities a
SET facname = UPPER(facname);

-- remove community board offices from dcp_sfpsd
DELETE from facilities
WHERE datasource = 'dcp_sfpsd' and facname ~* 'COMM BD';

UPDATE facilities a
SET factype =   REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(factype, 
                    'Usda Community Eligibility Option', 'USDA Community Eligibility Option'),
                    'Ged-Alternative High School Equivalency Prep Programs', 'GED-Alternative High School Equivalency Prep Programs'),
                    'Registered Esl Schools', 'Registered ESL Schools'), 
                    'Diagnostic & Treatment Center', 'Diagnostic and Treatment Center');

UPDATE facilities a
SET facdomain = UPPER(facdomain),
    facgroup = UPPER(facgroup),
    facsubgrp = UPPER(facsubgrp),
    factype = UPPER(factype),
    facname = UPPER(facname);


UPDATE facilities a
SET bbl = (CASE
            WHEN bbl ~ '^0' THEN NULL ELSE bbl
        END),
    bin = (CASE
            WHEN bin::NUMERIC%1000000=0 THEN NULL ELSE bin
        END),
    capacity = (CASE
            WHEN bbl ~ '^0' THEN NULL ELSE capacity
        END);

--ADD date datasource downloaded
ALTER TABLE facilities
ADD COLUMN IF NOT EXISTS date_datasource_downloaded TEXT;

UPDATE facilities
SET date_datasource_downloaded = (CASE WHEN datasource = 'hra_centers' OR datasource = 'nysed_activeinstitutions' THEN '07/12/2019'
									   WHEN datasource = 'nysoasas_programs' THEN '07/29/2019'
									   WHEN datasource = 'usnps_parks' THEN '11/18/2019'
									   WHEN datasource = 'moeo_socialservicesiteloactions' THEN '11/12/2019'
									   WHEN datasource = 'nycdoc_corrections' THEN '12/10/2019'
									   WHEN datasource = 'dcp_pops' THEN '12/16/2019'
									   ELSE '11/15/2019'
								END);