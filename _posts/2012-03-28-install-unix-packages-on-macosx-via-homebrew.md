---
layout: post
title: Homebrew를 이용하여 Mac OS X에서 Unix 패키지 사용하기
category: mac
tags: [mac, osx, unix, linux, homebrew, brew]
comments: true
redirect_from: /109/
disqus_identifier : http://blog.saltfactory.net/109
---

## 서론

Mac OS X는 훌륭한 운영체제다. Windows 와 Mac은 항상 비교 대상이 되어서 어느것이 더 좋고 나쁜지 이야기들 하지만 두가지 운영체제는 각각 장단점이 있는 것은 분명하며 사용자에게 가장 맞는 운영체제를 선택하면된다. Mac OS X을 훌륭한 운영체제라고 말하는 이유는 Unix 기반이기 때문이다. 그럼 Unix 는 더 좋지 않느냐? 라는 질문을 받게 될지도 모르겠지만 Unix의 명령어와 프로그램을 사용하면서도 빠른 반응과 개발자(사용자)를 즐겁게해주는 빠른 반응을 가진 UI를 가지고 있기 때문이다. (Unix는 command 만으로도 충분히 훌륭하다). 이러한 이유로 IDE를 사용하기에도, command를 사용하기에도 너무나 좋은 장점을 가지고 있다.

이러한 Unix기반에 Mac OS X에는 기본적인 Unix 프로그램과 명령어들이 설치되어 있어서 개발자에게 참 좋은 개발 플랫폼으로 사용될 수 있다. 하지만 Mac에서도 모든 Unix 프로그램이 설치되어 있는 것은 아니다. 그래서 때로는 source를 받아서 configuration을 하여 make를 하는 작업 등을 해야한다. 하지만 이러한 과정에서 Mac OS X 커널만의 문제로 컴파일이 제대로 되지 않는 문제가 생기기도 하는데 이러한 문제를 고쳐가면서 설치하기란 여긴 어려운것이 아니다. (물론 슈퍼 개발자들은 가능할지 모르겠다.) 그래서 이런 프로그램들을 BSD의 port 처럼 패키지 관리툴로 패키징 관리를 편리하게 할 수 있는 툴이 macport라는 것이 있다. 여러 오픈소스 개발자들이 Mac에 맞게 Unix 프로그램을 포팅해서 패키지 관리를 할 수 있게 노력하고 있어서 최근 라이브러리들이 빠르게 업데이트되고 있다. 처음에는 Macport를 사용했는데 macport은 기본적으로 macport가 사용하는 디렉토리에 실행파일은 실행파일대로, 라이브러리는 라이브러리 대로 설치가 되어진다.

다시 말해서 macport의 홈 디렉토리가 /opt/local 이라고 하면 (기본적으로 여기에 설치된다) /bin 밑에 명령어들이 모두 모여져 있다. 예를 들어 python도 ruby도 모두 /opt/local/bin/python, /opt/local/bin/ruby 등과 같이 말이다. 그리고 개발할 때 필요한 header 파일들도 모두 /opt/local/include/sqlite3.h, /opt/local/include/node/node.h 등으로 /opt/local/include 안에 모두 모여 있다. 마치 macport가 하나의 운영체제의 파일 시스템과 같은 형태로 하고 있는 것이다. 이것을 좀더 패키징화되어서 패키지마다 따로 관리하고 싶은 생각이 들었다. 그래서 찾게 된 것이 Homebrew 라는 것이다.

<!--more-->

Homebrew 소스들은 ruby로 만들어져 있다. 루비는 항상 simple, easy라는 슬로건을 가지고 있듯 Homebrew 역시 매우매우 편리하고 간단하게 의존성있는 패키지를 검색해서 자동으로 설치해주거나 패키지를 관리할 수 있다. (macport도 의존성을 자동으로 검색해서 설치해준다) . Homebrew 사이트에 가면 가장 먼저 볼 수 있는 것이 다음 문장이다.

> Homebrew is the easiest and most flexible way to install Unix tool Apple didn't include with OS X

설치방법도 간단하다. Mac OS X는 기본적으로 ruby와 curl이 설치되어 있다. 그렇기 때문에 다음을 복사해서 실행하면 Homebrew가 자동으로 설치가 된다.

```
/usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"  
```

wget이라는 Unix 프로그램이 있는데 개발할때 가장 많이 사용되는 프로그램 중에 하나이다. Mac OS X에는 기본적으로 설치되어 있지 않아서 처음에는 약간 의아해 했는데 Homebrew를 사용해서 wget을 설치하려면 brew search와 brew install을 사용하여 설치할 수 있다.

```
brew search wget
```

로 검색해서 패키지가 있으면 설치를 할 수 있다.

```
brew install wget
```

이렇게 Homebrew로 설치된 패키지들은 /usr/local/Cellar 라는 폴더안에 패키지별로 설치가되고 그 패키지별마다 버전별로 설치가 된다. /usr/local/Cellar/wget/1.13.4, /usr/local/Cellar/mongodb/2.0.2-x86_64 등으로 설치가 되고 각각 패키지별 안에 bin 폴더 밑에 실행 파일들이 존재한다. 이렇게 패키지별로 관리가 되기 때문에 macport와 달리 패키지를 관리하기 좀 더 편리하다.

만약에 wget을 삭제하고 싶으면 brew uninstall 명령어를 사용하면 된다.

```
brew uninstall wget
```
wget을 최신 버전으로 업그레이드하고 싶으면 brew upgrade 명령어를 사용하면 된다.

```
brew upgrade wget
```

## 결론

이렇게 쉽게 Homebrew를 이용해서 Mac OS X에 설치되어 있지 않은 Unix 패키지를 간단하게 설치하고 사용하거나 업그레이드하고 삭제할 수 있다. 각각의 패키지별로 설치되는 실행파일과 라이브러리, 헤더파일은 개발할때 패키지를 찾는데 효과적이다.

## 참고

1. http://mxcl.github.com/homebrew/
2. https://github.com/mxcl/homebrew/wiki/installation

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
