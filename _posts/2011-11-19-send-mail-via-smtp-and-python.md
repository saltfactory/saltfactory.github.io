---
layout: post
title: Python으로 SMTP을 이용하여 메일발송 하기
category: python
tags: [python, smtp, mail]
comments: true
redirect_from: /75/
disqus_identifier : http://blog.saltfactory.net/75
---

## 서론

Python은 프로그램을 매우 간결하게 만들어주고 시스템 프로그래밍을 위한 라이브러리들이 많이 지원되기 때문에 서버 프로그램을 만들때 python을 많이 이용한다. 이번 포스팅은 python으로 프로그램을 만들때 메일발송하는 기능이 필요해서 smtp로 메일을 발송하는 방법을 소개한다. 우선 smtp로 메일을 발송하기 위해서는 당연한 이야기지만 smtp 서버가 필요하다.  요즘은 포털에서 smtp를 이용할 수 있게 열어주고 있기 때문에 smtp를 직접 운영하지 안하지 않고 포털 smtp를 사용하기도 한다. (google, naver, daum 등 smtp를 이용할 수 있다.) 이렇게 smtp로 메일을 발송하는 서비스가 오픈되어 있는 만큼 smtp로 메일 발송하는 서비스를 만들기가 쉬워졌다. 다음 python 코드를 다양하게 변경해서 메일 서비스를 만들 수 있을거라 기대한다.
<--more-->

메일 프로그램을 만들기전에 SMTP 프로토콜의 간단한 이해가 필요하다.  SMTP(Simple Mail Transfer Protocol)은 최초 RFC 821 문서로 정의되었고, 이후 RFC 5321에 업데이트 되었다. SMTP는 기본적으로 port 25번을 이용하는데 google, naver, daum 등 보안 문제로 25번 포트번호를 사용하지 않고 각각 자신만의 포트번호로 변경하여 사용하고 있기 있기 때문에 SMTP 포트 번호가 무엇인지 반드시 숙지 해야한다. 아래는 SMTP를 보내기 위해서 SMTP 을 발송할때 필요 정보를 나타낸 것이다.(wikipedia 참조). 더 자세한 내용은 RFC문서를 확인해서 프로그램으로 만들수 있으며 간단하게 From:, To:, Cc:, Date:, Subject: 등을 가지는 것을 확인할 수 있다. python에서는 이런 헤더정보를 MIME 으로 간단하게 구현할 수 있다.

```
S: 220 smtp.example.com ESMTP Postfix
C: HELO relay.example.org
S: 250 Hello relay.example.org, I am glad to meet you
C: MAIL FROM:<bob@example.org>
S: 250 Ok
C: RCPT TO:<alice@example.com>
S: 250 Ok
C: RCPT TO:<theboss@example.com>
S: 250 Ok
C: DATA
S: 354 End data with <CR><LF>.<CR><LF>
C: From: "Bob Example" <bob@example.org>
C: To: "Alice Example" <alice@example.com>
C: Cc: theboss@example.com
C: Date: Tue, 15 Jan 2008 16:02:43 -0500
C: Subject: Test message
C:
C: Hello Alice.
C: This is a test message with 5 header fields and 4 lines in the message body.
C: Your friend,
C: Bob
C: .
S: 250 Ok: queued as 12345
C: QUIT
S: 221 Bye
{The server closes the connection}
```

python에서 한글을 사용하거나 UTF-8로 코드를 만들기 위해서는 다음과 같은 코딩 캐릭터를 지정해줘야한다.

```python
# -*- coding:utf-8 -*-
```

python에서 smtp를 사용하기 위해서는 smtplib 모듈을 임포트해야한다. 그리고 email에 관련된 MIME 설정을 하기위해서 email 모듈을 임포트해야한다. 파일 업로드를 위해서 os 라이브러리를 사용하기 위해서 os 모듈도 임포트해야한다.

위에서 SMTP 로 메일을 보내기 위해서 MIMEMultipart()를 사용하면 복잡하게 구현해야하는 헤더를 간단하게 구현할 수있다.
Cc는 참조자를 의미하는데 수신자가 여러명일 때 동시 참조자로 사용하는 것이다. (Bcc라고 숨은 참조자도 사용할 수 있다)
Cc는 여러명의 수신정보를 가지기 때무에 ","로 구분해서 설정해줘야한다. python에서는 join이라는 메소드를 사용해서 list에 들어있는 데이터를 특정 문자로 서로 붙여주는 기능을 제공하는데 join을 사용하면 list로 넘어오는 수신자 목록을 ","로 붙여서 만들어주는 것을 간단히 만들수 있다.

```python
cc_users = ["saltfactory@gmail.com", "sksong@hibrain.net"]
msg["Cc"] = ", ".join(cc_users)
```

Date라는 속성은 google의 SMTP를 사용할때는 없어도 되는 속성이였는데, 개인적으로 SMTP를 사용하려고 하다보니 이 속성이 없으니까 메일이 발송하지 않았었다. 대부분 python의 smtplib로 메일을 발송하는 예제를 보면 gmail을 SMTP 서버로 하는 예제가 많기 때문에 이 속성을 사용하지 않는데 사설 SMTP를 사용하여 발송하려면 반드시 필요한 속성이라는 것을 알아두자. 그런데 이 시간또한 그냥 date.now()로 구하게 되면 로케일정보로 전송되는 것이아니라 UTC 타임으로 전송되어서 우리나라 시간과 9시간의 차이가 나서 발송이 된다. 그래서 다음과 같이 emal의 Utils.formatdate의 localetime을 이용해서 시간을 구하도록 한다.

```python
msg["Date"] = Utils.formatdate(localetime=1)
```

그리고 또 하나 고민했던 것이 한글 제목과 한글 내용등 한글을 어떻게 캐릭터 설정을 하냐는 것이였다. 이 문제도 google SMTP를 사용하는 인터넷의 대부분의 예제를 살펴보면 빠져있다. 그렇지만 사설 SMTP를 사용하다보면 캐릭터 설정이 맞지 않아서 gmail에서는 잘 수신되던 한글 제목과 한글내용이 사설 SMTP로 발송하면 한글이 깨어져서 나와서 당황하게 될 것이다.
제목의 한글을 설정하기 위해서는 utf-8로 인코딩하여 작성해서 발송하기 때문에 Header에 charset을 utf-8로 지정하는 부분이 필요한다.

```python
msg["Subject"] = Header(s=subject, charset="utf-8")
```

그리고 내용의 charset을 지정하기 위해서는 다음과 같이 한다. 준비한 예제는 내용의 타입이 HTML이라고 생각하고 만들었다. 메일을 HTML형태로 보내기 위해서는 MIMEMultipart에 HTML을 attach하는 방법으로 구현한다.

```python
msg.attach(MIMEText(text, "html", _charset="utf-8"))
```

메일에 파일을 첨부하기 위해서는 MIMEBase를 이용하여 MIMEMultipart에 attach 한다. 이때 MIMEBase는 octet-stream의 application으로 만드는데 파이을 열어서 payload로 저장하고 base64로 인코딩한다.

```python
part = MIMEBase("application", "octet-stream")
part.set_payload(open(file_path, "rb").read())
part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(file_path))
msg.attach(part)
```

마지막으로 smtplib를 이용해서 smtp 연결 설정을 하는데 이때 서버주소, 포트, 아이디, 비밀번호가 필요하고 로그인 방법이 필요한다.
그리고 MIMEMultipart에 여러가지 속성을 설정한 메세지를 수신자에게 전달한다. 여기서 또 한가지 주의해야할 것이 Cc 속성을 지정한다고 참조자에게 모두 메일이 날아가지 않는다는 것이다. gmail에서는 Cc 설정을하면 공동참조자에게 모두 메일이 날아가지만 개인적으로 SMTP를 운용한다면 Cc 속성만 추가해도 from_user에게만 메일이 발송되고 메일의 공동참조자 표시에만 Cc 목록이 나타난다. 실제 메일을 발송할때는 Cc 사용자 list를 가지고 보내야한다는 것이다. 그리고 SMTP 헤더와 함께 메일을 발송한다.

```
smtp = smtplib.SMTP(smtp서버, 포트번호)
smtp = login (아이디, 비밀번호)
smtp.sendmail(발신자, cc_users(공동수신자), msg.as_string())
smtp.close()
```

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

smtp_server  = "smtp 서버"
port = smtp 포트번호
userid = "smtp 접속 아이디"
passwd = "smtp 비밀번호"

def send_mail(from_user, to_user, cc_users, subject, text, attach):
        COMMASPACE = ", "
        msg = MIMEMultipart("alternative")
        msg["From"] = from_user
        msg["To"] = to_user
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
```

사용방법은 다음과 같이 한다. 발신자가 from@test.net 이라고하고 수신자가 to@test.net이고 공동 수신자가 to2@test.net, to3@test.net 이고 /test/test.txt 파일을 전송한다라고 할때 다음과 같이 한다.

```python
send_mail("from@test.net", "to@test.net", ["to@test.net", "to2@test.net", "to3@test.net"], "제목", "내용",  "/test/test.txt")
```

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
