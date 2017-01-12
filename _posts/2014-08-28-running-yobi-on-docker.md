---
layout: post
title : docker-yobi를 이용하여 yobi 운영하기
category : git
tags : [docker, git, yobi]
comments : true
redirect_from : /261/
disqus_identifier : http://blog.saltfactory.net/261
---

## 서론

우리는 LXC로 서버를 운영하기 위해서 [Docker](http://docker.com)를 도입하기로 했다. docker를 도입해서 docker에 올리는 서비스중 첫번째로 [Yobi](http://yobi.io)를 적용하기로 했다. 개인연구로 사용하고 있는 랩탑은 Mac OS X를 사용하고 있기 때문에 [boot2docker]()를 사용하여 Dockerfile을 생성해서 GitHub에 [docker-hub](https://github.com/saltfactory/docker-yobi) 와 [Docker Hub](https://registry.hub.docker.com/u/saltfactory/yobi/)에 올렸다. 이 포스팅에서는 GitHub와 Docker Hub를 이용해서 Yobi를 사용하는 방법을 소개한다.

<!--more-->

## docker-yobi

docker-yobi는 docker에서 [Yobi](http://yobi.io)를 운영하기 위한 Dockerfile이 포함되어 있다. docker-yobi는 로컬에 있는 yobi 디렉토리를 **mount**하여 사용한다. 즉, docker-yobi를 실행할 때 docker 이미지에 내 로컬 PC에 있는 yobi 디렉토리를 그대로 사용할 수 있다.

docker-yobi를 사용하기 위해서 먼저 GitHub에서 yobi를 `clone`한다. 설치 예제를 설명하기 위해서 yobi를 `clone` 받은 경로는 `/Users/saltfactory/yobi`라고 가정한다.

```
git clone https://github.com/naver/yobi.git
```

docker나 boot2docker를 시작한 후 `build`를 한다.

```
docker build -t saltfactory/yobi .
```

docker-yobi의 `run-yobi.sh`를 실행한다. 이때, 로컬에 `clone`한 yobi의 디렉토리를 지정한다. 설치 예제로 `clone` 받은 경로는 `/Users/saltfactory/yobi`라고 가정한다.

```
sh run-yobi.sh /Users/saltfactory/yobi
```

docker-yobi가 정상적으로 실행되고 있는지 확인하기 위해서 `docker ps` 명령어로 확인한다.

```
docker ps
```
정상적으로 실행이되면 docker ps 목록에 yobi가 보인다. docker-yobi가 정상적으로 실행되면 [play](https://www.playframework.com/)가 실행되면서 필요한 패키지를 다운받고 컴파일한다. 만약 설치되는 로그를 보고 싶을 경우는 `docker logs` 명령어로 확인할 수 있다.

```
docker logs yobi
```

play가 정상적으로 시작이되고 난 다음 브라우저에서 확인한다.

http://localhost:9000


## docker-yobi 활용방법

docker-yobi는 yobi를 사용하는데 필요한 이미지와 컨테이너를 만들게 된다. 한번 만들어진 컨테이너를 재사용하면 play가 시작하면서 다운받고 컴파일한 패키지를 다시 다운받고 컴파일하지 않기 때문에 yobi 시작 시간을 줄일 수 있다. 새롭게 `docker build`를 하지 않는 이상 빠르게 yobi를 실행할 수 있다.

docker에 커네이너로 만들어진 yobi를 정지하기 위해서는 `docker stop` 명령어를 사용한다.

```
docker stop yobi
```

다시 yobi 컨테이너를 실행하고 싶을 경우 `run-yobi.sh`를 명령어를 사용한다.

```
sh run-yobi.sh /Users/saltfactory/yobi
```

## 다른 서버에서 docker-yobi 사용하여 이전하기

docker 환경을 갖춘 모든 리눅스 서버에서 docker-yobi를 사용하여 이전에 사용하던 yobi를 그대로 사용할 수 있다. 만약 yobi를 다른 서버로 이전할 경우, docker-yobi를 설치하고 로컬 PC에 저장된 yobi 디렉토리만 복사해서 이전하는 서버에 복사하여 `run-yobi.sh`를 할 때 이전한 서버에 복사한 yobi 경로를 지정하여 사용하면 된다.


## Mac OS X에서 boot2docker를 사용할 경우

docker는 리눅스 환경에서 사용하지만 Mac OS X에서 [boot2docker](http://docs.docker.com/installation/mac/)를 사용하여 docker-yobi를 사용할 수 있다.
boot2docker 설치방법은 http://docs.docker.com/installation/mac/ 나 http://blog.saltfactory.net/255 문서를 참조하면 된다.

boot2docker를 사용하기 위해서는 [VirtualBox](https://www.virtualbox.org)에서 forwarding port를 하기 위해서 docker-yobi 안에 있는 `boot2dockr-ports.sh`를 실행한다.

```
sh boot2docker-ports.sh
```

boot2docker에서 로컬 PC에 있는 디렉토리를 마운트하기 위해서 VirtualBox에서 shared directory를 지정해야 한다. 다음 사이트에 자세한 방법을 참조한다.

  1. https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c
  2. http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide

```
boot2docker down
```

```
curl http://static.dockerfiles.io/boot2docker-v1.2.0-virtualbox-guest-additions-v4.3.14.iso > ~/.boot2docker/boot2docker.iso
```

```
VBoxManage sharedfolder add boot2docker-vm -name home -hostpath /Users
```

```
boot2docker up
```

## Docker Hub

가장 먼저 해야할 일을 yobi를 clone 받는 것이다. 로컬 PC에 GitHub로부터 yobi를 clone 한다. 예제 설명을 위해서 clone 받는 위치는 `/Users/saltfactory/yobi`라고 가정한다.

```
git clone https://github.com/naver/yobi.git
```

docker는 GitHub와 같은 Repository를 구축했다. 그래서 docker 명령어로 docker image를 바로 다운받아서 사용할 수 있다. 우리는 yobi를 Docker Hub에서 바로 다운 받을 수 있게 GitHub와 Docker Hub를 연동했다.
![Docker Hub](http://asset.blog.hibrainapps.net/saltfactory/images/ecc95243-82dc-41ac-ba32-18e8b53992dc)

Docker Hub에서 `docker pull` 명령어를 사용하여  ***saltfactory/yobi*** 이미지를 다운 받는다.

```
docker pull saltfactory/yobi
```

***saltfactory/yobi*** 에서 필요한 파일은  [Play](https://www.playframework.com/)를 실행시키는 `start-yobi.sh` 파일이 필요하다. docker-yobi가 실행할때 이 파일을 자동으로 마운트해서 사용하기 때문이다. 로컬에 다음 내용으로 `start-yobi.sh` 파일을 만든다. 필요하다면 play가 시작할 때 다른 옵션을 추가해도 된다.

```bash
#!/bin/bash
cd /home/yobi/yobi; play "start -DapplyEvolutions.default=true -Dhttp.port=9000"
```

다음은 docker-yobi를 실행하는 `run-yobi.sh` 파일을 만든다.

```bash
#!/bin/bash

YOBI_HOME=$1

if [ -f $YOBI_HOME/RUNNING_PID ];
then
  rm -rf $YOBI_HOME/RUNNING_PID
  docker start yobi
else
  docker stop yboi
  docker rm yobi
  docker run --name yobi \
  -d -p 9000:9000 \
  -v $YOBI_HOME:/home/yobi/yobi \
  saltfactory/yobi
fi

docker ps
```

이제 `run-yobi.sh`를 실행한다.

```
sh run-yobi.sh /Users/saltfactory/yobi
```
마지막으로 브라우저에서 http://localhost:9000 를 확인한다.

![yobi](http://asset.blog.hibrainapps.net/saltfactory/images/35066d0d-0840-4d5b-9573-c1010ec914b3)

## 결론

우리는 여러대의 Linux 서버를 관리하는데 많은 시간이 들여지고 환경을 맞추는데 어려움을 겪어서 서버에 동작하는 서비스들을 docker로 운영하기로 결정했다. 첫번째로 yobi를 docker에서 운영하기 위해서 docker-yobi를 만들어서 GitHub에 [docker-hub](https://github.com/saltfactory/docker-yobi) 와 [Docker Hub](https://registry.hub.docker.com/u/saltfactory/yobi/)에 올렸다. 이제 우리는 어떠한 Linux 서버에서도 동일한 환경으로 Yobi 서비스를 사용할 수 있게 되었다.

Yobi는 git를 사용하기 위한 repository를 포함하고 있다. 이 repository는 docker 이미지 안에 넣지 않았다. 이유는 Yobi의 repository는 단순히 우리가 쌓는 데이터이기 때문이고, 이 데이터는 서버 환경에 영향을 받지 않고 빠르게 이전하거나 백업을 따로 하기 위해서 이다. 그래서 우리는 docker의 [VOLUME](https://docs.docker.com/userguide/dockervolumes/)을 사용해서 외부의 디렉토리를 docker 컨테이너에 올릴 수 있게 했다.

개인적으로 연구할 때 사용하는 랩탑은 Mac OS X 이기 때문에 boot2docker를 사용했지만 docker-yobi를 사용해서 어떤 Linux 서버에서도 쉽게 설치해서 운영할 수 있는 Dockerfile을 만들어서 사용할 수 있게 되었다.


## 참조

1. https://docs.docker.com/userguide/dockervolumes/
2. https://docs.docker.com/docker-hub/builds/
3. http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide
4. https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c

