---
layout: post
title : Mac OS X에 Oracle Instant Client 설치하기
category : oracle
tags : [oracle, mac, osx, client, inteall]
comments : true
redirect_from : /48/
disqus_identifier : http://blog.saltfactory.net/48
---

오라클에 접속하거나 오라클을 사용하는 프로그램을 작성하기 위해서 오라클 클라이언트가 필요한데 오라클에서는 instant client라는 것을 제공하여 인스톨하지 않고 압축파일만 풀어서 오라클 클라이언트를 사용할 수 있게 해준다. 인스턴스 클라이언트를 다운받는 곳은 다음과 같다. http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html
<!--more-->

개발 환경은 '11 초기형 맥북프로 모델에 64비트 맥 라이언(Mac OS X 10.7)을 사용한다. 그래서 x64 버전을 다운로드 설치하면 될거라 예상했지만, 설치후 sqlplus를 실행시키면 segment 11 fault 에러가 났다. OTN 포럼에서 검색한 결과 BDD 인터페이스를 perl 32비트를 사용하고 있어서 32비트를 다운받아서 사용하라는 글을 보고 x86을 다운 받아서 설치하니 이상없이 사용 가능했다. 그럼.. X64는 왜 만든거지?? 라는 이상한 의문이 들었다. 혹시 이 포스트를 보고 이유를 아시는 분께 조언을 부탁해본다.

우선 x86 파일 4가지를 다운 받는다.

- instantclient-basic-10.2.0.4.0-macosx-x86.zip
- instantclient-sdk-10.2.0.4.0-macosx-x86.zip
- instantclient-jdbc-10.2.0.4.0-macosx-x86.zip
- instantclient-sqlplus-10.2.0.4.0-macosx-x86.zip

디렉토리는 아무곳에 설치해도 상관이 없지만 개발의 편리를 위해서 /Projects/Servers/Oracle/instantclient 밑에 설치하려고한다. 다운 받은 파일은 이 디덱토리 밑으로 모두 mv 시켰다. 그리고 unzip 명령어를 사용해 모두 압축을 해제했다. 압축을 해제하면 instantclient_10_2라는 폴더가 생성되고 압축을 해제한 파일들은 모두 그 안에 들어있게 된다.

![](http://blog.hibrainapps.net/saltfactory/images/e5f6f33a-c5d1-47e7-9bdc-eb4799bf9710)

프로파일을 열어서 환경변수를 등록하고 프로파일을 다시 로드한다.

```
vi ~/.profile
```

```bash
export ORACLE_HOME=/Projects/Servers/Oracle/instantclient/instantclient_10_2
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
export SQLPATH=$ORACLE_HOME
export PATH=$PATH:$SQLPATH:
```

```
source ~/.profile
```

이제 sqlplus 를 사용할 수 있게 되었다.

![](http://blog.hibrainapps.net/saltfactory/images/fec64c35-e653-4aa6-81f8-5474e783084c)

