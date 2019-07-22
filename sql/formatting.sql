-- remove po boxes
DELETE from facilities 
where address ~* 'PO BOX|P.O. BOX|P. O. BOX|P.O.BOX|P.O BOX';

-- convert facname to all caps
UPDATE facilities a
SET facname = UPPER(facname);

-- remove community board offices from dcp_sfpsd
DELETE from facilities
WHERE datasource = 'dcp_sfpsd' and facname ~* 'COMM BD';