#!/bin/bash
source config.sh

display "Fast load spatial tableds"
docker run --rm\
    -v $(pwd)/facdb/fast_load:/src\
    -w /src\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 dataloading.py
    "

display "Load/geocode all source tables"
docker run --rm\
    -v $(pwd):/src\
    -w /src\
    -e EDM_DATA=$EDM_DATA\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/docker-geosupport:latest bash -c "
        pip3 install -e .
        source config.sh
        run_all
    "
