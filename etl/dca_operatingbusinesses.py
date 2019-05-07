# take 22m to run for 2019 data
from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

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

    # # filter out facilities not in New York City
    filter_rows(equals = [
            dict(borough_code = '1'),
            dict(borough_code = '2'),
            dict(borough_code = '3'),
            dict(borough_code = '4'),
            dict(borough_code = '5')
            ]),

    add_field('datasource', 'string', table_name),


    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    #rename the borough field
    rename_field('address_borough','boro'),

    #rename the zipcode field
    rename_field('address_zip','zipcode'),

    #generate a temparary address field
    add_computed_field([dict(target=dict(name = 'address_tmp', type = 'string'),
                                    operation=lambda row: get_address(row['address_building'],row['address_street_name'])
                                    ),
                        #validate the temparary address column with usaddress and generate a new address column
                        dict(target=dict(name = 'address', type = 'string'),
                                    operation=lambda row: quick_clean(row['address_tmp']) if row['address_tmp'] != None else None
                                    ),
                        # generate house number field by looking into usaddress
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address']) if row['address'] != None else None
                                    ),
                        # generate street name field by looking into usaddress
                        dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address']) if row['address'] != None else None
                                    )
                        
                            ]),
    
    add_computed_field([
                        ]),
    #delete the temporary field
    delete_fields(fields=['address_tmp']),

    #generate fields regarding to geo info
    geo_flow,

    #generate the coordinates
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['longitude'], row['latitude']) if row['location'] != None else None
                            )
                        ]),

    # printer(fields=['hnum','sname','address','boro','zipcode','datasource']),
    # printer(num_rows = 3),
    dump_to_postgis(table_name)
    
).process()
