---
layout: post
title: GitHub Pages 저장소 이전에 따른 도메인 문제 해결
category: github
tags:
  - github
comments: true
images:
  title: 'http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fd8a7fc0-a469-48b0-b752-85f9217dde1d'
---

# 서론

이 블로그는 **Jeklly**을 이용하여 **GitHub**에서 **GitHub Pages**로 운영되고 있다. GitHub Pages에서 공식적으로 Jekyll을 지원하고 있기 때문에 Markdown 파일만 만들면 자동으로 정적 HTML을 만들어줘서 HTML 파일은 저장속 관리에 포함하지 않아도 되는 장점이 있다. 뿐만아니라 개인이 가지고 있는 도메인을 **CNAME** 파일을 가지고 쉽게 등록할 수 있다. GitHub Pages는 기본적으로 GitHub에 계정이 있으면 {계정}.github.io 형태의 페이지 서비스를 제공받는다. 또한 각 프로젝트별 페이지를 만들 수 있는데 이 블로그는 프로젝트 페이지로 운영이 되고 있었다. 메인 페이지를 [tumblr](http://saltfactory.net)로 이전한 이후 프로젝트 저장소에서 관리하던 블로그를 메인 페이지로 이전을 했는데 이 때 기존의 자료를 그대로 남겨두어서 DNS 문제가 발생했었다. 이 블로그에서 이 문제에 대해서 소개하고 해결한 방법을 소개한다.

<!--more-->

## GitHub Pages

블로그에서도 몇번을 통해서 [GitHub Pages](https://pages.github.com/)에 대해서 언급을 했다. 그래서 GitHub에 대한 자세한 소개는 생략한다. 다만 반드시 기억하고 알아둬야할 것이 있는데 계정 메인 페이지에서는 반드시 **master** 브랜치를 사용해야하고, 프로젝트 페이지에서는 **gh-pages** 브랜치를 사용해야 한다는 것이다. 이 브랜치를 사용하지 않고 다른 브랜치에 정적 HTML이나 Jekyll 파일을 만들어도 GitHub Pages 서비스를 사용할 수 없게 된다.

## CNAME을 사용하여 GitHub 도메인 설정

GitHub Pages는 자시이 가지고 있는 **도메인**을 연결해주는 서비스를 제공한다. 이 블로그 사이트는 http://blog.saltfactory.net 이라는 도메인을 사용하여 GitHub Pages 서비스에 연결한 것이다.

방법은 정말 간단하다. 아래 두가지로 바로 나만의 도메인 주소를 가지고 GitHub Pagess를 연결할 수 있다.

1. GitHub Pages 저장소에 **도메인**을 **CNAME** 파일로 저장한다.
2. 도메인 서비스 사이트에서 **별칭(Alias)**를 지정한다.

자세한 방법은 [GitHub Pages 도메인 네임 설정하기](http://blog.saltfactory.net/github/setting-domain-name-in-github-pages-via-cname.html)에 소개했었다.

여기서 중요한 점은 GitHub는 GitHub Pages 서비스의 도메인 네임 서비스 연결을 위해 내가 가지고 있는 저장소 안에 **CNAME**이라는 파일이 존재하는지를 검색하고 모든 **CNAME** 파일의 정보를 읽어서 호스트와 별칭 관리를 하게 된다. 만약 내가 가지고 있는 저장소 중에 동일한 도메인네임 설정을 한 **CNAME** 파일이 존재한다면 GitHub Pages 서비스에서 분석해서 다음과 같이 같은 도메인을 가지고 있는 **CNAME** 파일 있다는 것을 메일로 알려준다.

![CNAME already exists](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/1b89456d-84e5-47c3-926f-e494c1f92420)


## GitHub Pages 저장소 이전

이 시나리오를 소개하기 전에 GitHub에 등록된 저장소 두가지를 소개한다.

* 개인 계정 페이지 프로젝트 저장소: https://github.com/saltfactory/saltfactory.github.io
* 블로그 페이지 프로젝트 저장소: https://github.com/saltfactory/blog

위 두가지 저장소에 개인 계정 페이지 저장소는 **master** 브랜치를 사용하고 있고, blog 페이지 프로젝트 저장소는 **gh-pages** 브랜치를 사용하고 있었다. 그래서 개인 계정 페이지 저장소의 **CNAME** 파일에는 다음과 같은 도메인이 저장되어 있었다.

```text
saltfactory.net
```

그리고 블로그 페이지 저장소의 **CNAME** 파일에는 다음 도메인이 저장되어 있었다.

```text
blog.saltfactory.net
```

처음 메인 사이트를 http://saltfactory.net 라는 이름으로 GitHub 개인 계정 **master** 브랜치에서 연결하여 사용하다 [tumblr](https://www.tumblr.com)로 이전을 했다. 이 작업을 위해서 단순하게 도메인 서비스를 담당하고 있는 웹 사이트에서 saltfactory.net 도메인 정보를 tumblr의 정보로 업데이트를 했다. 이때 까지만 해도 GitHub 페이지에는 아무런 수정을 하지 않고 모든 것이 쉽게 끝났다고 생각했다.

> 이렇게 바보처럼 작업해두고 며칠이 지났다.

한 사용자가 나의 글에 **Disqus**를 사용하여 댓글을 달았다. Disqus는 소셜 댓글 플러그인으로 웹 사이트에 특별한 데이터베이스 필요없이 바로 댓글 서비스를 구축할 수 있도록 도와준다. 댓글이 달리면 자동으로 메일로 노티피케이션 메일이 오는데 메일에는 원글의 링크가 있다. 이 링크를 클릭하고 문제를 알게된 것이다. 링크를 클릭하는 순간 GitHub Pages로 가야할 링크가 tumblr로 이동해 버리는 것이다.

> 문제는 **CNAME**의 중요성을 잠시 잊어버리고 단순하게 도메인 서비스를 하는 곳의 설정만 변경한 것이다.

## GitHub Pages의 URL 규칙과 CNAME 과의 관계

**CNAME** 파일의 동작 원리는 다음과 같다.

만약 인터넷 브라우저에서 http://blog.saltfactory.net 으로 요청을 한다면 도메인 서비스 사이트에서 지정한 **별칭**을 찾기 위해서 웹은 **saltfactory.net** 주소를 가지고 **DNS 서버**를 먼저 찾게 되고 만약 DNS 서버에 **CNAME** 설정이 되어 있으면 별칭을 찾아서 이동한다. 우리는 가비아 DNS 서비스에 별칭으로 **saltfactory.github.io.**를 등록했었다.

![DNS 서버 CNAME](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/62f656a2-b756-4f18-bdee-55dc7bdd83ff)

그럼 **blog.saltfactory.net** 도메인을 찾기위해서 DNS서버는 별칭으로 지정한 **saltfactory.github.io**로 넘어오게 된다. 그리고 **saltfactory.github.io**에 등록한 **CNAME**을 확인해서 다시 **blog.saltfactory.net** 페이지를 찾아갈 수 있도록 하는 것이다.

문제는 바로 **saltfactory.github.io** 로 찾아왔을 때 문제이다. GitHub Pages에서 **CNAME**을 그래도 두어서 GitHub에서 다시 tumblr로 이동해버리는 것이였다. 이 **CNAME** 파일에는 기존의 **saltfactory.net** 도메인 정보가 그대로 저장되어 있었기 때문이다. 즉, 다시 말해서 가비아에서 DNS 서버의 CNAME을 확인해서 GitHub Pages까지 왔다가 GitHUB Pages에서 가지고 있는 **CNAME**을 보니 다시 가비아의 DNS 서버로 보내버리는 것이다. 그래서 http://blog.saltfactory.net 으로 요청한 링크가 계속 tumblr의 http://saltfactory.net 가버리게 되는 것이다.

## GitHub Pages 이전에 따른 도메인 문제 해결

이 문제는 다음과 같은 순서로 해결했다.

1. saltfactory.github.io의 **master** 저장소의 모든 파일을 백업하고 지웠다.(**CNAME** 파일 포함하여 모두 삭제)
2. blog 프로젝트 저장소의 **gh-pages**에 있는 jekyll 파일들을 모두 saltfactory.github.io의 **master** 저장소로 복사했다.
3. blog 프로젝트 저장소의 **gh-pages**의 **CNAME** 파일을 삭제했다.
4. 마지막으로 blog 프로젝트 저장소가 더이상 자동으로 jekyll 컴파일을 하지 않기 위해서 **.nojekyll** 빈 파일을 만들어서 넣어줬다.

이제 DNS 서버가 **CNAME** 파일을 분석하면서 도메인을 찾으러 다니는 것을 정확하게 처리할 수 있게 되었다.

## 결론

GitHub는 개인 개발자가 서버 없이 웹사이트 호스팅을 할 때 아주 유용하다. 설정 방법도 매우 간단하고 Jekyll을 사용하여 Markdown으로 쉽게 문서를 웹사이트로 만들 수 있다. 개인 도메인을 가지고 있으면 GitHub Pages 프로젝트 저장소 최고 상단에 **CNAME** 파일에 도메인 주소를 저장하고, DNS 서버 설정을 하는 곳에 **CNAME 별칭**에 **{github 계정}.github.io.**만 설정하면 쉽게 적용할 수 있다. 만약 GitHub Pages를 사용하다 다른 서비스로 이전한다면 반드시 기존의 설정을 참조해서 CNAME 설정을 모두 변경해줘야한다. GitHub Pages 내에서 이전하는 것도 동일하다. GitHub Pages의 모든 도메인 설정은 **CNAME** 파일를 분석해서 처리한다는 것을 기억할 필요가 있다. CAME 설정을 제대로 하지 못해서 며칠간 엉터리 링크를 사용하도록 방치한 점을 반성하고 도메인 동작을 다시한번 찾아보게 된 계기가 되었다.

## 참고

1. https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/


