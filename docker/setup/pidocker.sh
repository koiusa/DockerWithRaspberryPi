#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/src/main.sh

function usage() {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h > display help
  -v > display version
  status [docker | compose | all] > display status
  install [docker | compose] > docker install
  init > [env | cocker]docker environment Setup
  start > docker engine Start
  stop > docker engine Stop
  up [path/to/docker-compose.yml] > docker-compose up
  down [path/to/docker-compose-dirctory] > docker-compose down
  clean > doker-compose process clean
EOM
}

function run_main() {
  case "$1" in
	  status)
		  show_status all
		  ;;
          install)
		  run_install $2
		  ;;
	  init)
		  run_init $2
		  ;;
          start)
		  start_docker
		  ;;
          stop)
		  stop_docker
		  ;;
	  up)
                  up_docker-compose $2
                  show_status all
                  ;;
          down)
	          down_docker-compose $2
		  show_status all
		  ;;
	  clean)
		  clean_docker-compose
		  show_status compose
		  ;;
          *)
		  usage
		  ;;
  esac
}

function get_option() {
 while getopts hv OPT
 do
  case "${OPT}" in
     v|-version)
	     show_version
	     exit 0
	     ;;
     h|-help)
	     usage
	     exit 0
	     ;; 
     \?)
	     exit 1
	     ;;
     *)
	     echo "$0: Illegal option -- ${OPT##}" 1>&2
	     exit 1
	     ;;
   esac
 done

 shift $((OPTIND - 1))
}

get_option $@

shift `expr "${OPTIND}" - 1`

if [ $# -ge 1 ]; then	
  run_main $@
else
  usage
fi

exit 0

