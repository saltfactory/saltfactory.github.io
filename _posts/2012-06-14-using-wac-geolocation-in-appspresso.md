---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 4.WAC GeoLocation 사용
category: ios
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha, geolocation]
comments: true
redirect_from: /160/
disqus_identifier : http://blog.saltfactory.net/160
---

## 서론

"Appspresso (앱스프레소)를 이용하여 iPhone과 Android 앱 동시에 개발하기"에 관련된 포스트 중에 "네이티브 앱을 하이브리드 앱으로 전환" 에 관련된 글에서 살펴보면 이벤트 핸들링 부터 MVC 까지 대부분 Sencha를 이용하고 있다. 실제 Sencha로 하이브리드 앱을 만들 수 있다.(단, 네이티브 코드를 사용하는 것이 아니라 개발은 웹 기술로 개발하고 앱을 스토어에 등록하기 위해서 packaging 작업을 할 때 물리적으로 웹이 아닌 네이티브 앱으로 만들어진다는 점에서, 네이티브 코드까지 개발하고 사용할 수 있는 Appspresso의 하이브리드의 개념과 다르다.). 그래서 자칫 Appspresso의 기능은 단지 HTML5와 Javascript 기반의 Sencha와 같은 UI를 개발하는 IDE로 생각할 수도 있다. 하지만 그렇게 생각하면 안된다.

> 하이브리드 앱은 단순하게 웹 개발 기술로 웹 앱을 만들고 그것을 네이티브 앱으로 사용할 수 있게 packaging만 하는 것이 아니라. Appspresso와 같이 WAC를 이용해서 네이티브 자원을 접근하거나 사용할 수 있어야 하며, 또한 네이티브 코드를 생산해서 웹 코드와 상호 연동을 하여 개발 할 수 있어야 진정한 하이브리드 앱 개발 프레임워크라 말할 수 있기 때문이다.

Sencha Touch 자체도 훌륭한 웹 앱 개발 프레임워크이다. 하지만 하이브리드 앱의 효과와 진가를 느끼기 위해서는 반드시 Appspresso의 WAC와 네이티브 코드의 상호연동하는 방법을 이용해 보길 권유하고 싶다.

이 포스팅은 이렇게 Sencha에서 해결할 수 없는 것을 Appspresso에서 지원하는 plugins으로 WAC로 해결할 수 있는 것을 소개하고자 한다.
이 블로그에서 우리는 "네이티브 앱을 하이브리드 앱으로 전환"이라는 주제로 앱을 마이그레이션 하고 있었다. 이 네이티브 앱은 iOS와 Android가 가지고 있는 네이티브 Map을 포털 재도의 API로 새롭게 만든 Daum Map API를 사용하고 있었기 때문에 우리는 Daum Map V3 API로 Javascript 기반의 API로 하이브리드 앱을 만들 때, Sencha와 연동해서 사용할 수 있도록 개발하였다.
Sencha Touch 2에서는 Google Map을 API 레벨로 만든 Ext.MapPanel이 존재하지만 우리는 기존의 사용자에게 똑같은 지도 인터페이스를 제공하기 위해서 Sencha의 Map 컴포넌트를 사용하지 않고 Daum에서 제공하는 Map V3 API로 구현을 하였다. 이렇게 Sencha가 지원하지 않는 라이브러를 가지고 UI를 연동하다보니 Sencha가 가지고 있는 기능을 활용하지 못하는 경우가 생긴다.

<!--more-->

지금 우리의 문제점은 바로 "GeoLocation" 정보이다.

쉽게 GPS를 어떻게 활용할지에 대한 고민을 하게 된다. Sencha의 Map 컴포넌트에서는 HTML5의 GPS를 사용하는 코드를 API 레벨로 라이브러리화 시켜놓았지만 우리는 현재 Sencha의 기능을 사용할 수 없다. 이미 우리는 MapPanel 대신에 Daum Map을 일반  Ext.Panel에 추가해서 사용하기 때문이다. 그렇지만 우리는 Appspresso (앱스프레소)라는 하이브리드 개발 플랫폼에서 개발을 하고 있다는 것을 잊으면 안된다. 앱스프레소에 관련된 포스팅 중에 WAC에 관련된 글을 참조하길 바란다.

<앱스프레소의 WAC에 관련된 글>
* [Appspresso를 사용하여 하이브리드앱 개발하기 - 11.WAC Devicepai 사용하기](http://blog.saltfactory.net/136)
* [Appspresso를 사용하여 하이브리드앱 개발하기 - 12.WAC DeviceStatus 사용하기](http://blog.saltfactory.net/137)
* [Appspresso를 사용하여 하이브리드앱 개발하기 - 13.WAC AddressBook, Contact사용하기](http://blog.saltfactory.net/138)

앱스프레소는 WAC라는 표준으로 디바이스 자원에 엑세스하는 인터페이스를 제공하고 있기 때문에 앱스프레소 공식 사이트에 관련된 문서가 적어도 인터넷 상에서 사용되고 있는 WAC 코드를 모두 사용할 수 있다. 이렇게 표준규약으로 WAC를 이용해서 인터페이스를 구현한 앱스프레소 때문에 다양한 예제와 문서를 참조할 수 있다는 것은 정말 좋은 점인것 같다.

WAC 중에서 우리는 GeoLocation의 문제를 해결하기 위해서 navigator.geolocation을 사용할 것이다. (https://members.wholesaleappcommunity.com/currentspecs/deviceapis/geolocation.html)

앱스프레소에서 geolocation을 사용하기 위해서는 project.xml에서 geolocation plugins을 사용한다고 선택을 해야한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/192981ec-a564-4ff5-abeb-03361843f670)

그리고 우리가 [Appspresso를 사용하여 네이티브앱을 하이브리드 앱으로 전환 - 3.Sencha MVC 적용](http://blog.saltfactory.net/158) 글에서 fireEvent로 등록한 것 중에서 "위치끄기" 버튼에 대한 handler 메소드에 다음 코드를 입력한다. 이 버턴을 담당하는 controller는 MainController에서 담당하고 있다. MainController.js를 수정한다.

## navigator.geolocation

현재 위치를 찾기 위해서 navigator.geolocation.watchPosition(successCallback, errorCallback, options)를 이용해서 현재 위치의 자료를 모니터링 할 것이다. 단발적인 현재위 위치를 가져오기 위해서는 navigator.geolocation.getPosition 메소드를 이용하면 되고 위치의 변화를 계속적으로 모니터링하기 위해서는 navigator.geolocation.watchPosition 메소드를 이용한다. 이렇게 호출된 watchPosition의 객체는 특정 watchID를 리턴하며 이후에 GPS를 끄기 위해서 navigator.geolocation.clearWatch를 이용한다. watchPosition이 성공하면 받게되는 파라미터는 position정보이다. successCallback에서 이 position을 가지고 위도, 경도를  position.coords.latitude, position.coords.longitude로 가져와서 사용할 수 있다.
더해서 지도에다 일반지도, 하이브리드 지도를 선택할 수 있는 컨트롤러를 추가했고, 지도 확대,축소를 위한 사이즈 컨트롤러도 추가했다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

var map;
var markers;
var infowindows;
var selectedMarkerIndex;
var watchId = null;
var currentLocationMarker;
Ext.define('CWNUMap.controller.MainController', {
	extend: 'Ext.app.Controller',
	alias: 'MainController',
	config: {
		refs: {
			mainView:'MainView',
			buildingsView : 'BuildingsView'

		},
		control: {
			mainView:{
				openBuildingsViewCommand:'onOpenBuildingsViewCommand',
				findCurentLocationCommand:'onFindCurentLocationCommand'
			}
		}
	},
	onOpenBuildingsViewCommand:function(){
		console.log('onOpenBuildingsViewCommand');
		var buildingsView = this.getBuildingsView();
		Ext.Viewport.animateActiveItem(buildingsView, {type:'slide', direction:'up'});
	},
	onFindCurentLocationCommand:function(button){
		console.log('onFindCurrentLocationCommand');

		if(watchId == null){
			var options =  {enableHighAccuracy:true, timeout:27000};

			watchId = navigator.geolocation.watchPosition(function(position) {
			    	console.log("position: " + position.coords.latitude +"," + position.coords.longitude);
					button.setText(HBNString.main.rightBarButtonOff);


					var icon = new daum.maps.MarkerImage(
							'/images/marker.png',
							new daum.maps.Size(32, 32),
							new daum.maps.Point(16, 32)
							);

					currentLocationMarker = new daum.maps.Marker({
			            position: new daum.maps.LatLng(position.coords.latitude, position.coords.longitude),
			            image : icon
			        });
					currentLocationMarker.setMap(map);

					map.panTo(new daum.maps.LatLng(position.coords.latitude, position.coords.longitude));



		    },function(error){
		    	console.log("error:" +error.message);
		    }, options);

		} else{
			button.setText(HBNString.main.rightBarButton);
			navigator.geolocation.clearWatch(watchId);
			watchId = null;
			currentLocationMarker.setMap(null);
		}


	},


	init:function(){
		console.log('init MainController');
	},
	launch:function(){
		console.log('launch MainController');
		var mapContainer = Ext.get('cwnumap').dom;

		var position = new daum.maps.LatLng(35.2456, 128.692);
		map = new daum.maps.Map(mapContainer, {
			center : position,
			level : 4,
			mapTypeId : daum.maps.MapTypeId.HYBRID
		});


		var zoomControl = new daum.maps.ZoomControl();
		map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
		var mapTypeControl = new daum.maps.MapTypeControl();
		map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);


    	var request = {
			'url': 'http://json 요청 주소',
			'success': function(response){
				var json =  JSON.parse(response.data);
				var store = Ext.getStore('BuildingStore');
				store.setData(json.buildings);
		    	store.load({
		    		callback:function(){
		    			markers = new Array();
		    			infowindows = new Array();
		    			var i = 0;

		    			store.data.each(function(building){
		    				var _position = new daum.maps.LatLng(building.get('latitude'), building.get('longitude'));

		    				daum.maps.event.addListener(map, "click", function(){
		    					infowindows[selectedMarkerIndex].close();
		    				});

		    				markers[i] = new daum.maps.Marker({position : _position});
		    				markers[i].index = i;
		    				markers[i].setMap(map);

	    					infowindows[i] = new daum.maps.InfoWindow({
	    						content: '<p style="margin:7px 22px 7px 12px;font:12px/1.5 sans-serif;"><strong>' + building.get('name')+ '<br/>(' +building.get('alias') + ')' + '</strong></p>',
	    						removable : true
    						});

		    				daum.maps.event.addListener(markers[i], "click", function(){
		    					console.log(this.index);
		    					if(infowindows[selectedMarkerIndex] != null) infowindows[selectedMarkerIndex].close();
		    					selectedMarkerIndex = this.index;

		    					infowindows[this.index].open(map, markers[this.index]);
		    				});


		    				i++;
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

WAC 를 이용해서 현재의 위치를 모니터링하면서 변경된 위치의 정보를 새로운 custom marker로 지도위에 위치하도록 했다. 새로운 마크에 사용된 이미지는 /images/marker.png로 되어 있고 Daum Map V3 API에서 MarkerImage를 이용해서 추가했다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/4bf6935f-68e5-495e-8aef-ee663565a8d9)

그리고 "위치찾기" 버튼이 클릭되면 버튼의 텍스트를 "위치끄기"로 변경을 하기 위해서  기존의 rightBarButton에 등록한 handler 메소드와 fireEvent 메소드를 수정했다. MainView.js를 수정하자.

```javascript
/**
 * file : MainView.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.view.MainView', {
	extend : 'Ext.Container',
	alias : 'widget.MainView',
	config : {
		fullscreen : true,
		layout : 'vbox',
	},
	initialize : function() {
		this.callParent(arguments);

		var leftBarButton = {
				xtype : 'button',
				text : HBNString.main.leftBarButton,
				align : 'left',
				id : 'searchBuildingButton',
				handler : this.onLeftBarButton,
				scope : this
		};

		var rightBarButton = {
				xtype : 'button',
				text : HBNString.main.rightBarButton,
				align : 'right',
				id : 'currentLocationButton',
				handler : this.onRightBarButton,
				scope : this
		};

		var titleBar = {
				xtype : 'titlebar',
				title : HBNString.main.title,
				docked : 'top',
				items:[leftBarButton, rightBarButton]
		};

		var mapView = {
				xtype:'MapView',
		};

		 this.add([titleBar, mapView]);
	},
	onLeftBarButton : function() {
		console.log("onLeftBarButton");
		this.fireEvent("openBuildingsViewCommand");
	},
	onRightBarButton : function(element, event) {
		console.log("onRightBarButton");
		this.fireEvent("findCurentLocationCommand", element);
	}
});
```

그리고 버튼이 변경되면 text를 사용하기 위해서 /locales/string.js를 수정하자.

```javascript
/**
 * file : string.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

var HBNString = {
	config:{
		daumMapKey:''
	},
	main:{
		title: "창원대 맵",
		leftBarButton: "건물찾기",
		rightBarButton: "현재위치",
		rightBarButtonOff: "위치끄기"
	},
	buildings:{
		title: "건물찾기",
		leftBarButton: "닫기",
		rightBarButton: "찾기"

	}
};
```

## 결론

fireEvent로 MainController에게 전달하는 메소드에 button 을 전달해서 "위치찾기" 버튼을 제어하는 메소드 안에서 WAC의 navigator.geolocation.watchPosition을 이용해서 현재 위치를 찾아서 새로운 Marker를 표시해주고 화면도 이동을 시켜주도록 프로그램을 수정을 완료했다. 다시 새롭게 빌드해서 디바이스로 런칭해보자. GPS 가 활성화 되면서 현재 위치를 모니터링 할 수 있게 되었다. 네이티브 앱에서 현재 위치를 지도위에서 보는 것과 동일한 기능을 Appspresso가 제공하는 WAC를 이용해서 구현할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/eace2f14-4ada-4dba-aea0-5ae096ae5fb3)

## 참고

1. http://specs.wacapps.net/geolocation/index.html
2. https://members.wholesaleappcommunity.com/currentspecs/deviceapis/geolocation.html
3. http://dna.daum.net/apis/maps/v3
4. http://appspresso.com/api-reference/geolocation


