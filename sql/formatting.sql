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

-- Output the records not having geoms
DROP TABLE IF EXISTS geo_rejects;
SELECT * INTO geo_rejects
FROM facilities
WHERE geom IS NULL;

ALTER TABLE facilities
DROP column grc,
DROP column grc2;

UPDATE facilities a
SET facdomain = UPPER(facdomain),
    facgroup = UPPER(facgroup),
    facsubgrp = UPPER(facsubgrp),
    factype = UPPER(factype),
    facname = UPPER(facname);