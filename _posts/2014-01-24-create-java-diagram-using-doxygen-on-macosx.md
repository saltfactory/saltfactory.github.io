---
layout: post
title: 맥에서 Doxygen을 이용하여 대용량 Java 프로젝트 클래스 다이어그램 문서 만들기
category: java
tags: [java, mac, osx, doxygen, documents]
comments: true
redirect_from: /218/
disqus_identifier : http://blog.saltfactory.net/218
---

## 서론

Java 개발에서 IntelliJ를 개발 IDE로 사용하고 있다. IntelliJ는 eclipse보다 안정성을 자랑하고 무엇보다 빠른 indexing를 제공하고 있기 때문에 개발할때 code assist를 가볍게 사용할 수 있는 장점을 가지고 있다. 이클립스에서 자바 파일이 많아지면 reindexing하는 시간 때문에 점한번 잘못 찍었다가는 eclipse 전체가 먹통이 되는 현상을 만날 수 있다. 그럼 IntelliJ는 그런경우가 없을까? 물론 IntelliJ에서도 메모리 문제가 발생하기도 한다. 보고서에 클래스 다이어그램을 넣기 위해서 IntelliJ에서 제공하고 있는 클래스 다이어그램 생성 메뉴를 눌렀을 때 이런 메세지를 발견했다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/9216c2f9-03a7-4f9a-a0d0-1cb979f080cc)

<!--more-->

IntelliJ는 Java 개발의 최강의 IDE이다. 자바파일에서 자동으로 UML을 생성시켜주는 기능은 개발 후 보고서를 작성할 때 정말 유용하다. 그런데 이번 Android 프로젝트를 진행하면서 클래스 관계가 복잡해지다 보니 UML이 엄청 크고 복잡하게 만들어졌다. export로 png 파일을 뽑으려고 하니 이런 메모리 문제를 만나게 되었다. 그래서 Doxygen으로 클래스다이어그램을 생성하기로 했다.

### Doxygen 다운로드

첫번째로 Doxygen을 다운받는다. 소스파일을 받아서 명령어로 사용해도 되지만, 맥에서 사용한다면 application 파일을 받아서 바로 할 수 있다. 이 포스팅을 작성할 때 doxygen-1.8.6.dmg 가 가장 최근 파일이다. 다음 링크에서 맥용 doxygen을 다운 받는다.
http://www.stack.nl/~dimitri/doxygen/download.html

![](http://asset.blog.hibrainapps.net/saltfactory/images/4bfffcfb-7036-4a94-b2ed-c3acb00772b5)

dmg 파일을 마운트해서 Doxygen 을 Applications에 드래그한다. Doxygen을 실행 시켰을 때 인증되지 않은 소프트웨어라는 메세지가 나오면서 실행되지 않을 때는 실행파일에서 오른쪽 마우스를 열고 팝업 메뉴에서 open을 선택해서 실행하면 실행할 수 있다. Doxygen을 실행하면 다음과 같은 화면이 나타난다. Doxygen은 아직 레티나 디스플레이를 적용하지 않아서 레티나 디스플레이에서는 글자가 깨어져 보인다. 레티나가 아닌 화면에서는 선명한 폰트로 나타날 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/459230f8-6111-478d-a6a7-07fed83e9bf8)

### Doxygen 디렉토리 선택

Doxygen은 크게 세가지 디렉토리를 선택한다. 첫째로 Doxygen의 작업 디렉토리, 두번째로 Doxygen을 이용해서 문서를 만들 소스파일이 있는 디렉토리, 셋째로 Doxygen에서 생성한 파일들이 만들어지는 디렉토리를 설정한다.

**Step 1:Specify the working directory from which oxygen will run** 에 있는 빈칸이 Doxygen 작업 디렉토리를 입력하는 곳이다.
**Step 2: 에서 Specify the directory the scan for source code** 가 문서를 만들 소스파일이 있는 디렉토리이다. 우린 Java 파일을 가지고 문서를 만들기 때문에 Java 파일이 있는 디렉토리를 설정한다.
**Step 2: 에서 Specify the directory where Doxygen should put the generated documentation** 이 Doxygen으로 문서가 만들어지는 디렉토리를 설정하는 곳이다.

다음은 중요한 것이 소스디렉토리 밑에 있는 모든 파일을 검사해서 문서를 만들기 위해서 Scan recursively를 체크한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/b2768478-2896-455c-a66a-5b9f0c5b5cec)

### 문서화할 언어 선택

다음은 Wizard 탭의 Mode를 선택한다. 우리는 Java 문서를 만들기 때문에 Java언어 optimize를 선택한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/f03f70ba-5635-4edf-a64f-83e85eaf06da)

### 실행

이제 run 탭을 눌러서 "Run Doxygen" 버튼을 클릭해서 문서를 만든다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/b6ecd879-27fa-4776-a751-2267df79d18c)

이렇게만 하면 간단하고 빠르게 문서가 만들어진것이다. Show HTML output 버튼을 눌러보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/43b8dfb2-e2bb-4e5d-9bd5-fabe487830d8)

이렇게 클래스 다이어그램과 Java 문서가 빠르게 만들어 진것을 확인할 수 있게 된다. Doxygen에서 그래프를 만들 때는 Doxygen이 가지고 있는 built-in class diagram generator를 이용해서 만드는 상속 그래프만 만들어 낼 수 있다. Doxygen은 GraphViz를 지원하는데 이것을 사용하면 참조되고 있는 그래프까지 표현을 할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/031f46a7-146c-4a8d-9505-00379130292e)

### GraphViz 설치

GraphViz에 관한 설명은 http://www.graphviz.org 에서 자세히 참조해보기 바란다.
맥에서 GraphViz를 설치하기 위해서는 여러가지 방법이 있지만 Homebrew를 사용하면 간단하게 설치할 수 있다. Homebrew에 관한 설명은 다음 링크를 참조한다. (http://blog.saltfactory.net/109)

```
brew install graphviz
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/9f9ff7c8-9d6d-4c9d-974c-9edc4f7dd1b5)

### GraphViz 설정

이젠 Doxygen에서 GrpahViz를 사용하기 위해서 설정을 한다. Wizard 탭에서 Diagrams을 선택하면 기본적으로 Use built-in class diagram generator를 사용해서 그래프를 그렸는데, Use dot tool from the GraphViz package를 사용한다고 체크한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/66c91ffc-93d9-4ef3-b9e8-17048e9b37b5)

다음은 클래스 다어그램을 그릴것이기 때문에 Expert에서 Dot을 선택해서 다음과 같이 설정한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/c1dec815-b8f8-4b49-9d72-db51f126d90a)

brew로 설치한 패키지는 /usr/local/bin에 실행 파일이 링크가 되어 있다. 그래서 GraphViz에서 dot을 이용해서 그래프를 만들기 위해서는 dot path를 설정해줘야한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/f6e33df5-ceb6-457c-ad22-9b7ecb21fbb6)

### 실행

이제 run 탭에가서 다시 실행을 해보자. output html을 살펴보면 Doxygen이 GraphViz를 사용해서 그래프가 정상적으로 그려진 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/31c34d45-d2c8-46be-813f-d4e67b1e91bb)

Doxygen은 빠르게 문서화를 만들어줄 수 있는 도구이다. 뿐만 아니라 큰 프로젝트에서 IDE에서 자동으로 다어그램을 만들 때는 메모리 문제가 많이 나타나는데 이것 또한 doxygen으로 문제를 해결할 수 있게 된다. Doxygen는 이 포스팅에서 설명하지 않은 많은 옵션들이 있다. 옵션을 수정하면서 테스트해 보길 권하고 싶다. call에 관련된 그래프를 만들어 낼 수 있으며 보다 디테일한 문서를 만들어 낼 수 있는 장점을 가진 좋은 툴이기 때문이다.

## 참고

1. http://www.doxygen.org

