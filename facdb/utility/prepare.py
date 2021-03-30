from functools import wraps

import pandas as pd

from . import BASE_URL
from .utils import format_field_names, hash_each_row


def read_csv(name: str, version: str = "latest") -> pd.DataFrame:
    return pd.read_csv(
        f"{BASE_URL}/{name}/{version}/{name}.csv", dtype=str, index_col=False
    )


def Prepare(function: callable = None, version: str = None) -> callable:
    def _Prepare(func) -> callable:
        @wraps(func)
        def wrapper(*args, **kwargs) -> pd.DataFrame:
            name = func.__name__
            df = (
                read_csv(name, version)
                .pipe(hash_each_row)
                .pipe(format_field_names)
                .pipe(func)
            )
            df["source"] = name
            return df

        return wrapper

    if function:
        return _Prepare(function)
    return _Prepare
