from setuptools import setup, find_packages

setup(
    name="facdb",
    version="0.1",
    pacakges=find_packages(),
    install_requires=[
        "click",
        "python-dotenv",
        "psycopg2-binary",
        "shapely",
        "usaddress",
        "geopandas",
        "sqlalchemy",
        "pandas",
        "pathlib",
        "python-dotenv",
    ],
    entry_points="""
        [console_scripts]
        cook=facdb.cli:cli
      """,
)
