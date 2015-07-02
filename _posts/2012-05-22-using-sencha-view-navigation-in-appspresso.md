---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 16.Sencha 뷰 네비게이션
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha]
comments: true
redirect_from: /147/
disqus_identifier : http://blog.saltfactory.net/147
---

## 서론

iOS 앱을 만들때 개발자에게 즐거움을 주는 이유는 이미 로직, 뷰, 컨트롤러 모두 모듈화하여 두었고, 복잡한 에니메이션과 같은 기능을 구현해 두었기 때문이다. 안드로이드 개발자역시 안드로이드의 widget이 이미 기본적으로 구현되어 있기 때문에 하드코딩을 하지 않고 새로운 인텐트를 추가하고 다른 엑티비티로 이동하거나 돌아올 수 있기 때문에 간단하게 네비게이션을 구현할 수 있다. 그런데 만약 이러한 에니메이션, 로직, 컨트롤러가 없다면 개발자들은 개발하는데 많이 힘들었을 것 같다.

Appspresso (앱스프레소)에서는 기본적으로 UI 프레임워크를 지원하고 있지 않다. 이젠 앱스프레소가 하이브리드 개발 프레임워크라는 것을 모두 인지하고 있을 것이라 생각한다. 앱스프레소에서는 자체 UI 프레임워크를 지원하고 있지 않지만 HTML, CSS, Javascript(또는 HTML5) 기반의 UI 프레임워크를 가져와서 UI 프레임워크로 사용하면 된다는 것을 [Appspresso를 사용하여 하이브리드앱 개발하기 - 10.Sencha 뷰 추가하기](http://blog.saltfactory.net/141) 글에서 우리는 알아보았다. 현재 존재하는 많은 자바스크립트 UI 프레임워크에서 우리는 Sencha Touch 2를 가지고 UI를 구성하고 있다. 물론 다른 자바스크립트 UI도 훌륭하지만 Sencha의 네이티브 앱과 동일한 UI 지원과 MVC 개발패턴을 사용할 수 있다는 강점을 이용하기 위해서 도입하기로 했다. 우리는 이제 Sencha로 네이티브 앱에서 동작하는 뷰 컨트롤러와 뷰 컨트롤러의 이동을 구현하는 방법에 대해서 알아 보기로 할 것이다. 네이티브 앱에서는 ViewController를 이동하거나 Intent를 만들어서 Activity를 이동한다거나 하는 명칭을 사용하지만 제목에 Sencha는 View 이동이라고 하였다. 이유는 Sencha 의 구성이 ViewController에 view 와 controller가 포함되는 것이 아니라, View의 구성과 Conroller의 구성이 나누어져 있기 때문이다.

Sencha의 컴포넌트로 View를 구성하는 방법은 [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 3. 뷰(View) 구성 - 컴포넌트 생성,구성](http://blog.saltfactory.net/142), [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 4. 뷰(View) 구성 - Navigation Components](http://blog.saltfactory.net/143) 글과 [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 5. 뷰(View) 구성 - Store-bound components (리스트 뷰)](http://blog.saltfactory.net/144) 를 먼저 살펴보고 이해하길 바란다.

<!--more-->

## Nested ListView

아마 이 블로그에 올라오는 Appspresso아 Sencha 튜토리얼을 빠짐없이 구독하고 있다면 Nested ListView 까지 테스트가 진행되었을 것이다. 그렇다 우리가 iOS에서 cell를 선택해서 다른 ViewController를 만들어서 뷰가 네비게이션하는 것을 Nested ListView에서 표현하고 있었던 것이다. Sencha Tutorial에 사용한 코드를 약간 수정했다. 다음을 MainView.js라는 이름으로 저장해보자.

```javascript
/**
 * file : MainView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactoryHybridTutorial.view.MainView', {
	extend: 'Ext.Panel',
	alias: 'main_view',
	config: {
	    styleHtmlContent: true,
		fullscreen: true,
		layout:{
			type: 'card',
			align: 'start',
			pack: 'start'
		}
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
					console.log('tap compose button');
				}
			}
			]
		};

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
		};

		var data = {
		     text: 'Groceries',
		     items: [{
		         text: 'Drinks',
		         items: [{
		             text: 'Water',
		             items: [{
		                 text: 'Sparkling',
		                 leaf: true
		             }, {
		                 text: 'Still',
		                 leaf: true
		             }]
		         }, {
		             text: 'Coffee',
		             leaf: true
		         }]
		     }, {
		         text: 'Fruit',
		         items: [{
		             text: 'Bananas',
		             leaf: true
		         }, {
		             text: 'Lemon',
		             leaf: true
		         }]
		     }, {
		         text: 'Snacks',
		         items: [{
		             text: 'Nuts',
		             leaf: true
		         }, {
		             text: 'Pretzels',
		             leaf: true
		         }, {
		             text: 'Wasabi Peas',
		             leaf: true
		         }]
		     }]
		 };

		 Ext.define('ListItem', {
		     extend: 'Ext.data.Model',
		     config: {
		         fields: [{
		             name: 'text',
		             type: 'string'
		         }]
		     }
		 });

		 var store = Ext.create('Ext.data.TreeStore', {
		     model: 'ListItem',
		     defaultRootProperty: 'items',
		     root: data
		 });

		 var nestedlist = Ext.create('Ext.NestedList', {
		     fullscreen: true,
		     title: 'Home',
		     displayField: 'text',
		     store: store,
		     toolbar:titlebar
		 });

		this.add([nestedlist, toolbar]);
	}
});
```

그리고 Appspresso에서 하이브리드 앱을 시작시킬 app.js를 다음과 같이 작성하고 저장하자. (앞으로는 js 파일의 위치를 언급하지 않을 경우는 [Appspresso를 사용하여 하이브리드앱 개발하기 - 10.Sencha 뷰 추가하기](http://blog.saltfactory.net/141) 에서 사용한 경로를 사용함을 기억해두길 바란다.)

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */


Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',
	views : ['MainView'],
	launch : function() {
		Ext.create('main_view');
	}
});
```

index.html은 다음과 같이 저장한다. 그리고 Appspresso에서 빌드를 하고 simulator로 실행하면 다음과 같이 멋진 리스트뷰가 만들어지고 Cell을 선택하면 다음 뷰로 넘어가게 되는 것을 확인할 수 있다.

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

![](http://cfile27.uf.tistory.com/image/1105D8334FBA23E132AEE1)

![](http://cfile2.uf.tistory.com/image/160BBE334FBA23EA1C6041)

![](http://cfile1.uf.tistory.com/image/2057203D4FBA23F4028E05)

이것은 나중에 Model과 Store에 대해서 한번 더 자세히 설명하겠지만, 데이터의 저장된 형태를 Nested로 하여 그 데이터의 형태대로 리스트 뷰를 차례로 만들어주는 Sencha의 고급 컴포넌트 중에 하나이다. 그럼 이러한 리스트 말고 일반 뷰 (Panel)은 어떻게 하면 다음 뷰로 이동이 가능할까? 데이터의 저장 구조도 없고 단순하게 뷰를 이동시키는 것인데 말이다.
그래서 Sencha에서는 NavigationView 컴포넌트를 만들어 두었다.

## NavigationView

Ext.NavigationView는 기본적으로 Ext.Container와 Card 레이아웃으로 구성이 되어 있다. Sencha Layout에 대해서는 Sencha 튜토리얼에서 설명하겠지만 Card 레이아웃은 말 그대로 카드를 섞듯 여러장의 뷰를 두고 이동할 수 있게 되어 있다. 그럼 어떻게 동작하는지 다음 코드를 한번 살펴보자. app.js를 다음과 같이 수정한다. ( 다음 코드는 Sencha Touch 2 의 Ext.Navigation.View의 공식 문서의 예제이다. )

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',
	launch : function() {
		var view = Ext.create('Ext.NavigationView', {
		    fullscreen: true,

		    items: [{
		        title: 'First',
		        items: [{
		            xtype: 'button',
		            text: 'Push a new view!',
		            handler: function() {
		                view.push({
		                    title: 'Second',
		                    html: 'Second view!'
		                });
		            }
		        }]
		    }]
		});
	}
});
```

on the fly로 새로 고침을 해서 살펴보면 위에서 봤던 Nested ListView와 동일하게 새로운 뷰가 push되어서 들어가는 것을 확인할 수 있다. 그리고 back 버턴을 누르면 자동으로 첫 뷰로 되돌아 오는 것을 확인할 수 있다.

![](http://cfile23.uf.tistory.com/image/124A55454FBA267A0DCDA8)

![](http://cfile22.uf.tistory.com/image/142BBE364FBA268415F3D3)

공식 메뉴얼에 있는 코드를 이해를 돕기 위해서 다음과 같이 수정을 해보자.
우선 두번째 뷰 SecondView.js를 다음 내용으로 저장을 한다.

```javascript
/**
 * file : SecondView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.define('SaltfactoryHybridTutorial.view.SecondView',{
	extend : 'Ext.Panel',
	alias : 'second_view',

	config: {
		fullscreen: true,
		html: 'second view'
	}

});
```

그리고 MainView.js를 다음과 같이 수정하자

```javascript
/**
 * file : MainView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactoryHybridTutorial.view.MainView', {
	extend : 'Ext.NavigationView',
	alias : 'main_view',

	config : {
		fullscreen : true
	}
});
```

마지막으로 app.js를 다음과 같이 수정한다.

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',
	views : ['MainView', 'SecondView'],
	launch : function() {
		var view = Ext.create('main_view', {
			items: [{
		        title: 'First',
		        items: [{
		            xtype: 'button',
		            text: 'Push a new view!',
		            handler: function() {
		            	var secondView = Ext.create('second_view');
		            	view.push(secondView);
		            }
		        }]
		    }]
		});

		Ext.Viewport.add([view]);
	}

});
```

위의 코드들은 네비게이션을 담당하는 뷰와 이벤트가 일어날때 새로 뷰를 생성해서 사용할 수 있도록 second view를 따로 만들어서 불러 사용하는 방법이다. 동작 결과는 위와 동일하다.

위 두가지 방법은 확실히 뷰 네비게이션이 맞다. 하지만 살펴보면 뷰 네비게션을 네비게이션바 (Sencha에서는 Toolbar나 Titlebar)에서 이벤트가 일어나지 않는다는 것을 확인할 수 있다.  Nested ListView나 NavigationView는 두번째 뷰로 네비게이션되면 자동으로 Back 버턴을 만들어주는데 오른쪽 상단에 만약에 버턴이 있다면 어떻게 할 것인지 고민하기 시작했다. 실제 UINavigationController에 UINavigationBar 에 UIBarButtonItem을 추가하는 것은 iOS에서 상당히 간단히 구현된다. 그리고 iOS가 너무나 유연하게 잘 설계되어져 있어서 각 뷰가 보여지는 곳에서 그에 해당되는 버턴을 올려둘수 있게 설계되어져 있다. 예를 들어서 FirstViewController.m 에서 상단에 compose 버턴을 추가하게 되면 다음과 같이하면된다.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"First";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
}

```

그리고 -pushViewController:animated: 가 일어난고 나타나는 SecondViewController.m에서는 이전과 독립적인 self.navigationItem을 가지고 동작할 수 있게 된다. 하지만 Sencha는 그런 원리가 아니기 때문에 Toolbar에 버턴을 추가하면서 view를 Navigation 하기가 쉽지가 않다. 예를 들어서 Xcode에서 작성한 위의 코드를 Sencha에서 작성한다고 가정해보자. NavigationView의 navigationBar에 오른쪽 버턴을 추가하기 위해서는 디폴트 navigationBar를 titlebar나 toolbar로 변경하면 된다.

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',
	views : ['MainView', 'SecondView'],
	launch : function() {
		var view = Ext.create('main_view', {
			navigationBar:{
				items:[{
					xtype:'button',
					iconCls:'compose',
					iconMask:true,
					align:'right'
				}]
			},
			items: [{
		        title: 'First',
		        items: [{
		            xtype: 'button',
		            text: 'Push a new view!',
		            handler: function() {
		            	var secondView = Ext.create('second_view');
		            	view.push(secondView);
		            }
		        }]
		    }]
		});

		Ext.Viewport.add([view]);
	}
});
```

이렇게 새롭게 설정한 navigationBar는 새로운 view가 push가 되어도 계속 유지가 되어버리는 문제가 발생한다.

![](http://cfile3.uf.tistory.com/image/174572414FBA48D0204B6B)

![](http://cfile2.uf.tistory.com/image/13529E3D4FBA48DD1DD68B)

iOS 였다면 이 동작은 다음과 같이 나타난다. 이러한 이유는 Sencha는 View 를 추가하는 것이고 iOS에서 UINavigationController에 추가되는 것은 새로운 ViewController가 추가되기 때문에 약간 그 성격이 다른것이다.

![](http://cfile26.uf.tistory.com/image/1813B54E4FBA4A6720DB56)

![](http://cfile25.uf.tistory.com/image/2009D0334FBA4A760ECD02)

그래서 직접 네비게이션을 할 수 있는 코드를 작성해보기로 한다. 기본 로직은 간단하다 각각 Toolbar를 가진 First View와 Second View를 만들어서  버턴을 누를때 뷰를 전환하면서 마치 navigation controller가 동작하듯 slide animation으로 이동하게 하는 것이다.

먼저 FirstView.js를 /src/js/app/view/FirstView.js 다음코드로 작성하여 저장한다. 두번째 뷰가 왼쪽에서 나타나야하기 때문에 Ext.Viewport.animationActiveItem은 두번째 뷰가 왼쪽에서 slide로 나타나게 하는 것이다.

```javascript
/**
 * file : Firstview.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactoryHybridTutorial.view.FirstView', {
	extend : 'Ext.Panel',
	alias : 'first_view',

	config : {
		fullscreen : true,
		html : 'first view',
		items : [ {
			xtype : "toolbar",
			docked : "top",
			title : "First",
			items : [ {
				xtype : "spacer"
			        }, {
				xtype : "button",
				iconCls : "compose",
				iconMask : true,
				id : "composeButton",
				handler:function(){
					var secondView =  Ext.create('second_view');
                                        Ext.Viewport.add([secondView]);
					Ext.Viewport.animateActiveItem(secondView, {
						type : 'slide',
						direction : 'left'
					});
				}
			} ]
		} ]
	},

});
```

그리고 SecondView.js를 다음과 같이 수정한다. 두번째 뷰에서 back 버턴을 누르면 첫번째 뷰가 오른쪽에서 나타나야하기 때문에 slide를 right 방향으로 주었다.

```javascript
/**
 * file : SecondView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.define('SaltfactoryHybridTutorial.view.SecondView', {
	extend : 'Ext.Panel',
	alias : 'second_view',

	config : {
		fullscreen : true,
		html: 'second view',
		items : [ {
			xtype : "toolbar",
			docked : "top",
			title : "Second",
			items : [  {
				xtype : "button",
				text:"back",
				ui : "back",
				handler : function(){
					var firstView = Ext.create('first_view');
					Ext.Viewport.animateActiveItem(firstView, {
						type : 'slide',
						direction : 'right'
					});
				}
			},
			{
				xtype : "spacer"
			}]
		} ]
	}
});
```

이제 app.js 에 이 두가지 뷰를 등록한다.

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',

	views : [ 'FirstView', 'SecondView' ],

	launch : function() {
		var firstView = Ext.create('first_view');
		Ext.Viewport.add([ firstView]);
	}
});
```

우리가 UINavigationController의 stack에 뷰컨트롤러를 push 하듯 Ext.Viewport.add 로 뷰를 추가하고 Ext.Viewport.animationActiveItem으로 다른 뷰끼리 이동을하는 로직이다. 그런데 이 코드를 실행하면 WARN이 발생한다. 아래 경고는 Second View에서 Back 버턴을 클릭하면 동작하게 한 handler에서 발생하는 경고이다. 경고의 내용을 살펴보면 이미 composeButton 이라는 ID를 사용하고 있어서 발생하는 문제라는 것을 확인할 수 있다. Ext.Viewport에서는 firstView와 secondView 두가지를 보관하고 있다가 해당하는 뷰를 보여주는 방법인데 다시 컴포넌트를 추가하려고 보니까 이미 생성한 ID 가 있어서 발생하는 문제이다. 해결방법은 이미 만들어진 뷰를 다시 생성하지 않고 재활용하면 되는 것이다. 실제  UINavigationController로 스택에 viewController를 push 하였다가 다시 pop 하는 방법을 사용한다.

![](http://cfile24.uf.tistory.com/image/117E13354FBA510924AD29)

코드른 다음과 같이 고쳐보자. 처음 앱이 동작할때 Ext.Viewport에 두 가지 뷰를 담아둔다.

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.application({
	name : 'SaltfactoryHybridTutorial',
	appFolder : '/js/app',

	views : [ 'FirstView', 'SecondView' ],

	launch : function() {
		var firstView = Ext.create('first_view');
		var secondView = Ext.create('second_view');
		Ext.Viewport.add([ firstView, secondView]);
	}
});
```

그리고 첫번째 뷰에서 두번째 뷰를 꺼집어내어서 뷰를 전환한다.

```javascript
/**
 * file : Firstview.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactoryHybridTutorial.view.FirstView', {
	extend : 'Ext.Panel',
	alias : 'first_view',

	config : {
		fullscreen : true,
		html : 'first view',
		items : [ {
			xtype : "toolbar",
			docked : "top",
			title : "First",
			items : [ {
				xtype : "spacer"
			}, {
				xtype : "button",
				iconCls : "compose",
				iconMask : true,
				id : "composeButton",
				handler:function(){
					var secondView = Ext.Viewport.items.get(1);
					Ext.Viewport.animateActiveItem(secondView, {
						type : 'slide',
						direction : 'left'
					});
				}
			} ]
		} ]
	},

});
```

두번째 뷰에서 다시 첫번째 뷰로 이동할 때는 Viewport의 첫번째에 저장된 뷰를 꺼내어서 전환하도록 한다.

```javascript
/**
 * file : SecondView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.define('SaltfactoryHybridTutorial.view.SecondView', {
	extend : 'Ext.Panel',
	alias : 'second_view',

	config : {
		fullscreen : true,
		html: 'second view',
		items : [ {
			xtype : "toolbar",
			docked : "top",
			title : "Second",
			items : [  {
				xtype : "button",
				text:"back",
				ui : "back",
				handler : function(){
					var firstView = Ext.Viewport.items.get(0);
					Ext.Viewport.animateActiveItem(firstView, {
						type : 'slide',
						direction : 'right'
					});
				}
			},
			{
				xtype : "spacer"
			}]
		} ]
	}
});
```

이렇게 두가지 뷰를 NavigationController 를 이용하여 Ext.Viewport에 담긴 뷰 간에 전환을 마치 UINavigationController에서 push와 pop을 하는 효과를 가져올 수 있게 구현할 수 있게 되었다.

![](http://cfile29.uf.tistory.com/image/166BC3454FBA533B1E3628)

![](http://cfile24.uf.tistory.com/image/172F6B464FBA53490B2A76)

두가지 뷰를 네비게이션하는 문제는 해결했지만 좀더 UINavgationController 처럼 컨트롤러 하나가 뷰의 동작을 담당하도록 하고 싶은 마음이 생긴다. 우리가 Sencha를 사용하는 궁긍적 목적인 MVC를 패턴을 사용하고 싶기 때문이다. 그래서 우리는 NavigationController를 하나 추가한다. (Sencha 튜토리얼에서 Sencha의 Controller에서 좀더 자세히 다루겠다. 지금은 Controller가 특정 Element에 이벤트를 등록하고 등록된 이벤트가 일어나면  처리할 수 있는 handler를 이용해서 명령어를 처리하거나 전달하는 객체라로 생각하자.)

/src/js/app/controller/NavigationController.js를 다음 내용으로 추가한다. 위에서 각각의 뷰에서 Viewport에서 뷰를 꺼집어 내어서 뷰를 전환하는 명령을 컨트롤러에 모두 모아서 등록했다. 그리고 refs 참조자를 이용해서 id가 composeButton 인 것과 backButton인 것을 각각 참조하는데 tap 행위가 일어나면 onComposeButton과 onBackButton 이벤트처리(handler) 메소드를 호출하게 게 control 로 정의하였다.

```javascript
/**
 * file : NavigationController.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define("SaltfactoryHybridTutorial.controller.NavigationController", {
	extend : "Ext.app.Controller",

	config : {
		refs : {
			composeButton : '#composeButton',
			backButton : "#backButton"
		},
		control : {
			composeButton : {
				tap : 'onComposeButton'
			},
			backButton : {
				tap : 'onBackButton'
			}
		}
	},

	onBackButton: function(){
		console.log('onBackButton');

		var firstView = Ext.Viewport.items.get(0);
		Ext.Viewport.animateActiveItem(firstView, {
			type : 'slide',
			direction : 'right'
		});

	},

	onComposeButton : function() {
		console.log('onComposeButton');

		var secondView = Ext.Viewport.items.get(1);
		Ext.Viewport.animateActiveItem(secondView, {
			type : 'slide',
			direction : 'left'
		});
	},

	launch : function() {
		this.callParent();
		console.log("launch");
	},
	init : function() {
		this.callParent();
		console.log("init");
	}
});
```

다음은 FirstView.js를 다음과 같이 수정한다. 이벤트 핸들러 부분을 컨트롤러에게 모두 위임했기 때문에 이벤트 처리를 할 필요가 없다.

```javascript
/**
 * file : Firstview.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactoryHybridTutorial.view.FirstView', {
	extend : 'Ext.Panel',
	alias : 'first_view',

	config : {
		fullscreen : true,
		html : 'first view',
		items : [ {
			xtype : 'toolbar',
			docked : 'top',
			title : 'First',
			items : [ {
				xtype : 'spacer'
			}, {
				xtype : 'button',
				iconCls : 'compose',
				iconMask : true,
				id : 'composeButton',
			} ]
		} ]
	}
});
```

다음은 SecondView.js를 수정한다.

```javascript
/**
 * file : SecondView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */
Ext.define('SaltfactoryHybridTutorial.view.SecondView', {
	extend : 'Ext.Panel',
	alias : 'second_view',

	config : {
		fullscreen : true,
		html: 'second view',
		items : [ {
			xtype : 'toolbar',
			docked : 'top',
			title : 'Second',
			items : [  {
				xtype : 'button',
				text:'back',
				ui : 'back',
				id : 'backButton',
			},
			{
				xtype : 'spacer'
			}]
		} ]
	}
});
```

## 결론

코드가 좀더 간결해지고 이벤트 처리하는 부분을 모두 Controller에게 맡길 수 있게 코드가 변경되었다.

네이티브로 앱을 만들던지 하이브리드로 앱을 만들던지 뷰의 네비게이션은 가장 기본적으로 필요한 UI 구성이다. iOS SDK에서는 기본적으로 제공하는 UINavigationController 나 Android의 startActivity(Intent intent)와 같은 것을 Sencha에서는 기본적으로 Ext.dataview.NestedList와 Ext.NavgationView로 구성할 수 있지만 Sencha는 iOS나 Android와 달리 컨트롤러가 포함한 뷰 컨트롤러나 엑티비티를 추가하는 것이 아니라 뷰의 구성만 추가하게 된다. 이를 좀더 구조적으로 핸들링하기 위해서 컨트롤러를 추가하여 핸들링하는 방법까지 살펴보았다. Sencha의 컨트롤러는 특정 엘리먼트의 이벤트를 등록하고 그 이벤트가 처리하는 컨트롤 메소드를 정의해둔 객체라고 간략하게 살펴보았는데 Sencha 튜토리얼에서 좀더 자세히 다루도록 하겠다. Sencha는 MVC를 지원하는 프레임워크로 디렉토리구조도 app/view, app/controller, app/model과 같이 모듈 구성으로 분리해서 저장하면 app.js 에서 모듈을 views:, controllers:, models: 로 등록할 수 있다. 위의 예제 코드는 잘 짜여진 코드가 아닐 수 있다. 뷰 네비게이션 설명을 위해서 두개의 뷰를 만들어서 Viewport에 넣어두고 가져오는 방식으로 구현했지만, 이렇게 하면 두번째 뷰를 사용하지 않아도 메모리를 점유하게 된다. 보통 iOS에 뷰 컨트롤러를 추가하여 네비게이션 컨트롤러에 추가할 때는 사용할 경우에만 생성해서 추가하고 사용하지 않을 때는 release 시키는 것 처럼 위의 코드를 좀더 자신의 응용 프로그램에 맞게 최적화 시켜서 사용하길 권유한다.

이 포스트는 Appspresso(앱스프레소)로 하이브리드 앱을 만들 때 뷰의 구성을 위한 설명중에 새로운 뷰 간의 네비게이션을 주제로 한 내용이다. 앱스프레소는 훌륭한 하이브리드 앱 개발 툴이고 비록 UI 개발 툴킷이 포함되어 있지 않지만 third-party UI 프레임워크를 가지고 개발하는 것을 충분히 지원하고 있기 때문에 Sencha 나 다른 jQuery Mobile 등을 이용해서 뷰를 구성할 수 있다. 실제 디바이스에 빌드해서 사용해보면 Appspresso의 문제가 아니라 UI가 HTML5 기반으로 구성되기 때문에 어떤 UI 프레임워크를 도입해서 사용하는지, 어떻게하면 UI 프로그램을 최적화시켜서 사용해야지에 대해서 앱의 성능이 좌우된다. 이러한 이유로 UI 프레임워크에 대한 충분 이해와 연습 또한 하이브리드 앱을 개발하는 가장 중요한 테크닉중에 하나인 것을 명심해야 할 것 같다.

## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.dataview.NestedList
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.navigation.View
3. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-1/
4. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-2/
5. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-3/
6. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-4/
7. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-5/


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
