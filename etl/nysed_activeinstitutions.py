from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, geo_flow, get_the_geom, quick_clean, get_hnum, get_sname

csv.field_size_limit(sys.maxsize)

def remove_room(address): 
    address = address.split('-RM')[0]
    address = quick_clean(address)
    return address


table_name = 'nysed_activeinstitutions'
nysed_activeinstitutions = Flow(
    load(url, resources = table_name),
    
    # cacheing table
    

    # datasource
    add_field('datasource', 'string', table_name),


    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################
    add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                operation=lambda row: remove_room(row['physical_address_line1'])
                                            ),
                        dict(target=dict(name = 'hnum', type = 'string'),
                                operation = lambda row: get_hnum(row['address'])
                                    ),
                            dict(target=dict(name = 'sname', type = 'string'),
                                    operation=lambda row: get_sname(row['address'])
                                    )
                        ]),
    rename_field('physical_zipcd5', 'zipcode'),
    add_field('boro', 'string'),
    
    geo_flow,
    
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    dump_to_postgis()
)

nysed_activeinstitutions.process()


# Load supplementry table: 
nysed_nonpublicenrollment = Flow(
    load(url, resources = 'nysed_nonpublicenrollment'),
    
    # datasource
    add_field('datasource', 'string', 'nysed_nonpublicenrollment'),

    # note this table is not spatial
    dump_to_postgis()
)

nysed_nonpublicenrollment.process()