import os
from pathlib import Path
import click
import json
import pandas as pd
import numpy as np
from ast import literal_eval

CONFIG_PATH = os.path.join(
    os.path.abspath(os.path.dirname(__file__)),
    'recipes'
)

@click.group()
def cli():
    pass

@cli.command('run')
@click.argument('recipe', type=click.STRING)
def run_recipes(recipe):
    os.system(f'python3 {Path(__file__).parent}/recipes/{recipe}.py')