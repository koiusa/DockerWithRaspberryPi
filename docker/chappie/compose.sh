#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
docker-compose -f docker-compose.yml up -d
sudo chown -R ${USER}:${USER} ${SCRIPT_DIR}/app
cd ${SCRIPT_DIR}/app && git clone https://github.com/koiusa/DiscordBotWithGPT.git
sudo docker exec -i chappie bash -c "cd DiscordBotWithGPT && ./configure.sh"
