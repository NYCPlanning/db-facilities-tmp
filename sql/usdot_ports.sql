
--select w.status::text, count(*) 
--from (select geo::json->'status' as status from usdot_ports) w
--group by w.status::text;
CREATE TABLE usdot_ports_tmp AS (
SELECT * FROM usdot_ports
WHERE nav_unit_n ~* '^port|terminal|ferry');

DROP TABLE usdot_ports;

ALTER TABLE usdot_ports_tmp
RENAME TO usdot_ports;

ALTER TABLE usdot_ports
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
	ADD proptype text; 
	
update usdot_ports as t
SET hash =  md5(CAST((t.*)AS text)), 
	wkb_geometry = (CASE
				        WHEN wkb_geometry is NULL 
				        THEN ST_GeometryFromText(point_location, 4326)
				        ELSE wkb_geometry
					END),
	address = (CASE 
                        WHEN the_geom is not NULL 
                            THEN geo_house_number || ' ' || geo_street_name
                        ELSE address             
                    END),
	facname = initcap(nav_unit_n),
	factype = (CASE
					WHEN nav_unit_n ~* 'Ferry' THEN 'Ferry Landing'
					WHEN nav_unit_n ~* 'Cruise' THEN 'Cruise Terminal'
					ELSE 'Port or Marine Terminal'
				END),
	facsubgrp = 'Ports and Ferry Landings',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = (CASE

				WHEN operators like '%Sanitation%' THEN 'NYC Department of Sanitation'
		
				WHEN operators like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		
				WHEN operators like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		
				WHEN operators like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		
				WHEN operators like '%Department of Interior%' THEN 'US Department of Interior'
		
				WHEN operators like '%Police%' THEN 'NYC Police Department'
		
				WHEN operators like '%Fire Department%' THEN 'NYC Fire Department'
		
				WHEN operators like '%Corrections%' THEN 'NYC Department of Correction'
		
				WHEN operators like '%State University%' THEN 'State University of New York'
		
				WHEN operators like '%Coast Guard%' THEN 'US Coast Guard'
		
				WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'Port Authority of New York and New Jersey'
		
				WHEN operators IS NULL AND owners like '%Parks%' THEN 'NYC Department of Parks and Recreation'
		
				WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		
				WHEN operators IS NULL AND owners like '%Department of Sanitation%' THEN 'NYC Department of Sanitation'
		
				WHEN operators IS NULL AND owners like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		
				WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'NYC Department of Port and Terminals'
		
				WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'US Department of Interior'
		
				WHEN operators IS NULL AND owners like '%Police%' THEN 'NYC Police Department'
		
				WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'NYC Fire Department'
		
				WHEN operators IS NULL AND owners like '%Corrections%' THEN 'NYC Department of Correction'
		
				WHEN operators IS NULL AND owners like '%State University%' THEN 'State University of New York'
		
				WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'US Coast Guard'
		
				ELSE 'Non-public'
		
			END),
	opabbrev = (CASE

				WHEN operators like '%Sanitation%' THEN 'NYCDSNY'
		
				WHEN operators like '%Department of Environmental Protection%' THEN 'NYCDEP'
		
				WHEN operators like '%Department of Transportation%' THEN 'NYCDOT'
		
				WHEN operators like '%Department of Ports and Terminals%' THEN 'NYCDPT'
		
				WHEN operators like '%Department of Interior%' THEN 'USDOI'
		
				WHEN operators like '%Police%' THEN 'NYCNYPD'
		
				WHEN operators like '%Fire Department%' THEN 'NYCFDNY'
		
				WHEN operators like '%Corrections%' THEN 'NYCDOC'
		
				WHEN operators like '%State University%' THEN 'SUNY'
		
				WHEN operators like '%Coast Guard%' THEN 'USCG'
		
				WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'PANYNJ'
		
				WHEN operators IS NULL AND owners like '%Economic Development%' THEN 'NYCEDC'
		
				WHEN operators IS NULL AND owners like '%Parks%' THEN 'NYCDPR'
		
				WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'NYCDEP'
		
				WHEN operators IS NULL AND owners like '%Sanitation%' THEN 'NYCDSNY'
		
				WHEN operators IS NULL AND owners like '%Transportation%' THEN 'NYCDOT'
		
				WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'NYCDPT'
		
				WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'USDOI'
		
				WHEN operators IS NULL AND owners like '%Police%' THEN 'NYCNYPD'
		
				WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'NYCFDNY'
		
				WHEN operators IS NULL AND owners like '%Corrections%' THEN 'NYCDOC'
		
				WHEN operators IS NULL AND owners like '%State University%' THEN 'SUNY'
		
				WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'USCG'
		
				ELSE 'Non-public'
		
			END),
	optype = (CASE
		
				WHEN operators like '%Sanitation%' THEN 'Public'
		
				WHEN operators like '%Department of Environmental Protection%' THEN 'Public'
		
				WHEN operators like '%Department of Transportation%' THEN 'Public'
		
				WHEN operators like '%Department of Ports and Terminals%' THEN 'Public'
		
				WHEN operators like '%Department of Interior%' THEN 'Public'
		
				WHEN operators like '%Police%' THEN 'Public'
		
				WHEN operators like '%Fire Department%' THEN 'Public'
		
				WHEN operators like '%Corrections%' THEN 'Public'
		
				WHEN operators like '%State University%' THEN 'Public'
		
				WHEN operators like '%Coast Guard%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Parks%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Department of Transportation%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Department of Sanitation%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Police%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Corrections%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%State University%' THEN 'Public'
		
				WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'Public'
		
				ELSE 'Non-public'
		
			END),
	overagency = (CASE
		
				WHEN owners like '%Port Authority%' THEN 'Port Authority of New York and New Jersey'
		
				WHEN owners like '%Economic Development%' THEN 'NYC Economic Development Corporation'
		
				WHEN owners like '%Parks%' THEN 'NYC Department of Parks and Recreation'
		
				WHEN owners like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		
				WHEN owners like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		
				WHEN owners like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		
				WHEN owners like '%Department of Interior%' THEN 'US Department of Interior'
		
				WHEN owners like '%Police%' THEN 'NYC Police Department'
		
				WHEN owners like '%Fire Department%' THEN 'NYC Fire Department'
		
				WHEN owners like '%Corrections%' THEN 'NYC Department of Correction'
		
				WHEN owners like '%State University%' THEN 'State University of New York'
		
				WHEN owners like '%Coast Guard%' THEN 'US Coast Guard'
		
				WHEN owners like '%United States%' THEN 'US Coast Guard'
		
				WHEN owners = 'Current Owner: City of New York.' THEN 'NYC Unknown'
		
				WHEN operators like '%Sanitation%' THEN 'NYC Department of Sanitation'
		
				WHEN operators like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		
				WHEN operators like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		
				WHEN operators like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		
				WHEN operators like '%Department of Interior%' THEN 'US Department of Interior'
		
				WHEN operators like '%Police%' THEN 'NYC Police Department'
		
				WHEN operators like '%Fire Department%' THEN 'NYC Fire Department'
		
				WHEN operators like '%Corrections%' THEN 'NYC Department of Correction'
		
				WHEN operators like '%State University%' THEN 'State University of New York'
		
				WHEN operators like '%Coast Guard%' THEN 'US Coast Guard'
		
				ELSE 'Non-public'
		
			END),
	overabbrev = (CASE

				WHEN owners like '%Port Authority%' THEN 'PANYNJ'
		
				WHEN owners like '%Economic Development%' THEN 'NYCEDC'
		
				WHEN owners like '%Parks%' THEN 'NYCDPR'
		
				WHEN owners like '%Department of Environmental Protection%' THEN 'NYCDEP'
		
				WHEN owners like '%Department of Transportation%' THEN 'NYCDOT'
		
				WHEN owners like '%Department of Port and Terminals%' THEN 'NYCDPT'
		
				WHEN owners like '%Department of Interior%' THEN 'USDOI'
		
				WHEN owners like '%Police%' THEN 'NYCNYPD'
		
				WHEN owners like '%Fire Department%' THEN 'NYCFDNY'
		
				WHEN owners like '%Corrections%' THEN 'NYCDOC'
		
				WHEN owners like '%State University%' THEN 'SUNY'
		
				WHEN owners like '%Coast Guard%' THEN 'USCG'
		
				WHEN owners like '%United States%' THEN 'USCG'
		
				WHEN owners = 'Current Owner: City of New York.' THEN 'NYC-Unknown'
		
				WHEN operators like '%Sanitation%' THEN 'NYCDSNY'
		
				WHEN operators like '%Department of Environmental Protection%' THEN 'NYCDEP'
		
				WHEN operators like '%Department of Sanitation%' THEN 'NYCDOT'
		
				WHEN operators like '%Department of Ports and Terminals%' THEN 'NYCDPT'
		
				WHEN operators like '%Department of Interior%' THEN 'USDOI'
		
				WHEN operators like '%Police%' THEN 'NYCNYPD'
		
				WHEN operators like '%Fire Department%' THEN 'NYCFDNY'
		
				WHEN operators like '%Corrections%' THEN 'NYCDOC'
		
				WHEN operators like '%State University%' THEN 'SUNY'
		
				WHEN operators like '%Coast Guard%' THEN 'USCG'
		
				ELSE 'Non-public'
		
			END), 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;