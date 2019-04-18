from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url

csv.field_size_limit(sys.maxsize)
table_name = 'dcas_colp'
dcas_colp = Flow(
    load(url, resources = table_name, force_strings=False),
    filter_rows(not_equals=[dict(agency='NYCHA'),
                            dict(agency='HPD'),
                            dict(usedec='ROAD/HIGHWAY'),
                            dict(usedec='TRANSIT WAY')])
    checkpoint(table_name),
    # uid text,
    # add_field('uid', 'string'),
    # facname text,
    # factype text,
    # facsubgrp text,
    # facgroup text,
    # facdomain text,
    # servarea text,
    # opname text,
    # opabbrev text,
    # optype text,
    # overagency text,
    # overabbrev text,
    # overlevel text,
    # capacity text,
    # captype text,
    # proptype text,
    # datasource
    # add_field('datasource', 'string', table_name),
    # hnum text,
    # sname text,
    # address text,
    # city text,
    # zipcode text,
    # boro text,
    # bin text,
    # bbl text,
    # latitude text,
    # longitude text,
    # xcoord text,
    # ycoord text,
    # commboard text,
    # nta text,
    # council text,
    # censtract text,
    # geom text
    printer(num_rows=3)      
)

dcas_colp.process()

