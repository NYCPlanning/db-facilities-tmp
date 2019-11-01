from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np

if __name__ == "__main__":
    table_name = 'nysdoh_healthfacilities'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df[df.facility_county.str.lower().isin(['kings', 
                            'new york',
                            'bronx', 
                            'queens',
                            'richmond'])]
    df['address'] = df.apply(lambda row: quick_clean(row['facility_address_2'])\
                                        if row['facility_address_2'] != ''\
                                        else quick_clean(row['facility_address_1']), axis=1)
    df['sname'] = df['address'].apply(get_sname)
    df['hnum'] = df['address'].apply(get_hnum)
    df = df.rename(columns={'facility_zip_code':'zipcode'})
    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)