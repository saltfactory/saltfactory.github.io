---
layout: post
title : Mac OS X에서 docker 설치하기(시작하기)
category : docker
tags : [docker, mac, linux]
comments : true
redirect_from : /255/
disqus_identifier : http://blog.saltfactory.net/255
---

## 서론

docker는 리눅스 컨테이너 환경으로 리눅스 자원을 나누어 사용하는 시스템이다. 이러한 특징 때문에 docker는 리눅스 운영체제에서 운영하기 가장 적합하다.
하지만 Mac 개발자도 boot2docker를 사용하여 docker를 사용할 수 있다. 이 포스트에서는 Mac 운영체제에서 boot2docker를 사용하여 docker를 운영하는 방법을 소개한다.

<!--more-->

![Docker Logo](http://blog.hibrainapps.net/saltfactory/images/f33da3ee-c5fc-4b88-b495-c637c9862c42)

## Docker

[Docker](https://www.docker.com/)는 가상 컨테이너에 애플리케이션을 포장해서 서로 다른 리눅스 서버에 실행할 수 있게 도와주는 기술이다. 이 것은 다양한 오픈소스 소프트웨어와 결합할 수 있는 리눅스 환경에서 클라우드와 가상화 기능을 실현할 기술로 주목 받아왔다. 이것은 VM는 비슷한것 같지만 Docker는 VM이 무거운 운영체제를 포함하지 않아도 된다. 좀더 정확한 표현은 호스트의 운영체제를 공유하는 방식이다. 이 때문에 수많은 리소스를 포함하고 있는 VM에 비해서 훨씬 빠르고 가벼운 가상화를 제공한다.

![VM vs. Docker](http://blog.hibrainapps.net/saltfactory/images/4a8ff7dc-e5a6-4de8-addd-cc8715eec91d)

Docker는 리눅스 컨테이너([LXC](http://en.wikipedia.org/wiki/LXC)) 가상화 기술을 기반해 애플리케이션 샌드박스를 자동생성하는 기술이다. 리눅스 운영체제 상에 CPU, 메모리, 스토리지, 네트워크 등의 자원을 애플리케이션마다 별로 격리된 가상공간으로 할당한다.

![VM vs. Docker](http://blog.hibrainapps.net/saltfactory/images/0cbfe0cb-87d7-421d-be50-97caa8df7057)
[이미지 출처 : http://pointful.github.io/docker-intro/]

## Docker 사내 도입 배경

Docker를 업무에 도입하게 된 배경은 연구소에서 서버 관리를 하고 있는데, 개발하는 운영체제와 운영되고 있는 서버의 운영체제가 다르고 여러버전의 서버가 있어서 컨테이너 기술을 도입하고 싶었기 때문이다. (개발은 Mac에서 하고 실제 운영하는 리눅스 서버는 Ubuntu 11.04, Ubuntu 12.04, CentOS 4.5, FreeBSD 등 여러 리눅스 계열 서버를 사용을 하고 있다.) 이렇게 다양한 서버를 운영하고 있을 때 여러가지 의존성 문제를 바로 잡는데 시간이 많이 소비된다. 서버를 이전, 마이그레이션 또는 병합과 분리 등 작업을 할 때 의존성문제와 환경 설정 문제를 매번 겪게 된다는 것을 경험하게 되었다. 그래서 복잡한 메뉴얼 등을 만들거나 설정 방법이 기억나지 않아서 힘들 때가 종종 생겼었다. 우리는 docker를 통해서 이 문제를 해결해보고 싶어졌다.

## Boot2Docker

Docker는 원래 ***리눅스 컨테이너(LXC)*** 기술로 리눅스 운영체제에서만 가능했다. 하지만 Mac OS X에서도[Boot2Docker](https://github.com/boot2docker/boot2docker)를 사용해서 docker를 사용할 수 있는데 이것은 Mac OS X에서 경량가상머신을 이용하여 virtualed docker engine을 관리할 수 있도록 지원하고 있다.

## Homebrew 로 설치하기

[Mac OS X에서 docker 설치하기 (공식문서)](https://docs.docker.com/installation/mac/#installation)를 따라해서 Docker를 Mac OS X에 설치할 수 있다. `docker`와 `boot2docker`는 설치 파일을 다운받거나 바이너리 파일을 받아서 설치할 수도 있지만 [Homebrew](http://brew.sh/)를 사용해서 간단하게 설치할 수 있다. Homebrew에 관해서는 [Homebrew를 이용하여 Mac OS X에서 Unix 패키지 사용하기](http://blog.saltfactory.net/109) 글을 참조한다.

### docker 설치하기

```
brew install docker
```
### boot2docer 설치하기

```
brew install boot2docker
```
### VirtualBox 설치하기

Mac OS X에서 docker를 사용하기 위해서는 virtualed docker engine을 사용하기 위해서 가상머신이 필요하는데 오라클에서 오픈 소스프로젝트로 진행하고 있는 [VirtualBox](https://www.virtualbox.org/)를 설치를 하여 virtualed docker engine을 올릴것이다. 사이트에서 바이너리 파일을 다운로드 받아서 설치를 해도 상관없지만 우리는 Homebrew의 확장툴인 [Homebrew Cask](http://caskroom.io/)로 VirstualBox를 설치 할 것이다.

`brew cask` 명령을 사용하기 위해서 Homebrew로 ***cask***를 설치한다.

```
brew install caskroom/cask/brew-cask
```

```
brew cask install virtualbox
```
이렇게 Homebrew를 사용하면 간단하게 Docker를 설치할 수 있다. 모든 설치가 완료되면 Docker를 사용할 준비를 하기 위해서 `boot2docker`를 실행한다.

## Docker 이미지 생성

Mac OS X에서 docker 엔진을 사용하기 위해 모든 설치가 완료되면 `boot2docker`를 사용하여  virtualed docker engine을  만들어야한다. 초기 생성은 `init`으로 한다.

```
boot2docker init
```

![boot2docker init](http://blog.hibrainapps.net/saltfactory/images/244f2298-f145-47b0-adc9-baa8ad1acd3c)

## Docker 시작

Mac OS X에서 Docker를 시작하기 위해서는 `boot2docker`를 사용해서 시작한다.

```
boot2docker up
```

위 명령어를 실행하면 vitualed docker engine이 시작되는 것을 확인할 수 있고 Docker가 실행되면 Docker client가 Docker daemon에 접근하기 위해서 `DOCKER_HOST`를 환경변수로 등록해야한다.

```bash
export DOCKER_HOST=tcp://192.168.59.103:2375
```

![export DOCKER_HOST](http://blog.hibrainapps.net/saltfactory/images/3486e7b7-affd-4bc3-879b-31af1f8fce06)

## Docker 접속

Mac OS X 터미널에서 docker로 접속하기 위해서는 `boot2docker`의 `ssh`를 사용하여 접근한다.

```
boot2docker ssh
```
![boot2docker ssh](http://blog.hibrainapps.net/saltfactory/images/d4c91b89-93c2-47c8-993d-a8c3fc423a44)
***boot2docker@0.8*** 버전에서는 `boot2docker ssh`로 접근하면 비밀번호(**tcuser**)를 물어봤는데 최근 버전은 물어보지 않고 바로 Docker로 접속된다. Docker에 접속하게 되면 Mac OS X의 터미널의 프롬프트가 ***docker@boot2dockr***로 변경되는 것을 확인할 수 있다.

## Docker 나가기

접속한 Docker에서 나가기 위해서는 우리가 리눅스 터미널에서 익숙한 `exit`로 나갈 수 있다.

```
exit
```

## Docker 종료

접속한 Docker에서 나가더라도 우리가 `boot2docker`로 올려 놓은 virutaled docker engine은 그대로 사용되고 있기 때문에 완전히 종료하기 위해서는 Docker를 정지시킨다.

```
boot2docker stop
```

## 결론

***Docker***는 리눅스 컨테이너(LXC) 가상화 기술을 사용하여 어플리케이션의 개발, 패키징, 배포를 편리하게 할 수 있게 해준다. 기존에 여러 운영체제에 올라가는 어플리케이션을 개발하고 배포할 경우 가상화머신(VM)을 사용하였는데 이때 VM은 각각의 운영체제의 리소스를 따로 설치하고 그 위에 어플리케이션을 운영하기 때문에 개발을 하거나 운영할 때 리소스가 많이 필요하고 너무 느리다는 단점이 있었다. 하지만 Docker는 운영체제의 설치 없이 호스트의 자원을 사용하는 형태로 어플리케이션과 라이브러리를 컨테이너화 하여 설치하여 독립적으로 운영할 수 있다. Docker는 리눅스 커널을 사용하여 컨테이너 개념으로 사용하기 때문에 오직 리눅스 운영체제에서만 사용할 수 있다. 하지만 ***boot2docker*** 를 사용하여 Mac OS X에서도 virutaled docker engine을 사용하여 Docker를 운영할 수 있도록 Docker에서 공식 지원을하고 있다. 이번 포스팅에서는 ***Homebrew***를 사용하여 Docker를 설치하는 방법에 대해서 알아 보았다. 우리는 앞으로 Docker에 관해서 좀 더 자세히 살펴 볼 것이다.

## 참고

1. https://docs.docker.com/installation/mac/#installation
2. http://www.itworld.co.kr/tags/64073/%EB%8F%84%EC%BB%A4/87915
3. http://www.zdnet.co.kr/news/news_view.asp?artice_id=20140610103601
4. http://qiita.com/ringo/items/da8bfbc48bcb33bc97a0
5. http://caskroom.io/

