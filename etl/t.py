from shapely.geometry import Point

def find_position(lat,lon):
    # s = s.str(s)
    # lon = s[s.find(','),:]
    # lat = s[:,s.find(',')]
    lat = float(str(lat))
    lon = float(str(lon))
    return [lon, lat]

def get_the_geom(lon, lat): 
        lon = float(lon) if lon != '' else None
        lat = float(lat) if lat != '' else None
        if (lon is not None) and (lat is not None): 
                return str(Point(lon, lat))

# print(find_position(40.633606800000, -74.029507300000))
print(get_the_geom(find_position(40.633606800000, -74.029507300000)[0],find_position(40.633606800000, -74.029507300000)[1]))