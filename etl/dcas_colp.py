from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom

csv.field_size_limit(sys.maxsize)

table_name = 'dcas_colp'
dcas_colp = Flow(
    load(url, resources = table_name, force_strings=False),

    checkpoint(table_name),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_field('zipcode', 'string', ''),
    rename_field('house_number', 'hnum'),
    rename_field('street_name', 'sname'), 
    rename_field('borough', 'boro'), 

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
                        
    dump_to_postgis(),
)

dcas_colp.process()