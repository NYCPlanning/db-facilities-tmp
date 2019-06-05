from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import re
import csv
import sys
from utils import url, fields, geo_flow, get_the_geom

csv.field_size_limit(sys.maxsize)

table_name = 'dohmh_daycare'

dohmh_daycare = Flow(
    load(url, resources = table_name, force_strings=False),
    update_resource(None, name=table_name),
    update_resource(resources=table_name, path=table_name+'.csv'),
    
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
    delete_fields(['geo']),
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

dohmh_daycare.process()
