# DockerWithRaspberryPi

[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/graphs/commit-activity)
[![GitHub issues](https://img.shields.io/github/issues/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/issues)
[![GitHub license](https://img.shields.io/github/license/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/blob/main/LICENSE)

##
設定ファイルの解釈は誤認している場合もありますが、ご了承のほどお願いします。  
Please note that my may have misinterpreted the configuration file.


## Testing Operating Environment
動作確認環境
```
Model : Raspberry Pi 4 Model B Rev 1.2
debian_version 10.13
Linux raspberrypi 5.15.89-v7l+ #1620 SMP Wed Jan 18 12:22:20 GMT 2023 armv7l GNU/Linux
```

```
--Docker Status--
Docker version 20.10.23, build 7155243
 Docker Root Dir: /mnt/portable/docker/root
WARNING: No memory limit support
WARNING: No swap limit support
WARNING: No kernel memory TCP limit support
WARNING: No oom kill disable support
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                  PORTS                                       NAMES
ada69522cd71   redmine       "/docker-entrypoint.…"   4 hours ago   Up 4 hours              0.0.0.0:8080->3000/tcp, :::8080->3000/tcp   redmine
516fa10ae736   postgres      "docker-entrypoint.s…"   4 hours ago   Up 4 hours              5432/tcp                                    redmine-redmine-db-1
REPOSITORY    TAG       IMAGE ID       CREATED       SIZE
redmine       latest    813d00988b99   2 weeks ago   508MB
postgres      latest    14ffa9942d15   2 weeks ago   314MB
--Docker Compose Status--
Docker Compose version v2.15.1
NAME                STATUS              CONFIG FILES
redmine             running(2)          /mnt/portable/docker/redmine/docker-compose.yml
```

## 
スクリプト配置ディレクトリへ移動
```
cd path/to/DockerWithRaspberryPi/docker
```

---

## Docker Engine Install setting
Dokcer Imageのルートディレクトリ保存先設定を任意のパスに設定  
docker/setup/setting.yml
```
docker:
  env:
    root: /mnt/portable/docker/root  # Dokcer Imageのルートディレクトリ保存先
    version: 

docker_compose:
  env:
    version: v2.15.1 
```

## Install Docker Engine
スクリプト配置ディレクトリで実行

Docker及びDocker Composeをインストールする
```
./pidocker.sh install 
```

Docker Image のルートディレクトリを設定のディレクトリにパス変更する
```
./pidocker.sh init
```

---

## Redmine with Docker compose Install setting

RedmineのDokcer Composeのパスワード設定を任意に変更  
docker/redmine/docker-compose.yml
```
version: '3.8'
services:
  redmine:
    image: redmine
    container_name: redmine
    ports:
      - 8080:3000
    volumes:
      - ./files:/usr/src/redmine/files
      - ./log:/usr/src/redmine/log
      - ./plugins:/usr/src/redmine/plugins
      - ./public/themes:/usr/src/redmine/public/themes
    environment:
      REDMINE_DB_POSTGRES: redmine-db  # ※1に対応
      REDMINE_DB_DATABASE: redmine  # setup_postgres.shのcreatedb名に対応
      REDMINE_DB_USERNAME: redmine  # ※2に対応
      REDMINE_DB_PASSWORD: redmine  # ※3に対応
      REDMINE_DB_ENCODING: utf8
    depends_on:
      - redmine-db
    restart: always

  redmine-db:  # ※1
    image: postgres
    restart: always
    environment:
      POSTGRES_DB: redmine-db  # ※1
      POSTGRES_USER: redmine  # ※2
      POSTGRES_PASSWORD: redmine  # ※3
    volumes:
      - ./dbdata/:/var/lib/postgresql/data

```

docker/redmine/setup_postgres.sh
```
#!/bin/sh

CONTAINER_NAME=$1

docker logs redmine # ログを確認
docker exec -it ${CONTAINER_NAME} createdb redmine --encoding=utf8 -O redmine -U redmine # CREATE DATABASEする 
```
## Apply Redmine Docker Image
Redimeのdocker-composeを実行  
Redmine及びPostgresのDockerImageを作成する
```
./pidocker.sh up path/to/DockerWithRaspberryPi/docker/redmine/docker-compose.yml
```

PostgresのDocker Image内でデータベースが作成されず、Redmineの起動に失敗するので別途コマンドで対応する
```
path/to/DockerWithRaspberryPi/docker/redmine/setup_postgres.sh redmine-redmine-db-1
```

---

## ShutDown Redmine Docker Image
```
./pidocker.sh down path/to/DockerWithRaspberryPi/docker/redmine
```
