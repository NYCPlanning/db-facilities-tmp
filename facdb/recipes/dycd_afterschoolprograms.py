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
    if location != '':
        return re.sub('.{5}$','',location)
    return ''

if __name__ == "__main__":
    table_name = 'dycd_afterschoolprograms'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df.rename(columns={'postcode':'zipcode','borough_/_community':'boro'})
    df['boro'] = ''
    df['address'] = df['location_1'].apply(lambda x: get_address(x)).apply(quick_clean)

    # extract house number and street name for queens and other boroughs seperately
    df_ = df[df.boro != 'Queens'].copy()
    df_qn = df[df.boro == 'Queens'].copy()
    df_['sname'] = df_['address'].apply(get_sname)
    df_['hnum'] = df_['address'].apply(get_hnum)
    df_qn['sname'] = df_qn['address'].apply(get_sname).apply(get_sname)
    df_qn['hnum'] = [a.replace(b, '').strip() for a, b in zip(df_qn['address'], df_qn['sname'])]
    df = df_.append(df_qn)

    records = df.to_dict('records')
    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)