---
layout: post
title : Mac OS X에서 Automator를 이용하여 온라인사전 검색 서비스 추가하기
category : hybridapp
tags : [phonegap, cordova, remote build, hybrid, hybridapp]
comments : true
redirect_from : /230/
disqus_identifier : http://blog.saltfactory.net/230
---

## 서론

Mac에는 유용한 기능이 기본적으로 많이 포함되어 있다. 특히 **서비스**라는 기능이 맥에서는 아주 유용하게 사용할 수 있다. **서비스**는 어플리케이션에 종속적이거나 또는 모든 어플리케이션에서 사용할 수 있는 서비스이다. 즉, 어플리케이션에서 특별한 기능을 바로 연결해서 사용할 수 있는 것이다. 이 서비스는 **Automator**라는 것으로 제작할 수 있는 이것은 Mac에서 특정 작업을 자동화할 수 있는 기능이다. 이것은 apple script로 제작된다. 이번 포스트에서는 웹 검색을 하거나 어플리케이션 안에 모르는 영어단어가 나오면 바로 단어를 사전에 찾을 수 있는 서비스를 Automator로 만들어서 추가하는 방법을 소개한다.

<!--more-->

## Automator

맥(Mac OS X)을 사용한지는 벌써 7년이 다되어 간다. 처음에는 불편한 윈도우즈가 싫었고 Linux를 사용할 일이 많아서 데스크탑에 Linux를 사용하다가 좀더 빠르고 아름다운 컴퓨팅을 하고 싶어서 맥이라는 것을 알게되었고 Intel 기반으로 맥이 발매되기 시작하면서 x86 컴퓨터에 Mac OS X를 설치해서 사용하다가 석사 입학 선물로 어머니께 MacBook Black을 받게 되면서 나의 Mac Life는 시작 되었다. 그때 이후로부터 지금까지 Active-X가 설치되지 않아서 결제시스템을 제외하고는 단 한번도 맥을 사용하면서 불편한적은 없었다. 컴퓨터공학을 전공하는 나로써 맥은 아직도 무한한 기능을 다 사용하지 못해서 늘 흥미로운 도전을 계속하게 만들고 있다. 뿐만 아니라 개발과 연구용으로 맥은 더할 나위없이 훌륭한 운영체제라는 것을 몸소 느끼고 있다. 개발자 컨퍼런스나 지금 만나는 대부분 사람들이 맥을 사용하고 있을 정도로 개발과 연구에 훌륭한 자원이 되고 있다는 것은 자명한 사실이다. 맥이 BSD Unix를 근간으로 한다는 것은 완벽하게 Windows의 사용보다 확장할 수 있다는 것을 말해준다. 더구나 맥은 미려한 인터페이스를 가지고 있기 때문에 사용하는데 시각의 즐거움도 더해준다. 맥에서 운영체제를 업데이트하면서 500가지 새로운 기능이 추가되었다라는 말들을 우스개 소리로 들었던 것을 난 아직도 그 사실을 인정하고 싶다. 아직도 편리한 기능의 대부분을 모르고 있는 것 같기 때문이다. 오늘은 Automator를 이용해서 custom service를 만드는 것을 살펴볼 것이다. 설명하기 이전에 우리는 공학인이라는 것을 먼저 말하고 싶다. 우리는 복잡하고 번거러운 일을 수동으로 하기 싫어한다. 웹에서 자료를 검색하고 찾으면서 자연스럽게 국내 자료보다 국외 전문자료나 커뮤니티를 많이 찾게 되는데 짧은 영어실력으로 원문을 이해하는데 어려움을 가진다. 그래서 우리는 온라인 사전 서비스를 하는 네이버나 다음의 사전을 열어서 탭을 눌러가면서 검색어를 던지고는 하는데 이 과정을 반복적으로 하니까 공대인으로 참 답답하기 짝이 없다. 그럼 이런 행동을 컴퓨터에서 자동화하면 얼마나 좋을까? 생각하게 된다. 이런 고민을 하면서 검색하던 중에  http://wankyuchoi.blogspot.kr/2012/03/blog-post_8598.html 의 글을 찾게 되었다. 이 블로그에서는 Naver 사전을 이용했는데 난 보통 다음사전을 이용하고 있다. 다음은 반응형 웹을 사용해서 사전서비스를 만들었기 때문에 작은화면 창을 이용하면 모바일 버전이 아니더라도 작은 화면에 최적화된 사전 서비스를 사용할 수 있고 생각을 했기 때문이다.그래서 Automator로 다음사전검색 서비스를 만들어서 등록했다. 아래 그림은 웹 브라우저에서 Automator라는 영어단어를 Automator로 만든 서비스로 다음사전을 열어서 검색어를 검색한 결과이다.


![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/fb7c3fb2-1965-463e-9a52-57f6fc508c3c)

Mac OS X에서는 이런 사용자의 행위를 자동화로 만들어주는 툴을 이미 만들어서 반복적이고 복잡한 일을 한번에 처리할 수 있는 방법을 지원해주고 있는데 이것이 바로 Automator로 가능하다. Apple 공식 사이트에 Automator를 다음과 같이 설명한다. 한마디로 Automator는 개인자동화비서이다.

> Automator is your personal automation assistant, making it easy for you to do more, and with less hassle. With Automator, you use a simple drag-and-drop process to create and run “automation recipes” that perform simple or complex tasks for you, when and where you need them.


### Automator 실행

Spotlight에서 Automator를 검색해서 실행한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/3a05dd97-a545-4e14-923d-4e69a0e952c5)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e785fba0-410e-438b-98aa-aa9f3164373a)

처음 실행하면 위의 하면과 같이 실행이 된다. 나중에 Automator로 만든 서비스들을 iCloud에 저장하여 다른 Mac에서도 동일한 서비스를 iCloud를 사용해서 가져와서 사용할 수 있다. 우리는 "다음사전"을 등록 할 것인데, 이후에 iCloud로 저장하면 다음과 같이 Automator를 실행하면 iCloud에 저장한 목록을 볼 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/be7f8c93-0293-4cf6-8db8-e732e1121d4c)

이제 Automator로 사용자가 여러번 반복하는 불편한 작업을 서비스로 만들어서 사용해 보자. 아마 처음 Automator를 열면 아무런 서비스가 등록되지 않았기 때문에 New Document를 선택하여 새로운 작업창을 연다. Automator는 자동화를 만드는 툴인데 자동화 타입을 설정한다. 여러가지 타입이 있는데 나중에 기회가 되면 다양한 자동화를 소개하겠다. 이번에는 현재 실행중인 어플리케이션에서 사용할 수 있는 새로운 서비스를 등록할 것이기 때문에 Service 타입을 선택한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/6c22d276-d4da-4ca8-b7ec-adf9973728bd)

Service를 선택하면 Automator의 화면에 Actions과 Variables 탭이 왼쪽에 보인다. 우리는 사전을 브라우저로 여는 행위를 자동화 할 것이기 때문에 Actions를 선택한 가운데 검색창에 "Run AppleScript"를 검색하여 오른쪽 작업창으로 드래그앤 드롭을 한다. AppleScript는 Apple에서 만든 스크립트 언어로 Mac OS X에서도 많은 부분이 AppleScript로 어플리케이션을 제어하고 있다. AppleScript는 스크립트 언어로 어플리케이션을 제어할 수 있는데 우리가 지금 하고 싶어하는 것은 새로운 브라우저를 열어서 검색을 하게끔하기 때문에 AppleScript를 사용해서 사람이 새로운 브라우저를 열어서 검색하는 행위를 만들 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9bb542a5-ed6d-4c33-944a-493bb83df601)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/f9abb7a0-a336-4588-bc51-26060c384d0a)

위의 그림처럼 Run AppleScript를 새로운 flow에 추가가 될 것이다. 이 곳은 우리가 검색어를 "다음사전"에 검색어를 만드는 작업을 넣을 것이다. 우리가 다음 사전을 열어서 Automator 단어를 검색한다고 생각해보자. 그러면 다음사전 웹 사이트를 열어서 검색어를 넣고 검색을 할 것이다. URL을 살펴보자.http://dic.daum.net/search.do?q=Automator 라고 만들어졌다. 사람이 직접 다음사전을 열어서 이렇게 검색어를 입력하면 이렇게 URL이 만들어진다. 우리는 AppleScript로 이 행위를 만들려고 한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5aa15371-08aa-48d1-931d-1ae2de249c68)


만약에 웹 검색을 하다가 검색을 하고 싶은 단어가 있으면 Automator에게 검색어를 넘겨주어서 AppleScript로 사람이 직접 검색어를 만들어서 던지듯 URL을 만들어라고 명령할 것이다. 그래서 위의 Automator의 flow에 추가된 AppleScript에서 on run과 end run 사이에 다음과 같이 AppleScript를 입력한다. URL을 검색어를 추가해서 만들어서 다음 행위로 전달하라고 명령한다. 여기서 input은 앞으로 우리가 검색어를 선택해서 Automator에 등록한 서비스로 입력하는 값이 될 것이다.

```
on run {input, parameters}
	return "http://dic.daum.net/search.do?q=" & (input as string)
end run

```

우리는 검색어를 검색할 수 있는 URL을 가지고 새로운 창에서 이 검색어를 던졌다. 이와 동일한 행위를 Automator에게 실행하게 한다. 즉, 새로운 브라우저를 열라고 명령할 것인데 현재 검색어를 검색한 창에서 이동하지 않고 팝업을 띄워서 확인하고 싶기 때문에 Actions의 검색 창에서 Website Popup을 검색한다. 그리고 선택하여 오른쪽 flow에 드래그 앤 드롭을 해서 새로운 행위를 추가한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/c06741db-fa59-49fb-8250-84c26223e1eb)

오른쪽 Automator의 flow를 살펴보면 URL을 만들어서 Website를 popup 시킬것이라는 말이다. Automator의 가장 오른쪽 상단에 play 버튼을 실행해본다. Play를 누르면 우리가 Automator에 명령한 행위를 flow 순서대로 실행을 하기 때문에 다음과 같이 URL을 새로운 팝업창에 열어서 보여줄 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9b101dbb-7e48-4c04-a3de-e22478f60ab8)

그런데 우리는 input을 새로운 서비스로 입력되는 값을 받기 때문에 현재는 사실 input 값이 하나도 없는 상태이다. AppleScript를 정의한 곳에 다음과 같이 input 대신에 하드코딩을 해보자. 그리고 다시 실행해보자.

```
on run {input, parameters}
	return "http://dic.daum.net/search.do?q=Automator"
end run
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/95759c70-0395-4da5-883f-e7843b635ddb)

실행 결과는 우리가 다음사전 웹 사이트를 열어서 검색어를 가지고 검색한 결과와 동일하게 나오는 것을 확인할 수 있다. 하지만 우리는 전체 화면을 차지하는 이 사이즈가 마음에 들지 않다. 좀더 사전 앱과 같이 가볍고 작은 창에 열려서 현재 문서를 보는데 불편함이 없기를 바란다. 그래서 다음과 같이 Website Pop으로 추가한 flow에 다음과 같이 설정 값을 변경한다.

```
Site Size: iPhone (팝업이 열릴때 아이폰 사이즈로 열도록 설정한다)
```

웹 사이트가 열릴때 User Agent로 열수도 있는데 Safari, iPhone, iPad로 열도록 할 수도 있다. 하지만 User Agent를 스마트폰 디바이스로 선택하면 요즘 대부분 사이트가 User Agent로 스마트폰을 판단해서 앱을 설치하라고 유도하고 있기 때문에 User Agent는 Safari로 그대로 두는것이 좋다. 만약에 User Agent를 iPhone을 한다면 다음과 같이 열리게 된다. 아래와 같이 모바일 앱을 설치하라고 안내할 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/cad6947b-7cb6-4676-ad34-518bf1fe84c7)

다음은 현재 다음사전 서비스를 반응형웹으로 만들었다. 이말은 다시 말하면 Agent를 모바일 디바이스로 만들지 않아도 브라우저 크기만 줄여주면 그 화면에 최적화된 화면으로 보여줄수 있도록 만들었다는 말이다. 그래서 우리는 스마트폰이 아닌 일반 브라우저로 스마트폰 크기와 같은 크기에 최적화된 웹 화면을 그대로 사용할 수 있다. 모든 설정은 다음과 같다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ccc2dd88-fd9e-4bf6-ba56-c7879b86b665)

이렇게 Automator로 명령을 작성한 다음 저장을 한다. 이름은 편한대로 저장하면 된다. 우리는 "다음사전"으로 만들었다. 이젠 브라우저에서 검색어를 드래그해서 오른쪽 마우스를 클릭해서 Services에 우리가 추가한 서비스가 있는지 확인하고 실행해보자.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5f44f78d-31db-4812-89ad-3f1c1adf3188)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/b2c7e2d5-7558-414a-a98f-fa5400c391a9)

어떠한가? 우리는 이제 더이상 복잡하고 번거롭게 모르는 영어단어를 찾기 위해서 새로운 브라우저창을 열어서 다음사전 검색서비스를 열고 검색어를 넣어서 검색하는 행위를 하지 않아도 된다. 단지 모르는 단어를 드래그해서 우리가 추가한 서비스를 실행하면 Automator가 우리의 복잡하고 번거로운 행위를 대신해 줄 것이다.

오른쪽 flow의 상단에 살펴보면 Service receives selected text 라는 항목이 있는데 이것은 이후에 우리가 Automator로 등록한 서비스를 호출할 때 드래그해서 선택한 내용이 text로 들어 올 것이라는 것을 지정하는 것이다. 그리고 in any application이라는 것은 특정 어플리케이션이 아니라 현재 사용하고 있는 모든 어플리케이션에서 우리가 만들 서비스를 사용할 수 있다는 것을 지정한다는 것이다. 특정 어플리케이션을 지정할 수도 있다. 하지만 우리는 꼭 사파리 뿐만 아니라 크롬브라우저에서도 또는 pdf에서도 다음사전 검색 서비스를 사용하고 싶기 때문에 in any application으로 지정한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/8d7b3b2e-d0d2-4711-89a3-c93ea2731882)

마지막으로 Automator로 저장하는 파일을 Services라는 디렉토리로 저장이 되는데 iCloud에 저장하기 위해서는 File > export를 선택해서 iCloud를 지정하면 된다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/b993a0d3-cbb2-4d41-add8-64f9aaa46dd8)

## 결론

검색을 하고 사전을 찾아보고 하는 반복작업은 아직도 계속되고 있다. 공대인으로 이와 같은 반복작업은 참으로 답답하기 이를때 없다. 그래서 이런 단순한 작업을 자동화할 수 있는 방법을 찾아보는 가운데 Mac OS X의 Automator가 사용자의 행위를 순서대로 실행시켜주거나 특정 일을 자동화 할 수 있게 도와준다는 것을 알게 되었다. 이젠 더이상 두가지 브라우저 창을 열어서 하나는 원문을 하나는 사전을 열어둘 필요가 없게 되었다. 우리는 단지 모르는 단어를 드래그해서 우리가 만든 서비스를 실행시키면 Automator가 대신 우리의 복잡하고 단순한 행위를 해줄 것이기 때문이다. Automator의 사용은 매우 유용하고 다양한 방법으로 사용할 수 있다. 이 포스팅은 단순히 모르는 단어를 사전에서 검색하는 행위를 저장해서 사용하는 방법을 설명했을 뿐 앞으로 다른 곳에서도 Autmator를 사용해서 자동화하는 방법을 소개할 것이다. 이런 능률과 재미로 개발자와 연구자들이 Mac을 사용하기에 충분히 매력적인 운영체제라고 생각이 든다.

이 글의 원문은 [<참고 3>](http://wankyuchoi.blogspot.kr/2012/03/blog-post_8598.html)의 글이 원글이다. 다른 사람의 수고한 내용을 그대로 복사하는 것을 우리는 원하지 않는다. 우리가 사용하는 블로그는 사내 블로그와 연결되어 있고 사내 연구원들과 학생들에게 좀더 유용하게 전달하기 위해서 수정하여 작성하였기 때문에 원글을 명시하는 바 이다. 지식은 공유할 수 있으면 좋고 복사되어서는 안된다고 생각하기 때문에 원글의 출처를 정확하게 밝힌다. 복잡하고 단순한 반복작업을 원글을 통해서 간소화 할 수 있었기 때문에 공대인으로 감명받아서 글을 작성해서 전달한다. 원글 저자에게 깊이 감사한다.

## 참고

1. http://support.apple.com/kb/ht2488
2. https://developer.apple.com/library/mac/documentation/AppleScript/Conceptual/AppleScriptX/AppleScriptX.html
3. http://wankyuchoi.blogspot.kr/2012/03/blog-post_8598.html

