---
layout: post
title : MySQL에서 Insert할때 not exists를 이용하여 동일한 데이터가 없을 경우만 입력하는 방법
category : mysql
tags : [mysql, database]
comments : true
redirect_from : /19/
disqus_identifier : http://blog.saltfactory.net/19
---

## 서론

Oracle에서는 exists라는 예약어가 있듯 MySQL에서도 exists와 not exists 라는 예약어가 있다. 이 예약어는 스카마에 데이터가 포함되어 있는지 또는 없는지를 확인하는데 사용되는 목적에 사용된다. not exits를 잘 활용하면 데이터를 입력할 때 중복된 되이터는 입력하지 않게 처리할 수 있다.
제약 조건을 이용하면 제약조건이 맞지 않는다는 에러나 예외처리를 해야하는데 not exists를 이용하면 이런 제약조건 위반없이 데이터를 유일하게 입력할 수 있다.

<!--more-->

```sql
INSERT INTO table (field)
SELECT 'value' FROM DUAL
WHERE NOT EXISTS (SELECT * FROM table WHERE field='value')
```

실제 예를 들어서 RssItems라는 테이블 안에 link값을 저장하는데 http://blog.saltfactory라는 한번 저장된 link가 있는 경우는 입력하지 않게하려고 할때 다음과 같이하면 된다.

```sql
INSERT INTO RssItems (link)
SELECT 'http://blog.saltfactory.net' FROM DUAL
WHERE NOT EXISTS (SELECT * FROM RssItems WHERE link='http://blog.saltfactory.net')
```

## 참고

1. http://dev.mysql.com/doc/refman/5.0/en/exists-and-not-exists-subqueries.html

