SELECT * FROM dcla_culturalinstitutions;

SELECT
    uid,
    source,
    initcap(organization_name) as facname,
    parsed_hnum as addressnum,
    parsed_sname as streetname,
    cleaned_address as address,
    city,
    zipcode,
    borough as boro,
    NULL as borocode,
    bin,
    bbl,
    (CASE
        WHEN discipline IS NOT NULL THEN discipline
        ELSE 'Unspecified Discipline'
    END) as factype,
    (CASE
        WHEN discipline LIKE '%Museum%' THEN 'Museums'
        ELSE 'Other Cultural Institutions'
    END) as facsubgrp,
    organization_name as opname,
    'Non-public' as opabbrev,
    'NYCDCLA' as overabbrev,
    NULL as capacity,
    NULL as captype,
    NULL as proptype,
    wkt::geometry as wkb_geometry,
    geo_1b,
    NULL as geo_bl,
    NULL as geo_bn
INTO _dcla_culturalinstitutions
FROM dcla_culturalinstitutions;
