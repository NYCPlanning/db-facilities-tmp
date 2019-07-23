--select w.status::text, count(*) 
--from (select geo::json->'status' as status from doe_busroutesgarages) w
--group by w.status::text;

ALTER TABLE doe_busroutesgarages
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

WITH capacity AS(
	SELECT vendor_name, garage__street_address, COUNT(DISTINCT(route_number)) AS route_counts 
	FROM doe_busroutesgarages
	GROUP BY vendor_name, garage__street_address
)
update doe_busroutesgarages as t
SET hash =  md5(CAST((t.*)AS text)),
	address = (CASE 
						WHEN geo_street_name is not NULL and geo_house_number is not NULL 
							THEN geo_house_number || ' ' || geo_street_name
						ELSE t.garage__street_address         
					END),
	facname = initcap(t.vendor_name),
	factype = 'School Bus Depot',
	facsubgrp = 'Bus Depots and Terminals',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(t.vendor_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Education',
	overabbrev = 'NYCDOE', 
	overlevel = NULL, 
	capacity = route_counts, 
	captype = 'routes', 
	proptype = NULL
FROM capacity c
WHERE t.vendor_name = c.vendor_name
AND t.garage__street_address = c.garage__street_address
;

-- Depulicate by vender_name and garage__street_address
WITH tmp AS(
	SELECT MIN(ogc_fid) AS ogc_fid
	FROM doe_busroutesgarages
	GROUP BY vendor_name, garage__street_address
	)
DELETE FROM doe_busroutesgarages
WHERE ogc_fid NOT IN (
	SELECT ogc_fid
	FROM tmp
	)
;
