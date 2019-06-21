from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

table_name = 'usdot_ports'
usdot_ports = Flow(
    load(url, resources = table_name, force_strings=True),
    

    add_field('datasource', 'string', table_name),

    filter_rows(equals = [
            dict(state_post = 'NY'),
            ]),

    filter_rows(equals = [
            dict(county_nam = 'New York'),
            dict(county_nam = 'Queens'),
            dict(county_nam = 'Bronx'),
            dict(county_nam = 'Richmond'),
            dict(county_nam = 'Kings'),
            ]),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                    operation=lambda row: quick_clean(row['street_add'])
                                ),
                        dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address'])
                                ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                ),
                        dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: row['county_nam']
                                )
                        ]),
    rename_field('wkt', 'point_location'),
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

usdot_ports.process()

