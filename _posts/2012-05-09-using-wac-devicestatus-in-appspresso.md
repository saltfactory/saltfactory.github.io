---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 12.WAC DeviceStatus 사용하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, wac, devicestatus]
comments: true
redirect_from: /137/
disqus_identifier : http://blog.saltfactory.net/137
---

## 서론

Appspresso로 하이브리드 앱을 만들 때 최고의 강점은 UI 개발을 단일 코드로 진행할 수 있다는 것이 아닌가 생각한다. 그러면 UI가 디바이스 종류와 상관없이 모두 동일해진다는 말이 된다는 이야기인데 우리는 기존 UX를 무시하고 무조건적으로 일방적으로 아이폰의 UX나 안드로이드의 UX를 강요하기 위해서 단일 UI를 만들어버릴 수 있다. 고객은 특정 모델에 따라 다른 UI를 요구할 수도 있다.  또는 UI에서 디바이스의 상태를 확인하기 기능을 넣기 원할 수도 있다. 배터리의 충전 상태나, 디바이스가 가속도 센스를 지원하는지, 또는 디스플레이의 상태에 따라서 다른 UI를 제공하고 싶어할 수도 있을 것이다. WAC의 deviceStatus를 이용하면 이런 문제를 쉽게 해결할 수 있다. 만약 이러한 속성을  Appspresso의 WAC를 사용하지 않는다면 아마도 네이티브 코드로 디바이스의 상태를 확인하고 stub method를 이용해서 javascript와 call by name으로 메세지 전송을 해야할 것이다. 그럼 WAC의 deviceStatus를 이용해서 얼마나 편리하게 디바이스 정보를 얻을 수 있는지 살펴보자.
(ADE의 Inspector의 사용법을 알고 있어야하기 때문에 이 방법에 대해서는 [Appspresso를 사용하여 하이브리드앱 개발하기 - 11.WAC Devicepai 사용하기](http://blog.saltfactory.net/136) 글을 참고한다.)

<!--more-->

## DeviceStatus

Appspresso에서 제공하고 있는 deviceStatus의 문서는 http://appspresso.com/api/wac/devicestatus.html 에서 확인할 수 있다.
deviceStatus에 대한 값을 가져오기 위해서는 deviceStatus의 getPropertyValue 메소드를 이용해서 획득할 수 있다. getPropertyValue에 필요한 인자들은 다음과 같다.

```
{PendingOperation} getPropertyValue(successCallback, errorCallback, prop)
```

이것을 좀 더 알기 쉽게 표현하면 다음과 같이 표현할 수 있다.

```javascript
var pendingOperation = deviceapis.devicestatus.getPropertyValue(
 	 function(value){
		 console.log(value); // success callback function
	 },  
	 function(error){
		 console.log("An error occurred " + error.message); // error callback function
	 },
	 {aspect:"aspect_name", component : "component_type", property:"property_name"} // property options
);
```

deviceStatus의 속성으로는 Aspect, Compoent, Poprety가 필요하다. WAC에 어휘집은 Aspect로 접근 가능하다. 단말에는 Aspect의 실체로 _default, _activty, _memory 등이 존재하고 표현하지 않을 때는 _default가 설정된다. 그리고 마지막으로 aspect의 component의 특정 속성으로 property가 존재한다.

먼저 compoent를 획득하기 위해서 deviceStatus.getCompoents(aspect)를 실행해서 확인해보자.
app.js에 다음 코드를 입력한다.

```javascript
var deviceapis = window.deviceapis;
var deviceStatus = deviceapis.devicestatus;

var components = deviceStatus.getComponents("Device");
console.log(components);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/a37786c2-796d-4baa-82fc-6a36e113daac)

지금 테스트하고 있는 디바이스는 iPod touch 2.1 세대 디바이스이다. 그 중에서 WAC로 접근할 수 있는 deviceStatus의 Device Aspect의 component는 "_default"만 존재한다. 이제 Device의 모델명을 가져오는 코드를 작성해보자.

```javascript
var deviceapis = window.deviceapis;
var deviceStatus = deviceapis.devicestatus;

var pendingOperation = deviceapis.devicestatus.getPropertyValue(
	 function(value){
		 console.log("This device model is : " + value); // success callback function
	 },  
	 function(error){
		 console.log("An error occurred " + error.message); // error callback function
	 },
	 {aspect:"Device", component : "_default", property:"model"} // property reference
);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/b71634f1-f16f-4f4c-af39-160456d5239c)

success callback function에서 aspect와 component와 property에 맞는 값을 획득해서 이벤트를 만들었다. 현재 연결된 iPod 2.1라는 것을 확인할 수 있다. 이렇게 모델명을 획득해서 모델명에 따라 다른 UI를 설정하거나 다른 기능을 추가, 삭제 할 수 있게 된다. 만약 디바이스의 해상도를 가져와서 그 해상도에 맞는 UI를 만든다고 가정해보자. 그러면 디바이스의 크기가 필요하다. 이럴 경우에는 aspect가 Display이고 property가 resolutionWidth를 이용해서 가져올 수 있다.

```javascript
var deviceapis = window.deviceapis;
var deviceStatus = deviceapis.devicestatus;

function successCallback(value){
	 console.log("This device model is : " + value);
}

function errorCallback(error){
	 console.log("An error occurred " + error.message);
}

var prop = {aspect:"Display", component : "_default", property:"resolutionWidth"};

var pendingOperation = deviceapis.devicestatus.getPropertyValue(successCallback, errorCallback, prop);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/4bf313c9-a615-4057-a1d4-1a67fd77fb81)

Nexus One ( android 폰)과 Apple의 iPod Touch를 연결해서 Device의 vendor를 확인해보았다.

```javascript
var deviceapis = window.deviceapis;
var deviceStatus = deviceapis.devicestatus;

function successCallback(value){
	 console.log("This device model is : " + value);
}

function errorCallback(error){
	 console.log("An error occurred " + error.message);
}

var prop = {aspect:"Device", component : "_default", property:"imei"};

var pendingOperation = deviceapis.devicestatus.getPropertyValue(successCallback, errorCallback, prop);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/3e409ec0-dfba-4525-ad6f-898eac54d87e)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/38ae5218-4164-42ba-bfa6-b83add59c3d9)

이렇게 하나의 코드로 디바이스 속성을 deviceStatus의 getPropertyValue를 이용해서 가져올 수 있다. Appspresso에서 지원하는 WAC의 deviceStatus Module의 접근할 수 있는 Aspect와 property 목록은 http://appspresso.com/api/wac/devicestatus.html 어휘집 테이블을 확인하고 적용하면 된다.

뿐만 아니라 디바이스의 상태를 감지해서 변화가 일어나면 상태를 변경된 이벤트를 감지하여 다른 작업을 할 수도 있다. 이렇게 변화를 감지해서 작업하는 메소드가 watchPropertyChange 메소드이다.

```javascript
var deviceapis = window.deviceapis;
var deviceStatus = deviceapis.devicestatus;

var prop = {aspect:"Battery", component : "_default", property:"batteryLevel"};
var option = {minNotificationInterval:60000};

function errorCallback(error){
	 console.log("An error occurred " + error.message);
}

function propertyChangeCallback(ref, value) {
	alert("New value for " + ref.property + " is " + value);
}

deviceapis.devicestatus.watchPropertyChange(propertyChangeCallback, errorCallback, prop, option);
```

이렇게 watchProertyChange를 이용해서 devicestatus에 이벤트를 추가해두면 property가 변경될 때 감지해서 동작하게 되는 것이다. 예제는 디바이스의 베터리가 변경(감소)되면 alert를 발생하게 하였다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8e42c0ff-37a1-49d0-b4df-c4d04329d9c9)

## 결론

Appsresso에서는 WAC를 사용할 수 있게 되어 있기 때문에, Device Status를 확인하기 위해서 디비아스 특징을 가져오는 네이티브 코드를 특별하게 만들 필요는 없다. 그렇다고 WAC가 디바이스의 모든 특징을 다 가져올 수 있는 것은 아니다. 경우에 따라서 spec에 빠진 것도 있고, 필요에 의해서 네이티브코드를 직접 작성해야 하는 일도 생길 수 있다. 하지만 기본적으로 제공해주는 deviceStatus를 이용해서 복잡한 코드를 줄일 수 있고, 간단하게 디바이스의 특징을 확인하여 작업할 수 있다. 뿐만 아니라, 디바이스의 물리적인 상태가 변경되는 것을 감지해서 새로운 이벤트나 작업을 추가할 수 있다는 것은 큰 메리트가 있는 것이다. 이를 구현하기 위해라면 NotificationCenter나 RunLoop를 이용해서 만들어야 하지만, WAC에서 제공하는 watchChangeProperty 메소드를 이용해서 쉽게 구현할 수 있다는 강점이 있다.

## 참고

1. http://appspresso.com/api/wac/devicestatus.html
2.http://appspresso.com/api/wac/symbols/WatchOptions.html

