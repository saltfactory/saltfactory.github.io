---
layout: post
title: Mac OS X에 Oracle Instant Client 설치하여 SQL*Plus 사용하기
category: database
tags: [database, oracle, mac, client, install]
comments: true
redirect_from: /237/
disqus_identifier : http://blog.saltfactory.net/237
---

## 서론

Oralce에서는 Mac을 위한 공식적은 DBMS 설치 파일을 제공하지 않는다. 하지만 Instant Client를 제공하고 있기 때문에 Oracle 데이터베이스 프로그램을 하기 위해서는 Mac용 **Oracle Instance Client**를 설치해야한다. 이번 포스트에서는 Mac에서 Oracle Instance Client를 설치하여 **SQL*Plus**를 사용하는 방법에 대해 소개한다.

<!--more-->


![oracle](http://cfile6.uf.tistory.com/image/210B8D3E53604DE411AA4B)

개발용으로 맥(Mac OS X)은 더 없이 훌륭한 랩탑이다. 유닉스 기반의 운영체제이기 때문에 서버 프로그램과 클라이언트 프로그램을 동시에 작업하거나 테스트할 수 있기 때문이다. 맥은 대부분의 웹 서버와 데이터베이스를 설치해서 개발할 수 있다. 대부분 벤더에서 Mac 용 버전을 개발하고 배포하고 있는데 Oracle은 Databsae를 공식적으로 Windows와 Linux 플랫폼을 Mac용은 지원하지 않는다. 다만 Mac에서 Oracle Database에 접근할 수 있는 client를 지원 하고 있다. (물론 VM을 설치해서 사용은 가능하지만 이것은 논외로 생각한다.). Oracle Instant Client는 Oracle Database에 접근할 수 있는 sqlplus 를 지원하고 있을 뿐만 아니라, Oracle 기반 Application을 개발할 때 특별히 수정해서 소스를 재 컴파일할 필요 없고 적은 용량의 디스크에서도 바로 사용할 수 있게 경량으로 프로그램과 라이브러리를 담고 있는 패키지이다.

> 다시 한번 언급하지만 이 포스팅은 Oracle Database를 Mac에 설치하는 것이 아니라, 원격에 있는 Oracle Database에 접근할 수 있는 Mac용 Oracle instant client의 설치에 대해서 소개한다.

## Oracle instant client 다운로드

Oracle의 instant client 다운로드는 다음에서 제공한다.
http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html

다양한 플랫폼을 지원하고 있지만 우리는 Mac 에 설치할 것이기 때문에 Instant Client for Mac OS X (Intel x86)(32-bit and 64-bit) 를 선택한다.
Mac OS X은 PPC, 32-bit, 64-bit 버전이 있기 때문에 자신이 어떤 운영체제를 사용하고 있는지 잘 확인하고 다운로드 한다.

만약 Mac의 운영체제가 몇 비트인지 알고 싶으면 uname -a 를 사용하여 확인이 가능하다.

```
uname -a
```

![uname](http://cfile24.uf.tistory.com/image/262EB3415360543709492D)

Mac OS X가 **64-bit** 운영체제일 경우 **RELEASE_X86_64 x86_64**가 나타날 것이고, **32-bit** 일 경우 **RELEASE_I386 i386**으로 나타난다. 이 글을 포스팅할 때 Oralce instant client의 가장 최근 버전은 Version 11.2.0.4.0(64-bit) 이다.

필요한 파일을 모두 다운로드 받은 후 특정 경로로 이동한다. 관리의 편리성을 위해서 `/Projects/Servers/Libraries/Oracle/instantclient_11_2` 에 다운로드 받은 모든 파일을 이동시켰다.

![instantclient directory](http://cfile8.uf.tistory.com/image/22614A48536056891B854F)

## 시스템 환경변수 추가

Oracle instant client 파일을 모두 다운받은 후 특정 경로로 이동시킨 이후에는 환경변수를 설정하는 작업을 한다. `$HOME/.bash_profile`을 열어서 다음과 같이 Oracle 환경 변수를 추가한다.

```
vi ~/.bash_profile
```

```bash
export DYLD_LIBRARY_PATH="/Projects/Libraries/Oracle/instantclient_11_2"
export TNS_ADMIN="/Projects/Libraries/Oracle/instantclient_11_2"
export ORACLE_HOME="/Projects/Libraries/Oracle/instantclient_11_2"
export OCI_LIB="/Projects/Libraries/Oracle/instantclient_11_2"
export OCI_INCLUDE_DIR="/Projects/Libraries/Oracle/instantclient_11_2/sdk/include"

export PATH=$DYLD_LIBRARY_PATH:$PATH
```

`$HOME/.bash_profile`에 환경변수를 추가한 다음 .bash_profile을 시스템에 적용하기 위해서 `source`를 실행한다.

```
source ~/.bash_profile
```

Oracle instant client는 특별한 소스 컴파일 없이 바이너리 파일을 다운로드 받아서 환경설정만 해주면 바로 사용할 수 있다.

## SQL*Plus 사용

Oracle 데이터베이스에 접근하기 위해서는 [SQL\*Plus](http://docs.oracle.com/cd/B28359_01/server.111/b31189/toc.htm)를 사용하면 되는데 이것은 우리가 다운로드 받은 Oracle instant client에 안에 들어있다. **SQL\*PLus**를 이용해서 서버에 접근하는 방법은 보통 [Local Naming Parameters](http://docs.oracle.com/cd/B28359_01/network.111/b28317/tnsnames.htm)를 저장하는 `tnsnames.ora` 파일을 사용해서 사용하는데 Oracle instant를 다운 받은 파일에는 이 파일이 존재하지 않는다. sqlplus를 이용할때 `tnsnames.ora` 파일이 없어도 Oracle에 접근할 수 있는데 방법은 다음과 같다.

```
sqlplus {계정}/{비밀번호}@{파리미터}
```

자세히 살펴보면 다음과 같다. 다음 정보를 이용해서 원격에 있는 Oracle로 접속을 할 수 있다. Oracle은 서버에 설치할 때 설치 정보로 다음과 같은 정보를 필수로 가진다.

- **호스트이름** : Oracle DBMS가 설치되어 있는 서버이름 또는 IP
- **포트번호** : 디폴트 값은 1521
- **서비스아이디** : 같은 호스트에서 서비스의 구분을 위해서 설정하는 SID가 있다, Oracle 라이센스가 없는 일반 학생일 경우는 Oracle Express 버전을 사용할 것이고 디폴트 값은 XE 이다.

```
sqlplus {계정}/{비밀번호}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=호스트이름 또는 아이피)(PORT=포트번호))(CONNECT_DATA=(SID=서비스아이디)))
```

```
sqlplus tutorial/tutorial@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=192.168.0.123)(Port=1521))(CONNECT_DATA=(SID=XE)))
```

아래는 위의 sqlplus 를 이용해서 Oracle에 접속한 결과이다. 우리가 사용한 Oracle instant client의 SQL*Plus는 11.2.0.4.0 버전이고 서버에는 Oracle Database 10g Express Edition Release 10.2.0.1.0이 설치되어 있다는 것을 확인할 수 있다.

![sqlplus connect](http://cfile29.uf.tistory.com/image/2441914C53605D8E2999C0)

## OID 에러 해결

위와 동일하게 진행했는데 만약 다음과 같이 **OID 에러**가 발생하는 경우가 있을 것이다. [OID](http://www.oracle.com/technetwork/middleware/id-mgmt/overview/index-082035.html)는 [Oracle Internet Directory](http://www.oracle.com/technetwork/middleware/id-mgmt/overview/index-082035.html)를 말하는 것으로 [Oracle Fusion Middleware](http://www.oracle.com/us/products/middleware/overview/index.html)의 [Tier Identity Management Oracle Internet Directory](http://docs.oracle.com/cd/E27559_01/integration.1112/e27123/topology.htm)의 표준이다. OID는 [LDAP3](http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol)(Light weight Directory Access Protocol)로 구현이 되어 있고 Microsoft의 Active Directory의 Oracle 버전이라 생각하면 된다. 이때 OID는 호스트 validation을 체크하는데 `/etc/hosts`에 `hostname`이 없으면 OID에러를 발생한다.

![oid error](http://cfile5.uf.tistory.com/image/22464C4353605ED6184380)

Oracle instant client 10.x 버전에는 발생하지 않았는데 Oracle instant client 11.x 버전부터 OID 에리거 발생을 하는데 이럴 경우 `/etc/hosts` 파일에 현재 자신의 컴퓨터의 hostname을 추가한다.

먼저 자신의 hostname을 살펴본다.

```
hostname
```

![hostname](http://cfile6.uf.tistory.com/image/274E6F365360609C19DB43)

현재 사용하고 있는 Mac의 hostname은 saltfactory이다. 이젠 `/etc/hosts` 파일을 열어서 다음과 같이 `hostname`을 추가한다.

```
sudo vi /etc/hosts
```

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost saltfactory
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
```

이렇게 `/etc/hosts`에 `hostname`을 추가한뒤 다시 `sqlplus`를 사용해서 oracle에 접속하면 OID 에러 없이 접속할 수 있는 것을 확인할 수 있다.

## tnsnames.ora 사용

tnsnames.ora 파일은 Oracle client나 Application에서 Oracle에 접근하기 위한 Local Naming Parameters를 가지고 있는 파일이다.
이 파일을 사용하면 위에서 tnsnames를 사용하지 않은 sqlplus 접속 할때의 긴 파라미터를 간단하게 이름으로 대처할 수 있다.

우선 우리가 `TNS_ADMIN`으로 환경설정한 경로로 이동한다.(우리는 편의상 `$ORACLE_HOME`과 `$TNS_ADMIN` 경로를 같이 설정했다.)

```
cd $TNS_ADMIN
```
이제 다음 내용을 가지고 tnsnames.ora 파일을 만든다. 우리는 TestServer라는 이름에 다음 설정을 추가한다.

```
TestServer =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.123)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = XE)
    )
  )
```

이렇 `tnsnames.ora` 파일을 작성했으면 `sqlplus`를 이용해서 다음과 같이 사용할 수 있다.

```
sqlplus tutorial/tutorial@TestServer
```

## 결론

이 포스팅은 Mac 운영체제 안에서 다른 원격지에 있는 Oracle 데이터베이스에 접근하기 위해서 Oracle instant client를 설치하는 방법을 소개했다. Oracle instant client의 sqlplus와 tnsname을 설정해서 데이터베이스에 접근하는 소개를 했는데 Oracle instant client는 sqlplus 이외에 다양한 라이브러리가 들어 있어 웹 프로그램이나 기타 어플리케이션을 만들 때 반드시 필요한 라이브러리들도 포함이 되어 있다. 이에 대한 사용법과 설명은 다른 포스팅에서 소개를 할 기회가 있을 것이다. MySQL이나 SQLite처럼 Mac에서 Oracle을 바로 설치해서 개발하면 참 좋겠지만 공식적으로 Oracle은 Mac 버전을 지원하지 않고 Oracle instant client만을 제공하고 있다. 앞으로 Oracle 기반 어플리케이션 개발을 하기 위해서는 Oracle instant client는 반드시 필요하기 때문에 이 포스팅으로 간단하게 설치방법과 sqlplus를 이용해서 Oracle에 접속하는 방법을 소개했다.

## 참고

1. http://www.oracle.com/technetwork/database/features/instant-client/index-100365.html
2. http://docs.oracle.com/cd/E21764_01/oid.1111/e10029/concepts.htm
3. http://docs.oracle.com/cd/B19306_01/network.102/b14213/tnsnames.htm#i500409

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
