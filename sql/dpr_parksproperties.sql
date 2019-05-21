--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dpr_parksproperties) w
--group by w.status::text;

ALTER TABLE dpr_parksproperties
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

UPDATE dpr_parksproperties as t
SET hash = md5(CAST((t.*)AS text)),
	wkb_geometry = (CASE
						WHEN wkb_geometry is NULL 
							THEN ST_SetSRID(ST_Centroid(multipolygon), 4326)
						ELSE wkb_geometry
					END),
	facname = signname,
	factype = typecatego,
	facsubgrp = (CASE
                    -- admin of gov
                    WHEN typecatego = 'Undeveloped' THEN 'Miscellaneous Use'
                    WHEN typecatego = 'Lot' THEN 'City Agency Parking'
                    -- parks
                    WHEN typecatego = 'Cemetery' THEN 'Cemeteries'
                    WHEN typecatego = 'Historic House Park' THEN 'Historical Sites'
                    WHEN typecatego = 'Triangle/Plaza' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecatego = 'Mall' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecatego = 'Strip' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecatego = 'Parkway' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecatego = 'Tracking' THEN 'Streetscapes, Plazas, and Malls'
                    WHEN typecatego = 'Garden' THEN 'Gardens'
                    WHEN typecatego = 'Nature Area' THEN 'Preserves and Conservation Areas'
                    WHEN typecatego = 'Flagship Park' THEN 'Parks'
                    WHEN typecatego = 'Community Park' THEN 'Parks'
                    WHEN typecatego = 'Neighborhood Park' THEN 'Parks'
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