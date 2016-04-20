---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 9.Controller
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, controller]
comments: true
redirect_from: /154/
disqus_identifier : http://blog.saltfactory.net/154
---

## 서론

이 포스팅은 Sencah Touch의 MVC 에 관한 아티클 중에 마지막 컨트롤러(Controller)에 관한 이야기이다. 우리는 Sencha 의 MVC 중에서 시각적 요소를 만들기 위한 View와 데이터와 로직을 담당하는 Model을 같이 살펴보았다. 이제 사용자의 이벤트를 받거나 데이터 처리 후에 특정 Model이나 View 작업을 지시하는 컨트롤러에 대해서 살펴보자. 이미 Springframework과  Ruby on Rails의 MVC에 익숙해져 있는 상태에서 Sencha MVC의 컨트롤러는 조금 당황스럽게 느껴졌다. 아마 Client Software를 개발해본 개발자에게는 익숙할 수 있는 컨트롤러의 동작일 수도 있지만 웹 개발에서 MVC를 주로 다루는 나에게 URL 요청 없이 사용자의 이벤트를 특정 동작으로 매핑시키는 것이 어색했던 것이다. 하지만, Sencha에서는 이런 동작이 너무 당연하다. Sencha는 Javascript 기반의 프레임워크로 사용자의 이벤트와 데이터 워크프롤우를 메소드로 연결시켜서 작업하기 때문에, 특정 이벤트를 특정 메소드로 연결시켜주는 기능이 바로 컨트롤러의 기능인 것이다.
그럼 이벤트를 어떻게 받을 것인가에 대해서 살펴봐야하는데 Sencha Touch 2.x 부터 refs 라는 속성이 추가되면서 HTML의 DOM이나 View 등의 객체를 쉽게 참조(References)할 수 있게 구현해 두었다.

<!--more-->

## Ext.Titlebar

우선 이벤트를 처리하기 위해서 간단한 Ext.Titlebar를 만들어보자.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {

        var composeButton = {
	    	xtype:'button',
	    	iconCls:'compose',
	    	iconMask:true,
	    	align:'right',
    	}  

    	var titleBar = {
	    	xtype: 'titlebar',
	    	title: 'Test Controller',
	    	docked: 'top',
	    	items: composeButton
    	}

    	Ext.Viewport.add(titleBar);

	}
});
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/726042b9-b9f3-4014-a49f-e6f77a042d85)

우리는 이제 Ext.Container를 추가해서 xtype을 이용해서 컴포넌트를 하나 추가하는 일은 매우 쉽게 할 수 있을 것이다. (혹시 이 방법에 대해서 아직 잘 모른다면 http://blog.saltfactory.net/category/Sencha 에서 Sencha Touch 2 (센차터치)를 이용한 웹 앱 개발 2~7 까지 살펴보길 바란다.)

우리는 이전에 Ext.Button에 이벤트를 처리를하기 위해서 handler 메소드를 구현했었다. (기억이 나지 않을 경우는 http://blog.saltfactory.net/143 에서 4. 이벤트 추가하기를 살펴보길 바란다.) 간단히 composeButton을 클릭할 때 이벤트를 처리하는 코드를 추가해보자.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {

        var composeButton = {
	    	xtype:'button',
	    	iconCls:'compose',
	    	iconMask:true,
	    	align:'right',
		handler:function(){
			console.log('composeButton handler')
		}
    	}

    	var titleBar = {
	    	xtype: 'titlebar',
	    	title: 'Test Controller',
	    	docked: 'top',
	    	items: composeButton
    	}


    	Ext.Viewport.add(titleBar);

	}
});
```

handler를 구현하고 composeButton을 누르면 console에 'composeButton handler'가 출력되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/776ba94c-b1b1-43f1-8788-889ba552001e)

위 코드는 우리가 MVC 에서 사용하고 싶어하는 코드가 아니다. 위 코드에서 뷰와 컨트롤러를 분리해보자. 우선 application에서 View를 분리해보자. /apps/view/MainView.js를 만들고 다음 코드를 추가하자.


```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Container',
	alias: 'mainView',
	config: {
		fullscreen: true,
	},
	initialize:function(){
            var composeButton = {
	    	xtype:'button',
	    	iconCls:'compose',
	    	iconMask:true,
	    	align:'right',
			handler:function(){
				console.log('composeButton handler')
			}
    	    }

    	var titleBar = {
	    	xtype: 'titlebar',
	    	title: 'Test Controller',
	    	docked: 'top',
	    	items: composeButton
            }

	this.add(titleBar);
	}
});
```

그리고 app.js에서 view를 분리했기 때문에 views에 MainView를 등록하고 애플리케이션이 launch 할때 생성하도록 코드를 다음과 같이 수정한다.


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

        Ext.create('mainView');

	}
});
```

MainView를 분리하기 전에는 app.js에서 이벤트 처리가 되기 때문에 app.js에서 콘솔 로그가 찍혔지만 MainView로 뷰를 분리하고 나서는 MainView에서 이벤트처리가 이루어졌다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7f036cc5-4ba5-4c3f-a193-bc508eaf49e5)


## Controller

하지만 우리가 원하는 것은 View에서 완전히 이벤트 처리를 하는 부분은 Controller로 분리해서 Controller에서 데이터 처리를 하길 원한다. 이제 /app/controller에 MainController.js를 추가하고 다음 코드를 입력해보자. 컨트롤러를 추가하기 전에 MainView에서 이벤트처리하는 부분을 제거하고 컨트롤러가 composeButton을 참조할 수 있게 identifier를 만들어 두자. id는 document.getElementById와 같은 selector를 이용해서 이후에 controller가 이벤트를 등록하고 리스닝할 수 있게 하는 것이기 때문에 중복되지 않는 id로 지정하는 것이 좋다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Container',
	alias: 'mainView',
	config: {
		fullscreen: true,
	},
	initialize:function(){
        var composeButton = {
	    	xtype: 'button',
	    	iconCls: 'compose',
	    	iconMask: true,
	    	align: 'right',
		id: 'composeButton'
		// handler:function(){
		// 	console.log('composeButton handler')
		// }
    	}

    	var titleBar = {
	    	xtype: 'titlebar',
	    	title: 'Test Controller',
	    	docked: 'top',
	    	items: composeButton
    	}

		this.add(titleBar);
	}
});
```

이제 MainController를 추가하자. 컨트롤러는 이벤트를 특정 identifier에 등록하고 이벤트가 등록된 것에 엑션이 일어나면 실제 이벤트를 처리하기 위해서 구현한 컨틀롤메소드를 호출하는 기능을 하고 있다. 우리는 위에서 이벤트를 등록시킬 composeButton에 id로 "composeButton"으로 지정하였다. refs는 참조자로 HTML의 selector를 이용해서 이벤트를 등록한 엘리먼트를 참조한다. 이때 selector는 jquery의 셀렉트와 유사하다. 그렇게 참조된것을 컨트롤러 속성으로 등록을 한다. 그리고 그 속성이 어떤 이벤트로 동작할지를 지정하고 그 이벤트에 처리하는 메소드로 연결하는 작업을 conrol에서 지정할 수 있다. 아래 코드에 연관된 속성과 값을 같은 색상으로 구별했다.

```javascript
/**
* file : MainController.js
* author : saltfactory
* email : saltfactory@gmail.com
*/
Ext.define('SaltfactorySenchaTutorial.controller.MainController', {
	extend: 'Ext.app.Controller',
	alias: 'MainController',
	config: {
		refs: {
			composeButton: '#composeButton'
		},
		control: {
			composeButton: {
				tap : "onComposeButton"
			}
		}
	},

	onComposeButton:function(){
		console.log("onComposeButton");
	},

	init:function(){
		console.log('init MainController');
	},
	launch:function(){
		console.log('launch MainController');
	}

});
```

마지막으로 Controller를 추가했으니 이제 app에서 controller를 등록해야한다. app.js를 다음과 같이 수정한다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.application({
name: 'SaltfactorySenchaTutorial',

views: ['MainView'],
controllers: ['MainController'],

launch: function() {

        Ext.create('mainView');

	}
});
```

새로고침하여 앱을 다시 실행시켜보면 다음과 같이 MainController가 초기화 할 때 init 메소드를 호출하고, launch 될 때 launch 메소드를 호출한다. 그리고 composeButton을 누르면 MainController의 onComposeButton 핸들러 메소드가 실행하도록 컨트롤러가 동작한 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a192696b-54f7-4b88-aa4c-2fb5b55b9663)

## 결론

간단하게 Sencha에서 하나의 코드로 뷰와 이벤트 처리를 하는 부분을 논리적으로 View와 Controller로 나누어서 코드를 분리할 수 있는 방법을 테스트해보았다. 이제 팀 프로젝트나 논리적으로 코드를 분리하여 MVC 패턴으로 개발을 할 수 있는 기본적인 예제들은 모두 완료했다. 블로그에 소개한 Sencha의 MVC는 아주 기본적인 예제를 준비해서 소개한 것이다. Sencha는 블로그에 소개하지 않은 아주 많은 속성들을 가지고 있다. Ext 컴포넌트 자체가 많은 기능, 속성, 옵션들이 존재하기 때문에 이것은 실제 개발하면서 조금씩 소개할 예정이다. Sencha Touch는 javascript 기반의 웹 앱을 만드는 프레임워크로 많은 컴포넌트와 기능을 포함해서 소스코드 자체가 방대한 크기를 가지고 있다. 하지만 현재 존재하는 웹 앱 프레임워크 중에서 가장 네이티브 형태와 유사하게 만들 수 있는 템플릿을 제공하고 있으며 거의 대부분 이 템플릿으로 개발이 가능하다. 그리고 Sencha는 자체적으로 MVC를 지원하고 있기 때문에 웹 앱을 개발할 때 따로 MVC 개발 패턴을 약속하거나 수동으로 만들지 않고, Sencha Touch가 제공하는 MVC 개발 로직으로 만들면 편리하게 MVC 패턴으로 코드를 분리하고 유지 보수 할 수 있다는 장점을 가지고 있다.

이제 Sencha의 기본적인 컴포넌트 내용과, Sencha의 MVC에 대해서 소개는 마치고, 실제 이렇게 분리해서 소개한 MVC를 가지고 직접 모바일 앱에 적용하는 방법에 대해서 포스팅이 계속 진행될 예정이다. 그 때는 기본적인 내용은 생략하고 새롭게 추가되는 속성 위주로 소개할 예정이기 때문에 앞에 연재한 아티클에 대해서 반드시 한번 실습해보고 같이 진행하는 것이 좋을 것 같다. Sencha Touch는 웹 앱을 개발하는데 충분하지만 터치 기반의 모바일 앱을 개발하는데 최적화가 되어 있다. 앞으로 Sencha에 대한 내용은 대부분 Appspresso (앱스프레소)를 활용하여 개발하는 내용에 대해서 소개할 것이다. 하지만 개발 방법론과 접근 방법은 Appspresso와 독립적이며 지금까지 소개한 내용과 크게 다르지 않기 때문에 앞으로 이와 같은 방법을 이용해서 개발하는데 문제없이 진행될 것이라 예상된다.

## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.app.Controller
2. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-1/

