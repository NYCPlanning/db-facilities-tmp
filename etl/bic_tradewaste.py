# from dataflows import load, Flow, printer, find_replace, add_field, add_computed_field, filter_rows
from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import re
import csv
import sys
from pathlib import Path
from utils import url, fields, quick_clean, get_hnum, get_sname, get_geocode, geo_flow
csv.field_size_limit(sys.maxsize)

bic_tradewaste = Flow(
        load(url, resources = 'bic_tradewaste', force_strings=False),
        checkpoint('bic_tradewaste'),
        # uid
        add_field('uid', 'string'),
        # uid facname
        add_field('facname', 'string'),
        # factype
        add_field('factype', 'string', 'Trade Waste Carter Site'),
        # facsubgrp
        add_field('facsubgrp', 'string', 'Solid Waste Transfer and Carting'),
        # facgroup
        add_field('facgroup', 'string', 'Solid Waste'),
        # facdomain
        add_field('facdomain', 'string', 'Core Infrastructure and Transportation'),
        # servarea
        add_field('servarea', 'string'),
        # opname
        add_computed_field([dict(target=dict(name = 'opname', type = 'string'),
                                    operation=lambda row: row['bus_name'].title()
                                    )]),
        # opabbrev
        add_field('opabbrev', 'string', 'Non-public'),
        # optype
        add_field('optype', 'string', 'Non-public'), 
        # overagency
        add_field('overagency', 'string', 'NYC Business Integrity Commission'), 
        # overabbrev
        add_field('overabbrev', 'string', 'NYCBIC'),
        # capacity
        add_field('capacity', 'string'),
        # captype
        add_field('captype', 'string'),
        # proptype
        add_field('proptype', 'string'),
        # datasource
        add_field('datasource', 'string', 'bic_tradewaste'),
        # hnum, sname, address, city, zipcode
        add_field('boro', 'string', ''),
        add_computed_field([dict(target=dict(name = 'address', type = 'string'),
                                        operation=lambda row: quick_clean(row['mailing_office'])
                                        ),
                                dict(target=dict(name = 'hnum', type = 'string'),
                                        operation=lambda row: get_hnum(row['address'])
                                        ),
                                dict(target=dict(name = 'sname', type = 'string'),
                                        operation=lambda row: get_sname(row['address'])
                                        ),
                                dict(target=dict(name = 'zipcode', type = 'string'),
                                        operation=lambda row: re.findall(r'\d+', row['location_1'].split('\n')[1])[0]\
                                                                if row['location_1'] is not None else None
                                        )
                        ]),
        geo_flow,
        # rename_field('mail_city', 'city'),
        # select_fields(fields),
        # printer(fields=['address', 'hnum', 'sname', 'zipcode', 'geo']),
        dump_to_postgis()
        )

bic_tradewaste.process()

        