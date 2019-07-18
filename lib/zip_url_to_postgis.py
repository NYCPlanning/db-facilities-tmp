import os
import logging
import mimetypes
from lib.parse_engine import parse_engine
from osgeo import ogr
from osgeo import gdal
from pathlib import Path

def zip_url_to_postgis(url, table_name):
    engine = parse_engine(os.environ.get('DATAFLOWS_DB_ENGINE'))
    dstDS = gdal.OpenEx(engine, gdal.OF_VECTOR)
    srcDS = gdal.OpenEx(f'/vsizip//vsicurl/{url}')
    gdal.VectorTranslate(
        dstDS,
        srcDS,
        geometryType = 'Multipolygon',
        layerCreationOptions = ['precision=NO'],
        format='PostgreSQL',
        srcSRS='EPSG:2263', 
        dstSRS='EPSG:4326',
        layerName=table_name,
        accessMode='overwrite')

def url_to_postgis(url, table_name):
    engine = parse_engine(os.environ.get('DATAFLOWS_DB_ENGINE'))
    dstDS = gdal.OpenEx(engine, gdal.OF_VECTOR)
    srcDS = gdal.OpenEx(f'/vsicurl/{url}', open_options=['AUTODETECT_TYPE=NO', 'EMPTY_STRING_AS_NULL=YES', 'GEOM_POSSIBLE_NAMES=the_geom'])
    gdal.VectorTranslate(
        dstDS,
        srcDS,
        layerCreationOptions = ['precision=NO'],
        format='PostgreSQL',
        srcSRS='EPSG:4326', 
        dstSRS='EPSG:4326',
        layerName=table_name,
        accessMode='overwrite')