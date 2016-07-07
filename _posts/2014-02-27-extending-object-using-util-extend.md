---
layout: post
title : util-extend를 이용하여 Object 확장하기
category : node
tags : [node, javascript, extend, object, util-extend]
comments : true
redirect_from : /231/
disqus_identifier : http://blog.saltfactory.net/231
---

## 서론

JavaScript 기반 프로그램을 작성할 때 Object를 확장해서 사용할 일이 발생한다. JavaScript 프로그램에서 파라미터로 options를 많이 사용한다. 설정 값을 저장하고 있는 options는 기본 값이 있고 값을 입력하지 않으면 기본 값이 적용되게 할 때 사용한다. 이때 오브젝트를 어떻게 확장해서 사용할 수 있는지 소개한다.

<!--more-->

## options 객체 예제

현재 Node.js는 개발자들이 많은 모듈을 만들어서 배포하고 있다. 우리가 Java 개발을 할 때 오픈소스로 개발된 .jar 를 이용해서 많은 복잡한 개발 시간을 단축시키는 것과 마찬가지로 Node.js로 프로그램을 개발할 때 많은 Node.js의 module이 복잡한 개발을 편리하게 해주고 시간을 단축 시켜줄 것이다. Node.js로 프로그램을 개발할 때 Object를 확장하거나 Default Options을 만들 일이 생긴다. 예를 들어 다음과 같다.

default_options을 만들어두고 사용자가 그 안에 들어가는 options를 입력할 때, 입력 받은 option은 덮어쓰기를 하고 나머지는 default option을 적용하고 싶을 경우이다. 다음을 살펴보자. 데이터베이스 커넥션을 만드는 프로그램에 default option으로 다음이 있다고 생각해보자.

* database_type을 입력 받는데, 만약 사용자가 입력하지 않을 경우는 mysql를 default로 한다.
* host를 입력 받는데, 만약 사용자가 입력하지 않을 경우는 localhost를 default로 한다.
* port를 입력 받는데, 만약 사용자가 입력하지 않을 경우는 3306을 default로 한다.
* database 이름을 입력 받는데, 만약 사용자가 입력하지 않을 경우는 아무런 database 값이 없는 것을 default로 한다.
* username을 입력 받는데, 만약 사용자가 입력하지 않을 경우는 root를 default로 한다.
* password를 입력 받는데, 만약 사용자가 입력하지 않을 경우는 아무런 비밀번호가 없는 것을 default로 한다.

위와  같이 default_options을 만든다면 다음과 같이 디폴트값을 만들 것이다.

```javascript
var default_options = {
		database_type:'mysql',
		host:'localhost',
		port:'3306',
		database:'',
		username:'root',
		password:''
	};
```

그리고 사용자는 위의 속성을 선택해서 입력한다고 가정하자. 즉, 사용자는 default mysql 커넥션 정보를 그대로 사용하고 싶고 username, password 그리고 database를 options으로 지정한다고 가정하자.

```javascript
var options = {
	database:'saltfactory_demo',
	username:'saltfactory',
	password:'password'
};
```  
그럼 default_options를 상속받아서 database, username, password만 덮어 써야한다. 이때 사용할 수 있는 좋은 Node.js의 module이 있는데 바로 util-extend라는 것이다. util-extend를 사용하기 위해서 npm으로 util-extend를 설치한다.

```
npm install util-extend
```

util-extend의 사용법은 간단하다. extend(default_object, object)로 하면 default_object에 object가 덮어쓰거나 확장할 수 있다.
다음을 살펴보자. default_object가 {a:1, b:2}이고 object가 {a:3}이라고 할 때, extend를 사용해서 default_object에 있는 a의 값을 object가 가지고 있는 a의 값인 3으로 덮어쓰기를 하고, default_object가 가지고 있는 나머지 속성은 그대로 가지게 된다.

```javascript
var extend = require('util-extend');

var default_object = {a:1, b:2};
var object = {a:3};

var extended_object = extend(default_object, object);
console.log(extended_object);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/488c09fc-90c2-497c-b307-2cd238d7f9da)

이 예제는 default_object 안에 있는 속성과 object의 속성이 같은 이름이 있을때 기본 값을 새로운 값으로 덮어쓰는 예제인데, util-extend라는 이름으로 알듯, Object를 extend 시킨다. Java의 extend와 마찬가지로 속성을 이름이 같을 경우 값을 덮어쓰고 새로운 값이 있으면 새로운 Object에 그 값을 추가할 수 있다. 다음 예제를 살펴보자. default_object에 있는 a를 덮어쓰고 default_object에 없는 c를 추가하고 싶은 예제이다.

```javascript
var extend = require('util-extend');

var default_object = {a:1, b:2};
var object = {a:3, c:4};

var extended_object = extend(default_object, object);
console.log(extended_object);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/56516c17-69c5-4a85-9433-4dbd7944232c)

결과는 예상했듯 default_object에 같은 이름을 가지고 있는 속성은 덮어 쓰기를 하고, 새로운 Object에 없는 값은 그대로 가져왔다. 뿐만 아니라 default_object에는 없고 새로운 Object에 있는 속성을 확장해서 만들어 냈다는 것을 확인할 수 있다.

이젠 util-extend를 사용해서 앞에서 우리가 생각한 프로그램을 만들어보자. database connection을 위한 default_options가 있고 사용자가 options를 입력 받는다고 생각해보자. 아마 프로그램은 다음과 같이 만들 수 있을 것이다. 예제 프로그램은 아주 간단한 function 하나만 있다. 실제 다른 module의 options을 처리하는 곳을 살펴보면 이와 비슷하게 사용하고 있다는 것을 확인할 수 있을 것이다.

```javascript
var extend = require('util-extend');

function connect(options){
	var default_options = {
		database_type:'mysql',
		host:'localhost',
		port:'3306',
		database:'',
		username:'root',
		password:''
	}

	var activity_options = extend(default_options, options);
	console.log(activity_options);
}


var options = {
	database:'saltfactory_demo',
	username:'saltfactory',
	password:'password'
}


connect(options);
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/82094d41-3546-4f94-8b41-922b7d0a4b60)


## 결론

Node.js로 프로그램을 만들때 options을 설정하거나 params을 설정하고 넘겨줘야할 일이 많아진다. 이때, default 값을 지정하고 다이나믹하게 Object를 확장해야하는 일이 많아 진다. 이는 Java의 Class를 extend로 상속받는 개념과 비슷하다. Node.js는 다양한 module이 많은데 우리가 원하는 것을 util-extend로 간단하게 해결할 수 있다. 실제 Node.js의 module을 설치하고 소스코드를 살펴보면 options를 처리하는 부분에 util-extend를 사용하는 모듈을 많이 볼 수 있을 것이다. options을 처리할 뿐만 아니라 다이나믹하게 params을 처리할 경우, 즉, 넘겨 받은 Object에 새로운 속성을 추가해서 Object를 다시 넘겨주거나 처리해야할 때 util-extend는 복잡한 처리 과정을 간단하게 처리할 수 있게 도와줄 것이다.

## 참고

1. https://github.com/isaacs/util-extend

