---
layout: post
title : gem install mysql 설치 방법
category : ruby
tags : [ruby, gem, mysql]
comments : true
redirect_from : /18/
disqus_identifier : http://blog.saltfactory.net/18
---

ruby에서 mysql 모듈을 설치하기 위해서 gem을 이용하는데

```
gem install mysql
```
을 하면 다음과 같이 mysql을 찾지 못한다는 메세지를 출력받게 된다.

<!--more-->

```text
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.

Provided configuration options:
	--with-opt-dir
	--without-opt-dir
	--with-opt-include
	--without-opt-include=${opt-dir}/include
	--with-opt-lib
	--without-opt-lib=${opt-dir}/lib
	--with-make-prog
	--without-make-prog
	--srcdir=.
...
```

이와 같은 경우는 mysql 디렉토리를 찾지 못해서 발생하는 경우가 대부분이다. 특히 Mac OS X 에서 mysql을 다운받아 설치할 경우 나타나는데. 이때 설치 옵션을 이용하면 된다. 압축을 /usr/loca/mysql로 풀어서 사용하거나, 다른 디렉토리에 설치해서 심볼릭링크를 만들어도 되겠다. 물론, 특정 디렉토리에 설치하더라도 옵션에서 경로만 정확하게 입력해주면 문제없이 설치된다.

```
gem install mysql -- --with-mysql-dir=/usr/local/mysql --with-mysql-lib=/usr/local/mysql/lib --with-mysql-include=/usr/local/mysql/include
```

설치가 성공적으로 되었다는 메세지는 다음과 같다.

```text
Building native extensions.  This could take a while...
Successfully installed mysql-2.8.1
1 gem installed
Installing ri documentation for mysql-2.8.1...
Installing RDoc documentation for mysql-2.8.1...
```

**irb**를 이용하여 require 'mysql'을 하면 true가 나타날 경우 정상적으로 설치 되었다는 것을 알 수 있다.

