from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, get_geom_source, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)


table_name = 'nysopwdd_providers'
nysopwdd_providers = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

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
    
    add_computed_field([dict(target=dict(name = 'address_tmp', type = 'string'),
                                    operation=lambda row: quick_clean(row['street_address_line_2'])
                                    ),
                        dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['street_address']) 
                                            if row['address_tmp'] == '' else row['address_tmp']
                                    ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['address'])
                                    )
                        ]),
 
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom_tmp', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),
                        dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: row['the_geom_tmp'] 
                                        if row['the_geom_tmp'] != None
                                else get_geom_source(row['location_1'])
                            )
                        ]),

    delete_fields(fields=['the_geom_tmp']),
    delete_fields(fields=['address_tmp']),
    
    dump_to_postgis(table_name)
)
nysopwdd_providers.process()
