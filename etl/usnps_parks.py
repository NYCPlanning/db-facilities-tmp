from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)


table_name = 'usnps_parks'
dca_operatingbusinesses = Flow(
    load(url, resources = table_name, force_strings=False),
    # cacheing table
    checkpoint(table_name),
    # datasource

    # filter out facilities outsite New York City
    filter_rows(equals = [
            dict(state = 'NY'),
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    # create boro field, set default as 'MN' since all
    # New National Parks are in Manhattan
    add_field('boro', 'string', 'MN'),

    # create hnum field, set default as empty
    add_field('hnum', 'string', None),

    # create zipcode field, set default as empty
    add_field('zipcode', 'string', None),

    #validate street name via usaddress
    add_computed_field([dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: quick_clean(row['unit_name'])
                                    )
                        ]),
    # generate geo info
    geo_flow,

    #rename multipolygon
    rename_field('wkt','the_geom_multipolygon'),

    # generate coordinates
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            ),

                        # cleate a new boro column
                        dict(target=dict(name = 'boro_tmp', type = 'string'),
                            operation=lambda row: row['boro'] if row['the_geom'] != None else ''
                            )
                        ]),
    
    #delete the old boro
    delete_fields(fields=['boro']),

    #rename boro_tmp field as boro
    rename_field('boro_tmp','boro'),

    # printer(fields=['sname','the_geom','boro']),
    # printer(num_rows = 3),
    dump_to_postgis(table_name)
).process()
