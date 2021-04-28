DROP TABLE IF EXISTS _nysparks_parks;

SELECT
    uid,
    source,
    name as facname,
    NULL as addressnum,
    NULL as streetname,
    NULL as address,
    NULL as city,
    NULL as zipcode,
    county as boro,
    NULL as borocode,
    NULL as bin,
    NULL as bbl,
    'Park' as factype,
    'Parks' as facsubgrp,
    'NYC Department of Parks and Recreation' as opname,
    'DPR' as opabbrev,
    'DPR' as overabbrev,
    NULL as capacity,
    NULL as captype,
    NULL as proptype,
    ST_POINT(longitude::double precision, latitude::double precision) as wkb_geometry,
    NULL geo_1b,
    NULL as geo_bl,
    NULL as geo_bn
INTO _nysparks_parks
FROM nysparks_parks;

CALL append_to_facdb_base('_nysparks_parks');
