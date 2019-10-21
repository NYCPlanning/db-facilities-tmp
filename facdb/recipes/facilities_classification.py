from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode
import pandas as pd

if __name__ == "__main__":
    table_name = 'facilities_classification'
    df = pd.read_csv('https://raw.githubusercontent.com/NYCPlanning/db-facilities-tmp/dev/referencetables/classification.csv')
    df.columns = [i.strip() for i in df.columns]
    ## Export to build engine
    exporter(df, table_name=table_name, to_geom=False)