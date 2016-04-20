---
layout: post
title: passport-tistory와 express를 사용하여 Tistory 인증 구현
category: passport-tistory
tags: [node, passport, passport-tistory, expressjs, tistory]
comments: true
redirect_from: /251/
disqus_identifier : http://blog.saltfactory.net/251
---

## 서론

*[passport-tistory](https://github.com/saltfactory/passport-tistory)를 사용하여 Node.js 로 Tistory 오픈 API를 사용하는 방법을 소개한다. passport-tistory는 Node.js로 만들어진 Tistory 오픈 API 인증모듈이다.*

<!--more-->

## passport-tistory?

[passport-tistory](https://github.com/saltfactory/passport-tistory) 는 passort의 많은 인증 strategy의 하나로 OAuth 2.0 기반의 인증방식을 사용하여 Tistory의 인증과정을 간단하게 처리할 수 있는 Tistory 오픈 API 인증모듈이다. passport-node의 구현 방법과 설명에 대해서는 “[passport-tistory Node.js Tistory 인증 모듈](http://blog.saltfactory.net/249)” 포스팅 했었다.

이번 포스팅에서는 Node.js로 웹 서비스를 만들때 passport-tistory를 사용하여 인증을 처리와 Tistory 오픈 API를 사용할 수 있는 방법에 대해서 소개하려고 한다.

## Tistory Client 등록

다른 API를 제공하는 서비스와 마찬가지로 Tistory도 Application을 관리할 수 있는 Dashboard를 제공하고 있다. 다른 서비스들과 다르게 Tistory는 Application을 ***클라이언트*** 라는 이름을 사용하고 있다. 오픈 API를 사용하기 위해서는 먼저 클라이언트로 등록을 해야한다. [클라이언트 등록](http://www.tistory.com/guide/api/manage/register) 을 하고 난 이후 만들어진 클라이언트를 관리하기 위해서는 [클라이언트 관리](http://www.tistory.com/guide/api/manage/list) 에서 만들어진 클라이언트를 관리할 수 있다.

API에 관련해서는 두가지 문서를 제공하고 있는데 다음 링크에서 확인할 수 있다.
* [오픈 API 가이드](http://www.tistory.com/guide/api/index)
* [인증 가이드](http://www.tistory.com/guide/api/oauth)

이 포스팅에서는 passport-tistory를 상용하는 예제를 만들기 위해서 클라이언트를 하나 만들것이다. 이름은 TistoryAPIDemo로 새로운 [클라이언트 등록](http://www.tistory.com/guide/api/manage/register)을 하자.

| 필드명 | 값 |
|-------|----|
| 서비스 명 | TistoryAPIDemo |
| 설명 | Tistory 오픈 API 사용 Demo |
| 로고등록 | 로고이미지 파일 경로 |
| 서비스 URL| http://127.0.0.1:3000 |
| 서비스 형태 | 웹 |
| 서비스 권한 | 읽기/쓰기 |
| CallBack 경로 | http://127.0.0.1:3000/auth/tistory/callback |

클라이언트를 등록하면 Client ID와 Secrete Key가 발급되는데 이 두가지 값을 `passport-tistory`로 인증할 때 사용할 것이다.

## express 웹 프로젝트 생성

OAuth 2.0 인증은 웹에서 인증하는 방법을 사용하기 때문에 반드시 웹 브라우저가 필요하고 웹 서비스를 사용해야한다.
간단하게 passport-tistory를 테스트하기 위해서 express를 사용해서 웹 프로젝트를 만들어보자. express는 npm으로 설치할 수 있다.

```
npm install -g express
```

그리고 express 어플리케이션을 간단하게 만들어주는 express-generator를 설치하자 express-generator는 버전에 맞는 것을 설치하기 위해서 @version 옵션을 추가한다. 우리는 express4 버전으로 테스트를 하기 때문에 @4 를 설치한다.

```
npm install -g express-generator@4
```

express와 express-generator 설치가 모두 마쳤으면 express 프로젝트를 생성하고 생성한 디렉토리로 이동한다.

```
express /tmp/TistoryAPIDemo && cd /tm/TistoryAPIDemo
```

프로젝트가 생성되면 dependences 모듈들을 설치한다.

```
npm install
```
express 프로젝트를 만들고 필요한 모듈을 모두 설치했으면 프로젝트 서버를 실행해보자.

```
bin/www
```
서버가 실행되면 브라우저에서 http://127.0.0.1:3000 을 열어보자. 다음과 같은 화면이 나타나면 정상적으로 express로 간단한 웹 프로젝트를 시작할 준비를 마쳤다.

## pasport-tistory 모듈 추가

프로젝트 디렉토리 안에는 패키지관리를 위한 package.json 파일이 존재할 것이다. 이 파일을 열어서 다음과 같이 `passport-tistory` 모듈을 추가하자.
`passport-tistory`모듈을 express의 미들웨어로 사용하기 위해서는 `express-session`과 `passport`이 추가적으로 필요하다.

```json
{
  "name": "TistoryAPIDemo",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "start": "node ./bin/www"
  },
  "dependencies": {
    "express": "~4.2.0",
    "static-favicon": "~1.0.0",
    "morgan": "~1.0.0",
    "cookie-parser": "~1.0.1",
    "body-parser": "~1.0.0",
    "debug": "~0.7.4",
    "jade": "~1.3.0",

    "express-session": ~"1.6.5",
    "passport" : "~0.2.0",
    "passport-tistory": "~0.1.0"
  }
}
```
package.json 을 저장하고 `npm install` 명령어로 새로 추가한 ***passport-tistory***를 설치한다.
```
npm intstall
```
## 라우팅 설정

express의 사용방법은 이 포스팅에서 자세하게 설명하지는 않는다 만약 express를 처음 사용하는 개발자는 [express 가이드](http://expressjs.com/guide.html) 를 꼭 살펴보기 바란다.

express는 routing 설정을 `app.js`에 하게 되는데 우리는 다음과 같은 routing을 설정할 것이다. express4 부터는 기본적인 view engine이 jade를 사용하고 있다. 다음 표에 routing과 관련된 view 파일을 설명한다.

| routing | method |  설명 | view 파일 |
|---------|---------|---------|---------|
| / | GET | http://127.0.0.1:3000/ URL로 요청이 들어올 때, 만약 로그인이 되어 있으면 profile 정보를 가져와서 보여준다 | index.jade |
| /account | GET | /account URL로 요청이 들어올 때, profile 정보를 가져와서 보여준다 | account.jade |
| /login | GET | Tistory Login을 할 수 있는 페이지를 보여준다 | login.jade |
| /logout | GET | 로그 아웃을 하고 / URL로 돌아간다 ||
| /auth/tistory | GET | Tistory 인증 페이지를 호출한다 ||
| /auth/tistory/callback | GET | Tistory 인증 후 callback 되는 URL로 인증이 성공적으로 이루어지면 / URL로 돌아간다||

위의 라우팅을 `app.js` 에 다음과 같이 기술할 수 있다. routing에 관련된 특별한 프로세스를 제외하고 단순히 URL 요청이 들어오면 view 과 연결되는 부분을 정의했다.

```javascript
... 생략 ...
// app.use('/', routes);
// app.use('/users', users);

app.get('/', function(req, res){
  res.render('index', {user: req.user})
});

app.get('/account', function(req, res){
  res.render('account', {user: req.user})
});

app.get('/login', function(req, res){
  res.render('login', {user: req.user})
});

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.get('/auth/tistory', function(req, res){
  // Titsory 인증 페이지로 이동
});

app.get('/auth/tistory/callback', function(req, res){
  res.redirect('/');
});

... 생략 ...

module.exports = app;

```

## view 파일

express의 기본 view engine은 [jade](http://jade-lang.com/api/) 를 사용한다. jade에 대한 설명은 이 포스팅에서는 하지 않기 때문에 [jade 가이드](http://jade-lang.com/api/) 문서를 찾아보기 바란다.
jade는 HTML의 복잡한 태그를 단순화시켰고 태그의 계층구조를 들여쓰기로 표현한다. 뿐만 아니라 인터폴레이션이 가능하고 모델을 분리해서 뷰에서 모델객체를 접근할 수 있도록 설계되어져 있다.
우리는 routing에서 필요한 뷰 파일을 만들것이다. 단순히 정보를 출력하는 목적으로 스타일은 제외하였다. 뷰 파일은 모두 다음과 같이 필요하다.
프로젝트 디렉토리 안에 `views/` 라는 디렉토리 안에 다음과 같이 `.jade` 파일을 생성한다.

`layout.jade`는 뷰의 전체 레이아웃을 담당한다.

```jade
// filename: layout.jade

doctype html
html
  head
    title Passport-Tistory Example
  body
    if !user
      p
        a(href='/') Home
        | |
        a(href='/login') Log in
    else
      p
        a(href='/') Home
        | |
        a(href='/account') Account
        | |
        a(href='/logout') Logout

    block content
```

`index.jade`는 로그인이 되면 사용자의 정보를 출력한다.

```jade
// filename : index.jade

extends layout

block content
    if (!user)
        h2 Welcome! Please Login.
    else
        h2 Hello "#{user.id}"
```

`account.jade`는 로그인된 사용자의 정보를 출력한다.

```jade
// filename : account.jade

extends layout
block content
    p Username: #{user.id}
```

`login.jade`는 tistory로 로그인하는 인증창으로 연결할 수 있는 링크를 출력한다.

```jade
// filename : login.jade

extends layout
block content
    a(href='/auth/tistory') Login with Tistory
```

## passport-tistory 설정

`app.js`에 라우팅 설정이 끝나면 `passport`가 제공하는 인증과 세션을 사용하기 위해서 `passport`를 함께 'require'한다.
`passport-tistory`의 설정을 진행한다. 우리는 앞에서 `package.json`에 passport-tistory를 추가해서 npm으로 설치를 완료했다.
`passport-tistory`에서 우리가 사용할 것은 Strategy 이기 때문에 다음과 같이 `require`를 할 때 `Strategy`를 사용할 수 있게 한다.


```javascript
var express = require('express');
... 생략 ...
// passport-tistory 설정
var passport = require('passport');
var TistoryStrategy = require('passport-tistory').Strategy;
... 생략 ...

```
다음은 Tistory 클라이언트를 추가하면서 발급받은 Client ID와 Secrete Key 그리고 클라이언트의 Callback URL을 지정한다.

```javascript
... 생략 ...
// passport-tistory 설정
var passport = require('passport');
var TistoryStrategy = require('passport-tistory').Strategy;

// Tistory 클라이언트 인증키
var TISTORY_CLIENT_ID = "2b0f4314438b5cfcb4a7e682cc9d5af7";
var TISTORY_CLIENT_SECRET = "2b0f4314438b5cfcb4a7e682cc9d5af78ef8bbc96622d6088e078d88513e0db62e66c8cc";
var TISTORY_CLIENT_CALLBACK = "http://127.0.0.1:3000/auth/tistory/callback";
... 생략 ...
```

다음은 `passport`와 express의 연결 작업을 하자. `passport`를 상요하여 인증이 마치면 session을 사용하는데
`passport-tistory`를 express의 미들웨어로 사용하기 위해서는 `passport`의 세션을 express에서 사용하기 위해
`express-session` 모듈이 필요하다. 그리고 `express-sesion`과 `passport`를 express의 미들웨어로 사용할 수 있게 `app.use()`로 등록한다.

```javascript
... 생략 ...
var session = require('express-session');
... 생략 ...
app.use(session({secret: '<mysecret>', saveUninitialized: true, resave: true}));
app.use(passport.initialize());
app.use(passport.session());
... 생략 ...

```


이제 `passport`에서 `passport-tistory`를 사용할 수 있게하는 설정을 한다. `passport`는 인증처리가 마치면 자동으로 Profile을 가지고 user 정보를 만든다.
우리는 `passport`에 `passport-tistory`의 Strategy를 사용하기 위해서 `passport.use()`로 `TistoryStrategy`를 사용한다.
우리는 로그인 페이지에서 ***Login with Tistory*** 링크를 누르면 Tistory의 인증 페이지로 인증처리를 요청할 것이다.
요청이 마치면 우리가 Client를 등록할 때 함께 등록한 Client CallbackURL로 결과를 callback하고 인증처리가 마치면 access_token을 획득해서 블로그 정보를 가져온다.

```javascript
passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});

passport.use(new TistoryStrategy({
      clientID: TISTORY_CLIENT_ID,
      clientSecret: TISTORY_CLIENT_SECRET,
      callbackURL: TISTORY_CLIENT_CALLBACK
    },
    function(accessToken, refreshToken, profile, done) {
      // access_token을 확인하기 위해서 다음 코드를 입력했다.
      console.log("accessToken: " + accessToken);

      process.nextTick(function () {
        return done(null, profile);
      });
    }
));

app.get('/auth/tistory',
    passport.authenticate('tistory'),
    function(req, res){
      // Tistory 인증 페이지로 이동
    });

app.get('/auth/tistory/callback',
    passport.authenticate('tistory', { failureRedirect: '/login' }),
    function(req, res) {
      console.log(req);

      res.redirect('/');
    });
```

## 요약

위의 과정을 간략하게 요약하면 다음과 같은 과정으로 진행했다.

1. Tistory 사이트에서 Tistory Open API를 사용할 새로운 Client를 등록하여 Client ID와 Secrete Key를 발급 받는다.
2. `express`와 `express-generator` 를 npm으로 global 모드(`npm install -g`)로 설치한다.
3. `express-generator` 명령어로 express 웹 프로젝트를 생성한다.
4. `package.json` 에 필요한 모듈을 기술하고 `npm install`로 설치한다.
5. `app.js`의 라우팅을 설정한다.
6. express에서 라우팅에 매칭하는 view 파일들을 만든다.
7. `app.js`에 'passport'와 'express-session'을 미들웨어로 사용할 수 있게 `app.use()`로 등록한다.
8. `passport`에 `passport-express`를 상용할 수 있게 설정한다.



## 실험결과

위의 과정이 모두 마치면 다음과 같이 express 프로젝트의 서버를 실행하여 테스트를 해보자.

```
node bin/www
```

http://127.0.0.1:3000

![Screen Shot 2014-07-18 at 9.54.43 AM.png](http://blog.hibrainapps.net/saltfactory/images/dcd4716d-4a6b-404f-a340-30352cad2a32)

http://127.0.0.1:3000/login

![Screen Shot 2014-07-18 at 9.54.46 AM.png](http://blog.hibrainapps.net/saltfactory/images/c764a59b-21db-45e9-a8ef-4fb14891ba39)

http://127.0.0.1:300/login 에서 ***Login with Tistory*** 링크를 눌렀을 때

![Screen Shot 2014-07-18 at 10.07.48 AM.png](http://blog.hibrainapps.net/saltfactory/images/1c8e7763-ad6a-4a25-8497-56b9793410e5)

![Screen Shot 2014-07-18 at 9.54.49 AM.png](http://blog.hibrainapps.net/saltfactory/images/12a7558a-5803-417f-8f81-991ab4121d02)

Tistory에서 클라이언트 인증이 모두 마치고 다시 callback URL로 돌아왔을 때,

![Screen Shot 2014-07-18 at 9.54.52 AM.png](http://blog.hibrainapps.net/saltfactory/images/2e46ac38-a214-4471-8aa4-24bcf80d6cb2)

http://127.0.0.1:3000/account

![Screen Shot 2014-07-18 at 9.54.56 AM.png](http://blog.hibrainapps.net/saltfactory/images/17e17b31-bb80-4aad-9c38-3870432c5802)

http://127.0.0.1:3000/logout

![Screen Shot 2014-07-18 at 9.54.43 AM.png](http://blog.hibrainapps.net/saltfactory/images/1098b65e-13b5-4ec3-ad63-9098c1e41951)

실험이 이상없이 진행되면 이제부터 access_token 를 획득하였기 때문에 Tistory 오픈 API를 사용할 수 있다. 획득한 access_token은 `app.js`에 `passport.use()` 의 콜백함수에서 확인할 수 있다.
access_token을 가지고 Tistory 오픈 API를 사용하는 방법은 다음 포스팅에서 소개하겠다.

## 결론


오픈 API를 사용하기 전에 항성 거쳐야할 과정이 바로 OAuth 인증이다. 만약 개인이 OAuth 인증 과정을 처리하는 프로그램을 작성한다면 아주 복잡한 과정을 프로그램으로 구현해야한다.
Node.js에서는 프로그램을 정말 간결하게 만들어줄 수 있는 획기적인 모듈들이 많은데 `passort` 라는 모듈이 그러하다. `passport`는 복잡한 인증과정을 추상적으로 상용할 수 있는 방법을 제공한다.
패스워드 인증부터 OAuth 1.0, 1.0a 그리고 2.0 까지 거의 모든 인증방법을 추상화하여 만들어 두었다. 그리고 서비스의 인증는 서비스마다 조금씩 다르기 때문에 `Strategy`를 사용하는 개념으로 만들어서
여러가지 다른 서비스의 `Strategy`를 사용하여 인증할 수 있게 만들어 두었다. 그래서 `passport`를 사용하는 `Strategy`가 약 140개가 넘는다.

Tistory 역시 오픈 API를 사용하기 위해서 OAuth 2.0 인증을 처리해야하는데 `passport`를 사용하여 인증할 수 있는 Strategy를 [passport-tistory](https://github.com/saltfactory/passport-tistory)라는 이름으로 구현하였다.
그리고 `passport-tistory`는 express로 웹서비스를 개발할 때 미들웨어로 사용하여 인증 과정을 간단하게 처리할 수 있다는 것을 이번 포스팅에서 소개했다.
`passport-tistory` 는 현재 `0.1.0` 버전이지만 꽤 안정적이고 앞으로도 지속적으로 업데이트를 할 예정이다. Node.js로 Tistory 어플리케이션을 만들거나,
Tistory의 오픈 API를 사용하기 위해서 OAuth 2.0 인증 후 access_token을 획득하고자 하는 개발자와 연구원들에게 도움이 되길 바란다.

## 참고자료

* http://blog.saltfactory.net/249
* http://blog.outsider.ne.kr/829
* https://github.com/outsideris/passport-me2day
* https://github.com/rotoshine/passport-kakao
* https://github.com/visionmedia/express


