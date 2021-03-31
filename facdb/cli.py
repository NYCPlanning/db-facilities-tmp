import importlib
from pathlib import Path
from typing import List, Optional

import typer
from sqlalchemy.sql import text

from .utility import ENGINE

app = typer.Typer()


@app.command()
def run(
    name: str = typer.Option(None, "--name", "-n", help="Name of the dataset"),
    scripts: Optional[List[Path]] = typer.Option(
        None, "-f", help="SQL Scripts to execute"
    ),
):
    pipelines = importlib.import_module("facdb.pipelines")
    pipeline = getattr(pipelines, name)
    pipeline()

    if scripts:
        for script in scripts:
            query = script.read_text()
            print(query)
            ENGINE.execute(text(query))


def init():
    app()
