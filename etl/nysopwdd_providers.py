from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)


table_name = 'nysopwdd_providers'
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

    # filter out facilities outsite New York City
    filter_rows(equals = [
            dict(county = 'KINGS'),
            dict(county = 'NEW YORK'),
            dict(county = 'BROX'),
            dict(county = 'QUEENS'),
            dict(county = 'RICHMOND')
            ]),
    

    #rename zipcode field
    rename_field('zip_code','zipcode'),

    #rename borough field
    rename_field('county','boro'),
    
    #validate adress, generate house number, street name via usaddress
    add_computed_field([dict(target=dict(name = 'address_tmp', type = 'string'),
                                    operation=lambda row: quick_clean(row['street_address_line_2'])
                                    ),
                        dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['street_address']) if row['address_tmp'] == '' else row['address_tmp']
                                    ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['address'])
                                    )
                        ]),
    # generate geo info
    geo_flow,

    # generate coordinates
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    #delete the temparary address
    delete_fields(fields=['address_tmp']),
    
    # printer(fields=['hnum','sname','address','boro','zipcode','the_geom','datasource'])
    # printer(num_rows = 3),
    dump_to_postgis(table_name)
).process()
