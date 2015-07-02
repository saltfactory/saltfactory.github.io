---
layout: post
title: RabbitMQ를 이용하여 비동기 데이터처리 시스템 구축하기
category: rabbitmq
tags: [rabbitmq, async]
comments: true
redirect_from: /90/
disqus_identifier : http://blog.saltfactory.net/90
---

## 서론

![{max-width:180px}](http://cfile5.uf.tistory.com/image/137A57344F0EBC811A59BC)

[RabbitMQ](http://www.rabbitmq.com)는 간단하게 말하면 표준 [AMQP (Advanced Message Queueing Protocol)](http://www.amqp.org) 메세지 브로커 소프트웨어(message broker software) 오픈소스이다. RabbitMQ는 [erlang](http://www.erlang.org)언어로 만들어졌을 뿐만 아니라, clustering과 failover를 위한 OTP framework로 서버가 만들어져 있다. RabbitMQ는 VMware에서 지원해주고 있는데 spring source 프로젝트중에 [spring AMQP](http://projects.spring.io/spring-amqp/)가 정식으로 1.0으로 릴리즈되면서 RabbitMQ의 지원은 더 적극적인것 같다. RabbitMQ는 다양한 언어로된 RabbitMQ client를 지원하고 있고 공식적인 온라인 문서에서는 Python과 Java에 대한 소스코드를 예제로 공개하고 있다.

RabbitMQ를 이해하기 위해서는 우선 [MQ(Message Queuing)](http://en.wikipedia.org/wiki/Message_queue)에 대한 이해가 필요하다. 프로그래밍에서 MQ는 프로세스 또는 프로그램 인스턴스가 데이터를 서로 교환할때 사용하는 방법이다. 이때 데이터를 교환할때 시스템이 관리하는 메세지 큐를 이용하는 것이 특징이다. 이렇게 서로 다른 프로세스나 프로그램 사이에 메시지를 교환할때 AMQP(Advanced Message Queueing Protocol)을 이용한다. AMQP는 메세지 지향 미들웨어를 위한 open standard application layer protocol 이다. AMQP를 이용하면 다른 벤더 사이에 메세지를 전송하는 것이 가능한데 JMS (Java Message Service)가 API를 제공하는것과 달리 AMQP는 wire-protocol을 제공하는데 이는 octet stream을 이용해서 다른 네트워크 사이에 데이터를 전송할 수 있는 포멧인데 이를 사용한다. 이러한 복잡한 설명과 달리 RabbitMQ 튜토리얼에서는 RabbitMQ를 매우 간단하게 편지를 작성하여 받는 사람에게 보낼 우체통, 우체국, 우편배달부가 있듯,  post box, post office and postman라고 비유적으로 설명하고 있다. 단지 다른것은 데이터의 바이너리 blobs을 accept, store, forward 시키는 것만 다른것이라 말한다.

RabbitMQ와 같은 Message Queueing은 대용량 데이터를 처리하기 위한 배치 작업이나, 체팅 서비스, 비동기 데이터를 처리할때 사용한다. RabbitMQ를 찾아보게 된 계기도 비동기식 데이터 처리를 하기 위해서 찾아보게 되었다. 프로세스단위로 처리하는 웹 요청이나 일반적인 프로그램을 만들어서 사용하는데 사용자가 많아지거나 데이터가 많아지면 요청에 대한 응답을 기다리는 수가 증가하다가 나중에는 대기 시간이 지연되어서 서비스가 정상적으로 되지 못하는 상황이 오기 때문에 기존에 분산되어 있던 데이터 처리를 한곳으로 집중하면서 메세지 브로커를 두어서 필요한 프로그램에 작업을 분산 시키는 방법을 하고 싶었기 때문이다. ActiveMQ와 RabbitMQ를 후보에 두었는데 RabbitMQ가 먼저 리뷰하게 되었다.

<!--more-->

## Mac OS X에 RabbitMQ 서버 설치

우선 RabbitMQ를 사용하기 위해서는 RabbitMQ server가 필요하다. http://www.rabbitmq.com/download.html 에 가서 자신에게 맞는 서버를 설치하여 사용하면 된다. 테스트할 서버는 Ubuntu인데 사용설명을 위해서 현재 사용중인 Macbook Pro에도 RabbitMQ server를 설치하였다. 이번 포스트에서는 RabbitMQ 서버를 설치하는 방법을 간단히 설명하고 "RabbitMQ를 이용하여 비동기 데이터 처리 시스템 구축하기 - 2편 메세지 전송과 수신 방법"에서 RabbitMQ 공식 문서에 나와 있는 예제를 바탕으로 포스팅을 할 예정이다.

우선 Mac용에서 설치하는 방법을 먼저 살펴보자. 개발자에게 Mac은 서버와 클라이언트를 모두 가질수 있게 해주는 개발자에게 가장 어울리는 운영체제가 아닌가 싶다. 개인적으로 Linux/Unix 환경에 개발하면서도 윈도우즈만큼 (이젠 더 편리한) GUI를 함께 사용한다는 것은 개발자에게 큰 행운이라고 본다. 서버 프로그램을 자주하는 개발자라면 아마도 Mac을 사용할때 가장 먼저 하는 것이 macport를 설치하는 것이 아닐까 생각든다. fink도 있는데 개인적으로 bsd의 port를 좋아하기 때문에 macport를 사용한다. 이것은 Unix software을 dawin 기반의 mac에서도 사용할수 있게 포팅해주는 패키지관리 프로그램이라고 생각하면 된다. RabbitMQ 공식 사이트에서도 Mac에서 설치할때는 macport를 사용하고 나와 있다. 하지만 이 포스팅을 작성할때 macport로 RabbitMQ를 설치하니 에러가 발생하면서 정상적으로 설치가 되지 않았다. 그러던 중에 macport의 의존성 패키지 업데이트에 대해 twitter에 글을 작성하다가 @andrwj 님께서 brew에 대해서 잠깐 언급하셔서 이번에 homebrew를 설치하여서 brew를 이용해서 RabbitMQ를 설치하였다.

```
brew search rabbitmq
```

라고 검색하면 rabbitmq가 패키지가 있는 것을 확인하고 install로 RabbitMQ 를 설치하면 된다.

```
brew install rabbitmq
```

brew는 macport와 달리 `/usr/local/Cellar/{패키지명}/{버전}` 으로 패키지가 설치되는데 현재 RabbitMQ의 최신 버전은 2.7.1이 설치가 된다. RabbitMQ는 erlang으로 만들어졌는데 RabbitMQ를 설치하면 erlang도 함께 자동으로 설치가 된다. RabbitMQ 서버를 실행해보자.

```
/usr/local/Cellar/rabbitmq/2.7.1/sbin/rabbitmq-server start
```

서버를 실행하면 RabbitMQ의 심볼이 나타나면서 rabbit boot start, external infrastructure ready, kernel ready, core initialized, message delivery logic read 순으로 부팅이 완료되고 메세지를 받기 위해 대기한다.

![](http://cfile25.uf.tistory.com/image/206C79444F0EE7D025146A)

RabbitMQ의 상태를 확인하기 위해서는 `rabbitmqctl`을 사용하면 된다.

```
/usr/local/Cellar/rabbitmq/2.7.1/sbin/rabbitmqctl status
```

## Ubuntu에 RabbitMQ 설치

이제 Ubuntu에 설치하는 방법을 살펴보자. Ubuntu는 apt-get 이라는 패키지 툴로 패키지를 관리할 수 있는데 사실 이 패키지툴은 굉장히 편리하다. apt를 이용해서 패키지를 설치하려면 리소스 리스트를 관리하는 툴에 리파지토리를 추가해줘야한다.

```
sudo vi /etc/apt/sources.list
```

파일의 맨 마지막에 다음 문장을 추가하고 저장하고 vi 에디터를 닫고 나온다.

```
deb http://www.rabbitmq.com/debian/ testing main
```

하지만 이 패키지는 rabbitmq에서 배포하는 패키지이고 ubuntu에서 정식 패키지로 인증되지 않은 것이기 때문에 RabbitMQ의 public key를 ubuntu가 신뢰할 수 있는 키로 등록해줘야한다. 머저 RabbitMQ에서 public 키를 wget으로 받아 온다.

```
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
```

다운받은 키를 apt-key를 이용해서 인증키로 등록한다.

```
sudo apt-key add rabbitmq-signing-key-public.asc
```

이제 apt-get 을 이용하여 RabbitMQ 서버를 설치한다.

```
sudo apt-get install rabbitmq-server
```

RabbitMQ는 공식적으로 Mac OS X, Debian/Ubuntu, RPM-based Linux, General Unix, Solaris, EC2 에서 설치가 가능하다. 여기서는 Mac과 Ubuntu 기반으로 RabbitMQ에 대해서 사용하는 방법을 포스팅하기 위해서 두가지 설치 방법만 작성했지만 공식 문서에 가면 다른 운영체제에서 설치하는 것도 어렵지 않게 따라할수 있을거라 생각이 든다. 다음 포스팅은 RabbitMQ의 공식 문서를 기반으로 실제 메세지를 전송하고 받는 방법에 대한 예제를 포스팅할 예정이다.

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
