---
layout: post
title: Ubuntu에서 Node.js 설치후 axconfig:port 1 not active 에러 해결하기
category: node
tags: [node, ubuntu, error]
comments: true
redirect_from: /219/
disqus_identifier : http://blog.saltfactory.net/219
---

## 서론

Node.js는 윈도우즈, 맥, unix 계열 시스템에서 모두 설치가 가능하다. 단일 코드로 여러 플랫폼에 동작할 수 있는 환경을 가지는 것은 개발자에게 행복한 것이다. 연구소에서 푸시서버를 Springframework를 Node.js로 마이그레이션 하기로 결정하고 맥에서 코드를 개발후 Ubuntu에 동작 테스트를 하기 위해서 Ubuntu에 Node.js를 설치했다.

```
sudo apt-get install node
```

Ubuntu에서 apt-get은 FresBSD와 마찬가지로 패키지를 관리하는 툴로 CentOS의 yum과 같은 기능을 가진 툴이다. apt-get을 사용하면 패키지 업데이트가 매우 편리한다. 아직 버전업이 활발히 이루어지고 있는 nodejs를 사용하기 위해서 nodejs를 apt-get으로 설치했는데 설치후 node를 실행하면 다음과 같은 에러를 발생하면서 실행이 되지 않는 문제가 생긴다.

```
axconfig : port 1 not active
axconfig : port 2 not active
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d4a273b4-d99b-41ef-be88-94253f01e16b)

<!--more-->

이 방법을 해결학 위해서는 두가지 방법이 있다. apg-get을 remove 하고 nodejs의 소스파일을 받아서 컴파일해서 설치하는 방법이다. 우리는 계속적으로 업데이트 되는 nodejs를 패키지툴로 관리하길 원하기 때문에 이 방법은 선택하지 않았다. 그래서 인터넷에서 해결 방법을 찾아서 apt-get으로 설치했고 이 방법에 대해서 공유하고자 한다. 방법은 http://stackoverflow.com/questions/2424346/getting-error-while-running-simple-javascript-using-node-framework 에 나와 있다.

먼저 apt-get으로 설치된 nodejs를 삭제한다.

```
sudo apt-get remove node
```

python software properties를 설치한다. 우리는 이것을 사용해서 apt-get으로 관리하는 패키지를 추가할 것이다.

```
sudo apt-get install python-sotware-properties
```

apt-get이 사용할 property에 새로운 nodejs를 추가한다.

```
sudo add-apt-repository ppa:chris-lea/node.js
```

apt-get이 사용하는 리파지토리에 nodejs를 추가했기 때문에 apt-get을 업데이트해서 정보를 갱신한다.

```
sudo apt-get update
```

nodejs를 새로 설치한다.

```
sudo apt-get install nodejs
```

기존에 설치된 nodejs는 /usr/sbin/node로 존재하지만 새로 설치된 node는 /usr/bin에 설치가 되기 때문에 PATH에 경로를 추가한다. vi로 ~/.profile을 열어서 PATH에 /usr/bin을 추가하자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/359d1296-f152-42e0-bee0-58aa5ce3b25b)

새로 추가한 PATH를 시스템에 반영하기 위해서 .profile을 컴파일 한다.

```
source ~/.profile
```

이렇게 Ubuntu에 nodejs를 apt-get으로 설치해서 사용할 수 있다. 테스트한 Ubuntu 서버 버전 정보는 다음과 같다. Ubuntu에서 버전확인은 lsb_release 로 확인할 수 있다.

```
lsb_release -a
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a91e4711-ca12-4e8e-bd26-94fde3a8f70d)

## 참고

1. http://stackoverflow.com/questions/2424346/getting-error-while-running-simple-javascript-using-node-framework

