--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dot_mannedfacilities) w
--group by w.status::text;

ALTER TABLE dot_mannedfacilities
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

update dot_mannedfacilities as t
SET hash =  md5(CAST((t.*)AS text)), 
    wkb_geometry = (CASE
        WHEN wkb_geometry is NULL 
        THEN ST_GeometryFromText(point_location, 4326)
        ELSE wkb_geometry
    END),
    address = (CASE 
                        WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        WHEN address is not NULL THEN address
                        ELSE site             
                    END),
	geo_bbl = (CASE
				WHEN geo_bbl IS NULL AND bbl ~ '\y(\d{10})\y' THEN bbl
				ELSE geo_bbl
			END),
    facname = (CASE
                        WHEN operations IS NOT NULL THEN operations
                        ELSE division
                END),
    factype = (CASE
                        WHEN operations LIKE '%Asphalt%' THEN 'Asphalt Plant'
                        WHEN division LIKE '%RRM%' OR division LIKE '%SIM%' OR division LIKE '%OCMC%' OR division LIKE '%HIQA%' OR division LIKE '%TMC%' OR division LIKE '%JETS%' OR division LIKE '%JETS%' OR division LIKE '%Multiple%' OR division LIKE '%External Affairs%' OR division LIKE '%Services%' THEN 'Maintenance, Management, and Operations'
                        ELSE 'Manned Transportation Facility'
                END),
    facsubgrp = (CASE
                        WHEN operations LIKE '%Asphalt%' THEN 'Material Supplies'
                        ELSE 'Other Transportation'
                    END),
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