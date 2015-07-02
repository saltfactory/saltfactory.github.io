---
layout: post
title: Envjs를 이용하여 브라우저 없이 JavaScript 개발하기
category: javascript
tags: [javascript, envjs]
comments: true
redirect_from: /195/
disqus_identifier : http://blog.saltfactory.net/195
---

## 서론

자바스크립트에 대한 불안정성의 선입견은 아무래도 다른 VM을 가진 언어보다는 훨씬 오해를 많이 받는다. 그 중에 하나가 바로 Javascript는 브라우저에서만 동작한다는 오해이다. 지금은 개발자들 사이에서 nodejs가 어느정도 인지도가 있기 때문에 더이상 javascript가 브라우저의 자바스크립트 엔진으로 돌아가는 front-end 개발 언어로만 인식되지 않고 있다. nodejs를 이용해서 서버 프로그램을 하고, 임베디드 프로그램까지 개발을 할 수 있는 시대가 왔기 때문이다.

우리 연구소에서는 지금 프로젝트 개발을 하면서 이 Javascript에 대한 오해와 그 오해를 풀기 위한 조사들을 계속 하고 있는 중이다. 그래서 오류없는 Javascript 어플리케이션을 개발하는 것이 우리의 가장 큰 목표이다. 처음 우리가 가진 Javascript의 오해는 바로 브라우저에서만 Javascript를 개발할 수 있다는 것이였는데 일전에 Javascript에서 Callback 구현하기 글에서 Rhino를 소개하면서 Rhino의 쉘에서 Javscript를 디버깅할 수 있다는 것을 포스팅하였다. 이번 포스팅은 브라우저 없이 Javasctipt를 개발하는 연장선으로 Envjs를 소개하려고 한다.

<!--more-->

## Envjs

Envjs는  브라우저 시뮬레이터 환경을 자바스크립트로 구현하여 브라우저 없이 Javascript를 개발할 수 있는 환경을 제공한다.
그런데 Rhino에서도 브라우저 없이 Javascript를 디버깅할 수 있었는데 Envjs 가 왜 언급하는지 궁금해 할 수 도 있다. Envjs는 말 그대로 브라우저 시뮬레이터와 같은 기능이다. 즉, 브라우저가 HTML의 DOM을 렌더링하여 그 엘리먼트를 Javascript에서 접근하거나 이벤트를 등록할 수 있는데, Envjs에 그러한 시뮬레이셔을 할 수 있다는 것이다.

Envjs를 테스트하기 위해서 Envj를 다운 받는다. 해당 사이트에서 다운로드를 해도 되고 github에서 최근 소스를 받을 수도 있다.

```
git clone https://github.com/thatcher/env-js.git
```

우리는 이미 Rhino에서 브라우저 없이 Javascript 디버깅하는 연습을 해보았다. 그럼 Rhino에서 브라우에서 할 수 있는 , 브라우저가 가지고 있는 속성을 사용할 수 있는지 확인해보자. Rhino에서 Javascript 개발에 사용할 test.html 파일을 만들어보자.

```html
<!DOCTYPE HTML>
<html>
    <body>
        <h1 id="title">Test Rhino and Envjs</h1>
    </body>
</html>
```

다운받은 env-js 안에는 rhino라는 디렉토리에 rhino의 javascript runtime jar가 있다.  rhino에서 Javscript를 사용할 이 test.html 파일을 window.location으로 지정을 할 것이다.

```
cd env-js/
```
```
java -jar rhino/js.jar
js> window.location = "test.html"
```

하지만 rhino에서는 window란 것이 선언되어 있지 않다고 Javascript Runtime Exception을 발생한다.

http://cfile6.uf.tistory.com/image/185D844050624F3006B85E

Envjs에서는 Rhino에서 addon 처럼 사용할 수 있는 env.rhino.js를 배포하고 있는데 다음 링크에서 다운 받을 수 있다. 다음 경로에서 `env.rhino.1.2.js` 파일을 다운 받는다. (현재 이 포스팅을 할 때 env.rhino.1.2.js 이였지만 이후에 버전이 높아질 수 있다.) http://www.envjs.com/release/envjs-1.2
다운 받은  `env.rhino.1.2.js` 파일은 `env-js/rhino/env.rhino.1.2.js`로 이동 했다. 이제 rhino에서 `env.rhino.1.2.js`를 로드한다. 그리고 test.html 파일 안에 있는 `<h1 id="title">` 엘리먼트에 접근해보자.

```
js> load('rhino/env.rhino.1.2.js');
js> window.location = "test.html";
js> var title = document.getElementById("title");
js> print (title)
js> print (title.innerHTML);
```

어떠한가 놀랍지 않은가? 브라우저 없이 HTML의 DOM Element를 javascript로 엑세스해서 Element의  객체와 객체의 속성들을 사용할 수 있게 되었다. 눈에는 보이지 않지만 Envjs와 Rhino 두가지의 환경이 Browser와 Javascript runtime  환경을 만들어주고 있는 것이다. 혹시 Javascript가 로드된 HTML의 속성을 읽을 수만 있을까? 반대로 DOM Element에 HTML을 삽입을 해보았다.

```
js> document.getElementById("title").innerHTML = "Envjs is browser simulator";
```
```
js> print (document.getElementById("title").innerHTML);
```

Envjs는 거의 완벽한 브라우저 시뮬레이션을 할 수 있게 환경을 제공하고 있다. (여기서 거의라는 말은 다직 테스트하지 않은 meda 접근들을 말한다.)

![](http://cfile1.uf.tistory.com/image/151C6C3A506252550EE1E1)

Envjs가 브라우저라면 혹시 로컬의 파일말고 원격에 있는 웹 문서도 열수 있어야 할 것이다. 그래서 테스트를 해보았다. Envjs가 로컬파일을 로드하는 것이 아니라 다른 외부 URL을 열수 있는지 다음과 같이 이 블로그 URL으로 테스트를 해보았다.

```
js> load ('rhino/env.rhino.1.2.js');
js> window.location = "http://blog.saltfactory.net"
js> var overview = document.getElementById("overview");
js> var blog_title = overview.getElementsByTagName('h1')[0].innerHTML;
js> console.log (blog_title);
```

http://blog.saltfactory.net 의 HTML 문서 코드의 일부이다. 만약 Envjs가 브라우저와 동일하게 동작한다면 이 URL에서 HTML 문서를 열어서 파싱한 후에 DOM Element에 대한 해석을 하고 있을 것이다.

![](http://cfile8.uf.tistory.com/image/126DDA3750625800226251)

결과는 예상대로 다음과 같이 외부 URL을 window.location 속성으로 인식해서 HTML 문서를 로드해서 Javascript로 HTML 의 Element에 접근이 가능하게 되었다.

![](http://cfile4.uf.tistory.com/image/115FA536506257441D7ECD)

http://blog.saltfactory.net 이라는 문서에는 여러가지 javascript 파일이 포함되어 있다. 그중에서 jQuery 가 포함되어 있는데 envjs에서 로드한 HTML 문서에 포함된 jQuery를 사용할 수 있는지 테스트를 해보자. 위에 document에 접근하기 위한 selector를 jQuery의 selector로 변경해서 테스트해보자.

```
js> var blog_title = $("#overview h1:first").html();
js> console.log (blog_title);
```

![](http://cfile24.uf.tistory.com/image/163F713B50625B83338F63)

역시나 Envjs가 브라우저와 동일하게 동작하기 때문에 원격 URL에서 읽은 HTML 문서에 포함된 javascript 까지 사용할 수 있다는 것을 확인할 수 있다. 원격에 있는 javascript 말고 로컬의 javascript를 추가로 불러들여서 원격 HTML 문서에 바로 테스트를 할 수 있다. 추가적으로 로컬에 있는 javascript 파일을 로드하기 위해서는 env.rhino.js 파일을 로드한 것 처럼 load() 함수를 이용하면 된다.

```
js> load(['file1.js', file2.js', .... ]);
```

## 결론

Javascript는 더 이상 브라우저에서만 돌아가는 스크립트 언어가 아니다. Rhino등 CLI 기반의 shell을 이용해서 Javascript 프로그램을 작성할 수 있다. 하지만 Javascript는 Javascript  자체의 사용보다는 HTML의 프로퍼티나 속성 값을 변화 시키면서 좀더 다양한 웹 어플리케이션을 만들 수 있다. Rhino의 CLI는 Javscript Runtime 환경을 만들어주지만 인터넷 브라우저의 환경은 아니다. 이를 해결할 수 있는 것이 Envjs 이다. Envjs는 브라우저 없이 웹 프로그램이 가능할 수 있도로고 브라우저 시물레이션 환경을 제공해주는 순수 Javascript로 만들어진 Javascript 라이브러리이다. Envjs 자체가 Javascript이기 때문에 Rhino에서 로드될 수 있고 Envjs가 브라우저 시물레이션을 할 수 있기 때문에 Envjs를 로드한 Rihno에서 HTML 문서를 열거나 엑세스 할 수 있게 되기 때문에 브라우저 없이도 Javascript를 개발할 수 있는 환경을 구축할 수 있게 된다. 더구나, 원격 HTML 문서에 앞으로 추가될 Javascript 파일을 로컬에서 생성해서 디버깅을 할 수 도 있다. 원격 HTML 파일 문서를 열어서 load()함수를 이용해서 추가될 Javascript 파일을 디버깅하고 에러 없이 어플리케이션 개발이 완료되면 원격 서버에 Javascript 파일을 추가하면 되기 때문에 이미 동작하고 있는 HTML 문서에 오류를 만들거나 동작에 문제가 생기지 않고 차츰차츰 Javascript 코드를 추가하면서 웹 서비스를 마이그레이션 할 수 있는 장점도 얻을 수 있을 것이다.

## 참고

1. http://www.envjs.com/doc/guides
2. http://ejohn.org/blog/bringing-the-browser-to-the-server/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
