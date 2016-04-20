---
layout: post
title: GitHub의 Pages를 이용하여 개인 사이트 구축하기기
category: note
tags: [github, pages]
comments: true
redirect_from: /208/
disqus_identifier : http://blog.saltfactory.net/208
---

## 서론

github는 git hosting 서비스를 넘어서 개발자의 SNS, 소셜 코딩, 코드 소스팅 등 많은 기능이 제공되는 개발 플랫폼으로 대부분의 개발자들이 가입해서 활동하고 있는 서비스이다. 트위터나 페이스북 등 영향력 있는 회사들 뿐만 아니라 국내 기업들도 오픈소스 프로젝트를 진행할 때는 github를 이용해서 코드를 배포하거나 오픈소스를 관리하기도 한다. 이러한 github.com에는 소스관리 뿐만 아니라 page 라는 기능도 포함하고 있다. 다시말해서 개인 page를 만들어서 서비스할 수 있는데 재미난 것은 github 답게 git로 page를 생성하고 관리한다는 것이다. 어떤 기업은 git로 이력서를 받는다는 이야기를 들었는데 github에서는 아마 모든 것을 git 방법으로 처리하려는 재밌는 고집 같기도 하다.
기존에 프로필 page로 http://about.me 를 이용하고 있었는데, github의 활성화를 위해서 github의 page를 생성해보기로 했다.

<!--more-->

우선 github.com에 page를 git로 생성하고 관리한다고 했는데 이 말은 github.com에 page를 위한 repository를 등록해야한다는 것과 같은 말이다. 그래서 새로운 repository를 등록해보자. 이때 주의해야할 점은 {자신의계정}.github.com 으로 repository를 생성해야한다. 이후 github.com의 프로필 page는 http://{자신의계정}.github.com 으로 서비스 된다는 것을 생각하면 된다. github.com의 계정이 http://github.com/saltfactory 이기 때문에 http://saltfactory.githubm.com 으로 page 가 만들어지게 된다.


### Manual하게 개인 페이지 만드는 방법

**(1) Pages를 위한 Repository 추가**

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e00a8d25-dbf2-4f08-8c60-e9d3fa2589fd)

간단하게 저장소를 추가하면 다음과 같이 생성이 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0e673060-57bb-40ec-90a3-427e12b0b41c)

**(2) HTML, JavaScript, CSS 파일 추가**

이렇게 저장소가 생성되면 github에서 위 저장소를 작업하기 위해서 clone을 한다.

```
git clone https://github.com/saltfactory/saltfactory.github.com
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ab56a8af-a254-46f2-9ac2-60242f789231)

이렇게 로컬에 받은 saltfactory.github.com 저장소 안에 index.html 과 javascript, css 파일을 추가하면 된다. 만약 IntelliJ와 같은 IDE를 사용하고 싶은 경우는 이 저장소를 그대로 사용하면 된다. 어떠한 IDE에도 영향 없이 개발하기 위해서 로컬에서는 IntelliJ를 이용했지만 github 소스 저장소에는 IntelliJ의 메타 파일들이 관리되지 않기 위해서 .gitignore에 IDE에 관련된 파일들을 추가해서 버전관리 되지 않게 설정했다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d6c4b0fb-c05c-47c6-921e-20a76baca296)

테스트를 위해서 index.html에 다음과 같이 간단한 코드를 추가했다.

```html
<!DOCTYPE HTML>
<html>
<meta charset="utf-8">
<link href="style.css" rel="stylesheet"/>
<script src="app.js"></script>
<head>
    <title>saltfactory's page</title>
</head>
<body>
<h1>This page is saltfactory's github page</h1>
</body>
</html>
```

그리고 추가한 파일들을 staging 에 추가하고 commit 한 다음에 github.com으로 push 한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/57ddc0e9-69da-4c10-803d-fb85e709ef4d)

이렇게 하면 github.com에 http://saltfactory.github.com 이라는 개인 page가 생성이 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f8585b82-d96a-48c7-976a-3de0d375bb6f)

### Automatic Pages Generator 를 이용해서 page를 생성하는 방법

#### Page를 위한 Repository 추가

위에 설명한 Manual하게 Page를 생성하는 방법의 page를 위한 repository를 추가하는 방법과 동일하다.

#### Repository의 Admin 페이지로 이동

github.com에서 새로 추가한 repository로 이동을 한다. https://github.com/saltfactory/saltfactory.github.com 그러면 repository 페이지의 오른쪽 상단에 Admin 이라는 버튼이 보이는데 이것을 눌러서 repository 의 admin 페이지로 이동한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/cd80ace2-e65b-4fac-a5f9-b96a2d1f6105)

#### Automatic Page Generator 선택

Repository의 admin 페이지로 이동하면 Github page 라는 항목 아래 Automatic Page Generator 라는 버튼이 보인다. 이 버튼을 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/74f806a0-fb5a-4f09-ad07-f6e142ae05cf)

#### Markdown 작성
Automatic Page Generator 버튼을 누르면 Markdown 을 수정할 수 있는 페이지가 나타난다. github는 HTML 개발자 뿐만 아니라 다양한 개발자들이 사용하기 때문에 혹시 HTML 코드를 모르거나 (그럴일은 없겠지만), 보다 HTML을 간단하고 편리하게 작성하기 위해서 Markdown을 사용할 수 있게 지원해주는 것 같다. Markdown에 익숙해지면 HTML코드는 귀찮게 느껴지게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b55e9dd6-8654-4c21-ae96-db2857b82efe)

화면 캡쳐에는 제외되었지만 아래로 스크롤을 하면 google analytics id를 연결하는 것도 있다. page의 접근 통계를 google analytics 로 분석할 수 있는 기능도 지원된다. 그리도 Layout을 선택하는 버튼이 보이는데 이를 누르고 Layout을 선택할 수 있다.

#### Layout 선택

github는 미리 다양한 layout을 만들어 두었다. 역시 개발자의 귀차니즘을 잘 알고 미리 이쁜 theme들을 준비할 것을 보면 github가 얼마나 개발자들의 특징을 잘 알고 서비스를 만드는지를 알 수 있다. (다양한 layout이 보이는데 @susukang98 님의 page가 github의 default layout으로 만들어진 것을 확인할 수 있다. 역시 개발자세요~ default)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/680901cd-df42-4f61-8052-6d550adafb59)

마음에 드는 layout을 선택하고 publish 라고 체크표시가 된 버튼을 선택하면 약 10분 뒤에 적용이 된다는 메세지와 repository에 layout을 위한 파일들이 추가된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6a6e029a-bb59-4637-90c4-3781ae7f36ba)

얼마 지나고 나서 http://saltfactory.github.com 을 열어보자. 멋진 개인 page가 만들어진 것을 확인할 수 있다. 뿐만 아니라 github.com의 개인 저장소로 연결해주는 귀여운 버튼도 자동으로 만들어지는 것을 확인할 수 있다. 이제 Markdown을 수정해서 내용만 변경하면 될 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0d6b692b-85a7-43ba-bfbd-83a7c7323d7c)

## 결론

nodeconf 를 다녀와서 [@susukang98](http://twitter.com/susukang98) 의 트위터에 등록된 개인 사이트가 github.com으로 만들어진 것을 보고 방법을 찾다가 [@outsideris](http://twitter.com/outsideris) 의 블로그에 포스팅된 내용을 보면서 테스트 했는데 github.com에 개인 page가 git를 이용해서 생성하고 수정할 수 있으며 버전까지 관리해주는 것을 보면서 재밌는 기능을 github.com에서 제공하고 있다는 것을 소개하기 위해서 포스팅을 했다. 개인적으로 간단한 개인 page를 자신의 로컬 머신에 두고 서비스하기 보다는 github.com과 같은 안정화된 서비스에 page를 만들어서 서비스한다면 여러가지 이유로 page가 죽는 경우가 적을 것 같다고 생각이 든다. 또한 개인이 html, javascript, css 파일을 직접 핸들링할 수 있다는 것 자체가 여러가지 웹 앱을 생성할 수 있다는 메리트가 있다. 뿐만 아니라 환경이 git이니 당연히 코드의 버전관리가 된다는 것도 좋은것 같다. 만약 이도저도 귀찮고 오직 Markdown으로 관리하면서 기본적으로 아름다운 layout을 사용하고 싶다면 github에서 제공하는 Repository의 admin 페이지에서 Automatic Page Generator를 이용하면 된다. 훌륭한 디자인으로 만들어진 개인 Page를 갖게 될 것이다. github는 개발자의 특징을 너무 잘 파악하고 있는것 같다. 아마 이래서 github가 개발자들에 가장 인기를 얻는 code hosting 서비스가 아닌가 생각이 든다. 나도 틈틈히 개인 page를 업데이트하면서 개인 프로필 페이지를 http://saltfactory.giithub.com 으로 이전 해야겠다고 생각을 했다


## 참조

1. http://pages.github.com
2. http://blog.outsider.ne.kr/593


