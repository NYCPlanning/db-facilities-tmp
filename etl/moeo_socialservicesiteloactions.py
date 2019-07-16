from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'moeo_socialservicesiteloactions'
moeo_socialservicesiteloactions = Flow(
    load(url, resources = table_name),
    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    
    add_field('zipcode', 'string', ''),
    
    rename_field('site_boro', 'boro'),
    rename_field('street_number', 'hnum'),
    rename_field('street_name', 'sname'),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

moeo_socialservicesiteloactions.process()