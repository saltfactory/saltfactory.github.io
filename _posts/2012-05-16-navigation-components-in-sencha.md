---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 4.Navigation Components
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, component, navigation]
comments: true
redirect_from: /143/
disqus_identifier : http://blog.saltfactory.net/143
---

## 서론

Sencha Touch를  사용하면 웹 프로그래밍으로 네이티브 UI와 동일하게 만들 수 있다는 것을 장점으로 말할 수 있겠다. 사용자에게 익숙한 UI를 개발자가 직접 만들지 않고 이렇게 템플릿으로 제공해주기 때문에 UI 개발 시간을 많이 줄일 수 있기 때문이다. 이번 포스팅에는 그런 네이티브의 UI를 어떻게 Sencha에서 사용할 수 있는지 차례대로 살펴보기로 하자. 뷰를 구성하기 위해서는 Ext.Component를 사용하는데 컴포넌트를 생성하고 추가하는 방법에 대해서는 [Sencah Touch2를 이용한 하이브리드 앱 개발 - 2.View 생성](http://blog.saltfactory.net/142) 글을 참조하기 바란다. 이 포스팅에서는 센차에서 컴포넌트를 생성하는 것을 모두 이해했다는 과정에서 진행하겠다.

Sencha Touch의 뷰 구성은 Ext.Component 를 상속받은 여러 컴포넌트를 가지고 뷰를 구성할 수 있다. 이번 포스팅에서는 Ext.Component 를 상속받은 컴포넌트 그룹중에서도 Navigation Components에 대해서 알아보기로 한다.

<!--more-->

## Toolbar

http://blog.saltfactory.net/142 글에서 우리는 Toolbar와 그 안에 들어가는 Button 들을 구성하는 방법에 대해서 알아 보았다. 코드는 다음과 같다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var leftTopButton = {
			xtype: 'button',
			text: 'Back',
			ui: 'back'
		}

		var rightTopButton = {
			xtype: 'button',
			text: 'New',
			ui: 'action'
		}

		var spacer = {
			xtype: 'spacer'
		}

		var toolbar = {
			xtype : 'toolbar',
			title: 'Home',
			docked: 'top',
			items: [leftTopButton, spacer, rightTopButton]
		}

		this.add([toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/fcf37d26-8343-419d-85b5-b7d360133b2b)

하지만 보통 툴바는 상단에 위치하는 것이 아니고 하단에 위치하도록 하여 만든다. 그리고 Toolbar에는 info 버턴만 나타나게 해보자.
그래서 우리는 다음과 같이 Toolbar를 하단에 위치하도록 해보자.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/bf263466-b009-4043-8314-c0d764baab4d)

## Button

앞에서는 언급하지 않았던 iconCls라는 것이 나온다. 이것은 Sencha에서 이미 아이콘에 관한 것을 CSS class로 정의해 두었는데 다음과 같은 iconCls가 정의되어 있다.

* action
* add
* arrow_up
* arrow_right
* arrow_down
* arrow_left
* bookmarks
* compose
* delete
* download
* favorites
* info
* more
* refresh
* reply
* search
* settings
* star
* team
* time
* trash
* user

위의 버턴에 관련된 iconCls를 모두 출력해보자. iconMask는 iconCls가 적용되어서 text가 아닌 아이콘이 나타나게하려고 mask를 적용한 것이다.


```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				iconCls: 'compose',
				iconMask: true,
				align: 'right'
			}
			]
		}

		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar,
		    {
		   		xtype: 'button',
		   		iconCls: 'action',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'add',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'arrow_up',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'arrow_right',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'arrow_down',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'arrow_left',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'bookmarks',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'compose',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'delete',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'download',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'favorates',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'info',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'more',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'refresh',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'reply',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'search',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'settings',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'start',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'team',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'time',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'time',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'trash',
		   		iconMask: true,
				margin: '5'
		   	},
		    {
		   		xtype: 'button',
		   		iconCls: 'user',
		   		iconMask: true,
				margin: '5'
		   	},
			 toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/138175cc-7f11-4c3f-bb6e-71edfea680ff)

## Titlebar (with Button)

이제 Titlebar를 구현해보도록 하자. title을 입력하고, 글을 작성할 수 있는 Compose 버턴을 추가해보자.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				iconCls: 'compose',
				iconMask: true,
				align: 'right'
			}
			]
		}
		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar, toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/b85100d9-b0f5-4640-a7e8-399f11f56e0e)

## SegmentedButton

아이폰에서는 UISegmentedControl 이라고 불리는 세그멘트 메뉴를 구성해서 추가해보자. Sencha에서는 이와 동일한 UI를 SegmentedButton이라고 말하고 있다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				iconCls: 'compose',
				iconMask: true,
				align: 'right'
			}
			]
		}

		var segmentedbutton = {
			xtype: 'segmentedbutton',
			allowMultiple: false,
			allowDepress: false,
			docked: 'top',
			activeItem: 0,

			items:[
			{
				text: 'Option1',
				pressed: true
			},
			{
				text: 'Option2',
			},
			{
				text: 'Option3',
			},
			{
				text: 'Option4',
			}
			]
		}


		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar, segmentedbutton, toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/4379e34d-691f-4835-9510-ae79daeb2745)

SegmentedButton이 추가되었지만 우리가 원하는대로 출력은 되지 않았다. 우리는 이 세그먼트버턴이 중앙에 위치하면서 가로가 화면에 가득차게 나타나길 원하고 있기 때문이다. 그래서 다음과 같이 수정한다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				iconCls: 'compose',
				iconMask: true,
				align: 'right'
			}
			]
		}

		var segmentedbutton = {
			xtype: 'segmentedbutton',
			allowMultiple: false,
			allowDepress: false,
			docked: 'top',
			activeItem: 0,
			centered: true,

			layout: {
				type: 'hbox',
				pack: 'center',
				align: 'stretchmax'
			},

			items:[
			{
				text: 'Option1',
				pressed: true,
				width: '25%'
			},
			{
				text: 'Option2',
				width: '25%'

			},
			{
				text: 'Option3',
				width: '25%'

			},
			{
				text: 'Option4',
				width: '25%'

			}
			]
		}


		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar, segmentedbutton, toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/b915ab4b-0d09-4807-b264-824072deecc0)

## 이벤트 추가하기

우리는 Ext.Toolbar와 Ext.Titlebar 컴포넌트를 추가하였고 그 안에 Ext.Button 을 추가하였다. 마지막으로 Ext.SegmentedButton 컴포넌트를 추가하였는데, 마지막으로 버턴에 이벤트를 추가하는 방법을 알아보자.
Toolbar 에 있는 compose 버턴을 눌렀을때 console로 로그를 출력해보기 위해서 다음과 같이 코드를 수정한다. compose 버턴을 정의하는 속성에 handler 속성을 추가하고 console.log를 할 수 있는 메소드를 구현해서 추가한다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				xtype: 'button',
				iconCls: 'compose',
				iconMask: true,
				align: 'right',
				handler:function(){
					console.log('tap compose button')
				}
			}
			]
		}

		var segmentedbutton = {
			xtype: 'segmentedbutton',
			allowMultiple: false,
			allowDepress: false,
			docked: 'top',
			activeItem: 0,
			centered: true,

			layout: {
				type: 'hbox',
				pack: 'center',
				align: 'stretchmax'
			},

			items:[
			{
				text: 'Option1',
				pressed: true,
				width: '25%'
			},
			{
				text: 'Option2',
				width: '25%'

			},
			{
				text: 'Option3',
				width: '25%'

			},
			{
				text: 'Option4',
				width: '25%'

			}
			]
		}


		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar, segmentedbutton, toolbar])
	}
});
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/ce43ea47-c506-4a6d-b076-000247e49d80)

다음은 SegmentedButton에 이벤트를 처리할 코드를 등록할 것인데, 단순한 Button과 달리 SegmentedButton은 여러가지 버턴들의 조합으로 이루어져있다. SegmentedButton에 이벤트를 감지하기 위해서 listeners를 등록할 수 있다. 다음 코드를 살펴보자.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',

	config: {
	    styleHtmlContent: true,
		html: '<h1>Hello, World!</h1>',
		fullscreen: true,
	},

	initialize: function(){
		var titlebar = {
			xtype: 'titlebar',
			docked: 'top',
			title: 'Home',
			items: [
			{
				xtype: 'button',
				iconCls: 'compose',
				iconMask: true,
				align: 'right',
				handler:function(){
					console.log('tap compose button')
				}
			}
			]
		}

		var segmentedbutton = {
			xtype: 'segmentedbutton',
			allowMultiple: false,
			allowDepress: false,
			docked: 'top',
			activeItem: 0,
			centered: true,

			layout: {
				type: 'hbox',
				pack: 'center',
				align: 'stretchmax'
			},

			items:[
			{
				text: 'Option1',
				pressed: true,
				width: '25%'
			},
			{
				text: 'Option2',
				width: '25%'

			},
			{
				text: 'Option3',
				width: '25%'

			},
			{
				text: 'Option4',
				width: '25%'

			}
			],
			listeners: {
				toggle: function(container, button, pressed){
					console.log("User toggled the '" + button.config.text + "' button: " + (pressed ? 'on' : 'off'));
				}
			}

		}


		var toolbar = {
			xtype : 'toolbar',
			docked: 'bottom',
			items: [
			{
				xtype: 'spacer'
			},
			{
				xtype: 'button',
				iconCls: 'info',
				iconMask: true
			}
			]
		}

		this.add([titlebar, segmentedbutton, toolbar])
	}
});
```

리스너를 등록하는데 버턴이 눌러졌을 때의 버턴의 activity를 출력할 수 있도록 toggle 속성에 메소드를 추가하였다. index.html 을 새로 고침하여 SegmentedButton 을 순서대로 출력하면 다음과 같이 console.log를 출력하는 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/faaa25a2-1e78-419d-b30e-518d4d379dde)

## 결론

이번 포스트는 Ext.Component를 상속받은 뷰를 구성하는 컴포넌트 중에서도 Navigation Components에 대해서 알아보았다. 뿐만 아니라, 버턴에 이벤트를 처리하는 메소드를 등록하는 방법에 대해서도 살펴보았다. 버턴과 같은 단순한 이벤트에 handler 속성에 이벤트를 처리하는 메소드를 구현해서 등록할 수 있었고, 또는 listeners를 이용해서 세그먼트버턴에 이벤트를 처리하는 기능을 등록할 수 있었다. 이벤트를 관장하는 부분은 간단히 소개했는데, 이유는 나중에 Sencha의 MVC 개발 방법 중에 Controller로 뷰의 이벤트를 담당할 수 있게 처리할 수 있는 부분이 나오는데 그 때 좀더 자세히 설명하기 위해서이다. 이 포스트에서는 뷰를 구성하는 Ext.Component를 구성하는 방법에 대해서 소개하는 것이 주제이기 때문에 이벤트 처리에 대해서는 간단히 소개만하고 넘어간다.


## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.Toolbar
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.TitleBar
3. http://docs.sencha.com/touch/2-0/#!/api/Ext.Button
4. http://docs.sencha.com/touch/2-0/#!/api/Ext.SegmentedButton


