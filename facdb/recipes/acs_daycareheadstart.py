from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname
import pandas as pd

if __name__ == "__main__":
    table_name = 'acs_daycareheadstart'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df.rename(columns={'program_address':'address',
                            'zip': 'zip_code',
                            '%_of_enrol':'pct_of_enrol'})
    df['sname'] = df['address'].apply(get_sname)
    df['hnum'] = df['address'].apply(get_hnum)
    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name=table_name)