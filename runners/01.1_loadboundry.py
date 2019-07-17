from lib import zip_url_to_postgis, url_to_postgis

zip_url_to_postgis('http://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nybb16b.zip/nybb_16b/nybb.shp', 'dcp_boroboundaries')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nybbwi_19b.zip/nybbwi_19b/nybbwi.shp', 'dcp_boroboundaries_wi')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nyct2010wi_19b.zip/nyct2010wi_19b/nyct2010wi.shp', 'dcp_censustracts')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nyccwi_19b.zip/nyccwi_19b/nyccwi.shp', 'dcp_councildistricts')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nynta_19b.zip/nynta_19b/nynta.shp', 'dcp_ntaboundaries')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nypp_19b.zip/nypp_19b/nypp.shp', 'dcp_policeprecincts')
zip_url_to_postgis('https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nysd_19b.zip/nysd_19b/nysd.shp', 'dcp_school_districts')
url_to_postgis('https://sfo2.digitaloceanspaces.com/db-data-recipes/recipes/doitt_zipcodeboundaries/2019-07-17/doitt_zipcodeboundaries.csv', 'doitt_zipcodeboundaries')