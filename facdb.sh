#!/bin/bash
function init {
    docker-compose up -d --build
    docker-compose exec -T facdb facdb init
}

function facdb_execute {
    docker-compose exec -T facdb facdb $@
}

case $1 in
    init) init ;;
    *) facdb_execute $@;;
esac
