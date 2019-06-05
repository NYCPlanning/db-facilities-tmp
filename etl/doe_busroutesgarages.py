from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname
import datetime
csv.field_size_limit(sys.maxsize)

table_name = 'doe_busroutesgarages'
SCHOOL_YEAR = f'{datetime.date.today().year-1}-{datetime.date.today().year}'
print(f'current school year is {SCHOOL_YEAR}')

doe_busroutesgarages = Flow(
    load(url, resources = table_name, force_strings=True),
    update_resource(None, name=table_name),
    update_resource(resources=table_name, path=table_name+'.csv'),

    filter_rows(equals=[dict(school_year=SCHOOL_YEAR)]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                        operation=lambda row: quick_clean(row['garage__street_address'])
                                        ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address'])
                                    )
                        ]),

    add_field('boro', 'string', ''),

    rename_field('garage_zip', 'zipcode'),

    geo_flow,
    
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

doe_busroutesgarages.process()

