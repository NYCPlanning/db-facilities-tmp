# db-facilities
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/NYCPlanning/db-facilities?label=version)
![Build](https://github.com/NYCPlanning/db-facilities/workflows/Build/badge.svg)

## Development:
### Configurations
- We strongly advise that you use VScode for development of this project
- The `.devcontainer` contains all development configuration you would need, including:
    - `psql` is preinstalled
    - `python-geosupport` is installed with 21a geosupport
    - `poetry` is installed and initialized
    - `pre-commit` is also preconfigured and no additional setup is needed
- If you do not have vscode setup, don't worry, you can still develop using docker-compose
    - initialize docker-compose: `./facdb.sh init`
    - the facdb.sh script is a one to one wrapper of the python facdb cli, e.g. `./facdb.sh --help`
    - docker-compose is also used to test PR and build the dataset in github actions
    
### Pipeline development with the `facdb` cli
- Create a pipeline function under the name of the function, e.g. `dcp_colp`
- If you don't want to run every command with `poetry run`, we recommend you activate the virtual environment by `poetry shell`
- you can execute the python part by calling `facdb run --name dcp_colp` or `facdb run -n dcp_colp`
- Once you have your sql script ready, you can call `facdb run -n dcp_colp -f facdb/sql/dcp_colp.sql` to run both the python part and the sql part of the pipeline. If you have more than one sql script to execute for that particular pipeline, you can call `facdb run -n  dcp_colp -f facdb/sql/dcp_colp.sql -f some/other/script.sql`
- To run sql scripts only: `facdb sql -f facdb/sql/dcp_colp.sql -f some/other/script.sql`
