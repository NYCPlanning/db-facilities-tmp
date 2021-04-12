SELECT
    uid,
    source,
    (CASE
        WHEN building_name IS NOT NULL AND building_name <> '' THEN building_name
        ELSE building_address_with_zip_code
    END) as facname,
    address_number as addressnum,
    street_name as streetname,
    (CASE
        WHEN geo_1b::json->'result'->>'geo_street_name' IS NOT NULL
        AND geo_1b::json->'result'->>'geo_house_number' IS NOT NULL
            THEN (geo_1b::json->'result'->>'geo_house_number')||' '||(geo_1b::json->'result'->>'geo_street_name')
        ELSE address_number||' '||street_name
    END) as address,
    NULL as city,
    zip_code as zipcode,
    borough_name as boro,
    borough_code as borocode,
    bin,
    bbl,
    'Privately Owned Public Space' as factype,
    'Privately Owned Public Space' as facsubgrp,
    'Not Available' as opname,
    'Non-public' as opabbrev,
    'NYCDCP' as overabbrev,
    NULL as capacity,
    NULL as captype,
    NULL as proptype,
    (CASE
        WHEN location is NULL
        THEN ST_TRANSFORM(ST_SetSRID(ST_Point(
                xcoordinate::DOUBLE PRECISION,
                ycoordinate::DOUBLE PRECISION),
                2263), 4326)
        ELSE ST_SetSRID(location::geometry, 4326)
    END) as wkb_geometry,
    geo_1b,
    geo_bl,
    geo_bn
INTO _dcp_pops
FROM dcp_pops;
