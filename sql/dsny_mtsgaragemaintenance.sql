--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dsny_mtsgaragemaintenance) w
--group by w.status::text;

ALTER TABLE dsny_mtsgaragemaintenance
	ADD hash text, 
	ADD	facname text,
	ADD	factype text,
	ADD	facsubgrp text,
	ADD	facgroup text,
	ADD	facdomain text, 
	ADD	servarea text,
	ADD	opname text,
	ADD	opabbrev text,
	ADD	optype text,
	ADD	overagency text,
	ADD	overabbrev text,
	ADD	overlevel text,
	ADD	capacity text,
	ADD	captype text,
	ADD	proptype text;

update dsny_mtsgaragemaintenance as t
SET hash =  md5(CAST((t.*)AS text)), 
    the_geom = (CASE
                    WHEN the_geom = ''
                        THEN location
                    ELSE the_geom
                END),
	facname = (CASE
                    WHEN type = 'GARAGE' THEN CONCAT(name,' ',type)
                    WHEN type <> 'GARAGE' THEN CONCAT(name)
		        END),
	factype = (CASE
                    WHEN type = 'MTS' THEN 'DSNY Marine Transfer Station'
                    WHEN type = 'Garage' THEN 'DSNY Garage'
                    WHEN type = 'Repair' THEN 'DSNY Repair Facility'
                    WHEN type = 'Drop Off' THEN 'DSNY Drop-Off Facility'
		        END),
	facsubgrp = 'Solid Waste Transfer and Carting',
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = 'NYC Department of Sanitation',
	opabbrev = 'NYCDSNY',
	optype = 'Public',
	overagency = 'NYC Department of Sanitation',
	overabbrev = 'NYCDSNY', 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;