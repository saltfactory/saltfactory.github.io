---
layout: post
title: RVM으로 Ruby 1.9.3 설치시 Error running GEM_PATH 문제 해결하기
category: ruby
tags: [ruby, rvm, error, gem]
comments: true
redirect_from: /188/
disqus_identifier : http://blog.saltfactory.net/188
---

## 서론

RVM(Ruby Version Manager)는 하나의 머신(Mac, PC, Linux 등)에 여러버전의 Ruby 를 설치해서 alternative 하게 Ruby 버전을 동시에 사용할 수 있게 해준다. 이미 Ruby 나 Ruby on Rails를 개발하거나 연구 도구로 사용할 때 RVM은 가장 많이 사용하고 있는 Ruby 환경이 아닐까 생각이된다.  현재 나의 맥에는 RVM을 이용해서 여러버전의 Ruby를 설치하고 테스트하고 있다. Lagacy 서버에서는 ruby 1.8로 만들어진 프로그램들이 있고 최근에는 ruby 1.9 기반으로 만들어진 서버 프로그램들이 있기 때문에 개발용 맥북에서는 동시에 여러버전을 테스트하기 위해서 RVM을 사용하고 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/591d25b8-998a-489a-9354-542ca2281cf9)

<!--more-->

## GEM_PATH 에러

ruby 1.9.3 버전이 릴리즈된지 시간이 지났기 때문에 rvm 으로 1.9.3을 설치하려고 하니 다음과 같음 문제가 발생했다. 이상하게 GEM_PATH 문제를 발생하면서 Ruby 1.9.3-head 버전은 설치되었지만 WARN을 발생하였다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/390a3c60-ffac-4ff6-a976-cccc3d38dac4)

그래서 GEM의 최선버전 설치 문제 인가 싶어서 rubygem을 최신 버전을 다시 업그레이드 설치를 했지만 역시 에러가 발생을 했다. 그래서 RVM 자체가 문제인가 싶어서 RVM을 업그레이드 하도록 했다.
문제가 발생한 RVM 버전은 1.6.23 이였다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8c02162d-b192-48ec-8368-919fc34085da)


## 최신 RVM 설치

RVM 최신 head를 받는다. RVM은 정말 잘 만들어진 툴이다. 다음 명령어를 하면 github에서 관리되고 있는 소스버전중에 HEAD를 찾아서 바로 다운로드 시켜주기 때문이다.

```
rvm get head
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/864369db-b03a-4dfb-a892-cc7a86122572)

이렇게 소스를 다운받아서 최신 소스로 변경시켜준다. rvm get head 이후 RVM은 1.15.8 버전으로 변경이 되었다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9534d93c-a5d4-4037-aa6a-e87b66946f67)

새로 변경된 RVM 파일을 갱신하기 위해 reload를 한다.

```
rvm reload
```

그리고 다시 ruby 1.9.3 을 설치한다.

```
rvm reinstall ruby 1.9.3-head --with-gcc=clang
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f2cfb1cd-9be8-4584-bac0-8a3b7c8af477)

이제 정상적으로 ruby 1.9.3-head가 설치되었다. 만약 ruby 1.9.3 head가 아닌 ruby 1.9.3 버전을 설치하고 싶으면 다음과 같이한다.

```
rvm install ruby-1.9.3 --with-gcc=clang
```

## 참조

1. http://stackoverflow.com/questions/9439502/rvm-install-ruby-installation-error

