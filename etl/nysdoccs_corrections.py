from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom

csv.field_size_limit(sys.maxsize)

table_name = 'nysdoccs_corrections'

nysdoccs_corrections = Flow(
    load(url, resources = table_name),
    add_field('datasource', 'string', table_name),
    add_field('boro', 'string', ''),

    filter_rows(equals = [
            dict(county = 'Kings'),
            dict(county = 'New York'),
            dict(county = 'Brox'),
            dict(county = 'Queens'),
            dict(county = 'Richmond')
            ]),
    
    rename_field('house_number', 'hnum'),
    rename_field('street_name', 'sname'),
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

nysdoccs_corrections.process()
