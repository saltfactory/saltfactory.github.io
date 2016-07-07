---
layout: post
title: Node.js를 사용하여 웹과 서버프로그램 동시에 사용 가능한 코드 개발하기
category: node
tags: [javascript, node]
comments: true
redirect_from: /197/
disqus_identifier : http://blog.saltfactory.net/197
---

## 서론

Rhino를 소개하면서 Javascript를 브라우저 없이 개발하는 방법을 소개했는데 이번 포스팅은 브라우저에서 동작하는 Javascript 코드가 아니라 서버에서 동작하는 Javascript를 소개한다. 뿐만아니라 브라우저 없이 서버에서 개발한 Javascript 코드를 웹 어플리케이션에서 동작하는 Javascript로 사용할 수 있는 것을 소개할 것이다. 브라우저가 아닌 곳에서 Javascript를 개발한다... 어쩌면 이것은 말이 안되는 이야기일 수도 있지만 V8 엔진이 등장하면서 그 이야기는 현실이 되었다. 뿐만아니라 nodejs 등장은 이미 개발자 사이에서 개발 방법론에 대한 변경이 일어날 정도로 큰 이슈가 되었다. nodejs에 대한 설명은 한 포스팅에 해결할 수 있을만큼의 분량이 아니다. nodejs는 점점 개발자들이 많아지고 있고 다양한 모듈들이 만들어지고 있기 때문에 앞으로 nodejs라는 주제로 포스팅을 계속 이어 갈 예정이다.
이 포스팅은 javascript 코드를 브라우저 없이 개발해서 서버와 웹 페이지에서 동일하게 사용할 수 있다는 것이 요점이기 때문에 nodejs에 대한 간략한 소개만 한다.
위키에서는 nodeJS에 대해서 다음과 같이 정의하고 있다.

> Node.js는 V8 (자바스크립트 엔진) 위에서 동작하는 이벤트 처리 I/O 프레임워크이다. 웹 서버와 같이 확장성 있는 네트워크 프로그램 제작을 위해 고안되었다.

위의 정의는 많은 기술이 포함되어 있지만 이번 포스팅에서는 V8 엔진 위에서 웹 서버 프로그램을 만들 수 있다는 것만 알고 설명한다. V8 엔진은 구글에서 개발한 오픈소스 JIT(Just In Time) 가상머신 형식의 자바스크립트 엔진이며 구글 브라우저와 안드로이드 브라우저에 포함이 되어 있다. V8 엔진은 ECMAScript-3의 규약으로 C++로 개발이 되어져 있는데 독립적으로 실행이 가능하다. nodejs는 이러한 V8 엔진위에서 동작을 하고 nodejs는 서버 프로그램을 작성할 수 있기 때문에 V8 위에 동작하는 Javascript 코드를 가지고 서버와 웹 어플리케이션에 돌아가는 코드를 동일하게 사용할 수 있는 것이다.

<!--more-->

## Node.js 설치

맥에서 Node.js를 설치하기 위해서는 http://nodejs.org/download/ 에서 자신에게 맞는 OS 환경의 바이너리 파일로 설치를 하면 된다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/974fee57-3cf6-4ea3-8093-868d0ffedb4d)

Mac 사용자라면 macport나 homebrew를 이용해서 설치도 가능하다. homebrew로 설치를 하기 위해서는 다음과 같이 인스톨을 할 수 있다.

```
brew install node
```

## Web 사이드

간단하게 javascript를 브라우저 없이 개발할 수 있는지 테스트를 해보자.

```javascript
/**
 * filename : person.js
 */
var Person = function (name) {
	this.name = name;
	this.hello = function () {
		return "Hello, My name is " + this.name + "!";
	}
}


var saltfactory = new Person('SungKwang');
console.log(saltfactory.hello());
```

위 Javascript 코드를 `test.html`에서 사용하다고 생각해보자.

```html
<!DOCTYPE HTML>
<html>
<head>
	<script src="person.js" type="text/javascript"></script>
</head>
<body>
<h1>nodeJS and Javascript<h1>
</body>
</html>
```

`test.html` 파일을 브라우저에서 열어보자. 브라우저에서 test.html을 열면서 javascript 를 해석하고 console에 로그를 남겼다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/cb16eeff-f7b8-419a-a8e6-d54905846a16)


## Server 사이드

이제 이 파일을 실행을 해보자.

```
node person.js
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/949e0f3f-4784-446f-8ba1-059f07325a17)

브라우저에서나 동작할만한 Javascript 객체가 정확하게 node를 이용해서 해석되고 있다는 것을 확인할 수 있다. 위 파일을 마치 하나의 Javascript 라이브러리 처럼 사용한다고 생각해보자. 즉, 여러가지 javascript 파일들이 존재하고 그 파일을 `<script type="filename" type="text/javascript"></script>`로 불러 들여서 사용하다고 가정해보자. 그래서 person.js를 좀더 유연하게 사용할 수 있게 변수 생성을 제거한다. 그리고 nodejs의 fs 모듈을 이용해서 외부 javascript 파일을 읽어서 eval을 한다.

```javascript
/**
 * filename : person.js
 */
var Person = function (name) {
	this.name = name;
	this.hello = function () {
		return "Hello, My name is " + this.name + "!";
	}
}
```

node 쉘에서 다음 코드를 실행한다.

```javascript
var fs = require('fs');
eval(fs.readFileSync('person.js', 'utf-8'));

var saltfactory = new Person("SungKwang");
var mushroom = new Person("YoungJi");

console.log(saltfactory.hello()):
console.log(mushroom.hello());
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/c585e099-bdf4-4cf9-9eae-16419fbd56ad)

이제 person.js를 좀더 다양하게 사용할 수 있게 되었다. 브라우저 없이 Javascript를 개발할 분만 아니라 서버에서 사용할 수 있는 javascript 프로그램을 만들 수가 있다.

그럼 javascript 프로그램으로 HTML에 Element를 엑세스할 수 있는 프로그램은 어떻게 개발을 할까? 우리는 Envjs를 이용해서 브라우저 시뮬레이션을 할 수 있었다. 하지만 Envjs는 rhino를 위한 라이브러이다. nodejs에서는 이와 비슷한 것을 jsdom으로 해결할 수 있다. nodejs에서는 nodejs 패키지를 설치하기 위해서 npm(Node Packaged Modules)이라는 것을 사용한다. npm을 설치하는 것은 간단하게 다음과 같이 설치할 수 있다.

```
curl http://npmjs.org/install.sh | sh
```

npm이 설치되어 있으면 npm으로 jsdom을 설치한다.

```
npm install jsdom
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8360ebd0-f753-4641-adcf-86d587a78888)

jsdom을 이용해서 HTML 파일을 열어서 접근해보도록 하자.

```javascript
/**
* filename : jsdom-test.js
*/

var jsdom = require('jsdom');
jsdom.env({
	html: "test.html",
	done: function(errors, window){
		console.log(window);
	}
});
```

그리고 node로 이 jsdom-test.js 파일을 실행시키면 test.html 을 읽어오는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e4308382-ee69-4b45-be1a-7c3ad79450b8)

HTML 파일을 로드했으니 Javascript로 HTML Element에 접근을 해보자. jsdom-test.js 파일을 다음과 같이 수정한다.

```javascript
/**
* filename : jsdom-test.js
*/

var jsdom = require('jsdom');
jsdom.env({
	html: "test.html",
	done: function(errors, window){

		console.log(window.document.getElementsByTagName('h1')[0].textContent);
	}
});
```

HTML 문서에 있는 h1의 Element의 텍스트를 가져오는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8cb5c187-a710-4e57-8a4d-4020c9531a21)

jsdom은 HTML 파일을 로드할 뿐만 아니라 로컬 javascript 파일을 로드도 한다. jQuery 파일을 로드해서 사용하려면 다음과 같이한다.

```javascript
/**
* filename : jsdom-test.js
*/

var fs = require('fs');
var jqueryjs = fs.readFileSync("./jquery-1.8.2.min.js").toString();

var jsdom = require('jsdom');
jsdom.env({
	html: "test.html",
	src: [jqueryjs],
	done: function(errors, window){
		var $ = window.$;
		console.log($("h1").text());
	}
});
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/98db538e-5295-47df-b361-7946aeaafb03)

Envjs도 원격의 HTML를 로드해서 사용할 수 있었는데 jsdom도 원격지의 HTML을 로드해서 로컬에서 Javascript 프로그램을 작성할 수도 있다.

```javascript
/**
* filename : jsdom-test.js
*/

var fs = require('fs');
var jqueryjs = fs.readFileSync("./jquery-1.8.2.min.js").toString();

var jsdom = require('jsdom');
jsdom.env({
	html: "http://blog.saltfactory.net",
	src: [jqueryjs],
	done: function(errors, window){
		var $ = window.$;
		console.log($("#overview h1:first").text());
	}
});
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/a9661a67-59a2-436f-b29c-434f60e5b06a)

## 결론

이전 포스팅에서 Rhino와 Envjs를 이용해서  브라우저 없이 Javascript Application을 만들 수 있다는 것을 확인했다. 그리고 이번 포스팅에서는 v8엔진에서 프로그램을 할 수 있는 nodejs 를 이용해서 서버 프로그램과 웹에서 사용할 수 있는 Javascript 코드를 함께 사용할 수 있는 것을 개발하는 방법을 소개했다. Javascript는 nodejs에서 서버프로그램을 할 수 있는 코드로 사용될 수 있는 이때 알고리즘, 자료구조, 모델 등 웹 어플리케이션과 서버에서 사용할 수 있는 코드를 개발을 할 수가 있다. 혹, 자바스크립트를 브라우저에서 개발하면 되는데 왜 이렇게 복잡하게 하는지에 대한 의문이 있다면 이렇게 말하고 싶다. Javascript는 HTML을 엑세스하는 단순한 언어가 아니라 변수와 메소드를 가진 객체를 만들어 객체 지향 프로그램이 가능한 언어이다. 그래서 여러 사람이 프로그램을 만들 때 UI를 핸들링하는 Javascript 프로그램을 만들거나 Operation만을 만들거나 또는 구조체나 모델만을 만드는 작업을 분업해서 작업을 한다면 모두가 브라우저를 열어서 개발하지 않아도 된다는 것이다. 각각 자신이 맡은 모듈을 만들어내면서 그것을 단위테스트를 통해서 검증하고 이후 웹 어플리케이션이나 서버 프로그램에서 동일한 Javascript를 사용할 수 있도록 만들어 낼 수 있다면 상당히 효율적으로 코드가 사용될 수 있을 것이라 예상된다. 에러없는 Javascript 개발에 한발짝 더 다가서기 위해서는 브라우저에 발생하는 에러를 제외한 알고리즘이나 자료구조와 단위테스트를 좀더 명확하게 할 수 있는 로컬 환경이 도움이 될 것이라 여겨진다. 다음 포스팅에서는 nodejs에서 단위테스트를 하는 방법에 대해서 포스팅을 할 예정이다.

## 참고

1. http://nodejs.org
2. https://github.com/tmpvar/jsdom


