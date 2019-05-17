from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'doitt_libraries'
doitt_libraries = Flow(
    load(url, resources = table_name, force_strings=False),
    # cacheing table
    checkpoint(table_name),
    # datasource
    add_field('datasource', 'string', table_name),


    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    # hnum
    rename_field('housenum', 'hnum'),
    # sname 
    rename_field('streetname', 'sname'),
    # boro
    add_field('boro', 'string', ''),
    # zipcode
    rename_field('zip', 'zipcode'),

    rename_field('the_geom', 'original_geom'),

    geo_flow,
    
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    printer(num_rows=3),
    dump_to_postgis()
)

doitt_libraries.process()

