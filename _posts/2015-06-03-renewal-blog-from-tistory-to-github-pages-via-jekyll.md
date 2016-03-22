---
layout: post
title: Tistory에서 Jekyll을 이용하여 GitHub Pages로 블로그 이전
category: note
tags: [note, freeboard, markdown, blog]
comments: true
---


> 생일을 맞이하여 블로그를 새롭게 개편했다.

2012년 이전 글을 제외한 나머지 글들을 모두 **Markdown** 으로 포팅했다.

왜?

이번 포스팅에서는 기존의 블로그에서 Github Pages로 블로그를 이전한 이유에 대해서 이야기를 나눈다.

<!--more-->

## 블로그 이전 준비


### Tistory 블로그

2년동안 Tistory 블로그를 사용했다. 공해하고 발행한 포스트만 200건이 넘는다. 처음 Tistory를 선택한 이유는 다음과 같다.

* 직접 HTML, CSS, JavaScript를 적용할 수 있는 서비스
* 광고 없는 서비스
* 컨텐츠 import와 export를 지원하는 서비스

2년동안 꽤 만족하면서 사용했다. 애국심 때문에 Wordpress와 Tumblr를 사용하고 싶은 마음을 참아가면서 말이다.. Tistory는 국내 대형 포털 블로그보다 자유도가 높아서 개발자와 연구하는 사람들에게 인기 있는 블로그 서비스이다. 이런 사람들은 대부분 자기가 원하는대로 컨텐츠를 만들어내고 싶어하기 때문이다. 정해진 레이아웃, 광고를 무조건 삽입하고 나오는 블로그... 그런건 정말 사용하기 싫은 블로그이다.

### 블로그 이전 이유

이렇게 잘 사용하던 블로그에서 블로그를 이전하게된 이유는 다음과 같다.

* **Markdown 지원을 하지 않는다.**
* 내가 원하지 않는 JavaScript가 너무 많이 요청된다.
* 서비스 자체의 강제 스타일링(`!important`) 때문에 CSS 충돌이 발생한다.

블로그 이전을 마음먹게된 이유는 사소한 이유지만 [Markdown](http://daringfireball.net/projects/markdown/)을 지원하지 않는 이유가 크다. 개발하거나 연구하면서 문서를 만들 때 Markdown을 사용하는데 이 내용을 다시 블로그로 포스팅하려고 하는데 [WYSIWYG](http://en.wikipedia.org/wiki/WYSIWYG)을 사용해서 글을 작성해야 했기 때문이다. 그래서 이중으로 글을 작성하는 것이 싫어서 Tistory를 Theme를 Markdown을 위한 스타일이 적용되게 변경하고, Markdown 문서를 HTML으로 변환하는 [mark2html](https://github.com/saltfactory/mark2html) Node.js 모듈을 직접 만들어 Markdown을 HTML 포멧으로 변환해서 Tistory 블로그에 글을 올렸다.... 아... 설명을 해도 복잡하다. 나름 익숙해졌지만 글을 작성할 때마다 복잡한 프로세스를 거쳐야해서 Markdown을 작성하면 바로 웹 서비스를 할 수 있는 [Jekyll](http://jekyllrb.com/) 기반으로 [Github Pages](https://pages.github.com/)로 블로그를 운영하기로 마음먹었다.

Tistory는 초기보다 더 많은 JavaScript를 로드하고 있었다. 사용자에게 자유를 보장하면서도 서비스를 운영하기 위해서 사용자가 만들지 않은 서비스에서 사용하기 위한 JavaScript 파일들이 로드되는 것인데 이런 요청이 점점 더 많아지게 되는 모습을 보면서 앞으로도 지속적으로 증가할 것으로 예상이 되었다. 서비스 입장에서 이해하지만 사용자에게는 불필요한 코드들이다.

Markdown을 렌더링 하기 위해서 열심히 CSS을 만들었는데, 동적으로 로드된 서비스용 CSS가 내가 만든 스타일을 무시해 버리는 경험을 겪으면서 블로그 이전을 마음먹게 되었다. 내가 원하지 않는 `!important` 을 더이상 강요받고 싶지 않았던것 같다.

이러한 이유로 Tistory에서 다른 블로그로 이전하려고 마음을 먹게 되었다.

### 블로그 이전시 고려사항

블로그 이전을 하면서 고려한 사항은 다음과 같다.

* **Markdown** 지원
* 기존 블로그의 **URL링크 유지**
* HTML, CSS, JavaScript를 자유롭게 사용할 수 있는 환경
* 컨텐츠 관리(import, export) 지원

처음으로 고민한 서비스는 [Tumblr](https://www.tumblr.com/)이다. tumblr는 아주 훌륭한 소셜 블로그 서비스 플랫폼이다. 개인적으로 지금 존재하는 SNS 서비스중에 가장 좋다고 생각하고 있다. 이 서비스는 Markdown 입력을 지원한다. 그리고 데이터 import/export를 지원한다. theme를 직접 만들어서 사용할 수 있다. 하지만 기존의 링크를 유지하기엔 어려움이 있었다.

#### 기존 블로그의 URL 링크 유지

블로그를 이전할 때 가장 고민했던 부분이 이부분이다. 쉽게 예를 들어 설명하면 누군가 다른 블로그나 사이트에 기존 블로그 링크를 상용했다고 가정하자. 그러면 본문에 http://blog.saltfactory.net/270 이런 링크가 다른 웹 사이트 본문에 남게 된다. 그러면 다른 사용자들이 그 사이트에 방문해서 **링크**를 통해 내 블로그로 진입하게 될때 블로그 주소가 http://blog.saltfactory.net/2015-05-06-redirect-using-with-parameter-on-nginx.html 이런 식으로 변경되어 버리면 찾을 수 없는 페이지로 표시가 되면서 **링크**가 더이상 연결되지 않는 자원이 된다. 뿐만 아니라 블로그를 통해 자료를 공유하고 다시 보고 싶어하는 사용자들은 다시 내 블로그를 찾아 올 수 없는 문제가 발생한다.  

Markdown을 지원하는 블로그는 생각보다 많지 않았다. [Wordpress](https://wordpress.org/)에 플러그인을 이용하여 사용하면 되지만 Free Pricing Plan에는 광고가 포함되고 custom domain을 사용할 수 없기 때문에 제외했다. 연구용 서버에 소스를 설치해서 운영할 수 있지만 down time 없고 앞으로도 지속적으로 사용할 수 있는 안정적인 서비스를 위해서 설치형 블로그 방법은 선택하지 않았다.

### GitHub Pages

GitHub Pages는 고민하는 모든 사항을 만족시켜주었다. Jekyll을 사용하여 운영하게 되면 **Markdown 문서를 자동으로 웹 서비스**로 만들 수 있었다. 그리고 **광고도 없다.** [git](https://git-scm.com/)를 사용하니 자동으로 import/outport를 할 수 있다. 그리고 **컨텐츠의 버전을  관리를 할 수 있다.**라는 강점까지 가질 수 있었다. 그리고 이전 블로그에 대한 링크 문제에 대한 고민은 GitHub Pages에서 공식적으로 제공하는 Jekyll의 Plugins인 [redirect_from](https://github.com/jekyll/jekyll-redirect-from) 기능을 사용하여 해결 할 수 있었다. 그래서 이전 블로그를 GitHub Pages로 이전하기로 결정을 하게 되었다.

## 블로그 이전과 문제 해결방법

### WYSIWYG 에디터의 단점

[WYSIWYG](http://en.wikipedia.org/wiki/WYSIWYG) 은 웹 사이트에서 사용자가 글을 작성할 때,  편리한 UI를 제공하여 컨텐츠를 쉽게 제작할 수 있게 UI 인터페이스로 컨텐츠를 제작할 수 있게 도와주고 작성한 컨텐츠는 HTML 포멧으로 저장을 한다.  대형 포털부터 오픈소스 프레임워크에서도 단순기능부터 고급기능까지 WYSIWYG 에디터로 구현해서 서비스를 하고 있다.

문제는 바로 이 **HTML 포멧**이다. 특정 웹 서비스에서 WYSWYIG으로 제작한 HTML은 [inline styling(또는 inline css)](http://www.w3schools.com/html/html_css.asp)으로 만들어지게 되는데, 이 컨텐츠를 다른 서비스로 이전할때 새로운 웹 사이트의 레이아웃과 어울리지 않는 문제를 가진다. 이미 inline styling으로 처리된 컨텐츠를 다른 스타일로 적용할 수 없는 문제가 발생한다.

Tistory에 작성한 이전 포스트들도 모두 inline styling으로된 HTML 포멧으로 만들어져 있었다. 그럼 어떻게 HTML 양식을 Markdown으로 만들었을까? 정답은 바로 **손수 작업했음**이다...

WYSWYG에서 작성한 HTML 문서를 파싱해서 `<h>` 태그를 `###`로 하고, 어떤 태그를 Markdown으로 매핑하고.. 이런 작업은 이루어질 수 없었다. WYSWYG으로 만든 포스트들은 워낙 상황에 따라 다르게 만들어져 있었고, 케이스별로 패턴을 만들기에는 케이스가 너무 많았다. 결국 데이터를 긁어서 수동으로 Markdown 포멧에 맞게 문서를 다시 만들었다. **Markdown 에서 HTML 변환**은 너무나 유연하고 쉽다. Markdown의 장점 중에 하나이다. Markdown으로 문서를 만들어두면 어떠한 서비스로 이전이 가능하다. 실제 GitHub Pages에서 다른 블로그로 이전할 경우 고민하지 않고 Markdown을 HTML 문서로 변환해서 포스팅하면 끝난다. 이런 Markdown의 장점과 WYSIWYG의 단점은 더욱 Markdown을 글을 남겨야한다는 생각을 하게 만들어 주었다.

## 기존 블로그 링크 유지하기

기존 블로그 링크를 유지하기 위한 작업은 다음과 같이 진행하였다.

1. 기존 도메인을 그대로 사용하기 위해 도메인 서비스를  GitHub 으로 설정한다.
2. GitHub Pages에서 지원하는 CNAME 파일을 사용하여 CNAME alias를 적용한다.
3. 기존 링크를 유지하기 위해 `redirect_from`을 설정한다.

이 방법은 꽤 중요한 방법이기 이에 대한 설명은 단독으로 포스트를 만들어서 공유할 예정이다.

### 기존의 커멘트 서비스 유지하기

기존 블로그에서는 블로그 이전을 고려하여 Tistory에서 제공하는 댓글 서비스를 사용하지 않고  [Disqus](https://disqus.com/)와 [Facebook Comment]()를 사용하여 커멘트 서비스를 구현하였었다. 마찬가지로 방명록 역시 Tistory에서 제공하는 것을 사용하지 않고 Disqus comment를 이용하여 운영하였는데 이것은 모두 블로그를 이전할 경우 이전 댓글을 그대로 연장해서 사용하고 싶었기 때문이다. Jekyll에서 `_includes`에 `disqus.html`과 `facebook_comments.html` 파일을 만들어서 포스트에 기존 커멘트를 그대로 사용할 수있는 코드를 추가했다.

Disqus에서 기존 커멘트를 그대로 사용할 수 있는 방법은 다음과 같다. Disqus를 설정할 때 커스텀 변수가 있는데 커멘트의 **identifier**를 `disqus_identifier`로 지정하여 URL이 달라져도 disqus_identifier만 같으면 동일한 커멘트로 사용할 수 있는 것이다. 이전 블로그에서 사용하던 `disqus_identifier`를 새로운 블로그에서도 동일하게 사용하여 이 문제를 해결했다. Facebook comment 역시 동일한 방법으로 `data-href` 값을 동일한 URL로 지정하면 같은 커멘트로 사용할 수 있다. 이에 대한 방법도 단독으로 포스팅을 만들어서고 공유할 예정이다.

### 방문자 통계 서비스

Tistory에서는 방문자 통계 서비스가 있었다. 하지만 GitHub Pages 에서는 그런 서비스가 존재하지 않는다. 이 문제를 해결하기 위해서 [Google Analytics](http://www.google.com/analytics/ce/nrs/)를 사용했다. 이것은 단순히 Tistory의 방문자 통계 기능을 넘어서 **웹 사이트 분석 시스템**으로 사용할 수 있다. Google Analytics를 사용하여 블러그를 분석, 운영하기 위한 방법도 앞으로 공유할 예정이다.



