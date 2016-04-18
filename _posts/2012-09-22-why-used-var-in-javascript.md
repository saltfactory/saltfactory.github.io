---
layout: post
title: JavaScript에서 var를 사용하는 이유
category: javascript
tags: [javascript, var]
comments: true
redirect_from: /193/
disqus_identifier : http://blog.saltfactory.net/193
---

## 서론

자바스크립트(Javascript)를 도입할 때 어떤 개발자는 Javascript의 유연성에 매력을 느끼고 어떤 개발자는 Javascript에서 발생하는 에러 때문에 Javascript에 알레르기를 보이기도 한다. Javascript는 여러가지 특수한 성질 때문에 매우 유연해서 이식성 높은 프로그램을 만들 수 있지만, 그만큼 다른 언어에 비해서 디버깅하기 어렵다. Javascript 언어의 특별한 특징 중에서 오늘은 자바스크립트의 변수에 대해서 이야기를 하려고 한다.

<!--more-->

## 변수선언

보통 프로그래밍 언어들은 변수를 선언하고 사용을 하는 것이 일반적이다. Javascript도 다른 프로그래밍 언어처럼 변수 선언을 하고 사용할 수 있다. 하지만, javascript는 변수를 선언하지 않고도 사용할 수 있다.

변수 선언 없이 변수를 사용하는 것은 다른 언어에서도 간혹 볼 수 있을 것이다. Ruby 에서는 변수 선언없이 모든 객체를 변수로 할당(assign) 할 수 있다.

```ruby
a = 1
b = 1
```

이렇게 Ruby에서는 변수의 타입과 변수를 선언하지 않아도 사용할 수 있다. 그리고 함수 안에서 로컬 변수를 사용하는 예제를 살펴보면 다음과 같다.

```ruby
def sum (x, y)
    result = x + y
    return result
end
```

하지만 변수의 사용범위 (scope)는 메소드 안에서만 사용이 가능하다. irb (Interactive Ruby Shell)을 이용해서 확인을 해보자.

![](http://asset.hibrainapps.net/saltfactory/images/189f47c6-b595-42a3-a4e4-8b5b863e35c7)

irb에서 Ruby의 변수에 숫자를 할당할때 미리 선언하지 않고 바로 사용할 수 있는 것을 확인 할 수 있다. 또한 함수를 정의해서 그 안에 result라는 로컬변수를 선언해서 사용할 때 함수 안에 들어있는 로컬변수의 범위가 함수 안에서만 사용가능하고 외부에서는 로컬 변수에 접근할 수 없는 것을 확인 할 수 있다. Ruby에선느 전역변수일 경우 $변수를 사용한다.

그럼 Javascript에서 변수 선업 없이 사용하고 변수의 유효범위를 확인해보자. 브라우저에서 테스트해도 좋고 Mozilla의 Rhino의 Javascript Shell CLI를 이용해서 테스트해도 상관없다. Rhino를 사용하는 방법은 [Javascript에서 Callback 구현하기](http://blog.saltfactory.net/192) 글에서 간단하게 소개한 적이 있으니 참조해보길 바란다. 위의 코드를 Javascript로 똑같이 구현하면 다음과 같이 구현 할 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/29c318f8-7e36-46fd-87d2-0ea2ce4fc030)

그런데 Javascript 코드를 잘 살펴보면 result의 scope가 sum 이라는 함수 안에서 사용했는데 sum 함수 밖에서 result를 출력시켰는데 sum 안에서 사용한 로컬 변수인 result에 값이 출력되는 것을 볼 수 있다.

이것은 Javascript 에서 변수 선언 없이 바로 사용하게 되면 비록 함수내의 로컬변수로 사용되더라도 모든 변수들은 암묵적으로 전역 프로퍼티가 되어 버린다. 그래서 이러한 속성 때문에 다른 라이브러리들의 변수 명이 같거나, 다른 Javascript에서 사용하는 변수 명을 덮어쓰게되어 오류가 발생하기도 한다. 오류가 발생하지 않더라도 다른 값이 들어가서 원하는 결과가 나오지 않을 수도 있다. 그럼 Javascript에서 어떻게 변수를 선언해서 사용해야 할까? 위 코드를 다음과 같이 var를 이용해서 변수를 선언해서 사용하면 된다.

![](http://asset.hibrainapps.net/saltfactory/images/cf0bc501-4eef-4be8-a182-20f9e779c230)

암묵적 전역 프로퍼티로 되어버린 코드와 달리 함수 안에 로컬변수를 var로 선언하게 되면 그 변수의 scope는 함수 밖에 영향을 끼치지 못하고 함수 내 로컬변수로 사용 할 수 있게 된다.

## 결론

Javascript는 브라우저에서 DOM과 Event를 처리하기 위한 간단한 스크립트 언어라고만 생각하던 이전의 웹 환경이 이제는 Javascript가 C#이나 Java 처럼 어플리케이션을 개발할 수 있는 레벨로 변해있다. 시대가 변해서 Javascript 언어가 변경된 것이 아니라 지금까지 웹 환경과 Javascript에 대한 깊은 관심이 없었다가 클라이언트, 모바일 환경 개발 패러다임이 변경되면서 HTML5과 Javascript 그리고 CSS3의 비중이 매우 커지게 되었다. 단순하게 팝업이나 뛰우던 Javascript 코그다 이제는 웹 어플리케이션을 만들어내는 중요한 언어가 되었다. 웹 페이지에서 Javascript 에러가 발생해서 페이지가 로딩되거나 띵띵 거리면서 오류 창을 만들어내도 사용자들이 대충 쓸거라는 생각을 하면 더이상 사용자는 그 서비스를 (웹 어플리케이션을) 사용하지 않으려 할 것이다. 그래서 Javascript가 견고하고 최적화 될 수 있게 기초부터 학습해가려고 한다. 하이브리드 웹을 공부하면서 Javascript의 시각이 달라졌고 Objective-C나 Java 만큼 좋은 자료구조와 알고리즘으로 만들어질 수 있게 노력해야하는 것도 느꼈다. 이 블로그에서는 앞으로도 Javascript에 대한 이야기를 계속할 예정이다.

## 참고

1.Stoyan Stefanov,김준기,변유진, O'REILLY, "Javascript Patterns", p.13~14


