from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname
from pathlib import Path

csv.field_size_limit(sys.maxsize)

table_name = 'dcp_sfpsd'
dcp_sfpsd = Flow(
    load(url, resources = table_name),

    # ################## geospatial ###################
    # ###### Make sure the following columns ##########
    # ###### exist before geo_flows          ########## 
    # #################################################

    rename_field('addressnum', 'hnum'), 

    rename_field('streetname', 'sname'),

    #zipcode -> zipcode
    # boro -> boro

    rename_field('the_geom', 'point_location'),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),

    dump_to_postgis()
)

dcp_sfpsd.process()

