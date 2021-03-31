import os

from . import BUILD_ENGINE


def ExecuteSQL(query):
    os.system(f'''psql {BUILD_ENGINE} -c "{query}"''')
    return None
