#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/src/main.sh

function usage() {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h Display help
  -v Display Version
  status (docker | compose | all) Display Status
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
		  init_docker
		  ;;
          start)
		  start_docker
		  ;;
          stop)
		  stop_docker
		  ;;
	  run)
                  run_docker-compose $2
                  show_status all
                  ;;
	  clean)
		  clean_docker-compose
		  show_status compose
		  ;;
  esac
}

function run_install() {
  case "$1" in
          docker)
		  install_docker
		  ;;
          compose)
		  install_docker-compose
		  ;;
  esac
}

function get_option() {
 local opt optarg

 while getopts hv OPT
 do
 # OPTIND 番目の引数を optarg へ代入
  case "${OPT}" in
     v|-version)
	     show_version
	     exit
	     ;;
     h|-help)
	     usage
	     exit
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
fi

exit 0

