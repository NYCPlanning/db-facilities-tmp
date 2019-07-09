from dataflows import *
from lib import dump_to_postgis, rename_field, map_field
import os
import csv
import sys
from pathlib import Path
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname, convert_to_boro

csv.field_size_limit(sys.maxsize)

table_name = 'nysdec_lands'

nysdec_lands = Flow(
    load(url, resources = table_name),
    add_field('datasource', 'string', table_name),
    
    filter_rows(equals = [
            dict(county = 'KINGS'),
            dict(county = 'NEW YORK'),
            dict(county = 'BRONX'),
            dict(county = 'QUEENS'),
            dict(county = 'RICHMOND')
            ]),
    add_computed_field([dict(target=dict(name = 'boro', type = 'string'),
                                operation=lambda row: convert_to_boro(row['county'])
                                    )]),
                                    
    
    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    
    dump_to_postgis()
)
nysdec_lands.process()