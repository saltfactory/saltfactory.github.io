---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 3.컴포넌트 구성
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, component]
comments: true
redirect_from: /142/
disqus_identifier : http://blog.saltfactory.net/142
---

## 서론

Sencha Touch 는 네이티브 앱과 가장 유사한 인터페이스를 생성해주는 것으로 유명하다. 하이브리드 앱을 만들때 사용자의 UX를 무시하지 않는 것이 좋은 접근 방법이다.  하이브리드 앱에서는 기존에는 네이티브 앱에서는 복잡해서 하기 힘들었던 스타일 프로그래밍이 HTML5 + CSS(CSS3)의 조합으로 보다 편리하게 UI의 스타일을 변화 시킬 수 있게 되었다. 이러한 자유로움이 사용자가 지금까지 숙지해온 경험을 혼란으로 만들수도 있다. 가령 back 모양을 변경한다던지, 위치를 상단에서 하단으로 변경한다던지하면 아이폰 사용자는 메뉴를 찾기위해서 혼란스러워 할 수 있다는 의미이다. 이러한 관점에서 네이티브에 가장 가까운 UI를 미리 스타일로 만들어서저 컴포넌트 형식으로 제공해주는 Sencha의 특징을 장점으로 말할 수 있다. 이번 포스팅에서는 그러한 컴포넌트들의 UI를 만들고 뷰를 구성하는 방법에 대해서 설명한다.

<!--more-->

먼저 우리는 기본적으로 뷰를 올리기 위해서 Ext.Panel 이라는 것을 사용한 것을 기억 할 것이다. 또한 MVC 모델에 따라서 뷰를 분리해서 관리하기 위해서 app/view 아래 뷰를 물리적으로 나누기도 했었다. ( [Sencah Touch2를 이용한 하이브리드 앱 개발 - 2.View 생성](http://blog.saltfactory.net/140) 글 참조)

```javascript
/**
 * file : app.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.application({
	name : 'SaltfactorySenchaTutorial',
	views : [ 'MainView' ],
	appFolder : '/js/app',
	launch : function() {
		Ext.create('welcome_view');
	}
});
```

```javascript
/**
 * file : MainView.js
 * author : saltfactory
 * email : saltfactory@gmail.com
 */

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Panel',
	alias : 'welcome_view',

	config: {
		html: 'Hello, World!',
		fullscreen: true
	}
});

```

우리는 이전에 이렇게 app.js와 app/view/Welcome.js 로 앱과 뷰를 분리해서 관리하고 생성 시킬 수 있다는 것을 알아보았다. 이젠 이 뷰를 어떻게 구성할지에 대해서 살펴보자. 먼저 뷰를 구성하는 것을 살펴보기 전에 Ext.Component에 대해서 살펴보아야한다. Ext.Component는 Sencha 에서 시각화하는 클래스를 말하는 것인데 컴포넌트들은 다음과 같은 특징이 있다.

1. 페이지에서 템플릿을 사용해서 렌더링할 수 있다.
2. 어떠한 시간이든 보이거나 감출 수 있다.
3. 스크린 중심에 위치할 수 있다.
4. 활성화 / 비활성화를 설정할 수 있다.
5. 다른 컴포넌트 위에 위치 시킬 수 있다.
6. 에니메이션 효과로 위치나 크기를 변경할 수 있다.
7. 다른 컴포넌트 안에 도킹할 수 있다.
8. 다른 컴포넌트를 정렬, 스크롤, 드래그 등을 할 수 있다.

Sencha에서 가능한 컴포넌트는 크게 네가지로 분류된다. (각각 컴포넌트의 공식 메뉴에 자세히 설명하고 있어서 링크로 설명은 대신한다.)]]


#### Navigation components

* [Ext.Toolbar](http://docs.sencha.com/touch/2-0/#!/api/Ext.Toolbar)
* [Ext.Button](http://docs.sencha.com/touch/2-0/#!/api/Ext.Button)
* [Ext.TitleBar](http://docs.sencha.com/touch/2-0/#!/api/Ext.TitleBar)
* [Ext.SegmentedButton](http://docs.sencha.com/touch/2-0/#!/api/Ext.SegmentedButton)
* [Ext.Title](http://docs.sencha.com/touch/2-0/#!/api/Ext.Title)
* [Ext.Spacer](http://docs.sencha.com/touch/2-0/#!/api/Ext.Spacer)

#### Store-bound components

* [Ext.dataview.DataView](http://docs.sencha.com/touch/2-0/#!/api/Ext.dataview.DataView)
* [Ext.Carousel](http://docs.sencha.com/touch/2-0/#!/api/Ext.carousel.Carousel)
* [Ext.List](http://docs.sencha.com/touch/2-0/#!/api/Ext.dataview.List)
* [Ext.NestedList](http://docs.sencha.com/touch/2-0/#!/api/Ext.dataview.NestedList)

#### Form components
* [Ext.form.Panel](http://docs.sencha.com/touch/2-0/#!/api/Ext.form.Panel)
* [Ext.form.FieldSet](http://docs.sencha.com/touch/2-0/#!/api/Ext.form.FieldSet)
* [Ext.field.Checkbox](http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Checkbox)
* [Ext.field.Hidden](http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Hidden)
* [Ext.field.Slider](http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Slider)
* [Ext.field.Text](http://docs.sencha.com/touch/2-0/#!/api/Ext.field.Text)
* [Ext.picker.Picker](http://docs.sencha.com/touch/2-0/#!/api/Ext.picker.Picker)
* [Ext.picker.Date](http://docs.sencha.com/touch/2-0/#!/api/Ext.picker.Date)

#### General components
* [Ext.Panel](http://docs.sencha.com/touch/2-0/#!/api/Ext.Panel)
* [Ext.tab.Panel](http://docs.sencha.com/touch/2-0/#!/api/Ext.tab.Panel)
* [Ext.Viewport](http://docs.sencha.com/touch/2-0/#!/api/Ext.Viewport)
* [Ext.Img](http://docs.sencha.com/touch/2-0/#!/api/Ext.Img)
* [Ext.Map](http://docs.sencha.com/touch/2-0/#!/api/Ext.Map)
* [Ext.Audio](http://docs.sencha.com/touch/2-0/#!/api/Ext.Audio)
* [Ext.Video](http://docs.sencha.com/touch/2-0/#!/api/Ext.Video)
* [Ext.Sheet](http://docs.sencha.com/touch/2-0/#!/api/Ext.Sheet)
* [Ext.ActionSheet](http://docs.sencha.com/touch/2-0/#!/api/Ext.ActionSheet)
* [Ext.MessageBox](http://docs.sencha.com/touch/2-0/#!/api/Ext.MessageBox)

여기에 나오는 모든 컴포넌트를 최대한 실습해보려고 하겠지만 빠진 부분은 공식 메뉴을을 찾아보거나, 다른 컴포넌트의 상용과 크게 다르지 않다. 위에 열거되어 있는 컴포넌트들은 모두 Ext.Component를 상속받기 때문이다.  우리가 가장 먼저 살펴보았던 것은 Ext.Panel 이라는 General components 중에 하나였다. 이제 좀더 구체적으로 뷰를 구성하기 위한 컴포넌트 사용 예제를 살펴보자.

## Toolbar

우리는 기존에 Ext.Panel을 생성하는 방법을 배웠다. Toolbar도 Ext.Component를 상속받기 때문에 동일한 방법으로 생성할 수 있겠다. MainView.js를 열어서 다음과 같이 수정하자. 간단하게 MainView 를 Ext.Toolbar를 상속받게 정의하였다. 그리고 toolbar를 상단에 배치시키기 위해서 docked를 'top'으로 설정했다. 'bottom'으로 하면 하단에 배치된다. 그리고 버그인지 모르겠지만, 하이브리드 앱 상에서는 width:'100%'를 주지 않아도 fullscreen으로 나오는데 데스크탑에서 브라우저를 열어서 확인하면 명시적인 사이즈 없이는 사이즈가 fullscreen으로 만들지 못했다. 이 Ext.define은 Ext.application에서 launch 속성이 동작할때 Ext.create('main_view')를 호출하는데 관련된 정의를 Panel에서 Toolbar로 상속되게 변경한 것이다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	}
});
```

index.html을 새로 고치맣면 아이폰에서 Toolbar와 동일한 모야이 상단에 붙은 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/477e860a-be4a-42a4-b451-9df0593eac76)

우리는 좀더 Toolbar 스럽게 만들기 위해서 버턴을 추가하자, 왼쪽상단에 "Back" 이라는 뒤로가기 버턴을 추가할 것이다. MainView.js 파일을 다음과 같이 수정하자.

1. LeftTopButton이라는 이름으로 Ext.define을 가지고 정의를 한다.
2. Ext.Button의 속성중에서 text라는 속성은 버턴 위에 나타나는 글자를 지정하는 것인데 'Back'이라는 글자를 지정한다.
3. Ext.Button의 속성중에 ui라는 속성은 버턴의 모야을 지정하는 것인데, 그 중에서 'back'을 지정한다. ui에 값으로는 (normal, back, forward, round, action, decline, confirm) 이 있다.
4. 그리고 Toolbar를 정의하는 곳에서 객체가 생성될 때 작업을 지시하기 위해서 initialize 속성에 메소드를 구현해서 추가한다.
5. initialize에서는 Toolbar 위에 올라가는 버턴을 생성하여 추가하는데 Sencha에서는 객체의 이름과 객체를 매핑시킨다고 하였다. 이 때 버턴의 이름이 LeftTopButton이므로 객체를 생성할 때 new LeftTopButton()으로 생성할 수 있다. 그리고 Ext.Component가 가지고 있는 속성중에 add 메소드를 이용해서 child component를 추가한다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('LeftTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'Back',
		ui: 'back'
	}
})


Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	},

	initialize: function(){
		var leftTopButton = new LeftTopButton();
		this.add([leftTopButton]);
	}
});
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c0926abd-dc44-4904-8698-5ad6c828848a)

우리는 Toolbar를 조금 더 수정해보자. Toolbar 오른쪽에 "New"라는 버턴을 추가해보자. 우리는 앞서 버턴을 툴바에 추가하는 방법에 대해서 알아보았다. 그래서 코드를 다음과 같이 수정한다.


```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('LeftTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'Back',
		ui: 'back'
	}
})

Ext.define('RightTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'New',
		ui: 'action'
	}
})


Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	},

	initialize: function(){
		var leftTopButton = new LeftTopButton();
		var rightTopButton = new RightTopButton();
		this.add([leftTopButton, rightTopButton]);
	}
});
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/20842fa6-ece8-4f68-b96a-9407f71fd5a2)

그런데 우리가 원하는 모양으로 나오지 않는다는 것을 확인할 수 있다. 이는 아이폰 개발자라면 알 수 있는 UI 구성이다. UIToolbar에 items를 NSArray 타입으로 받아서 UI를 구성하는데 Sencha에서도 동일하게 구성을 만들어둔 것이다. 그래서 다음과 같이 변경해보자.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('LeftTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'Back',
		ui: 'back'
	}
})

Ext.define('RightTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'New',
		ui: 'action'
	}
})

Ext.define('Spacer', {
	extend: 'Ext.Spacer',
})


Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	},

	initialize: function(){
		var leftTopButton = new LeftTopButton();
		var spacer = new Spacer();
		var rightTopButton = new RightTopButton();
		this.add([leftTopButton, spacer, rightTopButton]);
	}
});
```

다시 index.html 파일을 새로 고침해보자. 이제 우리가 원하는 모양대로 Toolbar가 네이티브 앱의 모양과 동일하게 구성된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3ed1f690-d038-4d24-9477-61a92b4f05d2)

Sencha에서 우리는 컴포넌트를 생성하는 방법으로 Ext.create를 사용했고 위 예제에서는 이름과 동일한 클래스명을 new로 생성하였다. 우리는 Ext.create을 상용해서 컴포넌트들을 생성하고 추가해보자.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('LeftTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'Back',
		ui: 'back'
	}
})

Ext.define('RightTopButton', {
	extend: 'Ext.Button',

	config: {
		text: 'New',
		ui: 'action'
	}
})

Ext.define('Spacer', {
	extend: 'Ext.Spacer',
})



Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	},

	initialize: function(){
		var leftTopButton = Ext.create('LeftTopButton');
		var spacer = Ext.create('Spacer');
		var rightTopButton = Ext.create('RightTopButton');
		this.add([leftTopButton, spacer, rightTopButton]);
	}
});
```

이런 패턴으로 컴포넌트를 정의하고 추가하고 하는 작업을 하려면 복잡하게 될 것 같다는 생각이 든다. 그래서 Sencha는 xtype 이라는 속성을 컴포넌트에 추가하였고, 이 xtype은 컴포넌트가 생성되고 렌더링 될때 옵티마이저하게 하는 기능을 갖도록 구현하였다. 그래서 위의 코드를 다음과 같이 변경할 수 있다. 코드가 굉장히 짦고 간단해졌다.

```javascript
/**
* file : MainView.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.view.MainView', {
	extend : 'Ext.Toolbar',
	alias: 'main_view',

	config: {
		fullscreen: true,
		title: 'Home',
		docked: 'top',
		width: '100%',
	},
	initialize: function(){
		this.callParent(arguments);

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

		this.add([leftTopButton, spacer, rightTopButton]);
	}
});
```

마지막으로 우리가 처음 생성했던 Hello, World!의 Panel 컴포넌트에 우리가 만든 위의 Toolbar를 추가해서 완벽하게 구성해보자. Toolbar는 다음과 같이 xtype으로 정의할 수 있고, this.add로 컴포넌트를 생성하여 추가한 것은 items 속성으로 변경할 수 있다.

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

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/265af8d8-ff82-441d-adcf-bba7d7d28588)

그리고 우리는 본문을 HTML로 작성하고자 하기 때문에 컨텐츠가 HTML 스타일이 적용되게 다음 코드를 추가하자.

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

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a647d666-7be3-41e7-98b3-c68881919990)

## 결론

이제 우리가 구성하기로 마음 먹은대로 컴포넌트를 사용해서 뷰를 구성했다. 컴포넌트를 생성하는 방법은 Ext.create를 이용하거나 Ext.define에 정의한 이름을 new로 생성하여 만들 수 있다. 그리고 그렇게 생성된 컴포넌트들은 Ext.Component가 가지는 add 메소드를 이용해서 순서적으로 추가할 수 있다. 이렇게 정의하고 컴포넌트를 생성하고 하는 코드가 너무 길어지기 때문에 Ext.Component의 xtype이라는 것으로 컴포넌트를 정의하여 컴포넌트가 랜더링 될때 최적화된 컴포넌트를 구성할 수 있다는 것을 소개하였다. 마지막으로 우리가 사용하는 사용자 정의 HTML 속성을 사용하기 위해서 styleHtmlContent을 true 로 한다. 이 포스팅은 컴포넌트를 생성하여 다른 컴포넌트에 추가하여 뷰를 구성하는 방법을 Toolbar를 예로 들어 설명했다.  다음 포스팅에서는 컴포넌트 생성과 구성 과정을 생략하고 좀 더 다양한 컴포넌트를 조합해서 뷰를 구성하는 방법에 대해서 포스팅할 예정이다.


