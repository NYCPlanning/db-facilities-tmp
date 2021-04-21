import os

from . import BUILD_ENGINE


def ExecuteSQL(script):
    os.system(f"""psql {BUILD_ENGINE} -v ON_ERROR_STOP=1 -f {script}""")
    return None
