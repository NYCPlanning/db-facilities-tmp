from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'dot_bridgehouses'
dot_bridgehouses = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('wkt', 'point_location'),

    add_field('zipcode', 'string', ''),
    add_field('hnum', 'string', ''),

    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: row['boroname'] 
                                            if row['boroname'] != 'None'
                                            else '' 
                                    ),
                        dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['site'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: row['address']
                                    )
                        ]),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),

    dump_to_postgis()
)

dot_bridgehouses.process()

