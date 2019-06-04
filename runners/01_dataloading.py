import os

recipes = ['dcp_pops', 'nypl_libraries', 'dohmh_daycare', 'doitt_libraries', 
'qpl_libraries', 'nysdoh_healthfacilities', 'doe_busroutesgarages', 
'dca_operatingbusinesses', 'nysomh_mentalhealth', 'doe_lcgms', 'sbs_workforce1',
'foodbankny_foodbanks', 'usdot_ports', 'dsny_mtsgaragemaintenance', 
'dot_publicparking', 'nycha_policeservice', 'nysdec_solidwaste', 
'usdot_airports', 'nysed_activeinstitutions', 'dcla_culturalinstitutions', 
'dot_mannedfacilities', 'usnps_parks', 'bic_tradewaste', 'nysopwdd_providers', 
'dfta_contracts', 'dpr_parksproperties', 'bpl_libraries']

for i in recipes: 
    os.system(f'cook recipe run {i}')