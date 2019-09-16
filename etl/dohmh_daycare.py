from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import re
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom

csv.field_size_limit(sys.maxsize)

table_name = 'dohmh_daycare'

dohmh_daycare = Flow(
    load(url, resources = table_name),
    # load('/home/db-facilities/datapackage.json'),
    # datasource text,
    add_field('datasource', 'string', table_name),

    ################################### Spatial #################################
    # hnum text,
    rename_field('building', 'hnum'),
    # sname text,
    rename_field('street', 'sname'),
    # zipcode --> no action needed
    # boro text,
    rename_field('borough', 'boro'),

    geo_flow,

    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_path(f'{str(Path(__file__).parent)}/tmp'),
)

post_process = Flow(
    load(f'{str(Path(__file__).parent)}/tmp/dohmh_daycare.csv'),
    dump_to_postgis()
)

dohmh_daycare.process()
post_process.process()

os.system(f'rm -r {str(Path(__file__).parent)}/tmp')
