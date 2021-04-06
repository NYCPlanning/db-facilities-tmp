from functools import wraps

import pandas as pd
import simplejson as json
from tqdm.contrib.concurrent import process_map

from . import GeosupportError, g


class Function1B:
    def __init__(
        self,
        street_name_field: str = None,
        house_number_field: str = None,
        borough_field: str = None,
        zipcode_field: str = None,
    ):
        self.street_name_field = street_name_field
        self.house_number_field = house_number_field
        self.borough_field = borough_field
        self.zipcode_field = zipcode_field

    def geocode_a_dataframe(self, df: pd.DataFrame):
        records = df.to_dict("records")
        it = process_map(self.geocode_one_record, records, chunksize=1000)
        df_geo = pd.DataFrame(it)
        return df.merge(df_geo, how="left", on="uid", suffixes=("", "_"))

    def geocode_one_record(self, inputs: dict) -> dict:
        """
        Note that df needs
        """
        uid = inputs.get("uid")
        input_sname = inputs.get("input_sname")
        input_hnum = inputs.get("input_hnum")
        input_borough = inputs.get("input_borough")
        input_zipcode = inputs.get("input_zipcode")
        try:
            geo = g["1B"](
                street_name=input_sname,
                house_number=input_hnum,
                borough=input_borough,
                zip_code=input_zipcode,
            )
        except GeosupportError as e:
            geo = e.result

        geo = self.parser(geo)
        return dict(
            uid=uid,
            geo_1b=json.dumps(
                dict(
                    inputs=dict(
                        input_sname=input_sname,
                        input_hnum=input_hnum,
                        input_borough=input_borough,
                        input_zipcode=input_zipcode,
                    ),
                    result=geo,
                ),
                ignore_nan=True,
            ),
        )

    def parser(self, geo):
        return dict(
            geo_house_number=geo.get("House Number - Display Format", ""),
            geo_street_name=geo.get("First Street Name Normalized", ""),
            geo_borough_code=geo.get("BOROUGH BLOCK LOT (BBL)", {}).get(
                "Borough Code", ""
            ),
            geo_zip_code=geo.get("ZIP Code", ""),
            geo_bin=geo.get(
                "Building Identification Number (BIN) of Input Address or NAP", ""
            ),
            geo_bbl=geo.get("BOROUGH BLOCK LOT (BBL)", {}).get(
                "BOROUGH BLOCK LOT (BBL)", ""
            ),
            geo_latitude=geo.get("Latitude", ""),
            geo_longitude=geo.get("Longitude", ""),
            geo_city=geo.get("USPS Preferred City Name", ""),
            geo_xy_coord=geo.get("Spatial X-Y Coordinates of Address", ""),
            geo_commboard=geo.get("COMMUNITY DISTRICT", {}).get(
                "COMMUNITY DISTRICT", ""
            ),
            geo_nta=geo.get("Neighborhood Tabulation Area (NTA)", ""),
            geo_council=geo.get("City Council District", ""),
            geo_censtract=geo.get("2010 Census Tract", ""),
            geo_grc=geo.get("Geosupport Return Code (GRC)", ""),
            geo_grc2=geo.get("Geosupport Return Code 2 (GRC 2)", ""),
            geo_reason_code=geo.get("Reason Code", ""),
            geo_message=geo.get("Message", "msg err"),
            geo_policeprct=geo.get("Police Precinct", ""),
            geo_schooldist=geo.get("Community School District", ""),
        )

    def __call__(self, func):
        def wrapper(*args, **kwargs):
            df = func()
            df["input_sname"] = df[self.street_name_field]
            df["input_hnum"] = df[self.house_number_field]
            df["input_borough"] = df[self.borough_field]
            df["input_zipcode"] = df[self.zipcode_field]
            df = self.geocode_a_dataframe(df)
            return df

        return wrapper
