#!/bin/bash
function init {
    DOCKER_BUILDKIT=1 docker-compose up -d --build
    docker-compose exec -T facdb facdb init
}

function facdb_execute {
    docker-compose exec -T facdb facdb $@
}

case $1 in
    init) init ;;
    *) facdb_execute $@;;
esac
