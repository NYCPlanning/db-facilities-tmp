-- Use DOE or ACS as the primary source and drop duplicate (same bin with similar name) DOHMH record

-- REMOVE daycare center duplicates from DOHMH based on acs_daycareheadstart
WITH flag AS(
    WITH match AS(
        SELECT TRIM(
            REPLACE(
            REPLACE(
            UPPER(a.program_name),'-',' '),'  ', '')
            ) AS acs_name, 
            TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(d.legal_name),'INC', ''),'LLC', ''),',',''),'.',''),'-',' '),'THE',''),'  ', '')
            ) AS dohmh_name, 
            d.day_care_id
        FROM acs_daycareheadstart a, dohmh_daycare d
        WHERE a.geo_bin = d.geo_bin
        AND a.geo_bin != ''
                )
    SELECT day_care_id, string_to_array(acs_name, ' ')&&string_to_array(dohmh_name, ' ') AS similarity_flag
    FROM match
    )
DELETE FROM dohmh_daycare
WHERE day_care_id IN(
SELECT day_care_id 
FROM flag
WHERE similarity_flag = True
);

-- REMOVE PREK duplicates from DOHMH based on doe_universalprek
WITH flag AS(
    WITH match AS(
        SELECT TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(a.name),'SCHOOL',' '),'INC',' '),'LLC',' '),'THE',' '),'-',' '),',',' '),'.',' '),'  ', '')
            ) AS doe_name, 
            TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            UPPER(d.legal_name),'INC', ''),'LLC', ''),',',''),'.',' '),'-',' '),'THE',''),'  ', '')
            ) AS dohmh_name, 
            d.day_care_id
        FROM doe_universalprek a, dohmh_daycare d
        WHERE a.geo_bin = d.geo_bin
        AND a.geo_bin != ''
                )
    SELECT day_care_id,string_to_array(doe_name, ' ')&&string_to_array(dohmh_name, ' ') AS similarity_flag
    FROM match
    )
DELETE FROM dohmh_daycare
WHERE day_care_id IN(
SELECT day_care_id 
FROM flag
WHERE similarity_flag = True
);


