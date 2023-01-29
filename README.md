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
```
.pidocker.sh install docker
```

```
.pidocker.sh install compose
```

Docker Image のルートディレクトリを設定のディレクトリにパス変更
```
.pidocker.sh install init
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
Redmine及びPostgresのDockerImageが作成される
```
.pidocker.sh install run path/to/DockerWithRaspberryPi/docker/setup/docker-compose.yml
```

PostgresのDocker Image内でデータベースが作成されず、Redmineの起動に失敗するので別途コマンドで対応する
```
path/to/DockerWithRaspberryPi/docker/setup/setup_postgres.sh
```