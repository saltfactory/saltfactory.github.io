---
layout: post
title : ubuntu에 GitLab 설치하여 git 호스팅 서비스 구축하기 (ubuntu + gitlab + RVM + Apache + Passenger)
category : git
tags : [git, gitlab, ubuntu, ruby, rvm]
comments : true
redirect_from : /175/
disqus_identifier : http://blog.saltfactory.net/175
---

## 서론

이제 연구소와 개발팀에서 git는 없어서는 안되는 매우 중요한 버전관리 시스템으로 자리잡고 있다. github나 google code 에서 git 호스팅 서비스를 이용하면 되지만 무료로 사용할 경우 저장소(repository)의 공간이 적을 뿐만 아니라 private repository 운영을 하지 못한다는 제한이 있다. 그래서 연구소에서 연구원들에게 git 호스팅 서비스를 할 수 있도록 자체적으로 git 서버를 구축하였다. 올해 초부터 꾸준히 gitorious.org에서 배포하고 있는 오픈소스로 [gitorious](https://gitorious.org/)를 기반 git 호스팅 서비스를 구축하였는데, 커뮤니티가 좀 더 활발하고 국내 유저들이 많은 [gitlab](http://gitlabhq.com/) 기반으로 git 서버를 이전하기로 결심을 했다.

gitorious와 마찬가지로 gitlab은 Ruby on Rails 기반으로 만들어진 것이라 서버측 프로그램을 루비 기반으로 많이 사용하고 있는 연구소의 시스템에 무리 없이 설치가 가능할것 이라고 판단했다. 참고로 gitorious는 마찬가지로 Ruby on Rails 기반이지만 gitlab 보다 설치가 좀 까다로운 편이라고 생각하면된다. gitlab 공식 wiki install에서는 ruby 1.9.2를 시스템에 교체 설치하고 nginx로 서버를 설정하는 문서로 되어 있다. 하지만 우리가 사용하는 시스템은 이미 여러버전의 Ruby 프로그램이 운영되고 있고 RVM을 사용하고 있고 RoR 서비스를 [Passenger](http://www.modrails.com/) 기반으로 서비스하고 있기 때문에 RVM과 Apache2 + Passenger 로 설정하는 방법을 소개하기로 한다.
<!--more-->

## GitLab 요구사항
기본적으로 gitlab을 설치하기 위한 요구사항은 다음과 같다.

- **ubuntu/debian** : 데비안 계열 뿐만 아니라 redhat 계열인 CentOS와 Fedora 에서도 충분히 설치가 가능할 것이고 뿐만아니라 Mac OS X에서도 설치가 가능할 것이다.
- **ruby 1.9.2+ ** : gitlab에서 소개하는 설치 방법에서는 ruby 1.9.2 버전을 시스템 환경으로 설치하지만, 이 포스팅에서는 RVM 으로 ruby 1.9.2-head를 상용했다.
- **MySQL or SQLite** : gitlab은 git 뿐만 아니라 wiki, issue, merge request, wall, comments, notes 등 팀 프로젝트 갭발에 편리한 서비스를 제공하기 위해서 데이터베이스를 사용한다. 그리 큰 연구소가 아니가 프로젝트 단위가 적으면 SQLite로 가볍게 설치할 수도 있을 것 이지만, 우리는 프로젝트도 많고 관리해야하는 데이터가 많을 것으로 대비해서 MySQL 데이터베이스를 선택했다.
- **git** : 당연히 시스템에 git이 설치되어 있어야한다.
- **gitolite** : git 저장소의 중앙 집중 서버의 역활을 하는 것인데 흔히 gitosis와 gitolite를 비교를 많이 한다.
- **redis** : gitlab에서는 key/value 형태의 NoSQL 인 redis를 사용한다.  redis는 현재 github에서도 사용하고 있는 NoSQL이다. gitlab에서는 어떻게 사용하고 있는지에 대해서는 나중에 다시 한번 언급하기로 한다.

설치순서는 gitlabhq 의 wiki 중에서 install for stable version(recommended) 를 그대로 진행하도록 한다. 이 포스팅에서는 변경된 몇가지 변경되어 있기 때문에 원래 설치 메뉴을 문서를 반드시 확인하길 바란다.

우선 ubuntu에서 sudo 권한을 가진 사용자만 root 권한으로 시스템 전체적으로 파일을 생성하거나 관련된 작업을 할 수 있다. 편의상 완전히 root로 변경해서 작업을 해보자.

```
sudo -i
```

##  Install Packages

gitlab을 설치하기 이전에 시스템 라이브러리 패지지를 업데이트하고 업그레이드 한다.

```
apt-get update && upgrade
```

다음은 gitlab에서 필요로 하는 패키지를 설치한다.

```
apt-get install -y wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline6-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev libicu-dev redis-server openssh-server git-core python-dev python-pip libyaml-dev postfix
```

혹시 MySQL이 설치되지 않았다면 MySQL 패키지를 설치한다.

```
apt-get install -y mysql-server mysql-client libmysqlclient-dev
```

## git 계정 생성

git 계정은 gitolite를 이용해서 사용자들의 코드들을 git repository에 저장하고 gitlab에 접근할 수 있는 계정으로 일반 시스템 계정과 달리 로그인을 하지 않는 계정이다. root의 경우 su - 명령어를 이용해서 이 계정으로 변환이 가능하다.

```
adduser \  
--system \  
--shell /bin/sh \  
--gecos 'git version control' \  
--group \  
--disabled-password \  
--home /home/git \  
git
```

## gitlab 계정 생성

gitlab 계정은 gitlab 서비스를 관리하는 계정으로 RoR로 되어 있는 gitlab을 관리하기 위한 계정이다. 그리고 git 그룹에 이 계정을 포함 시킨다.

```
adduser --disabled-login --gecos 'gitlab system' gitlab
```
```
usermod -a -G git gitlab
```

## ssh key 생성

git는 ssh의 public key로 동작하기 때문에 ssh key를 생성한다.

```
sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa
```

## gitolite 소스 복제

gitlab은 gitolite를 이용해서 호스팅 서비스를 하기 때문에 gitolite 를 git를 이용해서 git 계정 디렉토리에 복제한다.

```
cd /home/git && sudo -H -u git git clone git://github.com/gitlabhq/gitolite /home/git/gitolite
```

## 환경설정

git 계정의 홈 디렉토리에 있는 .profile을 파일을 열어서 다음 코드를 추가하고 저장한다. 존재하지 않을 경우 저장하고 파일을 닫는다.

```
sudo -u git -H vi .profile
```

```bash
PATH=$PATH:/home/git/bin
export PATH
```

git 계정의 디렉토리에 복제해 놓은 gitolite의 gl-system-install 명령어를 실행한다

```
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; /home/git/gitolite/src/gl-system-install"
```

gitlab에서 사용할 ssh key 를 복사한다.

```
sudo cp /home/gitlab/.ssh/id_rsa.pub /home/git/gitlab.pub && sudo chmod 0444 /home/git/gitlab.pub
```

gitolite의 설정을 변경한다. 그리고 g-setup -q 를 이용해서 ssh key 사용해서 gitolite를 설정한다.

```
sudo -u git -H sed -i 's/0077/0007/g' /home/git/share/gitolite/conf/example.gitolite.rc
```
```
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gl-setup -q /home/git/gitlab.pub"
```

git를 이용해서 관리할 repository리 저장될 디렉토리의 권한을 설정한다.

```
sudo chmod -R g+rwX /home/git/repositories/
```
```
sudo chown -R git:git /home/git/repositories/
```

이제 다음 명령어로 gitolite를 이용해서 코드를 복제할 수 있는지 테스트를 해본다.

```
sudo -u gitlab -H git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin
```

지금까지의 설정이 바르게 되었다면 다음과 같이 출력 될 것이다.

![](http://cfile23.uf.tistory.com/image/11397E37503C77E712D832)

## gitlab  설치

이제 git 호스팅 서비스를 하기 위해서 gitlab을 설치해보자. gitlab 계정으로 변형하여 진행하겠다.

```
su - gitlab
```

이 포스팅에서는 RVM을 이용해서 gitlab을 운영하기 때문에 RVM으로 Ruby 버전을 변경하고 실행한다.

```
rvm 1.9.2-head
```

gitlab에 필요한 패키지를 gem을 이용해서 설치한다.

```
gem install charlock_holmes --version '0.6.8'
```
```
pip install pygments
```
```
gem install bundler
```

다음은 gitlab 소스를 복제하고 필요한 tmp 디렉토리와 gitalb.yml을 샘플에서 복사를 한다.

```
git clone -b stable git://github.com/gitlabhq/gitlabhq.git gitlab
```
```
cd gitlab && mkdir tmp
```
```
cp config/gitlab.yml.example config/gitlab.yml
```

gitlab에서 사용할 데이터베이스 설정 파일을 복사한다.

```
cp config/database.yml.mysql config/database.yml
```
```
cp config/database.yml.example config/database.yml
```

mysql에 들어가서 gitlab에 필요한 데이터베이스와 계정을 만든다. 데이터베이스 이름은 gitlabhq_production 으로 만든다.

```
mysql -u root -p
```

```sql
CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '비밀번호';
```
```sql
CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
```
```sql
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';
```

그리고 database.yml을 열어서 설정한 것에 맞게 수정을 한다.

```yaml
#
# PRODUCTION
#
production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: gitlabhq_production
  pool: 5
  username: gitlab
  password: 비밀번호
  # socket: /tmp/mysql.sock


#
# Development specific
#
#
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: gitlabhq_development
  pool: 5
  username: gitlab
  password: 비밀번호
  # socket: /tmp/mysql.sock

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test: &test
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: gitlabhq_test
  pool: 5
  username: gitlab
  password: 비밀번호
  # socket: /tmp/mysql.sock

cucumber:
  <<:
```

gitlab에 필요한 gems 을 이용해서 설정되어진 패키지를 설치한다.

```
bundle install --without development test --deployment
```

gems 설치가 마치면 gitlab 어플리케이션에 필요한 셋업을 진행한다. 이 때 필요한 테이블들이 생성된다.

```
bundle exec rake gitlab:app:setup RAILS_ENV=production
```

마지막으로 gitlab이 hook 할 수 있는 설정을 한다.

```
cp /home/gitlab/gitlab/lib/hooks/post-receive /home/git/share/gitolite/hooks/common/post-receive
```
```
chown git:git /home/git/share/gitolite/hooks/common/post-receive
```

## Passenger 설치

Passenger는 Apache에서 RoR 어플리케이션을 운영하게 해주는 모듈이다. 만약 Passenger가 설치되어 있지 않으면 passenger를 먼저 설치한다.

```
rvm 1.9.2-head
```
```
gem install passenger
```
```
rvmsudo passenger-install-apache2-module
```

passegner 모듈 설치과 완료되면 apache2 모듈에 추가를 한다. 아래 내용을 passenger.load 파일에 저장한다.

```
vi /etc/apache2/mods-available/passenger.load
```

```
LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.2-head/gems/passenger-3.0.15/ext/apache2/mod_passenger.so
PassengerRoot /usr/local/rvm/gems/ruby-1.9.2-head/gems/passenger-3.0.15
PassengerRuby /usr/local/rvm/wrappers/ruby-1.9.2-head/ruby
```

추가한 모듈을 apache에 추가한다

```
a2enmod passenger
```

## Apache Vhost 설정

이제 마지막으로 apache의 vhost를 설정한다. 예제 도메인 이름으로 gitlab.saltfactory.net으로 하겠다.

```
vi /etc/apache2/sites-available/gitlab.saltfactory.net
```

```
<VirtualHost *:80>
    <Directory /home/gitlab/gitlab/public>
        AllowOverride All
        Options -MultiViews
    </Directory>

	RackBaseURI /
	RackEnv production

    DocumentRoot /home/gitlab/gitlab/public
    ServerName gitlab.saltfactory.net

	LogLevel warn
	ErrorLog ${APACHE_LOG_DIR}/gitlab.saltfactory.net-error.log
	CustomLog ${APACHE_LOG_DIR}/gitlab.saltfactory.net-access.log combined

    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript text/css application/x-javascript
    BrowserMatch ^Mozilla/4 gzip-only-text/html
    BrowserMatch ^Mozilla/4\.0[678] no-gzip
    BrowserMatch \bMSIE !no-gzip !gzip-only-text/html

    # Far future expires date
    <FilesMatch "\.(ico|pdf|flv|jpg|jpeg|png|gif|js|css|swf)$">
        ExpiresActive On
        ExpiresDefault "access plus 1 year"
    </FilesMatch>

    # No Etags
    FileETag None

    RewriteEngine On

    # Check for maintenance file and redirect all requests
    RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
    RewriteCond %{SCRIPT_FILENAME} !maintenance.html
    RewriteRule ^.*$ /system/maintenance.html [L]
</VirtualHost>
```

apache vhost 설정을 마치고나면 apache2에 설정한 vhost 정보를 추가한다.

```
a2ensite gitlab.saltfactory.net
```

이제 apache2를 재시작하면 gitlab.saltfactory.net(예제 도메인으로 실제 도메인으로 접근해보길 바란다.) 으로 접근하면 gitlab 을 사용할 수 있게 된다.

![](http://cfile6.uf.tistory.com/image/1358604D503C8B420251F5)

![](http://cfile25.uf.tistory.com/image/161A8B49503C8B54085350)

## 참고

1. https://github.com/gitlabhq/gitlabhq/blob/stable/doc/installation.md

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
