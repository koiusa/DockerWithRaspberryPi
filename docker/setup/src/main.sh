#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/src/status_functions.sh
. ${SCRIPT_DIR}/src/install_functions.sh
. ${SCRIPT_DIR}/src/init_functions.sh

function init_docker() {
 stop_docker
 set_docker_root
 start_docker
}

