-- drop views if they already exist
DROP VIEW IF EXISTS qc_operator;
DROP VIEW IF EXISTS qc_oversight;
DROP VIEW IF EXISTS qc_classification;
DROP VIEW IF EXISTS qc_captype;
DROP VIEW IF EXISTS qc_capvalues;
DROP VIEW IF EXISTS qc_proptype;
DROP VIEW IF EXISTS qc_mapped;
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
CREATE VIEW qc_mapped_datasource AS(
with geom_new as (
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
	ORDER BY percentwithgeom),
	geom_old as (
		SELECT a.datasource, 
	COUNT(*) as total,
	b.countwithgeom,
	COUNT(*) - b.countwithgeom as countwithoutgeom,
	round(((b.countwithgeom::double precision/COUNT(*)::double precision)*100)::numeric, 2) as percentwithgeom
	FROM dcp_facilities a
	JOIN (SELECT datasource, COUNT(*) as countwithgeom
	FROM dcp_facilities
	WHERE geom IS NOT NULL
	GROUP BY datasource) b
	ON a.datasource=b.datasource
	GROUP BY a.datasource, b.countwithgeom
	ORDER BY percentwithgeom)
	select a.datasource, 
		a.total as total_new,
		b.total as total_old, 
		a.countwithgeom as wgeom_new,
		b.countwithgeom as wgeom_old,
		a.countwithoutgeom as wogeom_new,
		b.countwithoutgeom as wogeom_old,
		a.percentwithgeom as pctgeom_new, 
		b.percentwithgeom as pctgeom_old
	FROM geom_new a
	join geom_old b
	on (a.datasource=b.datasource)
	order by a.percentwithgeom);

CREATE VIEW qc_mapped AS (
	with geom_new as (
		SELECT facdomain, facgroup, facsubgrp, factype, datasource, 
		count(*) as count_new, 
		sum((case when geom is null then 1 else 0 end)) as wogeom_new
		from facilities 
		group by facdomain, facgroup, facsubgrp, factype, datasource), 
	geom_old as (
		SELECT facdomain, facgroup, facsubgrp, factype, datasource, 
		count(*) as count_old, 
		sum((case when geom is null then 1 else 0 end)) as wogeom_old
		from dcp_facilities 
		group by facdomain, facgroup, facsubgrp, factype, datasource)
	select a.facdomain, a.facgroup, a.facsubgrp,
		a.factype, a.datasource, a.count_new, b.count_old,
		a.wogeom_new, b.wogeom_old
	from geom_new a
	join geom_old b
	on (a.facdomain = b.facdomain
		AND a.facgroup = b.facgroup 
		AND a.facsubgrp = b.facsubgrp
		AND a.factype = b.factype
		AND a.datasource = b.datasource)
);

-- report the number of records with geoms by domain, group and subgroup
CREATE VIEW qc_mapped_subgroup AS (
WITH geom_new as(
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
	ORDER BY percentwithgeom),
	geom_old as (
		SELECT a.facdomain, a.facgroup, a.facsubgrp,
		COUNT(*) as total,
		b.countwithgeom,
		COUNT(*) - b.countwithgeom as countwithoutgeom,
		CAST((b.countwithgeom/COUNT(*)::double precision)*100 AS DECIMAL(18,2)) as percentwithgeom
	FROM dcp_facilities a
	JOIN
	(SELECT facdomain, facgroup, facsubgrp, COUNT(*) as countwithgeom
	FROM dcp_facilities
	WHERE geom IS NOT NULL
	GROUP BY facdomain, facgroup, facsubgrp) b
	ON a.facdomain=b.facdomain
	AND a.facgroup=b.facgroup
	AND a.facsubgrp=b.facsubgrp
	GROUP BY a.facdomain, a.facgroup, a.facsubgrp, b.countwithgeom
	ORDER BY percentwithgeom)
	select a.facdomain, a.facgroup, a.facsubgrp, 
		a.total as total_new,
		b.total as total_old, 
		a.countwithgeom as wgeom_new,
		b.countwithgeom as wgeom_old,
		a.countwithoutgeom as wogeom_new,
		b.countwithoutgeom as wogeom_old,
		a.percentwithgeom as pctgeom_new, 
		b.percentwithgeom as pctgeom_old
	FROM geom_new a
	join geom_old b
	on (a.facdomain=b.facdomain
		AND a.facgroup=b.facgroup
		AND a.facsubgrp=b.facsubgrp)
	order by a.percentwithgeom)
;
-- report Change in distribution of number of records by fac subgroup / group / domain between current and previous version
CREATE VIEW qc_diff AS (
	select 
	coalesce(a.facdomain, b.facdomain) as facdomain, 
	coalesce(a.facgroup, b.facgroup) as facgroup,
	coalesce(a.facsubgrp, b.facsubgrp) as facsubgrp,
	coalesce(a.factype, b.factype) as factype,
	coalesce(a.datasource, b.datasource) as datasource,
	coalesce(count_old, 0) as count_old, 
	coalesce(count_new, 0) as count_new, 
	coalesce(count_new, 0) - coalesce(count_old, 0) as diff from 
(select facdomain, facgroup, facsubgrp, factype, datasource, coalesce(count(*),0) as count_new
from facilities
group by facdomain, facgroup, facsubgrp, factype, datasource) a
FULL JOIN
(select facdomain, facgroup, facsubgrp, factype, datasource, coalesce(count(*),0) as count_old
from dcp_facilities
group by facdomain, facgroup, facsubgrp, factype, datasource) b
ON a.facdomain = b.facdomain 
	and a.facgroup = b.facgroup
	and a.facsubgrp = b.facsubgrp 
	and a.factype = b.factype
	and a.datasource = b.datasource
order by facdomain, facgroup, facsubgrp, factype
);