from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import re
import csv
import sys
from utils import url, fields, get_geocode, get_the_geom

csv.field_size_limit(sys.maxsize)

def get_facname(center_name, legal_name):
    if re.match(r'(SBCC|SCHOOL BASED CHILD CARE)', center_name):
        return legal_name.title()
    else: 
        return center_name.title()

def get_factype(facility_type, program_type): 
    facility = facility_type.lower().replace(' ', '_')
    program = program_type.lower().replace(' ', '_')
    rules = dict(
        camp = dict(
            all_age_camp = 'Camp - All Age', 
            school_age_camp = 'Camp - School Age'
        ), 
        gdc = {
            'child_care_-_infants/toddlers' : 'Group Day Care - Infants/Toddlers',
            'infant_toddler' : 'Group Day Care - Infants/Toddlers', 
            'child_care_-_pre_school' : 'Group Day Care - Preschool', 
            'preschool' : 'Group Day Care - Preschool'
        },
        sbcc = dict(
            preschool = 'School Based Child Care - Preschool', 
            infant_toddler = 'School Based Child Care - Infants/Toddlers'
        ),
        default = dict(
            sbcc = 'School Based Child Care - Age Unspecified', 
            gdc = 'Group Day Care - Age Unspecified'
        )
    )
    if program == 'preschool_camp': 
        return 'Camp - Preschool Age'
    else: 
        factype = rules.get(facility, ' - '.join([facility_type, program_type]))\
                    .get(program, rules['default'].get(facility))
        return factype

def get_captype(program_type): 
    p = program_type.lower()
    if re.match('infant', p):
        return 'Infant and toddler maxiumum capacity calculated by DOHMH'
    elif re.match('preschool', p):
        return 'Preschooler maxiumum capacity calculated by DOHMH'
    else: 
        return 'Maxiumum child capacity calculated by DOHMH'

table_name = 'dohmh_daycare'

dohmh_daycare = Flow(
    load(url, resources = table_name, force_strings=False),
    checkpoint(table_name),
    # uid text,
    add_field('uid', 'string'),
    # facname factype facgroup facsubgrp
    add_computed_field([dict(target=dict(name = 'facname', type = 'string'),
                                        operation = \
                                            lambda row: get_facname(row['center_name'], row['legal_name'])
                                        ),
                        dict(target=dict(name = 'factype', type = 'string'),
                                        operation = \
                                            lambda row: get_factype(row['facility_type'], row['program_type'])
                                        ), 
                        dict(target=dict(name = 'facgroup', type = 'string'),
                                        operation = \
                                            lambda row: 'Camps' if re.match('camp',row['facility_type']+row['program_type'].lower())\
                                                    else 'Day Care and Pre-Kindergarten'
                                        ),
                        dict(target=dict(name = 'facsubgrp', type = 'string'),
                                        operation = \
                                            lambda row: 'Camps' if row['facgroup'] == 'Camps'
                                                    else 'Day Care'
                                        ),
                        ]),
    # facdomain
    add_field('facdomain', 'string', 'Education, Child Welfare, and Youth'),
    # servarea
    add_field('servarea', 'string'),
    # opname text,
    add_computed_field([dict(target=dict(name = 'opname', type = 'string'),
                                        operation = \
                                            lambda row: row['legal_name'].title()
                                        )
                        ]),
    # opabbrev text,
    add_field('opabbrev', 'string', 'Non-public'), 
    # optype text,
    add_field('optype', 'string', 'Non-public'), 
    # overagency text,
    add_field('overagency', 'string', 'NYC Department of Health and Mental Hygiene'), 
    # overabbrev text,
    add_field('overabbrev', 'string', 'NYCDOHMH'),
    # overlevel text,
    add_field('overlevel', 'string'),
    # capacity captype 
    add_computed_field([dict(target=dict(name = 'capacity', type = 'string'),
                                        operation = \
                                            lambda row: str(row['maximum_capacity']) if row['maximum_capacity'] != 0 else None
                                        ),
                        dict(target=dict(name = 'captype', type = 'string'),
                                        operation = \
                                            lambda row: get_captype(row['program_type'])
                                        )
                        ]),
    # proptype text,
    # datasource text,
    add_field('datasource', 'string', table_name),

    ################################### Spatial #################################
    # hnum text,
    rename_field('building', 'hnum'),
    # sname text,
    rename_field('street', 'sname'),
    # address text,
    # city text,
    # zipcode --> no action needed
    # boro text,
    rename_field('borough', 'boro'), 
    add_computed_field([dict(target=dict(name = 'geo', type = 'object'),
                                        operation=lambda row: get_geocode(row['hnum'], row['sname'], row['boro'], '')
                                        ),
                        dict(target=dict(name = 'results', type = 'object'),
                                        operation=lambda row: row['geo'].get('results', {})
                                        ),
                        dict(target=dict(name = 'street_name', type = 'string'),
                                        operation=lambda row: row['results'].get('First Street Name Normalized', '')
                                        ),
                        dict(target=dict(name = 'house_number', type = 'string'),
                                        operation=lambda row: row['results'].get('House Number - Display Format', '')
                                        ),
                        dict(target=dict(name = 'borough_code', type = 'string'),
                                        operation=lambda row: row['results'].get('BOROUGH BLOCK LOT (BBL)', {})\
                                                                            .get('Borough Code', '')
                                        ),
                         dict(target=dict(name = 'zip_code', type = 'string'),
                                        operation=lambda row: row['results'].get('ZIP Code', '')
                                        ),
                        dict(target=dict(name = 'bin', type = 'string'),
                                        operation=lambda row: row['results']\
                                            .get('Building Identification Number (BIN) of Input Address or NAP', '')
                                        ),
                        dict(target=dict(name = 'bbl', type = 'string'),
                                        operation=lambda row: row['results'].get('BOROUGH BLOCK LOT (BBL)', {})\
                                                                            .get('BOROUGH BLOCK LOT (BBL)', '')
                                        ),
                        dict(target=dict(name = 'latitude', type = 'string'),
                                        operation=lambda row: row['results'].get('Latitude', '')
                                        ),
                        dict(target=dict(name = 'longitude', type = 'string'),
                                        operation=lambda row: row['results'].get('Longitude', '')
                                        ),
                        # dict(target=dict(name = 'xcoord', type = 'string'),
                        #                 operation=lambda row: row['results'].get('Longitude', '')
                        #                 ),
                        # dict(target=dict(name = 'ycoord', type = 'string'),
                        #                 operation=lambda row: row['results'].get('Longitude', '')
                        #                 ),
                        dict(target=dict(name = 'commboard', type = 'string'),
                                        operation=lambda row: row['results'].get('COMMUNITY DISTRICT', {})\
                                                                            .get('COMMUNITY DISTRICT', '')
                                        ),
                        dict(target=dict(name = 'nta', type = 'string'),
                                        operation=lambda row: row['results'].get('Neighborhood Tabulation Area (NTA)', '')
                                        ), 
                        dict(target=dict(name = 'council', type = 'string'),
                                        operation=lambda row: row['results'].get('City Council District', '')
                                        ),
                        dict(target=dict(name = 'censtract', type = 'string'),
                                        operation=lambda row: row['results'].get('2010 Census Tract', '')
                                        ),
                        dict(target=dict(name = 'the_geom', type = 'string'),
                                        operation=lambda row: get_the_geom(row['longitude'], row['latitude'])
                                        ),
                        ]),
    delete_fields(fields=['results']),
    checkpoint(table_name+'1'),
    dump_to_postgis()    
)

dohmh_daycare.process()

