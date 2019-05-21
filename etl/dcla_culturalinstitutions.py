from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'dcla_culturalinstitutions'
dcla_culturalinstitutions = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_computed_field([dict(target=dict(name = 'address_cleaned', type = 'string'),
                                        operation=lambda row: quick_clean(row['address'])
                                        ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address_cleaned'])
                                    ),
                            dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address_cleaned'])
                                    )
                        ]),
    delete_fields(fields=['address_cleaned']),

    add_field('boro', 'string', ''),

    rename_field('postcode', 'zipcode'),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    printer(num_rows=3),
    dump_to_postgis()
)

dcla_culturalinstitutions.process()

