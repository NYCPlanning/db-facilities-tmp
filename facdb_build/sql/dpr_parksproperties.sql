--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;

ALTER TABLE dpr_parksproperties
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

UPDATE dpr_parksproperties as t
SET hash = md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE
						WHEN wkb_geometry is NULL 
							THEN ST_SetSRID(ST_Centroid(multipolygon::geometry), 4326)
						ELSE wkb_geometry
					END),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    ELSE location            
                END),
	facname = signname,
	factype = typecategory,
	facsubgrp = (CASE
                    -- admin of gov
                    WHEN typecategory = 'Undeveloped' THEN 'Miscellaneous Use'
                    WHEN typecategory = 'Lot' THEN 'City Agency Parking'
                    -- parks
                    WHEN typecategory = 'Cemetery' THEN 'Cemeteries'
                    WHEN typecategory = 'Historic House Park' THEN 'Historical Sites'
                    WHEN typecategory = 'Triangle/Plaza' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecategory = 'Mall' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecategory = 'Strip' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecategory = 'Parkway' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecategory = 'Tracking' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecategory = 'Garden' THEN 'Gardens'
                    WHEN typecategory = 'Nature Area' THEN 'Preserves and Conservation Areas'
                    WHEN typecategory = 'Flagship Park' THEN 'Parks'
                    WHEN typecategory = 'Community Park' THEN 'Parks'
                    WHEN typecategory = 'Neighborhood Park' THEN 'Parks'
                    ELSE 'Recreation and Waterfront Sites'
		        END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Parks and Recreation',
	opabbrev = 'NYCDPR',
	optype = 'Public',
	overagency = 'NYC Department of Parks and Recreation',
	overabbrev = 'NYCDPR',
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL,
	proptype = NULL;