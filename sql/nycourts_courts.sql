--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;

ALTER TABLE nycourts_courts
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

UPDATE nycourts_courts as t
SET hash = md5(CAST((t.*)AS text)),
	address = (CASE 
                        WHEN wkb_geometry is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = name,
	factype = 'Courthouse',
	facsubgrp = 'Courthouses and Judicial',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYS Unified Court System',
	opabbrev = 'NYCOURTS',
	optype = 'Public',
	overagency = 'NYS Unified Court System',
	overabbrev = 'NYCOURTS',
	overlevel = NULL,
	capacity = NULL,
	captype = NULL,
	proptype = NULL;

-- Deduplicate for records at the same location having both regular court and summons court
DELETE FROM nycourts_courts
WHERE ogc_fid::NUMERIC NOT IN(
SELECT min(ogc_fid::NUMERIC) AS sommons
FROM nycourts_courts
GROUP BY REPLACE(REPLACE(REPLACE(name,' (Summons Court)',''),' (Summons Court )',''),'The ',''), address);

-- Delete a courthouse in dcas_colp if it's included in nycourts_courts
DELETE FROM dcas_colp
WHERE factype = 'Courthouse'
AND UPPER(name) IN (
SELECT UPPER(name) FROM nycourts_courts)
;