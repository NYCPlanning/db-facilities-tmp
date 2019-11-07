from .engines import build_engine, edm_engine, psycopg2_connect
from .geocode import geocode_percentage
from sqlalchemy.types import TEXT
import io
import psycopg2
import logging
import os

def exporter(df, table_name, con=build_engine, 
            sep='~', to_geom=True, geo_column='wkb_geometry',
            SRID=4326, null=''):

    # psycopg2 connections
    db_connection = psycopg2_connect(con.url)
    db_cursor = db_connection.cursor()
    str_buffer = io.StringIO() 
    df['ogc_fid'] = df.index
    column_definitions = ','.join([f'"{c}" text' for c in df.columns])

    # # Create table
    create = f'''
    DROP TABLE IF EXISTS {table_name};
    CREATE TABLE {table_name} (
        {column_definitions}
    );
    '''
    con.connect().execute(create)
    con.dispose()

    # export
    df = df.replace(sep, null, regex=True)
    df.to_csv(str_buffer, sep=sep, header=True, index=False)
    str_buffer.seek(0)
    
    db_cursor.copy_expert(f"COPY {table_name} FROM STDIN WITH NULL AS '{null}' DELIMITER '{sep}' quote '\"' CSV HEADER", str_buffer)

    # db_cursor.copy_from(str_buffer, table_name, sep=sep, null=null, columns=df.columns)
    db_cursor.connection.commit()

    if to_geom:
        geocode_percentage(df, table_name)
        make_geom = f'''
        ALTER TABLE {table_name} 
        ALTER COLUMN {geo_column} TYPE Geometry USING ST_SetSRID(ST_GeomFromText({geo_column}), {SRID});
        '''
        con.connect().execute(make_geom)
        con.dispose()
    else: pass

    str_buffer.close()
    db_cursor.close()
    db_connection.close()

def exporter_classic(df, table_name, con=build_engine, chunksize=10000,  to_geom=True, SRID=4326):
    df = df.replace(r'^\s+$', None, regex=True)
    
    df.to_sql(table_name, con = con, 
                        if_exists='replace', index=False, 
                            chunksize=chunksize)
                            
    # # Change to target DDL
    for i in df.columns:
        con.connect().execute(f'ALTER TABLE {table_name} ALTER COLUMN "{i}" TYPE text USING ("{i}"::text);')
        con.connect().execute(f'UPDATE {table_name} SET "{i}"=NULLIF(TRIM("{i}"), \'\');')
        con.dispose()
    
    if to_geom:
        make_geom = f'''
        UPDATE {table_name}
        SET wkb_geometry = ST_GeomFromText(wkb_geometry, {SRID});
        '''
        con.connect().execute(make_geom)
        con.dispose()
    else: pass