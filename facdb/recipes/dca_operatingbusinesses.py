from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter, exporter_classic
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np

if __name__ == "__main__":
    table_name = 'dca_operatingbusinesses'
    df = importer(table_name)

    # Filter table
    df = df[df.address_borough != 'Outside NYC']
    df = df[df.industry.isin(['Scrap Metal Processor',
                                'Parking Lot',
                                'Garage', 
                                'Garage and Parking Lot',
                                'Tow Truck Company'])]

    df['datasource'] = table_name
    df = df.rename(columns={'address_zip':'zipcode',
                            'address_borough': 'boro'})
    df['address'] = df['address_building'] + ' ' + df['address_street_name']
    df['sname'] = df['address'].apply(get_sname)
    df['hnum'] = df['address'].apply(get_hnum)
    records = df.to_dict('records')

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)
    
    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name, sep='|')