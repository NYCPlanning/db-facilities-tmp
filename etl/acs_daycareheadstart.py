from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'acs_daycareheadstart'

acs_daycareheadstart = Flow(
    load(url, resources = table_name, force_strings=True),
    add_field('datasource', 'string', table_name),
    rename_field('program_address', 'address'),
    map_field('address', quick_clean),
    rename_field('zip', 'zipcode'),
    
    add_computed_field([
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                        ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['address'])
                                        )        
                        ]),
    filter_rows(not_equals = [
            dict(hnum = ''),
            ]),
                        
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    
    dump_to_postgis()
)

acs_daycareheadstart.process()
