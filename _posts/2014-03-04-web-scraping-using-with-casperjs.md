---
layout: post
title : Casper.js를 이용하여 웹사이트 데이터가져오기
category : node
tags : [node, javascript, casper, casper.js]
comments : true
redirect_from : /232/
disqus_identifier : http://blog.saltfactory.net/232
---

## 서론

국내 최초 자바스크립트 컨퍼런스(http://jscon.ebrainus.com)에 다녀와서 흥미로운 주제를 많이 접할 수 있었는데 그중에 하나가 바로 [Casper.js](http://casperjs.org/)였다. 이번 자바스크립트 컨퍼런스에 대한 내용은 따로 포스팅하기로 하고 일단 연구원답게 잊어버리기 전에 기술부터 연구해보기 했다. 일전에 블로그에 웹 스크래핑하는 방법을 포스팅한 적이 있다. 그 때는 Node.js를 이용해서 웹 데이터를 가져오는 주제로 포스팅을 했는데 PhantomJS를 사용하는 내용을 포함하고 있다. CasperJS는 이 PhantomJS를 포함하고 있다. 예전부터 웹의 네비게이션을 자동화하여 필요한 데이터를 추출하고 싶었는데 좀더 인공지능적으로 사람처럼 행동하는 프로그래밍을 하기 위해서 복잡한 코드를 사용해야만 했다. 즉, 로그인을 한 뒤 어떤 정보를 가져오는 것 처럼 사람의 행동을 뭔가 컴퓨터가 자동적으로 해줘서 필요한 데이터를 수집해주기 위해서는 생각보다 복잡한 코드가 많이 필요하다. CasperJS는 사람이 브라우저를 열어서 뭔가 행동을 하는 것을 동일하게 해낼 수 있다. 실제 CasperJS는 Web Browser engine을 가지고 있다. 이 말은 사람이 브라우저를 열어서 웹 Documents를 해석해서 이벤트를 주는 것과 동일하게 할 수 있다는 것을 의미한다. 이제부터 사람이 브라우저로 하는 행동을 CasperJS로 처리하기 위해서 어떻게 해야하는지 살펴보자.

<!--more-->

### CasperJS 설치

먼저 CasperJS를 설치한다. CasperJS는 [PhantomJS](http://phantomjs.org/)와 **Python**을 요구하고 있다. PhantomJS로 마찬가지로 node module로 설치하는 방법이 있고 일반 설치파일을 설치하는 방법이 있다. 후자는 [Homebrew](http://brew.sh/)를 사용하면 간단하게 설치할 수 있다. 우리는 Node.js의 모듈로 설치해보자.

```
npm install -g casperjs
```

### CasperJS를 이용해서 Web Scraping 하기

앞에서 포스팅한 웹에서 데이터 가져오기 테스트를 Casper를 이용해서 계속 진행해보자. 앞의 예제는 다음 글을 먼저 살펴보기 바란다.(http://blog.saltfactory.net/224) 간단히 설명하면 브라우저가 아닌 프로그램을 사용해서 웹 사이트의 특정 Element의 값을 가져오는 것인데, PhantomJS는 브라우저는 아니지만 실제 브라우저 엔진을 가지고 있어서 브라우저를 열어서 HTML DOM object를 접근하는 것과 동일하게 할 수 있다는 것이다. CasperJS도 이와 비슷하다. CasperJS는 다음과 같이 구현할 수 있다. 브라우저 안에서 HTML 문서를 접근하기 위해서 document를 이용해서 접근하는것과 마찬가지로 CasperJS에서도 document 객체에서 동일하게 접근이 가능한데 CasperJS가 브라우저 엔진을 사용하고 있기 때문이다.

```javascript
// filename : app.js
// author : saltfactory@gmail.com

var casper = require('casper').create();

function getTodayCount(){
    return document.querySelector('#side_today_count').innerText;
}


casper.start('http://blog.saltfactory.net', function(){
   var side_today_count = this.evaluate(getTodayCount);
console.log("오늘의 방문자 수 : " + side_today_count);
})


casper.run();
```

위 코드를 실행해보자. 실행은 casperjs로 실행을 한다.

```
casperjs app.js
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0a703380-e9d2-45eb-a403-e05d86054ea4)

CasperJS를 사용하는 것이 왠지 PhantomJS를 사용하거나 Node.js의 라이브러리를 사용해서 웹 데이터를 스크래핑하는 것보다 훨씬 간단한거 같다. 마치 웹 브라우저안에 DOM 접근을 직접하는 느낌마저 든다. casperjs 라는 명령어 대신에 casperjs를 Node.js 어플리케이션의 라이브러리로 사용하기 위해서는 [SpookyJS](https://github.com/SpookyJS/SpookyJS)라는 CasperJS 드라이버를 사용해야한다. CasperJS를 좀 더 살펴보기로 하자.

### CasperJS를 이용해서 웹 사이트 네비게이션하기

CasperJS의 가장 흥미로운 것이 바로 사람이 브라우저의 행동을 순차적으로 Casper가 그대로 할 수 있다는 것이다.
오늘 방문자 수를 확인하기 위해서 브라우저를 여는게 복잡하고 귀찮아서 웹 스크래핑을 이용해서 간단하게 방문자수를 확인했다. 티스토리가 훌륭한 블로그이지만 네이버 블로그처럼 댓글이 달리면 알람을 주는 기능은 없다. 그래서 티스토리 블로그의 관리자 페이지에서 댓글을 확인하는데 이것 또한 매번 댓글을 확인하기 어렵기 때문에 CasperJS로 이것을 해보려고 한다. 티스토리 블로그의 관지자 주소는 다음과 같다. http://blog.saltfactory.net/admin/center/
이 주소를 브라우저에서 열면 다음과 같이 관리자 로그인 페이지로 넘어가게 된다.


![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ff76723f-b853-42a3-81c6-315bf637cc3f)

그리고 티스토리 로그인 정보를 입력하면 다시 관리자 페이지로 이동하게 된다. 우리는 CasperJS로 이 작업을 해보려고 한다.

#### CasperJS로 첫번째 URL 요청하기

먼저 티스토리블로그 관리자센터에 CasperJS로 접근한다. CasperJS의 진행사항을 살펴보기 위해서 create 할 때 options을 추가한다.

```javascript
// filename : app.js
// author : saltfactory@gmail.com

var casper = require('casper').create({verbose: true, logLevel: "debug"});

casper.start('http://blog.saltfactory.net/admin/center/');
casper.run();
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/91a3b6cf-df2b-4026-8e1a-bf4b04348de0)

CasperJS의 실행 결과를 살펴보면 처음에 http://blog.saltfactory.net/admin/center/를 요청했지만 나중에 내부적인 세션체크가 이루어지고 난 다음에 자체적으로 http://saltfactory.tistory.com/login?requestURI=http://blog.saltfactory.net/admin/center/&try=1 로 URL이 변경된 것을 확인할 수 있다. 이제 변경된 URL이 열린 페이지, 즉, 로그인 페이지에서 form에 아이디와 비밀번호를 넣어서 로그인체크를 하고 우리가 처음에 요청한 http://blog.saltfactory.net/admin/center로 돌아다는 일을 해야한다.

####  CasperJS로 웹사이트 로그인 Form 입력해서 submit 하기

CasperJS에서는 form을 채워서 submit을 해주는 메소드가 존재한다. 바로 `casper.fill()` 메소드이다. 이때 `fill()`에 들어가는 것은 form을 선택하고 그 form 안에 input을 넣어주면 된다. 위의 로그인 페이지 소스를 분석하면 form은 id로 LoginForm 으로 만들어져 있고, input은 loginid를 입력 받는 nam이 loginid와 password를 입력받는 name이 password로 구성되어져 있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9133e373-2694-4877-a250-6ec877e9af82)

위 과정을 CasperJS 소스코드로 다음과 같이 구현할 수 있다. CapserJS는 순차적으로 사람의 행동과 동일하게 진행시킬 수 있는 데 then을 사용하면 앞의 행위 다음의 행위를 지정할 수 있다. 이것에 대한 내용은 다음에 좀더 깊게 자세히 하도록 하겠다. 여긴선 단순히 then으로 앞의 일을 그대로 받아와서 처리할 수 있다고만 생각하자.

```javascript
// filename : app.js
// author : saltfactory@gmail.com

var casper = require('casper').create({verbose: true, logLevel: "debug"});

casper.start('http://blog.saltfactory.net/admin/center/');

casper.then(function(){
	this.fill('form#LoginForm', {
			'loginid':'아이디',
			'password':'비밀번호'
	}, true);
});

casper.run();
```

실행한 결과는 다음과 같다. 살펴보면 form element를 selector를 이용해서 찾아서 `loginid` 필드에 값을 set하고 password 피드에 값을 set하고 HTTP Post로 submit을 진행한다. 그리고 로그인체크가 끝나면 우리가 세션이 필요한 요청한 페이지로 다시 URL을 변경시켜 돌아가게 해준다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9563683b-d04c-4503-a76a-7efd9e7bf14a)

#### CasperJS를 이용해서 필요한 데이터 가져오기

로그인이 완료된 상태로 우리가 요청한 http://blog.satlfactory.net/admin/center 페이지로 갔을 때 우리는 최근 댓글을 가져오고 싶다. 그래서 페이지를 분석하면 다음과 같다. 다음과 같이 최신댓글은 div 태그에 id가 recentComments로 만들어져 있고 각각 댓글은 span의 class가 txt로 이루어져 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f4dc5f6d-773b-4293-a8f2-abf815d8ae97)

그래서 최근댓글 중에서 가장 첫번째 댓글을 가져오기 위해서 다음과 같이 querySelector와 querySelectorAll을 사용해서 필요한 데이터에 접근할 수 있다. 아래 코드를 실행하면 티스토리 관리자 페이지에서 최근 댓글중에 첫번째 댓글을 가져오는 것을 확인할 수 있다.

```javascript
// filename : app.js
// author : saltfactory@gmail.com

var casper = require('casper').create({verbose: true, logLevel: "debug"});

casper.start('http://blog.saltfactory.net/admin/center/');

casper.then(function(){
	this.fill('form#LoginForm', {
			'loginid':'아이디',
			'password':'비밀번호'
	}, true);
});

casper.then(function(){
	var latestComment = function(){
		return document.querySelector("#recentComments").querySelectorAll('span.txt')[0].innerText;
	};

	console.log("최신 댓글 : " + this.evaluate(latestComment));
});

casper.run();

```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ac36ef58-2344-486f-a2b7-750be5b54dad)


## 결론

CasperJS는 사람이 웹사이트에서 사이트를 브라우징하는 것과 같은 일을 해낼 수 있다. 국내에서 CasperJS를 이용해서 웹 사이트 스크린샷을 찍는 예제를 찾아볼 수 있는데 이것은 CasperJS가 실제 브라우저 엔진을 가지고 브라우징을 하고 있기 때문이다. 자바 컨퍼런스에 갔을 때도 CasperJS를 가지고 사이트에 로그인해서 화면 캡처를 찍는 예제를 보여줬는데, CasperJS가 스크린샷을 만들어낼 수 있는 것은 그리 중요하지 않다고 생각하고 CasperJS가 사람의 행동을 그대로 순차적으로 진행해서 사람이 웹 사이트를 브라우징을 하는 것 처럼 할 수 있다는 것은 정말 놀라운 것이였다. 이 포스팅에서도 예제로는 form의 input에 값을 넣고 submit을 하는 예제를 보여줬지만, 실제로 사람이 링크를 클릭하듯, CasperJS가 링크로 누르고 웹 사이트를 이동하고 다닐 수 있다. 또한 개발자가 웹 브라우저에서 JavaScript 파일을 injection하여 테스트를 하는 것 처럼 현재 열려진 사이트에서 CasperJS를 이용해서 JavaScript를 넣고 테스트도 할 수 있다. CasperJS는 이렇게 사람의 행동을 대신하여 자동화 할 수 있는 강력한 기능을 지녔다. 편리한 기술은 항상 양날의 검과 같다. 어떤 사람은 웹 데이터 스크래핑이 법적으로 문제가 된다는 말도 있고, 또한 이런 자동화 기술은 해킹 도구로 사용이 가능하다고 생각한다. 물론 기술을 나쁜 곳에 사용하면 안된다. 우리는 연구원이고 기술적으로 사람의 편리함을 제공해주는 것을 계속적으로 연구하는 일을 하고 있다. 이 과정속에서 보안상 문제가 되는 부분을 찾아서 보안할 수 있을 것이고 그 과정에서 또한 새로운 기술이 창조되고 계속적으로 발전할 것이라고 믿고 있다. 티스토리는 자동 로그인 방지를 막기 위해서 CAPCHA[http://ko.wikipedia.org/wiki/CAPTCHA]가 추가되면 좋을 것 같다.

## 참고

1. http://casperjs.org
2. http://nodeqa.com/nodejs_ref/73
3. http://nodeqa.com/nodejs_ref/86


