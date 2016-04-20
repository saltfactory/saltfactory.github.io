---
layout: post
title: Appspresso를 사용하여 네이티브앱을 하이브리드 앱으로 전환 - 2.Sencha Model과 원격데이터 요청
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha, model]
comments: true
redirect_from: /156/
disqus_identifier : http://blog.saltfactory.net/156
---

## 서론

현재 Appspresso(앱스프레소)를 사용해서 하이브리드 앱을 개발하면 가장 많이 고민하는 부분이 바로 UI이다.  이것은 아직 공식화 되거나 표준화된 하이브리드 UI가 없기 때문이다. 네이티브 앱은 이런 고민을 하지 않아도 된다. 왜냐면 SDK에 이미 UIKit과 Widget이 제공하고 있기 때문이다. 그래서 하이브리드 앱을 개발할 때 Sencha, jQuery, Dojo, 등의 Javascript UI 라이브러리 선택을 하는데 고민하게 된다. 그래서 Sencha를 선택해서 UI 개발 환경을 정했다고 하자. 그렇다고 고민이 사라지는 것은 아니다. 왜냐하면 어느것을 어떤 수준까지 이용해야하냐는 것이다. 이 말은 이미 각각의 라이브러리들이 너무 많은 기능을 포함하고 있기 때문에 그 기능이 중복된다는 것이다. 네이티브 앱에서는  NSURLRequest을 URL을 요청할 때 사용하라고 (물론 다른 방법도 존재하지만 대부분 NSURLResponse를 위해서 NSURLRequest를 사용할 것이다. 아니면 패키징된 써드파티 클래스를) 이미 정해져 있지만 Sencha에서도 Ajax, JSONP를 이용해서 원격 데이터를 요청할 수 있는 기능이 있고, Appspresso의 ax.ext.net.curl을 이용해서 cross-domain url request를 요청할 수 있기 때문이다.

결론부터 말하자면, 개발자의 의도와 목적에 맞게 사용하는게 답인 것다. Sencha의 모든 기능을 이용하여 네이티브 앱으로 패키징하여 앱스토에 올리기 위해서 패키지 빌드용으로 Appspresso를 이용해도 되고, 순수 UI의 목적만 사용하고 나머지는 Appspresso의 plugins 기능이나 네이티브 코드를 이용해서 개발하라는 것이다. Sencha를 UI로 사용한다는 말은 Sencha의 MVC를 이용한다는 말과 다르지 않다. (물론 MVC 를 이용하지 않아도 되지만 코드가 복잡해지고 나중에 유지보수가 어려워질 것이다.) 그래서 그냥 단순하게 Sencha의 Model과 Store를 이용하기 위해서 proxy 속성을 이용해서 ajax나 scripttag나 jsonp 등을 이용해도 된다. 하지만, Appspresso 자체에 훌륭한 여러가지 plugins들이 존재한다. 우리는 이렇게 훌륭하게 잘 만들어진 Appspresso의 라이브러리와 Sencha의 라이브러리를 보완하면서 적당한 기능으로 나누어서 섞어서 사용하길 원할 수 있다. 그래서 이 포스팅에서는 원격 서버로 부터 데이터를 요청해서 Sencha의 Model을 이용하고 그것을 사용해서 UI에 반영하는 과정을 소개한다.

<!--more-->

[Appspresso를 사용하여 하이브리드앱 개발하기 - 17.Sencha와 Daum Map 사용하기](http://blog.saltfactory.net/155) 아티클에서 우리는 Appspresso를 이용해서 Sencha와 Daum의 지도 API를 이용해서 기존의 네이티브 코드로 개발했던 지도뷰를 하이브리드 앱으로 구현하는 과정을 살펴보았다.

기존 네이티브 앱(iOS, Android)을 하이브리드 앱으로 전환 할 때 다음 조건을 만족시켜야한다. 우리는 1,2,3 의 조건을 앞의 아티클에서 같이 구현해보았고 이 포스팅에서는 4번 조건을 구현하기로 한다.

1. Appspresso를 이용해서 HTML5 기반의 하이브리드 앱으로 개발한다.
2. Sencha를 이용해서 기존의 네이티브 앱과 UI를 최대한 비슷하게 만든다.
3. 지도 서비스를 위해서 "다음 맵"을 사용한다.
4. 건물의 위치와 건물명에 관한 데이터를 서버에서 json 데이터로 요청한다.
5. 건물 목록을 볼 수 있는 리스트 뷰 사용한다.
6. 검색 기능을 구현한다.

실제 기존의 네이티브 앱에서는 앱이 실행되면 원격 서버로 부터 json 형식으로된 건물들의 데이터를 요청해서 지도 위에 건물의 위치를 Maker로 표시하고 marker를 선택할때 CallOutView (말풍선)이 나와서 건물의 이름과 호관을 보여준다. 우리는 이 기능을 구현할 것이다.

![](http://blog.hibrainapps.net/saltfactory/images/7c735c6e-0d02-4fd4-932e-3f5398a8d47b)

## 원격 데이터 요청

우리는 앞에서 만든 원격 데이터를 요청하기 위해서 MainController를 수정할 것이다. MainController가 지도를 MainView의 Panel에 만들어서 올리면서 원격 서버로부터 건물 데이터를 요청하기위해서 Controller가 launch 될 때 Appspresso의 ax.ext.net.curl을 요청하도록 해보겠다.
먼저 우리는 Sencha만 가지고 하이브리드 앱을 구현하는 것이 아니라 Appspresso의 WAC plugins을 사용할 것이다. 앱스프레소의 프러그인 중에서  원격의 데이터를 요청하기 위해서 ax.ext.net.curl을 이용할 것이다. 이 플러그인을 사용하기 위해서 Appspresso의 project.xml 을 열어서 Plugin List 중에서 ax.ext.net을 선택한다.

![](http://blog.hibrainapps.net/saltfactory/images/ea934398-e0db-483d-af00-6ce8431862af)

이젠 MainController.js를 열어서 launch때 동작하는 메소드를 수정한다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * licesce : CCL (Not commercial)
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

//		var marker = new daum.maps.Marker({
//			position : position
//		});
//		marker.setMap(map);

    	    var request = {
			'url': 'http://json 파일이 위치한 서버경로',
			'success': function(response){
				var json =  JSON.parse(response.data);
				ax.log(json);
				},
			'error': function(error){
				ax.log(error);
				},
			'method':'GET'
		};

    	    ax.ext.net.curl(request);
	}

});
```

MainController가 생성되고 launch 될 때 동작하는 메소드 안에 원격 서버에서 json 데이터를 요청하기 위해서 ax.ext.net.curl을 요청하는 코드를 추가했다. 이 코드에 대한 설명은 [Appspresso를 사용하여 하이브리드앱 개발하기 - 3.원격데이터 요청하기](http://blog.saltfactory.net/127) 글을 참조하면 된다. 간단하게 설명하면 원격 데이터를 요청할 URL과 요청후 요청이 성공 했을 경우 response를 받아서 동작할 response callback 함수, 그리고 요청이 실패했을 경우 error를 받아서 동작할 error callback 함수, 요청할 http method를 지정한 request를 ax.ext.net.curl로 실행하는 것이다. 그리고 요청이 성공하면 success에 등록된 success callback에서 response를 받는데 현재 요청한 것이 json 데이터라서 요청후 JSON.parse로 응답받은 문자열을 json 객체로 변경한 것이다. 그렇게 생성된 json을 Inspector를 통해서 출력하면 다음과 같이 buildings라는 속성 안에 47개의 건물 속성이 저장된 배열이 있다는 것을 확인할 수 있다.


실제 요청한 json 데이터를 일부 보면 다음과 같다. 아래 데이터는 원격 서버에 웹 프로그램으로 작성되어 RESTful API를 지원하도록 만들어져 있다.

```javascript
{
    "buildings": [
                  {
                  "alias": "1호관",
                  "created_at": "2012-04-07T08:29:33Z",
                  "description": "",
                  "id": 1,
                  "latitude": 35.245558,
                  "longitude": 128.691957,
                  "name": "대학본부",
                  "number": 1,
                  "updated_at": "2012-04-13T01:25:40Z"
                  },
                  {
                  "alias": "2호관",
                  "created_at": "2012-04-07T08:30:44Z",
                  "description": "",
                  "id": 2,
                  "latitude": 35.245036,
                  "longitude": 128.693912,
                  "name": "중앙도서관",
                  "number": 2,
                  "updated_at": "2012-04-13T01:24:48Z"
                  },
                  .
                  .중간 생략
                  .
                  ,
                  {
                  "alias": "51호관",
                  "created_at": "2012-04-16T11:52:17Z",
                  "description": "",
                  "id": 48,
                  "latitude": 35.242484,
                  "longitude": 128.696672,
                  "name": "하이브레인넷",
                  "number": 51220,
                  "updated_at": "2012-04-16T11:52:17Z"
                  }
    ]
  }
```

![](http://blog.hibrainapps.net/saltfactory/images/8c478b71-0c3a-45ef-933f-4c97a6ddbf83)

우리는 이렇게 Sencha Touch 의 MVC 중에서 Controller 안에서 Appspresso의 plugins를 사용하는 방법을 같이 해보았다. 이젠 이렇게 Appspresso의 plugins으로 요청한 데이터를 Sencha의 Model로 저장하는 Store를 구현해보자.

/js/app/model/Building.js 를 아래 코드로 생성한다.
```javascript
/**
 * file : Building.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.model.Building', {
	extend: 'Ext.data.Model',
	alias: 'Building',

     config: {
		 fields: [
		          {name:'id', type:'int'},
		          {name:'name', type:'string'},
		          {name:'alias', type:'string'},
		          {name:'created_at', type:'string'},
		          {name:'latitude', type:'double'},
		          {name:'longitude', type:'double'},
		          {name:'number', type:'int'},
		          {name:'updated_at', type:'string'},
		          {name:'description', type:'string'}],
     }
});
```

"Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 8. 모델(Model)" 글에서는 Store의 proxy를 이용해서 모델에 해당하는 데이터를 json에서 reader해서 Model 형태로 Store에 저장했었다. 하지만 우리는 Sencha의 proxy를 이용해서 원격 데이터를 요청한 것이 아니라 Appspresso의 ax.ext.net.curl을 이용해서 데이터를 요청했다.

## Model과 Store

이렇게 외부 라이브러리로 요청해서 Sencha의 Model을 이용해서 Store로 저장하기 위해서는 Store를 다음과 같이 지정한다.

/js/app/store/BuildingStore.js 를 아래 코드로 생성한다.

```javascript
/**
 * file : BuildingStore.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.store.BuildingStore', {
	extend: 'Ext.data.Store',
	requires: ['CWNUMap.model.Building'],

	config:{
		model:'CWNUMap.model.Building'
	}
});
```

Model과 Store를 추가했으니 app.js를 수정하여 추가한다.

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

    models: ['Building'],
    stores: ['BuildingStore'],
    views: ['MainView'],
    controllers: ['MainController'],

    launch: function() {
    	Ext.create('MainView');

    }
});
```

그리고 MainController.js에서 json 데이터를 요청해서 성공하여 난 이후에 동작하는 success callback 함수 안에 json데이터를 이용해서 Building Model 형태로 ModelStore에 저장한다. 아래 코드를 살펴보면 Sencha의 Store를 Model형태를 가진 JSON 데이터를 store.setData()로 저장할 수 있다는 것을 확인할 수 있다.

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

//		var marker = new daum.maps.Marker({
//			position : position
//		});
//		marker.setMap(map);

    	var request = {
			'url': 'http://json 파일이 위치한 서버경로',
			'success': function(response){
				var json =  JSON.parse(response.data);
//					ax.log(json);
//					console.log(json);

				var store = Ext.create('CWNUMap.store.BuildingStore');
				store.setData(json.buildings);
		    	        store.load({
		    		    callback:function(){
		    			store.data.each(function(building){
		    				console.log(building.get('name') + ',' + building.get('alias') + ',' +building.get('latitude') + ',' + building.get('longitude'));
		    			});
		    		    }
		    	        });

				},
			'error': function(error){
				ax.log(error);
			},
			'method':'GET'
		};

    	ax.ext.net.curl(request);
	}

});
```

앱을 다시 실행시키면 다음과 같이 json 데이터가 모두 Model 로 BuildingStore에 저장이 되고, Store가 load될 때 callback으로 각각의 Model 데이터를 출력하도록 하였다.

![](http://blog.hibrainapps.net/saltfactory/images/3ae6df7c-f149-4bd7-8dd4-b93d7130ea64)

이제 Appspresso 의 plugins으로 원격에서 건물정보 데이터를 가져와서 Sencha의 Model 로 변경하여 Store로 저장하여 로드하였기 때문에 UI에서  Model를 이용하여 UI 요소를 추가할 수 있다. 지도 위에다 Store에 저장된 Model을 이용해서 Marker를 추가해보자. MainController.js를 다음과 같이 수정한다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */
var infowindow;
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

//		var marker = new daum.maps.Marker({
//			position : position
//		});
//		marker.setMap(map);

    	var request = {
			'url': 'http://json 파일이 위치한 서버경로',
			'success': function(response){
				var json =  JSON.parse(response.data);
//					ax.log(json);
//					console.log(json);

				var store = Ext.create('CWNUMap.store.BuildingStore');
				store.setData(json.buildings);
		    	store.load({
		    		callback:function(){
		    			store.data.each(function(building){
//		    				console.log(building.get('name') + ',' + building.get('alias') + ',' +building.get('latitude') + ',' + building.get('longitude'));
		    		        var _position = new daum.maps.LatLng(building.get('latitude'), building.get('longitude'));
		    			var marker = new daum.maps.Marker({
		    				position : _position
		    			});

		    			daum.maps.event.addListener(map, "click", function(){
		    				infowindow.close();
		    			});

		    			daum.maps.event.addListener(marker, "click", function(){
		    				if(infowindow != null) infowindow.close();

		    				infowindow = new daum.maps.InfoWindow({
		    					content: '<p style="margin:7px 22px 7px 12px;font:12px/1.5 sans-serif;"><strong>' + building.get('name')+ '<br/>(' +building.get('alias') + ')' + '</strong></p>',
		    					removable : true
		    				});
		    				infowindow.open(map, marker);
		    					//console.log(building.get('name'));
		    			});

		  			marker.setMap(map);
		  		    });
			}
		    	    });

			},
			'error': function(error){
				ax.log(error);
			},
			'method':'GET'
		};

    	ax.ext.net.curl(request);
	}

});
```

블로그 포스트요으로 inforwindow에 inline code로 만들었지만 css로 스타일을 분리하면 더 좋은 코드가 될 것 이다.
Appspresso 에서 On The Fly로 simulator로 빌드해서 테스트해보자. iOS와 Android 에서 모두 정상적으로 동작하는 것을 확인할 수 있다.

![](http://blog.hibrainapps.net/saltfactory/images/d04e6de4-d9c4-47ab-b449-d8a9b1f8518f)

![](http://blog.hibrainapps.net/saltfactory/images/e6858e7c-f3cf-4463-b459-233de505fbc3)

## 결론

이번 포스팅에서는 Appspresso와 Sencha Touch 2의 상호 데이터를 주고 받으면서 외부 라이브러리를 이용해서 원격 데이터를 요청해서 UI를 담당하는 Sencha의 MVC의 Model과 Store로 저장을 한다. 그리고 Controller에서 일을 처리하는 부분을 제어하여 Sencha MVC 와 Appspresso에서 제공하는 Plugins을 이용해서 하이브리드 앱을 개발 할 수 있게 되었다. Sencha와 Appspresso의 Plugins 인 ax.ext.net.curl을 사용했지만 [Appspresso를 사용하여 하이브리드앱 개발하기 - 3.원격데이터 요청하기](http://blog.saltfactory.net/127) 포스팅을 참조해서 Sencha와 네이티브 코드와도 연동할 수 있을 것이다. 우리는 이렇게 이전 아티클을 기반으로 지도위에 원격 서버에 있는 json 데이터를 이용해서 지도위에 marker를 동적으로 추가하였다. 다음은 요청한 원격데이터 기반으로 List View를 만들고 view navigation을 하는 기능과 검색하는 기능을 만들어보기로 하겠다.

## 참고

1. http://cwnumap.hibrainapps.net
2. http://dna.daum.net/apis/maps/v3


