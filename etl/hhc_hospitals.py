from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'hhc_hospitals'

hhc_hospitals = Flow(
    load(url, resources = table_name, force_strings=False),
    add_field('datasource', 'string', table_name),
    map_field('location_1', operation=lambda a: quick_clean(a)),
    
    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: row['borough']),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['location_1'])
                                        ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['location_1'])
                                        ),
                        dict(target=dict(name = 'zipcode', type = 'string'),
                                operation=lambda row: row['postcode'])
                        ]),
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    
    dump_to_postgis()
)

hhc_hospitals.process()
