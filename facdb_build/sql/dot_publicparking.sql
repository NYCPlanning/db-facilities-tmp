--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dot_publicparking) w
--group by w.status::text;

ALTER TABLE dot_publicparking
	ADD hash text,
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

update dot_publicparking as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_GeometryFromText(point_location, 4326)
				        ELSE wkb_geometry
					END),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE split_part(facaddress, ',', 1)      
                END),
	geo_bbl = (CASE
			WHEN geo_bbl IS NULL AND bbl ~ '\y(\d{10})\y' THEN bbl
			ELSE geo_bbl
		END),
	factype = 'Public Parking',
	facsubgrp = 'Parking Lots and Garages',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Transportation',
	opabbrev = 'NYCDOT',
	optype = 'Public',
	overagency = 'NYC Department of Transportation',
	overabbrev = 'NYCDOT', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;