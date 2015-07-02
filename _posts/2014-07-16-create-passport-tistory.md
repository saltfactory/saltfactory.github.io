---
layout: post
title: Tistory 오픈 API 인증 모듈 passport-tistory 소개
category: passport-tistory
tags: [tistory, node, passport, passport-tistory]
comments: true
redirect_from: /249/
disqus_identifier : http://blog.saltfactory.net/249
---

## 서론

passport는 Node.js의 인증을 처리하기 위한 인기있는 모듈중에 하나이다. passport를 사용하면 Open API를 위한 복잡한 OAuth 인증을 따로 구현하지 않고 쉽게 어플리케이션에 API를 위한 인증로직을 포함시켜 사용할 수 있다. 이 포스트에서는 Tistory의 Open API를 사용하기 위해 Tistory 인증모듈을 passport를 사용하여 구현한 사례를 소개한다.

<!--more-->


## passport-tistory

> *passport-tistory 는 Node.js 어플리케이션을 만들거나 티스토리 오픈 API 인증을 처리하는데 쉽고 편리하게 도와주는 인증처리 모듈이다.*

[passport-tistory](https://github.com/saltfactory/passport-tistory)는 npm을 사용하여 설치할 수 있다.

```
npm install passport-tistory
```

Tistory는 오픈 API를 제공하고 있다. 오픈 API를 사용하면 다양한 어플리케이션을 만들거사 서비스를 만들수 있기 때문에 개발자들은 오픈 API를 사용하고 싶어 한다. 하지만 오픈 API를 사용할때, 가정 먼저 걸림돌이 되는 것이 바로 인증 문제인다. 여러 사람이 사용하는 오픈 API는 보안문제 때문에 password 인증으로 할 수 없기 때문에 이젠 오픈 API의 인증에는 거의 표준이 되어 버리는 OAuth 인증을 사용하고 있다. Tistory 또한 OAuth 인증을 사용하는데 OAuth2.0 을 사용하고 있다.

## OAuth 2.0
오픈 API 의 인증에 표준화인 OAuth2.0을 Tistory에서도 인증처리를 하기 위해서 사용하고 있다. [OAuth 2.0](http://oauth.net/2/)의 스펙은 [rfc6794](http://tools.ietf.org/html/rfc6749)에 정의가 되어 있다. 한국어로 쉽게 설명이 되어 있는 곳이 있는데 [@tebica](https://twitter.com/tebica) 님께서 작성하신 [OAUTH 2.0 - OPEN API 인증을 위한 만능 도구상자](http://earlybird.kr/1584) 글을 읽어보면 OAuth 인증에 관한 전반적인 이해와 2.0에 대해서 쉽게 이해할 수 있다.

## Passport

Node.js의 모듈은 편리한 모듈가 참 많이 있다. 그 중에서 인증을 처리하기 위해서 가장 유명한 모듈인  [Passport](http://passportjs.org) 를 사용하면 local 인증부터 OAuth 인증까지 쉽게 구현할 수 있다. 더구나 passport는 140개 이상의 인증 strategy가 만들어져 있다. 여기에는 국내 개발자분들이 만들어 놓은 strategy도 있다.

[@Outsideris](https://twitter.com/Outsideris) 님께서 만드신 [passport-me2day](https://github.com/outsideris/passport-me2day)는 me2day 서비스의 인증을 처리하기 위한 strategy 이고 [@rotoshine](http://twitter.com/rotoshine)님께서 만드신 [passport-kakao](https://github.com/rotoshine/passport-kakao) 는 kaka 서비스의 인증을 처리하기 위한 strategy 이다.


passport-tistory Strategy 구현
============================

Passport는 모듈을 상속받아서 상세 구현을 할 수 있게 설계가 되어 있다. passport- 로 시작하는 모듈은 모두 Passport의 Strategy를 상속받아서 만들어진 것들이다.

## passport-oauth2

OAuth2.0 인증을 처리하기 위해서 이미 passport-oauth2 strategy가 만들어져 있다. 그래서 OAuth2.0 인증을 처리하기 위해서 기본적으로 passport-oauth2를 상속받아서 서비스에 맞게 수정해주면 된다.

## package.json

우리는 passport와 passport-oauth2 모듈이 필요하기 때문에 package.json을 다음과 같이 생성하였다.

```json
{
  ... 생략 ...
  "dependencies": {
    "passport": "~0.2.0",
    "passport-oauth2":"~1.1.2"
  },
  ... 생략 ...
}
```

전체 소스는 github에서 [package.json](https://github.com/saltfactory/passport-tistory/blob/master/package.json) 확인할 수 있다.


## strategy.js  구현

### passort-oauth2 상속

[strategy.js](https://github.com/saltfactory/passport-tistory/blob/master/lib/passport-tistory/strategy.js)는 passport-oauth2를 상속받아서 구현할 수 있기 때문에 TistoryStrategy를 OAuth2Strategy를 상속받아서 만들었다. strategy를 상속받는 코드는 다음과 같이 `util.inherits()`를 사용하면 된다.

```javascript
var util = require('util'),
OAuth2Strategy = require('passport-oauth2'),
profile = require('./profile');

/**
 * TistoryStrategy 생성자
 * @constructor
 */
function TistoryStrategy(options, verify){

}
  ... 생략 ...

// passport-oauth2 상속
util.inherits(TistoryStrategy, OAuth2Strategy);

  ... 생략 ...

/**
 * Expose `TistoryStrategy`.
 */
module.exports = TistoryStrategy;  
```

### passport-aouth2의 인증처리 함수 호출

passport-oauth2 모듈이 이미 OAuth 2.0 인증 프로세스를 구현해두었기 때문에 우리는 OAuth2Strategy의 인증처리하는 함수를 바로 호출하면 된다. 이것은 다음과 같이 `OAuth2Strategy.call()`을 호출하면 된다.

```javascript
var util = require('util'),
OAuth2Strategy = require('passport-oauth2');

/**
 * TistoryStrategy 생성자
 * @constructor
 */
function TistoryStrategy(options, verify){
  OAuth2Strategy.call(this, options, verify);
}

  ... 생략 ...

// passport-oauth2 상속
util.inherits(TistoryStrategy, OAuth2Strategy);

  ... 생략 ...

/**
 * Expose `TistoryStrategy`.
 */
module.exports = TistoryStrategy;
```

### options 재정의

passport-aouth2를 상속받아서 인증처리하는 함수를 사용할 수 있지만 인증처리를 위한 URL은 다시 정의를 해야한다.

OAuth 2.0에는 인증처리를 위해서 크게 3가지 URL이 필요하다.
1. authorizationURL - 인증요청을 하는 URL
2. tokenURL - 최초 사용자 인증 후 어플리케이션에서 사용할 access_token을 요청하는 URL
3. callbackURL - OAuth 2.0의 인증 처리후 요청할 callback URL 이다.

우리는 Tistory의 인증 API에 정의한 URL을 그대로 사용할 수 있게 했다.

```javascript
var util = require('util'),
OAuth2Strategy = require('passport-oauth2');

/**
 * TistoryStrategy 생성자
 * @constructor
 */
function TistoryStrategy(options, verify){
  var oauthHost = 'https://www.tistory.com';
  options = options || {};
  options.authorizationURL = options.authorizationURL || oauthHost + '/oauth/authorize';
  options.tokenURL = options.tokenURL ||  oauthHost + '/oauth/access_token';

  options.customHeaders = options.customHeaders || {};

  if (!options.customHeaders['User-Agent']) {
    options.customHeaders['User-Agent'] = options.userAgent || 'passport-tistory';
  }

  // 인증처리 호출
  OAuth2Strategy.call(this, options, verify);
}
  ... 생략 ...

// passport-oauth2 상속
util.inherits(TistoryStrategy, OAuth2Strategy);

  ... 생략 ...
/**
 * Expose `TistoryStrategy`.
 */
module.exports = TistoryStrategy;
```

OAuth2의 함수 Override
=====================

보통은 passport-oauth2 을 상속받아서 OAuth 2.0 인증을 처리하기 위해서는 위의 코드로 되지만
Tistory의 인증은 access_token을 획득하기 위해서 access_key를 얻을 수 있는 페이지로 한번더 redirect를 한다는 것을 알게 되었다.
passport-oauth2는 oauth 모듈을 사용하는데 oauth2의 인증처리 루틴을 모두 http 모듈의 request를 사용해서 POST로 전송하는 것을 알게되었다.
이렇게 oauth 모듈의 post 처리와 Tistory의 redirect는 access_token을 획득할 때 301 moved permanently explained 에러를 발생하는 것을 확인했다.
소스 코드를 분석한 결과 passport-oauth에서 사용하고 있는 oauth2의 `_chooseHttpLibrary`와 `getOAuthAccessToken` 함수를 override 하였다.

### follow-redirects와 querystring 모듈 설치
우리는 redirect 문제를 해결하기 위해서 `follow-redirects` 모듈을 설치할 것이고 redirect following은 GET으로만 사용할 수 있기 때문에 POST의 body로 요청한 것을 GET의 query string으로 변경하기 위해서 `querystring` 모듈을 설치할 것이다.
이 두가지를 설치하기 위해서 `package.json` 파일을 다음과 같이 수정한다.

```json
{
  ... 생략 ...
  "dependencies": {
    "passport": "~0.2.0",
    "passport-oauth2":"~1.1.2",
    "follow-redirects":"~0.0.3",
    "querystring":"~0.2.0"
  },
  ... 생략 ...
}
```

### oauth2._chooseHttpLibrary() 함수 재정의

`oauth2._chooseHttpLibrary()`함수는 http나 https 요청을 처리하기 위해서 http 라이브리를 정의하는 함수이 이다.
우리가 지금 가지고 있는 문제는 redirect 문제 인데 이 문제를 해결하기 위해서 우리는 기존의 `require('http')`를 사용하지 않고 redirect 페이지를 follow할 수 있는 follow-redirect 모듈로 교체할 것이다.

### oauth2.getOAuthAccessToken() 함수 재정의
passport-oauth2에서 access_token을 획득하기 위해서 사용하고 있는 `oauth2.getOAuthAccessToken()` 함수는 POST로 동작하고 있다. 하지만 http.request로 요청했을 때 page redirect된 것을 follow하기 위해서는 POST를 사용하면 안된다.
즉, page redirect following은 GET으로만 가능하다. 그래서 우리는 `oauth2.getOAuthAccessToken()` 함수 안에서 POST의 body를 만드는 부분은 querystring으로 변경해서 url querystring을 만들어서 GET으로 request를 요청하는 것으로 교체하였다.


```javascript
var util = require('util'),
  profile = require('./profile'),
  querystring= require('querystring'),
  OAuth2Strategy = require('passport-oauth2'),
  http = require('follow-redirects').http,
  https = require('follow-redirects').https;

function TistoryStrategy(options, verify) {

  ... 생략 ...

  this._oauth2._chooseHttpLibrary= function( parsedUrl ) {
    var http_library= https;
    if( parsedUrl.protocol != "https:" ) {
      http_library= http;
    }
    return http_library;
  };

  this._oauth2.getOAuthAccessToken= function(code, params, callback) {
    var params= params || {};
    params['client_id'] = this._clientId;
    params['client_secret'] = this._clientSecret;
    var codeParam = (params.grant_type === 'refresh_token') ? 'refresh_token' : 'code';
    params[codeParam]= code;


    var url = this._getAccessTokenUrl() + "?" + querystring.stringify(params);

    this._request("GET", url, {}, "", null, function(error, data, response) {
      if( error )  callback(error);
      else {
        var results;
        try {
          // As of http://tools.ietf.org/html/draft-ietf-oauth-v2-07
          // responses should be in JSON
          results= JSON.parse( data );
        }
        catch(e) {
          // .... However both Facebook + Github currently use rev05 of the spec
          // and neither seem to specify a content-type correctly in their response headers :(
          // clients of these services will suffer a *minor* performance cost of the exception
          // being thrown
          results= querystring.parse( data );
        }
        var access_token= results["access_token"];
        var refresh_token= results["refresh_token"];
        delete results["refresh_token"];
        callback(null, access_token, refresh_token, results); // callback results =-=
      }
    });
  }
}
```






passport-tistory Profile 구현
============================

passport는 인증처리 후 user의 정보를 가져올 수 있는 루틴이 포함되어 있는데 바로 `userProfile`을 사용하는 것이다.
[profile.js](https://github.com/saltfactory/passport-tistory/blob/master/lib/passport-tistory/profile.js)는 쉽게 생각하면 일종의 User의 정보를 담아두는 Model 이다.

```javascript
/**
 * Parse profile.
 *
 * @param {Object|String} json
 * @return {Object}
 * @api private
 */
exports.parse = function(json) {
  var profile = {}

  if ('string' == typeof json) {
    profile = JSON.parse(json);
  } else {
    profile = json;
  }

  profile.provider = 'tistory';



  return profile;
};
```

profile.js를 생성하면 strategy.js에 require하여 profile을 바로 사용할 수 있다.
strategy의 인증처리가 끝나면 인증후 획득한 access_key를 가지고 자동적으로 userProfile을 수행하여 API로 얻어온 user 정보를 저장하게 된다.
보통은 User 값을 가져오는 API를 동작하지만 Tistory API에서는 User 정보를 가져오는 API가 없다. 그래서 블로그 정보를 얻어오는 URL을 userProfile에 사용하게 했다.


```javascript
var util = require('util'),
OAuth2Strategy = require('passport-oauth2');

/**
 * TistoryStrategy 생성자
 * @constructor
 */
function TistoryStrategy(options, verify){
  ... 생략 ...
  // 인증처리 호출
  OAuth2Strategy.call(this, options, verify);
  this.name = 'tistory';
  this._userProfileURL = 'https://www.tistory.com/apis/blog/info?output=json';
}
  ... 생략 ...

// passport-oauth2 상속
util.inherits(TistoryStrategy, OAuth2Strategy);

  ... 생략 ...
/**
 * Tistory 블로그 정보를 얻는다.
 * 사용자 정보를 성공적으로 조회하면 아래의 object가 done 콜백함수 호출과 함꼐 넘어간다.
 */
TistoryStrategy.prototype.userProfile = function(accessToken, done) {

  this._oauth2.get(this._userProfileURL, accessToken, function (err, body, res) {
    if (err) { return done(new InternalOAuthError('failed to fetch user profile', err)); }

    try {
      var json = JSON.parse(body);

      profile.status = json.tistory.status;
      profile.id = json.tistory.id;
      profile.userId = json.tistory.userId;
      profile.tistory = json.tistory.tistory;
      profile.item = json.tistory.item;
      profile._raw = body;
      profile._json = json;

      done(null, profile);

    } catch(e) {
      done(e);
    }
  });
}

/**
 * Expose `TistoryStrategy`.
 */
module.exports = TistoryStrategy;
```

우리는 Tistory의 OAuth 2.0 인증을 처리하기 위해서 TistoryStrategy와 Profile을 만들었다.
그럼 이렇게 만든 passport-tistory 인증모듈을 어디에 어떻게 사용할 수 있는지는 다음 포스팅에서 알아보기로 하겠다.
직접 express로 웹 프로젝트를 만들고 passport-tistory를 사용해서 인증을 완료한 뒤에 Tistory의 오픈 API를 사용하는 예제를 포스팅할 예정이다.


## 결론

난생 처음으로 conributor가 되었다. 항상 Node.js 개발을 하면서 모듈을 가져와서 사용하기만 했는데 언젠가 한번 내가 직접 등록하고 싶다고 생각했는데 Tistory 오픈 API를 사용할 일이 생겨서 이번 기회에 npm 으로 배포할 수 있게 되었다.
아직 0.1.0 버전으로 병아리 패키지이다. 하지만 처음으로 conributor가 된 것에 스스로 감동하고 있다. 그리고 앞으로는 개인적으로 만들어서 사용한 모듈을 될 수 있는한 오류 없이 문서화해서 배포할 수 있게 구현할 예정이다.

passport-tistory 를 구현하는데 처음에는 생각보다 쉽지 않았다. 우선 oauth2.js의 동작하는 방법을 알아야했고, Tistory에서 access_token을 획득하는데 있어서 **301 moved permanently explained** 에러를 해결하는데 꽤 많은 시간을 보냈다.
이 시간동안에 module과 module.exports 개념을 알게 되었고, 뿐만 아니라 *http redirect following* 이라는 개념도 알게 되었다.

> *배우는 것보다 가르치는 것이 더 많이 배우는 기회가 된다.*

라고 가르쳐주신 교수님의 말씀이 생각난다. 연구원으로 살면서 앞으로도 더 많은 모듈을 만들어서 배포할 수 있는 contributor가 되려고 노력하고 싶다.

## 참고자료

* https://github.com/jaredhanson/passport
* http://blog.outsider.ne.kr/829
* https://github.com/outsideris/passport-me2day
* https://github.com/rotoshine/passport-kakao
* https://github.com/olalonde/follow-redirects
* https://github.com/Gozala/querystring
* https://github.com/visionmedia/express


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
