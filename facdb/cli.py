import importlib
import os
from pathlib import Path
from typing import List, Optional

import typer

from . import ExecuteSQL

app = typer.Typer(add_completion=False)


def complete_dataset_name(incomplete: str) -> list:
    pipelines = importlib.import_module("facdb.pipelines")
    completion = []
    for name in dir(pipelines):
        if name.startswith(incomplete):
            completion.append(name)
    return completion


@app.command()
def run(
    name: str = typer.Option(
        None,
        "--name",
        "-n",
        help="Name of the dataset",
        autocompletion=complete_dataset_name,
    ),
    scripts: Optional[List[Path]] = typer.Option(
        None, "-f", help="SQL Scripts to execute"
    ),
):
    """
    This function is used to execute the python portion of a pipeline,
    however you can also use -f to specify any sql script you need to execute
    """
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
    """
    this command will execute any given sql script against the facdb database
    """
    if scripts:
        for script in scripts:
            query = script.read_text()
            ExecuteSQL(query)


@app.command()
def clear(
    name: str = typer.Option(
        None,
        "--name",
        "-n",
        help="Name of the dataset",
        autocompletion=complete_dataset_name,
    ),
):
    """
    clear will clear the cached dataset created while reading a csv
    """
    from facdb.utility import BASE_PATH

    os.remove(BASE_PATH / f"{name}.pkl")
