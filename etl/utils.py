import usaddress
import re
import json 
import requests
import urllib
from shapely.geometry import Point
from dataflows import *
from lib import get_pipeline_url

# url = get_pipeline_url('pipelines/db-facilities')
url = 'https://db-data-recipes.sfo2.digitaloceanspaces.com/pipelines/db-facilities/2019-08-26/datapackage.json'

def convert_to_boro(county):
        if county.upper() == 'NEW YORK': return 'MN'
        if county.upper() == 'KINGS': return 'BK'
        if county.upper() == 'BRONX': return 'BX'
        if county.upper() == 'QUEENS': return 'QN'
        if county.upper() == 'RICHMOND': return 'SI'

def get_the_geom(lon, lat): 
        lon = float(lon) if lon != '' else None
        lat = float(lat) if lat != '' else None
        if (lon is not None) and (lat is not None): 
                return str(Point(lon, lat))

def quick_clean(address):
        address = '-'.join([i.strip() for i in address.split('-')]) if address is not None else ''
        result = [k for (k,v) in usaddress.parse(address) \
                if not v in \
                ['OccupancyIdentifier', 'OccupancyType']]
        return re.sub(r'[,\%\$\#\@\!\_\.\?\`\"\(\)\ï\¿\½]', '', ' '.join(result))
                
def get_hnum(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Address", v)]  if address is not None else ''
        return ' '.join(result)

def get_sname(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Street", v)]  if address is not None else ''
        return ' '.join(result)

def get_geocode(hnum, sname, boro, zipcode):
        # base_url = 'http://0.0.0.0:5000/1b?'
        base_url = 'http://0.0.0.0:5000/geocode/1b?'
        # base_url = 'http://api-geosupport.planninglabs.nyc:5000/1b?'
        # make sure there's no None involved
        hnum = str(hnum) if hnum is not None else ''
        sname = str(sname) if sname is not None else ''
        boro = str(boro) if boro is not None else ''
        zipcode = str(zipcode) if zipcode is not None else ''
        
        params = f'house_number={hnum}&street_name={sname}&borough={boro}&zip_code={zipcode}'
        url = base_url + params
        response = requests.get(url)
        result = json.loads(response.content)
        return json.loads(response.content)

geo_flow = Flow(
                add_computed_field([dict(target=dict(name = 'geo', type = 'object'),
                                                operation=lambda row: get_geocode(row['hnum'], row['sname'], row['boro'], row['zipcode'])
                                                ),
                                dict(target=dict(name = 'results', type = 'object'),
                                                operation=lambda row: row['geo'].get('result', {})
                                                ),
                                dict(target=dict(name = 'geo_street_name', type = 'string'),
                                                operation=lambda row: row['results'].get('First Street Name Normalized', '')
                                                ),
                                dict(target=dict(name = 'geo_house_number', type = 'string'),
                                                operation=lambda row: row['results'].get('House Number - Display Format', '')
                                                ),
                                dict(target=dict(name = 'geo_borough_code', type = 'string'),
                                                operation=lambda row: row['results'].get('Borough Code', '')
                                                ),
                                dict(target=dict(name = 'geo_zip_code', type = 'string'),
                                                operation=lambda row: row['results'].get('ZIP Code', '')
                                                ),
                                dict(target=dict(name = 'geo_bin', type = 'string'),
                                                operation=lambda row: row['results']\
                                                .get('Building Identification Number (BIN) of Input Address or NAP', '')
                                                ),
                                dict(target=dict(name = 'geo_bbl', type = 'string'),
                                                operation=lambda row: row['results'].get('BOROUGH BLOCK LOT (BBL)', '')
                                                ),
                                dict(target=dict(name = 'geo_latitude', type = 'string'),
                                                operation=lambda row: row['results'].get('Latitude', '')
                                                ),
                                dict(target=dict(name = 'geo_longitude', type = 'string'),
                                                operation=lambda row: row['results'].get('Longitude', '')
                                                ),
                                dict(target=dict(name = 'geo_city', type = 'string'),
                                                operation=lambda row: row['results'].get('USPS Preferred City Name', '')
                                                ),
                                dict(target=dict(name = 'geo_xy_coord', type = 'string'),
                                                operation=lambda row: row['results'].get('Spatial X-Y Coordinates of Address', '')
                                                ),
                                dict(target=dict(name = 'geo_commboard', type = 'string'),
                                                operation=lambda row: row['results'].get('COMMUNITY DISTRICT', '')
                                                ),
                                dict(target=dict(name = 'geo_nta', type = 'string'),
                                                operation=lambda row: row['results'].get('Neighborhood Tabulation Area (NTA)', '')
                                                ), 
                                dict(target=dict(name = 'geo_council', type = 'string'),
                                                operation=lambda row: row['results'].get('City Council District', '')
                                                ),
                                dict(target=dict(name = 'geo_censtract', type = 'string'),
                                                operation=lambda row: row['results'].get('2010 Census Tract', '')
                                                ),
                                dict(target=dict(name = 'geo_grc', type = 'string'),
                                                operation=lambda row: row['results'].get('Geosupport Return Code (GRC)', '')
                                                ),
                                dict(target=dict(name = 'geo_grc2', type = 'string'),
                                                operation=lambda row: row['results'].get('Geosupport Return Code 2 (GRC 2)', '')
                                                ),
                                dict(target=dict(name = 'geo_policeprct', type = 'string'),
                                                operation=lambda row: row['results'].get('Police Precinct', '')
                                                ),
                                dict(target=dict(name = 'geo_schooldist', type = 'string'),
                                                operation=lambda row: row['results'].get('Community School District', '')
                                                ),     
                                ]),
                delete_fields(fields=['results']),
        )