---
layout: post
title: Mac과 Docker 상호간 디렉토리 공유하기 (Boot2Docker에서 VOLUME 사용)
category: docker
tags: [mac, docker, boot2docker, volumn, ssfs]
comments: true
redirect_from : /265/
disqus_identifier : http://blog.saltfactory.net/265
---

## 서론

Mac에서 **Docker**를 사용하기 위해서는 **Boot2Docker**를 사용해야한다. Boot2Docker는 VirtualBox를 사용하기 때문에 Docker에 바로 로컬디렉토리를 공유폴더로 지정하기 위해서는 VirtualBox를 통해서 사용해야한다. 이러한 이유로 Docker에서 VOLUME을 사용하는 방법과 다른 방법이 필요하다. 이 포스트에서는 ssfs를 사용하여 Boot2Docker에서 Mac과 Docker 상호간 디렉토리를 공유하는 방법에대해 소개한다.

<!--more-->

## Boot2Docker

[Docker](http://en.wikipedia.org/wiki/Docker_(software))는 리눅스 커널 기반의 컨테이너 개념을 가지고 운용하는데 Mac은 리눅스 기반의 시스템이 아니기 때문에 [VirtualBox](https://www.virtualbox.org/) 기반에서 Docker를 운영할 수 있다. [Boot2Docker](http://boot2docker.io/)는 Mac이나 Windows에서 VirtualBox를 사용하여 가볍고 빠른 [Tiny Core Linux](http://tinycorelinux.net/) 운영체제 기반에 Docker를 운영하도록 만든 것이다. 다시 말해서 Boot2Docker를 사용하면 Linux 계열 운영체제가 아니더라도 docker를 운영할 수 있다.


## Boot2Docker의 한계

원래 Docker를 사용하면 리눅스 서버 운영체제에 격리된 컨테이너 안에서 각각 필요한 환경에서 동작한다. 상황에 따라 컨테이너 외부의 파일을 공유해야할 경우가 발생하는데 Docker에서 [VOLUME](https://docs.docker.com/reference/builder/#volume) 이라는 개념을 가지고 컨테이너 외부의 디렉토리를 컨테이너 내부의 디렉토리로 마운트시켜 공유할 수 있다.

**Boot2Docker**를 사용하면 **VOLUME**을 사용하는데 제한이 있다. Boot2Docker는 리눅스 계열이 아닌 운영체제에서 VirutualBox를 사용하여 가상머신 위에 Tiny Core Linux를 사용하고 있기 때문에 Local Host에서 Docker 컨테이너 내부에 직접적으로 디렉토리를 마운트를 시킬 수가 없다.

## SSHFS
[ssfs](http://en.wikipedia.org/wiki/SSHFS)는 원격지에 있는 디렉토리를 ssh 커넥션으로 로컬의 디렉토리에 마운트 시키는 파일시스템 클라이언트이다. **ssfs**는 [SFTP](http://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol)을 이용하여 데이터를 엑세스한다.

## Boot2Docker 환경에서 SSHFS를 이용하여 VOLUME 사용하기

SSHFS를 이용하면 Boot2Docker의 한계를 개선하여 디렉토리를 공유할 수 있다.
원리는 간단히 설명하면 SSHFS를 이용하여  Mac OS X 디렉토리를 Boot2Docker의 운영체제에 마운트를 하고,  Docker 실행할 때  Boot2Docker의 디렉토리를 docker 컨테이너로 마운트하게 된다. 즉, Mac OS X -> Boot2Docker -> Docker로 된다.

### 1. SSHFS 설치 (Mac)

Mac OS X에 SSHFS를 설치한다. SSHFS는 osxfuse를 이용하여 마운트를 하기 때문에 osxfuse를 함께 설치한다.

```
brew install Caskroom/cask/osxfuse
```

```
brew install sshfs
```

### 2. Local의 공유 디렉토리 생성 (Mac)

최종적으로 Docker에 공유하기 위한 Mac OS X에 디렉토리를 생성한다. (현재  Mac OS X 안 경로에 만드는 것이다)

```
mkdir /Users/saltfactory/shared
```

### 3. sshfs-fuse 로드 (Boot2Docker)

Boot2Docker 안에서 sshfs를 사용하여 원격에 있는 디렉토리를 마운트하기 위해 Boot2Docker에 ssh로 로그인후 **sshfs-fuse**를 로드한다.

```
boot2docker ssh
```

```
boot2docker tce-load -wi sshfs-fuse
```

### 4. 마운트될 디렉토리 생성 (Boot2Docker)

Boot2Docker 안에서 Mac OS X에서 생성한 디렉토리를 마운트할 디렉토리 지점을 지정하기 위해서 디렉토리를 생성한다. (현재 Boot2Docker 안 경로에 만드는 것이다)


```
mkdir /home/docker/shared
```

### 5. 마운트 설정을 위해 fuse.conf 추가 (Boot2Docker)

SSFS는 fuse를 사용하여 Mac OS X로부터 Boot2Docker에 디렉토리를 마운트하게 되는데 접근할 수 있는 권한을 설정하기 위해서  /etc/fuse.conf 파일을 다음 내용으로 추가한다. (현재 Boot2Docker 안 경로에서 만드는 것이다)

```
# filename: fuse.conf
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
user_allow_other
```

### 6. SSHFS를 이용하여 마운트 (Boot2Docker)

Boot2Docker 내부에서 SSFS를 이용하여 Mac에 생성한 디렉토리를 마운트한다. SSHFS를 사용할 때 Mac의 계정과 Boot2Docker에서 접근가능한 Mac의 내부 HostIP가 필요하다. SSHFS로  Mac의 디렉토리를 Boot2Docker에 마운트하기 위해서는 다음과 같이 사용한다.

```
sshfs -o allow_other {Mac계정}@{Boot2Docker에서 Mac에 접근할 수 있는 내무 HostIP}:/Users/saltfactory/shared /home/docker/shared
```

Boot2Docker에서 접근 가능하는 내부 HostIP는 `boot2docker config`에서 확인할 수 있다.

```
boot2docker config
```

위 명령어를 실행하면 아래와 같이 Boot2Docker의 설정을 볼 수 있는데 **HostIP** 값을 참조하면 된다. (아래 결과에서는 HostIP 값이 192.168.59.3 이다)

```
# boot2docker profile filename: /Users/saltfactory/.boot2docker/profile
Init = false
Verbose = false
Driver = "virtualbox"
Clobber = true
ForceUpgradeDownload = false
SSH = "ssh"
SSHGen = "ssh-keygen"
SSHKey = "/Users/saltfactory/.ssh/id_boot2docker"
VM = "boot2docker-vm"
Dir = "/Users/saltfactory/.boot2docker"
ISOURL = "https://api.github.com/repos/boot2docker/boot2docker/releases"
ISO = "/Users/saltfactory/.boot2docker/boot2docker.iso"
DiskSize = 20000
Memory = 2048
SSHPort = 2022
DockerPort = 0
HostIP = "192.168.59.3"
DHCPIP = "192.168.59.99"
NetMask = [255, 255, 255, 0]
LowerIP = "192.168.59.103"
UpperIP = "192.168.59.254"
DHCPEnabled = true
Serial = false
SerialFile = "/Users/saltfactory/.boot2docker/boot2docker-vm.sock"
Waittime = 300
Retries = 75

```

이제 SSFS로 Mac의 계정과 Boot2Docker의 HostIP를 이용하여 Mac에서 생성했던 `/Users/saltfactory/shared` 디렉토리를 Boot2Docker의 `/home/docker/shared`로 마운트를 시킨다.

```
sshfs -o allow_other saltfactory@192.168.59.3:/Users/saltfactory/shared /home/docker/shared
```

지금까지 문제 없이 진행하였다면 Mac의 디렉토리가 Boot2Docker 안에 정상적으로 마운트가 되어 두 디렉토리가 공유되고 있는 것을 확인할 수 있다. Mac의 디레토리에 파일을 만들면 자동으로 Boot2Docker에 마운트된 디렉토리 안에 파일이 보여지는 것을 확인할 수 있을 것이다.

Mac에서 파일을 만들어보자.

```
touch /Users/saltfactory/shared/README.md
```

Boot2Docker에서 파일이 보여지는지 확인해보자.

```
ls -l /home/docker/shared
```

ssfs로 마운트되어진 디렉토리는 다음과 같이 `fusermount` 명령어로 마운트를 해지할 수 있다.

```
fusermount -u /home/docker/shared
```


### 7. Dockerfile에 VOLUME을 지정 (Mac)
이제 Mac OS X에서도 Boot2Docker를 사용하지만 SSHFS를 이용하여 Mac의 디렉토리를 Boot2Docker로 마운트하였기 때문에, `Dockerfile` 안에 `VOLUME`을 사용하여 Boot2Docker에 마운트되어 있는 리렉토리를 Docker 컨테이너안에 마운트하여 공유할 수 있게 되었다. Dockerfile에 VOLUME을 추가한다.

```
FROM ubuntu:latest
MAINTAINER SungKwang Song <saltfactory@gmail.com>

... 생략 ...
VOLUME /shared
... 생략 ...
```

### 8. docker 실행

모든 설정이 끝났다. 마지막으로 docker를 실행하면서 Boot2Docker에 마운트된 디렉토리(`/home/docker/shared`)를 Docker 컨테이너 디렉토리로(`/shared`) 연결하도록 한다.

```
docker run -it -v /home/docker/shared:/shared ubunt:latest /bin/bash
```

이제 Mac에서 생성한 디렉토리(`/Users/saltfactory/shared`)가 docker 컨테이너 내부의 디렉토리(`/shared`)와 공유가 되었다. 왜 Mac의 디렉토리를 Docker 컨테이너로 마운트하는데 바로 하지 않고 Boot2Docker의 디렉토리를 마운트하는지는 앞에의 글에서 살펴보았듯이, Mac OS X -> Boot2Docker -> Docker로 마운트가 되어지기 때문이다. 즉, Boot2Docker의 디렉토리를 사용했지만 이 디렉토리는 Mac의 디렉토리의 마운트 포인트가 되고 있기 때문이다.

## 참조

* https://github.com/boot2docker/boot2docker#folder-sharing
* https://gist.github.com/codeinthehole/7ea69f8a21c67cc07293
* http://forum.docker.co.kr/t/osx-sshfs-osx/163


