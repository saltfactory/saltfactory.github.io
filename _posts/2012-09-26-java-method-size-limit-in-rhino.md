---
layout: post
title: Rhino에서 64K 넘는 대용량 JavaScript 로드할 때 발생하는 문제와 Java method size limit
category: javascript
tags: [javascript, node]
comments: true
redirect_from: /196/
disqus_identifier : http://blog.saltfactory.net/196
---

## 서론

Rhino에 대해서는 이전 포스팅을 읽어보면 Java기반의 Javascript Runtime 환경을 제공해 주기 때문에 브라우저 없이 Javascript 코드를 개발할 수 있다는 것을 알수 있다. Rhino는 생각보다 편리한 기능을 많이 포함하고 있고 Javascript 라이브러리를 개발하는데 매우 유용하다. 하지만 이런 Rhino에게 현재 버전에 치명적인 단점이 있다. 지금 Rhino1.7R4 버전에서 64K 이상크기의 Javascript를 로드하지 못하는 문제가 있다.

<!--more-->

현재 Envjs에서 배포하고 있는 env.rhino.1.2.js 파일은 64K 이상이다. Rhino1.7R4 버전에서 envjs를 로드하면 로드해보자.

```
java -jar js.jar
```
```
js> load ("env.rhino.1.2.js");
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/aab557ff-f185-4678-a020-8a02dcebeba8)

## Java method size limit

Rhino 1.7 R4에서는 `env.rhino.1.2.js`를 용량제한으로 로드를 하지 못한다는 에러가 나온다. 이게 무슨 말인가... 정말 황당한 문제 때문에 이유를 찾기 시작했다. 그중에서 다음 자료를 찾을 수가 있었다.

http://www.coachwei.com/2008/09/01/the-64kb-java-language-problem-lesso-learnd-from-using-rhino-to-process-javascript/

글을 보면 Rhino가 Java 의 non-native, non-abstract 메소드의 제한인 **65536**에 최적화 하기 위해서 Rhino가 로드하는 javascript의 코드길이가 이 이상이 넘지 않게 구현되어 있다는 것이다. 이건 Rhino의 문제인지 Java의 문제인지 몰라서 자료를 좀 더 찾아보기로 했다.

1. **maximum method size is too small (64k)** : http://bugs.sun.com/view_bug.do?bug_id=4262078
2. **method size limit in Java** : http://eblog.chrononsystems.com/method-size-limit-in-java
3. **Java Tip \#5 - Avoid 64KB method limit on JSP** : http://futuretask.blogspot.kr/2005/01/java-tip-5-avoid-64kb-method-limit-on.html
4. **Workarounds for the 64K Size Limit for the Generated Java Method** : http://docs.oracle.com/cd/A97688_16/generic.903/bp/j2ee.htm#1009526

위 자료들을 보면 Java, JSP 등에서 code generation에 대한 Java method 의 Limit에 대해서 글들을 볼 수 있다. Java method에 대한 크기 제한이 있는것은 처음 알게 된 사실이다. Java 메소드를 그렇게 크게 만들어 본 적이 없기도 했을 뿐드러 Rhino에서 Javascript 파일을 로드하는데 그 소스코드가 문자열로 메소드안에서 code generation이 되는지는 생각도 하지 못했기 때문이다.

env.rhino.1.2.js 파일을 살펴보자. env.rhino.1.2.js는 64k가 넘는다는 것을 확인 할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f0ba3c1a-5e65-4404-96cc-d1d8cb6e3a2c)

그래서 github.com/hns 에서 rhino를 fork 해서 코드를 수정했다. https://github.com/hns/rhino/commit/207bb86e63b452237fbf6004fee12b90980c67f3 커밋된 내용을 참조하거나 이 커밋의 rhino를 다운 받는다. 그리고 압축을 해지한 다음 ant를 이용해서 jar를 생성하기 위해서를 build를 한다. 그리고 en.rhino.1.2.js를 다시 로드한다.

```
cd hns-rhino-207bb86/
```
```
ant jar
```
```
cd hns-rhino-207bb86/build/rhino1_75pre/
```
```
java -jar js.jar
```
```
js > load ("env.rhino.1.2.js");
```

이젠 정상적으로 envjs 가 rhino에서 로드되어서 envjs를 사용할 수 있게 되었다.

## 결론

rhino에서는 Java의 최적화를 위해서 미리 대용량 파일을 로드하지 못하게 한듯하다. 이렇게 수정된 코드가 과연 Java의 method limit에 문제가 되지 않고 이상없이 사용 할 수 있는지에 대한 테스트는 더 필요할 것 같다. 이번 rhino와 대용량 javascript 로드를 통해서 Java의 method limit에 대한 것을 알게 된 것 같다. 실제 Java에서 XML을 파싱하기 위해서 대용량 XML을 로드하면서 비슷한 경험을 했다는 사례들도 찾을 수 있었다. Java의 이러한 제한이 있다면 rhino에서 대용량 자바스크립트를 로드하는게 가능하지 않게 때문에 여러개의 Javascript 파일을 나누어서 로드를 해야할 것이다. 아니면 rhino에 로드하기 위해서 javascript compressor를 이용해야 할지도 모른다. github.com/hns에 수정한 코드로 로드를 할 수는 있지만 현재 발생하는 이 문제에 대한 근본적인 해결 방법이 필요할 것으로 예상이 된다. 이 문제 대한 해결방법이나 Java method limit에 대한 다른 의견이 있으면 언제든지 조언을 부탁드리고 싶다.

## 참고

1. http://bugs.sun.com/view_bug.do?bug_id=4262078
2. http://eblog.chrononsystems.com/method-size-limit-in-java
3. http://futuretask.blogspot.kr/2005/01/java-tip-5-avoid-64kb-method-limit-on.html
4. http://docs.oracle.com/cd/A97688_16/generic.903/bp/j2ee.htm#1009526


