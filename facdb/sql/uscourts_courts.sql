DROP TABLE IF EXISTS _uscourts_courts;
SELECT
    uid,
    source,
    buildingname as facname,
    parsed_hnum as addressnum,
    parsed_sname as streetname,
    buildingaddress as address,
    buildingcity,
    zipcode,
    NULL as boro,
    NULL as borocode,
    NULL as bin,
    NULL as bbl,
    courttype as factype,
    (CASE
		WHEN upper(courttype) LIKE '%COURT%' THEN 'Courthouses and Judicial'
		ELSE 'Legal and Intervention Services'
	END) as facsubgrp,
    officename as opname,
    'NYCSBS' as opabbrev,
    'NYCSBS' as overabbrev,
    NULL as capacity,
    NULL as captype,
    NULL as proptype,
    wkt::geometry as wkb_geometry,
    geo_1b,
    NULL geo_bl,
    NULL geo_bn
INTO _uscourts_courts
FROM uscourts_courts;

CALL append_to_facdb_base('_uscourts_courts');
