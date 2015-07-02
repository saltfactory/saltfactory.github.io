---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 7.General Components
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, component, general, tabbar, image, message, action]
comments: true
redirect_from: /149/
disqus_identifier : http://blog.saltfactory.net/149
---

## 서론

Sencha는 다양한 컴포넌트를 미리 제공하기 때문에 모바일 앱을 웹으로 만들어도 어색하지 않다는 것을 우리는 이전 포스팅의 예제를 직접 테스트하면서 알게되었다. 뷰를 구성하는 Ext.Container를 상속받은 컴포넌트들을 조합하면 UI를 효율적으로 개발할 수 있다는 것도 알게 되었다. 이 포스팅은 Sencha Touch 2의 뷰를 구성하는 포스팅의 마지막으로 General Components에 대해서 살펴볼 것이다.

우리는 Sencha Touch의 중요한 component를 대부분 실습해보았는데, 몇가지 정말 중요한 컴포넌트를 살펴보지 않았다. 그 중에서 하나가 바로 탭 기능을 하는 것이다. iOS에서는 TabBarController이고 Android에서는 TabHost라고 불려지는 것은 여러개의 ViewController나 Activity를 탭을 누를 때마다 변환하면서 선택한 것을 보여주는 기능을 하는 것인데, Sencha에서는 이러한 기능을 Ext.tab.Panel을 이용해서 구현할 수 있다.

<!--more-->

## Tab Panel

보통 Tab 이라는 기능을 가지는 UI는 서로 다른 뷰를 번갈아 보이게 하면서 뷰를 활성화시키는 역활을 한다. Sencha에서도 동일한 방법을 사용하는데 다음과 같이 app.js를 변경하여 실행시켜보자.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.TabPanel', {
		    fullscreen: true,
		    tabBarPosition: 'bottom',

		    defaults: {
		        styleHtmlContent: true
		    },

		    items: [
		        {
		            title: 'Home',
		            iconCls: 'home',
		            html: 'Home Screen'
		        },
		        {
		            title: 'Contact',
		            iconCls: 'user',
		            html: 'Contact Screen'
		        }
		    ]
		});
	}
});
```

위의 코드는 아래 그림과 같이 두가지 탭 아티템을 가지고있는 탭 메뉴를 생성할 수 있다.

![](http://cfile29.uf.tistory.com/image/1633BC3F4FBB4CE607581B)

![](http://cfile7.uf.tistory.com/image/193177344FBB4CF134E49A)

만약에 Android의 TabHost와 같이 탭 메뉴가 상단에 위치하고 싶을 경우는 tabBarPosition을 top으로 변경하면 된다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
    launch: function() {
		Ext.create('Ext.TabPanel', {
		    fullscreen: true,
		    tabBarPosition: 'top',

		    defaults: {
		        styleHtmlContent: true
		    },

		    items: [
		        {
		            title: 'Home',
		            iconCls: 'home',
		            html: 'Home Screen'
		        },
		        {
		            title: 'Contact',
		            iconCls: 'user',
		            html: 'Contact Screen'
		        }
		    ]
		});
	}
});
```

tabBarPosition이 변경됨으로 탭 메뉴의 형태도 달라진다.

![](http://cfile1.uf.tistory.com/image/157F133B4FBB4EA017D2AB)

![](http://cfile29.uf.tistory.com/image/16475A374FBB4EC12570D5)

Sencha Touch를 이용하면 이렇게 간단하게 탭 메뉴를 구성할 수 있다.
우리는 [Sencah Touch2를 이용한 하이브리드 앱 개발 - 2.View 생성](http://blog.saltfactory.net/140) 글에서 view를 구성하는 파일을 /app/view/ 밑에 구성한다는 것을 살펴보았다. 우리는 여러개의 뷰를 만들어서 Tab을 이용해서 서로 다른 뷰 사이를 전환해보도록 하겠다.

FirstView.js와 SecondView.js를 각각 /app/view/ 디렉토리 밑에 아래와 같이 저장하여 생성한다. 간단하게 tab에 나타날 아이콘과 타이틀 설정과 뷰 자체의 타이틀바의 타이틀을 지정하였다.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		items: [{xtype:'titlebar', title:'first'}],
		html: '<h1>first view</h1>'
	}
});
```

```javascript
/**
* file : SecondView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.SecondView', {
	extend: 'Ext.Container',
	alias: 'second_view',

	config: {
		iconCls: 'user',
		title: 'second',
		items: [{xtype:'titlebar', title:'second'}],
		html: '<h1>Second View</h1>'
	}
});
```

다음은 app.js를 수정해보자. 위에 추가한 FirstView와 SecondView를 Ext.application에 views로 등록을 하고, 두가지 뷰를 생성하여 TabPanel의 items로 등록한다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.application({
    name: 'SaltfactorySenchaTutorial',
    views:['FirstView', 'SecondView'],
    launch: function() {

		var firstView = Ext.create('first_view');
		var secondView = Ext.create('second_view');

		var tab = Ext.create('Ext.TabPanel', {
		    fullscreen: true,
		    tabBarPosition: 'bottom',
		    defaults: {
		        styleHtmlContent: true
		    },
			items: [firstView, secondView]
		});

	}
});
```

위의 코드는 다음과 같이 수정할 수도 있다. 우리는 Ext 컴포넌트를 생성할때 Ext.create 대신에 xtype으로 컴포넌트를 렌더링하는 할 수 있다는 것을 앞에서 같이 살펴본적이 있다.  xtype과 마찬가지로 xclass는 해당되는 이름을 찾아서 렌더링하여 컴포넌트를 사용할 수 있게 해주는 것이다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	views:['FirstView', 'SecondView'],
    launch: function() {

		// var firstView = Ext.create('first_view');
		// var secondView = Ext.create('second_view');

		var tab = Ext.create('Ext.TabPanel', {
		    fullscreen: true,
		    tabBarPosition: 'bottom',
		    defaults: {
		        styleHtmlContent: true
		    },
			// items: [firstView, secondView]
			items:[
				{
					xclass:'SaltfactorySenchaTutorial.view.FirstView'
				},
				{
					xclass:'SaltfactorySenchaTutorial.view.SecondView'
				}
			]
		});

	}
});
```

![](http://cfile25.uf.tistory.com/image/126F933A4FBBB44131273A)

![](http://cfile6.uf.tistory.com/image/162EF3374FBBB44D1075B0)

탭 메뉴에 두가지 아이템을 선택할 수 있도록 되어졌고 각 아이템을 선택하면 뷰가 전환되는 것을 확인할 수 있을 것이다. 그런데 뷰의 전환이 iOS의 TabViewController와 Android의 TabHost와 다르다는 것을 느낄 것이다. Sencha는 기본적으로 뷰 전환 에니메이션을 Slide로 지정하고 있기 때문이다. 그럼 네이티브 앱과 같이 뷰가 전환되기 위해서는 에니메이션 효과를 없애면 된다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	views:['FirstView', 'SecondView'],
    launch: function() {

		// var firstView = Ext.create('first_view');
		// var secondView = Ext.create('second_view');

		var tab = Ext.create('Ext.TabPanel', {
		    fullscreen: true,
		    tabBarPosition: 'bottom',
		    layout:{
 				animation:null
 		    },
		    defaults: {
		        styleHtmlContent: true
		    },
			// items: [firstView, secondView]
			items:[
				{
					xclass:'SaltfactorySenchaTutorial.view.FirstView'
				},
				{
					xclass:'SaltfactorySenchaTutorial.view.SecondView'
				}
			]
		});

	}
});
```

## Image

Sencha를 이용해서 뷰를 구성하다보면 iOS의 UIImageView와 같이 이미지를 뷰에 올려서 사용하는 방법이 필요할 수 있다. 이미지 자원을 앱의 뷰에 올려서 뷰를 구성할때 필요하기 때문이다. 센차에서는 Ext.Img를 이용해서 이와 같은 작업을 할 수 있다.

FirstView.js에 Image를 올려보도록 하자.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			}
		],
		html: '<h1>first view</h1>'
	},

	initialize:function(){
		var imageView = Ext.create('Ext.Img',{
			src:'http://www.sencha.com/assets/images/sencha-avatar-64x64.png',
			height:64,
			width:64,
			flex: 1
		});
		this.add(imageView);
	}

});
```

원격 URL 로 이미지를 불러와서 현재의 뷰 (Ext.Container)에 Ext.Img 컴포넌트를 add 시키는 방법을 사용했다.

![](http://cfile6.uf.tistory.com/image/1109F33E4FBBB8CA37F053)

## MessageBox

네이티브 앱이나 웹 앱을 만들 때 사용자에게 뭔가 메세지를 출력시키기 위해서 우리는 MessageBox를 사용한다. iOS에서는 UIAlertView를 이용하고 Android 에서는 Toast 위젯을 이용한다.

FirstView.js에 버튼을 추가하고 버튼을 누르면 MessageBox가 보이도록 코드를 작성해보자.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					Ext.Msg.alert('알림', '버튼을 누르셨습니다', Ext.emptyFn);
				}
			}
		],
		html: '<h1>first view</h1>'
	},


});
```

![](http://cfile6.uf.tistory.com/image/174AF74F4FBBBB391E39DB)

MessageBox의 OK 버튼을 눌렀을 때 위 코드는 아무런 작업을 하지 않고 닫히기만 한다. 그래서 Ext.emptyFn 메소들를 입력했다. 그럼 버튼이 눌러졌을때 뭔가 일을 처리할 수 있도록 handler를 등록하자.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					Ext.Msg.alert('알림', '버튼을 누르셨습니다', function(){
 						console.log('on ok button')
 					});

				}
			}
		],
		html: '<h1>first view</h1>'
	},


});
```

Ext.emptyFn  대신에 작업을 처리할 수 있는 function으로 교체했다. 이제 다시 앱을 실행시키고 버튼을 누르면 등록해둔 handler 가 동작하는 것을 확인할 수 있다.

![](http://cfile23.uf.tistory.com/image/1421DD3A4FBBBDBA0778C2)

위의 MessageBox는 단순하게 버튼이 OK 하나만 되어 있는 MessageBox이다. 우리는 이러한 Alert 형태의 MessageBox 말고 사용자가 confirm을 할 수 있는 MessageBox를 많이 사용하기도 한다. 그래서 Sencha에서는 Ext.Msg에 Ext.Msg.alert와 Ext.Msg.confirm 두가지를 미리 정의해두었다.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					Ext.Msg.confirm('알림', '버튼을 누르셨습니다', Ext.emptyFn);
				}
			}
		],
		html: '<h1>first view</h1>'
	},

});
```

Ext.Msg.alert와 다르게 No, Yes 두가지 버튼이 포함되어 사용자가 결정할 수 있는 MessageBox가 만들어졌다.

![](http://cfile25.uf.tistory.com/image/1809AB3A4FBBBEC023D120)

Ext.Msg.alert에서 버튼을 누르면 이벤트를 처리할 수 있는 handler 를 등록한것 처럼 Ext.Msg.confirm을 처리하는 function을 정의해서 추가한다.  이 때 버튼을 누르면 어떤 것이 선택되었는지 알 수가 있다. 다음 코드로 변경해보자.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					Ext.Msg.confirm('알림', '버튼을 누르셨습니다', function(button){
 						console.log('on ok button : ' + button)
 					});
				}
			}
		],
		html: '<h1>first view</h1>'
	},

});
```

No 버튼을 누르면 no가 전달되고 Yes를 누르면 yes 값이 전달되는지 확인할 수 있다.

![](http://cfile6.uf.tistory.com/image/202CEF3C4FBBBF7C0AFA88)

또는 Ext.Msg를 직접 정의하여 사용할 수도 있다. Ext.Msg의 buttons에 각각 버턴을 따로 지정하고 hander도 따로 지정하면 된다.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					var msg = new Ext.MessageBox();
					msg.show({
					    title: '알림',
					    msg: '버튼을 누르셨습니다.',
					    buttons: [
							{
								text:'확인',
								handler:function(){ console.log('on ok button'), msg.hide()}
							},
							{
								text:'취소',
								handler:function(){ console.log('on cancel button'), msg.hide()}
							}
						]
					});
				}
			}
		],
		html: '<h1>first view</h1>'
	},
});
```

![](http://cfile29.uf.tistory.com/image/117A543B4FBBC04517A71D)

![](http://cfile30.uf.tistory.com/image/122DA9384FBBC05620E12C)

## ActionSheet

MessageBox 로는 사용자의 넓은 선택을 표현하기에 한계가 있다. 그래서 iOS에서는 사용자의 폭 넓은 선택을 받기 위해서 UIActionSheet를 사용하고 Android에서는 Dialog 위젯을 사용한다. Sencha 역시 ActionSheet 컴포넌트를 제공한다.

```javascript
/**
* file : FirstView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.FirstView', {
	extend: 'Ext.Container',
	alias: 'first_view',

	config: {
		iconCls: 'home',
		title: 'first',
		layout: 'vbox',
		items: [
			{
				xtype:'titlebar',
				title:'first'
			},
			{
				xtype:'button',
				text:'show MessageBox',
				margin: 10,
				handler:function(){
					var msg = new Ext.MessageBox();
					msg.show({
					    title: '알림',
					    msg: '버튼을 누르셨습니다.',
					    buttons: [
							{
								text:'확인',
								handler:function(){ console.log('on ok button'), msg.hide()}
							},
							{
								text:'취소',
								handler:function(){ console.log('on cancel button'), msg.hide()}
							}
						]
					});
				}
			},
			{
				xtype: 'button',
				text: 'show ActionSheet',
				margin: 10,
				handler:function(){
					var actionSheet = Ext.create('Ext.ActionSheet', {
					    items: [
					        {
					            text: '글 삭제',
					            ui  : 'decline',
								handler:function(){
									actionSheet.hide();
								}
					        },
					        {
					            text: '글 저장',
								ui : 'confirm',
								handler:function(){
									actionSheet.hide();
								}
					        },
					        {
					            text: '취소',
					            ui  : 'cancel',
								handler:function(){
									actionSheet.hide();
								}
					        }
					    ]
					});

					Ext.Viewport.add(actionSheet);
					actionSheet.show();

				}
			}
		],
		html: '<h1>first view</h1>'
	},
});

```

actionSheet의 items 들의 버튼 UI에 따라사 색상이 달라진다는 것을 확인할 수 있다.

![](http://cfile29.uf.tistory.com/image/186CE8454FBBC21408D6D6)

## 결론

이 포스팅을 마지막으로 Sencha Touch 2에서 뷰를 구성하는 컴포넌트에 대해서 예를 실습해보면서 살펴보았다. 이제 거의 대부분의 웹 앱 또는 하이브리드 앱의 UI를 만들 수 있는 준비는 모두 마친 것이다. 다음 포스팅에서는 Sencha의 MVC 중에서 Model과 Store에 대해서 포스팅이 진행될 예정이다. Sencha Touch는 기본적으로 UI의 컴포넌트들의 스타일과 특성을 내장해서 앱 개발시 UI 프로그래밍의 시간을 대폭 감소 시켜줄 수 있다. 이 블로그에서 작성하는 Sencha의 내용은 Sencha Touch의 가장 많이 사용되는 일부의 기능만을 소개한 것이다. 좀더 관심있게 메뉴얼과 구글링을 통해서 유연하고 아름다운 UI를 개발할 수 있을 것으로 예상된다.


## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.tab.Panel
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.Img
3. http://docs.sencha.com/touch/2-0/#!/api/Ext.MessageBox
4. http://docs.sencha.com/touch/2-0/#!/api/Ext.ActionSheet

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
