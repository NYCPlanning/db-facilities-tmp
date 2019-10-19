import pandas as pd

def importer(table_name):
    url = f'https://db-data-recipes.sfo2.digitaloceanspaces.com/pipelines/db-facilities/2019-08-26/{table_name}.csv'
    df = pd.read_csv(url, dtype=str)
    df = df.fillna('')
    return df