from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np

if __name__ == "__main__":
    table_name = "dsny_mtsgaragemaintenance"
    df = importer(
        table_name,
        sql=f"select st_astext(wkb_geometry) as wkt, * from {table_name}.latest",
    )
    df["wkb_geometry"] = df["wkt"]
    df["datasource"] = table_name
    df["address"] = df["address"].apply(quick_clean)
    df["sname"] = df["address"].apply(get_sname)
    df["hnum"] = df["address"].apply(get_hnum)
    df = df.rename(columns={"zip": "zipcode", "wkt": "location"})
    records = df.to_dict("records")

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)

    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)