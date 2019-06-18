from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname, convert_to_boro

csv.field_size_limit(sys.maxsize)

table_name = 'nysparks_parks'

nysparks_parks = Flow(
    load(url, resources=table_name, force_strings=False),
    add_field('datasource', 'string', table_name),
    filter_rows(equals = [
            dict(county = 'Kings'),
            dict(county = 'New York'),
            dict(county = 'Bronx'),
            dict(county = 'Queens'),
            dict(county = 'Richmond')
            ]),
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: convert_to_boro(row['county'])
                                    )]),
    
    dump_to_postgis()
)
nysparks_parks.process()
