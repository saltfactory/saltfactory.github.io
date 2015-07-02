---
layout: post
title: CSS3 @media query를 이용하여 반응형 웹 스크린 크기 대응하기
category: css
tags: [css, css3, responsive web]
comments: true
redirect_from: /200/
disqus_identifier : http://blog.saltfactory.net/200
---

## 서론

[CSS3 @media query를 이용하여 반응형 웹 스크린 크기 대응하기](http://blog.saltfactory.net/199) 글을 포스팅하고 다음과 같은 트윗을 보았다.

> 요즘 유행(?)하는 반응형웹의 기반이 되는 미디어쿼리... 물리적인 화면 크기(인치)를 고려하지 않은 해상도(픽셀)만으로 뭘 구분하지? 1280x800의 해상도를 가진 스마트폰에 데스크탑웹 보여줘도 됨?

이전글 포스팅후 장동수([@iolothebard](https://twitter.com/iolothebard/)) 님(KTH의 앱스프레소 초기 개발자로 존경하는 개발자 중에 한분입니다.)께서 올리신 이 트윗을 보고 코드를 다시 확인해보니, 확실히 이 말을 이해할 수 있을것 같아서 다시 자료를 찾아보고 수정을 했습니다. 감사합니다~

언제나 포스팅에 관련된 조언(피드백)을 감사히 받고 제가 더 많이 공부하고 수정할 수 있게 되는 것 같다. 이 블로그는 개인 블로그이면서 제가 연구하고 있는 연구소의 자료 공유 목적으로 글을 작성하고 있습니다. 그래서 여러가지 자료를 참고하고 최대한 간단하고 이해하기 쉽게 만들려고 하다보니 이런저런 문제로 자료를 놓치는 일이 많다. 하지만 위키피디아처럼 진정한 지식 공유가 되는것 같아서 포스팅에 대한 여러가지 의견을 받아서 다시 좀더 보완된 글을 공유하게 되는 것 같다.

<!--more-->

## @media 쿼리 오류

코드의 문제는 바로 @media 쿼리의 `min-width`, `max-with` 에서 생기는 오류이다. 오류라고 말하는 이유는 태블릿과 PC 스크린 사이즈를 다음과 같이 정의했다고 가정하자.

```css
@media all and (max-width: 768px) {
        body { background-color: red; }
        h1 { color: green; }
}
@media all and (min-width: 768px) and (max-width: 1024px) {
        body { background-color: black; }
        h1 { color: yellow; }
}
@media all and (min-width: 1025px) {
        body { background-color: blue; }
        h1 { color: white; }
}
```

위의 코드는 오해의 소지가 있다. 스크린 사이즈만으로 태블릿과 PC를 구분할 수 없기 때문이다. 그래서 어느날 1280px 아니면 그 이상의 태블릿이 나온다면, 또는 스마트폰이 나온다면?? 위 CSS에 정의한 @media의 구분으로는 분명히 PC에 볼 수 있는 스타일을 스마트폰에 보여주게 되어 혼란을 발생할 수 있다. 그럼 이 문제를 어떻게 해결해야할지에 대해서는 다음과 같이 대안을 생각할 수 있다. [Using CSS Media Queries to Style Your iPhone and iPad HTML](http://broadcast.oreilly.com/2010/04/using-css-media-queries-ipad.html) 이 글을 살펴보면 @media 쿼리로 단순히 min-with와 max-with만 사용하는 것이 아니라 min-device-with와 max-device-with를 활용한다. 그리고 디바이스의 orientation을 이용해서 디바이스의 가로의 길이를 감지해서 적용할 수 있게 되어 있다.

## CSS3 @media query

이것을 CSS3 @media 퀴리를 이용해서 사용하면 다음과 같이 만들어 낼 수 있다.

```css
/* iPads (portrait and landscape)  */
@media only screen
and (min-width : 768px)
and (max-width : 1024px) {
  body { background-color: orange; }
	h1 { color: black; }
}

/* iPads (landscape)  */
@media only screen
and (min-device-width : 768px)
and (max-device-width : 1024px)
and (orientation : landscape) {
  body { background-color: black; }
	h1 { color: yellow; }
}

/* iPads (portrait)  */
@media only screen
and (min-device-width : 768px)
and (max-device-width : 1024px)
and (orientation : portrait) {
   	body { background-color: yellow; }
	h1 { color: black; }  
}


/* Desktops and laptops */
@media only screen
and (min-width : 1025px) {
   	body { background-color: blue; }
	h1 { color: yellow; }  
}
```

이제 다시 PC와 iOS에서 브라우저로 테스트를 해보면 데스크탑의 구현 범위가 iPad의 스크린의 width를 겹치더라도 iPad일 경우는 `min-device-with`, `max-device-with`, orientation 속성으로 태블릿과 PC 화면을 구분해서 적용할 수 있게 된다. 여기서 태블릿의 디바이스 크기와 스크린의 크기를 조합해서 해당하는 사이즈를 유동적으로 변경해주면 된다.

![](http://cfile28.uf.tistory.com/image/14637F3C5072692A0873B1)

![](http://cfile25.uf.tistory.com/image/190E9136507269471B19AD)

![](http://cfile23.uf.tistory.com/image/12728F3C507269511A3BA3)

## 결론

CSS의 @media의 screen을 이용해서 화면의 크기를 이용해서 그에 맞는 반응형 웹을 만들고자 할 때 단순하게 screen의 크기로만 비교하게 된다면 태블릿과 PC 스크린의 만으로 디바이스를 구분할 수 없게 된다. 힘들게 반응형 웹을 구현했는데, 태블릿의 screen 크기가 크다고 PC용 웹을 보여준다는 것은 반응형 웹이고 말하기엔 문제가 있다. 태블릿과 PC 환경은 사용자 경험 자체가 틀리고 각각 웹을 사용하는 방법이 다르기 때문이다. 그래서 어떠한 이유로 태블릿에서는 스크린이 커지기만 한다고 해서 PC용을 보여주는 것이 아니라 태블릿에 가장 적합한 스타일을 보여줘야한다. 예전에 태블릿이 최초에 나왔을 때, 대부분의 기업들은 스마트폰 웹 버전을 그대로 보여주었는데, 사막 같이 넓은 메뉴, 텅텅 비어있는 리스트들을 생각해보면 알 것이다. 반대로, 태블릿이 풀스크린을 지원한다고 PC용 웹을 일방적으로 태블릿에서 보도록 하는 서비스들도 있다. 엄청난 데이터를 가진 첫 페이지에 풀 스크린으로 맞게 비율로 줄어드니 사람들은 돋보기라도 써야할 심정일 것이다. 비록 핀치 줌을 지워하지만, 태블릿은 태블릿에 맞는 구성으로 사용자에게 편리를 제공하는 것이 맞다고 생한다. 이러한 기준으로 볼 때 단순히 @media 쿼리에서 screen의 크기로만 디바이스를 체크하지 말고 디바이스의 크기를 적용하는 것이 반드시 필요한것 같다.

## 첨언

장동수 ([@iolothebard](https://twitter.com/iolothebard/)) 님의 피드백으로 좀더 반응형 웹 구축에 대한 자료를 알게 되었고 적용하는 방법에 대해서 알게 되었습니다^^ 앞으로도 블로그 포스팅을 구독하시거나 참조하시는 분들께 조언 많이 부탁드립니다. 이 블로그에서 방문해서 참조하는 코드와 데이터들이 오류가 없이 공유되길 바라기 때문에 고수님들의 조언, 참고하시는 개발자, 연구원님들의 피드백 감사히 받겠습니다.

## 참고

1. http://broadcast.oreilly.com/2010/04/using-css-media-queries-ipad.html

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
