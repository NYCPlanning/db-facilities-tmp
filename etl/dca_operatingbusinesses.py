# take 24m to run for 2019 data
from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

def get_borocode(city,borocode):
    '''
    This function is used for creating
    a temporary borough code field to fill with
    either address_city or borough_code
    info for facilities in NYC
    '''
    try:
        if borocode != '':
            return borocode
        elif borocode == '':
            if ((city == 'NEW YORK')|
            (city == 'BRONX')|
            (city == 'BROOKLYN')|
            (city == 'QUEENS')|
            (city == 'STATEN ISLAND')
            ):
                return city
    except:
        return None

def get_the_borocode(b):
    '''
    This function is used for converting
    city name to borough code
    '''
    if b == 'NEW YORK': return '1'
    if b == 'BRONX': return '2'
    if b == 'BROOKLYN': return '3'
    if b == 'QUEENS': return '4'
    if b == 'STATEN ISLAND': return '5'
    return b

def get_boro(b):
    '''
    This function is used for converting
    borough code into borough names
    '''
    boro = {'1': 'Manhattan', '2': 'Bronx',
            '3': 'Brooklyn','4': 'Queens',
            '5': 'Staten Island'
            }
    return boro.get(b, '')

        
def get_address(hnum, sname):
    '''
    This function is used to generate
    the facility address by combining
    house number and street name
    '''
    try:
        address = hnum + ' ' + sname
        return address
    except:
        return None

table_name = 'dca_operatingbusinesses'
dca_operatingbusinesses = Flow(
    load(url, resources = table_name, force_strings=False),
    # cacheing table
    checkpoint(table_name),
    
    # datasource
    add_field('datasource', 'string', table_name),


    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    
    # create a temporary borocode field, adding address city to fill the blank if they are in 5 boroughs
    add_computed_field([dict(target=dict(name = 'borocode_tmp', type = 'string'),
                                    operation=lambda row: get_borocode(row['address_city'],row['borough_code'])      
                                    ),

                        # replace the borough name with corresponding boro code
                        dict(target=dict(name = 'boro_code', type = 'string'),
                                    operation=lambda row: get_the_borocode(row['borocode_tmp'])      
                                    ),

                        # create a new borough field based on brough code
                        dict(target=dict(name = 'boro', type = 'string'),
                                    operation=lambda row: get_boro(row['boro_code'])      
                                    ),
                        ]),
    # delete the temporary borocode field
    delete_fields(fields=['borocode_tmp']),

    # delte the address_borough since we created a more complete boro field
    delete_fields(fields=['address_borough']),

    # filter out the facilities not in NYC
    # filter_rows(equals = [
    #             dict(boro = 'Manhattan'),
    #             dict(boro = 'Brooklyn'),
    #             dict(boro = 'Queens'),
    #             dict(boro = 'Bronx'),
    #             dict(boro = 'Staten Island')
    #             ]),

    # rename the zipcode field
    rename_field('address_zip','zipcode'),

    
    # generate address field
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                    operation=lambda row: quick_clean(get_address(row['address_building'],row['address_street_name']))
                                    ),
                        # generate house number field by looking into usaddress
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        # generate street name field by looking into usaddress
                        dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address'])
                                    )
                        
                            ]),
    # filter out the facilities doesn't have an address          
    filter_rows(not_equals = [
            dict(address = ''),
            ]),

    # # generate fields regarding to geo info
    geo_flow,

    #generate the coordinates
    add_computed_field([dict(target=dict(name = 'the_geom_tmp', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),
                        dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: row['the_geom_tmp']
                                if row['the_geom_tmp'] != None
                                else get_the_geom(row['longitude'], row['latitude']) 
                            )
                        ]),
    #delete the temparary geom
    delete_fields(fields=['the_geom_tmp']),

    # printer(fields=['hnum','sname','address','the_geoxm','geo_zipcode','boro','zipcode','datasource']),
    # printer(num_rows = 3),
    # printer(fields=['address',address_borough','address_city','boro_code','borocode_tmp','boro']),
    dump_to_postgis(table_name)
    
).process()
