import pandas as pd

from . import Export, Function1B, ParseAddress, Prepare


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="address")
@Prepare(version="testor")
def bpl_libraries(df: pd.DataFrame = None):
    df["longitude"] = df.position.apply(lambda x: x.split(",")[1].strip())
    df["latitude"] = df.position.apply(lambda x: x.split(",")[0].strip())
    df["zipcode"] = df.address.apply(lambda x: x[-6:])
    df["borough"] = "Brooklyn"
    return df


if __name__ == "__main__":
    df = bpl_libraries()
