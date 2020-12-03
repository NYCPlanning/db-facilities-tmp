--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dsny_mtsgaragemaintenance) w
--group by w.status::text;

ALTER TABLE dsny_mtsgaragemaintenance
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

update dsny_mtsgaragemaintenance as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_GeometryFromText(location, 4326)
				        ELSE wkb_geometry
					END),
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	geo_bbl = (CASE
				WHEN geo_bbl IS NULL AND ROUND(NULLIF(bbl, 'NULL')::NUMERIC,0)::TEXT ~ '\y(\d{10})\y'
				THEN ROUND(NULLIF(bbl, 'NULL')::NUMERIC,0)::TEXT
				ELSE geo_bbl
			END),
  	facname = (CASE
                    WHEN type ~* 'garage' THEN CONCAT(name,' ',type)
                    WHEN type !~* 'garage' THEN CONCAT(name)
		        END),
	factype = (CASE
                    WHEN type ~* 'mts' THEN 'DSNY Marine Transfer Station'
                    WHEN type ~* 'garage' THEN 'DSNY Garage'
                    WHEN type ~* 'repair' THEN 'DSNY Repair Facility'
                    WHEN type ~* 'drop off' THEN 'DSNY Drop-Off Facility'
		        END),
	facsubgrp = 'Solid Waste Transfer and Carting',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Sanitation',
	opabbrev = 'NYCDSNY',
	optype = 'Public',
	overagency = 'NYC Department of Sanitation',
	overabbrev = 'NYCDSNY', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;