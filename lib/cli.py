import click
import os 
from pathlib import Path
from sqlalchemy import create_engine, text
from urllib.parse import urlparse

def parse_engine(engine):
    result = urlparse(engine)
    username = result.username
    password = result.password
    database = result.path[1:]
    hostname = result.hostname
    portnum = result.port
    return dict(username = username,
                database = database, 
                hostname = hostname, 
                port = portnum)

etl_path = Path(__file__).parent.parent / 'etl'
sql_path = Path(__file__).parent.parent / 'sql'

engine = create_engine(os.environ.get('DATAFLOWS_DB_ENGINE'), max_overflow=-1)
conn = parse_engine(os.environ.get('DATAFLOWS_DB_ENGINE'))
username = conn['username']
database = conn['database']
hostname = conn['hostname']
port = conn['port']

@click.group()
def cli():
    pass

@cli.group()
def recipe():
        pass

def get_recipes(ctx, args, incomplete):
        return [k for k in os.listdir(etl_path) if incomplete in k]

@recipe.command('ls')
@click.argument('recipe', type=click.STRING, autocompletion=get_recipes)
def list_recipes(recipe):
        if recipe == 'local':
                click.echo('\n')
                for i in os.listdir(etl_path):
                        if i not in ['__init__.py', 'utils.py', 'test.py', 'template.py', '__pycache__']:
                                click.secho(i, fg='yellow')
                click.echo('\n')

        elif recipe == 'pg':
                click.echo('\n')
                for i in engine.table_names():
                        if i not in ['spatial_ref_sys', 'facilities']:
                                click.secho(i, fg='red')
                click.echo('\n')
                        
        elif recipe == 'diff': 
                try: 
                        in_pg = set(set(engine.table_names()) - set(['spatial_ref_sys', 'facilities']))
                        objs = set(set(os.listdir(etl_path)) - set(['__init__.py', 'utils.py', 'test.py', 'template.py', '__pycache__']))
                        in_local = set([obj.split('.')[0] for obj in objs])
                        click.echo('\n')
                        click.secho('in postgres not in local:', fg='green', bold=True)
                        for i in in_pg.difference(in_local):
                                click.secho(i, fg='magenta')
                        click.echo('\n')

                        click.secho('in local not in postgres:', fg='green', bold=True)
                        for i in in_local.difference(in_pg):
                                click.secho(i, fg='yellow')
                        click.echo('\n')
                except TypeError:
                        click.secho(f'type error', fg='red') 
       
@recipe.command('run')
@click.argument('recipe', type=click.STRING, autocompletion=get_recipes)
def run_recipes(recipe):
        click.echo('\n')
        click.secho(f'Pulling {recipe} from s3 and loading to postgres ... ', fg='yellow')
        os.system(f'python {etl_path}/{recipe}.py')

        click.echo('\n')
        click.secho(f'Perform transformation in postgres ... ', fg='yellow')
        os.system(f"psql -U {username} -d {database} -h {hostname} -p {port} -f {sql_path/f'{recipe}.sql'}")
        click.echo('\n')

        if recipe in engine.table_names(): 
                click.secho(f'{recipe} is loaded and transformed in psql!', fg='blue')
        else: 
                click.secho(f'something went wrong ...', fg='red')
        click.echo('\n')

@recipe.command('init')
def init_recipes():
        click.secho(f'Initializing ... ', fg='yellow')
        click.secho(f'Create facilities ... ', fg='yellow')
        os.system(f"psql -U {username} -d {database} -h {hostname} -p {port} -f {sql_path/'create.sql'}")
        click.secho(f'Create stored procedure ... ', fg='yellow')
        os.system(f"psql -U {username} -d {database} -h {hostname} -p {port} -f {sql_path/'load_to_facilities.sql'}")

@recipe.command('clean')
def remove_cache():
        click.secho(f'Removing cache ... ', fg='yellow')
        os.system('rm -r .checkpoints')