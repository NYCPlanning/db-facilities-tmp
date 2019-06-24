from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'nysomh_mentalhealth'
nysomh_mentalhealth = Flow(
    load(url, resources = table_name, force_strings=True),
    

    filter_rows(equals = [
            dict(program_county = 'Kings'),
            dict(program_county = 'New York'),
            dict(program_county = 'Brox'),
            dict(program_county = 'Queens'),
            dict(program_county = 'Richmond')
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('program_zip','zipcode'),

    add_field('boro','string',''),
    
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['program_address_1']) 
                                            # if row['program_address_1'] != None else None
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
nysomh_mentalhealth.process()
