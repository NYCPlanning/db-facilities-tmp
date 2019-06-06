from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname
from pathlib import Path

csv.field_size_limit(sys.maxsize)

table_name = 'dcp_pops'
dcp_pops = Flow(
    load(url, resources = table_name, force_strings=True),
    checkpoint(table_name),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('address_number', 'hnum'), 

    rename_field('street_name', 'sname'),

    rename_field('zip_code', 'zipcode'),

    rename_field('borough_name', 'boro'),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),

    dump_to_postgis()
)

dcp_pops.process()

