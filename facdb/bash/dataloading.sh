#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh
max_bg_procs 5

import_public doitt_buildingcentroids &
import_public dcp_mappluto

wait
