---
layout: post
title : Ubuntu에 nokogiri 설치
category : ruby
tags : [nokogiri, ubuntu, ruby, gem]
comments : true
redirect_from : /17/
disqus_identifier : http://blog.saltfactory.net/17
---

Ruby를 사용하여 HTML을 파싱하기 위해서 nokogiri를 사용려고 Ubuntu에 nokogiri를 설치하면 libxml2를 찾지 못한다는 에러를 만나게 된다.
<!--more-->

```
sudo gem install nokogiri
```

```text
ERROR:  Error installing nokogiri:
ERROR: Failed to build gem native extension.

/usr/bin/ruby1.8 extconf.rb
checking for libxml/parser.h... no
-----
libxml2 is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
-----
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options
```

이는 [libxml2](http://packages.ubuntu.com/search?keywords=libxml2)의 라이브러리가 Ubuntu에 설치되어 있지 않아서 생기는 문제이다.

해결 방법은 libxml2 라이브러리들을 설치해주고 nokogiri를 설치하면 된다.

```
sudo apt-get install libxml2 libxml2-dev libxslt1-dev
```
```
sudo gem install nokogiri
```
```
irb
```
```text
irb(main):001:0> require 'rubygems'
=> true
irb(main):002:0> require 'nokogiri'
=> true
```

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
