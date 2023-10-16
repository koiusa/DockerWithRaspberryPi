#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
. ${SCRIPT_DIR}/src/common_functions.sh

function install_env(){
 #Required at Docker Login
 sudo apt install gnupg2 pass

 #Address issue of Docker container and host not being able to synchronize time
 LIBSECCOMP=libseccomp2_2.5.4-1+b3_arm64.deb
 sudo curl http://ftp.debian.org/debian/pool/main/libs/libseccomp/${LIBSECCOMP}
 sudo dpkg ${LIBSECCOMP}
}

function install_docker(){
 #Docker Install
 sudo curl -fsSL https://get.docker.com -o get-docker.sh
 sudo sh get-docker.sh
 sudo usermod -aG docker $USER
 echo Reboot or re-login is required.
}

function install_docker-compose(){
 VERSION=$(get_setting "docker_compose_env_version")
 VERSION=$(echo $VERSION | sed 's/"//g')
 DISTRIBUTION=$(uname -s)-$(uname -m)
 DOCKER_COMPOSE_DIR=/usr/local/bin/docker-compose

 #Docker-Compose Insrall
 sudo curl -L "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-${DISTRIBUTION}" -o ${DOCKER_COMPOSE_DIR}
 chmod +x ${DOCKER_COMPOSE_DIR}
}
