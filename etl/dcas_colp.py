from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url, fields, geo_flow, get_the_geom

csv.field_size_limit(sys.maxsize)

table_name = 'dcas_colp'
dcas_colp = Flow(
    load(url, resources = table_name, force_strings=False),
    # cacheing table
    checkpoint(table_name),
    # uid
    # facname
    # factype
    # facsubgrp
    # facgroup
    # facdomain
    # servarea
    # opname
    # opabbrev
    # optype
    # overagency
    # overabbrev
    # overlevel
    # capacity
    # captype
    # proptype
    # datasource
    add_field('datasource', 'string', table_name),

    ################## geospatial ###################
    ###### Make sure the following columns ##########
    ###### exist before geo_flows          ########## 
    #################################################

    # hnum
    rename_field('house_number', 'hnum'),
    # sname
    rename_field('street_name', 'sname'), 
    # zipcode
    add_field('zipcode', 'string', ''),
    # boro
    rename_field('borough', 'boro'), 
    geo_flow,
    add_computed_field([dict(target=dict(name = 'the_geom', type = 'string'),
                            operation=lambda row: get_the_geom(row['geo_longitude'], row['geo_latitude'])
                            )
                        ]),
    printer(num_rows=3),
    dump_to_postgis(),
)

dcas_colp.process()