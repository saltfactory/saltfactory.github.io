---
layout: post
title : Ubuntu에서 Postfix와 Gmail SMTP를 사용하여 메일 보내기
category : ubuntu
tags : [ubuntu, postfix, mail, gmail, mailx, relay]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/522?size=full
---

## 서론

리눅스 서버를 운영하다보면 메일을 발송해야할 경우가 있다. 시스템의 로그나 다양한 리포트를 메일로 발송해야할 경우가 종종 생기는데 메일 서버를 구축하는 것은 만만치 않은 비용이 발생한다.
Ubuntu는 멋진 리눅스 운영체제이다. 사용자로 하여금 필요한 것을 쉽게 서비스할 수 있게 다양한 패키지를 사용할 수 있기 때문이다. 그리고 Gmail은 여러가지 서비스에 Gmail SMTP를 사용할 수 있는 방법을 제공하고 있다. 이 글에서는 Ubuntu의 **Postfix**라는 패키지를 사용하여 **Gmail SMTP**로 메일을 발송하는 방법에 대해서 소개한다.
<!--more-->

## Postfix

[Postfix](http://www.postfix.org/)는 [IBM Public License](https://en.wikipedia.org/wiki/IBM_Public_License) 오픈소스 MTA(mail transfer agent)이다. 이것은 **QMail**과 함께 **sendmail**을 대처하는 서비스로 많이 사용되고 있다. 이것은 예전에 **Vmailer** 과 **IBM Secure Mailer**로 알려져있다. postfix의 가장 큰 장점은 [SASL(Simple Authentication and Security Layer)](https://tools.ietf.org/html/rfc2222)를 이용한 **SMTP**인증을 지원하기 때문에 복잡한 relay를 설정하지 않고 **spam relay** 사용을 막을 수 있는 것이다. 이러한 이유로 postfix를 설치할 때 **libsasl** 라이브러리를 함께 설치해야한다.

## Postfix 설치

Ubuntu 서버에서 **Postfix**를 설치해보자. Ubuntu에서는 간단하게 **mailutils**만 설치하면 된다. 이 패키지의 의존성 패키지에서 **postfix**와 **libsasl** 모듈이 포함되어 있기 때문에 한번에 설치가 가능하다.

```
sudo apt-get install mailutils ca-certificates
```

만약 의존성 문제가 발생한다면 다음과 같이 설치하면 된다.

```
sudo apt-get install mailutils libsasl2-2 ca-certificates libsasls-modules postfix
```

## main.cf에 설정 추가

**Postfix**의 설정 파일은 **/etc/postfix/main.cf** 에 존재한다. 이 파일을 열어서 **gmail**을 사용하여 relay를 할 수 있도록 다음과 같이 파일을 변경한다.

- **replayhost** : relay를 하게될 SMTP 서버를 추가한다.
- **smtp_sasl_auth_enable** : SMTP의 **SASL** 인증 여부를 설정한다.
- **smtp_sasl_password_maps** : SMTP 비밀번호를 설정한다.
- **smtp_sasl_security_options** : 인증 옵션을 설정한다. **noanonymous**로 설정하면 익명사용자가 접근할 수 없다.
- **smtp_use_tls** : SMTP 보안 프로토콜을 TLS로 사용하는지 여부를 설정한다.
- **smtp_tls_CAfile** : SMTP TLS에 사용할 Certificates 파일을 지정한다.

```bash
# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = demopostfix
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = /etc/mailname, demopostfix, localhost.localdomain, localhost
#relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all

### Gmail SMTP 설정 추가

relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_use_tls = yes
smtp_tls_CAfile = /etc/postfix/cacert.pem
```

## Gmail 계정 설정

위에서 **smtp_sasl_password_maps**으로 지정한 파일에 **gmail** 계정의 비밀번호를 저장한다.
```
vi /etc/postfix/sasl_passwd
```
```
[smtp.gmail.com]:587  Gmail계정@gmail.com:Gmail비밀번호
```

예를들어 saltfactory@gmail.com 계정의 비밀번호가 testpasswd 라면 다음과 같이 파일을 저장한다.

```
[smtp.gmail.com]:587  saltfactory@gmail.com:testpasswd
```

**sasl_passwd** 파일을 저장한 다음 파일 권한을 변경한다.

```
sudo chmod 400 /etc/postfix/sasl_passwd
```

권한을 설정한 후에 postfix map설정을 업데이트한다.

```
sudo postmap /etc/postfix/sasl_passwd
```

## TLS 설정

다음은 **TLS**를 위해 서버의 **Certifcates** 파일을 지정한 곳에 복사한다.

```
cp /etc/ssl/certs/Thawte_Premium_Server_CA.pem /etc/postfix/cacert.pem
```

이젠 모든 설정이 끝났다.

## Gmail relay 테스트

**Postfix** 설정이 모두 끝났으면 메일을 발송을 테스트해보자. 터미널에 다음과 같이 실행한다. 메일은 saltfactory@gmail.com 으로 발송했다.

```
echo "Postfix를 사용하여 gmail로 메일 보내기" | mailx -s "Postfix 테스트" -a "From:SungKwang Song<saltfactory@gmail.com>"  saltfactory@gmail.com
```

메일이 정상적으로 발송이 되면 Gmail로 메일이 도착하는 것을 확인할 수 있다.

![gmail 발송 테스트](http://assets.hibrainapps.net/images/rest/data/523?size=full&m=1436837141)


## 결론

**Ubuntu** 운영체제는 현재 국내에서 가장 인기있는 리눅스 운영체제이다. 서버를 운영하다보면 메일 발송을 위해 **SMTP**서버를 직접 구축해야하는 상황이 생기는데 **Postfix**를 사용하여 **Gmail SMTP**를  쉽게 활용할 수 있다. Postfix는 **SASL**을 사용하여 스팸릴레이에 비교적 안전하기 때문에 운영하는데 사용하는데 큰 무리가 없을 것으로 예상된다. 어플리케이션에서 메일을 발송하거나 로그를 담당자에게 리포팅을할 때 메일을 활용하면 매우 효율적으로 시스템을 관리할 수 있을 것이다. 이 모든 것을 Postfix를 사용하여 간단하게 처리할 수 있을 것이다.


## 실습

**docker** 를 사용하여 이 내용을 실습할 수 있다.

- https://github.com/saltfactory/docker-ubuntu-tutorial/tree/master/postfix-gmail

## 참고

1. http://www.postfix.org/
2. https://rtcamp.com/tutorials/linux/ubuntu-postfix-gmail-smtp/


## 연구원 소개

* 작성자 : [송성광](http://saltfactory.net/profile) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
