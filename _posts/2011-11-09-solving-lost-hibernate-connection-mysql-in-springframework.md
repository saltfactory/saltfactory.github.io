---
layout: post
title : Springframework에서 MySQL 커네션을 잃어버리는 문제 해결
category : spring
tags : [spring,java,srpingframework,hibernate,mysql,connection]
comments : true
redirect_from : /59/
disqus_identifier : http://blog.saltfactory.net/59
---

## 서론

Springframework에서 MySQL을 사용할 때 특정 시점이 지나면 자동으로 커넥션을 잃어버리는 문제가 있다. 이 문제는 Springframework에서 아무런 오랜시간 동안 데이터요청이 없으면 커넥션과 풀링을 해지하는 기능을 가지고 있기 때문인데 이 문제를 해결하기 위한 방법을 소개한다.

<!--more-->


## Srping에서 MySQL 커넥션 문제

이번 프로젝트에서 **Springframework + Hiberante + MySQL**을 사용하여 프로젝트 개발을 진행하는 도중에 스케줄러가 돌면서 특정 시점이 되어서 아래와 같은 **JDBCConnectionException** 을 자꾸만 발생하였다. apache의 [common-dbcp](http://commons.apache.org/proper/commons-dbcp/)를 사용해서 dataSource를 하다가 [tomcat-jdbc](https://tomcat.apache.org/tomcat-7.0-doc/jdbc-pool.html)로 교체하여 [JNDI(Java Naming and Directory Interface) dataSource](https://tomcat.apache.org/tomcat-7.0-doc/jndi-resources-howto.html)로 사용하면서 발생했다. [JNDI](http://www.oracle.com/technetwork/java/jndi/docs/index.html) 방법을 사용하는 것은 이번이 처음이였기 때문에 더구나 지금까지 대부분 Oracle을 사용하다가 Spring framework + MySQL을 처음 다루기에 전에 보지 못한 예외들이 발생하는거라 생각했다. 여러가지 자료를 찾아보다 이 문제는 MySQL이 기본적으로 **8시간**동안 요청이 없으면 커넥션을 해지하고 풀링을 해지 하기 때문이라는 것을 알게 되었다. 프로젝트에서는 Spring framework의 `@Scheduled`를 이용해서 Tomcat 서버에서 스케줄을하는데 웹 요청이 들어오지 않고 JNDI를 이용해서 스케줄에서 Hibernate와 MySQL을 사용해서 생기는 문제로 여겨졌다.

```
org.springframework.dao.DataAccessResourceFailureException: could not execute query; nested exception is org.hibernate.exception.JDBCConnectionException: could not execute query
        at org.springframework.orm.hibernate3.SessionFactoryUtils.convertHibernateAccessException(SessionFactoryUtils.java:629)
        at org.springframework.orm.hibernate3.HibernateAccessor.convertHibernateAccessException(HibernateAccessor.java:412)
        at org.springframework.orm.hibernate3.HibernateTemplate.doExecute(HibernateTemplate.java:411)
        at org.springframework.orm.hibernate3.HibernateTemplate.executeWithNativeSession(HibernateTemplate.java:374)
        at org.springframework.orm.hibernate3.HibernateTemplate.find(HibernateTemplate.java:912)
        at org.springframework.orm.hibernate3.HibernateTemplate.find(HibernateTemplate.java:904)
        at net.hibrain.apps.push.model.PushProviderDaoImpl.findWillPushDevices(PushProviderDaoImpl.java:50)
        at net.hibrain.apps.push.model.PushProviderDaoImpl.insertAllPushDeviceJSON(PushProviderDaoImpl.java:131)
        at net.hibrain.apps.push.service.PushProviderServiceImpl.start(PushProviderServiceImpl.java:111)
        at net.hibrain.apps.push.service.PushProviderServiceImpl.start(PushProviderServiceImpl.java:61)
        at net.hibrain.apps.push.schedule.PushScheduleServiceImpl.startSyncronous(PushScheduleServiceImpl.java:34)
        at sun.reflect.GeneratedMethodAccessor47.invoke(Unknown Source)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:25)
        at java.lang.reflect.Method.invoke(Method.java:597)
        at org.springframework.scheduling.support.ScheduledMethodRunnable.run(ScheduledMethodRunnable.java:64)
        at org.springframework.scheduling.support.DelegatingErrorHandlingRunnable.run(DelegatingErrorHandlingRunnable.java:53)
        at org.springframework.scheduling.concurrent.ReschedulingRunnable.run(ReschedulingRunnable.java:81)
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:441)
        at java.util.concurrent.FutureTask$Sync.innerRun(FutureTask.java:303)
        at java.util.concurrent.FutureTask.run(FutureTask.java:138)
        at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.access$301(ScheduledThreadPoolExecutor.java:98)
        at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:206)
        at java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)
        at java.lang.Thread.run(Thread.java:662)
Caused by: org.hibernate.exception.JDBCConnectionException: could not execute query
        at org.hibernate.exception.SQLStateConverter.convert(SQLStateConverter.java:97)
        at org.hibernate.exception.JDBCExceptionHelper.convert(JDBCExceptionHelper.java:66)
        at org.hibernate.loader.Loader.doList(Loader.java:2231)
        at org.hibernate.loader.Loader.listIgnoreQueryCache(Loader.java:2125)
        at org.hibernate.loader.Loader.list(Loader.java:2120)
        at org.hibernate.loader.hql.QueryLoader.list(QueryLoader.java:401)
        at org.hibernate.hql.ast.QueryTranslatorImpl.list(QueryTranslatorImpl.java:361)
        at org.hibernate.engine.query.HQLQueryPlan.performList(HQLQueryPlan.java:196)
        at org.hibernate.impl.SessionImpl.list(SessionImpl.java:1148)
        at org.hibernate.impl.QueryImpl.list(QueryImpl.java:102)
        at org.springframework.orm.hibernate3.HibernateTemplate$30.doInHibernate(HibernateTemplate.java:921)
        at org.springframework.orm.hibernate3.HibernateTemplate$30.doInHibernate(HibernateTemplate.java:1)
        at org.springframework.orm.hibernate3.HibernateTemplate.doExecute(HibernateTemplate.java:406)
        ... 22 more
Caused by: com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure


The last packet successfully received from the server was 35,986,917 milliseconds ago.  The last packet sent successfully to the server was 22 milliseconds ago.
        at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
        at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:39)
        at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:27)
        at java.lang.reflect.Constructor.newInstance(Constructor.java:513)
        at com.mysql.jdbc.Util.handleNewInstance(Util.java:411)
        at com.mysql.jdbc.SQLError.createCommunicationsException(SQLError.java:1116)
        at com.mysql.jdbc.MysqlIO.reuseAndReadPacket(MysqlIO.java:3102)
        at com.mysql.jdbc.MysqlIO.reuseAndReadPacket(MysqlIO.java:2991)
        at com.mysql.jdbc.MysqlIO.checkErrorPacket(MysqlIO.java:3532)
        at com.mysql.jdbc.MysqlIO.sendCommand(MysqlIO.java:2002)
        at com.mysql.jdbc.MysqlIO.sqlQueryDirect(MysqlIO.java:2163)
        at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2624)
        at com.mysql.jdbc.PreparedStatement.executeInternal(PreparedStatement.java:2127)
        at com.mysql.jdbc.PreparedStatement.executeQuery(PreparedStatement.java:2293)
        at org.apache.commons.dbcp.DelegatingPreparedStatement.executeQuery(DelegatingPreparedStatement.java:96)
        at org.apache.commons.dbcp.DelegatingPreparedStatement.executeQuery(DelegatingPreparedStatement.java:96)
        at org.hibernate.jdbc.AbstractBatcher.getResultSet(AbstractBatcher.java:208)
        at org.hibernate.loader.Loader.getResultSet(Loader.java:1808)
        at org.hibernate.loader.Loader.doQuery(Loader.java:697)
        at org.hibernate.loader.Loader.doQueryAndInitializeNonLazyCollections(Loader.java:259)
        at org.hibernate.loader.Loader.doList(Loader.java:2228)
        ... 32 more
```

## MySQL에서 wait_time 조회하기

```
show global variables like 'wait%';
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/73794388-8ea4-45bd-b9f7-44b451cbec1e)

MySQL은 기본적으로 **8시간**동안 요청이 없으면 커넥션을 해지한다.
방법은 리소스를 설정하는 MySQL url에다가 `autoReconnection=true`로 변경하면 된다. 또는 `valdationQuery="select 1"``을 전처리로 실행하게하면 된다.

```xml

<Resource name="jdbc/test_database" auth="Container" type="javax.sql.DataSource"
maxActive="100" maxIdle="30" maxWait="10000" validationQuery="select 1"
username="ID" password="PASSWORD" driverClassName="com.mysql.jdbc.Driver"
url="jdbc:mysql://localhost: 3306/test_database?autoReconnection=true"/>
```

또는 스프링 프레임워크에서 `hibernateProperties`를 설정하는 곳에서 설정하면 된다. 다음은 그 설정 예이다. 이 설정 방법은 다음 블로그에서 참조했다. (http://mimul.com/pebble/default/2008/06/24/1214258760000.html)

```xml
<bean id="hibernateProperties"
          class="org.springframework.beans.factory.config.PropertiesFactoryBean">
        <property name="properties">
            <props>
                <prop key="hibernate3.hbm2ddl.auto">update</prop>
                <prop key="hibernate3.dialect">org.hibernate.dialect.MySQLDialect</prop>
                <prop key="hibernate3.c3p0.minPoolSize">15</prop>
                <prop key="hibernate3.c3p0.maxPoolSize">50</prop>
                <prop key="hibernate3.c3p0.timeout">600</prop>
                <prop key="hibernate3.c3p0.max_statement">50</prop>
                <prop key="hibernate3.c3p0.testConnectionOnCheckin">true</prop>
                <prop key="hibernate3.c3p0.testConnectionOnCheckout">false</prop>
                <prop key="hibernate3.c3p0.maxStatementsPerConnection">5</prop>
                <prop key="hibernate3.c3p0.maxIdleTime">300</prop>
                <prop key="hibernate3.c3p0.maxConnectionAge">14400</prop>
                <prop key="hibernate3.c3p0.acquireRetryAttempts">10</prop>
                <prop key="hibernate3.c3p0.preferredTestQuery">SELECT 1;</prop>
                <prop key="hibernate3.c3p0.idleConnectionTestPeriod">300</prop>
                <prop key="hibernate3.provider">org.hibernate.connection.C3P0ConnectionProvider</prop>
            </props>
        </property>
    </bean>
```

이 방법 외에도 `/etc/my.cnf`에서도 설정하는 방법도 있고 유지하는 방법 여러가지 있으니 프로젝트에 맞는 방법을 선택하여 사용하면 될것 같다.

