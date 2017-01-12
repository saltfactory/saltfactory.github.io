---
layout: post
title : MySQL에서 사용하는 Lock 이해
category : database
tags : [database, mysql, lock]
comments : true
redirect_from: /107/
disqus_identifier : http://blog.saltfactory.net/107
---

## 서론

운영체제에서 공유하고 있는 리소스의 접근을 경쟁하는 것을 제어하기 위해서 Lock이라는 개념을 사용한다. 데이터베이스도 리소스의 접근을 제어하기 위해서 Lock이라는 개념을 사용한다. Lock에 대한 이해 없이 사용하다가 다른 작업 때문에 테이블이나 행이 잠겨버 쿼리가 기다리는 상황이 발행해서 리소스 접근을 하는데 문제가 생기기도 한다. 뿐만 아니라 Lock을 어떻게 만들고 해지하는지에 대한 이해가 있어야 만약에 Lock이 발생하고 해지되지 않을 때 어떻게 Lock 프로세스를 멈추게 할 수도 있을 것이다. 트랜잭션 기반의 멀티프로세스나 멀티 쓰레 프로그램을 작성한다면 반드시 Lock의 개념을 알아야 데드락에 걸리거나 예외가 발생하는 프로그램을 작성하지 않을 수 있을 것이라고 생각이 든다. 실제 예제를 보면서 MySQL의 락을 어떻게 설정하는지 어떻게 동작하는지 이해하기 위해서 포스팅을 준비했다.

MySQL에서 Lock은 크게 Table Lock, Global Lock, Name Lock, User Lock 이 있다. 이 예제들을 살펴보고 마지막으로 InnoDB의 ROW 레벨의 락을 살펴 볼 것이다.

<!--more-->

## Table Lock

테이블락은 어떤 세션에서 테이블 자원에 엑세스하여 데이터를 읽거나 쓰기를 할때 다른 세션에서는 테이블 자원에 대한 엑세스를 제한 하는 락이다. 세션에서 명시적으로 테이블 락을 사용하면 그 세션에서 락을 해지하지 않으면 다른 세션에서는 접근을 하지 못하게 된다. 테이블 락을 사용하기 위해서는 테이블 락 권한을 가지고 있어야 가능하다.

MyISAM 스토리지 엔진으로 테이블을 생성한다. MyISAM은 테이블 레벨 락을 사용한다.

```
mysql> create table messages (
    id int auto_increment primary key,
    message varchar(140)) ENGINE=MyISAM;
Query OK, 0 rows affected (0.05 sec)

mysql> show table status where name='messages'\G
*************************** 1. row ***************************
           Name: messages
         Engine: MyISAM
        Version: 10
     Row_format: Dynamic
           Rows: 0
 Avg_row_length: 0
    Data_length: 0
Max_data_length: 281474976710655
   Index_length: 1024
      Data_free: 0
 Auto_increment: 1
    Create_time: 2012-03-06 09:59:34
    Update_time: 2012-03-06 09:59:34
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options:
        Comment:
1 row in set (0.00 sec)
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/624937f2-388a-49d9-b07c-04142fcf9374)

![](http://asset.blog.hibrainapps.net/saltfactory/images/5fe51055-31f9-4ba9-baea-e4d5bb065143)

두 세션이 열린 터미널을 살표보면 다음과 같이 두번째에 write lock을 실행하려면 명령어가 끝나지 않는 것을 확인 할 수 있다. 서버 단에서 Lock을 기다리는 쿼리의 목록을 볼 수 있는데 다음 명령어로 서버 수준에서 락을 기다리는 쿼리를 확인할 수 있다.


```
SHOW PROCESSLIST;
```

서버 수준에서 락이 되어서 기다리고 있는 쓰레드의 번호는 5번이고 LOCK TABLE messages WRITE 라는 쿼리문이 대기하고 있는 시간이 현재 300 miliseconds 라는 것을 확인할 수 있다.

```
mysql> SHOW RROCESSLIST \G
*************************** 1. row ***************************
     Id: 1
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
*************************** 2. row ***************************
     Id: 5
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 300
  State: Locked
   Info: LOCK TABLES messages WRITE
2 rows in set (0.00 sec)

명시적인 read 락을 해지하면 자동적으로 write 락이 명시적인 락으로 설정이 될 것이다. 다음 명령어로 락을 해지한다.
```

```
UNLOCK TABLES;
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/76796970-5a7e-4ebb-8e2e-9fcb7e0e5031)

read 락이 해지되면서 locked 되어 있던 5번 쓰레드의LOCK TABLE messages WRITE; 쿼리가 실행되면서 messages 테이블에 write 락이 명시적으로 설정되었다. open tables from {데이터베이스 명} 이라는 명령어로 현제 cached 된 테이블의 정보를 볼 수 있는데 지금 현재 테이블이 LOCK 되어 사용 중이라는 것을 확인 할 수 있다.


```
mysql> SHOW OPEN TABLES FROM test \G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 1
Name_locked: 0
1 row in set (0.00 sec)
```

write 락도  해지하고 다시 명령어를 실행해보자. 모든 락이 해지되어서 테이블에 현재 사용되는 세션이 없다는 것을 확인할 수 있다.

```
mysql> UNLOCK TABLES;
Query OK, 0 rows affected (0.00 sec)

mysql> show open tables from test \G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 0
Name_locked: 0
1 row in set (0.00 sec)
```

READ 락은 락을 명시적으로 사용한 세션과 모든 세션에서 insert, update, delete가 불가능하고 select만 가능하다.

```
mysql> LOCK  TABLE messages READ;
Query OK, 0 rows affected (0.00 sec)
```

다음은 messages 테이블에서 READ 락을 명시적으로 사용하고 그 세션에서 insert 쿼리 쓰레드의 결과 이다.

```
mysql> INSERT INTO messages (message) VALUES ('test');
ERROR 1099 (HY000): Table 'messages' was locked with a READ lock and can't be updated
```

다른 세션에서 insert 쿼리 쓰레드를 실행하면 READ 락이 해지될때까지 대기하고 있다.

WRITE 락은 락을 명시적으로 사용한 세션에서의 쓰레드만 read, wrtite 가 가능하다.

다음은 messages 테이블에서 WRITE 락을 명시적으로 사용하고 그 세션에 select 와 write를 허용하고 나머지 세션의 쓰레드에서는 read, wrtie 모두 락이 해지 될때까지 대기한다. 다음 예제를 보면 WRITE 락을 사용한 세션에서는 insert와 select가 사용 가능하지만 다른 세션에서 select 조회를 하면 그 세션의 쓰레드가 LOCKED 된 것을 확인할 수 있다.

```
mysql> LOCK TABLES messages WRITE;
Query OK, 0 rows affected (0.00 sec

mysql> INSERT INTO messages (message) VALUES ('test');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM messages \G
*************************** 1. row ***************************
     id: 1
message: test


mysql> SHOW PROCESSLIST \G
*************************** 1. row ***************************
     Id: 1
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
*************************** 2. row ***************************
     Id: 2
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 469
  State: Locked
   Info: select * from messages
2 rows in set (0.00 sec)
```

하지만 이렇게 테이블 락 때문에 다른 쓰레드가 계속적으로 대기만 한다면 교착상태에 빠지게 될 것이다. 그래서 최대 대기하는 시간의 설정을 변경할 수 도 있다. 테이블 락의 최대 대기 시간을 조회하기 위해서는 다음 명령어로 조회할 수 있다.

```
SHOW VARIABLES WHERE VARIABLE_NAME='table_lock_wait_timeout';
```
```
mysql> show variables where variable_name='table_lock_wait_timeout'\G
*************************** 1. row ***************************
Variable_name: table_lock_wait_timeout
        Value: 50
1 row in set (0.00 sec)
```

또한 mysqladmin debug를 사용해서 어느 테이블에 lock이 어떤 레벨로 설정되어 있는지 확인 할 수 있다. $MYSQL_HOME/data/{호스트명}.err 파일 안에 다음과 같이 test 데이터베이스의 messages 테이블에 write 락이 설정 되어 있는 것을 확인 할 수 있다.

```
Thread database.table_name          Locked/Waiting        Lock_type

1       test.messages               Locked - write        High priority write lock
```

## Global Lock

정확하게 말하면 글로벌 리드 락 (Global Read Lock)이다. 현재 세션 자체에서 글로벌하게 READ LOCK을 사용할 때 flush tables 명령으로 사용할 수 있다.

```
FLUSH TABLES WITH READ LOCK;
```
```
mysql> FLUSH TABLES WITH READ LOCK;
Query OK, 0 rows affected (15.74 sec)

mysql> show open tables from test\G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 0
Name_locked: 0
1 row in set (0.00 sec)
````

글로벌 리드 락을 설정한후 messages 테이블을 살펴보면 테이블 레벨의 락이 걸려 있지 않는 상태이다. 다른 세션에서 messages 테이블에 WRITE 락을 명시적으로 사용하게 되면 글로벌 리드 락 때문에 대기를 하게 된다.

```
mysql> show processlist\G
*************************** 1. row ***************************
     Id: 3
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 229
  State: Waiting for release of readlock
   Info: lock tables messages write
*************************** 2. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)
```

## Name Lock

네임락은 자세하게 문서로 정의 된 곳을 찾을 수 없어서 GET_LOCK에 사용하는 name string과 이해하기에 혼동될 수 있다. 테이블은 이름을 변경하거 삭제될때 테이블 레벨에서 묵시적으로 네임 락을 사용한다. 만약 이미 WRITE 락이 걸려 있는 테이블을 삭제한다고 할때를 살펴보자.

```
mysql> lock table messages write;
Query OK, 0 rows affected (0.00 sec)

mysql> show open tables from test\G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 1
Name_locked: 0
1 row in set (0.01 sec)
```

이렇게 messages 테이블에 WRITE 락이 걸려 있는 상태에서 다른 세션에서 messages 테이블을 drop 하려고 한다.

```
mysql-2> drop table messages;
```

이렇게 테이블을 삭제하거나 테이블 이름을 변경할 때는 네임 락이 걸리는 것을 확인할 수 있다.

```
mysql> show processlist \G
*************************** 1. row ***************************
     Id: 3
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 19
  State: Waiting for table
   Info: drop table messages
*************************** 2. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)

mysql> show open tables from test\G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 2
Name_locked: 1
1 row in set (0.00 sec)
```

만약에 messages에 락이 걸려있는 상태에서 다른 세션에서 messages 테이블 이름을 new_messages라고 변경한다고 할때는 다음과 같이 이전 테이블과 새로 변경될 테이블의 이름에 락이 걸리는 것을 확인할 수 있다.

```
mysql-2> rename table messages to new_messages;
```

WRITE 락을 사용한 세션에서 쓰레드의 상태와 테이블의 상태를 살펴보면 네임 락이 걸려 있는 것을 확인 할 수 있다.

```
mysql> show processlist\G
*************************** 1. row ***************************
     Id: 3
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 123
  State: Waiting for table
   Info: rename table messages to new_messages
*************************** 2. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)

mysql> show open tables \G
*************************** 1. row ***************************
   Database: test
      Table: messages
     In_use: 2
Name_locked: 1
*************************** 2. row ***************************
   Database: test
      Table: new_messages
     In_use: 1
Name_locked: 1
2 rows in set (0.00 sec)
```

## User Lock

사용자 레벨에서 락을 걸수 있는 방법이 있는데 이 방법은 락의 이름과 그 락의 타임아웃을 정의해서 사용하는 방법이다. GET_LOCK(str, timeout)이라는 메소드를 사용하여 락을 만들고 다른 세션에서 이 락의 이름이 있는지를 확인하고 있을 경우 정해진 타임 아웃기간 동안 락을 걸 수 있다. 그리고 락을 해지하기 위해서는 RELEASE_LOCK(str)을 명령을 사용한다. 이 방법은 Advisory Locking이라고도 한다.

두개의 세션을 열고 하나의 세션에서 다음 문장을 실행해보자. 'user_define_lock'이라는 락을 10초동안 유지하도록 하였다.

```
mysql> select GET_LOCK('user_define_lock', 10)\G
*************************** 1. row ***************************
GET_LOCK('user_define_lock', 10): 1
1 row in set (0.00 sec)
```

이제 다른 세션에서 다음 문장을 실행해보자.

```
mysql-2> select GET_LOCK('user_define_lock', 10)\G
*************************** 1. row ***************************
GET_LOCK('user_define_lock', 10): 1
1 row in set (0.00 sec)
```

다시 처음 user_define_lock을 설정한 세션에 살펴보면 User Lock에 걸려서 대기하고 있다는 것을 확인할 수 있다.

```
mysql> show processlist\G
*************************** 1. row ***************************
     Id: 3
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 2
  State: User lock
   Info: select GET_LOCK('user_define_lock', 10)
*************************** 2. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)
```

다시 두번째 세션의 터미널로 돌아가보면 10초가 지났기 때문에 Lock이 해제된 것을 확인 할 수 있다.

```
mysql> select GET_LOCK('user_define_lock', 10)\G
*************************** 1. row ***************************
GET_LOCK('user_define_lock', 10): 0
1 row in set (10.01 sec)
```

유저 락을 해지하기 위해서는 RELEASE_LOCK(str)을 상용해야한다. 만약 정의된 락의 이름이 있을 경우는 1 아닐 경우는 NULL을 출력하면서 유저 락을 해지한다.

```
mysql> select GET_LOCK('user_define_lock', 10)\G
*************************** 1. row ***************************
GET_LOCK('user_define_lock', 10): 1
1 row in set (0.00 sec)

mysql> select RELEASE_LOCK('user_define_lock')\G
*************************** 1. row ***************************
RELEASE_LOCK('user_define_lock'): NULL
1 row in set (0.00 sec)
```

## InnoDB의 ROW 레벨 Lock

위의 내요은 MyISAM 엔진에서 모두 사용이 가능한 락이지만 InnoDB는 MyISAM과 달리 row 레벨 락을 지원한다.
InnoDB 엔진으로 messages 테이블을 만들자, 위 예제를 계속 따라 왔더라면 네임 락 예제에서 기존의 messages 테이블은 new_messages로 변경되어 있을 것이다.

```
mysql> create table messages (
    -> id int auto_increment primary key,
    -> message varchar(140)) engine=InnoDB;
Query OK, 0 rows affected (0.06 sec)

mysql> show table status where name = 'messages'\G
*************************** 1. row ***************************
           Name: messages
         Engine: InnoDB
        Version: 10
     Row_format: Compact
           Rows: 0
 Avg_row_length: 0
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 11534336
 Auto_increment: 1
    Create_time: 2012-03-06 16:12:50
    Update_time: NULL
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options:
        Comment:
1 row in set (0.00 sec)
```

InnoDB 스토리지 엔진을 사용하기 때문에 트랜잭션을 사용할 수 있게 되었다. 이제 데이터를 입력하고 트랜잭션을 시작하여 row 레벨 락을 걸어 보겠다.

```
mysql> insert into messages (message) values ('test');
Query OK, 1 row affected (0.00 sec)

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT * FROM messages WHERE id = 1 LOCK IN SHARE MODE \G
*************************** 1. row ***************************
     id: 1
message: test
1 row in set (0.00 sec)
```

이제 두번째 세션에서 id=1로 락을 걸어둔 row를 삭제하려고 한다. 락 최대 시간이 다되면 타임아웃 에러를 발생시킨다.

```
mysql-2> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql-2> delete from messages where id = 1;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
```

InnoDB의 락의 타임아웃 설정은 다음과 같이 확인할 수 있다.


```
mysql> show variables where variable_name = 'innodb_lock_wait_timeout'\G
*************************** 1. row ***************************
Variable_name: innodb_lock_wait_timeout
        Value: 50
1 row in set (0.00 sec)
```

row 락에 걸려 있는 상태에서 프로세스 리스트를 확인해보자.

```
mysql> show processlist\G
*************************** 1. row ***************************
     Id: 3
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 10
  State: updating
   Info: delete from messages where id = 1
*************************** 2. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)
```

이제 다시 돌아와서 첫번째 세션에서 id=1인 row를 삭제해보자.

```
mysql> delete from messages where id = 1;
Query OK, 1 row affected (0.00 sec)
```

첫번째 세션에 데이터를 삭제하는 순간 두번째 세션에 대기를 하고 있던 쓰레드는 deadlock 에러를 발생 시킨다. 이미 삭제하고 난 값을 다시 삭제하려 하기 때문이다.

```
mysql> delete from messages where id = 1;
ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction
```

InnoDB의 락 상태를 확인하기 위해서는 SHOW INNODB STATUS를 사용하면 된다.

```
*************************** 1. row ***************************
  Type: InnoDB
  Name:
Status:
=====================================
120306 16:30:42 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 39 seconds
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 20, signal count 20
Mutex spin waits 0, rounds 180, OS waits 9
RW-shared spins 20, OS waits 10; RW-excl spins 1, OS waits 1
------------------------
LATEST DETECTED DEADLOCK
------------------------
120306 16:16:46
*** (1) TRANSACTION:
TRANSACTION 0 28163, ACTIVE 29 sec, OS thread id 4353515520 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 368, 1 row lock(s)
MySQL thread id 3, query id 113 localhost root updating
delete from messages where id = 1
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 0 page no 230 n bits 72 index `PRIMARY` of table `test`.`messages` trx id 0 28163 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 4; compact format; info bits 0
 0: len 4; hex 80000001; asc     ;; 1: len 6; hex 000000006e01; asc     n ;; 2: len 7; hex 800000002d0110; asc     -  ;; 3: len 4; hex 74657374; asc test;;

*** (2) TRANSACTION:
TRANSACTION 0 28162, ACTIVE 61 sec, OS thread id 4389679104 starting index read, thread declared inside InnoDB 500
mysql tables in use 1, locked 1
4 lock struct(s), heap size 1216, 2 row lock(s)
MySQL thread id 7, query id 114 localhost root updating
delete from messages where id = 1
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 0 page no 230 n bits 72 index `PRIMARY` of table `test`.`messages` trx id 0 28162 lock mode S locks rec but not gap
Record lock, heap no 2 PHYSICAL RECORD: n_fields 4; compact format; info bits 0
 0: len 4; hex 80000001; asc     ;; 1: len 6; hex 000000006e01; asc     n ;; 2: len 7; hex 800000002d0110; asc     -  ;; 3: len 4; hex 74657374; asc test;;

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 0 page no 230 n bits 72 index `PRIMARY` of table `test`.`messages` trx id 0 28162 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 4; compact format; info bits 0
 0: len 4; hex 80000001; asc     ;; 1: len 6; hex 000000006e01; asc     n ;; 2: len 7; hex 800000002d0110; asc     -  ;; 3: len 4; hex 74657374; asc test;;

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter 0 28180
Purge done for trx's n:o < 0 28179 undo n:o < 0 0
History list length 5
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0 28179, ACTIVE 465 sec, OS thread id 4353515520 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 368, 1 row lock(s)
MySQL thread id 3, query id 137 localhost root updating
delete from messages where id = 1
------- TRX HAS BEEN WAITING 41 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 0 page no 230 n bits 72 index `PRIMARY` of table `test`.`messages` trx id 0 28179 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 4; compact format; info bits 0
 0: len 4; hex 80000001; asc     ;; 1: len 6; hex 000000006e10; asc     n ;; 2: len 7; hex 800000002d0110; asc     -  ;; 3: len 4; hex 74657374; asc test;;

------------------
---TRANSACTION 0 28177, ACTIVE 572 sec, OS thread id 4389679104
2 lock struct(s), heap size 368, 1 row lock(s)
MySQL thread id 7, query id 139 localhost root
show innodb status
--------
FILE I/O
--------
I/O thread 0 state: waiting for i/o request (insert buffer thread)
I/O thread 1 state: waiting for i/o request (log thread)
I/O thread 2 state: waiting for i/o request (read thread)
I/O thread 3 state: waiting for i/o request (write thread)
Pending normal aio reads: 0, aio writes: 0,
 ibuf aio reads: 0, log i/o's: 0, sync i/o's: 0
Pending flushes (fsync) log: 0; buffer pool: 0
30 OS file reads, 69 OS file writes, 46 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2,
0 inserts, 0 merged recs, 0 merges
Hash table size 17393, node heap has 1 buffer(s)
0.00 hash searches/s, 0.00 non-hash searches/s
---
LOG
---
Log sequence number 0 5243606
Log flushed up to   0 5243606
Last checkpoint at  0 5243606
0 pending log writes, 0 pending chkp writes
34 log i/o's done, 0.00 log i/o's/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 21160914; in additional pool allocated 693760
Dictionary memory allocated 37240
Buffer pool size   512
Free buffers       486
Database pages     25
Modified db pages  0
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages read 23, created 2, written 53
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
Buffer pool hit rate 1000 / 1000
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
1 read views open inside InnoDB
Main thread id 4369481728, state: waiting for server activity
Number of rows inserted 3, updated 0, deleted 2, read 5
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================

1 row in set, 1 warning (0.00 sec)
```

## 결론

이 포스트는 MySQL의 Lock에 대한 이해를 위해서 작성한 것이고 특정한 환경에서 가장 최적의 Lock을 어떤 것을 사용해야한다는 것에 대해서는 소개하지 않았다. MyISAM과 InnoDB는 각각 장단점이 있는 스토리지 엔진이다. 이번 프로젝트에 AMPQ 를 사용하기 위해서 데이터베이스의 락 기능에 대해서 이해하고 정리하기 위해서 준비한 자료이다. 이제 실제 대용량 데이터를 상용해서 어떤 엔진을 사용해야할지에 대해서 다음 포스팅에 작성할 예정이다.


## 참고

1. 대용량 시스템 구축을 위한 MySQL  성능 최적화, 위키북스
2. http://dev.mysql.com/doc/refman/5.1/en/lock-tables.html
3. http://blog.pages.kr/131
4. http://dev.mysql.com/doc/refman/5.0/en/show-open-tables.html
5. http://dev.mysql.com/doc/refman/5.1/en/show-processlist.html
6. http://laonmaru.com/tc/blogmeme/62
7. http://www.phpdeveloper.org.uk/mysql-named-locks/
8. http://dev.mysql.com/doc/refman/4.1/en/innodb-lock-modes.htm

