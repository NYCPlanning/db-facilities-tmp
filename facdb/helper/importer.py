import pandas as pd
from .engines import facdb_engine

def importer(table_name, from_url=True, sql=''):
    if from_url:
        url = f'https://db-data-recipes.sfo2.digitaloceanspaces.com/pipelines/db-facilities/2019-08-26/{table_name}.csv'
        df = pd.read_csv(url, dtype=str)
        df = df.fillna('')
        return df
    else:
        if sql == '':
            df = pd.read_sql(f'select * from {table_name}.latest', con = facdb_engine)
        else: 
            df = pd.read_sql(sql, con = facdb_engine)
        return df
