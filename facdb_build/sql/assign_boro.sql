UPDATE facilities
SET boro = (CASE 
                WHEN borocode = '1' THEN 'Manhattan'
                WHEN borocode = '2' THEN 'Bronx'
                WHEN borocode = '3' THEN 'Brooklyn'
                WHEN borocode = '4' THEN 'Queens'
                WHEN borocode = '5' THEN 'Staten Island'
            END);