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

function run_init() {
  if [ -z "$1" ]; then
	  #init_env
	  init_docker
  else
	case "$1" in
	  env)
	  	init_env
		;;
	  docker)
	        init_docker
		;;
	esac
  fi
}

function run_install() {
  if [ -z "$1" ]; then
	  install_docker
	  install_docker-compose
  else
  	case "$1" in
          docker)
                  install_docker
                  ;;
          compose)
                  install_docker-compose
                  ;;
  	esac
  fi
}

function up_service() {
  SERVICE_NAME=$1
  SERVICE_YML=$(get_setting "${SERVICE_NAME}_env_service")
  SERVICE_YML=$(echo ${SERVICE_YML} | sed 's/"//g')
  up_docker-compose ${SERVICE_YML}
}

function down_service() {
  SERVICE_NAME=$1
  SERVICE_YML=$(get_setting "${SERVICE_NAME}_env_service")
  SERVICE_YML=$(echo ${SERVICE_YML} | sed 's/"//g')
  SERVICE_DIR=$(dirname ${SERVICE_YML})
  down_docker-compose ${SERVICE_DIR}
}

