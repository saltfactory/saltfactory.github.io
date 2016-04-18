---
layout: post
title: 센차터치(Sencha Touch)에서 JSONP로 크로스도메인 Ajax요청 문제 해결하기
category: sencha
tags: [sencha, sencha touch, jsonp, json, cross domain, domain, ajax]
comments: true
redirect_from: /206/
disqus_identifier : http://blog.saltfactory.net/206
---

Sencha Touch는 모바일 웹 앱을 쉽게 만들 수 있는 환경을 제공하고 있다. 그래서 Sencha Touch에서는 웹앱에서 서버측으로 JSON 데이터를 요청해서 Sencha Touch 기반의 application에서 사용할 수 있는 Data Model로 쉽게 사용할 수 있다. 그런데 Sencha Touch를 모바일 어플리케이션으로 개발하게 된다면 즉, 하이브리드 앱으로 네이티브 앱에 패키징하여 개발하게 된다면 어플리케이션의 자원들이 모두 local에 저장하기 때문에 http://domain 으로 요청행하는 크로스 도메인 문제가 발생하게 된다. 이렇게 서로 다른 도메인에서 JSON 데이터를 요청하여 처리할 수 있는 것이 바로 JSONP(JSON with Padding)이다. JSONP는 content-type을 application/json으로 json 데이터를 요청하는 것이 아니라 application/javascript로 JSON을 가지는 callback function을 요청해서 callback function의 JSON 데이터를 사용하는 방법이다. [Javascript 에서 callback 구현하기](http://blog.saltfactory.net/192) 글에서 callback function 자체를 parameter로  넘겨서 callback function 이름에 ()를 표시해서 callback 함수를 실행시키듯, JavaScript는 call by name 으로 함수를 참조하고 dynamic parameter passing을 하기 때문에 JSONP라는 특수한 기능을 사용할 수 있다. 위키에서 소개한 SJONP를 살펴보면  callback function 이름으로 JSON payload를 가지도록 해서 JSONP의 요청을 처리하는 것을 볼 수 있다.
http://en.wikipedia.org/wiki/JSONP

<!--more-->

### Sencha Simple Application

우리는 Sencha Touch의 기본 사용법은 앞의 포스팅으로 익히 알고 있다고 가정하고 기본 설정이나 사용법에 대해서는 생략한다. SenchaTutorial이라는 디렉토리 안에 lib 안에 sencha touch 개발에 필요한 js와 css 파일을 추가하였다. IDE는 각자 편리한 IDE를 사용하면 된다. 연구소에서 공식적으로 IntelliJ를 사용하고 있기 때문에 이 포스팅은 IntelliJ 기반으로 설명한다.

![](http://asset.hibrainapps.net/saltfactory/images/049e8aba-41de-4269-803d-3fac52eaf267)

그리고 간단히 index.html을 만든다. sencha 의 파일과 app.js를 호출하는 코드가 있다.

```html
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link href="lib/sencha/sencha-touch.css" rel="stylesheet"/>
    <script src="lib/sencha/sencha-touch-all-debug.js"></script>
</head>
<body>
<script src="app.js"></script>
</body>
</html>
```

app.js에는 JSONP를 요청하고 결과를 받아 볼 수 있게 간단한 titlebar와 button을 가지도록 xtype을 Ext.Viewport에 추가하였다.

```javascript
/**
 *
 * filename : app.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

Ext.application({
    name:"SenchaTutorial",
    launch:function () {

        var button = {
            xtype:"button",
            text:"JSONP",
            ui:"confirm",
            align:"right"
        };

        var titlebar = {
            xtype:'titlebar',
            title:"JSONP Test",
            docked:"top",
            items:[button]
        };

        var rootPanel = {
            xtype:"panel",
            layout:"fit",
            items:[titlebar]

        };

        Ext.Viewport.add(rootPanel)
    }
});
```

위의 Sencha Touch의 코드를 실행하면 다음과 같은 화면이 보이게 된다.

![](http://asset.hibrainapps.net/saltfactory/images/4ea3abe0-0352-4345-a2c3-5793ec324bec)

### Node.js 설치

이제 JSONP 버턴을 누르면 http://localhost/test.json 으로 json을 요청하도록 서버 프로그래밍을 해볼 것이다. 우리는 하이브리드 앱이나 웹 앱을 만들려고 하기 때문에 JavaScript에 익숙할 것이다. 그래서 서버 프로그래밍도 nodejs를 이용해서 테스트해보겠다. 우선 Mac OS X에 homebrew가 설치되어 있어야한다. 아니면 homebrew 없이 바로 node가 설치되어 있어야한다.HomeBrew는 Mac OS X의 missing unix package를 설치해주는 툴이다. [Homebrew를 이용하여Mac OS X에서 Unix 패키지 사용하기](http://blog.saltfactory.net/109) 글을 참조하면 더욱 자세히 설치하는 방법과 사용하는 방법을 확인할 수 있다. homebrew가 설치되어 있으면 node를 설치한다.

```
brew install node
```

### HTTP 서버 만들기

`lib/server.js` 라는 파일을 다음과 같이 코드를 추가한다. nodejs에 기본적으로 포함되어져 있는 http 모듈을 가지고 http 서버를 만들고 요청이 들어오면 url 모듈로 url을 파싱해서 url 쿼리스트링 중에 callback 이라는 파라미터의 값을 console 로 출력하였다. 그리고 http의 응답으로 name이 "saltfactory"인 json 객체를 JSON string 문자로 변환하여 응답으로 만들어서 돌려주는 코드이다.

```javascript
/**
 *
 * filename : server.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

var http = require('http');
var url = require('url');

var server = http.createServer(function (req, res) {

    var parts = url.parse(req.url, true);
    var callback = parts.query.callback;

    console.log(callback);

    var obj = {name:'saltfactory'};

    res.writeHead(200, {"Content-Type":"application/json"});
    res.write(JSON.stringify(obj));
    res.end();
});
server.listen(8080);
```

이 코드를 실행하고 다음과 같이 브라우저에서 요청한다.
http://localhost:8080/test.json?callback=callbackfunc

![](http://asset.hibrainapps.net/saltfactory/images/d63560e5-93a0-4db7-b6e1-8659662c276b)

그러면 브라우저에서 application/json인 {"name":"saltfactory"} 라는 json 결과를 받을 수 있다는 것을 확인할 수 있다. 그럼 서버측에 로깅을 살펴보자.

![](http://asset.hibrainapps.net/saltfactory/images/431c15ce-a70b-48c1-832c-d9a0d219ed66)

서버측에서는 url 파싱을 해서 callback 파라미터를 출력하니 callbackfunc이라는 결과가 나왔는데 이상하게 undefined도 같이 출력된다. 브라우저에서 refresh를 반복적으로하면 이 두 쌍이 계속적으로 출력이되는 것을 확인할 수 있다. 이것은 http요청을 할 때 favicon을 요청하는 url이 들어와서 이다. 그래서 그래서 다음과 같이 코드를 변경한다.

```javascript
/**
 *
 * filename : server.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

var http = require('http');
var url = require('url');

var server = http.createServer(function (req, res) {
    if (req.url == '/favicon.ico') {
        res.writeHead(404, {'Content-type':'text/plain'});
        res.end('not found');
    } else {

        var parts = url.parse(req.url, true);
        var callback = parts.query.callback;

        console.log(callback);

        var obj = {name:'saltfactory'};

        res.writeHead(200, {"Content-Type":"application/json"});
        res.write(JSON.stringify(obj));
        res.end();
    }
});
server.listen(8080);
```

이제 서버측 로그를 살펴보면 callbackfunc만 출력되는 것을 확인할 수 있다.

###  Ajax 요청


HTTP 서버가 만들어 졌으니 Sencha에서 Ajax로 JSON을 요청해보자. app.js에서 JSONP 버튼을 누르면 위에서 만든 HTTP 서버로 test.json을 요청할 것이다. Sencha Touch에서 Ajax를 요청하기 위해서는 Ext.Ajax.request를 이용해서 ajax 요청을 할 수 있다. 서버측으로 부터 받은 json은 문자열이기 때문에 Ext.decode를 이용해서 json 문자열을 json object로 변경한다.

```javascript
/**
 *
 * filename : app.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

Ext.application({
    name:"SenchaTutorial",
    launch:function () {

        var button = {
            xtype:"button",
            text:"JSONP",
            ui:"confirm",
            align:"right",
            handler:function () {
                Ext.Viewport.mask();
                var url = 'http://localhost:8080/test.json';

                Ext.Ajax.request({
                    url:url,
                    headers:{
                        "Content-Type":"application/json"
                    },
                    sucess:function (response) {
                        var obj = Ext.decode(response.responseText);
                        Ext.Msg.alert("Confirm", "My Name is : " + obj.name);

                        Ext.Viewport.unmask();
                    }
                });
            }
        };

        var titlebar = {
            xtype:'titlebar',
            title:"JSONP Test",
            docked:"top",
            items:[button]
        };

        var rootPanel = {
            xtype:"panel",
            layout:"fit",
            items:[titlebar]

        };

        Ext.Viewport.add(rootPanel)
    }
});
```

위 코드를 브라우저에서 실행해보았다. 브라우저에서 index.html 파일은  `file://` 로 시작하는 로컬파일이다. 이 파일에서 http://localhost 인 크로스 도메인으로 ajax를 요청하면 XMLHttpRequest를 사용할 수 없다는 에러를 발생한다.

![](http://asset.hibrainapps.net/saltfactory/images/1571af2c-581d-4ad9-8790-e4b68589b854)

### JSONP 요청

이제 우리는 JSONP를 요청하는 코드로 변경할 것이다. Sencha에서 JSONP는 `Ext.data.JsonP.request`를 이용해서 크로스 도메인으로 JSON 데이터를 요청할 수 있다. 이때 payload를 가지고 리턴할 callback 함수의 이름을 서버측으로 넘겨주는데 callback Key에 파라미터의 이름으로 넘겨준다. 즉 http://localhost:8080/test.json?callback=callbackfunc 으로 될 수 있기 callback 이라는 파라미터 이름으로 넘겨주게 된다. 서버에서 받은 JSON은 payload로 넘겨받은 것 자체가 json으로 되기 때문에 json의 key 로 데이터를 가져올 수 있다. 서버측에서 payload로 넘겨주는 json은 `{name:"saltfactory"} `이다.


```javascript
/**
 *
 * filename : app.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

Ext.application({
    name:"SenchaTutorial",
    launch:function () {

        var button = {
            xtype:"button",
            text:"JSONP",
            ui:"confirm",
            align:"right",
            handler:function () {
                Ext.Viewport.mask();
                var url = 'http://localhost:8080/test.json';

                Ext.data.JsonP.request({
                    url:url,
                    callbackKey:'callback',
                    headers:{
                        "Content-Type":"application/javascript"
                    },
                    success:function (json) {
                        Ext.Msg.alert("Confirm", "My Name is : " + json.name);

                        Ext.Viewport.unmask();
                    }
                });
            }
        };

        var titlebar = {
            xtype:'titlebar',
            title:"JSONP Test",
            docked:"top",
            items:[button]
        };

        var rootPanel = {
            xtype:"panel",
            layout:"fit",
            items:[titlebar]

        };

        Ext.Viewport.add(rootPanel)
    }
});
```

이제 서버측으로 요청해보자. 그런데 app.js에서 요청하는 JSONP는 정상적인데 서버측에서 받게된 JSON 객체를 파싱하는데 문제가 발생한다. 크로스도메인으로 JavaScript 코드를 요청하는데 문제는 발생하지 않지만, JSONP는 payload를 넘겨주는 function으로 wrapping을 해줘야하기 때문이다.

![](http://asset.hibrainapps.net/saltfactory/images/a4e45dca-3a66-4dcc-8c45-8c3140da0663)


![](http://asset.hibrainapps.net/saltfactory/images/9872f591-e4fa-43b5-b74d-76a418c1f47e)


그래서 서버에 코드를 다음과 같이 callback 파라미터가 가지고 오는 callback function 이름으로 json을 payload로 wrapping하도록 한다. 이때 Content-Type은 application/json에서 application/javascript로 변경해서 javascript callback function과 payload를 전송한다.


```javascript
/**
 *
 * filename : server.js
 * author : saltfactory@gmail.com
 * license : CC BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/2.0/)
 *
 */

var http = require('http');
var url = require('url');

var server = http.createServer(function (req, res) {
    if (req.url == '/favicon.ico') {
        res.writeHead(404, {'Content-type':'text/plain'});
        res.end('not found');
    } else {

        var parts = url.parse(req.url, true);
        var callback = parts.query.callback;

        console.log(callback);

        var obj = {name:'saltfactory'};

        res.writeHead(200, {"Content-Type":"application/javascript"});
        res.write(callback+"("+JSON.stringify(obj)+")");
        res.end();
    }
});
server.listen(8080);
```

브라우저에서 다시한번 테스트하면 Sencha Touch에서 JSONP를 요청하기 위해서 넘기는 callback 함수의 이름이 Ext.data.JsonP.callback1 이라는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/76ad3abc-f838-47e3-8aab-3c39da8251f9)

## 결론

Sencha Touchs는 서버에서 모바일 웹 서비스를 만들 뿐만 아니라 클라이언트 로컬에 돌아가는 앱을 만들 수 있다. 이때 로컬 도메인과 서버측 도메인과 서로 다른 도메인이기 때문에 서버측으로 JSON 데이터를 요청하는데 보안상 문제가 발생하게 된다. 이 문제를 해결하기 위해서 Sencha Touch는 JSONP 요청을 쉽게 사구현할 수 있게 내장 모듈을 가지고 있다. JSONP는 서버측에 application/javascript의 타입의 JSON을 payload로 가지는 callback function을 만들어서 넘겨주게 되는데 이는 Java, PHP, nodejs 등 서버 프로그램에서 구현해줘야 한다. Sencha Touch는 무거운 웹 앱 프레임워크라는 말이 많지만 여러가지 편리한 기능이 포함되어 있다. 그리고 잘 구조화된 모듈 때문에 Ajax를 요청하거나 JSONP를 요청할 때 데이터를 요청하는 코드만 변경해주면 다른 코드에 영향을 주지않고 크로스 도메인의 데이터 요청 문제를 해결할 수 있다.

## 참고

1. http://docs.sencha.com/touch/2-0/#!/guide/ajax
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.data.JsonP
3. http://nodeguide.com/beginner.html


