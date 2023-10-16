# DockerWithRaspberryPi

[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/graphs/commit-activity)
[![GitHub issues](https://img.shields.io/github/issues/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/issues)
[![GitHub license](https://img.shields.io/github/license/koiusa/DockerWithRaspberryPi)](https://github.com/koiusa/DockerWithRaspberryPi/blob/main/LICENSE)

## Testing Operating Environment
動作確認環境
```
Model : Raspberry Pi 4 Model B Rev 1.2
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 12 (bookworm)
Release:        12
Codename:       bookworm
Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux
```

```
--Docker Status--
Docker version 24.0.6, build ed223bc
 Docker Root Dir: /mnt/portable/docker/root
WARNING: No memory limit support
WARNING: No swap limit support
CONTAINER ID   IMAGE           COMMAND                  CREATED        STATUS                      PORTS                                       NAMES
2fb90cc0c95b   redmine         "/docker-entrypoint.…"   6 hours ago    Up 2 hours                  0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   redmine
69e288375091   postgres:15.0   "docker-entrypoint.s…"   6 hours ago    Up 2 hours                  5432/tcp                                    redmine-redmine-db-1
e86bb6eef5da   c2ec9716031f    "python3"                6 months ago   Exited (137) 20 hours ago                                               chappie
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
redmine      latest    10c155391e06   3 days ago      686MB
postgres     15.0      340f3238aa46   11 months ago   358MB
--Docker Compose Status--
Docker Compose version v2.22.0
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
      REDMINE_DB_DATABASE: redmine  # ※2に対応
      REDMINE_DB_USERNAME: redmine  # ※3に対応
      REDMINE_DB_PASSWORD: redmine  # ※4に対応
      REDMINE_DB_ENCODING: utf8
    depends_on:
      - redmine-db
    restart: always

  redmine-db:  # ※1
    image: postgres
    restart: always
    environment:
      POSTGRES_DB: redmine  # ※2
      POSTGRES_USER: redmine  # ※3
      POSTGRES_PASSWORD: redmine  # ※4
    volumes:
      - ./dbdata/:/var/lib/postgresql/data

```

docker/setup/setting.yml
Redimeのdocker-composeの設定ファイルパスを指定する
```
...

redmine:
  env:
    service: /mnt/portable/docker/redmine/docker-compose.yml
```

## Apply Redmine Docker Image

Redimeのdocker-composeを実行  
Redmine及びPostgresのDockerImageを作成する
```
./pidocker.sh up redmine
```

## ShutDown Redmine Docker Image
```
./pidocker.sh down redmine
```

