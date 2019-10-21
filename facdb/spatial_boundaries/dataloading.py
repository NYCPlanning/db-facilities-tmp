from cook import Importer
import os

def ETL():
    RECIPE_ENGINE = os.environ.get('FACDB_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='dcp_boroboundaries_wi')
    importer.import_table(schema_name='dcp_censustracts')
    importer.import_table(schema_name='dcp_councildistricts')
    importer.import_table(schema_name='dcp_cdboundaries')
    importer.import_table(schema_name='dcp_ntaboundaries')
    importer.import_table(schema_name='dcp_policeprecincts')
    # importer.import_table(schema_name='doitt_zipcodeboundaries')

if __name__ == "__main__":
    ETL()