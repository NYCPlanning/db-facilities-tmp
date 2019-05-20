import click
import os 
from pathlib import Path
from sqlalchemy import create_engine, text

etl_path = Path(__file__).parent.parent / 'etl'
sql_path = Path(__file__).parent.parent / 'sql'

engine = create_engine(os.environ.get('DATAFLOWS_DB_ENGINE'))

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
        sql_file = open(sql_path/f'{recipe}.sql')
        escaped_sql = text(sql_file.read())
        engine.execute(escaped_sql)

        click.echo('\n')
        if recipe in engine.table_names(): 
                click.secho(f'{recipe} is COOKED!', fg='blue')
        else: 
                click.secho(f'something went wrong ...', fg='red')
        click.echo('\n')

@recipe.command('init')
def init_recipes():
        click.secho(f'Initializing ... ', fg='yellow')

        create = open(sql_path/'create.sql')
        load_to_facilities = open(sql_path/'create.sql')
        escaped_sql = text(sql_file.read())
        engine.execute(escaped_sql)