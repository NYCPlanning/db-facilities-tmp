DROP PROCEDURE IF EXISTS append_to_facdb_base;
CREATE OR REPLACE PROCEDURE append_to_facdb_base (
    _table text
) AS $BODY$
DECLARE
    source text;
BEGIN
    EXECUTE format($n$
        SELECT source FROM %1$I;
    $n$, _table) INTO source;

	EXECUTE format($n$
        DELETE FROM facdb_base
        WHERE source = %1$L;
    $n$, source);

    EXECUTE format($n$
        INSERT INTO facdb_base
        SELECT uid::text,
            source::text,
            facname::text,
            addressnum::text,
            streetname::text,
            address::text,
            city::text,
            zipcode::text,
            boro::text,
            borocode::text,
            bin::text,
            bbl::text,
            factype::text,
            facsubgrp::text,
            opname::text,
            opabbrev::text,
            overabbrev::text,
            capacity::text,
            captype::text,
            proptype::text,
            wkb_geometry::geometry,
            geo_1b::json,
            geo_bl::json,
            geo_bn::json
        FROM %1$I; $n$, _table);
END
$BODY$
LANGUAGE plpgsql;
