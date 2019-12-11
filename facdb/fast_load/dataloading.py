from cook import Importer
import os

def ETL():
    RECIPE_ENGINE = os.environ.get('FACDB_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    #load geoboundaries
    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='dcp_boroboundaries_wi')
    importer.import_table(schema_name='dcp_censustracts')
    importer.import_table(schema_name='dcp_councildistricts')
    importer.import_table(schema_name='dcp_cdboundaries')
    importer.import_table(schema_name='dcp_ntaboundaries')
    importer.import_table(schema_name='dcp_policeprecincts')
    importer.import_table(schema_name='doitt_zipcodeboundaries')
    importer.import_table(schema_name='doitt_buildingcentroids')
    importer.import_table(schema_name='dcp_school_districts')

    #load reference table
    importer.import_table(schema_name='dcp_facilities')
    importer.import_table(schema_name='facilities_classification')
    importer.import_table(schema_name='facilities_input_research')
    importer.import_table(schema_name='dcp_mappluto')
    importer.import_table(schema_name='zipcode_city_lookup')

    # load facilities
    importer.import_table(schema_name='dcp_pops')
    importer.import_table(schema_name='dpr_parksproperties')
    importer.import_table(schema_name='moeo_socialservicesiteloactions')
    importer.import_table(schema_name='nycdoc_corrections')
    importer.import_table(schema_name='nysdec_lands')
    importer.import_table(schema_name='nysparks_historicplaces')
    importer.import_table(schema_name='nysparks_parks')
    importer.import_table(schema_name='usdot_ports')
    importer.import_table(schema_name='usnps_parks')

if __name__ == "__main__":
    ETL()