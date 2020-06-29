---
name: Update
about: "{VERSION} Update"
title: "[UPDATE]"
labels: ''
assignees: ''

---

# Data Loading

- [ ]  *acs_daycareheadstart*
    + status: NA
    + comments: discontinued, we are no longer using this data source
- [ ]  bpl_libraries
    + status: updated
- [ ]  dca_operatingbusinesses
    + status: updated
- [ ]  dcas_colp
    + status: NA
    + comments: no new version of COLP released yet (using 2018 November version on Bytes)
- [ ]  dcla_culturalinstitutions
    + status: updated
- [ ]  dcp_pops
    + status: updated
    + comments: downloaded from the POPS app
- [ ]  dep_wwtc
    + status: NA
    + comments: this dataset doesn't need updates
- [ ]  dfta_contracts
    + status: updated
- [ ]  doe_busroutesgarages
    + status: updated
- [ ]  doe_lcgms
    + status: updated
    + comments: this dataset is updated for CEQR
- [ ]  sca_enrollment_capacity
    + status: updated
- [ ]  doe_universalprek
    + status: updated
- [ ]  dohmh_daycare
    + status: updated
- [ ]  *__dot_bridgehouses__*
    + status: NA 
    + comments: might need refresh from FTP
- [ ]  *__dot_ferryterminals__*
    + status: NA 
    + comments: might need refresh from FTP
- [ ]  *__dot_mannedfacilities__*
    + status: NA 
    + comments: might need refresh from FTP
- [ ]  *__dot_pedplazas__*
    + status: NA 
    + comments: might need refresh from FTP
- [ ]  *__dot_publicparking__*
    + status: NA 
    + comments: might need refresh from FTP
- [ ]  dpr_parksproperties
    + status: updated
- [ ]  *__dsny_mtsgaragemaintenance__*
    + status: NA
    + comments: might need refresh from FTP
- [ ]  dycd_afterschoolprograms
    + status: updated
- [ ]  fbop_corrections
    + status: NA
    + comments: doesn't need update, no new facilities added
- [ ]  fdny_firehouses
    + status: updated
- [ ]  *__foodbankny_foodbanks__*
    + status: NA
    + comments: need to scrape data from google map and the downloaded KML does not have spatial info
- [ ]  hhc_hospitals
    + status: updated
- [ ]  __hra_centers__
    + status: updated
    + comments: new data source https://data.cityofnewyork.us/City-Government/Community-Health-Centers/b2sp-asbg/data
- [ ]  *__moeo_socialservicesiteloactions__*
    + status: NA
    + comments: receive by email
- [ ]  nycdoc_corrections
    + status: NA
    + comments: no update needed, hand checked no new facilities added
- [ ]  nycha_communitycenters
    + status: updated
- [ ]  nycha_policeservice
    + status: updated
- [ ]  nycourts_courts
    + status: NA
    + comments: hand checked, no update needed
- [ ]  nypl_libraries
    + status: updated
    + comments: not sure there are new libraries added, but the scraper worked
- [ ]  nysdec_lands
    + status: updated
    + comments: for some reason gdal won't read the link, so I had to manual update. not sure if new records added tho
- [ ]  nysdec_solidwaste
    + status: updated
- [ ]  nysdoccs_corrections
    + status: updated
    + comments: 1 facility in queens, 1 facility in Manhattan, 0 in the other 3 boros. 
- [ ]  nysdoh_healthfacilities
    + status: updated
- [ ]  nysdoh_nursinghomes
    + status: updated
- [ ]  nysed_activeinstitutions
    + status: updated
    + comments: manually downloaded selected table __  All Institutions: Active Institutions with GIS coordinates and OITS Accuracy Code - Select by County__ CSV from [website](https://eservices.nysed.gov/sedreports/list?id=1) and loaded into S3
- [ ]  __nysed_nonpublicenrollment__
    + status: updated
    + comments: this data set was not previously included in the list for some reason. 
- [ ]  nysoasas_programs
    + status: updated
    + comments: original link no longer work, switch to https://edm-recipes.nyc3.digitaloceanspaces.com/2020-03-23/Treatment_Providers_OASAS_Directory_Search_23-Mar-20.csv
- [ ]  nysomh_mentalhealth
    + status: updated
- [ ]  nysopwdd_providers
    + status: updated
- [ ]  nysparks_historicplaces
    + status: updated
- [ ]  nysparks_parks
    + status: updated
- [ ]  qpl_libraries
    + status: updated
- [ ]  sbs_workforce1
    + status: updated
- [ ]  uscourts_courts
    + status: updated
    + commetns: scraper ran smoothly, not sure there are new facilities added
- [ ]  usdot_airports
    + status: updated
    + comments: on argis site, it says updated 2020/02/17, no url change
- [ ]  usdot_ports
    + status: updated
    + comments: url changed to https://data-usdot.opendata.arcgis.com/datasets/major-ports-1, data is as of __2019/12/17__
- [ ]  usnps_parks
    + status: updated
    + comments: manually downloaded from url and loaded into s3
