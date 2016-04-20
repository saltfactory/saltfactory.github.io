---
layout: post
title: Xcode 업그레이드 이후 gem 라이브리 설치시 에러 발생하는 문제 해결하기
category: ruby
tags:
  - ruby
  - xcode
  - gem
comments: true
images:
  title: 'http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/df981f27-c49e-4906-8d0e-f3b15506eed6'
---

## 서론

얼마전 OS X 운영체제의 업그레이드 공식 발표 이후 **Mac OS X 10.10(Yosemite)** 에서 **Mac OS X 10.11(El Capitan)**으로 업그레이드를 진행하였다. 블로그를 [Jekyll](https://jekyllrb.com/) 기반으로 운영하고 있기도 하고 [Ruby on Rails](http://rubyonrails.org/) 를 가지고 진행하는 프로젝트가 있기 때문에 Ruby 기반의 환경 개발을 위해 RVM을 항상 사용하고 있다. OS X를 업그레이드 한 이후 Xcode를 업그레이드한 것을 잊고 Jekyll 라이브러를 업그레이드하기 위해서 gem install를 실행하는데 에러가 발생해서 잠시 당황했다. 순수 Ruby로 작성된 라이브리가 아니라 native 컴파일을 사용하는 라이브러리가 컴파일러를 사용할 때 발생하는 문제였다. Xcode는 업그레이드 이후 라이센스 동의를 하지 않으면 해당 패키지들을 사용할 수 없는 이유였다. 이번 포스팅에서는 Xcode 업그레이드 이후 라이센스 동의를 하지 않았을 때 만날 수 있는 문제를 소개한다.

<!--more-->

## Xcode 업그레이드 이후 gem 설치

Xcode 업그레이드 이후 Ruby gem 중에 native 컴파일을 하는 라이브러리가 설치되지 않는 문제를 만날 수 있다. 우리는 [ffi](https://github.com/ffi/ffi/wiki) 를 설치하는 과정에서 에러를 만나게 되었다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7758c5ae-78f1-4891-9f61-63f0a3b29086)

Gem 라이브러리 중에서는 순수하게 Ruby로 작성된 라이브러리도 있지만 C 라이브러리를 사용하거나 네이티브 컴파일을 필요로한 라이브러들이 있는데 이러한 라이브러리들은 컴파일러를 사용한다. Mac의 경우 Xcode를 설치하면 **Command Line Tools**에 이것을 포함하고 있다.

만약 Xcode를 업그레이드 하였다면, 반드시 Xcode의 라이센스에 동의를 해야한다. 라이센스 동의를 하지 않고 컴파일러를 실행시키면 다음과 같은 메세지를 보여준다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ccc6d03c-2b2a-4336-a348-90450a6976e9)


새롭게 설치하거나 업그레이드한 Xcode를 실행한다. 그러면 아래와 같이 **Xcode and iOS SDK License Agreement** 화면이 나타난다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a29a12ac-cf28-43c3-bd3a-31e5d95aa064)

Agree 버튼을 클릭한다. Xcode의 라이센스를 동의하기 위해서는 시스템 admin 권한이 필요하다. admin 권한 획득을 위해 비밀번호를 입력하여 Xcode 라이센스를 동의한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9cf8e8f3-5e42-4262-ae0e-0f7df1748c46)

이제 다신 gcc 컴파일을 실행해보자. Xcode 라이센스를 동의하기 전 메세지와 달리 컴파일러 정보가 나타난다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9f1a1ce9-a516-4d29-919a-adc0f7e5f402)

다시 Gem을 설치해보자. native 컴파일이 필요하던 **ffi** 라이브러가 정상적으로 설치된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/af4e7877-0873-43b6-b2d9-a530015dfbf3)

