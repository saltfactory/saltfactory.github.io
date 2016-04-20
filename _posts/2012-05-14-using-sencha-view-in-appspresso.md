---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 10.Sencha 뷰 추가하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha]
comments: true
redirect_from: /141/
disqus_identifier : http://blog.saltfactory.net/141
---

## 서론

Appspresso (앱스프레소)는 하이브리드 앱을 개발할 수 있는 개발 프레임워크이다. 이 말을 잘못 이해해서 앱스프레소가 마치 Xcode나 Adobe Dreamweaver 와 같이 Drag & Drop 으로 UI를 만들고 코드 snippet이 제공된다고 오해하면 안된다. Appspresso는 멀티 디바이스 (현재는 iOS, Android 만 제공한다) 하이브리드 앱 개발을 할 수 있는 SDK 와 WAC, 써드파티 Plugins 들이 포함된 웹 프로그래밍과 네이티브 프로그래밍을 조화롭게 개발할 수 있는 IDE를 제공하는 하이브리드 개발 프레임워크이다.

Appspresso (앱스프레소)는 UI 템플릿을 제공한다. 이 프레임워크에는 Sencha Touch, JQuery Touch, JO 등의 템플릿을 제공하고 있다. 즉, 이렇게 자바스크립트나 HTML5 기반의 라이브러리를 이용해서 UI를 만들 수 있다는 것이다. 그럼 왜 자바스크립트 라이브러리를 사용해야하느냐 의문이 생길 수도 있는데 하이브리드 앱을 정의할 때는 크게 두가지 관점에서 정의를 할 수 있다. 네이티브 앱에 웹 앱이 포함되는 경우와 웹 앱에 네이티브 앱이 포함되는 경우를 말한다. 전자는 흔히 Xcode나 elcipse등 네이티브 코드를 작성하다가 필요한 순간 UIWebView나 android.widget.WebView를 프로그램에 포함시켜(embeded)서 네이티브 코드와 서로 데이터를 주고 받으며 처리한다. 후자는 Appspresso (앱스프레소)와 같은 하이브리드 앱 개발 프레임워크를 이용해서 웹에서 네이티브코드를 호출해서 사용하는 것이다. 전, 후자 모두 각각 장단점이 있다. 전자와 같은 경우는 네이티브코드가 운영되고 있기 때문에 후자보다 자원사용이 효과적이다. 쉽게 말해서 더 빠르다는 것이다. 반면에 디바이스에 각각 독릭접인 UI를 핸들링하기 때문에 실제 공통으로 사용할 수 있는 코드는 embeded되는 웹 속의 적은 코드만 재활용할 수 있게 된다. 즉 개발 비용을 감축시키는데 효과적이지 못하다는 것이다. 반면 후자는 전자보다 공동으로 사용할 수 있는 코드가 상대적으로 많아지게 된다. 동일한 UI를 제공하면(꼭 동일한게 좋은 것은 아니지만, 대부분의 하이브리드 개발자는 혼자힘으로 멀티 디바이스를 감당하기 힘들기 때문에 단일 UI를 개발할거라 생각한다.) 웹으로 작성한 코드는 그대로 사용할 수 있기 때문이다. 다만, 브라우저 자원의 한계 때문에 네이티브 코드보다 성는이 낮다는 약점이 있다. 하이브리드 앱 개발자는 이 두가지의 trade off를 잘 이해하고 접목해야할 것이다. 후자와 같이 개발하면서 네이티브와 비슷한 액션 게임을 만들려고하는 개발자가 있을 수 있을까? 물론 그런 시도도 여러군데서 많이 하고 있지만 아직까지 디바이스의 물리적 제한때문에 별로 추천하고 싶지 않는 방법이다. 상황에 맞게 가장 적합한 개발 모델을 도입하는게 개발비용대 효과를 얻을 수 있을 것이라 생각된다.

<!--more-->

서론이 길었는데, 오늘 포스팅하는 내용은 바로 Appspresso (앱스프레소)로 개발할 때 UI 구성을 어떻게 하느냐는 것이다. 사실 블로그에 Appspresso에 대한 내용을 포스팅하면서 Sencha를 같은 카테고리에 넣고 동시에 설명해야할까 고민을 하게 되었다. 내용은 하이브리드 앱을 개발로 연구를 진행하고 있는데 사실 Sencha 자체로도 훌륭하고 공부해야할 양이 너무 많기 때문에 Appspresso에 집중해야할 내용이 희석될것 같아서 분리하게 되었다. 그래서 Sencha에 관한 내용은 http://blog.saltfactory.net/category/Sencha 에서 계속 업데이트될 예정이니 확인하길 바란다.

Sencha에 대한 설명은 [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 1. 설치, 생성, 패키징, 빌드(device, simulator)](http://blog.saltfactory.net/139)과 [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 2. 뷰(View) 생성](http://blog.saltfactory.net/140) 글로 대신하고 설정하는 방법부터 들어가보자 한다.

Appspresso에서 새로운 Appspresso Proejct를 생성하면 앱스프레소에서 제공하는 Javascript UI framework 를 선택할 수 있지만, 선택하지 않고 바로 Hello World 프로젝트로 생성하기로 한다.

![](http://blog.hibrainapps.net/saltfactory/images/badeb542-6b69-48f9-bf63-e88f24d5f76c)

## Sencha

이유는 Appspresso 현재 버전에서는 Sencha 1.x 버전은 제공하고 있기 때문이다. 현재 Sencha Touch는 2.0.1 버전이 가장 최근 라이브러리이다. 1.x와 2.x는 성능 향상을 위해서 구조자체를 고쳤다고 알려지고 있다. 뿐만 아니라 2.0.1 부터는 레티나 iPad를 지원하고 있다. 이러한 이유로 우리는 Sencha Touch 2.0.1을 다운받아서 사용할 것이다. Sencha Touch 2  사이트에서 Sencha Touch 2.0.1을 다운받도록 한다. http://www.sencha.com/products/touch/download/

다음은 sencha-touch-2.0.1에서 sencha-touch-all-debug.js와 sencha-touch.css 를 Appspresso 프로젝트의 js와 css에 각각 복사한다.

![](http://blog.hibrainapps.net/saltfactory/images/c3062fa4-852a-4c07-9628-115b0a831620)

다음은 index.html 에서 Sencha 파일들을 불러오게 다음과 같이 수정한다.

```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script src="/appspresso/appspresso.js"></script>
		<link rel="stylesheet" href="/css/sencha-touch.css" type="text/css"/>
		<script src="/js/sencha-touch-all-debug.js" type="text/javascript" charset="utf-8"></script>
		<script src="/js/app.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	</body>
</html>
```

우리는 간단하게 웹 앱을 만들어 볼 것이다. app.js를 /js 폴더 아래에 생성한다. Sencha command 없이 그냥 메뉴얼하게 Sencha 파일을 추가해서 웹 앱을 만드는 방법은 "Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 2. 뷰(View) 생성" 글을 참조하길 바란다. Appspresso의 디렉토리 안에서 만들어지는 내용만 다른 것이고 모든 동작 원리는 동일하다.

이제 간단하게 웹 앱이 로드될 때 "Hello, World!"를 출력시켜보도록하자. 다음 코드를 app.js에 추가한다.

```javascript
/**
 * file : app.js
 * email : saltfactory@gmail.com
 */

Ext.application({
    name: 'SaltfactorySenchaTutorail',

    launch: function() {
		Ext.create('Ext.Panel', {
			html: '<h1>Hello, World!</h1>',
			fullscreen:true
		});
    }
});
```

앱스프레소에서 빌드하고 simulator에 설치해서 실행해보자.

![](http://blog.hibrainapps.net/saltfactory/images/c652e3d4-c867-4ac8-a4d9-78e1ab54fa23)

생각했던 UI가 아니라서 실망을 했을지도 모르겠다. 뭔가 아이폰스럽게 UINavigationBar도 나와야 할 것 같고, UITabBar도 나와야 할 것 같은데 텅빈 화면에 단순하게 Hello, World! 만 출력되었기 때문이다. 하지만 너무 속상해 하지 말자. 우리는 앞으로 그런 Sencha의 컴포넌트를 하나씩 만들어가서 점점 네이티브 앱으로 업그레이드는 과정을 경험하게 될 것이다. "Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 2. 뷰(View) 생성"의 글과 동일하게 우리는 최종적으로 Sencha를 MVC 모델로 프로그래밍하길 원하기 때문에 여기서 뷰는 따로 분리해서 view라는 디렉토리에 저장하길 원한다. 그런데 Appspresso에서 javascript를 일괄적으로 저장하기 위해서 만들어 준 디렉토리 js가 있다. 이 곳에 우리는 Sencha App을 저장하길 원하고 /app 디렉토리가 아닌 /js/app의 디렉토리에 접근하기 위해서 Sencha에서는 어떤 작업을 하는지 살펴보기로 하자.
우선 우리는 앱이 시작되면 가장 처음 보이는 MainView.js를 만들어보자.

![](http://blog.hibrainapps.net/saltfactory/images/ce4cbfd2-234f-4c44-9dbd-b94bc2067863)

디렉토리 구조는 다음과 같이 /js/app/view/ 가 존재하고 그 안에 MainView.js를 생성하였다. MainView.js 안에는 다음과 같이 입력한다.

```javascript
/**
* file : Welcome.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
		html: 'Hello, World!',
		fullscreen: true
	}
});

```

자세한 내용은 http://blog.saltfactory.net/140 을 살펴보면 된다. 간단하게 이야기하면 SaltfactorySenchaTutorial의 앱 프로젝트의 이름으로 매핑되는데 app/view/MainView.js를 참조하고 alias로 main_view를 만들어서 사용하겠다는 정의이다. 그리고 app.js 파일을 다음과 같이 수정한다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	views: ['MainView'],
    launch: function() {
		Ext.create('main_view');
	}
});
```

앱스프레소를 실행해보자. 원래 Sencha의 default app 폴더는 최상위 폴더이기 때문에 다음과 같이 작성하면 다음과 같은 오류가 발생한다.

![](http://blog.hibrainapps.net/saltfactory/images/e59ca162-0f59-4472-8e41-2bdda41b9f3d)

이런 경우에는 application 경로를 변경해야하는데 Ext.applicaton 의 속성에 다음을 추가한다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	views: ['MainView'],
	appFolder: '/js/app',
        launch: function() {
		Ext.create('main_view');
	}
});

```

이제 정상적으로 화면이 에러 없이 출력되는 것을 확인할 수 있을 것이다. Sencha의 Ext.ClassManager는 Ext.create로 instantiate를 할 때 이름으로 객체와 매핑을 하고, 자원을 매핑한다. 이러한 이유로 Ext.Load에서 file exists 에러를 만나게 되면 대부분 이름이 잘못 표기되었거나 이름과 매핑되는 경로에 파일이 존재하지 않아서 발생하는 문제이다.

Sencha 는 MVC 모델을 따른다. 아마도 연구하면서 Sencha를 선택한 이유가 이 MVC 를 지원하기 때문이 가장 큰것 같다. 반면 Sencha는 jQuery Mobile이나 JTouch 보다 많이 무겁다.  이것은 두가지를 의미한다. 대부분의 UI가 모두 프로그래밍 되어 있다는 의미이고 다른 의미는 잘못 사용하면 성능상 문제를 일으킨다는 것이다. 연구의 목적은 UI 코드를 최대한 다시 작성하지 혼자서 아이폰과 안드로이드 폰의 앱을 개발하는 방법이 첫번째 목적으로 두었다. 그러면서도 안정화 되어 있고, 마이그레이션이 소스를 모듈로 나누어서 개발하고 싶었기 때문에 선택을 Sencha로 했다. jQuery 를 이용해서 더 멋지 앱을 만드는 사례도 많다. Sencha는 배우기 어렵고 무겁다. 선택은 하이브리드 앱을 개발할 때 어떤 관점으로 개발을 할지를 생각하고 도입하는 연구원의 몫이다. Sencha의 무거운 코드를 minify하고 optimizer하는 방법까지 포스팅할 수 있을지 모르겠지만, 프로젝트가 마감되기 전에 아마 그러한 문제를 해결하는 직면에 부딛힐 것이다. (그 과정을 거쳐가면서 블로그를 계속 이어갈수 있도록 자료와 조언을 많이 부탁합니다.)

마지막으로 하이브리드 앱에게 이런 UI를 남겨 두는 것이 너무 미안하기 때문에 간단하게 소스를 고쳐보자.

```javascript
/**
 * file : Welcome.js author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Panel',
	alias : 'main_view',

	config : {
		fullscreen : true,
		items : [ {
			xtype : 'toolbar',
			docked : 'top',
			title : 'Home',
		} ],
		html : '<h1> Hello, World!</h1>'
	}

});

```

간단하게 toolbar가 생기고 이제 조금은 앱처럼 보인다. 여기서 xtype에 대해서는 설명하지 않지만 다음 포스팅에서 설명할 예정이다. Sencha로 UI를 만들기가 쉬운것 같지만 생각만큼 쉽지 않기 때문에 하나하나 연구해보기로 한다.

![](http://blog.hibrainapps.net/saltfactory/images/dd0a76fc-506e-4e8f-8d6f-ca69e8eb1162)

## 결론

이 포스트에서는 view 파일을 분리하고 추가하는 방법에 대해서 알아봤고, Sencha의 기본 디렉토리가 아닐 경우 Ext.application의 setFolder로 앱 디렉토리를 추가하는 방법에 대해서 알아보았다. 그리고 Sencha command 없이 Appspreso(앱스프레소)에서 sencha 라이브러리를 추가해서 sencha 프레임워크중에 Ext.create로 간단하게 뷰를 추가하는 방법에 대해서 알아보았다. 앱스프레소 관련 포스팅에서슨 Sencha에 대해서 그렇게 깊게 포스팅하지 않고 Sencha 2 튜토리얼 포스팅에 내용을 상세히 포시팅하고 링크로 대신할 것이다. 그런한 이유로 Sencha Touch 2 튜토리얼도 반드시 읽어보면 도움이 될 것이다. 다만 이후에 웹 앱이 아닌, 하이브리드 앱으로 Sencha를 설명하는 포스팅에서는 네이티브코드와 Sencha의 Model 과 어떻게 연관되는지 자세히 설명할 예정이다.

