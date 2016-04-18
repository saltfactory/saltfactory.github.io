---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 15.Appspresso Studio 힙사이즈 문제 해결하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, heap, memory]
comments: true
redirect_from: /146/
disqus_identifier : http://blog.saltfactory.net/146
---

## Appspresso Studio

Appspresso Studio(앱스프레소 스튜디오)는 이큽립스 기반의 하이브리드 앱 개발에 필요한 SDK를 포함한 IDE 이다. 이클립스 기반이라는 말은 JRE를 이용하고 Java VM 위에서 동작하는 IDE라는 말이다.

<!--more-->

![](http://asset.hibrainapps.net/saltfactory/images/85459ad9-e419-433a-9ad1-aa3a2ec47a61)

Appspresso Studio를 열고 About Appspresso Studio를 열어보면 현재 설치되어 있는 앱스프레소 스튜디오 정보를 확인할 수 있는데 밑에보면 Appspresso Studio에 포함된 플러그인들을 확인할 수 있다.

## WTP (Web Tools Platform)

WTP는 이클립스의 메이저 개발 툴 플러그 인으로 웹 개발을 할 때 사용하는 플러그인이다. Appspresso 로 만들어지는 앱은 웹과 네이티브 코드가 같이 만들어야하기 때문에 웹 개발툴이 포함되어 있는 것은 지극히 당연한 것일 것 이라 생각된다. 또한 WTP에는 XML 에디터가 포함이 되어 있는데 이것은 XML의 속성을 정의하고 추가할 때 code로 입력하는 것이 아니라 WTP에서 제공하는 key, value 형식의 GUI 입력기를 사용할 수 있게 지원하고 있다. 그래서 우리가 project.xml이나 다른 앱스프레소 설정에서 사용되는 xml 에서 입력기를 이용해서 속성을 간단하게 추가할 수 있는 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/963680fd-12a3-40f9-8ed5-8eef5adc33b1)

## Eclipse

Appspresso Studio는 Eclipse 기반으로 만들어진 IDE이다. 현재 3.7.2 (코드명 Indigo) 기반에 만들어진 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/3574359a-80e0-413d-b8ed-27b7d0d3b840)

## Appsrpesso Studio

현재 사요중인 Appspresso Studio는 1.1.0 버전이고 2012년 4월 27일에 릴리즈된 버전이라는 것도 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/b010242f-d1e0-4341-b456-a06414dd4dd2)

## EMF

마지막으로 포함된 플러그인은 EMF(Eclipse Modeling Framework Core Runtime)이다. 이 플러그인은 객체를 모델링하거나 GUI 입력기를 사용할때 사용되는 플러그인인데, 아직은 앱스프레소에서 그래프 형태의 에디터는 보이지 않지만 향후에는 Xcode의 xib나 안드로이드의 GUI 툴과 같은 인터페이스를 제공해주지 않을까 조심스레 기대해본다.

이렇게 Appspresso Studio는 IDE와 Plugins 모두가 JRE를 이용하고 Java VM 위에서 동작하고 있다. 이말은 Java VM의 자원을 사용한다는 것이다. 이러한 이유로 코드량이 많아지면 Java VM에서 사용하는 자원인 메모리 영역이 부족한 현상을 겪게 될 수 있다. Java VM도 일종의 어플리케이션이고 운영체제 위에서 메모리를 할당 받고 그 안에서 운영중인 Java application을 관리하게 되는데, Appspresso Studio의 사용률이 높아지면서 메모리를 점유하거나 대량의 코드를 메모리에 올려서 작업할 때 VM의 메모리가 부족해서 문제가 발생할 수도 있다는 것이다. 이러한 문제는 코드가 크지면 발생하게 되는데 이유는 Appspresso Studio가 Eclipse 기반으로 만들어졌기 때문에 Eclipse가 가지고 있는 Code Assiatant의 동작과 indexing 기능을 사용하기 때문이다. 이 두가지는 우리가 Eclipse를 사용할 때 아주 편리하게 코드를 작성하기 위해서 탭이나 . 을 찍으면 자동으로 관련된 코드를 힌트로 보여준다거나, 관련된 클래스의 정보(메소드, 변수, 주석)등을 보여주기 위해서 코드를 분석해두는 일을 하는 것이다.

Appspresso Studio를 디폴트로 설치한 후 Sencha Touch 2 라이브러리를 추가하고 sencha-touch-all-debug.js를 여는 순간 Appspresso Studio는 갑자기 멈추는 현상이 일어난다거나, git에 올려둔 코드를 다른 곳에서 clone 해서 열었는데 다음과 같은 에러를 만날 수 있다는 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/4552cef6-f7ee-4665-a4b3-c41394d47628)

코드를 열면서 Appspresso Studio가 코드를 분석해서 인덱싱을하는 도중에 Building workspace를 하는 동안 Java heap space의 문제를 알려주는 경고이다. 이 문제는 Appspresso Studio가 사용하는 IDE가 동작할때 사용하는 힙의 크기가 부족해서 발생하는 문제이다. 우리는 이 문제를 해결하기 위해서 Appspresso Studio가 사용할 수 있는 힙 사이즈를 더 크게 변경해줄 것이다.

여러분들이 앱스프레소 스튜디오를 다운받아서 설치한 폴더 안에 appspresso.app/Contents/MacOS 폴더로 이동한다. 보통 애플리케이션은 /Applications  폴더로 이동시켜둔다고 가정하고 진행한다.

```text
cd /Applications/Appspresso/appspresso.app/Contents/MacOS
```

맥에서는 .app으로 해당 애플리케이션을 패키징화 시켜두는데 그 안에 Contents/MacOS에서 appspresso.ini 파일이 존재한다. 이것은 애플리케이션에 관련된 initialization 파일로 애플리케이션이 시작할 때 애플리케이션을 설정하는 사항이 포함되어 있다.

```text
-startup
../../../plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar
--launcher.library
../../../plugins/org.eclipse.equinox.launcher.cocoa.macosx.x86_64_1.1.101.v20120109-1504
--launcher.XXMaxPermSize
256m
-vmargs
-Dfile.encoding=utf-8
-XstartOnFirstThread
-Dorg.eclipse.swt.internal.carbon.smallFonts
```

디폴트로 설정되어 있는 appspresso.ini 파일에는 startup 할때 사용하는 launch와 그리고 library 그리고 launcher의 MaxPermSize 사이즈 그리고 -vmargs이 바로 JavaVM의 옵셥인데 인코딩과 쓰레드 등이 설정되어 있다.
우리는 여기서 힙사이즈를 설정하는 코드를 추가한다.

```text
-startup
../../../plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar
--launcher.library
../../../plugins/org.eclipse.equinox.launcher.cocoa.macosx.x86_64_1.1.101.v20120109-1504
--launcher.XXMaxPermSize
256m
-vmargs
-Dfile.encoding=utf-8
-XstartOnFirstThread
-Dorg.eclipse.swt.internal.carbon.smallFonts
-Xms512m
-Xmx512m
```

## 결론

이 설정은 Eclipse의 힙사이즈를 설정하는 방법과 동일한데, perm는 클래스의 메타 정보가 저장되는 공간이고, Xms는 힙사이즈, Xmx는 최대 힙사이즈 크기를 설정하는 것이다. (보통 힙사이즈와 최대 힙 사이즈를 동일하게 해주라고 권장하고 있다.) 힙사이즈가 크면 클 수록 좋다고 생각할지 모르겠지만, 힙사이즈를 키우면 운영체제가 사용하는 메모리가 부족하게 되거나 다른 애플리케이션이 사용하는 힙사이즈가 줄어들어 컴퓨터 자체의 속도가 줄어들어 오히려 역효과가 생길수도 있으니 상황에 맞게 조정하는 것이 좋다.

저장하고 다시 Appsresso Studio를 실행시키면 힘사이즈 크기로 생기는 문제를 해결할 수 있다.

## 참조

1. http://wiki.eclipse.org/Eclipse.ini


