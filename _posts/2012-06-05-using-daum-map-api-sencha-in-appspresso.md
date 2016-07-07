---
layout: post
title: Appspresso를 사용하여 네이티브앱을 하이브리드 앱으로 전환 - 1.Sencha와 Daum Map 사용하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha, daum, map]
comments: true
redirect_from: /155/
disqus_identifier : http://blog.saltfactory.net/155
---

## 서론

프로젝트에 Appspresso를 정식으로 프로젝트에 도입하기 전에 토이 프로젝트(연구실에서 개발하는 공식 프로젝트가 아닌 조그만 실험용 프로젝트)에서 먼저 마이그레이션 작업을 해보기로 했다. 연구소에서 연구활동을 하면서 토이 프로젝트로 창원대학교에 관련된 앱을 만들어서 서비스를 하고 있는데 최근 창원대학교의 건물을 찾는 앱이 필요하다는 요청이 있어서 간단하게 건물의 목록을 찾고 현재 위치로부터 어떤 방향으로 위치하고 있는지를 확인할 수 있는 앱을 만들었다. 이 앱은 거의 비슷한 인터페이스로 Android 앱과 iPhone 앱이 스토어에 등록되어 있는 상태 있다.
http://cwnumap.hibrainapps.net/  사이트에서 각각의 앱을 해당 스토어에서 다운 받아서 사용할 수 있다. Appspresso의 첫번째 마이그레이션 프로젝트는 이 앱을 하이브리드 앱으로 마이그레이션해서 앱스프레소 프로젝트로 관리하기로 했다.

<!--more-->

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/bb015bf1-ae39-4380-91e3-f9781e363d93)

기존 네이티브 앱(iOS, Android)을 하이브리드 앱으로 전환 할 때 다음 조건을 만족시켜야한다.

1. Appspresso를 이용해서 HTML5 기반의 하이브리드 앱으로 개발한다.
2. Sencha를 이용해서 기존의 네이티브 앱과 UI를 최대한 비슷하게 만든다.
3. 지도 서비스를 위해서 "다음 맵"을 사용한다.
4. 건물의 위치와 건물명에 관한 데이터를 서버에서 json 데이터로 요청한다.
5. 건물 목록을 볼 수 있는 리스트 뷰 사용한다.
6. 검색 기능을 구현한다.

오늘은 그 첫번째로 1번, 2번, 3번 조건인 Sencha를 이용하고 Daum Map을 Appspresso에서 개발하는 방법에 대해서 포스팅 한다.

## Sencha

우선 Sencha를 이용해서 기존의 네이티브 앱과 동일한 NavigationBar를 구현하기로하자. Appspresso에서 프로젝트를 생성하는 방법과 Appspresso에서 Sencha를 이용하는 방법에 대해서는 이전 아티클들을 참조하길 바란다. (http://blog.saltfactory.net/category/Appspresso)

Appspresso를 열어서 프로젝트를 생성하고 디렉토리 구조는 다음과 같이 하였다.
/lib/sencha/ 디렉토리를 생성하고 그 안에 sencha-touch.css와 sencha-touch-all-debug.js 파일을 추가하였다.
그리고 Sencha Touch 프레임워크를 사용하여 MVC 모델로 개발하기 위해서 /js/app/controller, /js/app/model, /js/app/view, /js/app/store 디렉토리를 추가하였다. 그리고 /js/app/app.js 파일을 만들었다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/57620260-407e-42e6-b5fe-3d8f96389270)

텍스트 관리는 이후에 지역화를 지원하기 위해서 미리 텍스트를 분리하여 개발하도록 locales/string.js 파일을 추가하였다.

```javascript
/**
 * file : string.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * lisence : CCL (Not commercial)
 */

var HBNString = {
	main:{
		title: "창원대 맵",
		rightBarButton: "현재위치",
		leftBarButton: "건물찾기"
	}
};
```

간단하게 첫번째 뷰를 설정하기 위해서 /js/app/view/MainView.js 뷰 파일을 생성한다. 그리고 다음 코드를 입력한다.

```javascript
/**
 * file : MainView.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.view.MainView', {
	extend : 'Ext.Container',
	alias : 'MainView',
	config : {
		fullscreen : true,
		layout:'vbox',
		items: [{
			xtype:'titlebar',
			title: HBNString.main.title,
			docked:'top',
			items:[{
				xtype:'button',
				text: HBNString.main.rightBarButton,
				align:'right',
				id:'currentLocationButton'
			},{
				xtype:'button',
				text: HBNString.main.leftBarButton,
				align:'left',
				id:'searchBuildingButton'
			}],
			flex:1
		},
		{
			xtype:'panel',
			flex:2,
			id:'cwnumap'
		}]
	}
});
```

뷰는 간단하게 Ext.TitleBar와 Ext.Button, Ext.Panel로 구성된다. TitleBar는 양쪽에 두개의 Button을 가지고 있고 vbox로 구성된 레이아웃에서 상단에 TitleBar와 하단에 Panel이 존재하게 하였다. 그리고 이후 Controller에서 이벤트를 등록하거나 각 컴포넌트에 접근하기 위해서 id를 부여하였다.

/js/app/app.js에는 다음 코드를 추가한다. 애플리케이션이 시작할 때 위에서 만든 MainView를 생성하도록 하였다.

```javascript
/**
 * file : app.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.application({
    name: 'CWNUMap',
    appFolder: '/js/app',

    views: ['MainView'],

    launch: function() {
    	Ext.create('MainView');
    }
});
```

마지막으로 index.html을 수정하자.

```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<script src="/appspresso/appspresso.js"></script>
		<link rel="stylesheet" href="/lib/sencha/sencha-touch.css" type="text/css"/>
		<script src="/lib/sencha/sencha-touch-all-debug.js" type="text/javascript" charset="utf-8"></script>
		<script src="/locales/string.js" type="text/javascript" charset="utf-8"></script>
		<script src="/js/app/app.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	</body>
</html>
```

앱을 실행시켜보자. 다음과 같이 기존의 네이티브 앱과 거의 유사한 NavigationBar가 만들어 졌다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3d7c925f-f311-4cec-937d-f7989bca1d1e)

## Daum Map

이제 우리는 Daum Map을 추가할 것이다. 다음에서는 모바일용 Daum Map API를 공개하였다. 하지만 모바일용 Map API는 네이티브 코드와 네이티브 SDK로 동작하는 API로 하이브리드 앱에서 동작할 수 없다. 왜냐면 하이브리드 앱에서 메인 인터페이스는 네이트브 뷰 컴포넌트들이 아니라 바로 WebKit에서 동작하는 HTML5 코드이기 때문이다. 그래서 우리는 Daum Map V3 API를 이용하여 Javascript로 Daum Map API를 이용할 것이다. 다음 지도 API에서 모바일앱용 지도가 아닌 지도 인증키를 요청한다. 여기서 주의해야할 것은 Daum Map V3 API는 Referer 를 확인한다. 즉, 요청하는 도메인 안에서만 동작한다는 이야기인데, 우리가 테스트할 시뮬레이터의 호스트는 http://0.0.0.0 이고 Appspresso의 On The Fly로 디버깅하기 위해서는 각자의 디버깅 Host의 도메인으로 요청해야한다.

다음 캡처를 확인해보자. 아래는 시뮬레이터 도메인으로 요청을 해서 On The Fly의 디버깅을 이용해서 실행하면 다음과 같이 Referer의 문제로 API 로드 실패한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/712f6059-cceb-4921-94f5-d186feeb55a2)

그리고 시뮤레이터 도메인으로 제대로 요청하지 않으면 아래와 같이 나온다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/da1d33f4-593b-45a7-ba5a-7782a3ea6d7a)

다음의 지도 API 인증키를 제대로 요청한 이후에 Daum Map API를 요청하기 위해서 index.html을 다음과 같이 수정한다.

```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<script src="/appspresso/appspresso.js"></script>
		<link rel="stylesheet" href="/lib/sencha/sencha-touch.css" type="text/css"/>
		<script src="/lib/sencha/sencha-touch-all-debug.js" type="text/javascript" charset="utf-8"></script>
		<script src="/locales/string.js" type="text/javascript" charset="utf-8"></script>
		<script src="/js/app/app.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="http://apis.daum.net/maps/maps3.js?apikey=다음지도인증키"></script>  
	</head>
	<body>
	</body>
</html>
```

이제 우리는 Controller를 하나 추가할 것이다. MainView에서 우리는 지도가 들어가기 위한 Ext.Panel 컴포넌트를 하나 말들고 id를 'cwnumap' 이라고 지정하였다. 우리는 앱에서 컨트롤러가 로드될 때 MainView의 컴포넌트에 이벤트를 추가하고 Daum Map API를 이용해서 Panel에 지도를 넣을 것이다.

/js/app/controller/MainController.js 를 작성하자.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.controller.MainController', {
	extend: 'Ext.app.Controller',
	alias: 'MainController',

	config: {
		refs: {
			currentLocationButton:'#currentLocationButton',
			searchBuildingButton:'#searchBuildingButton'
		},
		control: {
			currentLocationButton: {
				tap : 'onCurrentLocationButton'
			},
			searchBuildingButton: {
				tap : 'onSearchBuildingButton'
			}
		}
	},

	onCurrentLocationButton:function(){
		console.log("onCurrentLocationButton");
	},

	onSearchBuildingButton:function(){
		console.log('onSearchBuildingButton');
	},

	init:function(){
		console.log('init MainController');
	},
	launch:function(){
		console.log('launch MainController');

		var mapContainer = document.getElementById('cwnumap');

		var position = new daum.maps.LatLng(35.2456, 128.692);
		var map = new daum.maps.Map(mapContainer, {
			center : position,
			level : 4,
			mapTypeId : daum.maps.MapTypeId.HYBRID
		});

		var marker = new daum.maps.Marker({
			position : position
		});
		marker.setMap(map);
		var infowindow = new daum.maps.InfoWindow({
			content : '창원대학교'
		});
		infowindow.open(map, marker);

	}

});
```

Sencha의 컨트롤러에 대해서는 [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 9. 컨트롤러(Controller)](http://blog.saltfactory.net/154) 글을 참조하기 바란다. 그 안에 identifier와 refs와 control에 대한 설명이 있다. 간단히 말하자면 MainView에서 지정한 id를 MainController가 refs를 이용하여 참조한 다음에 이벤트에 해당하는 일을 처리하기 위해 각각 해당하는 메소드를 호출할 수 있게 제어하는 기능을 한다. 그리고 컨트롤러가 생성되고 메모리에 올릴때 뷰에서 생성된 'cwnumap'의 HTML DOM Element를 찾아서 Daum Map API가 사용할때 맵을 추가할 수 있는 컨테이너로 생성하였다. 그리고 Daum Map API를 이용해서 지도를 그리고 위에 Marker를 추가해 핀을 나타낸다.

마지막으로 컨트롤러를 추가했으니 app.js에 MainController를 등록한다.

```javascript
/**
 * file : app.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.application({
    name: 'CWNUMap',
    appFolder: '/js/app',

    views: ['MainView'],
    controllers: ['MainController'],

    launch: function() {
    	Ext.create('MainView');
    }
});

```

아래는 앱을 실행한 후에 TitleBar에 있는 Button을 눌러서 MainController에 등록된 메소드들이 제어되는지 확인하는 화면이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fff86a98-5a25-4f96-8b4a-d269b619bee6)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/2ebc7d35-bad5-4a65-86a5-29fa9c2adab4)

## 결론

이렇게 Sencha와 Daum API를 Appspresso에서 동작할 수 있게 구현할 수가 있다. Appspresso로 프로젝트를 만들어서 하나의 코드로 간단하게 두가지 앱을 개발 할 수 있는 장점을 다음을 보면 확인할 수 있다. Appspresso에서 개발은  Chrome Extension Appspresso Debugging 툴로 개발하고 코드 반영은 On The Fly로 할 수 있다. 그리고 그렇게 개발된 코드를 가지고 iOS와 Android에 바로 적용하여 테스트할 수 있다. 포스트 과정에서 실제 디바이스에 올리는 내용은 생략했지만 http://blog.saltfactory.net/category/Appspresso 아티클에서 그 내용을 찾아서 적용할 수 있을 것이다. 토이프로젝트의 기존 앱을 하이브리드 앱으로 전환하는 과정을 블로그릍 통해서 계속 포스팅을 진행할 예정이다. 그 과정 중에 첫번 째로 다음의 지도를 Sencha와 함께 사용하는 방법에 대해서 소개하였다. 다음은 원격지에 있는 서버에서 json 데이터를 요청하여 처리하는 과정을 포스팅할 예정이다.


![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/bbf96a4b-50ed-4ade-a8ec-57e7cc5cd949)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/d5c7882d-429d-4116-8b5e-ff12a6d6c016)

이 블로그에 사용되는 모든 코드는 CCL(By-NC-SA 2.0) 라이센스 (http://creativecommons.org/licenses/by-nc-sa/2.0/kr/) 에 의해서 보호됩니다. (저작권 표시, 비영리, 동일조건변경허락). 상업용 목적으로 코드를 사용하시거나 저작권 표시없이 재사용하실 수 없습니다. 올바른 공유문화를 위해서 협조바랍니다. 소스코드는 이후 github으로 공개할 예정입니다.

## 참고

1. http://cwnumap.hibrainapps.net
2. http://dna.daum.net/apis/maps/v3


