---
layout: post
title: GitHub Pages 도메인 네임 설정 하기
category: github
tags:
  - github
  - jekyll
  - pages
  - domain
  - dns
comments: true
images:
  title: 'https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/a3b92191-fdd4-442f-9529-ff425bdcd419'
---


## 서론

GitHub Pages를 사용하여 사이트를 운영하게되면 기본적으로 **.github.io** 도메인 네임을 받게된다. 예를들어 GitHub의 아이디가 saltfactory라면 http://saltfactory.github.io 로 만들어지게된다. 이 도메인네임도 꽤 쓸만하지만 대부분 특별한 도메인네임을 사용하고 싶어한다. 예를들어 현재 이 블로그가 GitHub Pages로 만들어졌고 도메인네임을 http://blog.saltfactory.net 로 만들어진것 처럼 말이다. 이번 포스팅에서는 GitHub Pages에서 사이트를 운영할때 도메인네임을 연결하는 방법을 설명한다.

<!--more-->

## GitHub Pages의 종류

GitHub Pages는 GitHub의 저장소를 웹 사이트를 운영할 수 있는 웹 디렉토리로 만들어주는 서비스인데  GitHub Pages의 종류는 크게 두가지이다.

* 개인 사이트 GitHub Pages
* 프로젝트 사이트 GitHub Pages

**개인 사이트**는 GitHub에 가입한 계정의 이름에 **.github.io**라는 저장소를 만들게되면 자동으로 개인 사이트를 위한 GitHub Pages를 만들 수 있는 서비스이다. 다시 말해 **saltfactory**라는 GitHub Pages 계정이 있으면 저장소에 **saltfactory.github.io**라고 만들면 http://saltfactory.github.io 라는 개인 사이트 GitHub Pages 를 위한 만들 수 있다. 이 때 주의 해야할 점은 이 사이트의 저장소를 브랜치는 **master**에서 만들어져야 한다는 것이다.

**프로젝트 사이트**는 GitHub에 등록한 프로젝트별 사이트를 자동으로 만들 수 있도록 제공되는 서비스이다. 한가지 주의해야할 점은 이 사이트의 저장소를 위한 브랜치가 **gh-pages**라는 브랜치이다. 이렇게 만들어진 프로젝트 사이트는 **{github계정}.github.io/{프로젝트 저장소 이름}**으로 만들어진다. 예를들어 **saltfactory** 계정으로 [mark2html](https://github.com/saltfactory/mark2html) 저장소에 프로젝트를 만들었다면 이 프로젝트 사이트는 http://saltfactory.github.io/mark2html 으로 만들 수 있다.

## 도메인네임 등록

GitHub에서 제공하는 **{계정}.github.io**라는 도메인네임이 아닌 자신의 도메인네임을 사용하여 GitHub Pages를 접근하기 위해서,  가장 먼저 해야할 일은 도메인 서비스에 도메인네임을 등록하는 것이다. 국내 대표적인 도메인 등록 서비스는 다음과 같다. 개인적으로 사용하기 편한것을 사용하면 된다.

* [후이즈](http://www.whois.co.kr)
* [가비아](http://gabia.com)

이 블로그는 가비아를 사용하여 도메인네임을 등록하여 GitHub Pages와 연결되어 있고 이 글에서 설명하는 방법은 가비아에서 설정하는 방법을 예로 보여줄 것이다. 하지만 꼭 가비아 서비스가 아니더라도 이 글에서 설명하는 개념은 어느 도메인 등록 서비스에도 적용할 수 있을 것이다.

GitHub의 **DNS Provider**  IP 주소는 다음과 같다.

* **192.30.252.153**
* **192.30.252.154**

자신의 도메인네임의 **호스트 설정**에서 자신의 **호스트 이름**에 **IP 주소**를 위의 것 중에 하나로 입력한다.

![gabia ](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/2473d210-b885-4f38-8f1d-849930062a1c)

## CNAME 파일

GitHub Pages에서 도에인네임 설정은 GitHub Pages의 **DSN Provider** 의 IP 주소로 설정한 호스트이름의 **별칭(alias)**을 이용하여 설정하는 것이다.

GitHub Pages의 두가지 종류 중에 **개인 사이트**를 위한 도메인네임을 설정하자. 우리는 위에서 도메인네임 등록 서비스에서 **GitHub Provider**의 IP주소로 **호스트 이름**과 **IP 주소**를 등록하였다. 이렇게 설정이 되면 브라우저에서 http://saltfactory.net을 입력하면 GitHub Provider에 접근하게 된다. 우리의 목표는 GitHub Provider에 접근하는 것이 아니라 나의 개인 사이트를 위한 저장소에 접근하도록하는 것이다. GitHub는 GitHub Provider가 나의 저장소에 접근하기 위한 방법으로 저장소 안에 [CNAME](https://en.wikipedia.org/wiki/CNAME_record)파일을 사용한다.

이제 개인사이트를 위한 저장소의 **master** 브랜치의 디렉토리 안에 `CNAME `파일을 만들어서 **호스트 이름**을 저장한다. https://github.com/saltfactory/saltfactory.github.io 저장소에 살펴보면 저장소 **master** 브랜치의 디렉토리 안에 **CNAME** 파일이 존재하는 것을 볼 수 있다. 이 파일은 도메인넴임 서비스에 등록할 때 사용한 **호스트 이름**을 저장하였다.

```
saltfactory.net
```
이제 브라우저 주소창에 http://saltfactory.net 을 입력하면 GitHub Provider에 접근하여 끝나는 것이 아니라 GitHub Provider가 나의 개인 저장소인 https://github.com/saltfactory/saltfactory.github.io 까지 접근하여 **개인 사이트**의 웹 페이지를 볼 수 있다.

## 서브도메인 설정

만약 서브 도메인을 사용할 때는 **저장소의 CNAME 파일**과 도메인네임 서비스의 **CNAME 레코드**를 함께 설정해야한다.

예를 들어 http://saltfactory.net의 서브도메인으로 http://blog.saltfactory.net 을 만들고 싶다면 **blog.saltfactory.net**은 **프로젝트 사이트**를 위한 방법으로 만들어서 **gh-pages** 브랜치에 **CNAME**을 서브도메인으로 저장하여 추가한다. https://github.com/saltfactory/blog 저장소에 접근해보자.

블로그 운영을 위해 **blog**라는 프로젝트를 위한 저장소를 만들어서 **gh-pages**라는 브랜치를 만들었다. 그리고 **CNAME** 파일에 다음 내용을 저장하여 파일을 생성하였다.

```
blog.saltfactory.net
```

다음은 도메인서비스에 **CNAME record**에 **별칭**을 추가하는 것이다. 가비아에서는 다음과 같이 **별칭**과 **값/위치**로 설정할 수 있다.

* **별칭(alias)** : blog
* **값/위치** : saltfactory.github.io.

![cname record](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/cafa973b-e352-4669-a19d-af2f9e079f41)

이 때 주의해야할 점은 **값/위치**에 **saltfactory.github.io.** 마지막에 `.`이 추가 되어야한다는 것이다.

## 결론

GitHub Pages로 사이트를 구축할 때 필요한 도메인네임 설정을 **CNAME**으로 처리할 수 있다는 것을 확인했다. GitHub Pages는 **개인 사이트**와 **프로젝트 사이트**를 만들 수 있는데 개인 사이트는 **master** 브랜치에서, 프로젝트 사이트는 **gh-pages** 사이트에서 **CNAME** 파일을 만들어야 된다는 것을 살펴보았다. 그리고 서브도메인을 사용하기 위해서는 **별칭**을 사용해야하는 것을 살펴보았다. 도메인 등록 서비스를 사용하지 않고 직접 DNS를 구축하여 사용한다면 원리는 동일한다 CNAME을 설정해주는 곳에서 별칭을 추가하면 서브도메인을 사용할 수 있게된다.

## 참고

1. https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/

