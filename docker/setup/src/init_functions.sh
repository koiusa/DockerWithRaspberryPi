#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
. ${SCRIPT_DIR}/src/common_functions.sh

function set_docker_root() {
 #Doker Root Dirctory
 DOCKER_PORTABLE_ROOT=$(get_setting "docker_env_root")
 DOCKER_PORTABLE_ROOT=$(echo $DOCKER_PORTABLE_ROOT | sed 's/"//g')
 sudo rsync -aXS /var/lib/docker/. ${DOCKER_PORTABLE_ROOT}

 DAEMON_FILE=/etc/docker/daemon.json
 echo "{\"data-root\": \"${DOCKER_PORTABLE_ROOT}\"}" | sudo tee ${DAEMON_FILE} > /dev/null
 
 #Result Display
 echo "${DAEMON_FILE}"
 echo $(cat ${DAEMON_FILE})
}

function up_docker-compose() {
 COMPOSE_YML=$1
 docker-compose -f ${COMPOSE_YML} up -d
}

function down_docker-compose() {
 COMPOSE_DIR=$1
 cd $1 && docker-compose down
}

function clean_docker-compose() {
 docker-compose down
 docker-compose build
 docker network prune
}

function init_env() {
 sudo usermod -a -G docker $USER
}

