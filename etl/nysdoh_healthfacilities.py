from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)


table_name = 'nysdoh_healthfacilities'
nysdoh_healthfacilities = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),

    filter_rows(equals = [
            dict(facility_county = 'Kings'),
            dict(facility_county = 'New York'),
            dict(facility_county = 'Brox'),
            dict(facility_county = 'Queens'),
            dict(facility_county = 'Richmond')
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################   

    rename_field('facility_zip_code','zipcode'),

    add_field('boro','string',''),
    
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                    operation=lambda row: quick_clean(row['facility_address_2'])
                                                    if row['facility_address_2'] != ''
                                                    else quick_clean(row['facility_address_1'])
                                    ),
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
                            ), 
                        ]),

    dump_to_postgis(table_name)
)

nysdoh_healthfacilities.process()
