from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np
import re

def get_address(location):
    '''
    This function will extract the address information
    from the location
    '''
    location = str('' if location is None else location).split('(')[0]
    p = re.compile('^.*(?P<zipcode>\d{5}).*$')
    match = p.search(location)
    if match is not None:
        zipcode =  match.groupdict()['zipcode']
        address = location[:location.find(zipcode)]
        return address
    return None

def clean_boro(b):
    if b == 'New York':
        b = 'Manhattan'
    if b not in ['Bronx', 'Manhattan', 'Brooklyn', 'Queens', 'Staten Island']:
        b = None
    return b

if __name__ == "__main__":
    table_name = 'dycd_afterschoolprograms'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df.rename(columns={'postcode':'zipcode','borough_/_community':'boro'})
    df['boro'] = df['boro'].apply(lambda x:clean_boro(x))
    df['address'] = df['location_1'].apply(lambda x: get_address(x)).apply(quick_clean)
    df['sname'] = df['address'].apply(get_sname)
    df['hnum'] = df['address'].apply(get_hnum)

    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)