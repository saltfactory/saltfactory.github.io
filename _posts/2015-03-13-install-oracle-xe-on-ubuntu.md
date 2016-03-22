---
layout: post
title: Ubuntu에 Oracle XE 설치하기
category: linux
tags: [database, ubuntu, oracle]
comments: true
redirect_from : /267/
disqus_identifier : http://blog.saltfactory.net/267
---

## 서론

기존의 Redhat 계열의 리눅스 서버 운영체제를 **Ubuntu** 서버로 운영하기 위해서 여러가지 서비스를 새롭게 설치해야한다. 최근의 오픈소스 프로젝트로 만들어지는 패키지들은 특정 운영체제와 상관없이 대부분의 운영체제의 기본 패키지로 포함이 되어 있거나 새롭게 컴파일해서 설치할 수 있도록 배포하고 있다. Oracle은 오픈소스 프로젝트가 아니다. **Oracle Express Edition**으로 무료 소프트웨어를 배포하고 있지만 리눅스 환경에서 RPM 패키지 관리툴로 설치할 수 있도록 배포하고 있다. 기존의 Redhat 계열 리눅스 서버에서는 RPM으로 설치가 가능했지만 **Ubuntu** 서버로 변경하면서 **Oracle XE**를 설치하는 메뉴얼이 필요해 서 Oracle XE를 Ubuntu에 설치하는 방법에 대해서 소개한다. 설치하는 과정 중에 **리눅스 커널 파라미터 설정**과 **공유메모리 설정** 부분을 주의하지 않아 오류는 없지만 설치후 Oracle이 동작하지 않는 문제를 발견했었다. 이 문서에서 이와 같은 문제를 겪을 때 해결할 수 있는 방법을 소개한다.

<!--more-->

## Ubuntu

최근 국내에서 가장 있기는 리눅스 서버는 [Ubuntu](www.ubuntu.com/)라고해도 과언이 아닐 것이라 생각이된다. **Ubuntu**는 [Debian](https://www.debian.org/)를 기반으로 만들어졌다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/531f6662-d1bb-468c-b07f-e8db1c8acb87)

그래서 안정적이고 편리하게 패키지를 관리할 수 있는 장점을 가지고 있다. 무엇보다도 현재 리눅스 커뮤니티 중에서 가장 엑티브하게 활동하는 곳이 Ubuntu이기 때문에 온라인 자료가 많은 것이 최고의 장점이다. **Debian**은 오픈 소스 프로젝트 가운데 하나로 37,500개의 패키지를 갖춘 저장소를 관리하기 때문에 패키지 사용이 편리하다. [Redhat](http://redhat.com) 계열이 [yum](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/ch-yum.html)으로 패키지를 관리할 수 있다면 **Debian** 계열은 [apt-get](https://wiki.debian.org/apt-get)로 패키지를 관리할 수 있다. **Ubuntu**는 Desktop 버전 위주로 개발을 진행해왔기 때문에 서버 패키지보다 업데이트 주기가 빠른 편이라 최신 라이브러리들을 사용할 수 있는 장점이 있다. 하지만 너무 빠른 업데이트 주기 때문에 안정성이 낮아질 수 있기 때문에 [LTS(Long Term Support)](https://wiki.ubuntu.com/LTS) 버전으로 만들어진 서버를 배포하고 있는데 **5년**동안 지속적인 관리를 보장 받을 수 있다. 현재 가장 안정화된 서버 버전은 [12.04LTS](http://releases.ubuntu.com/12.04/)이다.

## Oralce Express Edition

[Oracle XE(Express Edition)](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html)는 상용 Oracle의 무료로 사용할 수 있는 Oracle DBMS로 사용 Oracle의 대부분의 기능을 사용할 수 있기 때문에 개발자나 관리자들이 빠르게 개발을 하거나 실험을 위해서 사용할 수 있다. **Oracle XE**는 무료이지만 오픈소스 프로젝트는 아니다. 이러한 이유로 위에서 말한 오픈소스 패키지 저장소에서 패키지를 관리할 수 없고, Oracle 공식 사이트에서 [Linux용 Oracle-XE](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)를 다운 받을 수 있다. Oracle는 [Oracle Linux](http://www.oracle.com/us/technologies/linux/overview/index.html) 운영체제를 배포하고 있는데  Oracle Linux는 Redhat 계열이고 이것은 [rpm](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Deployment_Guide/ch-rpm.html)이라는 패키지 관리툴로 패키지를 설치할 수 있다. Oracle은 **Oracle XE** Linux 버전을 rpm 파일 형태로 배포하고 있다. **Oracle XE 10g** 버전까지는 **32bit**를 지원했지만 Oracle은 더이상 **Oracle XE 10g**를 배포하고 있지 않고, **Oracle XE 11g** 부터 **64bit**만 배포하고 있다.

## Ubuntu에 Oracle XE 설치

### Ubunut 64Bit 확인

**Oracle XE**는 11g 버전을 배포하면서 32bit 지원을 중단하고 64bit만 배포하고 있다. (32bit는 Windows용만 지원을 한다.) 다시 말해서 **Oracle XE**를 설치하기 위해서는 서버 운영체제가 64bit 운영체제야 한다. Ubuntu에서 현재 시스템이 64bit인지를 확인해보자.

```
uname -i
```

결과가 `x86_64`로 나오면 현재 설치된 운영체제는 64bit이다.

### Oralce XE 다운로드

위에서 설명했듯 **Oracle XE**는 오픈소스가 아니기 때문에 오픈소스 패키지를 관리하는 저장소에서 패키지 관리툴로 설치할 수 없다. **Oracle XE**는 Oracle 공식 사이트에 `RPM` 파일 형태로 배포되고 있다. 가장 최신 **Oracle XE**를 다운 받는다. (Oracle XE를 다운로드하기 위해서는 Oracle 사이트 계정이 필요하다. Oracle 계정으로 로그인 후 다운로드를 할 수 있기 때문에 Curl이나 wget으로 서버에서 바로 다운받을 수 없고 PC에 다운 받아서 서버로 다운 받은 파일을 업로드해야 한다.)

[Oracle XE 다운로드](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) 에서 Linux용 64비트를 다운받는다. 현재 배포 버전은 **Oracle Database Express Edition 11g Release 2 for Linux x64** 이다.


### Oracle XE 설치에 필요한 패키지

Ubuntu에서는 `.rpm` 파일을 사용해서 패키지를 설치할 수 없기 때문에 PRM 파일을 Debian 계열의 패키지 설칠를 위한 `.deb` 파일로 변경하여 패키지를 설치해야한다.
Ubuntu에 **Oracle XE**를 설치하기 위해서 필요한 패키지들이 있는데 다음과 같다.

* **[alien](https://help.ubuntu.com/community/RPM/AlienHowto)** : RPM 패키지를 Debian 패키지로 변환하는 툴
* **[libaio1](http://packages.ubuntu.com/lucid/libs/libaio1)** : Linux 커널 AIO[Asynchronous I/O](http://lse.sourceforge.net/io/aio.html) 엑세스 라이브러리
* **[unixodbc](http://packages.ubuntu.com/lucid/unixodbc)** : [ODBC(Open Database Connectivity)](http://en.wikipedia.org/wiki/Open_Database_Connectivity) 라이브러리

필요한 패키지를 `apt-get` 명령어를 이용하여 root 권한으로  설치한다.

```
sudo apt-get install -y alien libaio1 unixodbc
```

### RPM 파일을 DEB 파일로 변환

다운받은 `.rpm` 파일을 **Ubuntu**에 설치하기 위해서 **alien**을 사용하여 `.deb` 파일로 변경한다.

```
sudo alien --scripts -d oracle-xe-11.2.0-1.0.x86_64.rpm
```

위 명령어를 실행하면 한참의 시간이 지난 이후  같은 경로에 `oracle-xe_11.2.0-2_amd64.deb` 파일이 생성된다.

### /sbin/chkconfig

Rethat 패키지들은 설치할 때 `/sbin/chkconfg`를 사용하는데 **Ubuntu**에는 없기 때문에 이와 동일한 환경을 만들어주기 위해서 아래 내용을 가지고 `/bin/chkconfig` 파일을 생성한다.

```
sudo vi /sbin/chkconfig
```

```bash
#!/bin/bash
# Oracle 11gR2 XE installer chkconfig hack for Ubuntu
file=/etc/init.d/oracle-xe
if [[ ! `tail -n1 $file | grep INIT` ]]; then
echo >> $file
echo '### BEGIN INIT INFO' >> $file
echo '# Provides: OracleXE' >> $file
echo '# Required-Start: $remote_fs $syslog' >> $file
echo '# Required-Stop: $remote_fs $syslog' >> $file
echo '# Default-Start: 2 3 4 5' >> $file
echo '# Default-Stop: 0 1 6' >> $file
echo '# Short-Description: Oracle 11g Express Edition' >> $file
echo '### END INIT INFO' >> $file
fi
update-rc.d oracle-xe defaults 80 01
#EOF
```

파일 생성 이후 이 파일을 실행할 수 있도록 파일 권한을 **755** 변경한다.

```
sudo chmod 755 /sbin/chkconfig
```

### Kernel 파라미터 설정

**Oracle**는 서버를 운영하는데 커널파라미터 설정이 필요한데 시스템 컨트롤 데몬에 시스템 파라미터 설정을 저장하여 등록한다. Oralce은 Linux 커널의 파라미터를 사용하여 운영되기 때문이다.

* **[fs.file-max](http://docs.oracle.com/cd/B28359_01/server.111/b32009/appc_linux.htm#UNXAR011)** : 오픈하는 파일의 수를 지정하는 커널 파리미터(각 오라클 인스턴스는 512*PROCESSES만큼 file descriptior를 가진다.)
* **[net.ipv4.ip_local_port_range](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Adjusting_Network_Settings-Changing_Network_Kernel_Settings.html)** : 이 값은 TCP와 UDP의 트래픽을 위한 범위를 설정하는 커널 파라미터
* **kernel.sem** : 세마포를 지정하는 커널 파라미터
* **kernel.shmmax** : 공유 메모리 페이지를 지정하는 커널 파라미터

```
sudo vi /etc/sysctl.d/60-oracle.conf
```

```
# Oracle 11g XE kernel parameters
fs.file-max=6815744
net.ipv4.ip_local_port_range=9000 65000
kernel.sem=250 32000 100 128
kernel.shmmax=536870912
```
시스템컨트롤러 데몬에 커널파라미터를 설정하였으면 커널 파라미터를 로드한다.

```
sudo service procps start
```

## Oracle XE가 사용할 파일 추가

**Oracle XE**는 `/bin/awk`를 사용하게 되는데 Ubuntu에는 `/usr/bin/awk`에 설치되어 있기 때문에 다음과 같이 심볼릭링크를 만들어준다.

```
sudo ln -s /usr/bin/awk /bin/awk
```

**Oracle XE**는 리스너가 사용할 lock 파일을 만들어준다.

```
sudo mkdir /var/lock/subsys
```

```
sudo touch /var/lock/subsys/listener
```

## 메모리 설정

**Oracle XE**를 설치하고 나서 특별한 에러 없이 Oracle 프로세스가 리스너만 시작되고 다른 프로세스가 실행되지 않는 문제를 만날 수 있다. **Oralce XE**를 설치할 때 정상적으로 설치가 되지 않거나 오류가 발생하게되면 `$ORACL_HOME`안의 `log` 디렉토리를 살펴보면 된다. 설치가 정상적으로 되지 않거나, 설치는 되었는데 에러 없이 Oracle이 정상적으로 시작이 되지 않을 경우 로그를 살펴보면**ORA-000845:MEMORY_TARGET** 에러가 발생하게 되는 경우가 있는데 메모리의 설정이 잘못되거나 사이즈가 부족해서 그런 경우이다. 이런 경우 메모리 설정을 위해서 다음 과정을 진행한다.

먼저 현재 설정되어 있는 **shared memeory**를 삭제한다.

```
sudo rm -rf /dev/shm
```

새롭게 SHM을 만들어서 마운트를 시킬 수 있게 다시 만든다.

```
sudo mkdir /dev/shm
```

```
sudo mount -t tmpfs shmfs -o -size=4096m /dev/shm
```

shm 설정을 데몬에 등록해서 로드하도록 하기 위해서 다음 내용을 `/etc/rc2.d/S01shm_load` 파일로 등록한다.

```
sudo vi /etc/rc2.d/S01shm_load
```

```
#!/bin/sh
case "$1" in
start) mkdir /var/lock/subsys 2>/dev/null
touch /var/lock/subsys/listener
rm /dev/shm 2>/dev/null
mkdir /dev/shm 2>/dev/null
mount -t tmpfs shmfs -o size=4096m /dev/shm ;;
*) echo error
exit 1 ;;
esac
```

```
sudo chmod 755 /etc/rc2.d/S01shm_load
```

### Oracle XE 패키지 설치

**Oracle XE**를 설치하기 위한 **Ubuntu**의 환경설정은 끝났다. 이제 **Oracle XE**를 설치하기 위해 `.rpm`을 `.deb` 파일로 변환한 패키지를 설치한다.

```
sudo dpkg --install oracle-xe_11.2.0-2_amd64.deb
```
정상적으로 설치가 되면 다음과 같이 **Oracle XE**가 설치되고 데몬을 자동으로 등록하게 된다.

```
Selecting previously unselected package oracle-xe.
(Reading database ... 72392 files and directories currently installed.)
Preparing to unpack ./oracle-xe_11.2.0-2_amd64.deb ...
Unpacking oracle-xe (11.2.0-2) ...
Setting up oracle-xe (11.2.0-2) ...
Executing post-install steps...

 Adding system startup for /etc/init.d/oracle-xe ...
   /etc/rc0.d/K01oracle-xe -> ../init.d/oracle-xe
   /etc/rc1.d/K01oracle-xe -> ../init.d/oracle-xe
   /etc/rc6.d/K01oracle-xe -> ../init.d/oracle-xe
   /etc/rc2.d/S80oracle-xe -> ../init.d/oracle-xe
   /etc/rc3.d/S80oracle-xe -> ../init.d/oracle-xe
   /etc/rc4.d/S80oracle-xe -> ../init.d/oracle-xe
   /etc/rc5.d/S80oracle-xe -> ../init.d/oracle-xe

You must run '/etc/init.d/oracle-xe configure' as the root user to configure the database.

Processing triggers for ureadahead (0.100.0-16) ...
Processing triggers for desktop-file-utils (0.22-1ubuntu1) ...
Processing triggers for mime-support (3.54ubuntu1.1) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
```

설치가 모두 마친 이후 **Oracle XE**를 사용하기 위해 Oracle 최초 설정을 `/etc/init.d/oracle-xe configure`로 설정한다.

```
sudo /etc/init.d/oracle-xe configure
```

최초 설정 내용은 다음과 같이 서비스 포트설정과 패스워드 설정이다.

* Specify the HTTP port that will be used for Oracle Application Express [8080]:
* Specify a port that will be used for the database listener [1521]:
* Specify a password to be used for database accounts.


### 환경변수 설정

**Oracle XE** 설치가 모두 끝나면 Oracle에 관련된 환경 변수를 추가한다.

```
vi ~/.bashrc
```

```
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`
export ORACLE_BASE=/u01/app/oracle
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$PATH
```

```
source ~/.bashrc
```

**Ubuntu** 서버 전체에 사용하는 변수에 등록하고 싶으면 `/etc/environment` 파일에 위 내용을 추가한다.


### 상태 확인

설치가 모두 끝나면 정상적으로 운영되고 있는지 다음과 같이 확인한다. Oracle의 네트워크 상태를 확인하기 위해서 리스너가 정상적으로 동작하고 있는지 확인한다.

```
lsnrctl status
```
만약 리스너가 정상적으로 동작하고 있으면 다음과 같은 결과를 출력할 것이다.

```
LSNRCTL for Linux: Version 11.2.0.2.0 - Production on 13-MAR-2015 13:54:41

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC_FOR_XE)))
STATUS of the LISTENER

Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.2.0 - Production
Start Date                13-MAR-2015 10:32:50
Uptime                    0 days 3 hr. 21 min. 53 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Default Service           XE
Listener Parameter File   /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/brainoffice1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC_FOR_XE)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=brainoffice1.hibrain.net)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=brainoffice1.hibrain.net)(PORT=8080))(Presentation=HTTP)(Session=RAW))
Services Summary...
Service "PLSExtProc" has 1 instance(s).
  Instance "PLSExtProc", status UNKNOWN, has 1 handler(s) for this service...
Service "XE" has 1 instance(s).
  Instance "XE", status READY, has 1 handler(s) for this service...
Service "XEXDB" has 1 instance(s).
  Instance "XE", status READY, has 1 handler(s) for this service...
The command completed successfully

```

설치한 Oracle에 로그인 해보자. SYS와  SYSTEM 계정의 초기 비밀번호는 설치할 때 입력한 비밀번호를 사용한다.

```
sqlplus system
```

정상적으로 로그인이 되면 다음과 같은 화면이 출력되면서 Oracle에 접속이 된다.

```
SQL*Plus: Release 11.2.0.2.0 Production on Fri Mar 13 13:59:40 2015

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL>
```

## Oracle XE 삭제

만약 **Oracle XE**를 설치하는 도중에 에러가 발생하여 재설치를 해야하는 경우나 완전히 삭제해야하는 경우는 다음과 같이 삭제한다.

* **Oracle XE** 서비스를 정지한다.

```
sudo service oracle-xe stop
```

* **Oracle XE** 패키지를 삭제한다.

```
 sudo dpkg --purge oracle-xe
```

* **Oracle** 디렉토리를 삭제한다.

```
sudo rm -rf /u01/app
```

* **Oracle XE** 데몬을 삭제하고 갱신하다.

```
sudo rm /etc/default/oracle-xe
```

```
sudo update-rc.d -f oracle-xe remove
```

* **Ubuntu** 설정 파일을 삭제한다.

```
sudo rm /sbin/chkconfig /etc/rc2.d/S01shm_load /etc/sysctl.d/60-oracle.conf
```

* **Oracle XE** 리눅스 계정을 삭제한다.

```
sudo userdel -r oracle
```

```
sudo delgroup dba
```

## 결론

Oracle은 가장 많이 사용하고 있는 RDBMS이다. 프로젝트를 진행할 때 Oracle 기반의 어플리케이션을 개발하기 위해서는 Oracle 서버가 필요한데 개발용 서버에 Oracle을 가볍게 설치하고 운영하기 위해서 **Oracle XE**를 설치하여 운영할 수 있다. Oracle XE는 Redhat 계열에 설치할 수 있는 RPM 파일 형태로 배포하고 있다. 최근 Ubuntu 리눅스 서버가 패키지 관리의 편리성과 활발한 커뮤니티 활동으로 많은 인기를 얻고 있어 Ubuntu 리눅스를 도입하게 될 때 Oracle XE를 설치기 위해서는 `.rpm` 파일을 `.deb` 파일로 변경하여 설치하는 방법이 필요하다. 이때 Redhat 계열에 최적화되어 있는 환경을 Ubuntu에 맞게  **rpm에 관련된 파일**, **커널 파라미터**, 그리고 **공유 메모리**에 관련되어 설정을 해야한다. 이에 관한 내용을 조사하고 설치시 발생한 문제를 해결했다. 설치 후 에러는 없지만 Oracle이 정상적으로 실행이 되지 않을 때 `$ORACLE_HOME/log` 디렉토리 안에 있는 로그 파일을 분석하면 이 문서에서 소개하는 내용의 문제로 실행이 되지 않는 경우를 발견했었다. Ubuntu에서 Oracle을 운영할 경우나 새롭게 설치해야하는 경우 이 문서를 참조하면 개발 환경을 구축하는데 도움이 될 수 있을것으로 기대된다.



## 참조

* http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm
* http://blog.whitehorses.nl/2014/03/18/installing-java-oracle-11g-r2-express-edition-and-sql-developer-on-ubuntu-64-bit/
* http://meandmyubuntulinux.blogspot.kr/2012/05/installing-oracle-11g-r2-express.html


