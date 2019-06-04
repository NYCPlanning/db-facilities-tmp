from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'bpl_libraries'
bpl_libraries = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_field('boro','string', 'BK'),
    map_field('address', operation=lambda a: quick_clean(a)),
    add_computed_field([dict(target=dict(name = 'zipcode', type = 'string'),
                                operation=lambda row: row['address'][-5:]
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
    
    dump_to_postgis(table_name)
)

bpl_libraries.process()
