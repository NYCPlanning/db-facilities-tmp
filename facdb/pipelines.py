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
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="locality",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="address")
@Prepare
def nypl_libraries(df: pd.DataFrame = None):
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
    industry = [
        "Scrap Metal Processor",
        "Parking Lot",
        "Garage",
        "Garage and Parking Lot",
        "Tow Truck Company",
    ]
    today = datetime.datetime.today()
    df.license_expiration_date = pd.to_datetime(
        df["license_expiration_date"], format="%m/%d/%Y"
    )
    # fmt:off
    df = df.loc[df.license_expiration_date >= today, :]\
        .loc[df.industry.isin(industry), :]
    # fmt:on
    return df


@Export
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="address")
@Prepare
def dcla_culturalinstitutions(df: pd.DataFrame = None):
    df["zipcode"] = df.postcode.apply(lambda x: x[:5])
    return df


@Export
@Prepare
def dcp_colp(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="street_name",
    house_number_field="address_number",
    borough_field="borough_name",
    zipcode_field="zip_code",
)
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dcp_pops(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def dcp_sfpsd(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def dep_wwtc(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def dfta_contracts(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def doe_busroutesgarages(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def doe_lcgms(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def doe_universalprek(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def dohmh_daycare(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boroname",
)
@FunctionBL(bbl_field="bbl")
@ParseAddress(raw_address_field="site")
@Prepare
def dot_bridgehouses(df: pd.DataFrame = None):
    df["address"] = df.address.astype(str).replace("n/a", None)
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boroname",
)
@FunctionBL(bbl_field="bbl")
@ParseAddress(raw_address_field="address")
@Prepare
def dot_ferryterminals(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boroname",
)
@FunctionBL(bbl_field="bbl")
@ParseAddress(raw_address_field="address")
@Prepare
def dot_mannedfacilities(df: pd.DataFrame = None):
    df["address"] = df.address.astype(str)
    return df


@Export
@Prepare
def dot_pedplazas(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boroname",
)
@FunctionBL(bbl_field="bbl")
@ParseAddress(raw_address_field="address")
@Prepare
def dot_publicparking(df: pd.DataFrame = None):
    df["address"] = df.address.astype(str)
    return df


@Export
@Prepare
def dpr_parksproperties(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boro",
    zipcode_field="zip",
)
@ParseAddress(raw_address_field="address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dsny_garages(df: pd.DataFrame = None):
    df["address"] = df.address.astype(str)
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="boro",
    zipcode_field="zip",
)
@ParseAddress(raw_address_field="address")
@Prepare
def dsny_specialwastedrop(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zip",
)
@ParseAddress(raw_address_field="address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dsny_textiledrop(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="street",
    house_number_field="number",
    borough_field="borough",
    zipcode_field="zipcode",
)
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dsny_leafdrop(df: pd.DataFrame = None):
    df["bbl"] = df.bbl.fillna(0).astype(float).astype(int)
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="zip_code",
)
@ParseAddress(raw_address_field="location")
@Prepare
def dsny_fooddrop(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="street",
    house_number_field="number",
    borough_field="borough",
    zipcode_field="zipcode",
)
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def dsny_electronicsdrop(df: pd.DataFrame = None):
    df["bbl"] = df.bbl.fillna(0).astype(float).astype(int)
    return df


@Export
@Prepare
def dycd_afterschoolprogram(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def fbop_corrections(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def fdny_firehouses(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def foodbankny_foodbanks(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def hhc_hospitals(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="postcode",
)
@ParseAddress(raw_address_field="street_address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def hra_snapcenters(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="postcode",
)
@ParseAddress(raw_address_field="street_address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def hra_jobcenters(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="postcode",
)
@ParseAddress(raw_address_field="office_address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def hra_medicaid(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def moeo_socialservicesitelocations(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nycdoc_corrections(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
)
@ParseAddress(raw_address_field="address")
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
@Prepare
def nycha_communitycenters(df: pd.DataFrame = None):
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
def nycha_policeservice(df: pd.DataFrame = None):
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
def nycourts_courts(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysdec_lands(df: pd.DataFrame = None):
    df = df[df.county.isin(["NEW YORK", "KINGS", "BRONX", "QUEENS", "RICHMOND"])]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="county",
    zipcode_field="zip_code",
)
@ParseAddress(raw_address_field="location_address")
@Prepare
def nysdec_solidwaste(df: pd.DataFrame = None):
    df = df[df.county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])]
    return df


@Export
@Function1B(
    street_name_field="street_name",
    house_number_field="house_number",
    borough_field="county",
    zipcode_field="zipcode",
)
@Prepare
def nysdoccs_corrections(df: pd.DataFrame = None):
    df["zipcode"] = df.zipcode.apply(lambda x: x[:5])
    df = df[df.county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="facility_county",
    zipcode_field="facility_zip_code",
)
@ParseAddress(raw_address_field="facility_address_1")
@Prepare
def nysdoh_healthfacilities(df: pd.DataFrame = None):
    df = df[
        df.facility_county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])
    ]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="county",
    zipcode_field="zip",
)
@ParseAddress(raw_address_field="street_address")
@Prepare
def nysdoh_nursinghomes(df: pd.DataFrame = None):
    df = df[df.county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="county_description",
    zipcode_field="physical_zipcd5",
)
@ParseAddress(raw_address_field="physical_address_line1")
@Prepare
def nysed_activeinstitutions(df: pd.DataFrame = None):
    df = df[
        df.county_description.isin(["NEW YORK", "KINGS", "BRONX", "QUEENS", "RICHMOND"])
    ]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="program_county",
    zipcode_field="program_zip_code",
)
@ParseAddress(raw_address_field="program_street_address")
@Prepare
def nysoasas_programs(df: pd.DataFrame = None):
    df = df[
        df.program_county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])
    ]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="program_county",
    zipcode_field="program_zip"
)
@ParseAddress(raw_address_field="program_address_1")
@Prepare
def nysomh_mentalhealth(df: pd.DataFrame = None):
    df = df[
        df.program_county.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"])
    ]
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="county",
    zipcode_field="zip_code"
)
@ParseAddress(raw_address_field="street_address")
@Prepare
def nysopwdd_providers(df: pd.DataFrame = None):
    df = df[
        df.county.isin(["BRONX", "NEW YORK", "KINGS", "QUEENS", "RICHMOND"])
    ]
    return df


@Export
@Prepare
def nysparks_historicplaces(df: pd.DataFrame = None):
    df = df[
        df.county.isin(["Bronx", "New York", "Kings", "Queens", "Richmond"])
    ]
    return df


@Export
@Prepare
def nysparks_parks(df: pd.DataFrame = None):
    df = df[
        df.county.isin(["Bronx", "New York", "Kings", "Queens", "Richmond"])
    ]
    return df

@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    borough_field="borough",
    zipcode_field="postcode",
)
@FunctionBN(bin_field="bin")
@FunctionBL(bbl_field="bbl")
@ParseAddress(raw_address_field="address")
@Prepare
def qpl_libraries(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="street",
    house_number_field="number",
    borough_field="borough",
    zipcode_field="postcode",
)
@FunctionBN(bin_field="bin")
@FunctionBL(bbl_field="bbl")
@Prepare
def sbs_workforce1(df: pd.DataFrame = None):
    return df


@Export
@Function1B(
    street_name_field="parsed_sname",
    house_number_field="parsed_hnum",
    zipcode_field="zipcode",
)
@ParseAddress(raw_address_field="buildingaddress")
@Prepare
def uscourts_courts(df: pd.DataFrame = None):
    df["zipcode"] = df.buildingzip.apply(lambda x: x[:5])
    return df


@Export
@Prepare
def usdot_airports(df: pd.DataFrame = None):
    df = df[
        (df.state_name == "NEW YORK")
        & (df.county.isin(["NEW YORK", "KINGS", "BRONX", "QUEENS", "RICHMOND"]))
    ]
    return df


@Export
@Prepare
def usdot_ports(df: pd.DataFrame = None):
    df = df[
        (df.state_post == "NY")
        & (df.county_nam.isin(["New York", "Kings", "Bronx", "Queens", "Richmond"]))
    ]
    return df


@Export
@Prepare
def usnps_parks(df: pd.DataFrame = None):
    df = df[df.state == "NY"]
    return df
