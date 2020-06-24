UPDATE facilities
SET address = UPPER(address);

UPDATE facilities
SET address = trim(regexp_replace(address, E'[ tnr]+', ' ', 'g')),
	streetname = trim(regexp_replace(streetname, E'[ tnr]+', ' ', 'g'))
;

UPDATE facilities a
SET addressnum = NULL,
    streetname = NULL
FROM facilities b
WHERE (b.address ~* ' at 'OR b.address LIKE '%@%'
OR b.address ~* ' and ' OR b.address LIKE '%&%')
AND (b.addressnum IS NOT NULL
OR b.streetname IS NOT NULL)
AND a.uid = b.uid
;