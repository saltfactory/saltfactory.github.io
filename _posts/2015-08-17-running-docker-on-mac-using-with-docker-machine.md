---
layout: post
title: Docker Machine을 이용하여 Mac에서 docker 운영하기
category: docker
tags:
  - docker
  - docker-machine
  - mac
comments: true
images:
  title: 'https://hbn-blog-assets.s3.amazonaws.com/docker-logo-new.png'
---


## 서론

연구소에서 프로젝트를 진행하면서 Docker의 활용도가 높아졌다. 서버 기반의 프로젝트가 많은 특징으로 이전에는 개발 서버를 구축해서 사용했지만 Docker 도입이후 물리적인 서버로부터 많이 자유로워졌다. 다양한 서버 플랫폼에 테스트를 할 수도 있고 여러개의 인스턴스를 재활용하여 사용하기도 한다. Docker 기반으로 개발을 하지만 데스크탑 환경은 Mac에서 개발을 진행하고 있다. 이러한 이유로 Docker를 바로 사용하지는 못하고 Mac에서 VM을 기반으로 한 Docker 운영을 위한 [Boot2Docker](http://boot2docker.io/)를 사용하여 Docker 기반 개발을 진행하고 있었다. **Boot2Docker**는 Docker의 공식 사이트에서도 설치방법 및 운영을 위한 문서를 공식적으로 지원하였다. 하지만 최근 Docker 의 공식 사이트에서는 Boot2Docker의 deprecates를 공지하고  [Docker Machine](https://docs.docker.com/installation/mac/)를 사용하는 방법을 제시하고 있다. 이 포스팅에서는 **Docker Machine**을 사용하여 Boot2Docker로부터 마이그레이션하는 방법과 Docker를 사용하는 방법을 소개한다.

<!--more-->

## Docker Toolbox

**Docker Machine**을 가장 쉽게 설치하는 방법은 [Docker Toolbox](https://www.docker.com/toolbox)를 설치하는 것이다.

![docker toolbox](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/99923d3c-7285-4cf8-9e02-ddc6563847be)

Docker는 지속적으로 발전하고 있고 더욱 더 쉽게 Docker를 사용할 수 있는 방법을 제공하고 있다. **Docker Toolbox**는 Docker의 All-in-One 으로 생각하면 된다. Docker Toolbox를 설치하면 Docker를 바로 시작할 수 있다. Docker Toolbox에는 다음 어플리케이션들이 포함되어 있다.

- Docker Client
- **Docker Machine**
- Docker Compose
- Docker Kitemactic
- Virtual Box

우리가 설치하고 싶은 **Docker Machine**이 포함되어 있는 것을 확인할 수 있다. https://www.docker.com/toolbox 에서 Docker Toolbox를 다운로드한다. Mac/Windows 버전이 존재하며 자신의 운영체제 맞는 것을 다운로드 받고 설치한다. Mac용 Docker Toolbox를 설치했다.

![docker machine installer](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/93049f78-ddff-4957-8c6f-52b6319ccfa0)

기존에 **Boot2Docker**를 사용하고 있었다면 설치 중에 다음과 같은 메세지를 만나게 된다.

![boot2docker migration alert](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/854ccb78-66da-4fe0-b578-2dac29eab034)

**Docker Machine**는 내부적으로 **VM**을 사용하는데, Boot2Docker에서 사용한 VM으로부터 마이그레이션을 할 수 있다. Migrate를 선택하면 기존의 Boot2Docker에서 사용한 VM을 그대로 사용할 수 있고 Do not Migrate를 선택하면 새로운 VM을 사용한다.

만약 Docker Machine을 설치하고 Boot2Docker의 VM을 사용하기 위해서는 **--virtualbox-import-boot2docker-vm** 옵션을 사용하면 된다. Docker 공식 사이트에서는 **Boot2Docker**를 **Docker Machine**으로 마이그레이션하는 방법을  https://docs.docker.com/machine/migrate-to-machine/ 에서 소개하고 있다.

Docker Toolbox를 설치하면서 Boot2Docker VM을 마이그레이션하면 다음과 같이 **docker-machine**의 리스트에 **default**라는 이름으로 **virtualbox DRIVER**가 설치된 것을 확인할 수 있다. docker-machine의 목록을 살펴보기 위해서는 **ls** 명령어를 사용한다.

```
docker-machine ls
```

![docker-machine ls](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5f47e7e8-c744-4819-a4e6-7c2d16d032e7)


좀더 자세하게 살펴보기 위해서는 **inspect** 명령어를 사용한다. **default**라는 이름으로 만들어진 머신을 살펴보자.

```
docker-machine inspect default
```

```json
{
    "ConfigVersion": 1,
    "Driver": {
        "IPAddress": "",
        "SSHUser": "docker",
        "SSHPort": 59018,
        "MachineName": "default",
        "CaCertPath": "/Users/saltfactory/.docker/machine/certs/ca.pem",
        "PrivateKeyPath": "/Users/saltfactory/.docker/machine/certs/ca-key.pem",
        "SwarmMaster": false,
        "SwarmHost": "tcp://0.0.0.0:3376",
        "SwarmDiscovery": "",
        "CPU": 8,
        "Memory": 2048,
        "DiskSize": 20000,
        "Boot2DockerURL": "",
        "Boot2DockerImportVM": "boot2docker-vm",
        "HostOnlyCIDR": "192.168.99.1/24"
    },
    "DriverName": "virtualbox",
    "HostOptions": {
        "Driver": "",
        "Memory": 0,
        "Disk": 0,
        "EngineOptions": {
            "ArbitraryFlags": [],
            "Dns": null,
            "GraphDir": "",
            "Env": [],
            "Ipv6": false,
            "InsecureRegistry": [],
            "Labels": [],
            "LogLevel": "",
            "StorageDriver": "",
            "SelinuxEnabled": false,
            "TlsCaCert": "",
            "TlsCert": "",
            "TlsKey": "",
            "TlsVerify": true,
            "RegistryMirror": [],
            "InstallURL": "https://get.docker.com"
        },
        "SwarmOptions": {
            "IsSwarm": false,
            "Address": "",
            "Discovery": "",
            "Master": false,
            "Host": "tcp://0.0.0.0:3376",
            "Image": "swarm:latest",
            "Strategy": "spread",
            "Heartbeat": 0,
            "Overcommit": 0,
            "TlsCaCert": "",
            "TlsCert": "",
            "TlsKey": "",
            "TlsVerify": false,
            "ArbitraryFlags": []
        },
        "AuthOptions": {
            "StorePath": "",
            "CaCertPath": "/Users/saltfactory/.docker/machine/certs/ca.pem",
            "CaCertRemotePath": "",
            "ServerCertPath": "/Users/saltfactory/.docker/machine/machines/default/server.pem",
            "ServerKeyPath": "/Users/saltfactory/.docker/machine/machines/default/server-key.pem",
            "ClientKeyPath": "/Users/saltfactory/.docker/machine/certs/key.pem",
            "ServerCertRemotePath": "",
            "ServerKeyRemotePath": "",
            "PrivateKeyPath": "/Users/saltfactory/.docker/machine/certs/ca-key.pem",
            "ClientCertPath": "/Users/saltfactory/.docker/machine/certs/cert.pem"
        }
    },
    "StorePath": "/Users/saltfactory/.docker/machine/machines/default"
}
```

**Boot2DockerImportVM**의 값을 살펴보면 기존의 **boot2docker-vm**라는 이름으로 사용하던 VM을 임포트한 것을 확인할 수 있다.


## Docker Machine

**Docker Machine**은 **Docker Engine**에 접속하기 위한 **Docker Client**을 설치, 설정하고  관리한다. 만약 Mac에서 Docker를 사용하고 싶을경우 Docker Machine은 다음 그림과 같이 사용 가능하다. **Docker Machine**은 Docker Client를 다양한 Docker Host에 접속할 수 있게 해준다. 내 로컬의 Docker 엔진 뿐만 아니라 Data Center VM, Cloud Instance까지 접속할 수 있게 해준다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f5cf34c4-836c-49f5-82c2-a0e981648bb8)

그림출처 : http://www.tomsitpro.com/articles/docker-enterprise-hub-orchestration,1-2375.html

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/867b4da4-dfe4-477b-b727-377647e4b323)

그림출처 : http://pocketstudio.jp/log3/2015/07/01/docker-machine-0-3-generic-driver-and-scp/

다음은 Docker Machine을 사용하여 AWS와 Digital Ocean과 로컬의 VM에서 동작하고 있는 Docker 사이의  파일을 복사하는 것을 데모한 내용을 소개한다. 일본어로 되어 있지만 삽입된 그림과 코드를 살펴보면 **Docker Machine**을 이해하는데 도움이 된다.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/1BwDIHFAnBXtNG" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/zembutsu/docker-machine-introduction-cloudmix-11th" title="Docker Machineを始めるには？" target="_blank">Docker Machineを始めるには？</a> </strong> from <strong><a href="//www.slideshare.net/zembutsu" target="_blank">Masahito Zembutsu</a></strong> </div>

## Docker Machine Command

**Docker Machine**은 Boot2Docker와 상당히 비슷한 명령어들이 많이 있다. Machine을 관리하기 위한 Docker Machine의 commands를 살펴보자.

| Command | 설명 |
|---|---|
| active | 현재 active한  머신 출력 |
| config | 머신에 커넥션하기 위한 설정 출력 |
| create | 머신 생성 |
| env | docker client를 위한 환경변수 설정 |
| inspect | 머신 정보 출력 |
| ip | 머신의 IP 주소 출력 |
| ls | 머신 목록 |
| regenerate-certs | 머신에 사용하는 TLS 인증서를 갱신 |
| restart | 머신 재시작 |
| rm | 머신 삭제 |
| ssh | 머신에 ssh 접속 |
| scp | 머신의 파일 복사 |
| start | 머신 시작 |
| status | 머신 상태 출력 |
| stop | 머신 중지 |
| upgrade | 최신 버전의 docker를 위한 머신 업그레이드 |
| url | 머신의 URL 출력 |
| help, h| 도움말 출력 |

## create

Docker Machine을 사용하여 **virtualbox**를 드라이브로하는 VM을 추가해보자. (cloud driver를 사용하는 예제는 차후에 소개한다)

```
docker-machine create --driver virtualbox dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/85e2415e-4e59-49c2-9d8f-5787b3429df9)

## ls

Docker Machine의 목록을 살펴보자.

```
docker-machine ls
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b7e44065-fb8a-4830-896c-ba194063b929)

현재 **Docker Machine**에 기존의 Boot2Docker를 마이그레이션한 default라는 것과 위에서 추가한 dev가 보인다. Docker Machine을 사용하면 각각의 VM에 있는 docker로 접근이 가능하다.

## start

현재 default의 docker가 실행되고 있지 않다. Docker Machine의 **start** 명령어로 머신을 실행할 수 있다.

```
docker-machine start default
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9073cd41-2e9d-4627-abcf-74e070aff555)

docker-machine의 리스트를 살펴보면 default와 dev가 각각 virutalbox 드라이브로 다른 내부 아이피에서 동작하는 것을 확인할 수 있다.


## env

새로운 머신을 실행하면 *Started machines may have new IP address. You may need to re-run the `docker-machine env` command.*라는 메세지가 출력된다. 이것은 docker-machine이 로컬 컴퓨터에 있는 docker 중에서 접속할 수 있는 IP를 지정하라는 뜻이다. 현재 위 list를 살펴보면 **ACTIVE**에 아무것도 표시가 되어 있지 않다. 이런 상태로는 어떤 docker엔진도 접속을 하지 못한다.

**env** 명령어는 Docker Machine의 환경을 설정하는 명령어이다. 위에서 생성한 **dev** 머신을 사용하기 위해서 우리는 다음과 같이 **Docker Machine**의 환경을 설정할 수 있다.

```
docker-machine env dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/445ceba4-97eb-42be-86dd-919a5bc2b1f9)

이 명령어를 사용하면 **DOCKER_TLS_VERIFY**, **DOCKER_HOST**, **DOCKER_CERT_PATH**, 그리고 **DOCKER_MACHINE_ANME**이 환경변수로 설저을 하기 위한 스크립트로 만들어진다. **env** 명령어를 실행 후  *Run this command to configure your shell: # eval "$(docker-machine env dev)"* 메세지가 나타난다. 실제 docker에 접속하기 위한 shell을 실행하는 것으로 위에서 env로 만든 설정파일을 환경변수로 설정하는 것이다.

```
eval "$(docker-machine env dev)"
```

다시 **docker-machine ls**로 리스트를 살펴보자. 위에서 우리는 **dev**에 접속하기 위해 docker-machine의 env를 설정하였다. dev 머신의 **ACTIVIE**에 표시가 된 거을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6a80fffa-6ffb-4d99-8e47-2286de067198)

이제 docker 명령어를 사용할 수 있다. docker의 이미지 목록을 살펴보자.

```
docker images
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e6f80408-6ce2-4447-9095-bae125158bbc)

아직 docker에서 어떤 이미지도 만들지 않았기 때문에 목록에 나타나지 않는다. 중요한 것은 Mac에서 **Docker Machine**을 사용하여 **Docker**에 접속하고 있다는 것이다. 테스트를 위해서 간단한 docker 이미지를 실행해보자.

```
docker run hello-world
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/98d10758-c36e-491e-86ff-d7b6ff9d0f37)

이 명령어를 실행한 이후 docker는 로컬에 이미지가 없기 때문에 hub에서 이미지를 pull한 뒤 실행을 할 것이다. 다시 이미지 목록을 살펴보자. 이제는 hello-world라는 저장소의 이미지가 보여질 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/87895896-ec62-4b38-8474-50395794156e)

## status

Docker Machine에서 머신의 상태를 확인하기 위해서는 **status** 명령어를 실행하여 확인할 수 있다. status 확인을 위해 default 머신을 중지 시켰다. dev와 default 머신의 상태를 확인해보자.

```
docker-machine status dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f4cb09c1-4f86-472c-a67b-5cbf68e70ee1)

현재 dev는 **Running**이라는 상태를 출력하고, default는 **Stopped**라는 상태를 출력한다.

## active

만약 여러개의 머신이 실행되고 있다면 현재 **ACTIVE**인 머신을 확인하기 위해서는 **active** 명령어를 사용하여 확인할 수 있다. 테스트를 위해서 모든 머신을 실행하였다. 그리고 다음 명령어를 실행시키면 현재 **ACTIVE**는 **dev**가 출력되는 것을 확인할 수 있다.

```
docker-machine active
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c6c2d940-8938-436c-acf9-89d46c7eb77a)

## inspect

이 명령어는 위에서 머신의 정보를 확인하기 위해서 실행해본적이 있다. **inspect**는 머신의 상세정보를 확인할 때 사용한다. 출력결과는 JSON 형태로 출력이 된다.

```
docker-machine inspect dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7d5869d7-60b7-4190-b0c2-18152fc72cde)

## config

Docker Machine는 VM 드라이브를 사용하여 접속하기 때문에 접속하기 위한 설정 정보가 있다. 이 접속정보를 확인하기 위해서는 **config** 명령어를 사용한다.

```
docker-machine config dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/16a4d510-2b39-4db1-85d7-6bc99903b99c)

## ip

Docker Machine에서 특정 머신의 IP 정보를 확인하기 위해서 **ip** 명령어를 사용한다. Mac에서 Docker Machine을 사용하면 VirutalBox 드라이브를 사용하여 내부적으로 접근하는 IP가 생성되기 때문에 나중에 Docker 엔진으로 IP 기반으로 접근하기 위해서 이 명령어를 자주 사용하게 될 것이다.

```
docker-machine ip dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d3ddae1c-dfb5-4e70-a809-695473b7fba3)

## url

Docker Machine에 특정 머신의 URL을 **url** 명령어로 확인할 수 있다.

```
docker-machine url dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f615f356-3954-474f-9297-0f4d5b9b260c)


## ssh

실행되어 있는 docker에 **SSH**로 접속하기 위해서는 **ssh** 명령어로 접속할 수 있다. Docker Machine에서 **create** 로 생성한 머신에 ssh로 접속했는데 boot2docker 배너가 보인다.

```
docker-machine ssh dev
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ff775d8b-1897-41f2-9f3a-7ee212356c17)

## scp

[SCP](https://en.wikipedia.org/wiki/Secure_copy)는 SSH 프로토콜을 사용하여 원격지의 파일을 복사하는 보안 플토콜이다. Docker Machine에서는 **scp** 명령어를 사용하여 다른 머신들 사이의 파일을 복사할 수 있다. 테스트를 위해서 test.md 파일을 만들었다. **dev** 머신 안에 **~/test.md** 경로에 파일을 복사하려면 다음과 같이 할 수 있다.

```
docker-machine scp test.md dev:~/test.md
```

dev 머신으로 파일을 복사하고 난 다음 파일 ssh로 접속하면 **~/test.md** 경로에 로컬 파일에서 머신으로 파일이 복사 된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/08e26fba-8cf2-42b9-aaff-1a78fb99edc5)


## stop

Docker Machine을 중지하기 위해서는 **stop** 명령어를 사용한다. 위에서 실행한 **dev** 머신을 중시시키기 위해서는 다음 명령어를 실행한다.

```
docker-machine stop dev
```

다시 docker-manchine의 리스트를 살펴보면 dev가 중지된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/bff25720-1f21-4ab3-8679-d77ad75e3d00)

하지만 여기서 끝이 아니다. 아직 위에서 **docker-machine env dev**로 환경변수를 등록한 것을 기억할 것이다. 이 환경변수까지 모두 삭제해야한다.

```
eval "$(docker-machine env -u)"
```

## rm

Docker Machine에서 머신을 삭제하기 위한 명령어는 **rm**이다. 이 명령어를 실행하면 드라이버등 물리적인 파일 모두 삭제가 된다. **dev** 머신을 삭제하기 위해서 다음과 명령어로 삭제할 수 있다.

```
docker-machine rm dev
```
![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f5d0e293-36e9-4927-906d-11d243afe7be)

## 결론

Docker는 사용자에게 좀 더 편리하게 Docker를 사용할 수 있는 환경을 공식적으로 지원하려고 하고 있다. Docker는 기본적으로 리눅스에서 동작하는데 많은 개발자들이 Mac이나 Windows 운영체제에서 개발을 하기 때문에 **Boot2Docker**라는 것을 사용하여 VM 기반의 docker 운영을 할 수 있었다. Docker에서는 **Docker Machine**이라는 것을 베타로 릴리즈하였고 Boot2Docker 지원을 deprecated 시켰다. 이젠 앞으로 Docker Machine을 사용하여 Mac에서 Docker 기반 프로젝트를 진행해야할 것이다. 이에 따라 Docker Machine으로 마이그레이션하는 방법과 명령어에 대해서 간단하게 살펴보았다.

## 참고

1. https://docs.docker.com/machine/
2. https://docs.docker.com/machine/get-started/
3. https://docs.docker.com/machine/migrate-to-machine/


