UPDATE facilities
SET overlevel = 
(CASE 
	WHEN overabbrev LIKE 'NYS%' THEN 'State'
	WHEN overabbrev LIKE 'MTA%' THEN 'State'
	WHEN overabbrev LIKE 'PANYNJ%' THEN 'State'
	WHEN overabbrev LIKE 'NYCOURTS%' THEN 'State'
	WHEN overabbrev LIKE 'US%' THEN 'Federal'
	WHEN overabbrev LIKE 'FBOP' THEN 'Federal'
	WHEN overabbrev = 'Non-public' THEN NULL
	WHEN overabbrev = 'HYDC' THEN NULL
	ELSE 'City'
END);
