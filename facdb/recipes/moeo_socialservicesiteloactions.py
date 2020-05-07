from facdb.helper.engines import facdb_engine
from facdb.helper.exporter import exporter
from facdb.helper.importer import importer
from multiprocessing import Pool, cpu_count
from facdb.helper.geocode import geocode, get_hnum, get_sname, quick_clean
import pandas as pd
import numpy as np
from pathlib import Path

if __name__ == "__main__":
    table_name = "moeo_socialservicesiteloactions"
    df = importer(table_name)
    df["datasource"] = table_name
    classification = pd.read_csv(
        Path(__file__).parent.parent.parent
        / "referencetables/moeo_socialservicesiteloactions_classification.csv"
    )

    df = pd.merge(df, classification, how="left", on="program_name")
    df = df.rename(
        columns={"street_number": "hnum", "street_name": "sname", "site_boro": "boro"}
    )
    records = df.to_dict("records")

    ## geocode
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 1000)

    df = pd.DataFrame(it)

    ## Export to build engine
    exporter(df, table_name)
