---
layout: post
title: Jekyll을 사용하여 GitHub Pages 만들기
category: jekyll
tags:
  - jekyll
  - git
  - ruby
comments: true
redirect_from: /256/
disqus_identifier: 'http://blog.saltfactory.net/256'
images:
  title: 'http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/936a7798-d70b-4957-b291-5ed619cfb801'
---

## 서론

GitHub는 git 호스팅 서비스 외 다양한 개발 환경을 제공하고 있다. GitHub는 소셜 코딩 환경 뿐만아니라 프로젝트의 사이트를 만들 수 있는 기능을 제공하는데
**Github Pages**를 이용하여 Markdown 파일을 사용하여 개인 및 프로젝트 사이트를 운영할 수 있다. 이 포스트에서는 GitHub Pages를 이용하는 방법을 소개한다.

<!--more-->

## GitHub Pages

[Github Pages](https://pages.github.com/)는 github의 프로젝트를 만들 수 있게 github에서 제공하고 있는 서비스이다. 사이트를 만들기 위해서 서버를 설치하고 웹서버 환경을 구축하지 않고도 github에 웹 리소스를 리파지토리에 `git push` 하는 것 만으로 웹 사이트를 만들 수 있다. 이 것은 소스코드만 보이는 GitHub의 Reposity를 보여주는 대신 프로젝트 사이트를 만들기에 편리하다.    웹 개발자라면 한번쯤 방문한 [Bootstra](http://getbootstrap.com/) 사이트 역시 GitHub page로 만들어진 것이다. 프로젝트 리파지토리에 `gh-pages` 브렌치를 만들고 `index.html` 파일을 넣는 것 만으로도 프로젝트 사이트를 만들 수 있으니 정말 편리하다. GitHub Pages를 생성하는 방법은 [User, Organization, and Project Pages](https://help.github.com/articles/user-organization-and-project-pages)를 살펴보면 된다.

GitHub page를 생성하는 방법은 ***gh-pages*** branch에 `index.html` 파일을 `git push` 하는 것 만으로도 만들 수 있고, 다른 static website generator framework를 사용해도 된다. GitHub에서는 공식적인 Database를 지원하고 있지 않기 때문에 static website(HTML 파일)을 사용해야 한다.

## GitHub 계정 페이지

GitHub는 프로젝트 페이지 말고도 GitHub Account Page를 만들 수 있다. 다시 말해서 GitHub의 계정이 ***saltfactory*** 라고 한다면 http://saltfactory.github.io 라는 개인 페이지를 만들 수 있는 것이다. 프로젝트 페이지와 달리 계정 페이지는 ***gh-pages*** branch를 사용하는 것이 아니라 ***master*** branch를 사용한다. 우리는 이번 포스팅에서 개인 페이지를 만드는 방법을 살펴볼 것이다. 계정 페이지를 만들기 위해서는 GitHub에 새로운 리파지토리를 생성해야한다.

### Repository 생성

> 계정 페이지는 반드시 ***{GitHub의 계정}***.github.io 라는 이름으로 만들어야 한다.

다시 말해서 계정이 ***saltfactory***라면 리파지토리 이름을 ***saltfactory.github.io*** 라고 만든다. 그러면 https://github.com/saltfactory/saltfactory.github.io 과 같이 GitHub에 리파지토리가 생성이 된다.

현재는 리파지토리가 비어져 있을 것이다. 이것을 이젠 내 컴퓨터에 `clone`을 한다.

```
clone https://github.com/saltfactory/saltfactory.github.io.git
```

## Jekyll

![jekyll](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0d6a63c8-4deb-4dc9-928c-3e3d961ea281)

[Jekyll](http://jekyllrb.com/)은 static websites 생성 프레임워크이다. `Ruby`로 만들어진 이 것은 **Markdown** 파일을 `_posts` 디렉토리에 생성하는 것 만으로 멋진 static website를 만들어준다. Markdown을 사용하는 개발자에게 반가운 이야기일 것이다. 우리도 Markdown을 표준 document format으로 정하고 난 뒤에 Jekyll을 사용해서 Pages를 만들고 기존의 블로그를 이전하고 있다.

### Jekyll 설치

우선 [Ruby](https://www.ruby-lang.org/en/)가 설치되어 있어야 한다. Ruby는 다양한 버전이 존재하는데 의존성 문제를 해결하기 위해서 [RVM(Ruby Version Manager)](https://rvm.io/)을 함께 설치한다. 이 블로그에서도 RVM에 대한 포스팅이 있는데 설치하는데 문제가 발생하면  http://blog.saltfactory.net/search/rvm 의 글 들을 살펴보면 도움이 될 것이다.

### RVM 설치

RVM 설치는 아래와 간단히 설치할 수 있다.

```
curl -sSL https://get.rvm.io | bash -s stable --ruby
```

### Ruby 2.1.1 설치

Mac OS X에는 ***ruby 1.9.3*** 버전이 기본적으로 설치되어 있다. 하지만 GitHub에서 사용하는 Ruby 버전은 ***ruby 2.1.1*** 이다. RVM이 설치되면 Rubyㄹㄹ 설치한다.

```
rvm install 2.1.1
```

그리고 기존의 ***ruby 1.9.3***을 사용하는 것이 아니라 ***ruby 2.1.1***을 기본으로 사용하기 위해 이것을 디폴트로 지정한다.

```
rvm --default use 2.1.1
```

### Gemfile 생성

우리가 위에서 `clone`한 `saltfactory.github.io` 디렉토리로 이동한다.

```
cd saltfactory.github.io/
```

지금부터 우리는 Jekyll을 사용해서 계정 페이지를 만들기 위해 필요한 라이브러리들을 설치할 것이다. Node.js가 ***npm***이 있는 것 처럼 Ruby는 [gem](https://rubygems.org/)이 있다. 필요한 라이브러리들을 ***Gemfile*** 안에 작성하고 `bundle install` 이라는 명령어로 필요한 라이브러리들을 한번에 설치할 수 있다.

GitHub는 Jekyll을 사용하기 위한 [의존성 버전](https://pages.github.com/versions/)을 업데이트하여 알려주고 있다.

우리가 설치할 때만 해도 아래와 같이 ***ruby 2.1.1*** 버전에 ***jekyll 1.5.1*** 버전을 사용했다.

```ruby
source 'https://rubygems.org'

gem 'jekyll', '1.5.1'
gem 'kramdown', '1.3.1'
gem 'liquid', '2.5.5'
gem 'maruku', '0.7.0'
gem 'rdiscount', '2.1.7'
gem 'RedCloth', '4.2.9'
gem 'jemoji', '0.1.0'
gem 'jekyll-mentions', '0.0.9'
gem 'jekyll-redirect-from', '0.3.1'
gem 'jekyll-sitemap', '0.3.0'
gem 'github-pages', '20'
```

오늘 확인 했을 때 다음과 같이 버전이 업그레이드 되었고 더 많은 라이브러리가 추가 되었다. 아래 내용을 `Gemfile`에 입력하고 저장한다.

```ruby
source 'https://rubygems.org'

gem 'jekyll', '2.2.0'
gem 'jekyll-coffeescript', '1.0.0'
gem 'jekyll-sass-converter', '1.2.0'
gem 'kramdown', '1.3.1'
gem 'liquid', '2.6.1'
gem 'maruku', '0.7.0'
gem 'rdiscount', '2.1.7'
gem 'redcarpet', '3.1.2'
gem 'RedCloth', '4.2.9'
gem 'pygments.rb', '0.6.0'
gem 'jemoji', '0.3.0'
gem 'jekyll-mentions', '0.1.3'
gem 'jekyll-redirect-from', '0.4.0'
gem 'jekyll-sitemap', '0.5.1'
gem 'github-pages', '22'
```

Gemfile을 저장하고 나면 필요한 라이브러리들을 설치한다.

```
bundle install
```

기존에는 [nokogiri](http://nokogiri.org/)를 사용하지 않았는데 이번 GitHub pages dependency versions에서는 nokogiri가 의존성이 있는 것으로 확인되었다. 만약 다음과 같이 에러가 발생한다면 nokogiri가 XML 라이브러리가 필요해서 생기는 문제이다.
![nokogiri install error](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0e0db0f8-8bc0-41c7-9a6e-0fa22f105219)

이 문제를 만나게 되면 [Homebrew](http://brew.sh/)를 사용해서 XML C 라이브러인 ***libiconv***를 설치한다. homebrew에서 libiconv를 찾아보자.

```
brew search libiconv
```
만약 아래와 같이 libiconv를 찾을 수 없다면 메세지가 나오면 Homebrew의 저장소를 추가해야한다.

```
Apple distributes libiconv with OS X, you can find it in /usr/lib.
Some build scripts fail to detect it correctly, please check existing
formulae for solutions.
homebrew/dupes/libiconv
```
```
brew tap homebrew/dupes/libiconv
```
위와 같이 `brew tap`을 하면 새로운 리파지토리가 추가되는 것을 확인할 수 있을 것이다. 이제 libiconv가 설치가 될 것이다.

```
brew install libiconv
```

마지막으로 nokogiri를 다시 설치한다. 다음과 같이 nokogiri가 정상적으로 설치가 되는 것을 확인할 수 있다.
![nokogiri installed](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2540c218-b519-407b-a2f0-c3a891aec775)

이제 Jekyll을 사용할 모든 준비가 끝났다.

## Jekyll 생성

이제 터미널에서 `jekyll` 명령어를 사용할 수 있다. 현재 우리는 GitHub에서 `clone`한 `saltfactory.github.io/` 디렉토리 안에 있다. 여기에 우리는 jekyll을 추가할 것이다.

```
jekyll new . --force
```
이렇게 jekyll을 새롭게 생성하면 디렉토리 안에 다음과 같은 파일들이 생성이 될 것이다.
![after jekyll new](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ca5de217-a265-43bb-8caa-bd12971c93e2)

만약  다음과 같이 ***LSI***에 대한 경고가 나오면 다음과 같이 [GSL](http://www.gnu.org/software/gsl/)을 설치한다. 이것은 C 연산 라이브리인데 이것을 사용하면 10배 정도 더 빠르게 연산이 가능하다.

> Notice: for 10x faster LSI support, please install http://rb-gsl.rubyforge.org/

```
brew install gsl
```

gsl 설치가 완료되면 `brew link`를 만들어서 `/usr/local`에 추가한다.

```
brew link gsl
```

만약 권한 문제로 링크가 만들어지지 않으면 다음과 같이 권한을 재 설정하고 다시 `brew link gsl`를 한다.

```
sudo chown -R `whoami` /usr/local
```

그리고 ***rb-gsl*** 을 설치한다.
```
gem install rb-gsl
````

이미 우리는 static websites를 만들 준비를 모두 마친것이다. jekyll 서버를 실행시켜보자. `--watch` 옵션은 서버가 실행되어 있을때 파일이 변경되면 서버 재시작 없이 자동으로 변경된 것을 반영하기 위해서이다.

```
jekyll serve --watch
```
![jekyll serve](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5532ff2b-6b80-41e6-b386-36ac9d7767f7)

Jekyll 서버가 정상적으로 시작되면 http://localhost:4000 을 브라우저에서 확인한다.

![preview default](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f2c8f409-d654-446b-9765-3d5d8691ade6)

서버가 실행되면 디렉토리에는 자동적으로 static page 들이 만들어진다. `tree` 명령어를 사용해서 확인해보자

```
tree
```

![tree after run](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e2ec3f4b-d78a-4164-b269-8902793410c2)

`_post` 디렉토리 안에 Markdown 으로 되어 있는 파일을 Jekyll이 자동으로 디렉토리를 만들면서 정적 HTML 파일을 생성한 것을 확인할 수 있다.

## _config.yml 설정

Jekyll의 모든 설정은 `_confg.yml` 파일에 저장한다. 이제 우리에 맞는 설정으로 바꾸어 보자. ***Jeyll 2.0*** 이상 버전 부터는 `pygments: true` 속성이 변경되어 `highlighter`로 이름이 바뀌었고 값으로 `pygments`를 지정한다.

```yaml
title: saltfactory.net
email: saltfactory@gmail.com

twitter_username: saltfactory
github_username:  saltfactory
facebook_username: salthub

markdown: redcarpet
redcarpet:
  extensions: ["no_intra_emphasis", "fenced_code_blocks", "autolink", "strikethrough", "superscript", "with_toc_data", "tables"]

highlighter: pygments

permalink: pretty

safe: true
lsi: true

gems:
  - jekyll-redirect-from
  - jemoji
```

다시 Jekyll 서버 를 실행시켜보자. `_config.yml` 파일은 `--watch` 옵션이 적용되지 않기 때문에 이 파일을 수정하면 Jekyll 서버를 다시 실행시켜야 한다.

![restart jekyll](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/39918d12-a161-4e63-b4cf-68c2d4ee449e)

![post view](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/662a626b-bdca-43e8-8e4d-0b0d5e97e2ba)


## 블로그 포스트 만들기

Jekyll은 **Markdown** 파일을 자동으로 정적 페이지로 만들어준다고 앞에서 이야기 했었다. `_post` 디렉토리에 Markdown 파일을 하나 추가해 보자. 파일을 생성할 때 다음 규칙을 지킨다.

1. 파일이름은 ***YYY-MM-dd-{영문제목}.md*** 형태로 만든다.
2. [Front Matter](http://jekyllrb.com/docs/frontmatter/)를 작성한다. Front Matter는 Jekyll이 정적 페이지를 만들때의 메타 정보를 기입하는 곳이다. 자세한 정보는 [링크](http://jekyllrb.com/docs/frontmatter/)를 참조한다.

```


## Jekyll

![jekyll](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/84755ce7-0464-4833-9cc5-2b4a922bf8e9)

[Jekyll](http://jekyllrb.com/)은 static websites 생성 프레임워크이다. `Ruby`로 만들어진 이 것은 **Markdown** 파일을 `_posts` 디렉토리에 생성하는 것 만으로 멋진 static website를 만들어준다. Markdown을 사용하는 개발자에게 반가운 이야기일 것이다. 우리도 Markdown을 표준 document format으로 정하고 난 뒤에 Jekyll을 사용해서 Pages를 만들고 기존의 블로그를 이전하고 있다.ndex.html 파일을 git push 하는 것 만으로도 만들 수 있고, 다른 static website generator framework를 사용해도 된다. GitHub에서는 공식적인 Database를 지원하고 있지 않기 때문에 static website(HTML 파일)을 사용해야 한다.
```

위와 같이 `_post` 디렉토리에 Markdown을 추가하면 Jekyll은 자동으로 새로운 정적 페이지를 만들고 적용한다.

![new post](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/eee2d1e3-d410-4137-bb7b-2261ab57ea44)

![example](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b49e0d83-14f3-4d67-979f-ef263ac80273)



## GitHub 에 적용하기

이제 모든 Jekyll로 계정 페이지를 만드는 일이 모두 끝났다. 이제 GitHub 적용하기 위해서는 모든 파일을 GitHub의 저장소에 `push` 하면 된다.

```
git add .
```

```
git commit -m "first import"
```

```
git push
```

마지막으로 GitHub에 계정 페이지가 만들어졌는지 확인해보자 http://saltfactory.github.io 를 브라우저에서 열어보면 우리가 로컬에서 `jekyll serve --watch`로 확인한 페이지가 그대로 적용된 것을 보게 될 것이다.

## 결론

***GitHub Pages***는 프로젝트 사이트를 만들 수 있게 제공하는 GitHub의 서비스이다. GitHub는 이름 답게 모든 것을 `git`로 처리를 한다. GitHub에 프로젝트 사이트를 만들기 위해서는 `gh-pages` branch를 만들어서 정적 페이지를 만들어 `git push`를 하면 된다. 이 때 정적 사이트를 만들기 위해서 ***Jekyll***을 사용 할 수 있다. Jekyll은 Markdown으로 작성된 파일을 자동으로 정적 페이지를 만들어주는 static website generator framework이다. GitHub Pages는 프로젝트 페이지 뿐만 아니라 **계정 페이지**를 만들 수 있는데 ***{계정이름}.github.io***라는 리파지토리를 생성하고 `master` branch에 정적 파일을 `git push`하여 만들 수 있다.

우리는 웹 사이트를 제작하기 위해서 비산 웹 서비스 환경을 구축하거나 호스팅 서비스를 사용해야하는데 GitHub Pages를 사용하면 무료로 자신만의 사이트를 구축할 수 있으며 `git`를 사용하여 컨텐츠 이력을 관리하고 archive할 수 있다. Jekyll을 사용하여 복잡하지 않는 방법으로 Markdown 형식으로 작성한 글을 블로그나 웹 서비스 형태로 만들어 낼 수도 있다. 이 포스팅에서는 GitHub Pages를 생성하는 방법과 Jekyll을 사용하여 정적 사이트를 만들어서 GitHub Pages에 적용하는 방법을 살펴보았다. Jekyll이 Ruby 기반으로 만들어져서 설치하는데 약간의 복잡함이 있지만 이 과정을 지나면 간편하게 나만의 웹 서비스를 마들어 낼 수 있을 것이다.

## 참고

1. https://rvm.io/
2. https://help.github.com/articles/using-jekyll-with-pages
3. https://pages.github.com/versions/
4. http://blog.saltfactory.net/search/rvm
5. http://stackoverflow.com/questions/5528839/why-does-installing-nokogiri-on-mac-os-fail-with-libiconv-is-missing
7. https://github.com/jekyll/jekyll/issues/652


