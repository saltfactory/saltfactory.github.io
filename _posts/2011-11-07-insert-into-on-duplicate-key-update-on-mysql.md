---
layout: post
title: MySQL에서 특별한 값이 없으면 Insert하고 값이 있으면 Update하기
category: mysql
tags: [mysql]
comments: true
redirect_from: /54/
disqus_identifier : http://blog.saltfactory.net/54
---

## 서론

데이터베이스에 값을 입력(insert)할때 우리는 가끔 프로그램적으로 입력되길 바란다. 예를 들어서 사용자 이름은 유일하고 이메일 주소를 입력할때 가장 마지막에 입력된 값을 저장하고 싶어한다고 생각해보자.
<!--more-->

이 때 DBA와 프로그래머는 두가지 생각을 할 것이다.

1. Java나 Ruby, Python, PHP와 같은 프로그램 언어에서 데이터를 가져와서 업데이트 변경하는 작업하고 다시 저장하는 방법을 할 것이다. 물론 가능하지만 많은 데이터를 처리할 때는 한번의 쿼리에서 실행하는것이 더욱 효율적이다.
2. 사용자의 메일주소의 이력을 관리하고 결과를 가져올때 조인문을 사용해서 사용자별 연락처를 검색해서 그중에서 가장 최근에 입력된 이메일 주소를 가져올 것이다.

학생이라는 테이블과 학생 한명이 여러개의 메일 주소를 갖는 1:N의 형태를 갖는 테이블을 두개를 만들고 쿼리를 할때

```sql
SELECT stdents.name contacts.email FROM contacts, students
WHERE contacts.user_id = students.id AND students.name='saltfactory' ORDER BY id DESC LIMIT 1;
```

하지만 지난 이메일 주소는 참고할 일이 없기 때문에 더 이상 관리해야할 대상의 데이터가 아니므로  테이블로 따로 관리하지 않아도 된다. (물론 이번 예에서만 그렇다. 통합적이고 유연한 모델을 만들기 위해서는 사용자 정보에서 연락처 정보는 다른 엔터티로 관리하는게 효율적이다). 이럴때 사용자 이름과 이메일 주소가 들어올때 이미 저장되어 있는 사용자라면 이메일 주소를 update하면 되고 없는 사용자일 경우는 새롭게 insert하고자하는 쿼리문이 필요하다. Oracle에서는 case when then 이라는 것이 있지만 MySQL에서는 다른 방법으로 처리할 수 있는데 이것이 INSERT INTO ON DUPLICATE KEY UPDATE라는 것이다.
즉 어떠한 특정 컬럼에 Unique하다는 제약조건이 있다면 그 키를 가지고 있는 데이터가 들어오면 Insert를 실행하고, Unique한 키 값이 이미 있을 경우에는 Update를 실행하는 것이다.

테스트를 위해서 간단한 테이블을 준비했다.

```sql
DROP TABLE students;
CREATE TABLE students (
        name VARCHAR(25),
        email VARCHAR(255)
);

ALTER TABLE students ADD UNIQUE (NAME);
```

테스트할 테이블의 컬럼 중에 name 이라는 컬럼에 Unique 제약 조건을 추가했다. desc students; 를 실행하면 name 컬럼에 unique key가 생성되어 있는 것을 확인 할 수 있다.

![](http://cfile23.uf.tistory.com/image/13126C3F4EB788C808CCB8)

우선 이 테이블에는 아무런 데이터가 없다. select * from students;로 조회 하면 Empty set이라고 출력될 것이다.

![](http://cfile1.uf.tistory.com/image/1237E24C4EB788EC385CC8)

다음은 insert into on duplicate key update를 할 것이다. 만약에 saltfactory라는 사용자가 없다면 insert를 하고 이메일은 saltfactory@gmail.com을 입력하고, 만약 saltfactory라는 사용자가 존재하고 있다면 saltfactory@me.com을 이메일로 업데이트하라는 쿼리이다.

```sql
INSERT INTO students (NAME, email) VALUES ('saltfactory', 'saltfactory@gmail.com')
ON DUPLICATE KEY UPDATE name='saltfactory', email='saltfactory@me.com';
```

현재 아무런 값이 없기 때문에 insert를 하면서 saltfactory와 saltfactory@gmail.com을 입력할 것이다.

![](http://cfile7.uf.tistory.com/image/145F46354EB7897123DD17)

한번더 위 쿼리를 실행하면 saltfactory라는 이름이 이미 있으니 saltfactory@gmail.com의 이메일 주소가 saltfactory@me.com으로 업데이트 될 것이다.

![](http://cfile30.uf.tistory.com/image/1830913E4EB789BC1A1EC7)

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
