---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 2.View 생성
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view]
comments: true
redirect_from: /139/
disqus_identifier : http://blog.saltfactory.net/139
---

## 서론

Sencha 는 MVC 패턴으로 웹 앱을 개발할 수 있는 자바스크립트 프레임워크이다. MVC 패턴은 개발시 기능에 따라 모듈로 분리할 수 있고, 하는 역활을 체계적으로 분리하기 때문에 작업을 분업하거나 유지보수에 상당한 이점이 있는 소프트웨어 모델이다. 하지만 우리는 MVC 패턴을 먼저 연습하지 않을 것이다. Sencha에서 MVC를 한번에 이해하기는 어렵기 때문이다. 그래서 View, Model, Controller 순으로 각각의 모듈을 나누어서 설명하고 연습하면서 서서히 MVC에 익숙해질 수 있도록 예제를 준비했다. 우리는 Sencha를 자바스크립트 UI 프레임워크라고도 부리기도 하지만 생각보다 Sencha는 더 많은 부분을 구조화하고 UI 뿐만 아니라 로직까지 포함되어 있는 웹 앱 개발 프레임워크라는 것을 알게될 것이다.

<!--more-->

[Sencah Touch2를 이용한 하이브리드 앱 개발 - 1.설치,생성,패키지,빌드](http://blog.saltfactory.net/139) 글에서 우리는 Sencha command를 이용해서 바로 사용할 수 있는 간단한 Sencha 웹 앱 프로젝트를 생성하는 방법을 살펴보았다. Sencha를 사용해서 웹 앱을 만들수도 있고 Sencha를 하이브리드에 앱의 UI 개발을 위한 프레임워크로 사용할 수도 있다. 예를 들어 Appspresso(앱스프레소)나 Phonegap(폰갭)등으로 하이브리도 코드를 생성하면서 하이브리드 앱의 UI를 Sencha를 이용해서 개발 할 수 있다는 것이다. 그러한 이유로 Sencha command를 설치할 수 없을 경우가 있다. 이러한 경우에는 .js와 .css 파일을 추가해서 사용하면 된다. Sencha를 다운받으면 여러가지 파일들이 존재하지만 실제는 sencha-touch.js와 sencha-touch.css 파일만 있으면 된다. 개발을 할 때는 sencha-touch-all-debug.js와 sencha-touch.css 파일만 있으면 된다. 두개의 차이점은 minify(공백과 주석을 삭제해서 js의 물리적은 파일 크기를 줄이는 방법)를 해서 크기를 단축 시킨 것이다.
그럼 총 세가지 파일이 필요하다. Sencha를 로드하기 위하고 웹 앱이 동작할 수 있는 index.html 파일과, sencha-touch-all-debug.js와 sencha-touch.css를 추가한다.

간단하게 테스트를 하기 위해서 다음과 같은 구조로 디렉토리와 파일을 복사하여 집에 넣어보자. app 디렉토리에서는 Sencha 웹 앱에 관련된 코드들이 들어갈 것인데 처음 view에 대한 것만 테스트하기 위해서 app/view/ 디렉토리만 우선 생성한다.

![](http://cfile9.uf.tistory.com/image/13652E364FB06B101125D1)

![](http://cfile23.uf.tistory.com/image/1529F4394FB06B4B0A3456)

다른 파일은 sencha 라이브러리를 다운받은 것에서 복사하면 되고, app.js과 index.html 파일은 새로 생성한다.
그리고 index.html 파일을 다음과 같이 작성하고 저장한다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>SaltfactorySenchaTutorial</title>

    <link rel="stylesheet" href="lib/sencha-touch.css" type="text/css">

    <script type="text/javascript" src="lib/sencha-touch-all-debug.js"></script>
    <script type="text/javascript" src="app.js"></script>
</head>
<body></body>
</html>
```

## Ext.application

sencah에서 Ext.application 라는 것이 있는데, Ext.app.Application의 인스턴스로 sencha 웹 앱의 Models, Controllers, View 등을 정의하고 의존성있는 파일을 자동으로 로드시키는 기능을 한다. 이 모든것을 준비하고 있다가 lauch라는 메소드그 그러한 일을 담당하게 된다.

간단하게 앱이 실행될 때 Hello, World라는 alert를 출력 시켜보자. app.js를 열어서 다음과 같이 수정하자. 앱의 이름은 'SaltfactorySenchaTutorial' 이고, 앱이 실행될 때 호출되는 launch 에다가 alert 를 추가 시켰다.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',

    launch: function() {
		alert('Hello, World');
    }
});
```

index.html  파일을 열어서 확인해보자. 앱이 실행될 때 lauch 가 실행된다는 것을 우리는 확인할 수 있다.

![](http://cfile22.uf.tistory.com/image/114B283C4FB05C902CFF5A)

우리는 앱이 실행할 때 alert가 아니라 HTML 코드를 나타내고 싶을 것이다. 그럴 경우는 lauch 안에다 html 코드를 작성하는 코드를 입력하면 된다.
app.js 파일을 다음과 같이 수정하고 index.html 파일을 새로 고침 해보자.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorail',

    launch: function() {
		document.write("<h1>Hello, World!</h1>");
    }
});
```

![](http://cfile1.uf.tistory.com/image/192A72364FB05D9E31B0D8)

또는 다음과 같이 수정해보자.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',

    launch: function() {
		//document.write("<h1>Hello, World!</h1>");
		var body = document.getElementsByTagName("body")[0];
		body.innerHTML = "<h1>Hello2, World!</h1>";
    }
});
```

## launch

실행결과는 모두 동일하게 Ext.application의 lauch에 추가한 메소드가 실행될 때 그 안에 작성한 HTML를 추가하는 코드가 동작하게 되는 것이다. 이제 우리는 Sencha를 이용해서 HTML 코드를 추가하는 방법을 알아보자. app.js 파일을 다음과 같이 수정한다.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',

    launch: function() {
		//document.write("<h1>Hello, World!</h1>");

		// var body = document.getElementsByTagName("body")[0];
		// body.innerHTML = "<h1>Hello2, World!</h1>";

		Ext.create('Ext.Panel', {
			html: '<h1>Hello, World!</h1>',
			fullscreen:true
		});
    }
});
```

Sencha의 Panel의 html으로 코드를 추가할 경우는 위에서 추가한 HTML과 다르게 생성된다는 것을 확인할 수 있다.

![](http://cfile24.uf.tistory.com/image/11238E374FB0609333BB07)

이것은 Ext.Panel 이라는 것을 사용해서 html을 추가하기 때문인데. Sencha의 뷰 컴포넌트를 사용하면 Sencha가 제공하는 DOM 구조와 디폴트 스타일로 만들어지게 되고 그 안에 사용자가 정의한 html 코드가 추가되기 때문이다. Ext.panel에 좀더 자세히 살펴보자. 다음은 Sencha Touch 2의 공식 다큐먼트에 정의된 Ext.Panel의 구조를 나타낸 화면이다. Ext.Panel은 Ext.Base > Ext.Evented > Ext.AbstractComponent > Ext.Component > Ext.Container를 상속받아서 만들어졌다.

![](http://cfile10.uf.tistory.com/image/1534BC374FB0616F12DA5E)

Ext.Panel은 application에서 어떠한 container를 overlay할 때 사용하는 Container 컴포넌트이다. Ext.Container는 다음과 같은 특징을 가지고 있다. runtime에 instantiation을 해서 child component를 추가할 수 있거나 제거할 수 있다. 또한 특별한 layout을 구성할 수도 있다. layout에 대해서는 나중에 좀더  자세히 살펴보기로 하고, 중요한 특징은 run time에 실시간으로 컴포넌트가 추가되거나 삭제할 수 있다는 것이다. 우리가 작성한 코드는 앱이 실행할 때 이러한 속성을 지난 Panel을 하나 생성하여 fullscreen으로 만들었고 그 아래 HTML 코드를 추가하도록 한 것이다. Panel과 container의 이해를 위해서 다음 코드를 실행해보자.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',

    launch: function() {
		var button = Ext.create('Ext.Button', {
			text:'button',
			id: 'rightButton'
		});

		Ext.create('Ext.Container', {
			fullscreen: true,
			items: [
				{
					docked: 'top',
					xtype: 'titlebar',
					items: [button]
				}
			]
		});

		Ext.create('Ext.Panel', {
			html: 'Floating Panel',
			left: 0,
			padding: 10
		}).showBy(button);
	}
});
```

이렇게 run time에서 Ext.Panel와 Ext.Container를 이용해서 특정 컴포넌트를 overlay 시키도록 추가하거나 삭제할 수 있게 된다. 각가의 컴포넌트에 대해서는 앞으로 자세히 다루게 될 것이다. 한가지 확인할 것은 Ext.Container를 상속받게 된 컴포넌트들은 모두 run time에서 추가할 수 있다는 것이다.

![](http://cfile25.uf.tistory.com/image/12106A394FB064860CEF93)

다신 우리가 작성한 app.js로 돌아오자. 우리는 Ext.Panel 을 추가할 때 Ext.create라는 것을 사용하였다. Ext.create는 실제 Ext.ClassManager로 클래스의 이름과 실제 객체와 매핑을하는 역활중에서 instantiate를 실행하는 기능을 가지고 있다. Ext.ClassManager에 관해서는 http://docs.sencha.com/touch/2-0/#!/api/Ext.ClassManager 에서 확인할 수 있다. 쉽게 말해서 Ext.create에 정의한 이름을 가지고 Sencha에서 사용할수 있는 객체를 생성하고 매핑하는 것이다. 이렇게 Ext.ClassManager를 이용해서 객체를 생성시키는 방법은 다음과 같이 사용할 수도 있다. 아래 방법은 Ext.define으로 Ext.Panel을 상속받은 SaltfactorySenchaTutorial.view.Welcom 객체를 Ext.ClassManager인 Ext.define으로 정의하고 정의한 이름을 이용하여 Ext.create에서 이름으로 클래스를 생성하고 매핑하는 작업을 하는 것이다. index.html을 새로고침해서 확인하면 앞에서 출력한 형태 그대로 출력이 된다.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',

    launch: function() {
		//document.write("<h1>Hello, World!</h1>");

		// var body = document.getElementsByTagName("body")[0];
		// body.innerHTML = "<h1>Hello2, World!</h1>";

		// Ext.create('Ext.Panel', {
		// 	html: '<h1>Hello, World!</h1>',
		// 	fullscreen:true
		// });

		Ext.define('SaltfactorySenchaTutorial.view.Welcome', {
			extend: 'Ext.Panel',

			config: {
				html: 'Hello, World!',
				fullscreen: true
			}
		});

		Ext.create('SaltfactorySenchaTutorial.view.Welcome');
	}
});

```
## View

이렇게 미리 정의한 View를 담당하는 클래스를 추가해서 나타나게 할 수도 있다. 또한 우리가 처음 시작할 때 app 이라는 디렉토리와 그 아래로 view라는 디렉토를 만들었는데 그 디렉토리 안에 Welcome.js이라는 파일을 하나 추가하자.

![](http://cfile1.uf.tistory.com/image/1477CA384FB06C6D18063F)

그리고 Welcome.js에 다음 코드를 추가하자.

```javascript
Ext.define('SaltfactorySenchaTutorial.view.Welcome', {
	extend: 'Ext.Panel',

	config: {
		html: 'Hello, World!',
		fullscreen: true
	}
});
```

그리고 app.js 코드를 다음과 같이 수정하자. Ext.application에서 우리가 사용할 view를 미리 설정할 것이다. 이름은 Welcome이라는 이름으로 지정하였고, 이 이름을 기반으로 app/view/Welcome.js 라는 물리적인 파일이 존재해야한다. 그리고 Ext.create로 SaltfactorySenchaTutorial.view.Welcome 이라는 뷰를 instantiate 하여 생성하여 이름과 클래스를 매핑하는 것이다. 이렇게 어플리케이션에서 뷰에 관련된 파일만 분리할 수 있게 되었다.

```javascript
Ext.application({
    name: 'SaltfactorySenchaTutorial',
    views: ['Welcome'],
    launch: function() {
		//document.write("<h1>Hello, World!</h1>");

		// var body = document.getElementsByTagName("body")[0];
		// body.innerHTML = "<h1>Hello2, World!</h1>";

		// Ext.create('Ext.Panel', {
		// 	html: '<h1>Hello, World!</h1>',
		// 	fullscreen:true
		// });

		Ext.create('SaltfactorySenchaTutorial.view.Welcome');
	}
});
```

우리가 view를 접근할 때 이름 기반으로 접근할 수 있는데 어플리케이션 이름을 SaltfactorySenchaTutorial이라고 지정하였기 때문에 너무 긴 이름을 사용한다 이럴 경우 다음과 같이 alias를 사용할 수 있다. app.js 파일을 다음과 같이 수정하자 우리는 welcome_view라는 alias를 가진 View를 만들것이다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	views: ['Welcome'],

    launch: function() {
		//document.write("<h1>Hello, World!</h1>");

		// var body = document.getElementsByTagName("body")[0];
		// body.innerHTML = "<h1>Hello2, World!</h1>";

		// Ext.create('Ext.Panel', {
		// 	html: '<h1>Hello, World!</h1>',
		// 	fullscreen:true
		// });

		//Ext.create('SaltfactorySenchaTutorial.view.Welcome');
		Ext.create('welcome_view');
	}
});
```

Ext.define에서 alias를 추가하여 긴 이름의 뷰 이름을 간단한 alias로 변경하였다.

```java
/**
* file : Welcome.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.Welcome', {
	extend: 'Ext.Panel',
	alias: 'welcome_view',

	config: {
		html: 'Hello, World!',
		fullscreen: true
	}
});

```

다시 index.html을 새로 고침하여 확인하면 위에서 작성한 화면과 동일하게 나타나는 것을 확인할 수 있다.
웹 앱을 만들때 우리는 view의 사즈를 결정하고 싶어할 수 있다. 이럴때는 Ext.Panel에 속성(config options)을 이용하면 된다.

```javascript
/**
* file : Welcome.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.Welcome', {
	extend: 'Ext.Panel',
	alias: 'welcome_view',

	config: {
		html: 'Hello, World!',
		fullscreen: true,
		width: 320,
		height: 480
	}
});
```

![](http://cfile2.uf.tistory.com/image/1506A7444FB0766339A150)

또한 뷰가 스크롤이 가능하게 하고 싶어할 수도 있다 이럴 경우는 scrollable 속성을 true로 추가한다.

```javascript
/**
* file : Welcome.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.Welcome', {
	extend: 'Ext.Panel',
	alias: 'welcome_view',

	config: {
		html: 'Hello, World!',
		fullscreen: true,
		width: 320,
		height: 480,
		scrollable: true
	}
});
```

![](http://cfile8.uf.tistory.com/image/115651414FB076DE2D8206)

## 결론

이 밖에서 Sencha에서 매우 다양한 속성을 미리 지정해 두었다. 마치 아이폰이나 안드로이드의 네이티브 앱과 동일한 UI를 얻기에 충분한 속성들이 포함되어 있지 않나 생각이 든다. 앞으로 우리는 더 다양한 컴포넌트에 대해서 실습해 볼 것이기 때문에 자세한 속성에 대해서 이 포스트에서는 일일히 열거하지 않겠다. 나중에 특정 컴포넌트를 구현할 때 하나하나씩 소개하도록 할 예정이다. Sencha는 하이브리드 앱을 위해서 나온게 아니라 최초 부터 웹 앱을 위해서 만들어진 것이다. 그러한 이유로 꼭 모바일에 맞는 환경 말고도 사용자가 집접 뷰를 정의하거나 추가하여 다양한 UI를 만들어낼 수 있는 강점을 가지고 있다. Sencha MVC 중에서 View를 생성하는 것을 예제로 살펴보았다. Panel 뿐만 아니라 더 다양한 컴포넌트를 추가하거나 삭제할 수 있고 이건은 run time에서가 가능한데 이유는 Ext.Container를 상속받았기 때문이다. Sencha의 구조는 매우 복잡하고 클래스 패턴뿐만아니라 mixedin으로 구성되어 있기 때문에 그 내요을 모두 다 포스팅하기는 불가능하다. 다만 이 블로그에서는 하이브리드 앱을 개발하기 위해서 도입한 Sencha를 연구하면서 본인이 가장 필요한 컴포넌트와 그에 대한 설정과 사용법에 대해서 기록해 나갈것이다. 더 상세한 내용이 필요하다면 반드시 Sencha Touch 2 공식 문서를 확인하길 바란다.

## 참고

1.http://docs.sencha.com/touch/2-0/#!/guide/views
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.Container
3. http://docs.sencha.com/touch/2-0/#!/api/Ext.ClassManager
4. http://docs.sencha.com/touch/2-0/#!/api/Ext-method-create
5. http://docs.sencha.com/touch/2-0/#!/api/Ext-method-define

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
