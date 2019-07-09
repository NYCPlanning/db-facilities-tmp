from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname, convert_to_boro

csv.field_size_limit(sys.maxsize)

table_name = 'nysoasas_programs'
nysoasas_programs = Flow(
    load(url, resources = table_name),
    add_field('datasource', 'string', table_name),
    rename_field('provider_street', 'address'),
    map_field('address', quick_clean),
    rename_field('provider_zip_code', 'zipcode'),
    
    
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation = lambda row: convert_to_boro(row['provider_city'])),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                        ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                operation=lambda row: get_sname(row['address'])
                                        )
                        ]),
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),

    dump_to_postgis()
)

nysoasas_programs.process()

