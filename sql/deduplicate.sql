
-- deduplicate based on facname,address,factype,overagency,geom
DROP TABLE IF EXISTS facilities_tmp;
SELECT DISTINCT ON (facname,address,factype,overagency,geom) * 
INTO facilities_tmp
FROM facilities
;

DROP TABLE IF EXISTS facilities_wo_dedupe;
ALTER TABLE IF EXISTS facilities RENAME TO facilities_wo_dedupe;

SELECT * INTO facilities
FROM facilities_tmp
;
