import datetime

import pandas as pd

from . import Export, Function1B, FunctionBL, FunctionBN, ParseAddress, Prepare


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="address")
@Prepare
def bpl_libraries(df: pd.DataFrame = None):
    df["longitude"] = df.position.apply(lambda x: x.split(",")[1].strip())
    df["latitude"] = df.position.apply(lambda x: x.split(",")[0].strip())
    df["zipcode"] = df.address.apply(lambda x: x[-6:])
    df["borough"] = "Brooklyn"
    return df


@Export
@Prepare
def dcp_colp(df: pd.DataFrame = None):
    """
    Example for dcp_colp, no geocoding is needed for this table
    """
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="address")
@Prepare
def nypl_libraries(df: pd.DataFrame = None):
    df["borough"] = "Manhattan"
    df["latitude"] = df.lat
    df["longitude"] = df.lon
    return df


@Export
@Function1B(
    street_name_field="address_street_name",
    house_number_field="address_building",
    borough_field="address_borough",
    zipcode_field="address_zip",
)
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dca_operatingbusinesses(df: pd.DataFrame = None):
    df.license_expiration_date = pd.to_datetime(
        df["license_expiration_date"], format="%m/%d/%Y"
    )
    df = df.loc[df.license_expiration_date >= datetime.datetime.today(), :]
    return df
