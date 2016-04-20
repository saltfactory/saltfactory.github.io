---
layout: post
title: IntelliJ와 JSTestDriver를 이용하여 JavaScript 단위테스트하기
category: javascript
tags: [javascript, intellij, jstestdriver, unit test]
comments: true
redirect_from: /204/
disqus_identifier : http://blog.saltfactory.net/204
---

## 서론

Javascript가 더이상 팝업이나 만들어주는 웹 페이지 embed script code가 아니라 웹 어플리케이션을 만드는 고수준 언어로 인식되면서 기존의 다양한 어플리케이션 개발 방법론으로 Javascript 개발에 적용되고 있다. 이 블로그에서 QUnit을 이용해서 브라우저에서 Javascript를 단위 테스트하는 방법(http://blog.saltfactory.net/194)을 소개한적이 있다. 보통 Java 웹 프로그램을 개발하면서 Javascript를 View를 개발하면서 많이 개발할 것으로 예상이 된다. (물론 고급 방법은 MVC를 분업해서 View만 다른 IDE를 통해서 개발하겠지만 작은 연구소나 중소기업에서는 웹 프로그래머들이 Java 웹 프로그램도 개발하고 front-end 개발도 동시에 할 것이다.)

그래서 IntelliJ에서 Javascript를 단위 테스트하는 방법을 소개하려고 한다. IDE는 보통 자신이 가지고 있는 Testing Tool이 포함이 되어 있다. IntelliJ의 JetBrain에서 Javascript Application 개발 툴로 WebStorm이 있는데 이 IDE에는 JSTestDriver라는 Javascript Testing Tool이 포함이 되어 있다. 하지만  IntelliJ는 Java Application 개발 툴로 JSTestDriver가 없기 때문에 Plugins으로 설치를 해야한다.  

<!--more-->

## JSTestDriver

js-test-driver는 remote javascript testing 툴로 다양한 브라우저에 Javascript가 동작하는 것을 캡처링하여 단위 테스트를 하는 테스팅 툴이다. js-test-driver는 오픈소스 프로젝트로 http://code.google.com/p/js-test-driver/ 에서 보다 자세한 자료를 참고할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c295781f-3b52-4321-9909-174b2ab64f43)

js-test-driver는 IntelliJ 뿐만 아니라 eclipse에서도 plugins을 설치해서 Javascript를 테스트 할 수 있다. 연구소에서 IntelliJ를 Java 개발 IDE로 선택해서 개발하고 있기 때문에 이 포스팅에서는 IntelliJ에서 Javascript를 js-test-driver를 이용해서 단위 테스트하는 방법을 소개한다.
IntelliJ에는 800개가 넘는 plugins이 존재하고 있다. IntelliJ에 Plugins을 추가로 설치하고 싶으면 다음과 같이 Preferences의 Plugins 화면을 연다.


![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/28d95387-819b-49ec-9a5d-7a83bc2c678c)

plugins 화면에서 Browse repositories 버튼을 선택한다. 그러면 설치 가능한 plugins를 목록들이 나오는데 JSTestDriver를 검색한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f707aff4-2d52-492a-8d15-2a9bfadb1214)

JSTestDriver를 선택해서 오른쪽 마우스 버튼을 클릭해서 install 메뉴를 선택하면 IntelliJ가 재시작되면서 JSTestDriver plugins이 설치가 된다.
단위 테스트를 위해서 프로젝트를 생성하고 간단한 코드를 만들어보자. src/Person.js 파일을 생성한다.

```javascript
/**
 *
 * filename : Person.js
 */

var Person = function(){
    this.name = "saltfactory";
};

Person.prototype.getName = function(){
    return this.name;
};

```

그리고 Person 객체를 테스트하기 위해서 test/PersonTest.js 파일을 생성한다. 테스트는 간단하게 Person 객체의 이름을 가져와서 문자열과 같은지 assertion을 하는 것이다.


```javascript
/**
 *
 * filename : PersonTest.js
 */

PersonTest = TestCase("PersonTest");

PersonTest.prototype.testGetName = function(){
    var aPerson = new Person();
    assertEquals(aPerson.name, "saltfactory");
};

```

Javascript Test 파일까지 만들었으면 이제 IntelliJ에서 JSTestDriver를 이용해서 테스트파일을 실행시켜야한다. IntelliJ의 Run/Debug Configurations를 열기 위해서 Run 버튼 옆에 설정 버튼을 선택한다. Run/Debug Configurations 창이 열리면 왼쪽 상단의 + 버튼을 눌러서 TestDriver를 하나 생성한다. 우리가 테스트할 객체 이름이 Person 이기 때문에 PersonTest라고 이름을 정한다. Test는 Javascript test file을 실행시키기 원하기 때문에 Test에서 Javascript test file 항목을 선택한다. 그리고 JS test file에서 위에서 생성한 PersonTest.js 파일을 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8bb1cf83-566b-4d3a-b667-40722f268078)

이제 설정이 마쳤으니 Javascript로 생성한 Person 객체를 테스트해 보자. 그런데 바로 테스트가 진행이 되지 않을 것이다. 이유는 js-test-driver는 브라우저에서 javascript를 동작하는 것을 캡처링하기 때문에 브라우저를 캡처링하기 위한 디버깅 서버가 동작해야하기 때문이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d2a6b879-2646-4827-a737-ee002da6fba2)

그럼 디버깅 서버를 동작하고 브라우저와 연결하자. JS TestDriver Server 탭을 선택한다. Js TestDriver Server가 나타나면 왼쪽의 실행 버튼을 누른다. 그러면 There are no browsers captured 라는 메세지인데 이것은 디버깅 서비가 어떤 브라우저와 연결할지를 정하지 않아서이다. chrome을 선택해보자. 그럼 실제로 chrome 브라우저에서 동작하는 것을 캡처링 하겠다는 의미이고 chrome 과 js-test-driver의 화면은 다음과 같이 보이게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a3263002-66e2-4ec5-b696-2a0840cfcf60)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1f6e9371-62fb-44a9-abbe-68d8709e092b)

다시 IntelliJ에 가서 PersonTest.js를 테스팅하기 위해서 PersonTest 로 지정한 Run/Debug를 실행한다. 만약 단위 테스트에서 문제가 발생하지 않으면 초록색이 나타나면서 에 문구가 나타나지 않는다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2cee88f9-c505-491b-ba4b-b4a1246024a2)

만약 단위테스트가 실패로 떨어지게 되면 붉은색으로 나타나면서 원인까지 분석해준다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/20881248-7461-486d-8858-1b3b51629c70)

이제 Java application 개발에만 사용했던 IntelliJ를 View를 만들면서 Javascript를 개발하는데 사용할 수 있게 되었다.

## 결론

IntelliJ는 매우 강력한 Java IDE 이다. IntelliJ는 수많은 plugins를 가지고 있는데 Javascript Application IDE 에 들어 있는 JSTestDriver를 plugins으로 설치해서 Java를 개발하면서 Javascript 코드를 단위테스트할 수 있다. IntelliJ의 안정성과 빠른성능으로 보다 쾌적하게 Javascript를 개발할 수 있을 뿐만 아니라, JSTestDriver로 단위테스트를 할 수 있어서 Javascript의 코드 품질을 높일 수 있을 것으로 예상된다.

## 참고

1. Javascript 테스트 1. QUnit을 이용해서 Javascript 단위테스트하기 (Unit Test)
2. http://code.google.com/p/js-test-driver/
3. http://code.google.com/p/js-test-driver/
4. http://confluence.jetbrains.net/display/WI/Getting+Started+with+JsT

