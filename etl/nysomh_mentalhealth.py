from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, get_geom_source, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'nysomh_mentalhealth'
nysomh_mentalhealth = Flow(
    load(url, resources = table_name, force_strings=False),
    # cacheing table
    checkpoint(table_name),

    # filter out facilities outsite New York City
    filter_rows(equals = [
            dict(program_county = 'Kings'),
            dict(program_county = 'New York'),
            dict(program_county = 'Brox'),
            dict(program_county = 'Queens'),
            dict(program_county = 'Richmond')
            ]),

    # datasource
    add_field('datasource', 'string', table_name),


    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    # rename zipcode field
    rename_field('program_zip','zipcode'),

    # rename borough field
    rename_field('program_county','boro'),
    
    # validate adress, generate house number, street name via usaddress
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['program_address_1']) 
                                            if row['program_address_1'] != None else None
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
    add_computed_field([dict(target=dict(name = 'the_geom_tmp', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),
                        dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: row['the_geom_tmp'] 
                                        if row['the_geom_tmp'] != None
                                else get_geom_source(row['location'])
                            )
                        ]),
    #delete the temparary geom
    delete_fields(fields=['the_geom_tmp']),
    
    dump_to_postgis(table_name)
).process()
