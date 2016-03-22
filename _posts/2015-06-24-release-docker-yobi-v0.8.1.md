---
layout: post
title: Yobi를 docker에서 운영하기 위한 docker-yobi v0.8.1 업데이트
category: docker-yobi
tags:
  - yobi
  - git
  - docker-yobi
  - java
comments: true
images:
  title: 'https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5aa58637-424f-4c28-9d19-acd6d0ad0686'
---

##  서론

최근 yobi는 [Java8](http://www.oracle.com/technetwork/java/javase/overview/java8-2100321.html) 지원과  [play-2.3](https://www.playframework.com/documentation/2.3.x/Home)기반으로 [v.0.8.1](https://github.com/naver/yobi/releases/tag/v0.8.1) 업그레이드를 진행하였다. 또한 간단하게 설치하여 설정없이 바로 시작할 수 있는 풀패키지버전도 공개하였다. 더 많은 기능과 향상된 성능에 관하여 [v0.8.0](https://github.com/naver/yobi/releases/tag/v0.8.0)을 참조하면 알 수 있다. yobi가 업그레이드 됨에 따라 기존의 v0.7.x 기반의 [docker-yobi](https://github.com/saltfactory/docker-yobi)를 v0.8.1로 도커 컨테이너 이미지 업그레이드를 진행하였다. 이 글에서는 변경된 docker-yobi의 상용법을 소개한다.

<!--more-->

## docker-yobi 클론

github에서 docker-yobi를 **clone** 한다.

```
git clone https://github.com/saltfactory/docker-yobi.git
```

![git clone docker-yobi](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/f735ca78-957c-4866-9df4-f0bedcb7df11)

## docker-yobi 파일

docker-yobi는 `Dockerfile`과 쉽고 편리하게 운영할  수 있도록 쉘 파일을 포함하고 있다.
- **Dockefile** :  docker-yobi 이미지를 정의
- **config.sh** : docker-yobi에 관한 설정 정의
- **build.sh** : docker-yobi 이미지를 생성
- **start.sh** : docker-yobi 컨테이너를 실행
- **stop.sh** : docker-yobi 컨테이너를 중지
- **rm.sh** : docker-yobi 컨테이너를 삭제
- **logs.sh** : docker-yobi의 로그 확인

## 설정

`config.sh` 파일을 열어서 필요한 정보를 수정한다.

- **YOBI_HOME** : 내 컴퓨터에 있는 **Yobi 홈 디렉토리**를 경로를 입력(기본 값은 현재 디렉톨리 안에 `yobi` 디렉토리)
- **DOCKER_YOBI_NAME** : docker-yobi 컨테이너의 **이름**을 지정
- **DOCKER_YOBI_PORT** : docker-yobi 컨테이너의 외부 **포트번호**

만약 기존의 yobi를 사용하고 있다면 `YOBI_HOME`의 경로를 기존의 프로젝트 경로로 지정한다. **YOBI_HOME**의 `conf/`, `yobi.h2.db`, `repo/`, `uploads/` 를 자동으로 읽어 사용하게 됩니다(yobi-0.8x 기반, [yobi-0.7.x 버전은 yobi.h2.db 파일 마이그레이션](https://github.com/naver/yobi/blob/next/docs/ko/update-next-branch-to-0.8.0.md)이 필요하다.). 만약 새롭게 시작한다면 YOBI_HOME에 지정한 디렉토리 안에 이 디렉토리와 파일들이 생성된다.

```
vi config.sh
```
```bash
#!/bin/bash

YOBI_HOME="$(PWD)/yobi"
DOCKER_YOBI_NAME="yobi-0.8.1"
DOCKER_YOBI_PORT="9000"
```

## 빌드

`Dockerfile`에 정의한 docker-yobi 이미지를 생성한다.

```
sh build.sh
```

![build](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/42f3dee5-6196-41db-86da-f3eadaeb0e39)

## 시작

`config.sh`에 정의한 docker-yobi 컨테이너를 실행한다.

```
sh start.sh
```
만약 아무런 설정을 하지 않고 실행하게 되면 기본 **YOBI_HOME** 디렉토리를 발견하지 못해서 다음과 같은 메세지를 만나게 된다.

![not found YOBI_HOME](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/62905290-eebc-4a88-a0be-266e1f7b677d)

`./config.sh` 파일을 수정하지 않으면 기본적으로 **YOBI_HOME** 디렉토리는 docker-yobi를 clone한 디렉토리 안의 **yobi/** 디렉토리로 지정이 된다. 이 곳에 **yobi**라는 디렉토리가 없어서 발생하는 메세지이다. 이곳에 yobi 디렉토리를 만들거나 새로운 디렉토리로 지정하면 된다. 예제를 위해서 `/Users/saltfactory/shared/yobi-home`에 새롭게 디렉토리를 만들고 YOBI_HOME으로 지정한다.

![setting YOBI_HOME](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/84c14270-c1c1-4909-ba6e-e3744d1cec43)

다시 `sh start.sh` 명령어로 docker-yobi를 실행하자.

이제 정상적으로 docker-yobi가 실행이 되었다. docker-yobi가 실행이되면 Yobi가 정상적으로 실행되어 YOBI_HOME에 필요한 파일들을 만들게 된다. YOBI_HOME 디렉토리에 `ls` 명령어로 파일이 만들어졌는지 확인해보자.

![startup docker-yobi](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/695ce50a-4f6e-43eb-9087-7662652f2dcb)

브라우저를 열어서 Yobi가 정상적으로 실행되는지 확인해보자. host에 호스트 IP를 입력하면된다. 이 예제는 boot2docker를 사용하여 만들 것이라 boot2docker의 IP를 입력했다.

http://host:9000
![open yobi](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/3fb22afb-85b4-4db6-8892-8292e040f7fa)

docker 프로세스를 확인해보자. `config.sh`에 설정한 정보대로 docker-yobi가 운영되고 있는 것을 확인할 수 있다. 우리는 기본정보 그대로 사용했기 때문에 **PORT**는 9000 그리고 **NAME**은 yobi-0.8.1로 실행되었다.

![docker ps](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/2ad4ad32-0575-4949-b2e0-cee65b6c34db)

## 로그확인

docker-yobi에 관련된 로그를 보고 싶으면 `logs.sh` 파일을 실행한다.

```
sh logs.sh
````

현재 docker-yobi가 정상적으로 실행되었기 때문에 다음과 같은 로그를 확인할 수 있다.

![logs.sh](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/56e03610-bb91-4159-b2b7-c64566f92060)


## 중지

docker-yobi를 중지하고 싶을 경우는 `stop.sh` 파일을 실행한다. 이 파일은 `config.sh`에 정의한 docker-yobi 컨테이너를 중지시킨다.

```
sh stop.sh
```
![stop docker-yobi](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9326798e-b822-4e91-bf04-ba5db6200ed1)


## 삭제

docker에서 컨테이너를 중지해도 완전히 삭제되는 것은 아니다. `docker ps -a` 명령어로 중지된 컨테이너를 확인할 수 있다.

```
docker ps -a
```
![stoped container](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/957a6b4f-73dc-4a59-9153-32c26154a591)

docer-yobi 컨테이너를 완전히 삭제하기 위해서는 `rm.sh` 파일을 실행한다. 이 파일은 `config.sh`에 정의한 docker-yobi 컨테이너를 삭제한다. 그리고 다시 `docker ps -a` 명령어로 확인하면 docker-yobi 컨테이너가 완전히 삭제 된 것을 확인할 수 있다.

```
sh rm.sh
```

![sh rm.sh](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/b88231f9-875c-4f0e-b706-d3e9284576a9)

## 결론

**Yobi**는 사내에서 SCM을 구축할 때 매우 매력적인 오픈소스이다. 커미터와 커뮤니터들의 적극적인 활동으로 이슈들이 빠르게 업데이트되고 있고 이젠 Java8과 Play 2.3 기반의 안정화되고 성능 좋은 버전으로 릴리즈가 되었다. 이런 Yobi를 docker 환경에서 간편하고 쉽게 사용하기 위해 Yobi 버전에 맞춰 **docker-yobi**를 업데이트했다. 무거운 ubuntu에서 **debian** 기반으로 업데이트했으며 Java8 기반으로 동작하도록 만들었다. docker-yobi 외부에서 yobi의 파일들이 저장될 수 있도록 **YOBI_HOME** 디렉토리 공유할 수 있도록 하였다. docker-yobi의 유연성을 위해서 docker-yobi의 컨테이너 이름과 포트번호를 변경하여 운영할 수 있도록 **config.sh** 설정 파일 추가하였고, 간편한 사용을 위해서 명령여 쉘 파일을 추가하였다. docker-yobi를 사용하여 docker 환경에서 좀 더 빠르고 간편하게 Yobi를 사용할 수 있을 것으로 기대한다.

docker-yobi를 업데이트하게된 이유는 v0.7 기반의 yobi를 사용하다 v0.8로 마이그레이션을 하면서 발생하는 문제를 해결하기 위해서였다. 다음은 v0.7에서 v0.8을 쉽게 마이그레이션 하는 내용을 소개하고 docker-yobi에 마이그레이션 쉘을 추가할 예정이다.


## 소스

- https://github.com/saltfactory/docker-yobi

## 참고

1. http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html

