from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'dot_pedplazas'
dot_pedplazas = Flow(
    load(url, resources = table_name, force_strings=True),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_field('zipcode','string', ''),
    rename_field('wkt','point_location'),

    map_field('boro', operation=lambda a: a[:2]),
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['on_'])
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
                            )
                        ]),
    
    dump_to_postgis()
)

dot_pedplazas.process()
