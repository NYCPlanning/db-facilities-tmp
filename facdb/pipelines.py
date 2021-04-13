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
@Function1B(
    street_name_field="streetname",
    house_number_field="address_num",
    borough_field="borocode",
)
@FunctionBL(bbl_field="bbl")
@FunctionBN(bin_field="bin")
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
@Prepare
def dsny_mtsgaragemaintenance(df: pd.DataFrame = None):
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
@Prepare
def hra_centers(df: pd.DataFrame = None):
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
@Prepare
def nycha_communitycenters(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nycha_policeservice(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nycourts_courts(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysdec_lands(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysdec_solidwaste(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysdoccs_corrections(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nyshoh_healthfacilities(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysdoh_nursinghomes(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysed_activeinstitutions(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysoasas_programs(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysomh_mentalhealth(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysopwdd_providers(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysparks_historicplaces(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def nysparks_parks(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def qpl_libraries(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def sbs_workforce1(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def uscourts_courts(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def usdot_airports(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def usdot_ports(df: pd.DataFrame = None):
    return df


@Export
@Prepare
def usnps_parks(df: pd.DataFrame = None):
    return df
