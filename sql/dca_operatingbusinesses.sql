--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dca_operatingbusinesses) w
--group by w.status::text;

ALTER TABLE dca_operatingbusinesses
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

update dca_operatingbusinesses as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION, 
												 latitude::DOUBLE PRECISION), 4326)
				        ELSE wkb_geometry
				    END),
	address = (CASE 
                    WHEN geo_street_name is not NULL and geo_house_number is not NULL 
                        THEN geo_house_number || ' ' || geo_street_name
                    WHEN geo_street_name is NULL and geo_house_number is NULL and address is not NULL
                    	THEN address
                    WHEN  address_building is not NULL and address_street_name is not NULL
                    	THEN address_building || ' ' || address_street_name       
                END),
	facname = initcap(business_name),
	factype = (CASE 
			        WHEN industry LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			        WHEN industry LIKE '%Tow%' THEN 'Tow Truck Company'
			        ELSE CONCAT('Commercial ', industry)
		        END),
	facsubgrp = 
				(CASE
					WHEN industry = 'Scrap Metal Processor' THEN 'Solid Waste Processing'
					WHEN industry = 'Parking Lot' THEN 'Parking Lots and Garages'
					WHEN industry = 'Garage' THEN 'Parking Lots and Garages'
					WHEN industry = 'Garage and Parking Lot' THEN 'Parking Lots and Garages'
					WHEN industry = 'Tow Truck Company' THEN 'Parking Lots and Garages'
				END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = initcap(business_name),
	opabbrev = 'Non-public',
	optype = 'Non-public',
	overagency = 'NYC Department of Consumer Affairs',
	overabbrev = 'NYCDCA', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;

DELETE FROM dca_operatingbusinesses
WHERE license_expiration_date::date < current_date;
