---
layout: post
title: 개발용 PC와 운영체제 인코딩 설정 따른 톰캣 WAR 파일 한글 문제 해결
category: Java
tags: [java, jvm, tomcat, character, utf-8, war]
comments: true
redirect_from : /269/
disqus_identifier : http://blog.saltfactory.net/269
---

## 서론

Java를 이용하여 웹 프로젝트를 진행하면서 한번쯤은 캐릭터 문제를 겪게 된다. 이것은 프로그램을 작성할 때 한글(EUC_KR)을 함께 사용하기 때문이다. 내 PC에서 개발할 때는 문제가 없는데 특정 서버에 Deploy를 시키면 파일 안에 **한글 주석**이 이상한 문자열로 깨어지거나 HTTP 요청을 할 때 한글이 제대로 표현되지 않는 문제 등을 만날 수 있다. 이번 포스팅은 Java 프로그램을 작성해서 Tomcat 서버에 Deploy를 시키고 난 이후 war 파일이 풀렸을 때 war 안에 들어 있던 파일 속의 한글이 깨어지는 문제를 해결하는 방법을 소개한다.

<!--more-->

## 개발 PC 환경

최근 웹 개발은 Mac을 이용하거나 Ubuntu와 같은 리눅스 데스크탑 환경을 많이 사용한다. Mac과 Ubuntu는 특별한 설정을 하지 않으면 기본적으로 UTF-8 환경을 가진다. `locale` 명령어를 사용해서 내 컴퓨터의 설정을 확인해 볼 수 있다.

```
locale
```

```
LANG=
LC_COLLATE="C"
LC_CTYPE="UTF-8"
LC_MESSAGES="C"
LC_MONETARY="C"
LC_NUMERIC="C"
LC_TIME="C"
LC_ALL=
```
이렇게 UTF-8 로 사용되고 있는 Mac에서 IntelliJ 와 같은 응용 프로그램을 사용해서 파일을 생성하게 되면 파일은 기본적으로 System encoding을 따르기 때문에 파일은 **UTF-8**로 만들어지게 된다. 만약 Windows를 사용한다면 CP959 캐릭터 기반으로 만들어지게 될 것이다. **IntelliJ**의 **Preferences**를 열어서 확인하면 기본 **IDE Encoding**, **Project Encoding**, **Default encoding for properties files**를 설정할 수 있는 것을 확인할 수 있다. 만약 Windows PC에서 개발을 한다면 이 정보를 잘 확인해서 서버환경과 동일하게 만드는 것이 좋다.
![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/065a6ab5-18d3-4765-8f07-b089b5bb5fa2)
개발 PC 환경은 CP949나 EUC_KR 일 경우 서버에서 파일을 열게 되면 한글이 깨어지기 때문이다.

## JVM 환경

Java로 프로젝트를 진행하고 있다면 현재 사용하고 있는 JVM의 환경이 어떤지 확인해 둘 필요가 있다. JVM은 파일을 바이너리코드로 변경해서 어떠한 JVM 환경에서도 운영할 수 있게 만들어주는데 이때 한글이 깨어지지 않게 동작하게 하기 위해서는 JVM의 환경을 알아두는게 좋다. JVM은 OS의 환경 기반으로 동작한다. 다음 코드를 사용해서 운영체제와 파일 인코딩을 확인 할 수 있다.

먼저 JVM의 인코딩을 알아보자.

```
new OutputStreamWriter(new ByteArrayOutputStream()).getEncoding();
```

다음은 파일 인코딩을 알아보자.

```
System.getProperty("file.encoding");
```

두가지 설정을 jar로 바로 확인할 수 있도록 github에 jar를 등록해 두었다. git에서 소스를 clone 받아서 `EncodingDetector.jar`를 실행하면 된다.

```
git clone https://github.com/saltfactory/EncodingDetector.git
```

시스템 환경을 확인하기 위해서는 `system`을 입력한다.

```
java -jar EncodingDetector.jar system
```

파일 인코딩을 확인하기 위해서는 `file`을 입력한다.

```
java -jar EncodingDetector.jar file
```

두가지 모두 확인하기 위해서는 `both`를 입력한다.

```
java -jar EncodingDetector.jar both
```

## Tomcat 환경

Tomcat은 JVM을 위에서 운영된다. 이런 이유로 Tomcat의 환경은 JVM의 환경을 따른다. 즉, Tomcat의 Web 관리 툴을 가지고 `.war` 파일을 deploy 시키면  JVM이 가지고 있는 환경을 가지고 `.war` 파일을 풀어서 운영한다. 내 PC에서 **UTF-8** 환경으로 파일을 archive 시켰는데 서버 환경이 **EUC_KR**로 되어 있다면`.war` 파일이 풀렸을때 한글 내용이 저장되어 있는 파일을 열어보면 한글이 깨어지는 것을 확인할 수 있을 것이다.

## 실험

우리는 이 환경을 테스트하기 다음과 같이 환경을 설정해보자.

**UTF-8**로 한글 내용이 저장되어 있는 파일을 `.war`로 묶어보자

지금 운영체제의 환경은 **UTF-8** 이다.

```
mkdir encoding_test &&
```

```
echo "한글테스트" > encoding_test/test.text
```

```
jar -cvf encoding_test.war encoding_test/
```

위와 같이 `encoding_test.war`를 만들었다. 이것은 Tomcat 기반의 웹 프로그램을 만들어서 `.war`로 묶은 것과 동일하다고 가정한다.
이제 운영체제의 환경을 **EUC_KR**로 변경해보겠다.

```
export LAGN=EUC_KR
```

시스템 인코딩 설정을 변경하고 적용된 결과를 확인하기 위해서 `locale`로 확인해보자.

```
locale
```

```
LANG="EUC_KR"
LC_COLLATE="C"
LC_CTYPE="C"
LC_MESSAGES="C"
LC_MONETARY="C"
LC_NUMERIC="C"
LC_TIME="C"
LC_ALL=
```

이제 시스템 환경이 바뀌었다. 이제 **UTF-8** 환경이 아닌 곳에서 `.war`를 풀어보자. 이 작업은 **UTF-8**이 아닌 환경에서 Tomcat이 `.war`를 푸는것과 동일하다고 가정한다.

```
jar -xvf encoidng_test.war
```
방금 **UTF-8**로 만든 `test.text` 파일을 열어보면 한글이 깨어진 것을 확인할 수 있다.


## 결론

우리는 개발용 PC와 JVM 기반의 Tomcat 서버가 운영하는 서버의 인코딩이 다를 때 발생하는 문제를 실험해 보았다. 시스템 인코딩 문제는 흔히 개발자들이 실수하는 문제이다. 만약 Lagacy 서버를 사용한다면 최근 **UTF-8** 환경으로 시스템을 구축하기 전, 한글 서비스 위주의 서버들로 **EUC_KR** 설정(또는 **KO**)으로 되어 있을것이다. 특히 **Sun Solaris** 기반에 서버를 사용하고 있다면 반드시 운영체제의 환경을 확인해보면 좋을 것이다. 개발용 PC는 **UTF-8**로 파일을 작업하면서 서버에 deploy 시킬때는 **EUC_KR** 환경이여서 서버에 접속해서 파일을 살펴보면 한글 내용이 깨어진 것을 발견하게 될 것이다. 개발용 PC와 서버의 환경 설정을 동일하게 만들어주는 것이 우선적으로 필요하면 만약 서버 환경을 변경할 수 없을 경우 `JAVA_OPT= -Dencoding=utf-8` 옵션을 사용하여 JVM에서 인코딩을 다르게 사용하여 실행할 수 있도록 유도해야한다.


## 참고

- http://www.coderanch.com/t/277269/java-io/java/Change-default-character-set-JVM


