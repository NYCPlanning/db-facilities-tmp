-- drop views if they already exist
DROP VIEW IF EXISTS qc_operator;
DROP VIEW IF EXISTS qc_oversight;
DROP VIEW IF EXISTS qc_classification;
DROP VIEW IF EXISTS qc_captype;
DROP VIEW IF EXISTS qc_capvalues;
DROP VIEW IF EXISTS qc_proptype;
DROP VIEW IF EXISTS qc_mapped;

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
CREATE VIEW qc_mapped AS (
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