---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 11.WAC Devicepai 사용하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, wac, deviceapi]
comments: true
redirect_from: /136/
disqus_identifier : http://blog.saltfactory.net/136
---

## WAC

WAC (Whole Applications Community) 는 네트워크 사업자, 장치 및 네트워크 장비 제조 업체를 포함한 전세계 통신 회사들로 구성된 오픈 동맹이다. WAC는 단일 크로스 플랫폼 API 연산자에 의해 전달 네트워크 운영자 API를 사용하여 혁신 개발자를위한보다 쉽게 ​​만들기 위해 노력하고 있다. 즉, 다시 말하면 앱스토어나, 안드로이드 마켓과 간튼 벤더에 종속된 마켓의 앱 시장을 가지는 것이 아니라 전체적으로 사용할 수 있는 커뮤니티(마켓)을 만들기 위한 모임이다. 이러한 WAC 에서 단일 코드로 크로스 플랫폼을 지원하는 방법 (api)을 연구하고 spec을 만들어가고 있는데, WAC를 지원하는 디바이스는 앞으로 개발할 때 각기 다른 언어로 개발하고 다른 방법으로 개발하는 것이 아니라 WAC spec에서 제공하는 api를 이용해서 개발을 할 수 있게 되는 것이다. Appspresso(앱스프레소)에서는 WAC 2.0을 지원하고 있다. 이 포스팅에서는 Appspresso(앱스프레소)에서 WAC를 사용하는 방법에 대해서 간단한 예제로 알아 보기로 한다. (앞에서 우리는 1~10 까지의 Appspresso(앱스프레소)로 아이폰 안드로이드 앱을 동시에 개발하는 방법을 살펴보았다. 이 과정에서는 프로젝트 생성, 빌드, 디버깅 과정이 포함되어 있다. 앞으로 11번째 이후 부터는 프로젝트 생성에 대한 방법에 대해선 따로 설명하지 않을 것인데 이전 글들을 참조하기 바란다.)

<!--more-->

WAC에 대한 예제들은 ADE(Appspresso Debugging Extension)을 이용해서 확인할 수 있다.
Appspresso(앱스프레소)에서 WAC에 관한 문서는 다음에서 확인할 수 있다. http://appspresso.com/ko/api-reference-ko
앞으로 Appspresso에서 사용할 수 있는 WAC API의 방법을 차례로 예제를 통해 살펴볼 것이다. 첫번째로 Deviceapis에 대해 살펴보자.
테스트를 하기위해서 Appspresso Application 프로젝트를 만든다. 그리고 이전 예제들은 모두 index.html 안에 <script></script>안에 간단하게 javascript 코드를 넣고 테스트하였지만, 이제 /src/js/app.js 라는 appplication에 관한 자바스크립트 파일을 분리해서 사용하도록 하자. index.html의 코드는 다음과 같다.

```html
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="/appspresso/appspresso.js"></script>
<script src="/js/app.js"></script>
</head>
<body>
	<h1 id="title">Hello</h1>
	<h3>net.saltfactory.tutorial</h3>
</body>
</html>
```

## Deviceapi

Deviceapis는 WAC의 루터 인터페이스로 WAC 모듈은 모두 이 인터페이스로 접근이 가능하다. 앱스프레소에서 Deviceapis는 windows의 deviceapis 전역변수로 정의가 되어져 있다. 우리는 이 변수부터 확인해 볼 것이다. Appspresso 1.1 버전부터 ADE(Appspresso Debugging Extension)을 지원하는데 이것이 지원되면서 1.1 이전부터 하기 번거러운 디버깅을 Web Inspector를 사용해서 디버깅을 할 수 있게 되었다. ADE를 사용하기 위해서는 기본적으로 Web Inspector의 사용법을 알고 있어야한다. 그러면 놀라울만큼 다양한 디버깅을 할 수 있게 될 것이다.
우리는 간단하게 위에서 설명한 Deviceapis를 앱스프레소에서는 window의 deviceapis 전역변수로 구현하였다는 것을 확인하기 위해서 apps.js에 다음 코드를 저장하고 디바이스로 빌드하여 실행한다. 이때 on the fly가 활성화 될 수 있도록하고 ADE를 사용할 수 있도록 설정한다. 이 방법에 대해서는 [Appspresso를 사용하여 하이브리드앱 개발하기 - 4.ADE(Appspresso Debug Extension)으로 디버깅하기](http://blog.saltfactory.net/128) 글을 참조하기 바란다.

```javascript
var deviceapis = window.deviceapis;
console.log(deviceapis);
```

apps.js에는 window의 deviceapis의 전역변수를 ADE에서 확인할 수 있도록 console.log 로 출력하게 하였다. ADE는 생각보다 많은 디버깅을 할 수 있다는 것을 말했는데 그중에 하나가 바로 breakpoint를 사용할 수 있다는 것이다. ADE에서 Inspector를 열어서 Scripts  탭을 선택하고 console.log 가 실행되기 전에 breakpoint를 마크하여서 변수의 내용을 보길 원한다. breakpoint를 만들고 변수 위로 마우스를 올리면 tooltip으로 변수의 내용을 확인할 수 있게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/3dced2b1-92cc-4f78-8f81-b02ee77f9ce2)

tooltip으로 확인하니 deviceapis는 get deivcestatus 메소드를 가지고 있고 __proto__ 로 listActivatedFeatures 와 listAvaiableFeatures 라는 메소드가 체이닝되어 있다는 것을 확인할 수 있다. 좀더 자세하게 살펴보기 위해서 변수에다 오른쪽 마우스를 선택하고 Add to Watch를 한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/a76c480b-fabe-4ec5-87f4-88ed284e95a0)

이렇게 하면 변수에 대해서 특정한 Expressions를 할 수 있는 오른쪽 패널의 Watch Expressions 에 추가가 되고 변수의 내부를 탐색할 수 있게 된다. 아래는 Watch Expression에 추가된 변수를 탐색하여 __proto__ 로 체인된 메소드를 확인한 것이다. 우리가 axplugins.js에서 네이티브 코드를 사용하고 값을 가지오기 위해서 stub 메소드를 추가한 것과 마찬가지로 WAC의 디바이스 속성을 상용하기 위해서 execAsyncWAC, execSyncWAC, errorAsyncWAC, watchWAC, ...등등 메소드들이 체이닝 되어 있는 것을 화인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/b92680f8-82c0-41ed-a33b-731bd8c27ac4)

체이닝된 메소드 말고 windows.deviceapis가 가지고 있는 메소드는 listActivatedFeatures와 listAvailableFeautres 두가지 메소드인데 이 메소드들에 대해서 살펴보자.

## listActivatedFeautres

windows.deviceapis.listActivatedFeautres() 메소드는 Appspresso(앱스프레소) 프로젝트로 작업을 할 때 런타임시 활성화된 features들의 목록을 가져오는 메소드이다. 우리는 일전에 Plugins을 추가하기 위해서 project.xml 파일을 열어서 Add Plugin Project라는 메뉴를 사용한 적이 있다. 이때 Plugin List에 나타난 목록들이 WAC를 사용하기 위해서 기본적으로 추가되어 있는 plugins과 features를 확인할 수 가 있고 GUI로 간단하게 features를 추가할 수 있다. Appspresso Application Project를 처음 생성하면 기본적으로 deviceapi(android.ios)라는 plugin이 추가가 되어 있고 http://wacapps.net/api/deviceapis 라는 WAC api Feature가 추가되어 있는 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/23ae9df3-f4c4-49a0-a506-a0f3d89268f5)

그럼 windows.deviceapis에서 활성화된 features 목록을 보기 위한 listActivatedFeautres 메소드를 app.js에 추가하여 살펴보자. 간단하게 windows.deviceapis.listActivatedFeatures()메소드에서 획득한 features의 목록을 console로 logging하는 코드이다.

```javascript
var deviceapis = window.deviceapis;
console.log(deviceapis);

var features = deviceapis.listActivatedFeatures();
for (var i=0; i < features.length; i++) {
	console.log("Activited Features :  " + features[i].uri );
}
```

그리고 ADE에서 deviceapis를 breakpoint를 걸어서 Add Watch 를 했듯, features로 동일한 방법으로 내부를 살펴보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e7686a4c-1002-46f1-b249-d724fe2105d1)

우리는 프로젝트에서 deviseapis 플러그인으로 WAC의 feature 한가지를 추가했기 때문에 deviceapis.listActivatedFeaures()에서 획득한 feature가 http://wacapps/api/deviceapi 라는 것 하나만 가져올 수 있었다. 그럼 테스트를 위해서 하나더 추가해보자. WAC에서 디바이스 상태를 확인하기 위한 API인 devicestatus를 추가하였다. 여기서 살펴보면 plugin은 deviceapi.devicestatus(android,io)를 추가하였지만 Feature List를 살펴보면, http://wacapps.net/api/devicestatus, http://wacapps.net/api/devicestatus.deviceinfo, http://wacapps.net/api/devicestatus.networkinfo 라는 feature가 추가된 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/ade94b6f-497f-4f20-a3de-216c1aefd9ce)

다시 빌드를 후에 ADE를 새로고침 해보자 ( javascript등 resources 자원의 수정은 새로 빌드없이 on the fly 로 바로 확인이 되지만 네이티브 코드나 어플리케이션 설정등이 변경되면 다시 빌드해야만 적용된다.) ADE의 Inspector에서 Add Watch 말고 바로 변수를 console에서 evalute 할 수 있는데 evalute로 features를 확인해보자. breakpoint에서 features 변수를 선택하고 오른쪽 마우스를 클릭해서 Evalute in Console을 체크한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/26286128-ceb7-494e-8e33-1e75887f3874)

이렇게 하면 Watch Expressions에서 가려져서 나오지 않는 부분을 변수만 evaluate 할 수 있다. features 변수 안을 살펴보면 4가지의 배열 값이 있는 것을 확인할 수 있고 각각 v(value)를 화살표를 눌려서 확장시켜서 자세시 살펴보면, 우리가 project.xml에서 추가한 features가 activatedFeautres 의 값을고 deviceapis가 가지고 있다는 것을 확인 할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/7bdeff7c-d44b-4e04-902d-b6d86ebdba58)

## listAvailableFeatures

windows.deivceapis는 listActivatedFeatures 말고도 listAvailableFeatures 라는 메소드를 포함하고 있다. 이 메소드는 디바이스에서 사용 가능한 features들을 목록화하여 확인할 수 있다. app.js에  다음 코드를 추가하자.

```javascript
var deviceapis = window.deviceapis;
console.log(deviceapis);

var activted_features = deviceapis.listActivatedFeatures();
for (var i=0; i < activted_features.length; i++) {
	console.log("Activited Features :  " + activted_features[i].uri );
}

var availabe_features = deviceapis.listAvailableFeatures();
for (var i=0; i < availabe_features.length; i++) {
	console.log("Available Feature : " + availabe_features[i].uri);
}
```

그리고 ADE의 insepctor에서 위에서 features를 evaluate 한 방법과 동일하게 available_features를 확인해보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/ec7920e6-94cd-4f99-952b-d93e9c01a678)

deviceapis에서 listAvailableFeatures를 확인하면 다음과 같이 사용가능한 WAC의 features를 확인할 수 있게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/0c15de4f-d23e-414a-b2f4-be64c556bad0)

## 결론

Appsresso는 WAC로 개발할 수 있도록 이미 plugin과 Features를 정의해 두었다. 이 포스트는 generic하게 WAC api가 접근할 수 있는 모든 인터페이스를 담당하는 deviceapis라는 변수의 내용을 ADE를 이용해서 확인하는 방법을 살펴보았다. deviceapis.listActivatedFeatures()는 현재 runtime에서 활성화된 features의 목록을 확인할 수 있고, deviceapis.listAvaiableFeatures()는 디바이스에서 WAC로 사용할 수 있는 features를 확인할 수 있는 메소드라는 것도 살펴보았다.

## 참조

1. http://appspresso.com/api/wac/symbols/Deviceapis.html

