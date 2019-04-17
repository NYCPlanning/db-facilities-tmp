#!/bin/bash
## environmental variables settings
export AWS_ACCESS_KEY_ID='YSM62NECGEHHTM2H4BDI'
export AWS_SECRET_ACCESS_KEY='7ASH8rPMZUOGT/iNjuM08RNExdcthDSShbR+fGJhM1o'
export S3_ENDPOINT_URL='https://sfo2.digitaloceanspaces.com'
export DATAFLOWS_DB_ENGINE='postgresql://postgres:0312@localhost:5433/postgres'
export BUCKET='sptkl'

## install custom python pacakges
pip install -e .

## settings for cli
eval "$(_COOK_COMPLETE=source cook)"
