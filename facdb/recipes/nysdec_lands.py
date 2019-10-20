from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np

if __name__ == "__main__":
    table_name = 'nysdec_lands'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df[df.county.isin(['KINGS', 
                            'NEW YORK',
                            'BRONX', 
                            'QUEENS',
                            'RICHMOND'])]
    records = df.to_dict('records')

    ## Export to build engine
    exporter(df, table_name, to_geom=False)