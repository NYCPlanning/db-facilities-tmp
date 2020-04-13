from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np

if __name__ == "__main__":
    table_name = 'nycdoc_corrections'
    correction = 'facilities_input_research'
    df = importer(table_name)
    input_research = importer(correction)
    input_research = input_research[input_research.datasource == table_name]\
                                .rename(columns={'facname': 'name', 'address': 'address1'})\
                                .drop(columns=['v', 'ogc_fid','boro'])

    df['datasource'] = table_name
    df = df.append(input_research, sort=True).drop_duplicates(subset=['name'], keep='last')
    df = df.rename(columns={'house_number':'hnum', 
                            'street_name': 'sname'})
    df['hnum'] = df.address1.apply(get_hnum)
    df['sname'] = df.address1.apply(get_sname)
    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)