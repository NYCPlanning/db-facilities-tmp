DROP TABLE IF EXISTS _doe_busroutesgarages;
SELECT
    uid,
    source,
    initcap(vendor_name) as facname,
    parsed_hnum as addressnum,
    parsed_sname as streetname,
    garage__street_address as address,
    garage_city as city,
    garage_zip as zipcode,
    garage_city as boro,
    NULL as borocode,
    NULL as bin,
    NULL as bbl,
    'School Bus Depot' as factype,
    'Bus Depots and Terminals' as facsubgrp,
    initcap(vendor_name) as opname,
    'Non-public' as opabbrev,
    'NYCDOE' as overabbrev,
    NULL as capacity,
    'routes' as captype,
    NULL as proptype,
    wkt::geometry as wkb_geometry,
    geo_1b,
    NULL as geo_bl,
    NULL as geo_bn
INTO _doe_busroutesgarages
FROM doe_busroutesgarages;

CALL append_to_facdb_base('_doe_busroutesgarages');
