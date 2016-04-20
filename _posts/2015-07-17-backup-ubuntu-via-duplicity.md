---
layout: post
title: Ubuntu에서 Duplicity를 사용하여 암호화 백업 환경 구축하기
category: ubuntu
tags:
  - ubuntu
  - duplicity
  - backup
  - linux
comments: true
images:
  title: 'http://blog.hibrainapps.net/saltfactory/images/61576155-cbff-4de8-a7b5-243bb2e3d409'
---

## 서론

최근 [Ubuntu server](http://www.ubuntu.com/download/server)는 가장 인기 있는 리눅스 서버이다. 서버 운용에 필요한 편리한 패키지들이 많고, 패키지 관리가 쉽기 때문에 빠르게 서비스를 구축하거나 마이그레이션할 때 유용하다. Ubuntu는 많은 강점이 있지만 엔터프라이즈급 서버가 아니기 때문에 (이것은 오픈소스 운영체제의 장점이지만 단점이 아닐까 생각한다) 이유없이 죽거나 또는 물리적인 문제 때문에 서버 운영이 중단 될 수 있는 약간의 위험요소가 있다. 실제 git 서버를 Ubuntu에서 운영하다 디스크에 Bad block이 발생하여 서비스가 한동안 운영되지 못한 문제가 있었다. 다행히 복원은 하였지만 또 다시 발생할 수 있는 위험요소에 대처하기 위해서 백업 환경을 구축하기로 했다. 또한 보안이 필요한 파일들을 암호화해서 파일을 백업하는 기능이 필요했다. 이 글은 [duplicity](http://duplicity.nongnu.org/)를 사용하여 암호화 백업환경을 구축하는 방법에 대해서 소개한다.

<!--more-->

## Duplicity

예전에 백업을 위해서 bash로 스크립트를 만들었던 경험이 있다. Ubuntu 서버를 좀 더 ubuntu 스럽게 사용하기 위해서 Ubuntu에서 패키지를 사용하여 백업 환경을 구축하기로 결정했다. **Duplicity**는 우리의 요구사항을 만족시켜줬고 매우 **증분백업**, **암호화백업**, 그리고 **원격백업**을 지원하고 있기 때문에 이것을 즉시 도입했다. Duplicity는 다음과 같은 특징이 있다.

- **디렉토리 기반 백업**
- **[GnuPg](https://www.gnupg.org/)암호화 백업**
- **로컬 또는 원격백업**
- **rsync**
- **전체백업 또는 증분백업**
- **rdiff**

Ubuntu에서 **Duplicity**를 사용하기는 어렵지 않다. 기존의 다른 패키지를 설치하듯 **apt-get** 을 사용하여 패키지를 다룰 수 있기 때문이다.

```
apt-get install duplicity
```

## 백업 시나리오

**Duplicity**를 도입하여 백업을 하기 위한 시나리오는 다음과 같다.

- 서비스를 하고 있는 서버를 **"메인서버"**라고 정의한다.
- 원격에서 백업 파일이 복사되는 서버를 **"백업서버"**라고 정의한다.

1. 우리는 **"메인서버"**에서  [Yobi](http://yobi.io)를 사용하여 사내 git 호스팅 서비스를 하고 있다.
2. **"메인서버"**에서 Yobi에 데이터가 저장되는 디렉토리를 **"백업서버"**로 디렉토리를 백업을 하려고 한다.
3. **"백업서버"**로 백업할 때는 보안을 위해 백업 파일을 **암호화** 시켜 백업하려고 한다.
3. 디스크 공간 확보를 위해 파일이 변경된 것만 **증분백업**을 하기 원한다.
4. 언제든지 백업 내용을 확인할 수 있어야한다.
5. **"메인서버"**가 문제가 발생하였을 경우**"백업서버"**로부터 **단일파일/디렉토리 복원**이나 **멀티 파일/디렉토리 복원**을 지원해야한다.


## SCP(Secure Copy)

먼저 서버간 데이터를 복사하기 위해서는 파일복사 프로토콜이 필요하다. 우리는 보안에 민감한 데이터파일을 다른 서버로 전송해야하기 때문에 FTP를 사용하고 싶지 않았고, SSH 보안 프로토콜을 사용하는 [SCP(Secure Copy](https://en.wikipedia.org/wiki/Secure_copy)를 사용할 것이다.

**SCP**를 사용하여 **"메인서버"**의 디렉토리 데이터를 백업서버의 특정 디렉토리로 복사하는 방법을 살펴보자.

**CASE 메인서버:**

scp는 **ssh-client** 패키지에 포함이 되어 있다. **메인서버** ssh-client가 이미 설치되어 있으면 이 과정을 넘어간다. 만약 ssh-client가 없으면 **apt-get**을 사용하여 설치한다.

```
sudo apt-get install ssh-client
```

테스트를 진행하기 위해서 **mainuser**를 만들었다

```
useradd -ms /bin/bash mainuser
echo 'mainuser:mainuser' | chpasswd
```

그리고 백업할 데이터를 **/home/mainuser/data/seed.data** 에 만든다.

```
mkdir /home/mainuser/data
echo "test mainserver data backup" > /home/mainuser/data/seed.data
```

**tree**를 사용하여 **data**를 디렉토리를 살펴보자.

![샘플 데이터 구조](http://blog.hibrainapps.net/saltfactory/images/c0febede-87fd-4742-9a64-b0f554a11dd8)

**CASE 백업서버:**

**"백업서버"**는 **openssh-server**가 필요하다.

```
sudo apt-get install openssh-server
```
테스트를 진행하기 위해서 **backupuser**를 만들었다.

```
useradd -ms /bin/bash backupuser
echo 'backupuser:backupuser' | chpasswd
```

그리고 백업할 데이터가 복사될 디렉토리를 **/home/backupuser/backup/** 으로 만든다.

```
mkdir /home/backupuser/backup
```

**CASE 메인서버:**

이제 **"메인서버"**에서 **"백업서버"**로 파일을 복사해보자.

```
scp -r ~/data backupuser@backupServer:/home/backupuser/backup
```

![scp 복사 ](http://blog.hibrainapps.net/saltfactory/images/48b56012-cf62-4fda-9001-20174634f2cc)

**CASE 백업서버:**

**scp**로 복사가 완료되면 **"백업서버"**에서 **"메인서버"**로 부터 파일이 복사가 되었는지 확인해보자.

![backup 파일확인](http://blog.hibrainapps.net/saltfactory/images/9b3a9df0-064b-4842-ad8f-00b18b988ccc)

위에서 살펴보면 **SCP** 명령을 할 때 **비밀번호**를 입력하는 프롬프트가 나오는 것을 확인할 수 있다. 우리는 사람이 직접 복사를 하는 것이 아니라 특정 시점이 되면 서버가 자동으로 scp를 사용하기를 원한다. 그래서 비밀번호를 요구하지 않고 **백업서버**에 scp를 사용할 수 있는 설정을 할 것이다.

### RSA key기반 SSH 인증처리

SSH는 RSA키를 생성하여 생성된 키 기반으로 해당서버의 비밀번호 없이 로그인을 할 수 있다.

**CASE 메인서버:**

**"메인서버"**에서 **"백업서버"**로 로그인하기 위한 **RSA key**를 생성한다.

```
ssh-keygen -t rsa -b 2048
```

이때 나오는 질문에 대해서는 모두 **enter**로 비어 있는 값을 입력하면 된다.

![ssh-keygen](http://blog.hibrainapps.net/saltfactory/images/646a9017-a46a-43b9-8149-c0b185e3ee72)

이렇게 생성된 public key를 확인하면 다음과 같다.

```
cat ~/.ssh/id_rsa.pub
```

![id_rsa.pub](http://blog.hibrainapps.net/saltfactory/images/2e50b73c-36b4-4ecc-92f4-43ce558ca546)

**CASAE 백업서버:**

**"백업서버"**에서도 만약 만들어진 **RSA key** 가 없으면 **"메인서버"**와 동일하게 RSA key를 생성한다. 먼저 RSA key가 존재하는 **~/.ssh** 디렉토리를 확인하자.

```
ls ~/.ssh/
```

만약 사용하고 있는 key가 없으면 RSA key를 생성한다. 이 때 비밀번호를 입력하는 곳에는 비밀번호를 입력해도 상관이 없다. 이 키는 현재 **"백업서버"**를 위한 키 이기 때문이다.

```
ssh-keygen -t rsa -b 2048
```

**CASE 메인서버:**

다시 **"메인서버"**로 돌아가보자. 이제 위에서 **"백업서버"**에서 만든 키 파일을 가져와서 **"메인서버"**의 키를 추가할 것이다. 먼저 **"백업서버"**의 key를 가져와서 로컬에 복사한다. 아직은 이 때 **"백업서버"**의 비밀번호를 요구한다.

```
scp backupuser@backupServer:~/.ssh/id_rsa.pub ./authorized_keys
```
![copy backupserver id_rsa.pub](http://blog.hibrainapps.net/saltfactory/images/8c493c70-d977-4cfe-83b2-5454bc6cdb26)

복사한 **authorized_keys** 파일에는 **"백업서버"**의 key가 저장되어 있다. 이제  **"메인서버"**의 key를 이 파일에 추가한다.

```
cat ~/.ssh/id_rsa.pub >> ./authorized_keys
```

![id_rsa.pub 추가](http://blog.hibrainapps.net/saltfactory/images/b68b9964-3eda-4275-b1b7-0f4950be07af)

**"메인서버"**의 인증키가 저장된 파일을 다시 **"백업서버"**의 키 저장소로 복사한다.

```
scp ./authorized_keys backupuser@backupServer:~/.ssh/authorized_keys
```
이제 **"백업서버"**에 비밀번호 없이 접근할 수 있는 모든 설정이 끝났다. **ssh**로 **"백업서버"**에 접속해보자.

```
ssh backupuser@backupServer
```

![비밀번호 없이 ssh 로그인](http://blog.hibrainapps.net/saltfactory/images/2830dee6-febe-44d7-bb2e-65cfd4e13067)


ssh 프로토콜을 사용하는 **sftp**, **scp**로 모두 동일하게 비밀번호 없이 접근할 수 있게 되었다.

SCP에 관련된 데모를 서버가 없어 테스트를 할 수 없다면 github에 있는 docker 파일로 테스트를 할 수 있다. https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/scp

## GnuPG 파일 암호 설정

**CASE 메인서버:**

파일을 백업할 때 원본 데이터를 백업할 수도 있지만 보안상 다른 서버에 파일을 백업할 때는 파일을 암호화해서 복사해두는 것이 좋다. **Duplicity**에서는 [GnuPG](https://www.gnupg.org/)를 사용하여 파일을 암호화해서 백업을 할 수 있도록 지원한다. 이 기능을 사용하기 전에 GunPG key를 생성해야한다.

```
gpg --gen-key
```

위 명령어를 실행하면 다음과 같이 실행이 된다.

```text
gpg (GnuPG) 1.4.16; Copyright (C) 2013 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 2048
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: mainuser
Email address: mainuser@saltfactory.net
Comment: mainServer backup
You selected this USER-ID:
    "mainuser (mainServer backup) <mainuser@saltfactory.net>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

gpg: gpg-agent is not available in this session
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
............+++++
+++++
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
.......+++++
.+++++
gpg: /home/mainuser/.gnupg/trustdb.gpg: trustdb created
gpg: key 2AEE1A60 marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
pub   2048R/2AEE1A60 2015-07-17
      Key fingerprint = 4ED0 BAEC 47F9 30A9 ECD3  C559 CE4F 0449 2AEE 1A60
uid                  mainuser (mainServer backup) <mainuser@saltfactory.net>
sub   2048R/3AA6435D 2015-07-17
```

데모를 위해 생성한 **GnuPG**로 생성한 키는 **2AEE1A60** 이다.

**GnuPG**에 대한 사용방법은 http://blog.saltfactory.net/docker/generate-gpg-key-inside-docker.html 의 글을 참조하면 된다.

## Duplicity로 백업서버에 백업하기

**CASE 메인서버:**

**"mainServer"**의 파일을 **GnuPG**로 암호화해서 **"백업서버"**로 파일을 백업해보자. **Duplicity**의 백업은 **full**과 **incremental** 모드로 백업을 할 수 있다. 이것을 생략하면 자동으로 **full**로 백업을 한다.

```
duplicity --encrypt-key 2AEE1A60 ~/data scp://backupuser@backupServer/backup
```

![duplicity 백업](http://blog.hibrainapps.net/saltfactory/images/c5bd6fa5-e337-4fb2-90ff-07d4ed4ce3d5)

백업된 결과를 보면 **SouceFiles** 1개가 있고 에러 없이 백업이 완료되었다는 메세지를 받는다. 이렇게 백업을 하게 되면 백업으로 지정한 디렉토리 이하의 파일과 디렉토리들이 백업서버에 저장이 된다.

![백업 대상 내 백업](http://blog.hibrainapps.net/saltfactory/images/6440598c-8a7a-4eb3-9347-5f6d93d77370)

대상 디렉토리까지 모두 백업하려면 다음과 **--include**와 **--exlcude** 옵션을 추가해야한다. 예를 들어 **/home/mainuser/data/** 에서 **data/** 디렉토리부터 백업하려면 다음과 같이 **/home/mainuser** 디렉토리를 백업하는데 모든 것을 exclude 시키고 **/home/mainuser/data**만 include 시키도록 한다.

```
duplicity --encrypt-key 2AEE1A60 --include /home/mainuser/data --exclude '**' /home/mainuser scp://backupuser@backupServer/backup
```
![백업대상 백업](http://blog.hibrainapps.net/saltfactory/images/a4a90aa5-daf6-42bb-b14a-6aaff8411b25)


**CASE 백업서버:**

**"백업서버"**에서 백업된 파일을 확인하자. 백업서버에서는 **/home/backupuser/backup** 디렉토리에 백업 파일이 **GnuPG**로 암호화되어 저장되었다.

![백업파일 ](http://blog.hibrainapps.net/saltfactory/images/9230f814-cf18-4436-b876-7d654d76ad7e)


## Duplicity로 복구하기

**CASE 메인서버:**

백업을 하는 목적은 만약에 원본 파일에 문제가 발생했을 때를 대비하기 위해서이다. 서버에 파일이 어떤 원인으로 삭제되었다고 가정해보자.

**"메인서버"**에서 원본 파일을 삭제한다.

```
rm -rf data/
```

**"백업서버"**에서 백업된 파일 리시트를 확인한다.

![백업대상 백업](http://blog.hibrainapps.net/saltfactory/images/4d33a3cc-e839-4b3e-a132-a0b1924582e3)

삭제된 **data/** 디렉토리를 복원한다. 데이터를 복원하기 위해서 다음과 같이 **duplicity restore** 로 복원할 수 있다. 복원을 할 때는 **GnuPG** 비밀번호를 물어본다. 비밀번호는 **GnuPG 키**를 생성할 때 입력했던 비밀번호를 입력하면 된다.

```
duplicity restore scp://backupuser@backupServer/backup data
```
![디렉토리 복원](http://blog.hibrainapps.net/saltfactory/images/6fe43061-e4d3-4c83-b976-0a6598e59c4f)


만약에 파일 하나만 복원하고 싶을 경우 다음과 같이 **--file-to-restore** 옵션을 사용한다. 위에서 백업된 리스트를 확인하면 **seed.data** 파일이 목록에서 보일 것이다. 원본 파일 **seed.data**를 삭제하고 백업서버에서 파일을 복원한다.

```
rm seed.data
```
```
duplicity restore --file-to-restore seed.data scp://backupuser@backupServer/backup seed.data
```
![파일 복원](http://blog.hibrainapps.net/saltfactory/images/7a1bd27f-e756-468f-a136-27ef9f02fd5f)

## 백업 스케줄링 등록

마지막으로 **"메인서버"**의 스케즐링에 백업작업을 등록한다. Ubuntu에서는 [Cron](https://en.wikipedia.org/wiki/Cron) 스케줄링을 좀 더 직관적으로 사용할 수 있도록  **cron.daily/**, **cron.hourly/**, **cron.monthly/**, **cron.weekly/** 를 미리 만들어서 추가해 두었다. 이것은 **/etc/crontab** 안에 정의가 되어 있다.

```bash
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
```

만약 백업을 매일 하고 싶을 경우 **/etc/cron.dail/** 디렉토리 안에 작업 내용을 추가한 bash 파일을 넣어두면 cron 데몬이 자동으로 6시 25분에 실행을 시킬 것이다. 작업을 추가해보자. 백업은 주기적으로 백업을하면 디스크 공간을 많이 찾이하고 파일이 많이지면 백업하는데 시간이 오래 걸린다. 실제 백업을 할 때는 **incremental** 로 백업을 하면 효과적이다.

```
vi /etc/cron.daily/backup
```
```bash
#!/bin/sh
duplicity incremental --encrypt-key 2AEE1A60 /home/mainuser/data scp://backupuser@backupServer/backup
```
저장한 파일의 권한을 변경한다.
```
chmod 755 /etc/cron.daily/backup
```

이제 백업에 관한 모든 설정이 끝났다. 매일 아침마다 자동으로 백업이 진행이 될 것이다.

## 결론

이 글을 포스팅하기 위해서 [SCP에 관련된 예제](https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/scp)와 [GPG에 관련된 예제](https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/gpg)를 **docker**에서 테스트할 수 있도록 준비했었다. 또한 [docker에서 GnuPG 키 생성 문제 해결과 파일 암호화/복호화 하기](http://blog.saltfactory.net/docker/generate-gpg-key-inside-docker.html) 글을 앞에서 준비했다. **Ubuntu** 서버를 운영하면서 **백업**에 대해서 좀 더 신경을 써고 싶다고 생각한다면 **Duplicity**를 사용하면 대안이 될 것이다. Duplicity는 강력한 백업과 복원 기능을 가지고 있고 **증분백업**과 **파일암호화**를 지원하기 때문에 **보안**과 **디스크용량**에 대해서 좀 더 효과적으로 사용할 수 있다. 이 글에 대한 내용또한 docker에서 테스트할 수 있도록 준비했다. 다시 말해서 docker에서 운영하는 서버 백업도 **Duplicity**를 사용하여 백업할 수 있을 것이다.

## 실습

- https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/duplicity

## 참고

1. http://duplicity.nongnu.org/
2. http://duplicity.nongnu.org/duplicity.1.html
3. https://help.ubuntu.com/community/DuplicityBackupHowto#Backup
4. http://ifdattic.com/howto-encrypted-backup-with-duplicity/
5. http://www.evbackup.com/support-misc-duplicity/
6. https://zertrin.org/how-to/installation-and-configuration-of-duplicity-for-encrypted-sftp-remote-backup/

