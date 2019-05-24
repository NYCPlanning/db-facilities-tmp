
select w.status::text, count(*) 
from (select geo::json->'status' as status from doe_lcgms) w
group by w.status::text;

ALTER TABLE doe_lcgms
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

update doe_lcgms as t
SET hash =  md5(CAST((t.*)AS text)),
    facname = location_name,
    factype = (CASE
				
				WHEN managed_by_name = 'Charter' AND location_category_description ~* '%school%' THEN 
					CASE 
						WHEN location_type_description NOT LIKE '%Special%' THEN CONCAT(location_category_description, ' - Charter')
						WHEN location_type_description LIKE '%Special%' THEN CONCAT(location_category_description, ' - Charter, Special Education')
					END
					
				WHEN managed_by_name = 'Charter' THEN 
					CASE 
						WHEN location_type_description NOT LIKE '%Special%' THEN CONCAT(location_category_description, ' School - Charter')
						WHEN location_type_description LIKE '%Special%' THEN CONCAT(location_category_description, ' School - Charter, Special Education')
					END
	
				WHEN location_category_description ~* '%school%' THEN
					CASE
						WHEN location_type_description NOT LIKE '%Special%' THEN CONCAT(location_category_description, ' - Public')
						WHEN location_type_description LIKE '%Special%' THEN CONCAT(location_category_description, ' - Public, Special Education')
					END
	
				WHEN location_type_description ~* '%Special%' THEN CONCAT(location_category_description, ' School - Public, Special Education')
	
				ELSE CONCAT(location_category_description, ' School - Public')
				
			END),
    facsubgrp = (CASE

					WHEN location_type_description LIKE '%Special%' THEN 'Public and Private Special Education Schools'
		
					WHEN location_category_description LIKE '%Early%' OR location_category_description LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
		
					WHEN managed_by_name = 'Charter' THEN 'Charter K-12 Schools'
		
					ELSE 'Public K-12 Schools'
		
				END),
    facgroup = NULL,
    facdomain = NULL,
    servarea = NULL,
    opname = (CASE
					WHEN managed_by_name = 'Charter' THEN location_name
					ELSE 'NYC Department of Education'
				END),
    opabbrev = (CASE
					WHEN managed_by_name = 'Charter' THEN 'Non-public'
					ELSE 'NYCDOE'
				END),
    optype = (CASE
					WHEN managed_by_name = 'Charter' THEN 'Non-public'
					ELSE 'NYC Department of Education'
				END),
    overagency = 'NYC Department of Education',
    overabbrev = 'NYCDOE', 
    overlevel = NULL, 
    capacity = NULL, 
    captype = NULL, 
    proptype = NULL
;