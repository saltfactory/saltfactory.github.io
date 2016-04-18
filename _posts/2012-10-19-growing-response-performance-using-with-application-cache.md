---
layout: post
title: HTML5의 Application Cache를 이용하여 웹 페이지 응답속도 높이기
category: html5
tags: [html, html5, application cache, cache, performance]
comments: true
redirect_from: /202/
disqus_identifier : http://blog.saltfactory.net/202
---


## 서론

연구소에서 HTML5를 부분적으로 도입하기로 결정하면서 여러가지 **HTML5 API**를 이젠 적용할 수 있는 범위를 정할 수 있게 테스트를 하고 있다. HTML5는 단순히 Hyper Text Markup Language가 아니라는 것을 조금씩 알아가고 있다. 트랜드를 아는 것과 실제 사용하기 위해서 하나하나 테스트를 하는 것과는 연구하는 사람에게 너무나 다르게 느껴진다. 이번 포스팅은 HTML5의 [Application Cache](http://www.html5rocks.com/en/tutorials/appcache/beginner/)에 대한 소개를 하고자 한다.

<!--more-->

Application Cache는 HTML5에서 Offline Application을 위해서 만들어진 API 이지만 Application Cache의 가장 큰 장점은 바로 웹의 자원을 Application Level에서 Cache를 제어할 수 있다는 것이다. 이미 Application Cache에 대한 포스팅도 있고 이 기술이 공개된지는 오래 되었지만 내가 연구하는 연구소에서 도입할 범위를 정하기 위해서 연구소내 공유 목적으로 포스팅을 하려고 한다. 만약 Application Cache에 대한 좀 더 심도 깊은 내용은 참고[[1]](http://www.html5rocks.com/en/tutorials/appcache/beginner/)[[2]](http://xguru.net/621) 사이트에서 정보를 보충하길 바란다.


우리가 생각하는 사이트의 첫번째 문제는 화면이 로딩될 때 많은 이미지를 가져오는데 시간이 소요된다는 것이다. 그것이 광고든지, 아니면 주기적으로 자주 변하는 이지든 말이다. HTML5가 나오기 전에 우리는 어떻게 웹 프로그래밍을 했는지 생각해볼 필요가 있다. HTML을 우리는 단순히 Markup Language로 생각하고 데이터를 표현하는 것만 생각했지 HTML의 속도를 높이기 위해서 어떻게 구성할 것이며 어떻게 구조화 시킬것이고 요청을 어떻게 나눌 것인지에 대해서 깊게 생각하지 않았다는게 현실이다. (물론 기존에도 이런 고민을 깊게하는 웹 개발자가 있었겠지만 그런 웹 개발자는 흔하지 않았다) 하지만 HTML5에서는 다양한 API와 여러가지 성능을 높이는 기법들이 공개되면서 더이상 웹 프로그램을 서버에서만 부하를 담당하고 연산해서 HTML은 단순히 데이터를 표현해주는 것이라는 생각을 완전히 바꾸게 만들었다. 서버 중심의 웹 데이터들이 클라이언트로 쉽게 데이터나 연산을 분산시키고 재활용할 수 있게 만들수 있게 해준 것이다.

### Application Cache 미적용

HTML5 application cache를 테스트하기 위해서 우선 application cache가 적용되지 않은 코드를 다음과 같이 작성하였다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>HTML5 Application Cache</title>
    <link href="css/style.css" rel="stylesheet"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <script src="js/app.js"></script>
</head>
<body>
        <header>
            <h1 id="title">HTML5 Application Cache</h1>
        </header>
        <section>
            <article id="contents">
                <h2 id="subject" class="subjects">HTML5 Application Cache example</h2>
                <ul>
                    <li>app.js cached.</li>
                    <li><img src="images/1.png"/></li>
                </ul>
            </article>
        </section>

</body>
</html>
```

서버에 HTML 파일을 저장하고 요청을 해봤다. 아무런 caching 작업 없이 HTML 웹 사이트를 제작했다고 생각하고 웹 페이지를 최초 요청하였을 때이다. 예상대로 모든 요청을 처음하기 때문에 각각 URL 요청이 들어가는 부분은 네트워크 요청 시간이 포함되어서 시간이 길게 나타난다. 특히 jquery를 요청할 때는 google library host를 이용해서 구글서버까지 요청시간을 더해진 것을 확인할 수 있다. 이미지가 70kb 인것도 네트워크 요청에서 시간을 필요한 부분이다.

![](http://asset.hibrainapps.net/saltfactory/images/ca03af89-d723-4a47-8ac8-c2a4101ff565)

한번 요청한 페이지를 다시 같은 URL로 재 요청을 해봤다. 최초 HTTP 200 code의 결과와 달리 이번에는 HTTP 304 code의 결과를 반환하면서 최초의 로딩 속도 (669ms) 보다는 189ms로 많이 빨라졌다. 304 code는 이미 요청한 자원을 서버측의 내용과 변경된 것이 없다는 것을 확인한 코드인데 이 요청 때문에 서버의 자원과 비교하는 시간이 소비가 된다. 하지만 원래 브라우저가 동작하는 방식이 한번 읽은 Javascript/css/images 들은 temporary 디렉토리 같은 곳에 자체적으로 저장해서 웹 요청 시간을 단축시키기 때문에 최초의 요청시간보다는 많은 시간이 단축된 것을 확인할 수 있다. 다만 304 code를 계속 확인하는 시간은 포함이 되어 있다.

![](http://asset.hibrainapps.net/saltfactory/images/20cece35-eccc-40fe-ad6f-ccf8067543ce)

### Application Cache 적용

이제 HTML5의 application cache 를 적용해보자. application cache를 적용하기 위해서는 HTML 문서에 manifest를 지정해야하는데 일종의 캐시설정 규칙을 파일로 저장하는 것이다.  appcache.manifest 라는 파일을 html 문서와 동일한 곳에 아래 내용으로 저장하였다. 노란색으로 표시가 되어 있는 부분이 캐시 규칙을 설정하는 부분이다. 가장 상단의 CACHE MANIFEST는 반드시 포함되어야 하는 것이고 CACHE는 한번 요청한 다음에 caching 되어지는 URL 규칙이다. 이와 동일한 URL 이 브라우저에서 요청되어지게 되면 이 설정된 부분을 보고 application cache에 저장된 자원을 재사용하게 된다. NETWORK: 는 말 그대로 이 HTML 페이지가 요청될때 캐싱과 상관없이 매번 네트워크 요청을하는 URL 규칙이 들어가진다. 마지막으로 FALLBACK:은 URL요청을 했을때 실패가 일어나면 대처하는 URL을 정의해서 다른 URL 요청으로 대신하는 규칙을 만들 수 있다.

```
CACHE MANIFEST
# version 0.1.0

CACHE:
css/style.css
js/app.js
images/1.png
http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js

NETWORK:

FALLBACK:
```

한가지 주의해야할 점은 이 manifest가 서버에서 요청할때 header 정보에 Content-Type이 text/cache-manifest 로 되어야지만 정상적으로 요청을 받고 적용을 할 수 있다는 것이다. 그래서 서버 프로그램에 Content-Type="text/cache-manifest" 등을 지정해줘야한다. (manifest 파일을 php, jsp 로 만들 수 있다.). 아니면 apache 웹 서버를 사용하면 간단하게 .htaccess 파일에 다음과 같이 추가한다.

```
AddType text/cache-manifest .manifest
```

이제 이 application cache manifest를 HTML문서가 요청될 때 브라우저가 HTML5 application level에서 이해를 해야하기 때문에 HTML 파일을 다음과 같이 수정한다. HTML5 문서에 manifest의 설정 파일을 지정하고 window가 load 될 때 applicationCache의 업데이트 이벤트를 감지해서 변경된 것이 있으면 applicationCache를  swapCache를 하고 reload를 시켜서 application cache를 업데이하는 코드를 추가했다. 그리고 manifest에서 설정된 URL과 동일한 것이 표시했다. 다시 html 을 재요청해보자.

```html
<!DOCTYPE html>
<html  manifest="appcache.manifest">
<head>
    <meta charset="utf-8"/>
    <title>HTML5 Application Cache</title>
    <link href="css/style.css" rel="stylesheet"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <script src="js/app.js"></script>
    <script type="text/javascript">
        window.addEventListener('load', function(e) {
            window.applicationCache.addEventListener('updateready', function(e) {
                if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {
                    window.applicationCache.swapCache();

                    if (confirm('A new version of this site is available. Load it?')) {
                        window.location.reload();
                    }
                } else {}
            },false);
        },false);

    </script>

</head>
<body>
        <header>
            <h1 id="title">HTML5 Application Cache</h1>
        </header>
        <section>
            <article id="contents">
                <h2 id="subject" class="subjects">HTML5 Application Cache example</h2>
                <ul>

                    <li><img src="images/1.png"/></li>
                </ul>
            </article>
        </section>

</body>
</html>

```

응답속도는 놀라울 만큼 빨라졌다. 최초 로드 속도를 제외하고 304를 요청하던 요청 결과가 189ms 였는데 application cache를 하게 적용하게 되면 manifest를 읽어들여서 CACHE에 정의된 요청은 cache로 부터 불러오기 때문에 모두 200 code 결과가 나오면서 서버와의 통신을 하지 않게 되기 때문에 모든 것이 네트워크 요청없이 cache에서 불러왔기 때문이다.

![](http://asset.hibrainapps.net/saltfactory/images/937929c8-528d-43e5-b82f-90bbc8473126)

HTML5 application cache를 사용하면 브라우저에서 resouces가 어떻게 저장되는지 확인할 수 있다. resources 탭을 눌러서 Application Cache 를 확인해보자. 이렇게 manifest에 정의한 cache 정보를 부라우저가 HTML5 문서에 해석해서 application 레벨에서 cache를 관리하게 된다.

![](http://asset.hibrainapps.net/saltfactory/images/1b6845a5-14b4-4b60-9108-b08e7a8ac0f4)

캐시를 지우고 싶을 경우에는 크롬 브라우저에서 application cache를 보는 URL로 접근해서 삭제할 수 있다. chrome://appcache-internals/ 을 URL 입력창에 입력하면 다음과 같은 화면이 나타난다. 이것을 보면 manifest 파일에 관련된 캐시 정보를 가지고 있다는 것을 확인할 수 있고 Remove로 삭제할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/ddb1295c-d599-4640-b572-025263a63429)

View Entires를 클릭하면 manifest의 자세한 정보를 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/676d967d-79b7-4059-8925-9ed699e89d74)

그런데 한가지 주의할 점이 있다. HTML5 application cache를 사용하게 되면 cache를 적용한 html 파일이 자동으로 캐싱이 되어 버린다는 것이다. 그래서 HTML문서를 수정하더라도 cache 되어 있는 html 파일을 로드하기 때문에 적용되지가 않는다. manifest에서 html 문서를 NETWORK: 로 정의해도 html 문서만은 자동으로 캐싱되기 때문에 적용이 되지 않는다. 방법은 manifest를 변경해서 application cache가 업데이트 되어서 window.location.reload()를 해야만 한다는 것이다.

HTML5 application cache 은 훌륭한 cache 기법 application level에서 (서버설정없이) 할 수 있다는 것이 가장 큰 강점이다. 만약에 javascript 파일이 지속적으로 업데이트되는 (원격 업데이트)를 하고 싶으면 NETWORK: 쪽에 정의를 하면 된다. app.js는 수시로 변할 수 있는 파일이라고 가정하고 NETWORK: 아래에 정의를 하고 페이지를 다시 요청을 했다. 나머지는 모두 from cache로 캐시된 것에서 불러오지만 app.js 파일만은 서버에서 다시 요청을 하게된다.

![](http://asset.hibrainapps.net/saltfactory/images/906ef0b6-04ab-421e-b3b0-c63b2ab73a5c)

## 결론

웹 서버에서 Cache를 하거나 브라우저에 Cache 정책을 잘 세우게 되면 웹 페이지의 응답속도를 많이 줄일 수 있다. 특히 고정 이미지가 많거나 잘 수정되지 않는 대용량 리소스(javascript, css)파일을 캐싱하게 되면 URL request 요청을 줄이게 되어서 응답속도를 빠르게 만들 수 있다는 것을 위 테스트에서 확인을 하였다. 테스트 파일은 단순하게 javascript, css, image 파일이 하나뿐이지만 실제 한 웹 페이지에서 여러개가 사용되고 있고 브라우저가 이들 요청을 한번에 처리할 수 있는 요청은 한계가 있기 때문에 리소스를 원격 URL 요청으로 다운받아서 HTML 문서를 로드하는데는 많은 시간이 걸린다. HTML5 application cache를 사용하게 되면 URL HTTP request를 최소한으로 만들 수 있다. 그리고 잘 설계하고 이용해서 offline 문서를 만들 수도 있다는 것을 확인하였다. 광고 이미지가 많은 사이트에 HTML5 Application Cache를 적용하면 원격이미지 요청 네트워크 부하를 줄일 수 있다. 하지만 광고는 기간제한이 있다. 즉 광고가 끝나고 다른 광고 이미지로 대처해야하는 문제가 있는데 이것은 manifest파일을 광고가 변할 때 마다 갱신시켜주면 된다. manifest 파일은 확장자에 제한이 없다. 즉, php나 jsp 같은 언어로 manifest 파일을 원격서버에 프로그래밍으로 만들면 된다. manifest 파일이 변경되면 HTML5 문서에서 window.applicationCache.status에서 UPDATEREADY 상태로 변경되기 때문에 새로운 이미지가 갱신이 될 것이다. HTML5는 웹 앱을 만드는 많은 기능을 추가했다지만, 이 말은 웹 서비스의 성능을 높일 수 있는 기능이 많이 추가되었다는 말이기도 하다. 구형 브라우저가 아닌 HTML5 을 해석할 수 있는 브라우저, 모바일 브라우저를 위해서 지금이라도 HTML5 Application Cache 기능을 사용해보길 권유하고 싶다. 특히 모바일 브라우저를 위한 웹을 만든다고 한다면 이 Application Cache 기능이 성능 향상에 크게 도움을 줄 수 있을 것으로 예상된다.

## 참고

1. http://www.html5rocks.com/en/tutorials/appcache/beginner/
2. http://xguru.net/621


