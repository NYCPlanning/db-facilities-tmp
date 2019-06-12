from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname, convert_to_boro

csv.field_size_limit(sys.maxsize)

table_name = 'nysdoh_nursinghomes'
nysdoh_nursinghomes = Flow(
    load(url, resources = table_name, force_strings=True),
    checkpoint(table_name),

    filter_rows(equals = [
            dict(state = 'NY')
            ]),

    filter_rows(equals = [
            dict(county = 'New York'),
            dict(county = 'Queens'),
            dict(county = 'Bronx'),
            dict(county = 'Richmond'),
            dict(county = 'Kings'),
            ]),

    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    rename_field('zip_code','zipcode'),
    
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: convert_to_boro(row['county'])
                                    ),
                        dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: quick_clean(row['street_address']) 
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

    dump_to_postgis()
)
nysdoh_nursinghomes.process()
