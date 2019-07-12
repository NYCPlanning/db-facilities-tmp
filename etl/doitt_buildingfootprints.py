from dataflows import *
from lib import dump_to_postgis
import csv
import sys
from utils import url

csv.field_size_limit(sys.maxsize)

table_name = 'doitt_buildingfootprints'
doitt_buildingfootprints = Flow(
    load(url, resources = table_name),
    add_field('datasource', 'string', table_name),
    dump_to_postgis()
)

doitt_buildingfootprints.process()
