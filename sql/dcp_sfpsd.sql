-- select w.status::text, count(*) 
-- from (select geo::json->'status' as status from dcp_sfpsd) w
-- group by w.status::text;

ALTER TABLE dcp_sfpsd
	ADD hash text,
	ADD servarea text;
	
update dcp_sfpsd as t
SET hash =  md5(CAST((t.*)AS text)),
	geo_house_number = (CASE WHEN geo_house_number='' THEN hnum ELSE geo_house_number END),
	geo_street_name = (CASE WHEN geo_street_name='' THEN sname ELSE geo_street_name END),
	geo_borough_code = (CASE WHEN geo_borough_code='' THEN borocode ELSE geo_borough_code END),
	geo_longitude = (CASE WHEN geo_longitude='' THEN longitude ELSE geo_longitude END),
	geo_latitude = (CASE WHEN geo_latitude='' THEN latitude ELSE geo_latitude END),
	geo_bin = (CASE WHEN geo_bin='' THEN bin ELSE geo_bin END),
	geo_city = (CASE WHEN geo_city='' THEN city ELSE geo_city END),
	wkb_geometry = (CASE
                        WHEN wkb_geometry IS NULL
                            THEN ST_SetSRID(point_location::geometry, 4326)
                        ELSE wkb_geometry
                    END),
	servarea=NULL
;