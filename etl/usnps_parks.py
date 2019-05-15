from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)


table_name = 'usnps_parks'
usnps_parks = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

    filter_rows(equals = [
            dict(state = 'NY'),
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_field('boro', 'string', 'MN'),

    add_field('hnum', 'string', None),

    add_field('zipcode', 'string', None),

    add_computed_field([dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: quick_clean(row['unit_name'])
                                    )
                        ]),
    geo_flow,

    rename_field('wkt','multipolygon'),

    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),
                        dict(target=dict(name = 'boro_tmp', type = 'string'),
                            operation=lambda row: row['boro'] if row['the_geom'] != None else ''
                            )
                        ]),

    delete_fields(fields=['boro']),
    rename_field('boro_tmp','boro'),

    dump_to_postgis(table_name)
)

usnps_parks.process()
