---
layout: post
title : Yobi와 Apache 연동시 encoded slash 문제 RewriteRule로 해결하기
category : git
tags : [git, yobi, safari]
comments : true
redirect_from : /258/
disqus_identifier : http://blog.saltfactory.net/258
---

## 서론

Apache는 기본으로 URLEncoding을 하게 되어 있다. 이런 이유 때문에 특수 문자열을 함번 인코딩을해서 **%**와 같이 변환이 된 URL을 다시 요청하게 되면 자동으로 **%**에 대한 문자를 인코딩을 하는 문제가 발생한다. Yobi와 Apache를 연동할 때 Yobi에서 변경한 인코딩 URL을 중복으로 인코딩하지 않게 하는 방법에 대해서 소개한다.

<!--more-->

## Yobi

우리 연구소에서는 [gitlab](https://about.gitlab.com/)을 사용하여 소스코드를 관리하고 있다가 Naver Lab에서 만든 [Yobi](https://github.com/naver/yobi)로 프로젝트와 소스를 관리하기로 결정하고 마이그레이션 하였다. Yobi는 우리가 흔히 알고 있는 [GitHub](https://github.com)와 같이 git를 사용하여 소스를 관리할 때 웹에서 협업을 할 수 있는 [SCM](http://en.wikipedia.org/wiki/Software_configuration_management)이다. Yobi는 [Scala](http://www.scala-lang.org/) 기반의 [Play](https://www.playframework.com/) framework으로 만들어졌다. 기존의 gitlab은 Ruby기반으로 만들어져 있고 설정이 매우 까다로웠다. 하지만 Yobi는 서버에 JDK 7이 설치되어 있으면 간단하게 설치할 수 있는 장점이 있다. 더구나 우리는 HTTP를 지원하는 git 시스템을 원했기 때문에 Yobi는 우리의 필요조건을 모두 충족시켜 주었다.

## Yobi 서버 실행

Yobi는 [GitHub](https://github.com/naver/yobi)에서 `clone`을 하고 `play`를 실행시키면 자동으로 필요한 패키지들을 자동으로 다운받고 서버가 실행된다. 시작하는 방법도 아래와 같이 메모리옵션을 지정하고 `play`를 실행시켜면 된다.

```
_JAVA_OPTIONS="-Xmx2048m -Xms1024m" play "start -DapplyEvolutions.default=true -Dhttp.port=9000"
```

## Yobi와 Apache mod_proxy

Yobi는 Play framework를 사용하고 있기 때문에 자체 웹 서버를 동작시킬 수 있다. 만약 **80**번 포트를 사용하고 싶으면 Play 서버를 시작할 때 포트번호를 80번으로 지정하면 `http://`로 특별한 설정없이 http 서비스를 시작할 수 있다. 하지만 우리 연구실에서는 Front Web Server로 Apache를 사용하고 있었기 때문에 Apache와 Yobi를 연동하는 작업을 해야했다. 우리는 Yobi의 서버를 뒷단에서 기본포트로 서비스를 하고 외부에서 접근할 때 Apache를 통해서 들어가도록 설정했다.

처음 우리는 단순히 apache의 [mod_proxy](http://httpd.apache.org/docs/current/mod/mod_proxy.html)를 사용해서 Yobi 서버로 요청이 전달되게 했다.

```
ProxyRequests Off
ProxyVia Off
ProxyPreserveHost On

ProxyPass / http://127.0.0.1:9000/
ProxyPassReverse / http://127.0.0.1:9000/

<Proxy *>
	Order deny,allow
	Allow from all
</Proxy>

```

하지만 Apache로 proxy를 사용할 때 **encoded slash** 문제가 발생한다는 것을 알게 되었다.

## Encoded slash 문제

Yobi는 branch를 선택하면 JavaScript로 branch를 URL로 표현할 때 `encodedURL()`를 사용해서 요청한다. 만약 **DemoApp**이라는 프로젝트에 **1.0-dev**라는 branch가 있을 경우 Yobi는 이것을 표현하기 위해서 `http://%{HTTP_HOST}:9000/DemoApp/code/refs%2Fheads%2F2.0-dev` 라는 URL 요청을 하게 되는 것이다.

만약 Apache를 사용하지 않고 Play만 사용해서 서비스를 한다면 이 URL은 문제가 되지 않는다. 하지만 Apache를 사용하게 되면 자동으로 URL 인코딩을 지원하기 때문에 이중 인코딩 문제가 발생한다. 다시 말해서 `%2F`로 인코딩 된 URL을 Play 서버로 넘기기 위해서는 `%252F`인코딩으로 요청을 해야하는 것이다.

Yobi에서 정상적인 URL 요청은 다음과 같다.

```
http://%{HTTP_HOST}:9000/DemoApp/code/refs%2Fheads%2F2.0-dev
```

이 요청을 Apache를 사용해서 URL 요청을 한다고 하면 아래와 같이 요청하게 될 것이다.

```
https://%{HTTP_HOST}:9000/DemoApp/code/refs%2Fheads%2F2.0-dev
```

하지만 이렇게 요청하면 페이지를 찾을 수 없다고 **404 Not found** 에러를 보게 될 것이다. 이유는 Apache가 가지고 있는 자체 URL encoder 때문이다. 그래서 Yobi에서 `%2F`를 이해하기 위해서 다음과 같이 `%252F`로 요청을 해야한다. 왜냐면 Apache에 `%2F`라고 입력한다고 해도 Apache 내부에서는 이것을 자동올 `/` 인식해버리기 때문에 proxy로 넘기면 encoded URL이 넘어가지 않기 때문이다.

```
https://%{HTTP_HOST}:9000/DemoApp/code/refs%252Fheads%252F2.0-dev
```

이렇게 하기 위해서는 Yobi에서 URL 요청이 들어오는 것을 디코딩하는 소스 코드를 분석해서 디코딩하는 소스를 변경해야한다. 우리는 Naver에서 업데이트하는 소스코드를 `fetch`와 `pull`을 하는데 변경없이 적용하기 위해서 소스코드를 건드리지 않고 싶었다. 그래서 우리는 Apache의 **mod_proxy**를 사용하지 않고 [mode_rewrite](http://httpd.apache.org/docs/current/mod/mod_rewrite.html)를 사용하기로 결정했다.

## Yobi와 Apache mod_rewrite

Apache의 [mod_rewrite](http://httpd.apache.org/docs/current/mod/mod_rewrite.html) URL 요청이 들어오면 특별한 형태로 URL요청을 변경하는 모듈이다.
우리는 모든 요청을 `https` 요청을 `http://%{HTTP_HOST}:9000`으로 rewrite 시키도록 했다.

> /refs/heads/ 요청이 들어오면 우리는 이것을 Yobi로 넘길 때 encoded URL로 변경하도록 /refs%2Fhead%2 로 URL을 rewrite 하도록 했다.

```
AllowEncodedSlashes On

RewriteEngine On
RewriteCond %{HTTPS} on
RewriteRule ^(.*)/refs/heads/(.*)$ http://%{HTTP_HOST}:9000$1/refs\%2Fheads\%2F$2 [P,L,NE]
RewriteRule .* http://%{HTTP_HOST}:9000%{REQUEST_URI} [P,L,NE]

RewriteLogLevel 9
RewriteLog ${APACHE_LOG_DIR}/servername-rewrite.log
```
먼저 우리는 URL의 요청에 포함되어 있는 encoded slash를 받기 위해서 **AllowEncodedSlashes**를 **On**으로 설정했다. 그리고 URL rewrite가 바로 되는지 확인하기 위해서 Apache의 mode_rewrite 모듈의 로깅을 하기 위해서 **RewriteLog**를 설정했다. **RewriteLogLevle**을 지정해서 들어오는 모든 요청을 디버깅하면서 **RewriteRule**의 규칙을 설정했다.

```
RewriteRule ^(.*)/refs/heads/(.*)$ http://%{HTTP_HOST}:9000$1/refs\%2Fheads\%2F$2 [P,L,NE]
```
우리는 **RewriteRule**에 옵션을 다음과 같이 사용했다.
- **P** : proxy (이 옵션을 사용하지 않으면 proxy 되는 것이 아니라 location이 변경되어 버린다)
- **L** : last
- **NE** : no escape

우리가 적용한 **RewriteRule**이 두가지 이다. 하나는 Yobi의 branch요청을 하는 encoded slash를 처리하기 위한 것과 나머지는 모두 Request를 그대로 Yobi로 rewrite 하게 해 두었다.

## 결론

우리는 보안문제로 HTTPS를 사용하고 있고 front web server로 Apache를 사용하고 있었기 때문에 Yobi를 내부에서 요청을 받을 수 있게 Apache의 **mod_proxy**를 사용했다. 하지만 Yobi가 branch를 선택할 때 JavaScript의 `encodedURL()`를 URL로 요청하는데 Apache의 URL encoder때문에 proxy가 될 때 정상적으로 동작하지 않는 것을 발견했다. 그래서 우리는 **mod_rewrite**로 변경했다. **RewriteRule**은 정규표현식을 사용해서 `%2F`를 처리할 수 있게 rewrite를 규칙을 만들었다. Apache의 **mod_rewrite**는 다양한 규칙을 사용해서 우리가 원하는 URL로 변경시킬 수 있다. 우리는 단순히 Yobi의 branch가 만드는 encoded slash를 처리했지만 mod_rewrite를 사용하면 어떠한 URL로 원하는 URL로 변경하여 요청할 수 있도록 할 수 있다. 소스코드를 변경하지 않고 웹 서버단에서 다양한 처리를 할 수 있도록 Apache는 파워풀한 URL rewrite 기능을 가지고 있다.


## 참고

1. http://httpd.apache.org/docs/current/mod/mod_proxy.html
2. http://httpd.apache.org/docs/current/mod/mod_rewrite.html

