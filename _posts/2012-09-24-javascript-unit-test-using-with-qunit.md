---
layout: post
title: QUnit을 이용하여 JavaScript 단위테스트하기
category: javascript
tags: [javascript, qunit, unit test]
comments: true
redirect_from: /194/
disqus_identifier : http://blog.saltfactory.net/194
---

## 서론

프로그램을 개발하면 설계만큼 중요한 것이 바로 테스트이다. 내가 만든 아주 간단한 프로그램(함수를 포함한 어떠한 프로그램)을 검증하기 위해서 단위 테스트는 개발 프레임워크에서 절대 빠져서는 안되는 중요한 것이다. 하지만 나를 포함한 대부분의 개발자는 개발공수가 부족하다는 이유로 단위 테스트를 가볍게 여기고 간단한 로깅으로 프로그램을 작성하기에 급급해 한다. 이렇게 단위 테스트를 하지 않고 프로그램을 작성하다가 어느날 갑자기 큰 오류가 발견되었는데 그 오류가 과연 어디에서 어떤 부분에서 오래가 발생했는지 알지 못해서 복잡한 코드의 흐럼을 하나하나 다시 스택이나 힙의 내부를 관찰하면서 디버깅을 할 것이다. 하지만 이미 엄창난 양의 코드에서 문제를 발견해내는 것이 쉽지 않다. 그래서 프로그램 단위가 끝나면 단위 테스트를 이행하여 프로그램의 그 프로그램 조작이 논리적으로 이상이 없는지, 문제가 없는 함수인지 또는 클래스나 프로그램인지 학인해서 코드의 복잡성과 별개로 단위별 코드의 품질을 높일 수 있어서 에러를 사전에 예방할 수 있다. 자바에서는 JUnit이라는 단위 테스트 라이브러리가 매우 강력하고 대부분 자바 프로그램에서는 JUnit을 사용하고 있다. 아이폰을 개발하는 Xcode에서도 Unit Test를 지원하기 위한 프레임워크가 내장되어져 있다. 그럼 Javascript에서 프로그램 단위 테스트를 하기 위한 라이브러리가 있을까?하고 찾게 되었는데 커뮤니티에서 QUnit을 많이 언급하고 있어 QUnit으로 단위 테스트를 하기 위해서 이 포스팅을 작성하였다.

<!--more-->

## QUnit

QUnit은 jQuery 형태의 단위 테스트를 지원하고 있고, jQuery와 jQuery UI와 연동해서 jQuery를 이용해서 개발한 Javascript 코드를 검증하기에 좋게 만들어져있다. 하지만 jQuery와 상관없이 일반적인 Javascript 자체를 검정할 수 있기 때문에 Javascript Application 을 개발한 뒤에 단위 테스트를 할 때 QUnit을 많이 활용하고 있다.

QUnit은 http://qunitjs.com 에서 다운 받을 수 있다. 그리고 http://benalman.com/talks/unit-testing-qunit.html 를 참조하면 QUnit에 대한 전반적인 이해를 쉽게 할 수 있을 것이다.

먼저 Javascript는 브라우저의 Javascript 인터프리터 엔진이 필요하기 때문에 브라우저에 HTML 파일을 생성해서 포함해야지만 Javascript가 동작하는 것을 확인을 할 수 있기 때문에 index.html 만든다. (나중에 따로 포스팅을 하겠지만 브라우저 없이도 Javascript 디버깅이 가능하다. 이 포스팅은 일반적으로 Javascript 단위 테스트를 하는 방법을 다루기 위해서 브라우저 없이 디버깅하는 방법은 다음 포스팅에 다룰 것이다.)
테스트할 파일의 구조는 다음과 같다. JSUnitTestTutorial 안에 index.html 파일이 있고 lib 디렉토리 안에 jQuery와 QUnit 파일들이 존재한다. 그리고 내가 테스트하기 위한 Javascript 파일은 test 라는 디렉토리에 생성하기로 한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/91791680-93a3-4181-8112-6b75b5a10bff)

### Javasctipt 테스트할 수 있는 HTML 파일

먼저 index.html을 다음과 같이 작성한다. 코드는 간단하다. QUnit의 결과를 나타낼 수 있는 DIV 엘리먼트를 포함하고 jQuery, QUnit 그리고 테스트하기 위한 test.js 파일을 로드하는 코드가 포함된 HTML 문서이다. jQuery와 QUnit 파일은 해당 사이트에서 가장 최근의 소스로 다운 받으면 된다.

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>QUnit Example</title>
  <link rel="stylesheet" href="lib/qunit/qunit.css">
  <script type="text/javascript" src="lib/jquery/jquery-1.8.2.min.js"></script>
</head>
<body>
  <div id="qunit"></div>
  <script src="lib/qunit/qunit.js"></script>
  <script src="test/tests.js"></script>
</body>
</html>
```

위 index.html 파일을 생성했으면 브라우저를 열어서 확인해보자. 테스트의 편리함을 위해서 Coda 2를 이용했다. 여러분이 편한 IDE를 선택해도 상관없고, IDE없이 터미널에서 테스트하고 브라우저를 열어서 확인해도 상관없다. 다만 Inspector가 지원되는 브라우저를 이용하길 바란다. Javascript를 개발할 때 브라우저에서 Inspector가 제공되지 않으면 디버깅하기 매우 힘들기 때문이다. 실행하면 다음과 같이 QUnit의 테스트 결과를 나타내는 UI가 로드되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0e176e66-a324-44d7-8490-57a9072fbbbc)

지금은 아무런 테스트 코드가 작성되지 않았기 때문에 0 tests of 0 passed, 0 failed. 라는 결과가 21milliseconds 만에 출력되었다.
이제 QUnit을 사용해서 간단한 단위 테스트를 해보자. QUnit의 테스트 함수는 test라는 함수 안에 테스트할 함수를 closure로 블럭 프로그램으로 테스트를 한다. jQuery를 사용하는 개발자에게는 익숙한 문법으로 여겨질 것이다.

### ok() assert

단위 테스트는 Assert를 이용해서 로직이 이상이 있는지 없는지를 테스트할 수 있다. JUnit을 사용해본 경험이 한번이라도 있으면 JUnit에서 가장 사용을 많이 하는 assertion이 바로 assertTrue() 라는 것이다. 이것은 assertTrue 안에 참인 로직을 가지면 단위테스트가 성공적으로 이루어졌다고 판단하는 것이다. 그럼 QUnit에서는 이 assertTrue()와 동일한 기능을 하는 것이 바로 ok()라는 것이다. 다음 코드를 test/tests.js 에 추가해보자

```javascript
test("hello test", function(){
	ok( 1==1, "Passed!");
});
```

그리고 페이지를 리로드해보자. (Coda 2 를 사용해서 테스트한다면 그냥 저장을 하면 preview는 자동으로 리로드가 된다) 위 코드는 test("테스트 메소드 이름", 테스트로직 함수); 라고 생각하면 된다. 테스트할 함수 안에 ok() assert는 1=1을 비교해서 문제가 없으면 정상적으로 진행하는 코드이다. 이 코드가 실행되면 아래와 같은 결과를 볼 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/b0430c5f-6fea-466f-bd4c-72de2ea480b4)

hello test 테스트 함수의 결과는 1 tests 가 있고 1 passed 를 했고 0 failed로 하나의 함수를 이상없이 단위 테스트를 수행했다는 결과를 보여주는데, hello test (0, 1, 1)은 0개의 에러, 1개의 성공, 1개의 테스트 함수를 의미한다. 다음과 같이 코드를 추가해보자. Javascript에서 혼돈을 일으키는 바로 Value의 비교이다. 1과 "1"의 값의 비교인데 같으면 정상적으로 passed가 될 것이지만 만약에 1 과 "1"의 value 가 다르면 fail이 발생할 것이다.

```javascript
test("hello test", function(){
	ok( 1 == 1, "Passed!");
	ok( 1 == "1", "Passed!");
});
```

다시 페이지를 리로드 해본다. 예상한 결과가 나왔는가? 아래 결과에서 보듯 Javascript에서는 1과 "1"의 value는 같다고 보고 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0f024302-43f2-43b4-a04c-a418d57b685c)

위 코드의 단위 테스트에서는 테스트 함수 안에 2가지의 assert 테스트가 있었기 때문에 2 tests of 2 passed, 0 failed. 결과가 나타났고 hello test(0, 2, 2)로 에러 0개, 성공 2개, 테스트 2개로 확인할 수 있다.

### equal() assert

assert 중에서는 equal assert가 존재한다. 위 코드를 다음과 같이 변경해보자.

```javascript
test("hello test", function(){
	ok( 1 == 1, "Passed!");
	ok( 1 == "1", "Passed!");
});

test("equal test", function(){
	equal(1, 1, "Passed!");
	equal(1, "1", "Passed!");
});
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f0853b6d-3bef-4693-b1c9-f2565fc8efd8)

### deepEqual() assert

QUnit의 assert에는 deepEqual()이라는 것이 있는데 이것은 value 뿐만 아니라 type까지 비교를 하는 assert이다. 다음 코드를 추가해보자.

```javascript
test("hello test", function(){
	ok( 1 == 1, "Passed!");
	ok( 1 == "1", "Passed!");
});

test("equal test", function(){
	equal(1, 1, "Passed!");
	equal(1, "1", "Passed!");
	deepEqual(1, "1", "1과 '1'은 서로 같음");
});
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/865252e7-37fe-4c01-acfc-24eb376c7ce3)

deepEqual()을 가지고 1과 "1"을 서로 비교했을때는 equal과 다르게 두 입력값의 원시 데이터타입, 오브젝트, 정규식등을 검사해서 다르다는 것을 확인하기 때문에 equal과 1failed이 발생 하였다.

### strictEqual() assert

QUnit 중에서는 strictEqual()이라는 것도 있는데 이것은 value와 type을 검사한다. 다음 코드를 추가해보자.

```javascript
test("hello test", function(){
	ok( 1 == 1, "Passed!");
	ok( 1 == "1", "Passed!");
});

test("equal test", function(){
	equal(1, 1, "Passed!");
	equal(1, "1", "Passed!");
	deepEqual(1, "1", "1과 '1'은 서로 같음");
});

test("stringEqual test", function(){
	strictEqual(1, "1", "1 and 1 are the same value and type");
});
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/2c724203-e3b9-4b89-8d1f-6fd239303d18)

예상했듯 strictEqual()은 1과 "1"의 value와 type을 동시에 비교하기 때문에 결과가 fail이 발생하는 것을 확인할 수 있다.

### expect()

QUnit의 단위테스트를 보면 test() 함수 안에 function(){} 블락안에 여러개의 assert를 테스트할 수 있다. 그렇기 때문에 assert가 정상적으로 테스트가 되는지, 포함하는게 몇개인지를 확인할 수 있는 것이 바로 expect()라는 것이다. 다음 코드를 살펴보면 테스트 블락 함수 안에 4가지의 assert 테스트가 있는데 expect에서 4가지로 지정을 했다. 테스트 블럭 함수가 길어져서 테스트의 갯수가 몇개인지 확인하거나 이 블럭함수에 들어있는 테스트가 몇개인지 지정할 때 사용하면 편리하다.

```javascript
test("hello test", function(){
	expect(4);

	ok( 1 == 1, "Passed!");
	ok( 1 == "1", "Passed!");
	equal(1, 1, "Passed!");
	equal(1, "1", "Passed!");
});
```  

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/45c9b333-a9a3-4732-a03a-bfa8fa28375b)

expect()의 조건이 정상적으로 만족하면 위과 같이 문제 없이 테스트가 진행되는데 만약 assert 테스트가 4가지인데 expect를 3으로 지정하면 다음과 같은 결과를 볼 수 있다. 즉 assert는 4가지인데 expected 3 assertions를 예상했다는 에러가 발생한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/6cc2d61f-1e5b-448c-a120-6e3000c2ec0c)

### module()

또 테스트함수가 너무 많아지면 자동화해서 볼 때 어느 테스트함수가 테스타가 되었는지 구분하기 힘들거나, 또는 서로 연관된 로직을 테스트할 때 그룹핑하고 싶을 경우가 있다. 이럴 때 module()을 사용하면 된다. 아래 코드는 gruop a와 group b를 모듈을 나누어서 각각 테스트를 진행한 것이다.

```javascript
module( "group a" );
test( "a basic test example", function() {
  ok( true, "this test is fine" );
});
test( "a basic test example 2", function() {
  ok( true, "this test is fine" );
});

module( "group b" );
test( "a basic test example 3", function() {
  ok( true, "this test is fine" );
});
test( "a basic test example 4", function() {
  ok( true, "this test is fine" );
});
```

결과는 다음과 같이 나타난다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ec5dc90e-dcb8-44b6-968a-1bea8238a454)

Javascript는 비동기 프로그램을 간단하게 사용할 수 있는 언어로 인기를 얻고 있다. 쉽게 Event 기반의 프로그램을 만들기도 하고 callback을 사용하기도 한다. 그럼 이렇게 비동기로 동작하는 함수들은 어떻게 테스트해야할까? 다음 코드는 twitter search api를 javascript로 호출하는 간단한 예제이다. jQuery의 $.getJSON을 이용해서 트위터에 jquery가 들어있는 트윗글을 가져와서 그 결과가 0보다 큰지 확인하는 비동기 함수이다. 이때 callback 메소드를 만들고 그 안에서 데이터가 다 처리되고 난 다음에 assert를 start하게 하는 코드이다. 이 테스트를 위해서는 javascript의 콜백함수를 만드는 방법에 대한 이해가 필요할 수 있다. [Javascript 콜백 구현하기](http://blog.saltfactory.net/192) 글을 참조하면 도움이 될 것이다.


```javascript
function twitterSearch(callback){
	$.getJSON("http://search.twitter.com/search.json?q=jquery", callback);
}


test("a async test", function(){
	expect(1)
	stop();
	twitterSearch(function(data){
		console.log("f1 : " + data.results.length);
		ok( data.results.length > 0, "tweet is not empty");
		start();
	});
});
```

## 결론

Javascript는 이제 Front-end 개발자 뿐만 아니라 웹 개발자에게 굉장히 고급언어로 인식이 바뀌어지고 있다. 뿐만 아니라 단순 웹 페이지를 만드는, HTML을 도와주는 스크립트 언어가 아니라 Web Application을 개발할 수 있는 개발언어로 활용하기 때문에 고급스럽고 대용량 코드 생산이 필요하게 되었다. 그래서 객체지향 프로그램에서 시도하던 여러가지 방법론이 Javascript 개발에 적용되기 시작했고 이미 많은 라이브러리들이 공개되어 고품질 코드 개발을 지원하고 있다. 단위 테스트는 고품질 코드를 만들어내는데 빠질 수 없는 핵심 개밥 방법이다. 또한 단독으로 코드를 만들던 이전과 달리 하나의 함수, 하나의 컴포넌트를 만들어서 서로 협업하는 작업 환경이 되면서 각자의 코드를 검정하는 방법은 단위 테스트 밖에 방법이 없다. 이런 의미에서 QUnit은 Javascript 단위 테스트를 위해 굉장히 편리한 인터페이스를 제공하고 있고 JUnit과 비슷한 assert 를 지원하고 있다. 뿐만 아니라 비동기 코드를 겅증할 수 있는 기능도 제공하고 있고 테스트한 결과를 브라우저를 통해 시각적으로 확인할 수 있는 환경을 제공하고 있다. 앞으로 웹 어플리케이션 개발에 QUnit을 사용하는 사례가 많아지길 기대해본다.

## 참조

1. http://api.qunitjs.com

