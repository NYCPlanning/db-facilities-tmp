import os

from . import BUILD_ENGINE


def ExecuteSQL(script):
    os.system(f"""psql {BUILD_ENGINE} -f {script}""")
    return None
