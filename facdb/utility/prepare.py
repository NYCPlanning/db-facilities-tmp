import os
from functools import wraps
from pathlib import Path

import pandas as pd
import yaml

from . import BASE_URL
from .utils import format_field_names, hash_each_row


def read_datasets_yml() -> dict:
    with open(Path(__file__).parent.parent / ("datasets.yml"), "r") as f:
        return yaml.safe_load(f.read())["datasets"]


def get_dataset_version(name: str) -> str:
    datasets = read_datasets_yml()
    dataset = next(filter(lambda x: x["name"] == name, datasets), None)
    assert dataset, f"{name} is not included as a dataset in datasets.yml"
    return dataset["version"]


def read_csv(name: str) -> pd.DataFrame:
    version = get_dataset_version(name)
    return pd.read_csv(
        f"{BASE_URL}/{name}/{version}/{name}.csv", dtype=str, index_col=False
    )


def Prepare(func) -> callable:
    @wraps(func)
    def wrapper(*args, **kwargs) -> pd.DataFrame:
        name = func.__name__
        get_dataset_version(name)
        df = read_csv(name).pipe(hash_each_row).pipe(format_field_names).pipe(func)
        df["source"] = name
        return df

    return wrapper
