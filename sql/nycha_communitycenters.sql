--select w.status::text, count(*) 
--from (select geo::json->'status' as status from nycha_communitycenters) w
--group by w.status::text;

DELETE FROM nycha_communitycenters
WHERE UPPER(program_type) = 'CLOSED';

ALTER TABLE nycha_communitycenters
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

update nycha_communitycenters as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
					WHEN wkb_geometry IS NULL 
					THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
											 latitude::DOUBLE PRECISION), 4326)
					ELSE wkb_geometry
				END),
	address = (CASE 
                        WHEN wkb_geometry is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = development,
	factype = 'NYCHA Community Center - '|| initcap(program_type),
	facsubgrp = 'Community Centers and Community School Programs',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Housing Authority',
	opabbrev = 'NYCHA',
	optype = 'Public',
	overagency = 'NYC Housing Authority',
	overabbrev = 'NYCHA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

-- Remove senior centers and collapse NYCHA community centers by location 
-- and have one record per community center and categorize as "Community Center"
UPDATE nycha_communitycenters a
SET factype = 'Community Center'
FROM nycha_communitycenters
WHERE a.address IN (
	SELECT address 
	FROM nycha_communitycenters b
	GROUP BY address
	HAVING COUNT(*)>1
);

DELETE FROM nycha_communitycenters
WHERE factype ~* 'senior center'
OR hash IN (
    WITH center AS(
        SELECT address, MIN(hash) as min_hash
		FROM nycha_communitycenters
		WHERE factype = 'Community Center'
        GROUP BY address
    )
SELECT hash FROM nycha_communitycenters nycha, center c
WHERE nycha.address = c.address
AND nycha.hash != c.min_hash
);
