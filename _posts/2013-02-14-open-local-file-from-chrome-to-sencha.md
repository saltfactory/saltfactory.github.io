---
layout: post
title: 크롬 브라우저에서 로컬 file경로 Sencah Application을 실행하기
category: sencha
tags: [sencha, chrome, javascript]
comments: true
redirect_from: /212/
disqus_identifier : http://blog.saltfactory.net/212
---

Sencha Application은 web application을 개발하는 프레임워크라는 사실을 이젠 많은 개발자들이 알고 센차터치의 잠재력을 높이 평가하고 있다. 이러한 sencha application을 실행하기 위해서는 간단하게 html 파일과 javascript, css 파일만 있으면 브라우저에서 원격지에 파일을 업로드하지 않고 실행하면서 개발을 할 수 있다. 오페라 브라우저도 webkit engine을 포용하는 지금 시점에서 웹 어플리케이션은 webkit insepector로 개발하는 것이 이젠 거의 표준인 것으로 생각하기 때문에 chrome browser로 개발을 하는 사람들이 많아졌다.

<!--more-->

sencha touch 테스트를 위해서 다음과 같이 간단히 sencha touch application을 sencha command로 만들어보겠다.

```
cd $SENCHA_HOME
```

```
sencha generate app TestApp ../TestApp
```

![](http://cfile24.uf.tistory.com/image/16369543511CE478136FFA)

이젠 테스트로 만든 Sencha Projects 디렉토리에서 index.html 파일을 chrome에서 열어보자.

```
cd ../TestApp
```

```
open -a "Google Chrome" index.html
```

![](http://cfile30.uf.tistory.com/image/154D7144511CE5410F116E)

chrome 브라우저가 열리면서 다음과 같이 Cross origin requests are only supported for HTTP 에러를 발생하면서 Sencha Application이 실행이 되지 않는다. Safari 브라우저로 열어보자

```
open -a "Safari" index.html
```

![](http://cfile2.uf.tistory.com/image/121DDB42511CE5AC1FB5F1)

Safari 브라우저에서는 문제 없이 실행이 되는 것을 확인할 수 있다. 위와 같은 문제는 Chrome 브라우저에서 file 경로로 브라우저에서 열게되었을때 access file policy 제한으로 발생하는 문제이다. 그래서 Chrome 브라우저를 실행할 때 다음과 같이 옵션을 추가한다.

```
--args --allow-file-access-from-files
```

열려 있는 Chrome 프로세스를 완전히 종료를 한다. (만약 프로세스가 완벽하게 중지되지 않으면 오션을 추가해도 반영이 되지 않는다는 오류 메세지를 보게 될 것이다.) 그리고 옵션을 추가해서 Chrome을 열어보자.

```
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --allow-file-access-from-files index.html
```

![](http://cfile21.uf.tistory.com/image/17318043511CE72C25884C)

![](http://cfile4.uf.tistory.com/image/2715A03A511CE7350678E4)

이렇게 Chrome 브라우저를 열때 file access policy 제한을 풀어서 index.html을 실행하면 앞에서 봤던 문제 없이 Sencha Application을 Chrome에서 file 경로로 실행할 수 있게 된다.

## 참고

1. http://stackoverflow.com/questions/14776281/chrome-disable-web-security-cant-open-file

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
