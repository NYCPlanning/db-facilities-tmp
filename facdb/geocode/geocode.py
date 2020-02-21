from multiprocessing import Pool, cpu_count
from sqlalchemy import create_engine
from geosupport import Geosupport, GeosupportError
import pandas as pd
import usaddress
import re
import json
import os 

g = Geosupport()

def quick_clean(address):
        address = '-'.join([i.strip() for i in address.split('-')]) if address is not None else ''
        result = [k for (k,v) in usaddress.parse(address) \
                if not v in \
                ['OccupancyIdentifier', 'OccupancyType']]
        return re.sub(r'[,\%\$\#\@\!\_\.\?\`\"\(\)]', '', ' '.join(result))
                
def get_hnum(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Address", v)]  if address is not None else ''
        return ' '.join(result)

def get_sname(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Street", v)]  if address is not None else ''
        return ' '.join(result)

def geocode(input):
    # collect inputs
    uid = input.pop('uid')
    address = input.pop('address')
    address_c = quick_clean(address)
    borough = input.pop('borocode')

    hnum = get_hnum(address_c)
    sname = get_sname(address_c)

    try: 
        geo = g['1e'](street_name=sname, house_number=hnum, borough=borough, mode='regular')
        geo = parse_output(geo)
        geo.update(uid=uid, hnum=hnum, sname=sname, address=address, address_c=address_c)
        return geo
    except GeosupportError as e:
        geo = parse_output(e.result)
        geo.update(uid=uid, hnum=hnum, sname=sname, address=address, address_c=address_c)
        return geo

def parse_output(geo):
    return dict(
                xcoord = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('X Coordinate', ''),
                ycoord = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('Y Coordinate', ''),

                grc = geo.get('Geosupport Return Code (GRC)', ''),
                grc2 = geo.get('Geosupport Return Code 2 (GRC 2)', ''),
                msg = geo.get('Message', 'msg err'),
                msg2 = geo.get('Message 2', 'msg2 err'),
            )

if __name__ == '__main__':
    # connect to postgres db
    engine = create_engine(os.environ['BUILD_ENGINE'])

    # read in housing table
    df = pd.read_sql("select address, borocode, uid from facilities where geom is null and borocode is not null;", 
                    engine)

    # df = df.rename(columns={'uid':'uid', 
    #                         'addressnum':'house_number', 
    #                         'streetname':'street_name', 
    #                         'boro':'borough'})

    records = df.to_dict('records')
    
    print('geocoding begins here ...')
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)
    
    print('geocoding finished, dumping tp postgres ...')
    pd.DataFrame(it).to_sql('geo_result', engine, if_exists='replace', chunksize=10000)