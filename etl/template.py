from dataflows import load, Flow, printer, find_replace
from dataflows import add_field, add_computed_field, filter_rows
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url

csv.field_size_limit(sys.maxsize)

dohmh_daycare = Flow(
    load(url, resources = 'dohmh_daycare', force_strings=False),
    # uid text,
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
    # datasource text,
    # geom text
    printer(num_rows=3)      
)

dohmh_daycare.process()

