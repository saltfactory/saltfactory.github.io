---
layout: post
title: 자체 Https 테스트를 위해 OpenSSL과 Node.js로 Https Server 만들기
category: node
tags: [node, https, node.js, ssl, openssl, certificates, certs]
comments: true
redirect_from: /221/
disqus_identifier : http://blog.saltfactory.net/221
images :
  title : http://assets.hibrainapps.net/images/rest/data/511?size=full
---

## 서론

[HTTS](https://en.wikipedia.org/wiki/HTTPS)는 HTTP 보안 프로토콜이다. http로 전송되는 데이터를 암호화해서 보안을 위해서 최근에는 로그인이나 API 등 보안에 민감한 요청은 https를 사용한다. https에서 s는 secure socket을 사용한다는 말이다. https는 인증서를 등록해서 사용하는데 최신 브라우저에서는 https로 접근하면 보안 프로토콜을 사용한다는 표시를 한다거나 인증서 확인을하는 작업등을 한다. 이런 이유 때문에 클리언트 프로그램이 https로 요청하면 인증처리하는 과정을 거쳐야하기 때문에 일반 http 요청과 다른 과정이 필요하다. 개발할 때 https를 테스트하기 위해서 https에 사용되는 인증서를 구입해서 개발할 수는 없다. https에 사용하기 위해서 인증서를 만들더라도 https는 하나의 도메인만 적용되고 그 가격도 너무 고가이기 때문에 개발용 서버에 https 인증서를 구입하는 것은 효율적이지 못하기 때문이다. 그럼 어떻게 개발용으로 https 서버를 구현할 수 있을까? 다행히 [OpenSSL](https://www.openssl.org/)을 사용하면 자체 인증서를 만들 수 있다. 하지만 공인으로 등록된 인증서가 아니기 때문에 OpenSSL로 만든 인증서는 실제 서비스를 하는데는 무리가 있다. 하지만 개발용으로는 충분히 사용할 수 있기 때문에 어떻게 https 서버를 구현해서 사용할 수 있는지 소개한다.
<!--more-->

## 개인키 발급

우리가 첫번째 해야할 일은 개인키를 발급하는 것이다. OpenSSL에서 **genrsa**는 키를 [RSA 알고리즘](https://en.wikipedia.org/wiki/RSA_(cryptosystem))으로 만들겠다는 말이고 **1024**는 RSA 알고리즘을 1024로 만들겠다는 말이다.

```
openssl genrsa 1024 > key.pem
```

![개인키발급](http://cfile8.uf.tistory.com/image/2746CF3F52E72FEB1F0427)

이렇게 만들어진 파일을 열어보면 다음과 같다. RSA로 **PRIVATE KEY**로 만들어진 것을 확인할 수 있다.

![개인키발급결과](http://cfile8.uf.tistory.com/image/2136364352E7303C179D43)

## Cert 인증서 파일 생성하기

다음은 개인키를 가지고 디지털 인증서를 만들자.

```
openssl req -x509 -new -key key.pem > cert.pem
```

![인증서 파일 생성](http://cfile3.uf.tistory.com/image/267F333E52E735CC34F4F3)

인증서를 만들기 위해서는 몇가지 기입해야할 정보가 있다. 공인 인증기관에서 만드는 곳에서도 이와 동일한 항목들을 받아서 만들어지는데 OpenSSL로 인증서를 만드는 기관은 바로 자신이므로 항목에 입력을하면 디지털 인증서가 만들어진다. 물론 공인된 인증서는 아니다. 인증서 파일을 열어보면 다음과 같다.

![인증서 파일 생성 결과](http://cfile8.uf.tistory.com/image/216DB73E52E737B60CB1EA)

## Http 서버 만들기

http 테스트를 하기 위해서는 웹 서버, http 서버가 필요하다. apache와 nginx 등 다양한 웹 서버가 있지만 테스트를 위해서 간단하게 Node.js로 http 서버를 구현한다. Node.js 자체로 웹 서비스를 구현할 수 있지만 우리는 좀더 간편하게 구현하기 위해서 expressjs 웹 프레임워크를 사용한다.
expressjs를 npm으로 설치하자.

```
npm install express
```

express가 설치가되면 간단한 웹 서비스를 만든다.예제 코드는 다음과 같다. 코드는 간단하다. 단순히 로그인 페이지를 하나 만들고 로그인 버튼을 누르면 userId와 password를 전송하는 웹 서비스를 구현했다.

```javascript
var http = require('http'),
    express = require('express');

var port = 3000;
var app = express();
app.use(express.urlencoded());


var server = http.createServer(app).listen(port, function(){
  console.log("Http server listening on port " + port);
});



app.get('/', function (req, res) {
	res.writeHead(200, {'Content-Type' : 'text/html'});
	res.write('<h3>Welcome</h3>');
	res.write('<a href="/login">Please login</a>');
	res.end();
});

app.get('/login', function (req, res){
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write('<h3>Login</h3>');
	res.write('<form method="POST" action="/login">');
	res.write('<label name="userId">UserId : </label>')
	res.write('<input type="text" name="userId"><br/>');
	res.write('<label name="password">Password : </label>')
	res.write('<input type="password" name="password"><br/>');
	res.write('<input type="submit" name="login" value="Login">');
	res.write('</form>');
	res.end();
})

app.post('/login', function (req, res){
	var userId = req.param("userId");
	var password = req.param("password")

	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write('Thank you, '+userId+', you are now logged in.');
	res.write('<p><a href="/"> back home</a>');
	res.end();
});
```

이제 웹 서비스를 실행해보자.

```
node app.js
```

![http 서버 실행](http://cfile9.uf.tistory.com/image/2210B13652E7509D2FA14E)

이렇게 http 서버와 로그인 서비스를 만들고 나서 http 로 전송되는 패킷을 캡쳐해보자. 패킷캡쳐는 WireShark라는 툴을 사용하면 간단하게 캡쳐할 수 있다.
우리는 POST로 userId와 password를 넘기는데 이것을 캡쳐하기로 한다.

![패킷분석](http://cfile3.uf.tistory.com/image/24211D3552E751463A906E)

어떤가? 아주 깜짝 놀라는 결과를 얻게 될 것이다. 패킷캡처 툴로 아주 간단하게 userId와 password를 알아낼 수 있다. 간단하고 보안상 문제되지 않는 데이터는 http POST로 암호화 없이 전송해도 괜찮지만, 로그인 정보는 보안상 아주 중요한 문제가 된다. 그래서 우리는 위에서 만든 디지털 보안 인증서를 가지고 https를 구현해보기로 한다.

## Https 서버 구현

위의 코드를 다음과 같이 변경한다. 이전에 구현된 http에 https를 추가했다. port는 각각 80, 443으로 동작하게 한다. https는 443 포트로 동작하기 때문이다.

```javascript
var http=require('http'),
	https = require('https'),
	express = require('express'),
 	fs = require('fs');

var options = {
	key: fs.readFileSync('key.pem'),
	cert: fs.readFileSync('cert.pem')
};


var port1 = 80;
var port2 = 443;

var app = express();
app.use(express.urlencoded());

http.createServer(app).listen(port1, function(){
  console.log("Http server listening on port " + port1);
});


https.createServer(options, app).listen(port2, function(){
  console.log("Https server listening on port " + port2);
});

app.get('/', function (req, res) {
	res.writeHead(200, {'Content-Type' : 'text/html'});
	res.write('<h3>Welcome</h3>');
	res.write('<a href="/login">Please login</a>');
	res.end();
});

app.get('/login', function (req, res){
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write('<h3>Login</h3>');
	res.write('<form method="POST" action="/login">');
	res.write('<label name="userId">UserId : </label>')
	res.write('<input type="text" name="userId"><br/>');
	res.write('<label name="password">Password : </label>')
	res.write('<input type="password" name="password"><br/>');
	res.write('<input type="submit" name="login" value="Login">');
	res.write('</form>');
	res.end();
})

app.post('/login', function (req, res){
	var userId = req.param("userId");
	var password = req.param("password")

	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write('Thank you, '+userId+', you are now logged in.');
	res.write('<p><a href="/"> back home</a>');
	res.end();
});
```

다시 node를 실행해보자.

```
node app.js
```

브라우저를 열어서 두가지모두 접근해보자 http://localhost/login 과 https://localhost/login 으로 접근한다. 어떠한가 https로 접근하면 다음과 같이 인증서를 확인할 수 있다.

![https 요청](http://cfile4.uf.tistory.com/image/2558DC3B52E7653D22B78B)

![https 요청 결과](http://cfile6.uf.tistory.com/image/267ED53C52E764A72F92FD)

그럼 패킷은 과연 암호화 되어서 날아가는지 확인해보자. 위와 마찬가지로 WireShark를 사용한다. WireShark에서 패킷을 분석하기 위해서 여러가지 필터 옵션을 추가할 수 있는데 http.request.method=="POST"로 하면 http로 요청되는 POST 데이터를 잡을 수 있다. 하지만 https 옵션이 없기 때문에 tpc.port=443으로 필터를 넣고 캡처했다.

![https 패킷분석](http://cfile29.uf.tistory.com/image/24159A3B52E7658A072C7B)

캡처한 패킷을 살펴보면 모두 TLS로 패킷이 암호화 되어 있는 것을 확인할 수 있다.


## 결론

이제 우리는 https 서버를 간단하게 구축하였다. 이렇게 테스트할 수 있는 간단한 서버를 만든 이유는 웹 프로그램이 주 목적이 아니라 모바일 디바이스에서 https 요청을 하기 위해서 테스트할 서버가 필요했기 때문이다. 즉 https 통신을 받아줄 서버가 필요한데 이미 다른 개발 서버에는 적용할 수 없었고, 이미 디플로이된 서버에 테스트를 할 수 없었기 때문에 간단한 https 서버가 필요했다. 복잡하고 어렵게 서버를 구축할 필요없고, 프론트 개발자나 모바일 개발자는 자신의 PC에 간단하게 https 서버를 구축해서 테스트 할 수 있을 것으로 예상된다.

## 참고

1. http://nodejs.org/api/https.html
2. http://www.wireshark.org
3. http://stackoverflow.com/questions/16610612/create-https-server-with-node-js
4. http://www.itechlounge.net/2013/10/mac-wireshark-wont-start-and-ask-for-x11-with-osx-mavericks/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
