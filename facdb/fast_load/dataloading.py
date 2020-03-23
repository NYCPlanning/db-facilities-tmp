from cook import Importer
from multiprocessing import Pool, cpu_count
import os

source_tables = [
    'sca_bluebook',
    'dot_bridgehouses',
    'dot_ferryterminals',
    'dot_mannedfacilities',
    'dot_pedplazas',
    'dot_publicparking',
    'dpr_parksproperties',
    'dsny_mtsgaragemaintenance',
    'dycd_afterschoolprograms',
    'fbop_corrections',
    'fdny_firehouses',
    'foodbankny_foodbanks',
    'hhc_hospitals',
    'hra_centers',
    'moeo_socialservicesiteloactions',
    'nycdoc_corrections',
    'nycha_communitycenters',
    'nycha_policeservice',
    'nycourts_courts',
    'nypl_libraries',
    'nysdec_lands',
    'nysdec_solidwaste',
    'nysdoccs_corrections',
    'nysdoh_healthfacilities',
    'nysdoh_nursinghomes',
    'nysed_activeinstitutions',
    'nysed_nonpublicenrollment',
    'nysoasas_programs',
    'nysomh_mentalhealth',
    'nysopwdd_providers',
    'nysparks_historicplaces',
    'nysparks_parks',
    'qpl_libraries',
    'sbs_workforce1',
    'uscourts_courts',
    'usdot_airports',
    'usdot_ports',
    'usnps_parks'
]

boundry_tables = [
    'dcp_boroboundaries_wi',
    'dcp_censustracts',
    'dcp_councildistricts',
    'dcp_cdboundaries',
    'dcp_ntaboundaries',
    'dcp_policeprecincts',
    'doitt_zipcodeboundaries',
    'doitt_buildingcentroids',
    'dcp_school_districts'
]

reference_tables = [
    'dcp_facilities',
    'facilities_classification',
    'facilities_input_research',
    'dcp_mappluto',
    'zipcode_city_lookup'
]

def ETL(table): 
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')
    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name=table)

if __name__ == "__main__":
    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, reference_tables+boundry_tables)