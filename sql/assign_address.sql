UPDATE facilities
SET address = UPPER(address);

UPDATE facilities
SET address = trim(regexp_replace(address, E'[ tnr]+', ' ', 'g')),
	streetname = trim(regexp_replace(streetname, E'[ tnr]+', ' ', 'g'))
;