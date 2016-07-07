---
layout: post
title : Mac OS X에 CakePHP (2.x) 설치하기
category : php
tags : [php, cakephp, mac, osx]
comments : true
redirect_from : /176/
disqus_identifier : http://blog.saltfactory.net/176
---

## 서론

Ruby on Rails는 웹 개발의 발전을 선두한다고 말하고 싶을 정도로 웹 개발을 빠르게 할 수 있고 커뮤니티가 매우 엑티브하다. RoR은 MVC 패턴으로 웹을 개발할 수 있게 해주는 프레임워크로 웹 개발자가 MVC 패턴을 수동으로 만들지 않고 프레임워크가 제공하는 MVC 패턴으로 개발하기만 하면 매우 안정적으로 훌륭한 MVC 기반의 웹 어플리케이션을 만들 수 있는 환경을 제공한다. 이러한 RoR의 강점은 다른 웹 프레임워크에도 영향을 미쳤는데, 그중에 하나가 바로 CakePHP이다. 지금까지 PHP로 두서 없이 PHP 웹 사이트나 어플리케이션을 개발했다면 CakePHP로 MVC 패턴으로 웹 개발을 빠르게 할 수 있을 것이다. 이 포스팅은 Mac OS X에서 원격서버 없이 인터넷이 되지 않는 곳에서도 CakePHP 어플리케이션을 개발하기 위한 설치 방법을 소개한다.
<!--more-->

CakePHP는 PHP 어플리케이션을 만들기 위한 MVC 기반 웹 프레임워크이다. 이말은 기본적으로 웹서버, 데이터베이스 서버, PHP 가 필요하다는 말과 동일하다. PHP 개발을 위한 웹 서버로는 Apache, NGINX, LIGHTHTTPD 웹 서버가 가장 많이 사용되고 있다. Mac OS X는 유닉스 기반의 운영체제로 여러가지 유닉스 프로그램이 번들로 설치가 되어 있는데, Aapache와 PHP가 기본적으로 설치가 되어 있다.

맥 (Mac OS X)에서 Aapche 와 PHP를 설정하는 방법은 Mac OS X Lion에서 Apache + PHP + MongoDB 연동 글을 참조하길 바란다. MySQL 서버는 http://dev.mysql.com/downloads/mysql/5.1.html 에서 Mac OS X 용으로 다운 받아서 설치를 한다. dmg 파일을 받아서 사용해도 되고 tar 를 받아서 설치해도 된다. 또는 macport나 homebrew를 사용해서 mysql 서버를 설치해도 상관없다. tar 로 되어 있는 MySQL community server를 다운 받았고 tar를 다운받아서 /Projects/Server/mysql 로 압축을 풀었다고 가정한다. 이제 mysql  서버는 다음과 같이 실행할 수 있다.

```
/Projects/Server/mysql/support-mysql/mysql.server start
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f06c9fbb-2be3-44a2-8d53-74868697a55f)

이렇게 Aapache, PHP, MySQL  서버가 모두 설치 되었으면 이제 CakePHP를 소스를 다운받는다. PHP 작업을 위해서 /Projects/Workspaces/PHP/ 에서 작업을 한다고 가정한다. (자신이 편한 경로에 작업을 해도 상관없다)

```
cd /Projects/Workspaces/PHP
```
```
git clone https://github.com/cakephp/cakephp
```

이렇게 CakePHP를 다운 받았으면 작업의 편의를 위해서 몇가지 설정을 해보자. 우선, CakePHP를 위한 호스트이름이 필요하다. PHP는 웹 프로그램으로 브라우저에서 작업해야하는데 작업할 때마다 길다란 경로를 브라우저에 입력하는 것은 여간 힘든 작업이 아니다. 그래서 우리는 이 복잡함을 Apache의 virtual host로 간단하게 만드는 작업을 할 것이다. apache의 virtual host를 사용하기 위해서 httpd.conf에 vhost 설정 파일의 주석을 풀어줘야한다.

```
sudo vi /private/etc/apache2/httpd.conf
```


apache의 httpd.conf 에서 vhost를 사용하기 위해서 2가지를 확인해야한다. vhost_alias_module이 모듈로 로드되고 있는지, vhost 설정 파일이 로드되고 있는지를 확인해야한다. 그래서 httpd.conf 파일을 열어서 다음과 같이 주석이 되어 있는 부분을 주석해지를 해줘야한다.

Virtual Host Alias Module 주석 해지

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8b65bb76-d99a-4ad5-8eb9-f70a62a7f120)

Virtual Hosts 설정 파일 주석 해지

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8380a748-d052-4ef1-a50f-3f070f67c6f8)

이제 주석 해지한 httpd-vhosts.conf 파일에 다음을 수정할 것이다.

```
sudo vi /private/etc/apache2/extra/httpd-vhost.conf
```

```
<VirtualHost *:80>
    ServerName cake.saltfactory.local
    DocumentRoot /Projects/Workspaces/PHP/cakephp/app/webroot

<Directory /Projects/Workspaces/PHP/cakephp>
    Options FollowSymLinks
    Options Indexes
    Order allow,deny
    Allow from all
</Directory>

    ErrorLog "/private/var/log/apache2/cake.saltfactory.local-error_log"
    CustomLog "/private/var/log/apache2/cake.saltfactory.local-access_log" common

</VirtualHost>
```

위 설정은 cake.saltfactlry.local 이라는 주소를 브라우저에서 요청하게 되면 자동적으로 CakePHP의 webroot로 접근할 수 있게 해주는 설정이다.
우리는 CakePHP를 /Projects/Workspaces/PHP/cakePHP로 소스를 받아뒀다는 것을 상기해보자.

이젠 cake.saltfactory.loca 이라는 주소를 사용할 수 있게 Mac의 hosts 에 등록을한다.

```
sudo vi /private/etc/hosts
```

```
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1   localhost saltfactory.local
127.0.0.1   localhost cake.saltfactory.local
127.0.0.1   localhost
0.0.0.0     localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0 localhost
```

그리고 apache 서버를 재시작해보자.

```
sudo apachectl restart
```

두둥!!! 엄청난 실망을 했을지 모른다. cakePHP에서 알려주는 에러가 나타나기 때문이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/c1a5e9cb-930b-4177-82f6-6d7b0e00ae5a)

하지만 걱정할 것 없이 처음나온 에러부터 천천히 수정해보도록 하자.

우선 제일먼저 나타난 에러부터 확인하면 CakePHP가 사용하려는 tmp 디렉토리에 권한 문제로 파일 쓰기를 할 수 없어서 생기는 문제이다. 편의상 권한을 777로 변경한다. 실제 서비스를 하는 서버에서는 웹 서버만 접근할 수 있는 권한을 부여해야할 것이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/27120bd3-0086-4d06-a7bf-cf6b6bcd1309)

CakePHP의 경로로 이동한다.

```
cd /Projects/Workspaces/PHP/cakephp
```

app의 tmp 디렉토리 권한을 열어준다.

```
chmod -R 777 app/tmp
```

다음은 cakePHP가 사용하는 보안키에 관련된 설정을 수정하라는 알림을 처리한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/545bbe2d-d2ef-4409-bfc0-ab53d5342efc)

```
vi app/Config/core.php
```

core.php 파일을 열고 Security.salt와 Security.cipherSeed의 값을 아무런 랜던 값으로 대처한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/64b36c1f-6f8a-4ff1-822e-500a0dfddb26)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8e5c6224-469a-42bf-8738-5df2f28e1f75)

다시 cake.saltfactory.local 을 브라우저에 리로드해보자.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/24d10c7c-de32-4cf8-887d-3f6eecd12634)

이제 마지막으로 database를 사용하게 설장하는 것인데 다음과 같이 샘플 데이터베이스파일을 복사해서 수정한다.

```
cp app/Config/database.php.default app/Config/database.php
```

그리고 app/Config/database.php  파일을 열어서 맥의 MySQL 정보를 입력한다.

```php
class DATABASE_CONFIG {

    public $default = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => 'root',
        'password' => '',
        'database' => 'cakephp_production',
        'prefix' => '',
        'encoding' => 'utf8',
    );

    public $test = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => 'root',
        'password' => '',
        'database' => 'cakephp_test',
        'prefix' => '',
        'encoding' => 'utf8',
    );
}
```

그리고 MySQL 에서 CakePHP가 사용할 database를 생성한다.

```
mysql -u root
```
```
create database cakephp_production default character set utf8;
```
```
create database cakephp_test default character set utf8;
```

다시 cake.saltfactory.local 주소를 브라우저에서 새로 고침을 해보자. 아래와 같이 CakePHP가 정상적으로 설치되어진 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/10b5c86f-965b-4e60-b09e-bc2c55d38212)

## 결론

PHP는 웹 서버 설정과 긴말한 관계가 있다. PHP 개발을 하기 위해서는 서버 설정방법에 익숙한 것이 개발에 도움이 많이 될 것이다. 그리고 단순하게 PHP를 웹 사이트를 개발하는 스크립트 언어라고 생각하기보다 웹 어플리케이션을 개발할 때 사용하는 언어이고 CakePHP를 이용해서 MVC 기반 웹 어플리케이션을 만들 수 있다고 생각하고 앞으로 CakePHP에 대한 포스팅을 참조한다면 PHP도 훌륭한 웹 어플리케이션 개발 언어로 자리잡아 갈 것이다. 이번 포스팅은 앞으로 PHP 기반 어플리케이션을 개발하기 위한 준비 단계로 맥에서 CakePHP 개발환경을 구축해서 인터넷이 되지 않는 곳에서도 언제든지 나의 Mac을 개발 웹서버와 데이터베이스 서버로 만들어서 개발할 수 있는 방법을 소개하였다. 다음 포스팅에서는 CakePHP를 이용해서 실제로 간단한 MVC 기반의 어플리케이션을 만드는 방법을 소개할 예정이다.

## 참고
1. http://bakery.cakephp.org/articles/momendo/2006/10/04/installing-cakephp-on-macos-x

