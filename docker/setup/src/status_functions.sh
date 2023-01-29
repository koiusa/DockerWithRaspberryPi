#!/bin/sh

function show_version(){
 docker -v
 docker-compose -v
}

function docker_status(){
 echo "--Docker Status--"
 docker -v
 docker info | grep "Docker Root Dir"
 docker ps -a
 docker images
}

function docker-compose_status(){
 echo "--Docker Compose Status--"
 docker-compose -v
 docker-compose ls
}

function full_status(){
 docker_status
 docker-compose_status
}

function show_status(){
 case $1 in
  docker) 
   docker_status;;
  compose)
   docker-compose_status;;
  all)
   full_status;;
  *)
   ;;
 esac
}

function start_docker(){
 systemctl daemon-reload
 service docker start
}

function stop_docker(){
 service docker stop
 systemctl stop docker.socket
}
