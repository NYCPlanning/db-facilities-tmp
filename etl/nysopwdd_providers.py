from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'nysopwdd_providers'

nysopwdd_providers = Flow(
    load(url, resources = table_name),
    
    filter_rows(equals = [
            dict(county = 'KINGS'),
            dict(county = 'NEW YORK'),
            dict(county = 'BROX'),
            dict(county = 'QUEENS'),
            dict(county = 'RICHMOND')
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('zip_code','zipcode'),

    add_field('boro','string',''),

    map_field('street_address_line_2', lambda x: '' if not x else x),
    
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                    operation=lambda row: quick_clean(row['street_address']\
                                             + ' ' + row['street_address_line_2'])
                                    ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['address'])
                                    )
                        ]),
 
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),
                        ]),
    
    dump_to_postgis()
)
nysopwdd_providers.process()
