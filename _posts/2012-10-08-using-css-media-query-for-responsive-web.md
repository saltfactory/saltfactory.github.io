---
layout: post
title: CSS3 @media query를 이용하여 반응형 웹 스크린 크기 대응하기
category: css
tags: [css, css3, responsive web]
comments: true
redirect_from: /199/
disqus_identifier : http://blog.saltfactory.net/199
---

## 서론

웹 기술은 시간이 지나면서 점점 발전의 가속도가 빨라지고 있다. HTML5와 CSS3의 등장으로 단순하게 정보를 표현하던 정적인 웹을 사용자에게 효과적이고 고급스럽게 비정적인 데이터를 표현을 할 수 있게 해주는 환경을 제공할 수 있게 되었다. PC에서 브라우저로 속에서 표현되던 웹은 디바이스의 발전과 통신망의 발달로 모바일이나 타블릿 등 다양한 디바이스의 브라우저 속에서 표현하는 시대가 도래되었다. 이러한 결과로 사용자들은 더이상 PC에서 보던 브라우저속의 웹 환경을 원하지 않게 되었다. 모바일에 최적된 웹, 태블릿에 최적화 된 웹을 원하게 되었고 서비스 제공자들은 디바이스에 맞는 웹을 개발하기 시작한다. 그래서 서비스 제공자들은 디바이스에 맞는 웹 서비스를 제공하기 위해서, 각각 디바이스에 표현할 수 있는 최적의 환경을 만들기 위해서, 정보를 다르게 표현하기 위해서 각기 다른 뷰어를 만들어서 제공했다.(여기서 말하는 최초의 뷰어는 각각 디바이스에 맞는 최적의 웹 페이지를 만들거나, 다른 도메인 서비스를 하는 등을 말한다.) 하지만 디바이스 크기는 점점 더 다양해져가고 있고 일명 N-screen에 대응하는 개발을 하기 위해서 다른 뷰어들을 만드는 비용이 부담스러워지기 시작했다.

> There is no Mobile Web. There is only The Web, which we view in different ways. There is also no Desktop Web. Or Tablet Web. Thank you.
- Stephen Hay

우리가 흔히 모바일로 웹을 사용할 때 모바일 웹을 사용한다라고 말한다. 하지만 모바일 웹이라는 것은 없다. 단지 웹만이 있다. 테스크탑 웹이나 태블릿 웹이란 것도 없다. 우리는 디바이스라는 함정에 빠져있는 것일 수 있다. 웹은 단지 웹일 뿐이다. 모바일에 들어가는 웹이라고 모바일 웹, 태블릿에 들아간다고 태블릿 웹, 그리고 PC에 들어간다고 PC 웹이라고 생각해서는 안된다는 것이다. 즉, 모바일 웹은 다른 종류의 웹이 아니라 다른 디바이스로 웹을 사용하는 행위를 말하는 것이다.

우리는 **m.** 으로 시작하거나 **mobile.** 으로 시작하는 도메인을 호출하는 모바일 웹 서비스들을 흔히 볼 수 있다. 이러한 서비스는 PC에 최적화된 웹 서비스를 모바일에 맞게 완전히 다른 구성으로 데이터를 표현하기 위해서 모바일에 최적화된 웹 서비스를 구축한 것이다. 웹을 표현하는 방법이 아니라 웹 자체를 모바일용으로 만든 것이다. 실제 이러한 도메인을 PC 브라우저에서 열게되면 당황하게 된다. 모바일에서만 보여지는 화면이 PC에서 보니 당연히 그 구성이 이상하게 나타날 수 밖에 없다. 이러한 서비스의 가장큰 문제는 Twitter나 Facebook을 모바일에서 사용하다가 링크를 공유하게 되면 m. 또는 mobile. 으로 시작하는 링크가 공유되기 때문에, PC 를 사용하는 사용자가 그 링크를 열게되면 모바일 환경에 최적화된 웹 뷰가 나타나게 되는 것이다. (물론 웹 서버나 프로그램상으로 agent를 판단해서 다른 뷰로 redirect 시키거나 하기도 하지만 근본적으로 다른 웹뷰를 만들어서 하나의 웹을 다른 웹으로 표현하는 것이 위 의견에 다른 것이다.) 즉, 다시말하면 웹이 하나가 아니라 두가지가 존재한다는 것이다. 모바일 전용 웹 서비스와 PC용 웹 서비스가 존재해서 두가지가 같은 문서임에도 불구하고 다른 URI를 갖는 문제가 발생한다.

그럼 하나의 웹을 사용하자고 생각하는 순간 하나의 웹을 사용자가 어떤 디바이스를 사용하던지 그 환경에 맞게 자동적으로 반응해서 그 디바이스에 최적화된 데이터를 표현할 방법을 생각해야한다. 웹은 screen에 나타나는 document 이다. screen의 크기에 따라 document의 내용과 정보를 일정 크기의 screen에 가장 최적화 된 구성으로 표현되어 진다면 사용자들은 PC를 사용하던지 모바일이나 태블릿을 사용하던지 사용자가 가장 보기 좋은 구성으로 볼 수 있게 될 것이다. 이러한 연구는 오래전 부터 계속되어져 왔다.

다음은 IT 신기술을 가장 빠르게 적용하는 포털로 스마트폰 보급과 동시에 모바일 최적화 서비스 향상에 힘쓰고 있다. 최초 다음은 모바일 버전을 빠르게 대응하면서 사용자에게 많은 관심을 받게 되었다. 다음 화면은 다음에서 최초 모바일 버전으로 만든 다음 웹 서비스의 화면을 PC에서 열었을때 모습이다. 아래 링크들은 모두 m. 으로 시작하는 모바일에 화면으로만 볼 수 있는 링크를 모두 가지고 있다.

![](http://blog.hibrainapps.net/saltfactory/images/dd67d3e6-b361-4d8d-a760-a2e2be2596b0)

<!--more-->

최근의 다음은 반응형 웹을 사이트에 점차적으로 적용하고 있는 것을 확인할 수 있는데, 이전과 같이 m. 으로 시작하는 모바일 링크가 아니라 PC에서 사용하는 링크를 그대로 사용하면서 디바이스의 스크린에 대응해서 자동적으로 모바일에 최적화된 화면을 보여주고 있다.

![](http://blog.hibrainapps.net/saltfactory/images/fde62f84-aafc-415e-aa4d-f8ea7ad0fba3)

![](http://blog.hibrainapps.net/saltfactory/images/a716b702-18fc-4f66-a8c2-775e3743f151)

![](http://blog.hibrainapps.net/saltfactory/images/a831962e-0be1-4137-8859-97c49e6c7064)

최근에는 CSS3의 @media 쿼리를 이용해서 screen의 크기에 따라서 레이아웃 구성을 다르게하는 방법을 구현할 수 있다. 다음 코드를 index.html 이라는 파일로 만들어서 브라우저에서 열어보자. 그리고 브라우저를 창을 드래그해서 크기를 조절해보자.

```html
<!DOCTYPE HTML>
<html>
<head>
<style type="text/css">
            @media screen and (max-width: 400px) {
                body { background-color: red; }
                h1 { color: white; }
            }
            @media screen and (min-width: 401px) and (max-width: 500px) {
                body { background-color: green; }
                h1 { color: red; }
            }
            @media screen and (min-width: 801px) {
                body { background-color: blue; }
                h1 { color: yellow; }
            }
        </style>
</head>

<body>
    <h1>@media query test</h1>
</body>
</html>
```

브라우저 크기를 변경하면 @media 쿼리에서 지정한 크기에 정의한 CSS가 적용되는 것을 확인할 수 있다.

![](http://blog.hibrainapps.net/saltfactory/images/102c15d7-b297-4810-84c3-0863d8561efc)

![](http://blog.hibrainapps.net/saltfactory/images/b9384e59-92b0-4085-9f21-bea84ae4ad59)

![](http://blog.hibrainapps.net/saltfactory/images/809744df-103d-484f-a6b4-3aa66639676a)

위 코드는 PC 용 브라우저를 테스트하기 위해서 임의로 사이즈를 정의해서 테스트하였다. PC용 브라우저는 최소 크기가  모바일 320px 보다 크기고 테스트를 스크린 캡쳐하기 위해서 500px 이상을 테스트하기 위해서 임의로 정의한 것이다. 모바일, 테블릿, PC에 따라서 다르게 하고 싶은 경우는 다음과 같이 수정한다.

```html
<!DOCTYPE HTML>
<html>
<head>
<style type="text/css">
            /* Smartphones (portrait and landscape) */
            @media only screen
            and (min-device-width : 320px)
            /* Styles */
            }

            /* Smartphones (landscape) */
            @media only screen
            and (min-width : 321px) {
                /* Styles */
            }

            /* Smartphones (portrait) */
            @media only screen
            and (max-width : 320px) {
                /* Styles */
            }

            /* iPads (portrait and landscape) */
            @media only screen
            and (min-device-width : 768px)
            and (max-device-width : 1024px) {
                /* Styles */
            }

            /* iPads (landscape) */
            @media only screen
            and (min-device-width : 768px)
            and (max-device-width : 1024px)
            and (orientation : landscape) {
                /* Styles */
            }

            /* iPads (portrait) */
            @media only screen
            and (min-device-width : 768px)
            and (max-device-width : 1024px)
            and (orientation : portrait) {
                /* Styles */
            }

            /* Desktops and laptops */
            @media only screen
            and (min-width : 1224px) {
                /* Styles */
            }

            /* Large screens  */
            @media only screen
            and (min-width : 1824px) {
                /* Styles */
            }

            /* iPhone 4 */
            @media
            only screen and (-webkit-min-device-pixel-ratio : 1.5),
            only screen and (min-device-pixel-ratio : 1.5) {
                /* Styles */
            }
        </style>
</head>

<body>
    <h1>@media query test</h1>
</body>
</html>
```

하지만 CSS3 @media 쿼리는 IE6~8 브라우저에서는 지원되지 않는다. 그래서 Javascript로 구현된 respond.js를 이용해서 이 문제를 해결해야한다.
https://github.com/scottjehl/Respond 에서 git로 받거나 zipbal이나 tarbal을 받아서 respond.min.js를 코드에 추가한다. respond.js를 추가한 코드를 IE8에서 적용을 해보자. (respond.js는 IE6까지 지원한다.)


```html
<!DOCTYPE HTML>
<html>
    <head>
        <link href="css/master.css" rel="stylesheet"/>
        <!--[if lt IE 9]>
         <script type="text/javascript" src="js/respond.min.js"></script>
         <![endif]-->
    </head>

    <body>
        <h1>@media query test</h1>
    </body>
</html>
```

![](http://blog.hibrainapps.net/saltfactory/images/aea7ad1b-1e40-4c35-bcf1-b436e329ce25)

![](http://blog.hibrainapps.net/saltfactory/images/3f9ae0b4-9c85-413b-8dfa-ef1785e8b520)

![](http://blog.hibrainapps.net/saltfactory/images/d1c4fb39-7569-4b19-8879-9a2f03c6a0aa)

이제 모바일, 태블릿에서 적용이 바로되는지 확인해보자. iOS Simulator를 이용하여 테스트를 해보았다. 모바일과 태블릿의 화면 크기를 적용하기 위해서 다음과 같이 코드를 변경하였다.

```html
<!DOCTYPE HTML>
<html>
<head>
<meta name="viewport" content="width=device-width; initial-scale=1.0">
<style type="text/css">
@media all and (max-width: 320px) {
        body { background-color: red; }
        h1 { color: white; }
}
@media all and (min-width: 321px) and (max-width: 768px) {
        body { background-color: green; }
        h1 { color: red; }
}
@media all and (min-width: 769px) {
        body { background-color: blue; }
        h1 { color: yellow; }
}
</style>
<!--[if lt IE 9]>
<script type="text/javascript" src="js/respond.min.js"></script>
<![endif]-->
</head>

<body>
    <h1>@media query test</h1>
</body>
</html>
```

![](http://blog.hibrainapps.net/saltfactory/images/d67f84ba-61ea-4eff-abb0-99154e330126)

![](http://blog.hibrainapps.net/saltfactory/images/9628879a-de14-4cbf-8750-bebc73de99e7)

![](http://blog.hibrainapps.net/saltfactory/images/2ada8182-037b-4b07-a893-7b473a5093ca)

![](http://blog.hibrainapps.net/saltfactory/images/ad90d34f-99b0-4bd6-892f-8f05e152fe72)

## 결론

이 포스팅에서는 반응형 웹을 구현하는데 여러가지 기법 중에 @media 쿼리를 이용해서 웹이 표현되는 스크린(screen)의 크기에 따라 각각 다른 스타일을 적용하는 스크린 크기 대응에 관한 이야기를 소개했다. 하지만 @medai 쿼리는 CSS3를 이해할 수 있는 브라우저에서만 동작을 한다. 따라서 기본적으로 @media 쿼리를 이용하여 스크린 크기를 대응하게 되면 IE9 미만 버전 (IE8, IE7, IE6 등)은 반응형 웹을 구현하고자하는 @media 쿼리를 사용할 수 없다. 이 문제를 해결하기 위해서 respond.js라는 Javascript로 @media 쿼리를 이해할 수 있도록 라이브러리를 사용하면 구형 IE에도 적용 가능하다는 것을 실험으로 알 수 있었다. 이제 스크린의 크기에 대응해서 그에 관련된 스타일을 분리하는 것을 가능할 수 있게 되었으니 다음 포스팅에서는 @media 쿼리를 이용해서 실제 레이아웃 구성을 변경할 수 있는 예제를 포스팅 할 예정이다.

## 참고

1. http://hyeonseok.com/soojung/contents/upload/h3-responsive-web-design.pdf
2. http://css-tricks.com/snippets/css/media-queries-for-standard-devices/
3. https://github.com/scottjehl/Respond


