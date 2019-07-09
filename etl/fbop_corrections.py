from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'fbop_corrections'
fbop_corrections = Flow(
    load(url, resources = table_name),
    # datasource
    add_field('datasource', 'string', table_name),
    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    add_field('boro', 'string', ''),

    add_computed_field([dict(target=dict(name = 'hnum', type = 'string'),
                                    operation = lambda row: get_hnum(row['address'])
                                    ),
                            dict(target=dict(name = 'sname', type = 'string'),
                                        operation=lambda row: get_sname(row['address'])
                                    )
                            ]),
    # zipcode --> zipcode
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

fbop_corrections.process()

