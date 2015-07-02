---
layout: post
title: Mac OS X에서 Apache + PHP + MongoDB 연동
category: php
tags: [php, apache, mongodb, mac, osx]
comments: true
redirect_from: /157/
disqus_identifier : http://blog.saltfactory.net/157
---

## 서론

맥은(Mac OS X) 훌륭한 개발 환경을 제공한다. 내가 Mac을 가장 좋아하는 이유는 데스크탑이나 랩탑안에 PC환경과 Server 환경 모두를 사용할 수 있기 때문이다. 더구나 설정만 잘 한다면 개발했던 경로, 환경을 새로 고침없이 바로 서버로 소스관리툴로 업데이트하여 다운타임 시간 없이 바로 서버 개발을 할 수 있다는 것이다. Mac OS X에서는 서버에서 사용할 수 있는 오픈 소스가 대부분 설치되어 있다. Mac OS X Lion으로 업데이트되면서 Java Runtime Engine이 제외되었지만 다운로드하여 설치할 수 있는 쉬운 방법을 제공해주고 있다. 또는 유닉스(리눅스) 소프트웨어를 Mac OS X에 쉽게 설치할 수 있는 Homebrew나 port로 built-in 되어 있지 않은 공개소프트웨어를 쉽게 추가하거나 관리할 수 있다. 내가 Mac 을 상용하는 이유가 바로 화려하고 이쁜 UI 뿐만 아니라 Unix-like system을 윈도우즈만큼 빠른 UI와 Unix만큼 편리한 command를 사용할 수 있어 서버 프로그램을 개발하는데 아주 유용하기 때문이다.

서비스개발 프로젝트를 하면서 경험적으로 느낀것은 최신기술, 유행하는 프레임워크가 아니라 프로젝트를 성공적으로 끝낼 수 있는 개발자에게 가장 자신있고 빠르게 코드를 리비전할 수 있는 언어를 선택해서 자유도와 완성도를 높게 만들어서 프로젝트를 완료하는게 중요하다는 것을 알게 되었다. 개인 혼자서 Springframework와 ORM framework를 사용하면서 엔터프라이즈급 서비스가 아닌데 무작정 유행하는 프레임워크를 도입하게 되면 프로젝트 개발도 힘들어지고 덩치가 커질염려가 있다. 그래서 이번에는 서버프로젝트를 가볍고 빠르게 개발하려는 목적과 현재 서버 프로그램을 담당할 연구원이 PHP를 사용하고 있던 기술이 있어서 프레임워크 도입을 PHP 기반으로 가기로 했다.

Mac에서는 기본적으로 Apache와 PHP가 설치되어 있다. 이 포스팅에서는 built-in으로 설치된 Apache와 PHP 그리고 Homebrew를 이용해서 mongodb를 설치하고 pear를 이용해서 PHP mongoDB driver를 설치한 후에 PHP에서 mongoDB를 사용할 수 있는 환경을 설정하는 것에 대한 내용을 소개하려고 한다.

<!--more-->

## Apache

우선 Mac에서 Apache 웹 서버를 사용하기 위해서는 GUI로 실행하는 방법과 command로 실행하는 방법 두가지가 있다.
System preferences를 열어서 Sharing을 선택하고 Web Sharing을 활성화 시키면 Web Sharing : On으로 상태가 변경된다.

![](http://cfile25.uf.tistory.com/image/155564444FD68BEF25257F)

![](http://cfile9.uf.tistory.com/image/191A15354FD68C36190FA8)

프로세스를 확인해보자.

```text
ps -ef | grep httpd
```

![](http://cfile25.uf.tistory.com/image/177CAF344FD68CBE17816C)

프로세스를 확인하면 WEBSHARING_ON 모드로 httpd 웹 서버 데몬이 동작하고 있는 것을 확인할 수 있다. 이제 브라우저를 열어서 주소창에 자신의 아이디를 가지는 주소를 입력해보면 Mac에서 기본적으로 제공하고 있는 웹 사이트 개발에 필요한 개인 사이트 디렉토리(~/Sites)의 파일이 열릴 것이다.

![](http://cfile3.uf.tistory.com/image/13408A464FD68D79094BE9)

이제 command로 httpd 웹 서버를 실행시켜보자. System Preferences에서 웹 공유를 하기 위해서 켜두었던 Web Sharing을 Off로 변경하고 터미널을 열어서 다음과 같이 명령어를 입력한다.

```text
sudo httpd -k start
```

![](http://cfile23.uf.tistory.com/image/150653364FD68E5728336F)

httpd 프로세스가 동작하고 있고 위에서 확인한 것 처럼 브라우저에서 계정의 홈 사이트를 열어보면 (http://localhost/~Saltfactory) 사이트가 열리는 것을 확인할 수 있다. 서비스를 멈추기 위해서는 stop 명령어를 사용하면 된다.

```text
sudo httpd -k stop
```

![](http://cfile3.uf.tistory.com/image/130759344FD68EC213F7D5)

위 캡처에서는 warning이 나타난 것을 확인할 수 있는데 이것은 Apache를 설정하는 httpd.conf에 서버의 full qualified domain name이 없어서 그렇다. (예, http://blog.saltfactory.net 이나 http://127.0.0.1 과 같은 서버 네임)
httpd 명령어 말고 apachectl 이라는 명령어로 실행하거나 중지할 수 있다.

```text
sudo apachectl start
```

```text
sudo apachectl stop
```

![](http://cfile9.uf.tistory.com/image/134DD83D4FD693141984D8)

## Apache에서 PHP 모듈 사용 설정

php가 동작하는지 살펴보자. 자신의 사이트 디렉토리에서 test.php를 생성하고 다음 코드를 입력하자.

```text
vi ~/Sites/test.php
```

```php
<?php
phpinfo();
?>
```

다음과 같은 화면이 나오는가? 이렇게 나온다는 말은 apache와 php의 설정이 제대로 되어 있는 것이다.

![](http://cfile6.uf.tistory.com/image/134547404FD6947A010A67)

만약 위와 같이 나오지 않고 소스코드가 그대로 보인다면 다음 설정을 확인해서 설정해준다. 아마 최초에는 Apache에서 PHP 모듈을 사용하는 설정이 커멘트되어 있을 것이다.
Mac에서 Apache 서버의 환경설정 파일은 /private/etc/apache2/httpd.conf  에 있다.

```text
sudo vi /private/etc/apache2/httpd.conf
```

약 116라인쯤에 Apache에 모듈 사용을 설정하는 부분에서 php5_module 이 주석이 되어 있는 것을 확인할 수 있을 것이다.

![](http://cfile10.uf.tistory.com/image/150DC6374FD6C1A705934C)

여기서 116 라인의 앞의 주석을 제거하고 저장하고 나온뒤, Apache 서버를 재시작한다.

```text
#LoadModule php5_module       libexec/apache2/libphp5.so
LoadModule php5_module        libexec/apache2/libphp5.so
```

다시 http://localhost/~Saltfactory/test.php 를 확인하면 phpinfo(); 가 정확하게 나오는 것을 확인할 수 있다.

## MongoDB 설치

이제 MongoDB를 설치할 것인데, 이 블로그를 계속적으로 구독한다면 Homebrew의 사용에 대한 아티클을 봤을 것이다. Homebrew는 Mac OS X에서 missing unix package를 관리하는 툴인데 개발할 때 가장 사용 많이하는 툴이다. [Homebrew를 이용하여Mac OS X에서 Unix 패키지 사용하기](http://blog.saltfactory.net/109)를 살펴보면 Homebrew를 설치하고 그것을 이용해서 패키지를 설치하는 방법에 대해서 참조할 수 있다. Homebrew를 설치했다고 생각하고 진행한다.

```text
brew install mongodb
```

별 이상없이 간단하게 설치가 될 것이다. MongoDB를 설치한 후에 MongoDB를 LaunchAgent를 이용해서 사용할 것인지, 메뉴얼로 사용할 것인지 메세지가 나오는데, 개발할 때만 사용할 것이기 때문에 그냥 메뉴얼하게 MongoDB를 실행하도록 해보겠다.
MongoDB는 서버를 실행할 때 MongoDB 데이터를 저장할 곳이라던지 서버에 관한 설정을 외부 파일에서 작성해서 적용하는데 Homebrew로 설치할 경우 MongoDB는 /usr/local/Cellar/mongodb/2.0.6-x86_64 에 설치가 되고 /usr/local/etc/mongodb.conf로 설정 파일이 생성되어 진다.
그래서 mongodb를 메뉴얼하게 실행하기 위해서는 다음과 같이 터미널에 명령어를 입력한다.

```text
sudo mongod --config /usr/local/etc/mongodb.conf
```

mongodb.conf 파일에는 다음 설정이 기본적으로 저장되어져 있다.

```text
# Store data in /usr/local/var/mongodb instead of the default /data/db
dbpath = /usr/local/var/mongodb

# Only accept local connections
bind_ip = 127.0.0.1
```

![](http://cfile3.uf.tistory.com/image/14074D464FD6C5FF2F58FC)

이 아티클은 MongoDB 사용법에 대한 글이 아니라 Apache와 PHP 그리고 MongoDB의 연동을 주제로 한 글이기 때문에 자세한 사용법은 다른 글에서 소개하겠다.

## PEAR(PHP Extension Application Repository) 설치

Apache에서 PHP를 사용하기 위해서 php5_module을 사용하기 위해서 설정한 것을 위에서 살펴볼 수 있다. PHP에서 MongoDB를 사용하기 위해서 PHP용 MongoDB driver를 설치해야하는데 이것은 PHP의 extension 으로 설치를 할 수 있다. PHP를 재설치하지 않고 이미 설치되어 있는 PHP의 자원을 참조해서 extension을 추가하기 위해서는 pear(PHP Extension Application Repository)라는 것을 사용해야한다. 이것은 Mac OS X에 기본적으로 설치되어 있는 것이 아니기 때문에 소스코드로 설치해보도록 하자.

pear를 다운받기 위해서 /opt 폴더로 이동을 하고 pear를 wget으로 다운받는다.

```text
cd /opt
```

```text
wget http://pear.php.net/go-pear.phar
```

만약 wget 명령어가 없다면 Homebrew로 wget을 설치하고 다시 소스를 다운 받는다.

```text
brew install wget
```

pear를 다운 받고 난 다음에 다음과 같이 명령어를 실행시켜보자.

```text
sudo php -d detect_unicode=0 go-pear.phar
```

그러면 다음과 같이 패키지를 설치할 경로에 대해서 물어본다. 디폴트로 설치하려면 그냥 enter를 누르면 되고 난 prefix를 가지고 설치하기 위해서 1을 누르고 enter를 눌러서 prefix를 /usr/loca/pear로 설치할 수 있게 하였다.

![](http://cfile4.uf.tistory.com/image/186BBA344FD6C959099334)

이렇게 설정하고 pear를 실행하면 다음과 같은 경로를 만나게 된다.

```text
WARNING!. The include_path define in the currently used php.ini does not contain the PEAR PHP directory you just specified:
```

이 경고는 PEAR로 PHP의 extension 을 설치하면 php.ini 파일에 추가가되는데 php.ini 파일을 찾을 수 없어서 발생하는 문제이다.

![](http://cfile22.uf.tistory.com/image/1337373E4FD6C9FF24E427)

phpinfo()에서 .ini 파일을 찾아보도록 다음 명령어를 실행해보자.

```text
php -r "phpinfo();" | grep '.ini'
```

출력된 결과를 확인해보면 Configuration File(php.ini) Path =>/etc 로 시스템의 /etc 밑에 있다고 정의되어 있는데 실제 /etc/php.ini 파일이 존재하지 않는다. (php.ini.default 만 존재한다. php.ini의 샘플 파일을 미리 만들어서 php.ini.default로 설치되어 있는 것이다.)

![](http://cfile22.uf.tistory.com/image/172C91394FD6C89926F834)

이렇게 command로 확인할 수 있거나 우리가 방금 브라우저에서 확인했던 phpinfo(); 코드가 포함된 test.php를 열어서 확인할 수도 있다.

![](http://cfile21.uf.tistory.com/image/1357BD4C4FD6CC0C392AFA)

그럼 우리는 샘플로 만들어져있는 php.ini.default를 /etc/php.ini로 변경해보자.

```text
sudo mv /etc/php.ini.default /etc/php.ini
```

그리고 다시 php -r command로 확인해보자. 이제 /private/etc/php.ini에서 php.ini를 Loaded 한것을 확인할 수 있다.

![](http://cfile23.uf.tistory.com/image/2038E9394FD6CD122FF435)

우리는 /etc/php.ini로 복사를 했는데 왜 /private/etc/php.ini로 검색이 되었을까? Mac에서는 /etc 가 /private/etc를 심볼릭링크로 만들어져 있기 때문이다.

```text
ls -al /
```

![](http://cfile4.uf.tistory.com/image/1254194A4FD6CDE11C8E2A)

php -r 말고 test.php를 부라우저에서 확인해보자. Loaded Configuration File 항목에 /private/etc/php.ini 가 설정된 것을 확인할 수 있다.

![](http://cfile2.uf.tistory.com/image/2037F53A4FD6CE0B22E34B)

이제 pear를 다시 실행시키자.

```text
sudo php -d detect_unicode=0 go-pear.phar
```

![](http://cfile2.uf.tistory.com/image/174F37384FD6CCC228236F)

php.ini를 검색하게 되었고 이것을 이용해서 설치를 하게 된다. 설치가 완료되면 php.ini를 열어보자. php.ini 파일 가장 마지막 부분에 다음 코드가 추가된 것을 확인할 수 있다.

```text
;***** Added by go-pear
include_path=".:/usr/local/pear/share/pear"
;*****
```

## PHP용 MongoDB driver 설치

이렇게 PEAR(PHP Extension Application Repository)가 설치가되면 PECL(PHP Extension Community Library)를 이용해서 MongoDB driver를 설치할 수 있다.

```text
sudo /usr/local/pear/bin/pecl install mongo
```

![](http://cfile24.uf.tistory.com/image/117E7F364FD6CEE030C04D)

아마 처음 설치한다면 다음과 같이 "phpize" failed 에러가 발생할 것이다. 이것은 autoconf 명령어가 없어서 발생하는 문제인데 Homebrew를 이용해서 autoconf를 설치한다.

```text
brew install autoconf
```

![](http://cfile7.uf.tistory.com/image/192D4D434FD6CF690CFB9B)

다시 pecl 명령어를 사용해서 PHP용 MongoDB driver를 설치한다.

```text
sudo /usr/local/pear/bin/pecl install mongo
```

이제 에러 없이 설치가 완료되는 것을 확인할 수 있다. extension=mongo.so를 php.ini에 추가하라고 메세지가 출력된다.

![](http://cfile27.uf.tistory.com/image/14273E3B4FD6CFF42D84B7)

php.ini 파일을 열어서 extension을 추가하는 부분에 extension=mongo.so를 추가한다.

```text
sudo vi /etc/php.ini
```

![](http://cfile23.uf.tistory.com/image/206CBF424FD6D055172182)

이제 phpinfo()를 확인하자. test.php를 브라우저에서 열어보자. PHP용 MongoDB driver인 mongo가 1.2.10 버전이 설치되어 있는 것을 확인할 수 있다.

![](http://cfile24.uf.tistory.com/image/162A8A404FD6D0B00C2AFB)

php -r 명령어로 확인해보자.

```text
php -r "phpinfo();" | grep 'mongo'
```

![](http://cfile25.uf.tistory.com/image/1142793D4FD6D1030E05B9)

이제 PHP 프로그램에서 MongoDB를 사용할 수 있는지 간단한 코드로 테스트해보자. 테스트 소스는 간단하다 Mongo 커넥션을 열어서 mydb라는 데이터베이스를 지정하여 mycollection이라는 컬렉션에 myobj, myobj2를 저장하고 컬렉션에서 find()하여 모든 객체를 찾아서 출력후 db를 닫고 커넥션을 닫는 코드이다.


```php
<?php  
    error_reporting(E_ALL);
    ini_set('display_errors', '1');

    header("Content-type: text/plain");

    $connection = new Mongo();
    $db = $connection->mydb;

    $collection = $db->mycollection;
    $myobj = array("first_name" => "John", "last_name" => "Doe", "age" => 30);
    $myobj2 = array("first_name" => "Jane", "last_name" => "Doe", "age" => 27);
    $collection->insert($myobj);
    $collection->insert($myobj2);

    $cursor = $collection->find();
    foreach($cursor as $result)
    {
        echo "Name: " . $result["last_name"] . ", " . $result["first_name"] . "\n";
        echo "Age: " . $result["age"] . "\n\n";
    }

    $db->drop();
    $connection->close();
?>
```

이 코드를 test.php에 추가하고 브라우저에서 열어보자. 다음과 같이 PHP에서 MongoDB를 이용해서 저장하고 찾은 결과를 웹 페이지에서 출력할 수 있게 되었다.

![](http://cfile25.uf.tistory.com/image/20724D424FD6D311238BCA)

## 참고

1. https://groups.google.com/forum/?fromgroups#!topic/mongodb-user/CsMbnbzAGMs
2. http://www.deoker.com/686
3. http://manas.tungare.name/blog/how-to-install-mongodb-for-php-on-mac-os-x/
4. http://stackoverflow.com/questions/628838/how-to-set-up-pear-on-mac-os-x-10-5-leopard
5. http://stackoverflow.com/questions/9322742/php-autoconf-errors-on-mac-os-x-10-7-3-when-trying-to-install-pecl-extensions

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
