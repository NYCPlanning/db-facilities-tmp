UPDATE facilities f
SET zipcode = (CASE
                WHEN f.zipcode IS NULL THEN l.zipcode
                ELSE f.zipcode
            END)
FROM zipcode_city_lookup l
WHERE f.city= UPPER(l.city);