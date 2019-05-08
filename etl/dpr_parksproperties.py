from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

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

table_name = 'dpr_parksproperties'
dpr_parksproperties = Flow(
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
    add_computed_field([dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        # sname     
                        dict(target=dict(name = 'sname_tmp', type = 'string'),
                                    operation=lambda row: get_sname(row['address'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: quick_clean(row['signname']) if row['sname_tmp'] == '' else row['sname_tmp']
                                    ),
                        # boro
                        dict(target=dict(name = 'boro', type = 'string'),
                                    operation=lambda row: get_boro(row['borough'])
                                    )
                        ]),
    #delete the temparary sname
    delete_fields(fields=['sname_tmp']),

    #rename multipolygon
    rename_field('the_geom','the_geom_multipolygon'),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    # printer(num_rows=3, fields=['hnum', 'sname', 'boro', 'zipcode']),
    # printer(num_rows=3),
    # select_fields(fields=['signname','the_geom_multipolygon','the_geom'
    #                          ]),

    # dump_to_path(table_name)
    dump_to_postgis(table_name)
).process()