---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 1.iOS와 Android 앱 빌드
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c]
comments: true
redirect_from: /125/
disqus_identifier : http://blog.saltfactory.net/125
---

## 서론

iOS와 Android의 앱을 한 사람이서 개발하려면 Objective-C와 Java 언어를 익혀야한다. 그리고 두가지의 앱을 동시에 똑같은 인터페이스를 만들기 위해서 쉽게 생각해서 iOS는 Inteface Builder를 사용해야하고 Android 는 XML 메타 프로그래밍을 해야한다. (현재는 Android 도 Xcode의 Interface Builder 만큼은 아니지만 Drag 하여서 인터페이스를 설정하는 기능을 제공하고 있는 것으로 안다.)

saltfactory가 연구활동을 하는 곳, 하이브레인넷 부설 연구소는 하이브레인넷( http://www.hibrain.net)의 부설 연구소로 연구원 수가 많지가 않다. 이러한 이유로 두가지 디바이스르 동시에 개발한다는 것을 혼자 처리하기에는 무리가 있다고 판단하여 UI 개발을 최소한으로 줄일 수 있는 방법을 고려하다가 하이브리드 앱(Hybrid app)을 생각하게 되었다. Hybrid 앱은 웹 개발 기술과 네이티브 게발 기술을 동시에 사용하여 개발하는 방법을 말하는데 쉽게 C나 java와 같은 언어와 HTML과 Javascript나 웹 자원과 서로 상호 연결하여 개발하는 것이다. 이전 아티클 iPhone에서 하이브리드 앱 개발을 위해 Javascript와 Objective-C의 상호 호출하는 방법 라는 글에서 Javascript와 Objective-C의 상호 호출하는 방법에 대해서 포스팅되어 진것을 확인할 수 있다. 이렇게 Hybrid한 기법을 좀더 빠르게 개발할 수 있는 프레임워크를 찾게되었는데,  KTH에서 지원하는  Appspresso와 Adobe에서 지원하고 있는 Phonegap 도입을 생각하게 되었다.

<!--more-->

## Appsresso

첫번째로 Appspresso의 테스트를 해보기로 했다. Phonegap은 국내에서 도서도 제법 나오고 국내,외 적용 사례가 많이 나오고 있고, 개발자 커뮤니티도 활발한 것으로 보인다. Appspresso를 첫번째로 적용해보기로 판단한 이유는 하나의 Appspresso 툴 하나에서 Android와 iPhone 두가지를 한번에 빌드할 수 있는 장점 때문이다. on the fly 라는 기능은 파일이 변경된 것이 있으면 새로고침을 하여 다시 IDE에서 빌드하지 않아도 되는 기능인데, 현재 Appspresso 1.0.1 버전에서는 두가지 디바이스에 한번에 적용되지 않고 2.0 버전에서 동시에 on the fly를 적용시킬 수 있는 기능이 제공된다고 한다. 실제 Appsresso를 사용해보면 빌드시간이 오래 걸리기 때문에 on the fly 기능이 반드시 필요한 기능이다. 빠른 시간에 2.0 버전이 멀티 디바이스 on the fly 기능을 포함하고 업그레이드 되어서 배포되길 간절히 기다리고 있다.

Appspresso IDE는 eclipse 기반으로 만들어져 있고, IDE에서 iphone simulator와 android emulator를 설정해서 테스트할 수 있다. Asspresso 다운로드는 http://appspresso.com/download 에서 이메일을 통해서 받을 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/5743dc13-4afc-4580-925f-4b985ef430ff)

Appsrpesso를 동작하면 eclipse 초기 화면과 같이 workspace를 지정하는 화면이 나오고 workspace를 지정하면 프로그래스바가 진행되면서 eclipse와 동일한 IDE가 열린다.

Appsrpesso의 장점이 하나의 툴에서 iOS와 Android 두가지를 빌드해서 확인 할 수 있다고 앞에 말했는데 Appspresso가 두가지 시뮬레이터를 참조할 수 있어야 한다. 그래서 Preferecens에 들어가서 다음과 같이 설정을 한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/b06f8ae7-56e0-4dde-b6ea-c4d5993b6ea5)

## iOS 설정

Preferences 가 열리면 Asspresso의 iOS와 Android의 SDK를 설정한다. 먼저 iOS 개발을 위해서 iOS SDK의 디렉토리를 추가한다. Xcode 4.3 이전 버전은 /Developer 가 기본 Xcode의 경로이지만 Xcode 4.3 이후 부터는 앱 스토어에서 Mac App으로 설치가 되고 Applications 폴더에 설치가 되기 때문에 아래와 같이 지정한다.

```
/Applications/Xcode.app/Contents/Developer
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/ba54e47c-8d3f-4f1f-a7f6-b527fd550b29)

## Android 설정

Android 앱 개발을 위해서 Android SDK 디렉토리를 아래와 같이 지정한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/2260af74-729a-4772-a9b0-5ed4ff4e4955)

이제 Project를 만들어서 두가지 다른 디바이스에서 동작하는 간단한 앱을 만들어 보자.

새로운 Project를 생성해야하는데 "Appspresso Application Project"로 프로젝트를 하나 생성한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/87659737-bd6f-484d-b227-942ca524080b)

프로젝트 이름은 SaltfactoryHybridTutorial 이라고 앱의 정보를 입력한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/5e188da9-1ba0-483e-87f6-c6a563cc5b7b)

Finish를 눌러 마쳐도 되고 Next를 눌러서 Appspresso에서 기본적으로 제공해주는 UI framework를 선택할 수도 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/a11390f8-d7a9-48d2-9f9e-4f2a9ab9efa3)

Hello World 템플릿을 선택하고 Finish를 하면 Appsresso에서 자동으로 Hello World를 출력해주는 코드를 생성해준다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/fa1ac408-c4a3-4ac2-87e0-bd3f184dfb18)

## Run

프로젝트 폴더를 선택하여 오른쪽 마우스를 클릭한다. Run As를 살펴보면 Run Appspresso application on Android device와 Run Appspresso application to iOS device를 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/29433645-223b-4219-b082-58eb221b4a7c)

먼저 Run Appspresso application on iOS device를 선택하여 iPhone simulator에 설치하고 실행한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/bccd4607-a9b1-4546-af5c-2fb5a66bf4a4)

Xcode 4.3에서 설치해둔 simulator가 나타나는 것을 확인할 수 있다. 가장 위에 iphoneos5.1은 현재 실제 아이폰을 USB로 꽂아서 생긴것이다.  나중에 디바이스에 설치하고 싶으면 iphoneos5.1을 선택하면 된다. 원하는 디바이스를 선택하고 OK를 누르면 기본적으로 만들어준 파일들이 빌드되고 실행이 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/6c9165e9-7ec9-44e8-b811-c279a0f9791f)

![](http://asset.blog.hibrainapps.net/saltfactory/images/e4cbd39f-8ac1-43e5-b147-b1068eaab5d4)

위에 실행된 프로그램은 다음의 index.html 이 표현된 것이다. 이제 웹 프로그래밍 언어로 앱을 개발할 수 있게 되었다.

```html
<!DOCTYPE html>
<html>
	<head>
        <script type="text/javascript" src="/appspresso/appspresso.js"></script>
        <meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
			ax.log("Hello World");
		</script>
	</head>
	<body>
		<h1>Hello World</h1>
		<h3>net.saltfactory.hybridtutorial</h3>
	</body>
</html>
```

안드로이드 폰 앱도 동일하게 빌드할 수 있다.
아이폰 앱을 실행할 때와 동일하게 프로젝트에서 오른쪽 마우스를 클릭해서 Run as > Run Appsspresso application on Android Device 메뉴를 선택한다.

만약에 위에서 android sdk를 설정하는 부분이 빠졌다면 다음과 같이 android sdk를 포함한 디렉토리를 설정하라는 메세지를 확인하게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/4cf0d318-09e4-4c7a-9e2e-c9fee1e3591c)

이 메세지를 보게 되면 android sdk를 찾지 못해서 발생한 문제이기 때문에 앞에서 sdk를 설정하는 과정을 해주고 다시 Run을 하면 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/f2ca7df8-78e7-47b8-a7de-8f5094c499a3)

현재 android emulator가 두가지 만들어져 있기 때문에 두가지가 모두 나타났다. 만약 android emulator가 없다면 디바이스 목록에서 안드로이드 emulator가 나타나지 않을 것이다. 이런경우 android device manager에서 emulator를 만들어주거나 실제 안드로이드 폰을 USB로 꽂아서 USB debugging 기능을 활성화하면 디바이스 목록에 나타날 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e35b15dd-2a71-4f5f-88d8-55b167412fcb)

![](http://asset.blog.hibrainapps.net/saltfactory/images/e53f71d8-94df-4513-8427-19bb5c7099c2)

이렇게 Appspresso를 이용하면 이렇게 iPhone과 Android 폰에 들어가는 앱을 웹 개발 언어로 하나의 코드로 작성할 수가 있게 된다. 앞으로 Appspresso를 이용하여 실제 어떻게 개발하는지에 대한 이야기를 계속 연재할 예정이다. Appspresso는 웹킷을 이용하여 HTML과 Javascript로 구현되어서 Native Application 보다 성능에 대한 걱정을 하는 사람들이 많을 것이라 생각된다. 본인 또한 그렇다고 듣고 걱정해서 하이브리드 앱 개발에 대해서 그렇게 긍정적이지 못했다. 혼자서 아이폰과 안드로이드 앱을 동시에 개발하는데 있어서 각각 특징을 이해하고 개발하면서 걸리는 그 비용이 매우 많이 필요하게 되는데 하이브리드한 개발 방법으로는 웹 자원을 재사용할 수 있을거라 기대된다. Appspresso와 PhoneGap은 서로 장단점이 있는 하이브리드 앱 개발 플레임워크이다. 앞으로 실험하고 개발하면서 블로그를 통해서 자세히 살펴보기로 하자.

## 참고

1. http://appspresso.com/developer/getting-started

