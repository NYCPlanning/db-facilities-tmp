from dataflows import *
from lib import dump_to_postgis, rename_field
import os
import csv
import sys
from pathlib import Path
import re
from utils import url

csv.field_size_limit(sys.maxsize)

table_name = 'facilities_classification'
facilities_classification = Flow(
    load(url, resources = table_name),
    dump_to_postgis()
)

facilities_classification.process()

