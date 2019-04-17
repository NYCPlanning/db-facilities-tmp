import usaddress
import re
import json 
import requests
import urllib

fields = ['uid', 'facname', 
        'factype', 'facsubgrp', 
        'facgroup', 'facdomain', 
        'servarea', 'opname', 
        'opabbrev', 'optype', 
        'overagency', 'overabbrev', 
        'overlevel', 'capacity', 
        'captype', 'proptype', 
        'hnum', 'sname',
        'address', 'city', 
        'zipcode', 'boro', 
        'bin', 'bbl', 
        'latitude', 'longitude', 
        'xcoord', 'ycoord', 
        'commboard', 'nta', 
        'council', 'censtract', 
        'datasource', 'geom']

url = 'https://sptkl.sfo2.digitaloceanspaces.com/pipelines/db-facilities/2019-04-10/datapackage.json'

def quick_clean(address):
        address = '-'.join([i.strip() for i in address.split('-')])
        result = [k for (k,v) in usaddress.parse(address) \
                if not v in \
                 ['OccupancyIdentifier', 'OccupancyType']]
        return re.sub(r'[,\%\$\#\@\!\_\.\?\`]', '', ' '.join(result))

def get_hnum(address): 
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Address", v)]
        return ' '.join(result)

def get_sname(address): 
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Street", v)]
        return ' '.join(result)

def get_geocode(hnum, sname, boro, zipcode):
        base_url = 'http://0.0.0.0:5000/1b?'
        # make sure there's no None involved
        hnum = str(hnum) if hnum is not None else ''
        sname = str(sname) if sname is not None else ''
        boro = str(boro) if boro is not None else ''
        zipcode = str(zipcode) if zipcode is not None else ''
        
        params = f'house_number={hnum}&street_name={sname}&borough={boro}&zipcode={zipcode}'
        url = base_url + params
        response = requests.get(url)
        return json.loads(response.content)

