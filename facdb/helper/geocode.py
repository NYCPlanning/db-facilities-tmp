from geosupport import Geosupport, GeosupportError
import usaddress
import re
import os
from shapely.geometry import Point

g = Geosupport()

def geocode_percentage(df, table_name): 
    nrow = df.shape[0]
    geocoded = df[df.geo_latitude != ''].shape[0]
    os.system(f'printf "\e[1;33m%-32s\e[m geocoded pct: \e[1;33m%s\e[m\n" "{table_name}" "{round(geocoded/nrow*100, 2)}"')

def get_hnum(address):
    address = '' if address is None else quick_clean(address)
    result = [k for (k,v) in usaddress.parse(address) \
            if re.search("Address", v)]  if address is not None else ''
    result = ' '.join(result)
    if result == '':
        return address
    else: 
        return result

def get_sname(address):
    address = '' if address is None else quick_clean(address)
    result = [k for (k,v) in usaddress.parse(address) \
            if re.search("Street", v)]  if address is not None else ''
    result = ' '.join(result)
    return result

def quick_clean(address):
    address = '-'.join([i.strip() for i in address.split('-')]) if address is not None else ''
    result = [k for (k,v) in usaddress.parse(address) \
            if not v in \
            ['OccupancyIdentifier', 'OccupancyType']]
    return re.sub(r'[,\%\$\#\@\!\_\.\?\`\"\(\)\ï\¿\½]', '', ' '.join(result))

def create_geom(lon, lat):
        lon = float(lon) if lon != '' else None
        lat = float(lat) if lat != '' else None
        if (lon is not None) and (lat is not None): 
                return str(Point(lon, lat))

def geocode(inputs):
    hnum = inputs.get('hnum', '')
    sname = inputs.get('sname', '')
    borough = inputs.get('boro', '')
    zip_code = inputs.get('zip_code', '')

    hnum = str('' if hnum is None else hnum)
    sname = str('' if sname is None else sname)
    borough = str('' if borough is None else borough)
    zip_code = str('' if zip_code is None else zip_code)

    try:
        geo = g['1B'](street_name=sname, house_number=hnum, borough=borough, zip_code=zip_code)
    except GeosupportError as e:
        geo = e.result
    
    geo = parser(geo)
    geo.update(inputs)
    return geo

def get_the_geom(lon, lat): 
        lon = float(lon) if lon != '' else None
        lat = float(lat) if lat != '' else None
        if (lon is not None) and (lat is not None): 
                return str(Point(lon, lat))

def parser(geo): 
    latitude = geo.get('Latitude', '')
    longitude = geo.get('Longitude', '')
    the_geom = get_the_geom(longitude, latitude)
    
    return dict(
        geo_house_number = geo.get('House Number - Display Format', ''),
        geo_street_name = geo.get('First Street Name Normalized', ''),
        geo_borough_code = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('Borough Code', ''),
        geo_zip_code = geo.get('ZIP Code', ''),
        geo_bin = geo.get('Building Identification Number (BIN) of Input Address or NAP', ''),
        geo_bbl = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('BOROUGH BLOCK LOT (BBL)', '',),
        geo_latitude = latitude,
        geo_longitude = longitude,
        geo_city = geo.get('USPS Preferred City Name', ''),
        geo_xy_coord = geo.get('Spatial X-Y Coordinates of Address', ''),
        geo_commboard = geo.get('COMMUNITY DISTRICT', {}).get('COMMUNITY DISTRICT', ''),
        geo_nta = geo.get('Neighborhood Tabulation Area (NTA)', ''),
        geo_council = geo.get('City Council District', ''),
        geo_censtract = geo.get('2010 Census Tract', ''),
        geo_grc = geo.get('Geosupport Return Code (GRC)', ''),
        geo_grc2 = geo.get('Geosupport Return Code 2 (GRC 2)', ''),
        geo_policeprct = geo.get('Police Precinct', ''),
        geo_schooldist = geo.get('Community School District', ''),
        wkb_geometry = the_geom
    )