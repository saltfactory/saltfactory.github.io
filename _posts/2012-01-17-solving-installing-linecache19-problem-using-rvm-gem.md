---
layout: post
title: rvm 사용시 ruby 1.9 설치 후 irb에서 한글 입력되지 않는 문제 해결
category: ruby
tags: [ruby, irb, rvm, readline]
comments: true
redirect_from: /31/
disqus_identifier : http://blog.saltfactory.net/31
---

## 서론

[LineCaceh](https://rubygems.org/gems/linecache) 모듈은 디버깅이이나 예제용 프로그램 등 같은 코드가 여러번 사용될때 이것의 읽기 성능을 최적화 시켜주고 캐싱해주는 기능을 제공하는 모듈이다. LineCache의 RubyForge 사이트는 http://rubyforge.org/projects/rocky-hacks/linecache 이고 RubyGem 사이트는 http://rubygems.org/gems/linecache이다.  Python에서도 LineCache 모듈이 존재한다. 연구실에서 사용하던 git 서버는 [gitorious](https://gitorious.org)를 사용하여서 구축하였는데 업데이트 주기도 늦고 요즘 사람들이 많이 사용하고 있는 [gitlab](https://about.gitlab.com)으로 git 서버를 구축하기 위해서 서버를 마이그레이션 하기로 마음 먹었다. gitorious를 완전히 엎어 버릴수 없고 이전 소스를 따로 운영해야할지도 모르기 때문에 gitorious는 건들지 말고 gitlab을 설치하려고 했다. 문제는 gitorious는 Ruby 1.8.x에서 동작하였는데 gitlab은 gitolite 기반에 동작하고 이것이 ruby-1.9.2를 최소로 요구하고 있다. 다시 말해서 동일한 서버에 Ruby VM이 두가지가 설치되어야 한다. 그래서 결정한 것이 RVM(Ruby Version Manager)을 사용하기로 했다. RVM은 쉽게 Ruby VM을 선택적으로 빠르게 스위칭할 수 있는 프로그램인데 아마 Ruby 개발자나 Rails 개발자라면 대부분 RVM을 사용하지 않을까 생각한다. Ruby는 Python보다 업데이트 주기가 상당히 빠르다. 그래서 다양한 Ruby 버전이 존재하게 되었다. 기존의 모듈을 사용하거나 모든 버전에 문제없이 돌아가는 Ruby 프로그램을 만들기 이해서 Ruby VM 여러개를 스위칭하며 사용해야하기 때문이다. RVM에 대해서는 따로 포스팅을 준비하도록 하겠다.

<!--more-->

## gitlab 설치시 linecache19 설치 에러

RVM을 Multi-user 가 사용할수 있게 했고 `rvmsudo rvm install ruby-1.9.2-head`로 가장 최신 Ruby를 설치했다. 그리소 gitlab을 위한 gitolite를 설치하고 드디어 gitlabhq를 git로 clone 받아서 bundle install로 설치하는데 linecache19에서 에러가 발생하면서 설치가 중단되었다. (물론 더 많은 설치 에러가 있었지만 각 모듈에 대한 필요한 패키지나 dev ilb가 없어서 생기는 문제였다. 이것은 apt-get install을 이용해서 해당 dev나 lib 패키지들을 설치해주면 된다.)

문제는 linecache19가 설치가 되지 않는 것이다.

```
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/local/rvm/rubies/ruby-1.9.2-head/bin/ruby extconf.rb
checking for vm_core.h... no
checking for vm_core.h... no
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.

Provided configuration options:
	--with-opt-dir
	--with-opt-include
	--without-opt-include=${opt-dir}/include
	--with-opt-lib
	--without-opt-lib=${opt-dir}/lib
	--with-make-prog
	--without-make-prog
	--srcdir=.
	--curdir
	--ruby=/usr/local/rvm/rubies/ruby-1.9.2-head/bin/ruby
	--with-ruby-dir
	--without-ruby-dir
	--with-ruby-include
	--without-ruby-include=${ruby-dir}/include
	--with-ruby-lib
	--without-ruby-lib=${ruby-dir}/lib
/usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/contrib/uri_ext.rb:268:in `block (2 levels) in read': Looking for http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p312.tar.gz and all I got was a 404! (URI::NotFoundError)
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:1194:in `block in transport_request'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:2342:in `reading_body'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:1193:in `transport_request'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:1177:in `request'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:1170:in `block in request'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:627:in `start'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/net/http.rb:1168:in `request'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/contrib/uri_ext.rb:239:in `block in read'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/contrib/uri_ext.rb:286:in `connect'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/contrib/uri_ext.rb:234:in `read'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/contrib/uri_ext.rb:128:in `download'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/ruby_core_source.rb:55:in `block in create_makefile_with_core'
	from /usr/local/rvm/rubies/ruby-1.9.2-head/lib/ruby/1.9.1/tempfile.rb:320:in `open'
	from /usr/local/rvm/gems/ruby-1.9.2-head/gems/ruby_core_source-0.1.5/lib/ruby_core_source.rb:51:in `create_makefile_with_core'
	from extconf.rb:19:in `<main>'
Requesting http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p312.tar.gz


Gem files will remain installed in /home/hibrainapps/.bundler/tmp/2581/gems/linecache19-0.5.12 for inspection.
Results logged to /home/hibrainapps/.bundler/tmp/2581/gems/linecache19-0.5.12/ext/trace_nums/gem_make.out
An error occured while installing linecache19 (0.5.12), and Bundler cannot continue.
Make sure that `gem install linecache19 -v '0.5.12'` succeeds before bundling.
```

이와 같은 에러를 내면서 발생하면서 설치가 되지 않는다. 자료를 찾아보는 가운데 ruby-debug와 linecache19는 ruby 설치 소스 파일을 참조한다는 것을 알게 되었다(http://stackoverflow.com/questions/6650567/installing-linecache19-for-ruby-1-9-2-via-rvm). 그래서 RVM에 설치되는 ruby의 소스 파일 경로를 찾아보니 경로는 다음과 같다. Multi-User를 위해서 rvmsudo를 사용해서 ruby를 설치하게 되면 다음과 같은 경로에 소스파일이 존재한다. 다른 버전의 ruby를 설치하면 ruby-1.9.2-head 대신에 해당 ruby 버전을 찾아서 하면 된다.

```
/usr/local/rvm/src/ruby-1.9.2-head
```

만약 Single-User 모드로 RVM을 설치했다면 아마도 경로는 다음과 같은 곳에 설치되어 있을 것이다.

```
$HOME/.rvm/src/ruby-1.9.2-head
```

이제 소스파일을 가지고 다시 linecache19를 설치해보자. Muti-User 모드로 설치할때는 다음과 같이 하면 된다.

```
rvmsudo gem install linecache19 -- --wth-ruby-include=/usr/local/rvm/src/ruby-1.9.2-head
```

Single-User 모드로 설치할 때는 다음과 같이 하면 된다.

```
gem install linecache19 -- --with-ruby-include=$HOME/.rvm/src/ruby-1.9.2-head
```

![](http://blog.hibrainapps.net/saltfactory/images/8e639082-fa36-4146-a143-b59dd8df2553)

ruby-debug-base19 설치에서도 동일한 문제로 설치가 되지 않는다. 위와 같은 방법으로 설치하면 해결할 수 있다.



