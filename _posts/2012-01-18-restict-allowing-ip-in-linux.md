---
layout: post
title: Linux에서 접근 가능한 IP 제한과 리포팅하기
category: linux
tags: [linux, ip, python]
comments: true
redirect_from: /95/
disqus_identifier : http://blog.saltfactory.net/95
---

## 서론

서버관리자는 서버를 매일 모니터링을 해야한다는 것이 서버관리자의 가장 큰 의무 중에 하나라고 생각된다. 서비스의 정도와 다르게 비록 개발 서버라고 할지라도 서버라는 것이 존재한다는 것은 언제나 공격의 대상이되고 내가 직접적으로 나쁜 의도로 사용하지 않아도 다른 서비스에 공격할 수 있는 통로가 되기도 한다. 그래서 서버를 운영한다는 것은 사실은 큰 부담감을 가지고 있는 것이다. 그래서 가장 간단하면서도 강력한 보안 정책이 있는데 간단하게 설명하자면 특정 서비스에 특정 호스트만 접근하게 하거나 막을수 있는 TCP Wrapped Service라는 것이 있다. TCP Wrapper라고 검색하면 사용하는 방법들이 많이 검색이 될 것이기 때문에 간단하게 사용하는 방법에 대해서 설명을 하고자 한다. 이 포스트는 TCP Wrapper 를 사용하면서 자동적으로 리포팅 기능을 할 수 있게 하는 것이 목적이기 때문에 [TCP Wrapper](http://en.wikipedia.org/wiki/TCP_Wrapper)에 대한 보다 깊은 내용은 다른 블로그나 문서를 참조하길 바란다.

<!--more-->

## TCP Wrapper

TCP Wrapper의 기능은 간단히 특정 host의 접근을 허락하거나 거절하는 기능이다.
이 설정은 통상 /etc/hosts.allow와 /etc/hosts.deny 파일 두가지에서 설정이 가능하다. 파일 이름을 보면 그 기능을 알 수 있을텐데 hosts.allow는 접속을 허락하는 서비스별 host를 정의할 수 있고 hosts.deny는 접근을 거부하는 서비스별 host를 정의할 수 있다. 이때 접근의 방법을 정의하는 룰은 다음과 같다.

```
데몬 : 호스트명(IP) [:옵션1:옵션2:...]
```

예를 들어서 특정 아이피 111.111.111.111이라는 IP를 가진 호스트가 무작위로 ssh 접근을 한다고 가정하면 hosts.deny 파일에 다음과 같이 설정하면 된다.

```
sshd : 111.111.111.111
```

매우 간단하지만 한가지 더 예를 들어 보자. 모든 호스트의 접근은 막는데 내가 개발하고 있는 호스트 123.123.123.111과 123.123.123.222만 서버에 접근하게 하고 싶을 경우에 다음과 같이 설정하면 된다.

```
# hosts.deny
ALL : ALL
```

```
# hosts.allow
ALL : 123.123.123.111, 123.123.123.222
```

이렇게 간단하게 서버에 접근할 할수 있는 호스트를 제한할 수 있다. 이제 좀더 스마트하게 리포트 기능을 추가해 보자.
내가 만약에 접근할 수 있는 클라이언트를 정했는데 알수 없는 클라이언트에서 계속적으로 서버로 접근하려는 시도를 감지하기 위해서 이렇게 접근을 허락하지 않는 알수 없는 클라이언트가 접근하려면 관리자에게 메일을 발송 시키도록 하는 기능을 추가해보자.


## 메일 리포팅 기능 추가

메일 발송 프로그램은 Python으로 SMTP을 이용하여 메일발송 (파일첨부, 공동참조자 포함) 포스트에 사용한 python으로 작성한 메일 발송 프로그램을 사용하였다. 꼭 python 메일 발송 프로그램이 아니라 자신의 서버에 맞는 메일 발송 프로그램을 사용하면 된다. 개인적으로는 서버 관리 프로그램은 python이나 ruby를 사용하기 때문에 이 포스팅에서는 python을 이용하는 방법을 설명한다.

python 메일 발송 프로그램은 외부에서 arguments를 받아서 그 문장을 현재 시간과 결합해서 리포트 메세지를 만들어서 서버 관리자나 리포터에게 메일을 발송한는 간단한 프로그램이다. `sendmail_unkwnown_ip.py` 라는 파일을 root만 접근할 수 있는 디록토리에 만들었다고 가정한다.

```python

#!/usr/bin/python
# -*- coding:utf-8 -*-

import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders
from email import Utils
from email.header import Header
import os
import sys
import time

smtp_server  = "SMTP 서버 주소"
port = "SMTP 포트번호"
userid = "SMTP 계정"
passwd = "SMTP 비밀번호"

def send_mail(from_user, to_user, cc_users, subject, text, attach):
        COMMASPACE = ", "
        msg = MIMEMultipart("alternative")
        msg["From"] = from_user
        msg["To"] = COMMASPACE.join(to_user)
        msg["Cc"] = COMMASPACE.join(cc_users)
        msg["Subject"] = Header(s=subject, charset="utf-8")
        msg["Date"] = Utils.formatdate(localtime = 1)
        msg.attach(MIMEText(text, "html", _charset="utf-8"))

        if (attach != None):
                part = MIMEBase("application", "octet-stream")
                part.set_payload(open(attach, "rb").read())
                Encoders.encode_base64(part)
                part.add_header("Content-Disposition", "attachment; filename=\"%s\"" % os.path.basename(attach))
                msg.attach(part)

        smtp = smtplib.SMTP(smtp_server, port)
        smtp.login(userid, passwd)
        smtp.sendmail(from_user, cc_users, msg.as_string())
        smtp.close()

now = time.localtime()
now = "%04d-%02d-%02d %02d:%02d:%02d" % (now.tm_year, now.tm_mon, now.tm_mday,

now.tm_hour, now.tm_min, now.tm_sec)

message = "<h2>알수 없는 IP 접근</h2> [%s] from  <font color='red'>%s</font> " % (now, sys.argv[1])
send_mail("발송 이메일주소", ["수신자 이메일주소"], ["공동참조자 이메일주소"], "알수 없는 IP 접근 리포트", message,  None)

```

이 python 이메일 전송 프로그램은 외부에서 파라미터를 하나 받도록 만들었다. `sys.argv[1]`은 알수 없는 호스트가 접근할때의 IP를 받아오는 argument 가 될 것이다. 다음은 shell이 이 프로그램을 실행할 수 있도록 실행 권한을 파일에게 추가 한다.

```
chmod +x /root/sendmail_unknown_ip.py
```

host의 접근 권한을 hosts.allow와 hosts.deny에서 룰을 설정해서 관리할 수 있는데 `hosts.allow` 파일을 열어서 다음 문장을 추가한다.

```
ALL : UNKNOWN : spawn /root/sendmail_unknown_ip.py %h : deny
```

모든 서버에서 알수 없는(UNKNOWN) 호스트가 접근하면 spawn을 사용해서 위에서 만든 `sendmail_unkown_ip.py`을 실행하는데 이 때 파라미터로 접근한 호스트의 IP를 넘기게 된다. 그러면 python 메일 전송 프로그램이 리포트할 message를 완성시켜 관리자에게 메일을 전송하는 것이다.

`spawn`은 자식 프로세스를 하나 생성시켜서 새로운 쉘 명령어(shell command)를 할 수 있게 해주는 옵션이다.

이제 TCP Wrapper에 정의한 허락된 호스트 접근 이외의 알수 없는 호스트가 서버에 접근을 하게 되면 다음과 같이 즉시 메일로 접근한 사항을 메일로 확인 받을 수 있게 되었다.

![](http://cfile25.uf.tistory.com/image/1813B0424F16561B1A42B1)

하지만 이렇게 TCP Wrapper 기능을 사용하고 알수없는 호스트의 접근 사항을 메일로 확인 할 수 있더라도, 반드시 서버 관리자는 서버의 로그 파일을 주기적으로 모니터링하고 분석하는 일을 해야한다. 어떠한 사항으로 장애가 일어날지 모르며 어떻게 다른 경로로 접근해서 서버를 다른 용도로 사용할지 모르기 때문이다.


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
