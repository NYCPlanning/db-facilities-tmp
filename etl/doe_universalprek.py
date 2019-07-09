from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

def get_boro(b): 
    boro = dict(
        Q = 'QN', 
        M = 'MN', 
        B = 'BK', 
        X = 'BX', 
        R = 'SI'
    )
    return boro.get(b, '')
    
table_name = 'doe_universalprek'
doe_universalprek = Flow(
    load(url, resources = table_name),
    # 

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('zip','zipcode'),
    map_field('address', operation=lambda a: quick_clean(a)),
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: get_boro(row['borough'])
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

doe_universalprek.process()
