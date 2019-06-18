-- assign the domain and group
UPDATE facilities a
SET facdomain = b.facdomain,
	facgroup = b.facgroup
FROM facilities_classification b
WHERE a.facsubgrp = b.facsubgrp;

-- DROP TABLE facdbclassification;