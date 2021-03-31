import os

from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

BASE_URL = "https://nyc3.digitaloceanspaces.com/edm-recipes/datasets"
BUILD_ENGINE = os.environ.get("BUILD_ENGINE")
ENGINE = create_engine(BUILD_ENGINE)
