import importlib
from pathlib import Path
from typing import List, Optional

import typer

from . import ExecuteSQL

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
            ExecuteSQL(query)


@app.command()
def sql(
    scripts: Optional[List[Path]] = typer.Option(
        None, "-f", help="SQL Scripts to execute"
    )
):
    if scripts:
        for script in scripts:
            query = script.read_text()
            ExecuteSQL(query)


def init():
    app()
