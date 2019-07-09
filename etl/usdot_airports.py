from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'usdot_airports'
usdot_airports = Flow(
    load(url, resources = table_name),
    

    add_field('datasource', 'string', table_name),

    filter_rows(equals = [
            dict(statename = 'New York')
            ]),

    filter_rows(equals = [
            dict(county = 'New York'),
            dict(county = 'Queens'),
            dict(county = 'Bronx'),
            dict(county = 'Richmond'),
            dict(county = 'Kings'),
            ]),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################


    add_field('zipcode', 'string', ''),
    add_field('hnum', 'string', ''),
    rename_field('wkt', 'location'),

    add_computed_field([
                            dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: quick_clean(row['fullname']) + ' ' + row['facilityty']
                                    ),
                            dict(target=dict(name = 'boro', type = 'string'),
                                    operation=lambda row: row['county']
                                    )
                        ]),

    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),

    delete_fields(fields=['boro']),

    dump_to_postgis()
)

usdot_airports.process()

