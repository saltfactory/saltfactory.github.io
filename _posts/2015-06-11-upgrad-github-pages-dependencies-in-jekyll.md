---
layout: post
title: Jekyll 기반 GitHub Pages 라이브러리 업그레이드
category: jekyll
tags:
  - jekyll
  - ruby
  - github
  - github pages
comments: true
images:
  title: 'http://blog.hibrainapps.net/saltfactory/images/89577e27-9e4e-4c79-a36e-c547359237bf'
---

## 서론

GitHub Pages로 블로그를 운영하면 글을 작성하고 배포하는 것이 **programmatic**하다. 어떻게보면 재미있는 부분이지만 블로그 호스팅 서비스를 이용하여 사용할 때는 생각하지 않은 부분을 처리해야하는 경우가 발생한다.
[Jekyll](http://jekyllrb.com)과 [GitHub Pages](https://pages.github.com)로 블로그를 운영하고 있다면 [GitHub Pages Dependency versions](https://pages.github.com/versions/)을 지속적으로 살펴볼 필요가 있다. **GitHub**은 시스템 안정성을 높이기 위해 서비스를 지속적으로 개발하고 있고 라이브러리를 높이고 있기 때문에 programmic한 작업을 하기 위해서는 라이브러리를 함께 업데이트해주면 좋다. 이번 글에서 이 작업에 대해서 소개한다.

<!--more-->

## GitHub Pages Dependency versions

GitHub는 공식적으로 **Jekyll**을 사용하여 사이트를 구축할 수 있는 서비스를 제공하고 있고 의존성을 가지는 라이브러리를 공개하고 있다. https://pages.github.com/versions/

만약 Jekyll을 로컬시스템에 설치하여 내가 작성한 **Markdown**이 GitHub Pages에서 렌더링되는 것을 확인하거나 웹 사이트를 프로그래밍하려면 반드시 GitHub와 동일한 라이브러리를 설치해서 사용하는 것이 좋다. Jekyll에서 사용할 수 있는 수많은 플러그인들이 있다. 만약 개인서버나 호스팅업에체 Jekyll을 운영한다면 GitHub에서 사이트를 운영하는 것보다 플로그인을 이용하여 더 다양한 기능을 사용할 수 있다. 하지만 GitHub Pages로 Jekyll을 사용한다면 공식적으로 제공하는 플러그인 이외는 적용이 되지 않기 때문에 반드시 제공하는 라이브러리만 사용할 수 있다.

이 글을 작성할 때 GitHub Pages에 사용하고 있는 라이브러리와 버전은 다음과 같다.

* **jekyll**	: 2.4.0
* **jekyll-coffeescript** : 1.0.1
* **jekyll-sass-converter** :	1.2.0
* **kramdown** : 1.5.0
* **maruku** : 0.7.0
* **rdiscount** : 2.1.7
* **redcarpet** : 3.3.1
* **RedCloth** : 4.2.9
* **liquid**	: 2.6.2
* **pygments.rb** : 0.6.3
* **jemoji** : 0.4.0
* **jekyll-mentions** : 0.2.1
* **jekyll-redirect-from** : 0.8.0
* **jekyll-sitemap**	: 0.8.1
* **jekyll-feed** : 0.3.0
* **github-pages** : 38
* **ruby** :	2.1.1

## Gemfile

**Jekyll**은 **Ruby** 기반 서비스이다. 이러한 이유로 Jekyll을 사용할때 Ruby  프로젝트에서 라이브러리를 관리하는 [Gemfile](http://bundler.io/gemfile.html)을 사용할 수 있다. Jekyll 디렉토리에 `Gemfile`을 열어서 다음과 같이 현재 최신 라이브러리 버전을 저장한다.

```
source 'https://rubygems.org'

gem 'jekyll', '2.4.0'
gem 'jekyll-coffeescript', '1.0.1'
gem 'jekyll-sass-converter', '1.2.0'
gem 'kramdown', '1.5.0'
gem 'maruku', '0.7.0'
gem 'rdiscount', '2.1.7'
gem 'redcarpet', '3.3.1'
gem 'RedCloth', '4.2.9'
gem 'liquid', '2.6.2'
gem 'pygments.rb', '0.6.3'
gem 'jemoji', '0.4.0'
gem 'jekyll-mentions', '0.2.1'
gem 'jekyll-redirect-from', '0.8.0'
gem 'jekyll-sitemap', '0.8.1'
gem 'jekyll-feed', '0.3.0'
gem 'github-pages', '38'
```

## Bundler

이제 Jekyll에 설치해보자. `Gemfile`을 사용하여 라이브러리를 설치할 때, [bundler](http://bundler.io/)를 사용하여 쉽게 설치 할 수 있다. 만약 로컬시스템에 bundler가 설치되어 있지 않으면 [gem](https://rubygems.org/)을 이용하여 bundler를 먼저설치한다.

```
gem install bundler
```

**bundler**가 설치가 되면 `Gemfile` 이 있는 경로에서 다음 명령어로 라이브러리를 설치한다.

```
bundle install
```

만약 기존에 라이브러리를 설치가 되어 있을 경우 업데이트를 진행하면 된다.

```
bundle update
```

간단하게 **GitHub Pages**의 최신 라이브리를 설치하는 것을 완료했다. Jekyll 서버를 실행하여 이상없이 적용되는지 살펴보자

```
jekyll serve —wtach
```

## 에피소드

이 글을 작성하게된 이유가 있다. 최신 GitHub Pages 라이브러리를 업데이트하고 난 뒤 GitHub에 push를 하는데 다음과 같이 GitHub Pages 빌드에 실패를 했다는 메일이 왔다.

![GitHub build failed email](http://blog.hibrainapps.net/saltfactory/images/fe5c936f-9249-4663-abde-99913c48dc63)

내가 push한 Jekyll에 문제가 있다는 것을 확인하고 Jekyll 빌드를 실행하는데 다음과 같이 에러가 발생했다.

![jekyll error](http://blog.hibrainapps.net/saltfactory/images/234069e0-a05f-46fa-b648-66888a4337bb)

Jekyll과 GitHub Pages를 사용하여 블로그를 운영할 때 가장 불편한 것은 서버의 로그를 볼 수 없다는 것이다. 그래서 로컬의 Jekyll 환경으로 테스트를 해야한다. 서버의 문제를 파악하기 위해서 GitHub Pages에서 운영하고 있는 Ruby와 depenency versions에 꼭 맞는 라이브러리로 동일한 환경을 구축해야지만 정확하게 디버깅을 할 수 있다.

이 문제는 문제가 발생하는 곳을 찾는데 오래 걸렸다. Jekyll은 여러가지 라이브러리를 사용하고 있고 어떤 라이브러리는 C 레벨까지 내려가기 때문에 가끔 디버깅하기 어려운 부분이있다. 문제를 찾는지 오래 걸렸지만 해결방법은 아주 간단했다. 문제는 라이브러리를 업그레이드하고 난 뒤  `_config.xml`에 정의한 [redcarpet](https://github.com/vmg/redcarpet)의 `extenstions`의 표기 문제였다. 정상적인 설정은 아래와 같다.

```yaml
markdown: redcarpet
redcarpet:
  extensions: ["no_intra_emphasis", "tables", "autolink", "fenced_code_blocks", "strikethrough"]
```
GitHub의 이전 dependencies에서는 걸리지 앖았던 extensions 설정이 최신 버전으로 업데이트하고 나타나게 된 것이다. 하지만 문제점을 몰라서 오랜시간 로그를보면서 디버깅을 하다 **redcarpet**의 표기법이 맞지 않아서 에러가 생기것으로 판단되었다. 이렇게 최신 라이브러리로 업데이트를하게 되면 이전에는 발견되지 않은 에러가 발생되기도 한다.

## 결론

GitHub Pages은 Jeyll을 이용하여 개인 웹 사이트를 구축할 수 있다. Jekyll 많은 플러그를 이용하여 다양한 기능을 확장할 수 있다. 하지만 GitHub Pages에서는 공식적인 **dependency versions** 라이브러리를 공개하고 나머지 플러그인들을 사용할 수 없다. 만약 GitHub Pages에 포스트를 push 하고난 이후 GitHub로 부터 빌드 실패 메일이 온다면 GitHub Pages에서 사용하고 있는 현재 라이브러리와 동일한 라이브러리를 사용하여 로컬에서 Jekyll 서버로 디버깅을 해야한다. Jekyll은 Ruby 기반으로 **Gemfile**을 이용하여 간편하게 설치하거나 업데이트할 수 있다.

## 참고

1. https://pages.github.com/versions/


