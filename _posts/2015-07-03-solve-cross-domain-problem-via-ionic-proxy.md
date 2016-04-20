---
layout: post
title: Ionic 기반 하이브리드 앱에서 proxy를 사용하여 CORS 문제 해결하기
category: ionic
tags:
  - ionic
  - hybrid
  - hybridapp
  - cors
  - ajax
  - angularjs
  - anguar
  - proxy
comments: true
images:
  title: 'http://blog.hibrainapps.net/saltfactory/images/c04caa5a-d2d2-49e0-a405-49a63073c236'
---

## 서론

**Angular.js**, **jQuery** 또는 [Vanilla JS](http://vanilla-js.com/) 프로젝트를 진행하면서 [CROS(Cross-Origin Resource Sharing)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) 문제를 반드시 겪어 봤을 것이다. 요즘은 페이지 전환없이 [SPA(Single Page Application)](https://en.wikipedia.org/wiki/Single-page_application)을 개발하는 경우가 많기 때문에 **Ajax**나 **WebSocket**을 사용할 때, 로컬에서 작업하면서 서버측으로 HTTP 요청을 보낼 때 **CORS** 문제를 만나게 된다. 이 문제를 해결하기 위해서 웹서버에서 CORS를 허용하게 설정하거나, 웹 프로그래밍에서 CORS를 허용하도록 인터셉터나 필터를 만들어서 사용하기도 한다. **Ionic**은 이런 문제를 보다 쉽게 해결해서 프로그램에만 집중할 수 있도록 프레임워크에 proxy 메카니즘을 포함시켰다. 이 글은 Ionic framework에서 proxy를 사용하여 CORS 문제를 간단하게 해결하는 방법에 대해서 소개한다.

<!--more-->

## CORS(Cross-Origin Resource Sharing)

**CORS**의 문제는 **SPA** 개발을 할 때 가장 쉽게 만날 수 있다. 또는 페이지 전환 없이 **ajax**를 사용하여 다른 서버에 http 요청을 할 때 만날 수 있다.

예를 들어보자.

소스코드는 https://github.com/saltfactory/ionic-tutorial 에서 받을 수 있다.
proxy 설정에 관한 소스는 `proxy-demo/` 디렉토리 안에 있다.
**CORS** 문제는 다른 도메인을 가지고 있어야 하기 때문에 다른 서버가 필요하다.  `proxy-demo/` 안에 다른 서버를 동작할 수 있도록 Dockerfile 파일을 추가했다.

`proxy-demo/` 디렉토리 안으로 이동한다.

```
cd proxy-demo
```
다음은 `build.sh` 파일을 실행시켜 docker 이미지를 빌드한다. 그리고 `start.sh` 파일을 실행시켜 서버를 실행시키자.

```
bash build.sh
```
```
bash run.sh
```

![start docker](http://blog.hibrainapps.net/saltfactory/images/28fb0b7d-6ffe-40c3-82ab-768bd7c95e07)

브라우저에서 방금 추가한 서버를 확인해보자. 테스트를 위해서 웹서버 홈 디렉토리에 `/api/data.json` 파일을 docker 이미지에 추가해 두었다. 브라우저를 열어서 http://boot2docker:7000/api/data.json 을 요청해보자.

![docker browser](http://blog.hibrainapps.net/saltfactory/images/43941a12-d183-4bcb-a165-854d3579c8b4);

정상적으로 서버가 동작하면 추가한 JSON 데이터를 확인할 수 있다.

이 글은 Mac OS X에서 [boot2docker](https://docs.docker.com/installation/mac/)를 사용하여 작성 되었다. docker 호스트의 접근하기 위해서는 boot2docker의 ip를 확인해서 사용하면 된다.

```
boot2docker ip
```

좀 더 유연하게 테스트를 하기 위해서 http://demo.docker.localhost/api/data.json 로 접근하면 내부적으로 http://boot2docker:7000/api/data.json 이 요청되도록  **Apache** 웹 서버의 **vhost**를 설정하였다.

![vhost 결과](http://blog.hibrainapps.net/saltfactory/images/959a2b79-fedf-4cbc-8fd3-dc49a3f2e0ca)

이제 테스트를 위해 미리 ionic 프로젝트를 만들어 놓았다. `demo-ionic` 디렉토리 안으로 이동한다.

```
cd demo-ionic/
```

이동후 ionic 서버를 실행한다.

```
ionic serve
```

브라우저가 열리고 **CORS** 에러가 발생하는 것을 확인할 수 있다.

![CORS error](http://blog.hibrainapps.net/saltfactory/images/6ff25567-d87d-437d-b8e1-d2f9f6df1d29)

에러 내용은 다음과 같다.

```text
XMLHttpRequest cannot load http://demo.docker.localhost/api/data.json. No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'http://localhost:8100' is therefore not allowed access.
```

소스코드를 살펴보자. `proxy-demo/demo-ionic/www/js/app.js` 파일을 열어보자. 코드 중간쯤에 **Angularjs**의 [$http](https://docs.angularjs.org/api/ng/service/$http)를 요청하고 있는 부분이 보일 것이다. **$http**는 내부족으로 **XMLHttpRequest** 즉 **ajax**를 사용하고 있다.

```javascript
// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'

// angular.module('starter.services',[])
// .service()

angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: 'http://demo.docker.localhost/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      StatusBar.styleDefault();
    }

    // CORS 요청 데모
    $http.get(ApiEndpoint.url + '/data.json').
      success(function(data, status, headers, config) {
        console.log(config);
        console.log(status);
        console.log(data);
        $rootScope.name = data.name;
        $rootScope.email= data.email;
        $rootScope.blog = data.blog;
      }).
      error(function(data, status, headers, config) {
        console.log(config);
        console.log(status);
        console.log(data);
      });

  });
})

```

**CORS** 문제가 왜 발생했는지 눈치를 챘을 것이다. ionic으로 만든 demo-ionic 앱은 http://localhost:8100에서 동작하고 있는데 다른 도메인으로 http://demo.docker.localhost/api/data.json 을 요청했기 때문이다.

## CORS 해결 방법

만약 여러분이 이런 **CORS** 문제가 발생하면 어떻게 처리하겠는가?

처음에 CORS 문제로 로컬에서 다른 API 서버의 데이터를 가져올 수 없어서 서버 관리자에게 Nginx나 Apache 웹 서버에서 CORS를 접근할 수 있게 해달라고 요청을 했다.

* [CORS on Nginx](http://enable-cors.org/server_nginx.html)
* [CORS on Apache](http://enable-cors.org/server_apache.html)

하지만 이건 보안상 접근할 수 없도록 만든 것을 강제로 열어주는 것이다. 다른 어플리케이션에서도 이제 이 서버에 특별한 제약없이 접근할 수 있게되는 것이다. 프로그램 상에서 해결하는 방법도 마찬가지다.

* [express cors](https://github.com/expressjs/cors)
* [springboot cors](https://spring.io/guides/gs/rest-service-cors/)

무엇보다도 만약 우리가 요청할 수 없는 서버에 접근할때는 어떻게 할 것인가? Instagram API(https://api.instagram.com/v1/)에 접근하여 데이터를 가져올때는 어떻게 할 것인가? 서버 관리자에게 요청할 수 없다.

해결 방법은 있다. 네이티브 Plugins를 사용하는 방법이다. **Ionic**은 **coardova**를 기반으로 동작하기 때문에 cordova plugins을 사용할 수 있다.

* [cordova-HTTP](https://github.com/wymsee/cordova-HTTP)
* [phonegap-http-request](https://github.com/wf9a5m75/phonegap-http-request)

처음 프로젝트를 진행할 때 실제 Http Request를 처리하는 네이티브 Plugin을 제작하여 사용을 했었다. 하지만 더이상 그럴 필요가 없다. Ionic은 멋진 해결 방법을 포함하고 있기 때문이다.

http://ionicframework.com/docs/cli/test.html 에서 **Service Proxies** 섹션에서 **proxy**를 사용하여 **CORS** 문제를 해결하는 방법을 제시하고 있다.

## Ionic Proxy 설정

**Ionic** 프로젝트를 생성하면 프로젝트 디렉토리에 `ionic.project`라는 파일이 생성된다. 이 파일은 Ionic 프로젝트에 관련된 설정을 정의하는 파일이다. 파일을 열어서 다음과 같이 **proxies** 프로퍼티를 추가한다.

```javascript
{
  "name": "demo-ionic",
  "app_id": "",
  "proxies":[
    {
      "path":"/api",
      "proxyUrl":"http://demo.docker.localhost/api"
    }
  ]
}
```
프록시 설정은 로컬에서 **URL**의 **path**가 `/api` 로 접근하게 되면 프록시가 **proxyUrl**로 변경시켜 요청하도록 하는 것이다. 즉 다시 말해서 http://http://localhost:8100/api/data.json 으로 요청하면 프록시는 http://demo.docker.localhost/api/data.json으로 요청한 것으로 인식시키는 것이다. 그럼 요청은 같은 도메인으로 하기 때문에 **CORS** 문제가 발생하지 않고 프록시는 원래 요청 URL인 **proxyUrl**로 요청하기 때문에 원하는 데이터를 받아 올 수 있게 되는 것이다.

앞에서 설정했던 `proxy-demo/demo-ionic/www/js/app.js` 파일을 열어서 다음과 같이 수정하자. 앞에선 `ApiEndpoint.url`의 도메인이 http://demo.docker.localhost/api 였지만 **ionic.project** 파일에서 **proxy** 설정을 했기 때문에 이제 `ApiEndpoint.url`를 http://localhost:8100/api 로 지정하면 proxy에 의해서 자동으로 서버의 데이터를 가져오게 될 것이다.

```javascript
// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'

// angular.module('starter.services',[])
// .service()

angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: '/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      StatusBar.styleDefault();
    }

    // CORS 요청 데모
    $http.get(ApiEndpoint.url + '/data.json').
      success(function(data, status, headers, config) {
        console.log(config);
        console.log(status);
        console.log(data);
        $rootScope.name = data.name;
        $rootScope.email= data.email;
        $rootScope.blog = data.blog;
      }).
      error(function(data, status, headers, config) {
        console.log(config);
        console.log(status);
        console.log(data);
      });

      });
})

```

**ionic serve** 명령은 아주 훌륭하다. 파일을 변경하면 서버를 시작할 필요없이 바로 적용이 되기 때무에 브라우저를 바로 확인하면 된다. **ionic**의 **proxy** 설정 이후 http://localhost:8100/api/data.json 을 요청했지만 서버의 데이터를 가져온 것을 확인할 수 있다.

![ionic proxy result](http://blog.hibrainapps.net/saltfactory/images/81405bab-c985-4f9d-a1e3-ecad647bd7d6)

## 디바이스에서 proxy 설정

Ionic의 **proxy**는 **ionic server**의 기능이다. 하지만 디바이스에서는 proxy 서버가 존재하지 않는다. 그래서 위의 코드를 그대로 디바이스에서 실행하게되면 데이터를 가져올 수 없다. 위 코드를 그대로 iOS 디바이스에 빌드하여 실행시켜보자. 테스트를 위해서 ios simulator로 진행하였다.

```
ionic prepare && ionic emulate ios
```

실행후 서버로부터 결과를 가져오지 못하는 것을 확인할 수 있다. **Safari Web Inspector**를 이용하여 로그를 살펴보면, `file://api/data.json`이라고 호출되는 것을 확인 할 수 있다. 위에서 proxy를 설정하기 위해 **ApiEndpoint**를 설정한 것은 **ionic server**를 가지고 테스트하는 브라우저 환경에서만 적용이 되기 때문이다.

![emulate 결과](http://blog.hibrainapps.net/saltfactory/images/d27cec4b-df35-4ddf-a280-138b62788357)

실제 디바이스에서는 **ionic.project** 파일의 **proxy**에 설정한 **path**를 가지고 **ApiEndpoint**로 사용하던 것을 실제 주소 **proxyUrl**로 변경을 해야한다.
다시 명확하게 말하자면 아래와 같이 `./www/app.js`에 설장한 **ApiEndpoint**를 변경해야한다.

```javascript
// 데스크탑에서 테스트를 하기 위한 proxy path 설정
angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: '/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  ...
```

```javascript
// 실제 디바이스에서 사용하기 위한 proxyUrl 설정
angular.module('starter', ['ionic'])
.constant('ApiEndpoint', {
  url: 'http://demo.docker.localhost/api'
})
.run(function($ionicPlatform, $http, $rootScope, ApiEndpoint) {
  ...
```
디바이스에서 사용할 수 있도록 변경하고 다시 디바이스를 실행해보자.

```
ionic prepare && ionic emulate ios
```

![emulate 성공](http://blog.hibrainapps.net/saltfactory/images/33dde4c6-a41a-4606-82ff-a9156f64d56c)

데스크탑에서 로컬 **ionic server**를 사용할 때 **ApiEndpoint** 을 **proxy path** 사용하면 디바이스에서 되지 않는 문제를 실제 URL로 대처하면서 사용할 수 있게 되었다.


## 결론

웹 앱, 하이브리드 앱을 만들 때 API 서버에서 작업하는 개발자는 없을 것이다. **SPA(Single Page Application)**으로 앱을 제작할 때 HTTP 요청은 반드시 Ajax를 사용하거나 WebSocket을 사용해야한다. Ionic은 HTTP 요청을 AngularJS의 **$http**를 사용하여 요청을 하는데 이것은 다른 도메인으로 요청을 할 때 **CORS** 문제를 발생하면서 데이터를 요청할 수 없게 된다. Ionic은 프레임워크에 **proxy** 환경을 포함하고 있기 때문에 CORS 문제를 아주 쉽게 해결할 수 있다. 이 글로 통해 Ionic 프로젝트를 시작할 때 서버와 통신을 하는 문제를 쉽게 해결할 수 있을 것으로 기대한다.

## 소스코드

https://github.com/saltfactory/ionic-tutorial/releases/tag/proxy-demo

## 참고

1. http://ionicframework.com/docs/cli/test.html
2. http://blog.ionic.io/handling-cors-issues-in-ionic/


