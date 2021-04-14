SELECT * FROM dcp_sfpsd;

SELECT
    uid,
    source,
    NULL as facname,
    addressnum,
    streetname,
    address,
    city,
    SPLIT_PART(zipcode,'.',1) as zipcode,
    boro,
    SPLIT_PART(borocode,'.',1) as borocode,
    bin,
    bbl,
    factype,
    facsubgrp,
    opname,
    opabbrev,
    overabbrev,
    NULL as capacity,
    NULL as captype,
    NULL as proptype,
    the_geom::geometry as wkb_geometry,
    geo_1b,
    geo_bl,
    geo_bn
INTO _dcp_sfpsd
FROM dcp_sfpsd;
