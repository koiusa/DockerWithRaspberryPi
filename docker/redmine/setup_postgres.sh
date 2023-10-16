#!/bin/sh

CONTAINER_NAME=$1

#docker logs redmine # ログを確認
docker exec -it ${CONTAINER_NAME} createdb redmine --encoding=utf8 -O redmine -U redmine # CREATE DATABASEする 
