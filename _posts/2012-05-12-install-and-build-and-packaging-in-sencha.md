---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 1.설치,생성,패키지,빌드
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, install, packaging, build]
comments: true
redirect_from: /139/
disqus_identifier : http://blog.saltfactory.net/139
---

## 서론

![](http://cfile6.uf.tistory.com/image/135EB03C4FACA87C14D71D)

Sencha Touch는 아이폰, 안드로이드, 블랙베리 등 다양한 모바일 디바이스의 웹 앱 개발을 지원하는 자바스크립트 프레임워크이다. 자바스크립트 프레임워크라는 말에 촛점을 맞출 필요가 있는 이유는 Sencha Touch는 거의 대부분의 코드를 Javascript로 생성하기 때문이다. Appspresso(앱스프레소)를 이용해서 하이브리드 앱을 개발하는 방법에 대해서 포스팅하는 가운데 UI javascript 프레임워크 선정할때 후보로 Sencha Touch와 JQuery Mobile, JTouch 를 생각했는데 가장 네이티브 앱에 가까운 다양한 UI 제공과 MVC 프로그래밍을 할 수 있게 설계되어 있는 아키텍처 때문에 Sencha를 HTML5 를 이용한 하이브리드 앱 개발의 UI 프레임워크로 결정했다. (HTML5 기반 앱을 만들기위해서 미리 구입한 Sencha Touch 책이 있기 때문이기도 했는데 현재 판매되고 있는 것은 Sencha Touch 1.x 기반의 책들이다. Sencha Touch 2와 Sencha Touch 1은 구조 자체가 달라졌기 때문에 이전 책을 구입하면 조금 당항할 수도 있다. 물론 Sencha 공식 사이트에서 migration 정보를 문서로 제공하고 있지만 처음부터 Sencha Touch 2로 시작하는 것을 추천하고 싶다.) 하이브리드 앱 개발하는 과정에서 UI 프로그래밍은 필수 조건이다. 그래서 Appspresso에 관련된 포스팅에 연결해서 연재하려고 하다가 Sencha 자체만해도 내용이 방대하고 어렵기 때문에 Sencha라는 카테고리로 분리해서 작성하려고 한다. (참고로 jQuery 정로도 생각하면 정말 이해하는데 어려움을 겪을수 있다.)

Sencha는 데크스탑용과 모바일용 프레임워크가 따로 존재한다. 여기서는 Sencha Touch에 대한 포스팅을 진행할 것이다. Sencha Touch 2에 관한 내용만 포스팅할 것이며 Sencha Touch 1에 대한 비교나 문의에 대해서 답변을 할 수 없을지도 모른다. 이 글을 포스팅할 시점에는 Sencha Touch 2가 릴리즈된 상태이고, 하이브리드 앱 개발 연구에 Sencha Touch 2를 도입하기로 결정하고 Sencha Touch 2부터 바로 적용하기 위해서 이전 버전에서 마이그레이션하는 방법에 대해서는 논의하지 않겠다. (다만, Sencha의 공식 웹 사이트에서 http://docs.sencha.com/touch/2-0/#!/guide/upgrade_1_to_2 에서 마이그레이션하는 방법을 문서로 제공하고 있으니 참고하길 바란다.)

Sencha Touch 2의 공식 문서는 http://docs.sencha.com/touch/2-0/ 에서 확인할 수 있다. 현재 Sencha Touch 2에 관한 책이 나오지 않은 관계로 대부분 공식 사이트의 문서를 참조해서 테스트를 진행하려고 한다. 설명의 편의를 우해서 Sencha Touch 2를 Sencha로 표현하겠다.

<!--more-->

## 설치

Sencha 의 설치는 그냥 배포하고 있는 최신 파일을 다운 받아서 압축을 해제하고 필요한 파일을 사용하면 된다.
http://www.sencha.com/products/touch/download/ 에서 라이센스에 맞는 소스파일을 다운 받으면 된다. 오픈소스 버전과 무료 상용 버전이 있다. HTML5 Now Conference에 참석해서 Sencha의 무료 상용 버전 라이센스에 대해서 질문을 했는데 현재 무료로 진행중이며 더 자세한 사상은 Sencha 공식 교육에서 알려준다고 했으니 라이센스에 대해서는 그 때 다시 언급하도록 하겠다.
이 글을 작성할 때 Sencha의 버전은 2.0.1 이다. 압축을 풀고 디렉토리 내부를 살펴보면 다음과 같이 구성된 것을 확인할 수 있다.

![](http://cfile22.uf.tistory.com/image/160B95504FACBEBB216B50)

Sencha 는 자체적인 command들을 가지고 있는데 2.0 버전에서 있었던 senta shell 명령이 2.0.1 버전에서는 nodejs 명령어로 변경되었다. 자바스크립트 프레임워크 답게 이제 클라이언트 명령어까지 모두 자바스크립트로 처리하려고 하는 것 같다. 그래서 2.0.1 버전부터는 sdk-tools이 필요하다. sdk-tools의 다운로드는 http://www.sencha.com/products/sdk-tools 에서 다운받을 수 있다.

![](http://cfile23.uf.tistory.com/image/1757503C4FACC24C1286E5)

다운 받은 SenchaSDKTools-2.0.0-beta3-osx를 실행시켜보자

![](http://cfile3.uf.tistory.com/image/1324A5374FACC3921008BD)

![](http://cfile25.uf.tistory.com/image/1928F94A4FACC3A133FC22)

Sencha SDK Tools가 정상적으로 설치되면 command/sencha.js 를 실행 시킬 수 있게 된다.

![](http://cfile23.uf.tistory.com/image/137969414FACC3AB367910)

이제 Sencha를 사용할 준비를 모두 마쳤다. Sencha는 점점 더 프로젝트 규모가 커지게 되면서 단순히 자바스크립트 SDK가 아닌 하나의 개발 프레임워크로 변화하고 있는 중이다. Sencha 자체로 이제 하이브리드 앱 프로젝트를 만들거나 네이티브 앱 패키징을 할 수도 있다. 또한 특정 웹 디렉토리에서 자바스크립트와 스타일시트만 추가하던 예전과 달리 Sencha 의 command로 웹 앱 프로젝트까지 생성할 수 있게 되었다.

## 생성

Sencha command를 가지고 예제 프로젝트를 만들어보자. 이름이 SaltfactoryWebApp 이라는 Sencha 프로젝트를 만들기 위해서는 다음과 같이 명령어로 생성할 수 있다.

```text
node command/sencha.js generate app {앱이름} {설치될디렉토리}
```

앱 이름은 SaltfactoryWebApp 으로 /Projects/Workspaces/HTML5/SaltfactoryWebApp 이라는 디렉토리로 설치하게 했다. Sencha Touch 2.0.1 버전부터는 node-uuid 라는 모듈이 필요하다. 2.0 버전에는 필요없었던 것이 nodejs 기반으로 command를 사용하면서 생긴것 같다. 이럴 경우는 npm (node package manager)로 node-uuid 모듈을 설치한다.

```text
npm install node-uuid
```

![](http://cfile4.uf.tistory.com/image/183B4A3E4FAD11ED34AA53)

이때 주의해야할 점은 $SENCHA_TOUCH_HOME 디렉토리 안에서 command/sencha.js 를 실행시켜야한다는 것이다. 그렇지 않으면 다음과 같은 에러를 만나면서 실행할 수 없게 된다.

![](http://cfile7.uf.tistory.com/image/194711464FAD12C705AFB8)

설치된 경로를 에디터로 열어서 확인해보자. 각자 사용하고 있는 에디터를 열어서 확인하면 되겠다. sencha.js 명령어로 생성한 웹앱 프로젝트의 구조는 다음과 같다.

![](http://cfile25.uf.tistory.com/image/17688B414FAD1435251FDE)

간단하게 app/, resource/, sdk/ 라는 폴더가 존재하고 app.js, app.json, index.html,    packager.json 파일이 존재한다.


먼저 `app/` 디렉토리의 구조를 살펴보자. Sencha의 웹앱의 구조는 Ruby on Rails의 프로젝트 디렉토리 구조와 비슷하게 생겼는데 app/ 이라는 디렉토리 밑으로 MVC 구조를 상징하듯 Model, View, Controller라 존재하고 더불어 Profile, Store 디렉토리가 존재한다.

![](http://cfile27.uf.tistory.com/image/1369E3404FAD149C05C619)

`resources/` 는 웹앱에 필요한 css와 icons, images, loading, startup 이미지들이 존재한다. 그리고 sass를 공식적으로 지원하고 있다. sass(Syntactically Awesome StyleSheets) 는 css3의 확장으로 nested rule, variables, mixin, selector inheritance, 외 더 많은 것들이 확장된 것이다. 더욱 자세한 것은 http://sass-lang.com/ 에서 확인하면 될 것이다. sass에서는 .scss 확장자를 가지는 것을 사용하는데 이것은 sass 컴파일러를 이용해서 다이나믹하게 컴파일하여 css를 사용할 수 있게 해주는 것이다. sass와 scss에 대해서는 다음에 좀더 자세히 살펴보도록 하겠다. Sencha Touch의 이름에 맞게 모바일 웹앱에 최적화된 이미지 사이즈를 자동으로 해상도에 맞게 생성해준 것을 확인할 수 있다. Sencha Touch 2.0.1의 주요 업데이트 항목이 Retina iPad를 지원한다는 것이다. 아미지 사이즈를 살펴보면 2048 해상도에 맞는 이미지가 추가된 것을 확인할 수 있다.

![](http://cfile7.uf.tistory.com/image/1173ED3D4FAD1562290DE7)

`sdk/` 디렉토리는 sencha-touch-2.0.1/ 디렉토리 안에 포함된 앱에 필요한 sdk 들이 복사된 것을 확인할 수 있다. (항목이 많아서 캡쳐는 생략한다.) 파일을 살펴보자.


`index.html` 은 sencha가 가지고 있는 유일한 html 파일이다. Sencha는 다른 웹앱 프레임워크와 다르게 모든 것을 자바스크립트로 생성을 하게 된다. 이러한 이유로 최초 웹을 구동시키기 위한 index.html은 Sencha의 자바스크립트와 스타일시트를 로드하고 HTML5을 정의하는데 사용을 한다.
`app.js` 파일은 이름 그대로 Sencha 웹 어플리케이션의 로직이 코드가 들어가는 부분으로 최초 앱이 구동될 initialization 코드가 생성되는 파일이다.
`app.json`은 Sencha 웹 앱이 deployment 하기 위한 설정을 정의한 파일이다.
`packager.json`은 웹 앱을 네이티브 앱으로 패키징하기 위한 설정을 정의한 파일이다. Sencha 로 만든 웹 앱을 애플스토어나, 안드로이드 마켓에 등록하기 위해서 네이티브 앱으로 패키징하기 위해서 설정하는 파일이다.
웹 앱을 실행해보자. 단순하게 index.html 파일을 브라우저로 열어서 확인하면 된다.

![](http://cfile1.uf.tistory.com/image/2055763A4FAD1AC0265C4B)

![](http://cfile21.uf.tistory.com/image/203DE83A4FAD1AC036E7A6)

## 빌드

이렇게 간단하게 sencha.js 를 이용해서 웹 앱을 만들어 낼 수 가 있게 되는 것이다. 이제 이것을 iPhone에 설치해보자.iPhone에 설치하기 위해서는 packger.json을 수정한다.

```javascript
{
 	"applicationName":"SaltfactoryWebApp",
	"bundleSeedId":"634C5D59SE", // 임의코드
	"applicationId":"net.saltfactory.tutorial",
	"versionString":"1.0",
	"iconName":"resources/icons/Icon~ipad.png",
	"inputPath":"build/native",
	"outputPath":"build/",
	"configuration":"Debug",
	"platform":"iOS",
	"deviceType":"Universal",
	"certificatePath":"/Projects/Certificates/Saltfactory/2012-05-01/DevelopmentCertificates.p12", // 개발자 Certificates
	"certificatePassword": "", // 개발자 Certificates 비밀번호
    "provisionProfile": "/Projects/Certificates/Saltfactory/2012-05-01/saltfactory_tutorial_dev.mobileprovision", // provisioning file
	"certificateAlias":"iPhone Developer: Sung Kwang Song (라이센스코드)",
	"orientations": [
		"portrait",
		"landscapeLeft",
		"landscapeRight",
		"portraitUpsideDown"
	]
}
```

## 패키징

이렇게 수정된 것을 가지고 다음 명령어로 packaging을 실시한다. 이렇게 build native를 하면 packager.json 설정에 맞게 build/native 폴더 아래 .app 앱파일 생성이 된다.

```text
node $sencha-touch-2.0.1/command/sencha.js app build native
```

![](http://cfile10.uf.tistory.com/image/114646354FAD35FC0281A8)

이렇게 네이티브 빌드가 마치면 build/native/ 디렉토리 밑으로 SaltfactoryWebApp.app 파일이 생성이 된다. 이 파일을 iTunes로 드래그해서 집어 넣는다.

![](http://cfile22.uf.tistory.com/image/184FBA3A4FAD3564070649)

![](http://cfile4.uf.tistory.com/image/171BC0354FAD361928213C)

이렇게 생성된 .app 파일을 iTunes에 드래그하여 넣는다. 이렇게 iTunes의 Sync Apps 앱 항목에 들어오게 되는데 이를 체크하고 Sync를 선택하면 디바이스로 설치가 된다.

그런데 개발할때 이렇게 디바이스 설치하면 많은 시간이 소비되기 때문에 우리는 simulator에서 실행시켜서 확인하면서 개발하고 싶을 것이다. 이럴 경우 packager.json의 속성 중에 platform을 iOS 에서 iOSSimulator로 변경한다.

```javascript
{
	"applicationName":"SaltfactoryWebApp",
	"bundleSeedId":"634C5D59SE", // 임의코드
	"applicationId":"net.saltfactory.tutorial",
	"versionString":"1.0",
	"iconName":"resources/icons/Icon~ipad.png",
	"inputPath":"build/native",
	"outputPath":"build/",
	"configuration":"Debug",
	"platform":"iOSSimulator",
	"deviceType":"Universal",
	"certificatePath":"/Projects/Certificates/Saltfactory/2012-05-01/DevelopmentCertificates.p12", // 개발자 Certificates
	"certificatePassword": "", // 개발자 Certificates 비밀번호
    "provisionProfile": "/Projects/Certificates/Saltfactory/2012-05-01/saltfactory_tutorial_dev.mobileprovision", // provisioning file
	"certificateAlias":"iPhone Developer: Sung Kwang Song (라이센스코드)",
	"orientations": [
		"portrait",
		"landscapeLeft",
		"landscapeRight",
		"portraitUpsideDown"
	]
}
```

다시 build를 native로 해보자.

```text
node $sencha-touch-2.0.1/command/sencha.js app build native
```

이렇게 iOS simulator로 설치가 되어서 확인할 수 있게 되었다.

![](http://cfile1.uf.tistory.com/image/122551454FAD3A65074D08)

![](http://cfile1.uf.tistory.com/image/185784424FAD3A6F08E562)

![](http://cfile24.uf.tistory.com/image/146024444FAD3A900316FA)

## 결론

이번 포스팅은 Sencha Touch 2를 설치해서 Sencha Touch 2 기반의 웹앱 프로젝트를 생성하고 네이티브 앱으로 빌드하여 디바이스나 simulator로 설치하는 방법에 대해서 알아보았다. 웹앱을 만들어서 앱스토어나 안드로이드 마켓에 앱으로 정식 등록하기 위해서는 웹을 앱으로 네이티브 패키징을 해야하는데 이에 대한 방법을 sencha command를 이용해서 한다는 것도 알아보았다. 앞으로 Sencha Touch 2의 문서를 보면서 클래스, 속성에 대해서 좀더 세밀하게 테스트하는 과정을 포스팅할 것이다. 뿐만 아니라, 앱스프레소와 같은 하이브리드 앱에서 Sencha Touch 를 사용하는 방법에 대해서 포스팅할 것이다.


## 참고

1. http://docs.sencha.com/touch/2-0/#!/guide/command

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
