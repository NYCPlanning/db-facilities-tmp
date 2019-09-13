import os
from multiprocessing import Pool, cpu_count

recipes = ['acs_daycareheadstart','bpl_libraries','dca_operatingbusinesses',
        'dcas_colp','dcla_culturalinstitutions','dcp_pops', 'dcp_sfpsd', 
        'dep_wwtc', 'dfta_contracts','doe_busroutesgarages','doe_lcgms',
        'doe_universalprek','dohmh_daycare','dot_bridgehouses','dot_ferryterminals', 
        'dot_mannedfacilities', 'dot_pedplazas','dot_publicparking','dpr_parksproperties',
        'dsny_mtsgaragemaintenance', 'dycd_afterschoolprograms', 'fbop_corrections', 'fdny_firehouses',
        'foodbankny_foodbanks', 'hhc_hospitals','hra_centers', 'moeo_socialservicesiteloactions',
        'nycdoc_corrections', 'nycha_communitycenters','nycha_policeservice', 'nycourts_courts',
        'nypl_libraries', 'nysdec_lands','nysdec_solidwaste', 'nysdoccs_corrections',
        'nysdoh_healthfacilities','nysdoh_nursinghomes','nysed_activeinstitutions',
        'nysoasas_programs','nysomh_mentalhealth','nysopwdd_providers',
        'nysparks_historicplaces', 'nysparks_parks','qpl_libraries','sbs_workforce1',
        'uscourts_courts','usdot_airports','usdot_ports','usnps_parks','facilities_classification',
        'doitt_buildingcentroids']

# note doe_bluebook is merged into doe_lcgms

print(len(recipes))

def run_recipe(recipe):
    os.system(f'cook recipe run {recipe}')

with Pool(processes=cpu_count()) as pool:
        it = pool.map(run_recipe, recipes)