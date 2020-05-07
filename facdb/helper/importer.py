import pandas as pd
from .engines import facdb_engine


def importer(table_name, sql=""):
    if sql == "":
        df = pd.read_sql(f"select * from {table_name}.latest", con=facdb_engine)
    else:
        df = pd.read_sql(sql, con=facdb_engine)
    return df
