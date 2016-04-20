---
layout: post
title: Appspresso를 사용하여 네이티브앱을 하이브리드 앱으로 전환 - 3.Sencha MVC 적용
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, sencha, mvc]
comments: true
redirect_from: /158/
disqus_identifier : http://blog.saltfactory.net/158
---

## 서론

이번 포스팅에서는 Appspresso를 사용해서 Sencha의 MVC (http://blog.saltfactory.net/category/Sencha) 기반으로 앱을 만드는 과정을 소개한다. 이전 아티클에서 상단 타이틀바 왼쪽에 위치한 "건물찾기"라는 버턴을 누르면 새로운 View가 열리게되고 이들 각각의 View와 Controller가 어떻게 상호 연동되어서 이벤트를 핸들링하는지, 이 때 Controller와 View에서 Model과 Store를 어떻게 활용하는지에 대한 내용도 포함이 되어 있다.

[Appspresso를 사용하여 하이브리드앱 개발하기 - 18.Sencha Model과 원격데이터 요청](http://blog.saltfactory.net/156)에서 Appspresso(앱스프레소)의 plugins인 ax.ext.net.curl를 이용해서 서버로  json 형태의 데이터를 요청해서 json 데이터를 Sencha의 Model로 정의된 Store를 이용해서 다음 맵 API로 지도위에 Marker를 추가하는 작업을 하였다. 이때 우리는 Store 개념을 이해했을거라 예상된다. 한번 load된 Store를 재활용하는 방법도 이 글에서 소개된다. 이번 포스팅은 복잡도가 높은 편이다. 개념적으로 뷰에서 event를 핸들링하기 위해서 controller에서 view의 identifier로 찾아서 처리했던 부분을 View 마다 widget으로 인식해서 해당되는 widget 안에서 이벤트를 fireEvent로 등록해서 전파하는 방법을 사용하기 때문이다. 이 방법을 사용하기 위해서 우리는 단순하게 alias로 사용했던 View를 모두 widget으로 변경하는 작업을 할 것이다. 그리고 앱에서 필요한 View를 추가하고 각 View를 핸들링할 수 있는 Controller를 추가할 것이다. 복잡한 코드와 설명인만큼 주의하여 같이 진행해보도록 하자.

<!--more-->

## View

이전의 코드에서 View를 widget형태로 사용하기 소스코드를 변경하는 작업을 진행한다. 이 때 우리는 필요한 View를 추가해서 만들 것이다.
우선 변경전의 코드를 살펴보자

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

단순하게 items에 등록했던 컴포넌트들을 각각 버턴의 handler를 등록하고 그 handler를 controller에게 전파하기 위해서 scope를 지정할 것인데 이 객체자체를 scope로 상용하기 위해서 다음과 같이 코드를 변경한다.

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
//		items : [ {
//			xtype : 'titlebar',
//			title : HBNString.main.title,
//			docked : 'top',
//			items : [ {
//				xtype : 'button',
//				text : HBNString.main.leftBarButton,
//				align : 'left',
//				id : 'searchBuildingButton',
//				handler : this.onLeftBarButton,
//				scope: this
//			}, {
//				xtype : 'button',
//				text : HBNString.main.rightBarButton,
//				align : 'right',
//				id : 'currentLocationButton',
//				handler : this.onRightBarButton,
//				scope: this
//			} ],
//			flex : 1
//		}, {
//			xtype : 'panel',
//			flex : 2,
//			id : 'cwnumap'
//		} ]
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
	onRightBarButton : function() {
console.log("onRightBarButton");
this.fireEvent("findCurentLocationCommand");
	}
});
```

위 코드에서는 이전에는 xtype:panel 위에다가 지도를 만들었지만 변경된 코드에서는 아예 MapView라는 widget을 하나더 추가해서 사용하기로 했다.

```javascript
/**
 * file : MapView.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.view.MapView', {
	extend : 'Ext.Panel',
	alias : 'widget.MapView',

	config : {
		id: 'cwnumap',
		layout: 'vbox',
		height: '100%',
		width: '100%',
		centered: true
	},
	initialize:function(){
		console.log('init MapView');

	}
});
```

이렇게 추가된 View는 app.js에 등록을 해준다.

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
    views: ['MainView','MapView'],
    controllers: ['MainController'],

    launch: function() {
    	var mainView = {
    			xtype:'MainView'
    	};

    	Ext.Viewport.add(mainView);
    }
});
```

위 MainView.js 코드를 다시한번 설명하자면 leftBarButton의 handler로 이 Container가 가지고 있는 this.onLeftBarButton에 등록된 메소드를 지정을 한다. 그런데 이 메소드는 이벤트를 일어나면 단순하게 로그만 찍는 일을 하고 this.fireEvent()를 호출한다. fireEvent는 전달된 파라미터를 가지고 특정 이벤트를 addListener를 내부로 등록하는 것인데 쉽게 말하자면 이벤트를 관측하고 있는 Controller에게 이름을 가지고 이벤트를 전파한다고 생각하면 된다. 이건 iOS에서 NSNotificationCenter와 비슷하게 동작하는것 같다. 그럼 Controller에 어떻게 이 전파되는 것을 인지할 수 있는지 다음 코드를 살펴보자. 이해를 돕기 위해서 MainController의 refs와 control 부분만 비교한다.

## Controller

이전 MainController의 코드는 아래와 같았다.

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
... 생략
```

하지만  widget으로 변경된 View와 그 View 안에서 전파하는 이벤트를 받기 위해서 다음과 같이 수정이 된다. 이전에서 Controller에서 View 안에서 HTML의 Element의 identifer를 가지고 찾아서 handler 메소드를 tap이란 이벤트가 일어나면 동작해야할 메소드를 연결했지만, 새롭게 변경된 View에서 이벤트가 동작하면 Controller로 이벤트를 전파하기 위해서는 widget으로 등록된 각 View를 지정하고 각 View 마다 전파되는 이름으로 처리하는 메소드를 제어하도록 설정하게 변경되었다. 아래에서는 변경된 예제의 샘플로 MainView와 BuildingsView 두가지를 이 Controller에서는 refs 로 참조하고 있다. 이렇게 여러가지 View를 Controller에서 관리하기 때문에 onOpenBuildingsViewCommand를 살펴보면 이 Controller에서 refs로 참조하는 buildingsView를 this.getBuildingsView() getter 메소드로 가져와서 기존의 Viewport에 쉽게 추가하여 새로운 View로 전환할 수가 있는것이다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

var infowindow;
var map;
var markers;
var infowindows;
var selectedMarkerIndex;
Ext.define('CWNUMap.controller.MainController', {
	extend: 'Ext.app.Controller',
	alias: 'MainController',
	config: {
		refs: {
			mainView:'MainView',
			buildingsView:'BuildingsView'
//			currentLocationButton:'#currentLocationButton',
//			searchBuildingButton:'#searchBuildingButton'
		},
		control: {
			mainView:{
				openBuildingsViewCommand:'onOpenBuildingsViewCommand',
				findCurentLocationCommand:'onFindCurentLocationCommand'
			}
//			currentLocationButton: {
//				tap : 'onCurrentLocationButton'
//			},
//			searchBuildingButton: {
//				tap : 'onSearchBuildingButton'
//			}
		}
	},
	onOpenBuildingsViewCommand:function(){

		var buildingsView = this.getBuildingsView();

		Ext.Viewport.animateActiveItem(buildingsView, {type:'slide', direction:'up'});

		console.log('open buildingsView');
	},
	onFindCurentLocationCommand:function(){
		console.log('find location');
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

... 생략
```

## Model 사용

새로운 뷰를 전환하는 설명은 다시 자세히 설명하도록 하고 우선 이전에 코드에서 변경된 MainController.js의 코드는 다음과 같다. 기존의 HTML의 element의 identifier를 가지고 핸들링 메소드를 설정한 것과 달리 변경된 코드에서는 fireEvent로 전파하는 이벤트의 이름으로 핸들링 메소드를 설정하였다. 그리고 이전 코드에서는 HTML의 document.getElementById('cwnumap')으로 가져와서 그 위에서 다음 지로를 추가하였지만 View가 widget으로 변경되면서 접근하는 방법이 Ext.Get('cwnumap').dom 으로 변경이 되었다. 뿐만 아니라 나중에 건물 목록중에 선택된 목록을 지도에서 이동하거나 infowindow를 보여주기 위해서 Store에 저장된 Building을 이터레이션하면서 각각 markers오 infowindows의 Array로 저장하게 변경하였다. 아래의 Controller 의 가장 큰 변화는 fireEvent를 제어하는 것과 widget 형태의 View를 refs로 참조하는 것이다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

var map;
var markers;
var infowindows;
var selectedMarkerIndex;
Ext.define('CWNUMap.controller.MainController', {
	extend: 'Ext.app.Controller',
	alias: 'MainController',
	config: {
		refs: {
			mainView:'MainView',
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
	},
	onFindCurentLocationCommand:function(){
		console.log('onFindCurrentLocationCommand');
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

앱을 실행해보면 "건물찾기"와 "현재위치" 버튼을 클릭하면 각각에 handler의 메소드들이 동작하고 그 안에서 fireEvent로 Controller에게 전파해서 Controller가 refs와 conrol로 제어하는 해당되는 핸들러 메소드를 실행하게 되는 결과를 확인할 수 있다. 나머지 지도에 관련된 변경된 코드는 이전 아티클과 동일하게 동작하기 때문에 설명을 생략한다. 다만 주의해야할 부분은 이전에는 document.getElementById로 panel 을 찾은 부분을 Ext.Get().dom으로 찾았다는 것을 주의한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c4ddf78d-0b7e-42d7-9cea-392d76f2fea5)

이제 건물찾기를 하면 새로운 BuildingsView.js 가 열리면서 건물목록이 List 형태로 출력이 되는 뷰를 추가할 것이다. /js/app/view/BuildingsView.js를 추가한다. MainView.js와 동일하게 View안에 일어나는 이벤트를 Controller로 전파하기 위해서 fireEvent를 handler 메소드안에 등록하도록 한다. 다만, 이 BuildingsView 안에는 BuildingsList 라는 리스트 뷰가 하나 추가되어 있는데 각 row를 클릭할 때마다 onSelectItem이라는 handler가 동작하게 하고 그 안에서 fireEvent를 추가할때 파라미터를 함께 전달할 수 있도록 했다. 이유는 해당되는 빌딩의 index를 가지고 앞에서 Store를 가지고 저장한 marker와 infowindow를 찾기 위해서 이다. 그리고 BuildingsList에 이전에 MainController에서 load했던 Store를 그대로 재활용하기 위해서 Ext.getStore('BuildingsStore')를 이용했다. 이렇게 한번 load된 Store를 앱에서 어디서든지 getStore로 불러서 활용할 수 있다.

```javascript
/**
 * file : BuildingsView.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.view.BuildingsView', {
	extend : 'Ext.Container',
	alias : 'widget.BuildingsView',

	config : {
		fullscreen : true,
	},

	initialize : function() {
		this.callParent(arguments);

		var leftBarButton = {
			xtype : 'button',
			text : HBNString.buildings.leftBarButton,
			align : 'left',
			id : 'closeButton',
			handler : this.onLeftBarButton,
			scope : this
		};

		var rightBarButton = {
			xtype : 'button',
			text : HBNString.buildings.rightBarButton,
			align : 'right',
			id : 'searchButton',
			handler : this.onrightBarButton,
			scope : this
		};

		var titleBar = {
			xtype : 'titlebar',
			title : HBNString.buildings.title,
			docked : 'top',
			items : [ leftBarButton, rightBarButton ]
		};

		var buildingsList = {
			xtype : 'BuildingsList',
			store : Ext.getStore('BuildingStore'),
                        listeners: {
                            itemtap: { fn: this.onSelectItem, scope: this }
                        }
		};

		this.add([titleBar, buildingsList]);
	},
	onLeftBarButton : function() {
		console.log('onLeftBarButton');
		this.fireEvent('closeBuildingsViewCommand');
	},
	onRightBarButton : function() {
		console.log('onRightBarButton');
		this.fireEvent('findCurentLocationCommand');
	},
        onSelectItem:function(view, index, item, e){
 	   console.log('selectItemCommand');
 	   this.fireEvent('selectItemCommand', index);
        }

});
```

그리고 BuildingsView에서 사용하는 BuildingList를 /js/app/view/BuildingsList.js 로 추가한다. 이 List는 Sencha의 Ext.dataview.List를 상속받아서 내가 원하는 형태로 출력하기 위해서 만든 Custom List 이다. 각각의 row는 itemTpl 안에 HTML 코드로 수정이 가능하며, 이 때 template 안에 데이터를 넣기 위해서는 {}를 이용한데 Store에 저장된  Model의 속성 키의 이름으로 접근이 가능하다.

```javascript
/**
 * file : BuildingsList.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define("CWNUMap.view.BuildingsList", {
    extend: "Ext.dataview.List",
    alias: "widget.BuildingsList",
    id:'BuildingsList',

    config: {
    		layout: 'vbox',
    		height: '100%',
    		width: '100%',
    		centered: true,
    		loadingText: "Loading Buildings...",
    		emptyText: "<div class=\"notes-list-empty-text\">No buildings found.</div>",
    		onItemDisclosure: false,
    		itemTpl: "<div class=\"list-item-title\">{name}</div><div class=\"list-item-narrative\">{alias}</div>",
    },

    initialize:function(){
    	this.callParent(arguments);
    }
});
```

뷰를 추가했으니 app.js에 등록을 하자. 그리고 앱이 실행할때 미리 view를 추가해서 Viewport에 넣어두었다. 이유는 나중에 서로 다른 view 간에 전환을 Controller를 통해서 할텐데 그 때 이미 만들어진 View를 이용해서 이동하기 위해서이다.

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
    views: ['MainView', 'MapView', 'BuildingsView', 'BuildingsList'],
    controllers: ['MainController'],

    launch: function() {
    	var mainView = {
    			xtype:'MainView'
    	};

    	var buildingsView = {
    			xtype:'BuildingsView'
    	};

    	Ext.Viewport.add([mainView, buildingsView]);
    }
});
```

뷰가 추가가 되었으니 MainView에서 "건물찾기" 버턴을 누르면 새로운 BuildingsView가 나타날 수 있도록 MainView를 담당하고 있는 MainController.js를 수정하자. BuildingsView로 등록된 뷰를 refs로 참조하고 있고 이렇게 참조된 View는 this.getBuildingsView()로 getter 메소드로 가져올수 있다. 그리고 Viewport에 animation과 함게 activityItem으로 지정하게 한다. 이 때 slide 형태의 animation으로 위로 나타나는 효과를 적용했다.

```javascript
/**
 * file : MainController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://hibrain.net
 * license : CCL (Not commercial)
 */

var map;
var markers;
var infowindows;
var selectedMarkerIndex;
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
	onFindCurentLocationCommand:function(){
		console.log('onFindCurrentLocationCommand');
	},


	init:function(){
		console.log('init MainController');
	},
	launch:function(){
... 생략
	}

});
```

이제 앱을 새로 실행시키고 MainView에서 "건물찾기"라는 뷰를 동작시키면 다음과 같이 BuildingsView가 나타나는데 이때 BuildingsList 에 이전에  로드한 Store를 가지고 Ext.dataview.list의 store 속성으로 반복해서 출력하도록 구현된 뷰를 볼 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/cd3db0eb-f75e-466f-9715-dc5563cf0692)  

이제 이 List에서 row를 선택하여 하나의 Item이 가지고 있는 정보를 가지고 지도를 이동하고 marker에 infowindow를 나타나게하면서 BuildingsView를 닫는 행위를 "닫기"라는 버턴이 눌러졌을때 일어나도록 BuildingsView를 관찰하는 BuildingController를 추가할 것이다.
/js/app/contorller/BuildingController.js를 추가하자. MainController.js와 동일하게 refs로 각각의 view를 참조하게 설정한다. 반드시 존재하는 view를 모두 참조할 필요는 없다. 이 Controller에서 사용하는 뷰만 refs로 지정한다. 그리고 BuildingsView에서 Controller에게 이벤트를 전파하려고 등록한 fireEvent의 이름과 각각에 처리하는 메소드를 연결한다.

```javascript
/**
 * file : BuildingController.js
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

Ext.define('CWNUMap.controller.BuildingsController', {
	extend: 'Ext.app.Controller',
	alias: 'BuildingsController',
	config: {
		refs: {
			mainView:'MainView',
			buildingsView:'BuildingsView'
		},
		control: {
			buildingsView:{
				closeBuildingsViewCommand:'onCloseBuildingsViewCommand',
				findCurentLocationCommand:'onFindCurrentLocationCommand',
				selectItemCommand:'onSelectItemCommand'
			}
		}
	},
	onSelectItemCommand:function(index){

		var building = Ext.getStore('BuildingStore').data.items[index];
		map.panTo(new daum.maps.LatLng(building.get('latitude'), building.get('longitude')));

		if(infowindows[selectedMarkerIndex] != null) infowindows[selectedMarkerIndex].close();

		this.onCloseBuildingsViewCommand();

		selectedMarkerIndex = index;
		infowindows[selectedMarkerIndex].open(map, markers[selectedMarkerIndex]);

	},
	onCloseBuildingsViewCommand:function(){
		console.log('onCloseBuildingsViewCommand');
		Ext.Viewport.animateActiveItem(this.getMainView(), {type:'slide', direction:'down'});
	},
	onFindCurrentLocationCommand:function(){

	},
	init:function(){
		this.callParent(arguments);
		console.log('init BuildingsController');
	},
	launch:function(){
		this.callParent(arguments);
		console.log('launch BuildingsController');
	}
});
```

컨트롤러를 추가했으니 app.js에 추가하도록 한다.

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
    views: ['MainView', 'MapView', 'BuildingsView', 'BuildingsList'],
    controllers: ['MainController', 'BuildingController'],

    launch: function() {
    	var mainView = {
    			xtype:'MainView'
    	};

    	var buildingsView = {
    			xtype:'BuildingsView'
    	};

    	Ext.Viewport.add([mainView, buildingsView]);
    }
});
```

이제 앱을 새로 실행시키면 BuildingsView에서 각 행을 누를 때 마다 선택한 건물 정보를 가지고 maker로 이동하고 infowindow를 나게 하면서 열렸던 BuildingsView를 닫는 행위를 Controller에 의해서 제어된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/37fb22af-b344-4e03-91e9-232bf7a33673)

나머지 사용되었던 파일 코드를 추가한다.
먼저 list의 item의 높이를 변경하기 위해서 css를 추가하였다. /css/master.css

```css
/**
 * file : master.css
 * author : saltfacotry
 * email : saltfactory@gmail.com
 * copyright : http://www.hibrain.net
 * license : CCL (Not commercial)
 */

.list-item-narrative {
	color:#ccc;
	font-size: 0.7em;
}

.x-list .x-list-item, .x-list .x-list-item .x-list-item-label {
  min-height: 44px;
}

.x-list .x-list-item .x-list-item-label
{
	padding: 5px 8px 5px 8px;
}

```

BuildingsView.js에 사용된 문자열을 관리하기 위해서 /locales/string.js 변경 작업이 있었다.

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
	},
	buildings:{
		title: "건물찾기",
		leftBarButton: "닫기",
		rightBarButton: "찾기"

	}
};
```

css 파일을 추가하기 위해서 index.html 파일 수정 작업이 있었다.

```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<script src="/appspresso/appspresso.js"></script>
		<link rel="stylesheet" href="/lib/sencha/sencha-touch.css" type="text/css"/>
		<link rel="stylesheet" href="/css/master.css" type="text/css"/>
		<script src="/lib/sencha/sencha-touch-all-debug.js" type="text/javascript" charset="utf-8"></script>
		<script src="/locales/string.js" type="text/javascript" charset="utf-8"></script>
		<script src="/js/app/app.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" src="http://apis.daum.net/maps/maps3.js?apikey=다음 지도 인증키"></script>

		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
		</script>

	</head>
	<body>
	</body>
</html>
```

이렇게 MVC를 이용해서 두개의 View에 각각 이벤트를 각각 Controller로 연결을 하고 해당 Controller에서 다른 View로 전환을 Controller에서 담당을 했다. 뿐만 아니라 Controller에서 Model을 기반으로 Store로 데이터를 만들고 그것을 각각 View에서 사용할 수 있었다. 그래서 데이터를 저장하는 코드, 데이터를 표현하는 코드, 이벤트를 제어하는 코드를 각각 나누어서 MVC 기반으로 전반적으로 프그램이 완성되었다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/259a2da1-9e6f-4fb5-9735-7a3d2531c5d6)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e6a9fa45-9221-486a-b643-7604e02e6558)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b2faaef0-3443-4d46-b290-8afac3a1fa25)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ea071726-19f2-4a80-8013-231a24989e8f)

## 결론

이렇게 Appspresso(앱스프레소)와 Sencha Touch 2의 MVC를 이용해서 하이브리드앱을 만드는 방법에 대해서 살펴보았다. 다음은 포스팅에는 Appspresso의 WAC를 이용해서 Location 정보를 이용하여 하이브리드 앱에 적용하는 방법에 대해서 포스팅을 할 예정이다.

## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.mixin.Observable-method-fireEvent
2. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-1/
3. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-2/
4. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-3/
5. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-4/
6. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-5/


