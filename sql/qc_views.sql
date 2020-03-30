-- drop views if they already exist
DROP VIEW IF EXISTS qc_operator;
DROP VIEW IF EXISTS qc_oversight;
DROP VIEW IF EXISTS qc_classification;
DROP VIEW IF EXISTS qc_captype;
DROP VIEW IF EXISTS qc_capvalues;
DROP VIEW IF EXISTS qc_proptype;
DROP VIEW IF EXISTS qc_mapped_datasource;
DROP VIEW IF EXISTS qc_mapped_subgroup;
DROP VIEW IF EXISTS qc_diff;

-- creating views for QC reports

-- QC consistency in operator information
CREATE VIEW qc_operator AS (
SELECT opabbrev, opname, optype, datasource, COUNT(*)
FROM facilities
GROUP BY opabbrev, opname, optype, datasource
ORDER BY opabbrev);
-- QC consistency in oversight information
CREATE VIEW qc_oversight AS (
SELECT overabbrev, overagency, overlevel, datasource, COUNT(*)
FROM facilities
GROUP BY overabbrev, overagency, overlevel, datasource
ORDER BY overabbrev);
-- QC consistency in grouping information
CREATE VIEW qc_classification AS (
SELECT facdomain, facgroup, facsubgrp, servarea, COUNT(*)
FROM facilities
GROUP BY facdomain, facgroup, facsubgrp, servarea
ORDER BY facdomain, facgroup, facsubgrp);
-- make sure capcaity types are consistent
CREATE VIEW qc_captype AS (
SELECT DISTINCT captype
FROM facilities);
CREATE VIEW qc_capvalues AS (
SELECT DISTINCT datasource 
FROM facilities
WHERE captype IS NULL 
AND capacity IS NOT NULL);
-- make sure property types are consistent
CREATE VIEW qc_proptype AS (
SELECT DISTINCT proptype
FROM facilities);
-- report the number of records with geoms by data source
CREATE VIEW qc_mapped_datasource AS (
SELECT a.datasource, 
	COUNT(*) as total,
	b.countwithgeom,
	COUNT(*) - b.countwithgeom as countwithoutgeom,
	round(((b.countwithgeom::double precision/COUNT(*)::double precision)*100)::numeric, 2) as percentwithgeom
FROM facilities a
JOIN (SELECT datasource, COUNT(*) as countwithgeom
FROM facilities
WHERE geom IS NOT NULL
GROUP BY datasource) b
ON a.datasource=b.datasource
GROUP BY a.datasource, b.countwithgeom
ORDER BY percentwithgeom);
-- report the number of records with geoms by domain, group and subgroup
CREATE VIEW qc_mapped_subgroup AS (
SELECT a.facdomain, a.facgroup, a.facsubgrp,
    COUNT(*) as total,
    b.countwithgeom,
    COUNT(*) - b.countwithgeom as countwithoutgeom,
    CAST((b.countwithgeom/COUNT(*)::double precision)*100 AS DECIMAL(18,2)) as percentwithgeom
FROM facilities a
JOIN
(SELECT facdomain, facgroup, facsubgrp, COUNT(*) as countwithgeom
FROM facilities
WHERE geom IS NOT NULL
GROUP BY facdomain, facgroup, facsubgrp) b
ON a.facdomain=b.facdomain
AND a.facgroup=b.facgroup
AND a.facsubgrp=b.facsubgrp
GROUP BY a.facdomain, a.facgroup, a.facsubgrp, b.countwithgeom
ORDER BY percentwithgeom)
;
-- report Change in distribution of number of records by fac subgroup / group / domain between current and previous version
CREATE FUNCTION array_distinct(anyarray) RETURNS anyarray AS $f$
  SELECT array_agg(DISTINCT x) FROM unnest($1) t(x);
$f$ LANGUAGE SQL IMMUTABLE;

CREATE VIEW qc_diff AS (
select ARRAY_TO_STRING(array_distinct(ARRAY[a.facdomain, b.facdomain]), '') as facdomain, 
		ARRAY_TO_STRING(array_distinct(ARRAY[a.facgroup, b.facgroup]), '') as facgroup, 
		ARRAY_TO_STRING(array_distinct(ARRAY[a.facsubgrp, b.facsubgrp]), '') as facsubgrp,
		ARRAY_TO_STRING(array_distinct(ARRAY[a.factype, b.factype]), '') as factype,
		ARRAY_TO_STRING(array_distinct(ARRAY[string_to_array(a.datasource, ';') || string_to_array(b.datasource, ';')]), ', ') as datasource,
			count_old, count_new,
		count_new-count_old as diff from 
(select facdomain, facgroup, facsubgrp, factype, ARRAY_TO_STRING(array_agg(DISTINCT datasource), ';') as datasource, coalesce(count(*),0) as count_new
from facilities
group by facdomain, facgroup, facsubgrp, factype) a
FULL JOIN 
(select facdomain, facgroup, facsubgrp, factype, ARRAY_TO_STRING(array_agg(DISTINCT datasource), ';') as datasource, coalesce(count(*),0) as count_old
from dcp_facilities
group by facdomain, facgroup, facsubgrp, factype) b
ON a.facdomain = b.facdomain and a.facgroup = b.facgroup and a.facsubgrp = b.facsubgrp and a.factype = b.factype
order by facdomain, facgroup, facsubgrp, factype);