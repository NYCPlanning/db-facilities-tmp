--select w.status::text, count(*) 
--from (select geo::json->'status' as status from dcas_colp) w
--group by w.status::text;
CREATE TABLE dcas_colp_tmp as
SELECT * FROM dcas_colp
WHERE usedec ~* 'maintenance|storage|Infrastructure|Office|residential|no use';

DROP TABLE dcas_colp;

ALTER TABLE dcas_colp_tmp
RENAME TO dcas_colp;
  
ALTER TABLE dcas_colp
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

UPDATE dcas_colp as t
SET hash =  md5(CAST((t.*)AS text)), 
	facname = (CASE
				WHEN (name = ' ' OR name IS NULL) AND usedec LIKE '%OFFICE%' THEN 'Office'
				WHEN (name = ' ' OR name IS NULL) AND usedec LIKE '%NO USE%' THEN 'City Owned Property'
				WHEN name <> ' ' AND name IS NOT NULL THEN initcap(name)
				ELSE initcap(REPLACE(usedec, 'OTHER ', ''))
			END),
	factype = initcap(REPLACE(usedec, 'OTHER ', '')),
	facsubgrp = (CASE

			-- Admin of Gov

			WHEN usedec LIKE '%AGREEMENT%'

				OR usedec LIKE '%DISPOSITION%'

				OR usedec LIKE '%COMMITMENT%'

				OR agency LIKE '%PRIVATE%'

				THEN 'Properties Leased or Licensed to Non-public Entities'

			WHEN usedec LIKE '%SECURITY%' THEN 'Miscellaneous Use'

			WHEN (usedec LIKE '%PARKING%'

				OR usedec LIKE '%PKNG%')

				AND usedec NOT LIKE '%MUNICIPAL%'

				THEN 'City Agency Parking'

			WHEN usedec LIKE '%STORAGE%' OR usedec LIKE '%STRG%' THEN 'Storage'

			WHEN usedec LIKE '%CUSTODIAL%' THEN 'Custodial'

			WHEN usedec LIKE '%GARAGE%' THEN 'Maintenance and Garages'

			WHEN usedec LIKE '%OFFICE%' THEN 'City Government Offices'

			WHEN usedec LIKE '%MAINTENANCE%' THEN 'Maintenance and Garages'

			WHEN usedec LIKE '%NO USE%' THEN 'Miscellaneous Use'

			WHEN usedec LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'

			WHEN usedec LIKE '%OTHER HEALTH%' AND name LIKE '%ANIMAL%' THEN 'Miscellaneous Use'

			WHEN agency LIKE '%DCA%' and usedec LIKE '%OTHER%' THEN 'Miscellaneous Use'

			WHEN usedec LIKE '%UNDEVELOPED%' THEN 'Miscellaneous Use'

			WHEN (usedec LIKE '%TRAINING%' 

				OR usedec LIKE '%TESTING%')

				AND usedec NOT LIKE '%LABORATORY%'

				THEN 'Training and Testing'



			-- Trans and Infra

			WHEN usedec LIKE '%MUNICIPAL PARKING%' THEN 'Parking Lots and Garages'

			WHEN usedec LIKE '%MARKET%' THEN 'Wholesale Markets'

			WHEN usedec LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies'

			WHEN usedec LIKE '%ASPHALT%' THEN 'Material Supplies'

			WHEN usedec LIKE '%AIRPORT%' THEN 'Airports and Heliports'

			WHEN usedec LIKE '%ROAD/HIGHWAY%'

				OR usedec LIKE '%TRANSIT WAY%'

				OR usedec LIKE '%OTHER TRANSPORTATION%'

				THEN 'Other Transportation'

			WHEN agency LIKE '%DEP%'

				AND (usedec LIKE '%WATER SUPPLY%'

				OR usedec LIKE '%RESERVOIR%'

				OR usedec LIKE '%AQUEDUCT%')

				THEN 'Water Supply'

			WHEN agency LIKE '%DEP%'

				AND usedec NOT LIKE '%NATURE AREA%'

				AND usedec NOT LIKE '%NATURAL AREA%'

				AND usedec NOT LIKE '%OPEN SPACE%'

				THEN 'Wastewater and Pollution Control'

			WHEN usedec LIKE '%WASTEWATER%' THEN 'Wastewater and Pollution Control'

			WHEN usedec LIKE '%LANDFILL%' 

				OR usedec LIKE '%SOLID WASTE INCINERATOR%'

				THEN 'Solid Waste Processing'

			WHEN usedec LIKE '%SOLID WASTE TRANSFER%'

				OR (agency LIKE '%SANIT%' AND usedec LIKE '%SANITATION SECTION%')

				THEN 'Solid Waste Transfer and Carting'

			WHEN usedec LIKE '%ANTENNA%' OR usedec LIKE '%TELE/COMP%' THEN 'Telecommunications'

			WHEN usedec LIKE '%PIER - MARITIME%'

				OR usedec LIKE '%FERRY%' 

				OR usedec LIKE '%WATERFRONT TRANSPORTATION%'

				OR usedec LIKE '%MARINA%'

				THEN 'Ports and Ferry Landings'

			WHEN usedec LIKE '%RAIL%'

				OR (usedec LIKE '%TRANSIT%'

					AND usedec NOT LIKE '%TRANSITIONAL%')

				THEN 'Rail Yards and Maintenance'

			WHEN usedec LIKE '%BUS%' THEN 'Bus Depots and Terminals'



			-- Health and Human

			WHEN agency LIKE '%HHC%' THEN 'Hospitals and Clinics'

			WHEN usedec LIKE '%HOSPITAL%' THEN 'Hospitals and Clinics'

			WHEN usedec LIKE '%AMBULATORY HEALTH%' THEN 'Hospitals and Clinics'

			WHEN agency LIKE '%OCME%' THEN 'Other Health Care'

			WHEN agency LIKE '%ACS%' AND usedec LIKE '%HOUSING%' THEN 'Shelters and Transitional Housing'

			WHEN agency LIKE '%AGING%' THEN 'Senior Services'

			WHEN (agency LIKE '%DHS%' OR agency LIKE '%HRA%')

				AND (usedec LIKE '%RESIDENTIAL%'

				OR usedec LIKE '%TRANSITIONAL HOUSING%')

				THEN 'Shelters and Transitional Housing'

			WHEN agency LIKE '%DHS%' AND usedec NOT LIKE '%OPEN SPACE%' THEN 'Non-residential Housing and Homeless Services'

			WHEN (agency LIKE '%NYCHA%' 

				OR agency LIKE '%HPD%')

				AND usedec LIKE '%RESIDENTIAL%'

				THEN 'Public or Affordable Housing'

			WHEN usedec LIKE '%COMMUNITY CENTER%' OR (agency LIKE '%HRA%' AND name LIKE '%CENTER%') 

				THEN 'Community Centers and Community School Programs'



			-- Parks, Cultural

			WHEN usedec LIKE '%LIBRARY%' THEN 'Public Libraries'

			WHEN usedec LIKE '%MUSEUM%' THEN 'Museums'

			WHEN usedec LIKE '%CULTURAL%' THEN 'Other Cultural Institutions'

			WHEN usedec LIKE '%ZOO%' THEN 'Other Cultural Institutions'

			WHEN usedec LIKE '%CEMETERY%' THEN 'Cemeteries'

			WHEN agency LIKE '%CULT%' AND usedec LIKE '%MUSEUM%' THEN 'Museums'

			WHEN agency LIKE '%CULT%' THEN 'Other Cultural Institutions'

			WHEN usedec LIKE '%NATURAL AREA%'

				OR (usedec LIKE '%OPEN SPACE%'

					AND agency LIKE '%DEP%')

				THEN 'Preserves and Conservation Areas'

			WHEN usedec LIKE '%BOTANICAL GARDENS%' THEN 'Other Cultural Institutions'

			WHEN usedec LIKE '%GARDEN%' THEN 'Gardens'

			WHEN agency LIKE '%PARKS%'

				AND usedec LIKE '%OPEN SPACE%'

				THEN 'Streetscapes, Plazas, and Malls'

			WHEN usedec = 'MALL/TRIANGLE/HIGHWAY STRIP/PARK STRIP'

				THEN 'Streetscapes, Plazas, and Malls'

			WHEN usedec LIKE '%PARK%' THEN 'Parks'

			WHEN usedec LIKE '%PLAZA%'

				OR usedec LIKE '%SITTING AREA%' 

				THEN 'Streetscapes, Plazas, and Malls'

			WHEN usedec LIKE '%PLAYGROUND%'

				OR usedec LIKE '%SPORTS%'

				OR usedec LIKE '%TENNIS COURT%'

				OR usedec LIKE '%PLAY AREA%'

				OR usedec LIKE '%RECREATION%'

				OR usedec LIKE '%BEACH%'

				OR usedec LIKE '%PLAYING FIELD%'

				OR usedec LIKE '%GOLF COURSE%'

				OR usedec LIKE '%POOL%'

				OR usedec LIKE '%STADIUM%'

				THEN 'Recreation and Waterfront Sites'

			WHEN usedec LIKE '%THEATER%' AND agency LIKE '%DSBS%'

				THEN 'Other Cultural Institutions'



			-- Public Safety, Justice etc

			WHEN agency LIKE '%ACS%' AND usedec LIKE '%DETENTION%' THEN 'Detention and Correctional'

			WHEN agency LIKE '%CORR%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'

			WHEN agency LIKE '%CORR%' THEN 'Detention and Correctional'

			WHEN agency LIKE '%COURT%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'

			WHEN usedec LIKE '%AMBULANCE%' THEN 'Other Emergency Services'

			WHEN usedec LIKE '%EMERGENCY MEDICAL%' THEN 'Other Emergency Services'

			WHEN usedec LIKE '%FIREHOUSE%' THEN 'Fire Services'

			WHEN usedec LIKE '%POLICE STATION%' THEN 'Police Services'

			WHEN usedec LIKE '%PUBLIC SAFETY%' THEN 'Other Public Safety'

			WHEN agency LIKE '%OCME%' THEN 'Forensics'



			-- Education, Children, Youth

			WHEN usedec LIKE '%UNIVERSITY%' THEN 'Colleges or Universities'

			WHEN usedec LIKE '%EARLY CHILDHOOD%' THEN 'Day Care'

			WHEN usedec LIKE '%DAY CARE%' THEN 'Day Care'

			WHEN agency LIKE '%ACS%' AND usedec LIKE '%RESIDENTIAL%' THEN 'Foster Care Services and Residential Care'

			WHEN agency LIKE '%ACS%' THEN 'Day Care'

			WHEN agency LIKE '%EDUC%' and usedec LIKE '%PLAY AREA%' THEN 'Public K-12 Schools'

			WHEN usedec LIKE '%HIGH SCHOOL%' THEN 'Public K-12 Schools'

			WHEN agency LIKE '%CUNY%' AND usedec NOT LIKE '%OPEN SPACE%' THEN 'Colleges or Universities'

			WHEN AGENCY LIKE '%EDUC%' AND usedec LIKE '%SCHOOL%' THEN 'Public K-12 Schools'

			WHEN usedec LIKE '%EDUCATIONAL SKILLS%' THEN 'Public K-12 Schools'



			ELSE 'Miscellaneous Use'

		END),
	facgroup = NULL,
	facdomain = NULL,
	servarea = NULL,
	opname = NULL,
	opabbrev = NULL,
	optype = NULL,
	overagency = NULL,
	overabbrev = NULL, 
	overlevel = NULL, 
	capacity = NULL, 
	captype = NULL, 
	proptype = NULL
;



select distinct(usedec) from dcas_colp
where usedec ~* 'maintenance|storage|Infrastructure|Office|residential|no use';