---
layout: post
title: JavaScript에서 Callback 구현하기
category: javascript
tags: [javascript, callback]
comments: true
redirect_from: /192/
disqus_identifier : http://blog.saltfactory.net/192
---

## 서론

프로그램을 이벤트 기반으로 만들게 되면 한 프로세스로 모든 일이 끝날 때 까지 기다리지 않고 처리된 일이 이벤트를 발생시키거나 다른 일을 비동기적으로 할 수 있다. 이렇게 비동기적으로 일을 처리할 때는 Callback이나 Listener, delegate 등으로 구현할 수 있다. Callback에 대한 소개와 Java로 구현된 코드를 Java에서 Interface를 사용하여 Callback 구현하기 아티클에서 간단히 살펴보았는데, 이 포스팅에서는 Javascript에서 Callback을 구현하는 방법에 대해서 소개한다.

<!--more-->


## Rhino

Javascript는 브라우저의 Javascript 엔진이 있어야 해석이 가능하지만 최근 CLI (Command Line Interface)로 사용할 수 있는 툴들이 존재한다. 이 포스팅에서 사용할 CLI 툴은 Mozilla의 Rhino를 사용할 것이다. Java로 구현된 Rhino는 Javascript와 Java의 객체를 서로 사용할 수 있는 기능도 지원된다. Rhino에 대해서는 다른 포스팅에서 소개하도록 하고 여기서는 Javascript를 debugging 하기 위해서만 사용할 것이다. https://developer.mozilla.org/en-US/docs/Rhino 에서 최신버전의 Rhino를 다운받는다. 압축파일을 해지하면 js.jar 파일을 실행한다.

```
java -jar js.jar
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/edec3844-57ca-47ea-ac11-8d81b4b5cb35)

이렇게 Rhino의 CLI 로 사용하면 Javascript를 테스트 할 수 있다.

Callback을 만들기 위해서 피호출자가(Callee)가 호출자(Caller)를 호출해서 호출자(Caller)에서 구현한 메소드를 서브루틴 안에서 사용할 수 있어야한다. 앞의 포스팅과 비슷한 방법으로 Callback을 구현해보자.

## JavaScript Callback

우선 CallbackEvent.java에 해당되는 객체를 만든다. 이 객체는 함수형태를 가지고 있고 callback_method 를 가지고 있다.

```javascript
var CallbackEvent = function(){
    this.callback_method;
};
```

다음은 EventRegistration.java에 해당되는 객체를 만든다. 여기서 do_work는 호출자(Caller)에서 구현된 callback_method를 do_work에서 호출하도록 구현되어져 있다.

```javascript
var EventRegistration = function(callbackEvent){
    this.callbackEvent = callbackEvent;
    this.do_work = function() {
            this.callbackEvent.callback_method();
    }
};
```

마지막으로 Callback을 테스트할 EvnetApplication.java에 해당되는 객체를 만든다. 여기서 CallbackEvent 객체를 생성하고 call_method를 구현하여 eventRegistration 객체를 생성할때 등록시킨다. 그러면 EventRegistration에 do_work가 호출자(Caller)에서 구현해서 등록한 callback_method를 실행하게 되는 것이다.

```javascript
var EventApplication = function(){
    this.main = function(){
        var callbackEvent = new CallbackEvent();
        callbackEvent.callback_method = function(){
            print('call callback method from caller');
        }

        var eventRegistration = new EventRegistration(callbackEvent);
        eventRegistration.do_work();
    }
};
```

위 코드를 Rhino의 CLI에서 작성하고 실행시켜보자.

```
var eventApplication = new EventApplication();
eventApplication.main();
```

그러면 우리가 예상하듯 외부에서 구현한 CallbackMethod가 피호출자(callee)에서  호출자(caller)를 호출해서 서브루틴에서 메소드를 실행할 수 있게 되었다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7bb69dc0-b931-4699-ad8d-8fe960da61d1)

## 결론

Javascript는 객체지향 언어이지만 클래스가 없는 언어이다. 그렇지만 객체지향 언어이기 때문에 객체지향 언어가 사용하는 프로그래밍 패턴을 사용할 수 있다. Callback 는 Command Pattern에 분류되는데 외부에서 Callback을 구현해서 프로그램이 동작하는 가운데 서브루틴에서 외부에서 구현한 함수를 서브루틴에서 비동기적으로 사용할수 있기 때문에 코드의 재사용과 확장성이 매우 좋다. Javascript의 클로저(closure) 특징을 잘 사용하면 C나 Java에서 사용하는 콜백루틴을 구현하여 사용할 수 있다. Javascript는 이제 웹 컨텐츠를 어플리케이션 수준으로 만들수 있는 고수준 언어로 자리잡고 있고, 많은 언어에서 Javascript의 특징들을 들여오고 있다. 뿐만 아니라 OOP 개발자들이 Javascript 언어 개발에 집중하게 되면서 여러가지 개발 패턴과 라이브러리들이 존재하고 공유하게 되어지고 있는데 우리도 확장성 가능하고 유연한 코드를 개발하기 위해서 프로그램 개발 패턴을 익혀둘 필요가 있을 것 같다는 생각이 든다.

## 참고

1. http://www.impressivewebs.com/callback-functions-javascript/
2. http://stackoverflow.com/questions/2190850/javascript-create-custom-callback

