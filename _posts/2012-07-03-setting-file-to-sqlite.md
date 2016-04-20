---
layout: post
title: SQLite 디폴트 환경설정 저장하여 사용하기
category: database
tags: [database, sqlite]
comments: true
redirect_from: /162/
disqus_identifier : http://blog.saltfactory.net/162
---

## 서론

SQLite는 임베디드 시스템에서 상요하던 데이터베이스였는데 최근 스마트폰과 데스크탑의 브라우저 벤더들이 사용하면서 SQLite는 Oracle, SQLServer, MySQL과 더불어 가장많이 사용하고 알려진 DBMS가 되었다. 그런데 SQLite를 사용하다보면 궁금한 점이 생긴다. Oracle, SQL Server, MySQL들은 모두 화려하고 사용하기 좋은 GUI (상용, 무료 포함)가 있는 반면에 SQLite의 GUI는 그렇게 사용하기 좋은 툴이 없다는 것이다. 물론 Firefox의 plugins으로 사용할 수 있고, 오픈소스로된 약간 퀄리티가 낮은 GUI가 존재하긴 하지만 뭔가 아쉬움이 남는다. 그래서 스마트폰 개발을 할 때 대부분 터미널에서 sqlite3 명령어를 가지고 조회하고 데이터베이스 작업을 한다.

<!--more-->


## 데이터 파일 생성

SQLite를 이용해서 테이블을 만들고 조회를 한다고 가정해보자.
우선 sqlite3를 이용해서 sqlite 데이터 파일을 작성할 준비를 하자.

```
sqlite3 sample.sqlite
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/14fa5869-cad7-45d1-be49-f23dc77433dc)

sample.sqlite 데이터베이스가 열어진 상태에서 테스트를 하기 위한 테이블을 만들어보자.

```
CREATE TABLE users ( id INTEGER, name TEXT);
```

그리고 테스트를 위한 데이터를 입력해보자.

```
INSERT INTO users VALUES (1, 'saltfactory');
INSERT INTO users VALUES (2, 'lightfactory');

```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/14a23d35-df3e-4263-95f3-50a2ce3f2f82)

데이터를 입력했으니 조회를 해보자.

```
SELECT * FROM users;
```

Oracle이나 MySQL을 사용하던 사용자라면 SQLite의 SELECT 결과를 보고 실망을 했을지 모른다. SQLite의 SELECT 모드가 디폴트는 line mode에다가 header off가 기본적으로 되어 있기 때문이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6a285f2d-9393-4b70-824f-265a0d387475)

## .mode colue

우리는 Oracle과 MySQL과 같은 출력포멧을 원하기 때문에 column mode로 변경해보자.

```
.mode column
```

column mode로 변경한 다음에 다시 SELECT를 실행하면 다음과 같이 라인으로 출력되었던 튜플들이 column 형태로 출력되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5736bd7e-0feb-4582-bafc-16c61495da5c)


## .header on

형태는 컬럼 형태로 출력되지만 attribute가 어떤 컬럼에 해당되는지 알기 힘들기 때문에 header on을 하여 컬럼이름을 출력하도록 해보자.

```
.header on
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5062f007-8cf7-4a7f-a63b-a0f584c1db69)

## .width

이제 우리가 출력하기 원했던 모양대로 출력되는 것을 확인할 수 있다. 그런데 자세히 살펴보면 입력했던 값이 제대로 출력되지 않고 있다는 것을 확인할 수 있다. lightfactory 라고 입력했던 2번째 튜플의 name 값을 보면 lightfactor 라고 y가 잘려서 출력된 것이 확인된다. 우리는 이제 column의 사이즈를 .width 라는 명령어로 조절할 것이다. 컬럼의 순서대로 사이즈를 지정하면 된다.

```
.width 10, 20
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2c8a52e3-bea1-4315-8f27-754215127d82)

## .quit

이제 우리가 생각했던 형태로 완벽하게 출력이 되었다. 이제 sqlite 를 나가서 다시 들어오도록 해보자.

```
.quit
```

그리고 다시 SELECT를 실행하면 위의 설정들이 모두 무시되고 SQLite에 설정한 기본 설정으로 출력이 되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c810862c-fe77-484a-bab5-d20bf4a35018)

## .sqliterc

터미널에서 SQLite에 접속할 때마다 이렇게 수동으로 설정한다면 매우 불편할 것이다.

그래서 SQLite의 설정을 미리 파일에 저장하고 SQLite에 접속할 때 그 파일의 정보를 읽어와서 환경설정을 적용하게 해보자.
홈디렉토리 밑에 .sqliterc 파일을 만들고 환경설정 정보를 입력한다.

```
vi ~/.sqliterc
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c43672be-6d1e-49ce-919d-2199565ba9cf)

설정 정보를 저장한 뒤 SQLite에 다시 접속해서 SELECT 명령어를 실행해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/530d1c60-40bd-428e-9e2c-2955c2389d56)

이제부터는 SQLite를 사용할 때는 라인모드가 아닌 컬럼모드로 컬럼헤더를 확인하면서 사용할 수 있게 되었다.

## 참고

1. http://www.sqlite.org/sqlite.html
2. http://stackoverflow.com/questions/5240643/change-sqlite-default-settings

