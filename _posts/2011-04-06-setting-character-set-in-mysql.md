---
layout: post
title: MySQL 데이터베이스 캐릭터셋 (character set) UTF-8 설정
category: mysql
tags: [mysql, character, utf-8]
comments: true
redirect_from: /21/
disqus_identifier : http://blog.saltfactory.net/21
---

## 서론

mysql을 처음 설치하면 디폴트 캐릭터가 OS의 LANG에 영향을 받거나 Latin1으로 설정되어 있다.
지금 설치되어 있는 MySQL의  character 를 확인하려면 다음 명령어를 실행하면 알 수 있다.

```
show variables link 'c%'
```
만약 MySQL를 UTF-8로 되어 있지 않으면 MySQL 환경설정 파일에 character set 설정을 하여야 한다.
mysql의 디폴트 설정 파일은 /etc/my.cnf에 있다. 만약 특정 경로에 설치하였다면 my.cnf 파일을 열어서 수정하면 된다. 참고로, Mac용 MySQL .tar를 받아서 설치한 경우 압축을 풀어서 $MYSQL_HOME/support-files/my-large.cnf 파일을 /etc/my.cnf로 복사하여 작업하면 된다.

```
sudo cp $MYSQL_HOME/support-files/my-large.cnf /etc/my.cnf
```
```
sudo vi /etc/my.cnf
```
설정해야할 부분은 client, mysqld, mysql, mysqldump의 character set을 설정해야한다.
파일을 열어서 [client], [mysqld], [mysqldump], [mysql]을 차래로 찾아가면서 아래와 같이 설정한다.

```
[client]
default-character-set = utf8

[mysqld]
init_connect = SET collation_connection = utf8_general_ci
init_connect = SET NAMES utf8
#default-character-set = utf8
character-set-server = utf8
collation-server = utf8_general_ci

[mysqldump]
default-character-set = utf8

[mysql]
default-character-set = utf8
```

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
