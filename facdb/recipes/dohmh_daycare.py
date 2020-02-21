from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode
import pandas as pd

if __name__ == "__main__":
    table_name = 'dohmh_daycare'
    df = importer(table_name)
    df['datasource'] = table_name
    df = df.rename(columns={'building':'hnum', 
                            'street':'sname', 
                            'borough':'boro', 
                            'zipcode': 'zip_code'})
    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name=table_name, sep='|')