from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import datetime
import numpy as np

if __name__ == "__main__":
    table_name = "doe_busroutesgarages"
    SCHOOL_YEAR = f"{datetime.date.today().year-1}-{datetime.date.today().year}"
    print(f"current school year is {SCHOOL_YEAR}")

    df = importer(table_name)

    ## Filter table based on school year
    df = df[df.school_year == SCHOOL_YEAR]
    df["datasource"] = table_name
    df["address"] = df["garage__street_address"].apply(quick_clean)
    df["sname"] = df["address"].apply(get_sname)
    df["hnum"] = df["address"].apply(get_hnum)
    df = df.rename(columns={"garage_zip": "zipcode"})
    records = df.to_dict("records")

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)

    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)
