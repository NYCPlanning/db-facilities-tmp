UPDATE facilities
SET xcoord = ST_X(ST_TRANSFORM(geom, 2263)),
    ycoord = ST_Y(ST_TRANSFORM(geom, 2263));