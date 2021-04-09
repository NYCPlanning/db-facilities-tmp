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
    geo_1b::json->'inputs'->>'input_borough' as boro,
    geo_1b::json->'result'->>'geo_borough_code' as borocode,
    bin,
    (CASE
        WHEN geo_1b::json->'result'->>'geo_bbl' = '' AND bbl ~ '\y(\d{10})\y' THEN bbl
        ELSE geo_1b::json->'result'->>'geo_bbl'
    END) as bbl,
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
