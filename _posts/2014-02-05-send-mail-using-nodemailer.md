---
layout: post
title: Nodemailer를 이용하여 node.js에서 메일 보내기
category: node
tags: [node, node-mailer, mail, javascript]
comments: true
redirect_from: /223/
disqus_identifier : http://blog.saltfactory.net/223
---

## 서론

![](http://asset.hibrainapps.net/saltfactory/images/aac62155-cca3-4156-94c5-c3c0e4412b75)

푸시서버를 Springframework에서 Node.js로 변경하는 사내 프로젝트에서 메일 발송 프로그램이 필요하게 되었다. 푸시 전송 후 정상적으로 발송되었는지 리포팅을 메일로 발송해주었는데 기존에는 javamail을 사용했다. Node.js로 시스템을 새롭게 구축하면서 새로운 메일 발송 프로그램이 필요했고 Nodemailer로 메일 발송을 하게 되어 간단한 사용 방법을 포스팅한다.

우리는 사내 메일 서버가 있지만 부설연구소 개발 테스트용으로 gmail을 사용하고 있는데 간단하게 gmail로 메일을 발송하는 모듈을 찾고 있었다. 그런점에서 Nodemailer는 우리가 찾는 모듈로 적합하다고 판단했고 사용법도 간단해서 메일발송 자체 모듈을 만들고 Nodemailer로 발송을 시키도록 했다.

<!--more-->

### Nodemailer 설치

우선 Nodemailer를 설치한다. 간단하게 npm 으로 설치할 수 있다.

```
npm install nodemailer
```

### 텍스트 메일 발송

메일발송은 gmail의 SMTP 서버를 이용해서 메일을 발송하도록 한다.

```javascript
var nodemailer = require('nodemailer');

var smtpTransport = nodemailer.createTransport("SMTP", {
	service: 'Gmail',
	auth: {
		user: '구글메일 아이디',
		pass: '구글메일 비밀번호'
	}
});

var mailOptions = {
	from: '송성광 <saltfactory@gmail.com>',
	to: 'saltfactory@gmail.com',
	subject: 'Nodemailer 테스트',
	text: '평문 보내기 테스트 '
};

smtpTransport.sendMail(mailOptions, function(error, response){

	if (error){
		console.log(error);
	} else {
		console.log("Message sent : " + response.message);
	}
	smtpTransport.close();
});
```

메일을 발송해 보자.

```
node sf_mail.js
```

![](http://asset.hibrainapps.net/saltfactory/images/f0cafaf6-0ba9-4c71-852a-8cd9d605af4b)

메일이 정상적으로 발송하면 response를 받을 수 있고 이것을 callback으로 처리할 수 있다. 그리고 메일은 정상적으로 발송 되었는지 확인해보자.

![](http://asset.hibrainapps.net/saltfactory/images/9da33f55-0d26-4ebc-a9aa-9a4942c42bf0)

메일함을 살펴보면 한글이 포함된 메일이 정상적으로 발송 되어진것을 확인할 수 있다.

### HTML 내용 메일 발송

요즘은 텍스트로 이루어진 평문 메일보다 HTML으로 작성된 메일을 많이 사용한다. HTML 메일의 발송을 하기 위해서 다음과 같이 코드를 수정한다.

```javascript
var nodemailer = require('nodemailer');

var smtpTransport = nodemailer.createTransport("SMTP", {
	service: 'Gmail',
	auth: {
		user: '구글메일 아이디',
		pass: '구글메일 비밀번호'
	}
});

var mailOptions = {
	from: '송성광 <saltfactory@gmail.com>',
	to: 'saltfactory@gmail.com',
	subject: 'Nodemailer 테스트',
	// text: '평문 보내기 테스트 '
	html:'<h1>HTML 보내기 테스트</h1><p><img src="http://www.nodemailer.com/img/logo.png"/></p>'
};

smtpTransport.sendMail(mailOptions, function(error, response){

	if (error){
		console.log(error);
	} else {
		console.log("Message sent : " + response.message);
	}
	smtpTransport.close();
});
```

HTML을 발송하기 위해서는 mailOptions에서 text 대신 html 프로퍼티에 html 코드를 입력하면 된다. 발송된 메일을 확인해보자. HTML 코드가 적용된 메일이 정상적으로 전송된 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/755dc39a-7af6-40ab-bb58-c982277993c4)

### 파일첨부

우리는 리포팅하는 메일을 자동적으로 발송하게 하면서 로그 파일을 메일로 보내길 원했다. Nodemailer는 메일 첨부까지 매우 간편하게 할 수 있게 만들어져 있다. 메일에 파일을 추가하기 위해서는 다음과 같이 코드를 수정한다.

```javascript
ar nodemailer = require('nodemailer');
var fs = require('fs');

var smtpTransport = nodemailer.createTransport("SMTP", {
	service: 'Gmail',
	auth: {
		user: '구글메일 아이디',
		pass: '구글메일 비밀번호'
	}
});

var mailOptions = {
	from: '송성광 <saltfactory@gmail.com>',
	to: 'saltfactory@gmail.com',
	subject: 'Nodemailer 테스트',
	// text: '평문 보내기 테스트 ',
	html:'<h1>HTML 보내기 테스트</h1><p><img src="http://www.nodemailer.com/img/logo.png"/></p>',
	attachments:[
		{
			fileName: 'test.log',
			streamSource: fs.createReadStream('./test.log')
		}
	]
};

smtpTransport.sendMail(mailOptions, function(error, response){

	if (error){
		console.log(error);
	} else {
		console.log("Message sent : " + response.message);
	}
	smtpTransport.close();
});
```

테스트를 위해 간단한 로그 파일을 test.log 같은 경로에 만들었다.

![](http://asset.hibrainapps.net/saltfactory/images/2e58c83a-12ec-42b5-8cbf-0730420fd964)

메일을 발송한 후 확인해보자. 메일을 확인하면 파일이 정상적으로 첨부되어 발송 되었다는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/9fec66ac-eed3-4f10-9cdf-2de8e29387f4)

파일은 손상없이 정상적으로 전송되었는지 확인하기 위해서 첨부파일을 다운받아서 열어보자.

![](http://asset.hibrainapps.net/saltfactory/images/e2eca74a-e026-4309-a66e-d34f0e7bae5c)

## 결론

Node.js 는 엑티브한 개발자들이 필요한 모듈을 계속적으로 개발하고 업데이트를 진행하고 있다. 이미 고수준의 안정화된 모듈들이 많이 개발되어 있기 때문에 우리는 Node.js로 개발하면 많은 코드를 줄일 수 있고 개발 생산성을 향상 시킬 수 있다. Node.js는 아직 정식 version 1.0 로 릴리즈 되지 않았지만 수많은 모듈들이 있다. Node.js는 앞으로도 많은 모듈들이 만들어질 것이고 더욱 안정화 될 것으로 전망된다. Nodemailer는 SMTP를 사용해서 메일을 간단하게 발송 할 수 있게 도와준다. 뿐만 아니라 파일 첨부도 가능하다. Nodemailer 사이트에가서 메뉴얼을 보면 더욱더 다양한 옵션으로 여러가지 기능을 상용할 수 있을 것이다.

## 참고

1. http://www.nodemailer.com
2. https://github.com/andris9/Nodemailer

