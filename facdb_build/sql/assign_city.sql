/** Update the city if it's NULL based on the Zipcode**/
UPDATE facilities f
SET city = (CASE
                WHEN f.city IS NULL THEN UPPER(l.city)
                ELSE f.city
            END)
FROM zipcode_city_lookup l
WHERE f.zipcode = l.zipcode;