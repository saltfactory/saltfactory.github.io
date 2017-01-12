---
layout: post
title: JSPX로 빠르게 웹 서비스 개발하기
category: jspx
tags: [java, jsp, jspx, web]
comments: true
redirect_from: /207/
disqus_identifier : http://blog.saltfactory.net/207
---

## 서론

SPX는 Java web RAD framework이다. JSPX는 자바 rich interactive web application 개발을 쉽게하기 위해서 2008년도에 자바 커뮤니티인 java.net에서 소개가 되었다. JSPX는 초기에는 web form과 같은 매우 제한적이였지만 JSPX-bay로 프로젝트가 옮겨지면서 지원하는 것이 점차 많아지게 되었다. RAD framework는 Rapid Application Development framework로 RAD software 방법론을 기반으로 만들어진 프레임워크이다. RAD software 방법론은 매우 짧은 개발 주기를 강조하는 선형모델로 비즈니스 모델링, 데이터 모데링, 어플리케이션 생성, 테스팅의 인과 과정을 보다 빠르게 하면서 고품질의 제품을 개발하는 모델이다

![](http://asset.blog.hibrainapps.net/saltfactory/images/178bbaa6-22e4-46e1-9765-9926aaa2b923)

소프트웨어 자체는 지속적으로 변화를 수용할 수 있는 개발 방법론을 적용해서 요구사항이 들어오면 그 요구사항에 맞게 신속하게 제품의 디자인(모델링)부터 어플리케이션 변경까지 변경되어져야하는데 정적인 개발 방법을 가지고는 대규모 어플리케이션에 적용하기 힘들어진다. 하지만 어플리케이션을 마치 뼈대를 조립하듯이 설계가 되어져 있으면 변경이 필요한 부분만 빠르게 변경하고 조립해가는 방법을 사용하면 되기 때문에 이런 RAD framework는 고객의 요구사항과 어플리케이션 변경에 빠르게 대응할 수 있는 환경을 가지고 있다. RAD는 제한된 범위의 단독 시스템을 CASE를 사용하여 신속하게 개발하는 방법론이다. 이 개발 대상은 시스템이 복잡하지 않아서 독립적으로 기술을 설계가 가능한 경우에 사용할 수 있다.

JSPX라 불리는 JSPX-bay는 무료 java web RAD framework 으로 위 개념의 아키텍처를 지원하고 있다. JSPX를 Oracle Application Framework와 XML 표현식의 JSP와 혼동해서는 안된다. JSPX는 Java EE Servlet의 확장판으로 HTML 코드를 생성하는데 OOP모델로 개발할 수 있게 해주는 것을 지원하고 있다.

JSPX는 RAD의 방법론을 기반해서 다음 목적으로 디자인 되었다.

- **Business case Driven Framework** : JSPX는 비즈니스 CASE를 driven 할 수 있는데 이는 코드와 비즈니스 모델, 그리고 task를 분리할 수 있다.
- **Zero configuration** : JSPX는 JSF와 비교가 많이 되지만 JSF는 외부 설정 파일이 존재해야하는 반면에 JSPX는 그렇지 않다.
- **Declarative and Imperative Web** : JSPX는 HTML 코드를 OOP로 정의할 수 있고 Java API로 정의된 속성에 접근이 가능하다.
- **Optional and Default Implementation** : JSPX 자체게 기본 값이 있기 때문에 모두 설정하는 번거러움이 없다.
- **Interaction with other framework** : JSPX 페이지 안에 기존의 JSP를 임포트해서 사용할 수 있다.
- **Portable framework** :추가 노력 없이 거의 모든 Java Application Server에서 동작한다.

JSPX의 구조는 다음과 같다. Http Request 요청이 들어오면 Java Servlet이 URL 패턴에 해당되는 RequestHandler에게 요청을 넘겨서 Cache가 있으면 Cache된 컨트롤러를 사용하고 아니면 Page Controller과 Page Model Composer 를 이용해서 jspx와 조합해서 사용자 코드를 결합해서 Http Response를 반환해주는 구조를 가지고 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/4835c6e7-ebac-4123-965e-2c2bee9881e4)

CASE 기반으로 개발이 가능하다는 이야기인데 실제 어떻게 적용되는지 알아보기 이전에 기본 설정이 필요기 때문에 설정하는 포스팅부터 준비를 했다. JSPX는 Spring 프레임워크와 함께 연동해서 사용도 가능하지만 JSPX의 개념을 알기위해서 단독으로 설정해서 개발하는 방법을 소개한다.

## Java 웹 어플리케이션 프로젝트 생성

Java 웹 어플리케이션을 개발하려면 기본적으로 Java 서블릿 서버가 필요한데 apache-tomcat과 같이 무료 오픈소스 서브를 이용하여 개발을 하고 있을 것으로 예상이된다. 그리고 IntelliJ나 Eclipse와 같이 IDE를 통해서 쉽게 웹 어플리케이션 프로젝트를 생성할 수 있기 때문에 그에 대한 설명은 생략한다. 이 포스팅을 위해 JSPXTutorial이라는 웹 어플리케이션 프로젝트를 IntelliJ에서 생성했다. 그리고 서블릿 엔진 서버는 apache-tomcat-6.0.36을 사용했다. 그리고 web root 디렉토리 밑에 jspx 파일을 저장하기 위해서 jspx 디렉토리를 생성했다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/2fe679a6-2102-41f6-aba2-c26af8fffb1a)

## JSPX 라이브러리 다운로드

JSPX는 JSPX-bay 프로젝트로 이동이 되었다. JSPX-bay에서 jar 라이브러리를 다운받는다.  http://jspx-bay.sourceforge.net/pages/build/download.html 이 글을 포스팅할 때는 jspx-1.10.jar 버전을 다운 받았다.

Java IDE에 사용하고 있는 라이브러리 디렉토리에 jspx-1.10.jar를 넣는다. 이 포스팅은 IntelliJ 기반으로 작성하고 있지만 eclipse에 사용하는 lib 디렉토리에 넣고 classpath를 추가하면 된다. JSPX 라이브러리는 기본적으로 commons-fileupload와 log4j 라이브러리에 의존성을 가지고 있다. JSPX의 태생이 web form을 위한 것이기 때문에 fileupload 라이브러리에 대한 의존성을 가진것으로 보이고, logging을 위해서 log4j를 이용한것 같다. 이 두가지 라이브러리를 다음 링크에서 다운 받아서 프로젝트의 lib 디렉토리에 저장하여 classpath에 추가한다.
http://commons.apache.org/fileupload/download_fileupload.cgi
http://logging.apache.org/log4j/1.2/download.html

## web.xml 설정

Java 웹 어플리케이션을 개발하기 위해서는 Java 서블릿을 서블릿 엔진이 해석하기 위해서 web.xml을 설정해야한다. JspxHandler라는 서블릿은 eg.java.net.jspx.engine.RequestHandler 클래스로 *.jspx 파일 요청이 들어오면 매핑이되게 설정했고. /jspEmbededResources/* 요청이 들어오면 eg.java.net.web.jspx.engine.ResourceHandler 클래스인 서블릿과 매핑이 되게 설정했다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
		  http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">


    <display-name>jspx-demo</display-name>
    <servlet>
        <servlet-name>JspxHandler</servlet-name>
        <servlet-class>eg.java.net.web.jspx.engine.RequestHandler</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>ResourceHandler</servlet-name>
        <servlet-class>eg.java.net.web.jspx.engine.ResourceHandler</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>JspxHandler</servlet-name>
        <url-pattern>*.jspx</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>ResourceHandler</servlet-name>
        <url-pattern>/jspxEmbededResources/*</url-pattern>
    </servlet-mapping>
</web-app>
```

## HelloWorld page 클래스 작성

JSPX는 요청이 들어오면 Java Page 컨트롤러 클래스파일과 JSPX가 서로 조합되어서 HTML 파일이 만들어진다. Page가 만들어질 때 Label이라는 element에 Hello Java World 라고 문자열을 입력했다. 이후에 JSPX 파일에 <label id="message"/>에 여기 Label 이라는 jspx ui element에 문자열을 넣기 위해서 이다. Page 클래스를 상속받은 HelloWorld 클래스는 단순하게 POJO 형태로 setter와 getter로 jspx의 html element와 서로 상호데이터를 주고 받을 수 있다.

```java
package net.saltfactory.tutorial.jspx;

import eg.java.net.web.jspx.ui.controls.html.elements.Label;
import eg.java.net.web.jspx.ui.pages.Page;
import org.apache.log4j.Logger;

/**
 * Filename: HelloWorld.java
 * Created by saltfactory@gmail.com
 * User: Saltfactory
 * Date: 11/16/12
 */
public class HelloWorld extends Page {

    Label message;
    Logger log;

    public HelloWorld() {
        log = Logger.getLogger(this.getClass());
    }

    protected void pageLoaded() {
        if (!isPostBack) {
            message.setValue("Hello Jspx World");
        }
    }

    public void setMessage(Label message) {
        this.message = message;
    }

    public Label getMessage() {
        log.debug(message.getValue());

        return message;
    }
}
```

## JSPX 파일 생성

JSPX는 HTML 파일 생성하는 코드를 대폭적으로 줄일 수 있다고 JSPX에서는 설명하고 있다. 실제 PageController과 조합해서 HTML 코드가 OOP 적으로 설계해서 조립을 하는 것이기 때문인것 같은데 이번 예제에서는 단순하게 label 이라는 html element에 Page 클래스를 상속받은 HelloWorld의 message만 가져와서 조립되는 예제만 준비했다. 아래코드를 살펴보면 label 이라는 element에 id만 부여 되었을 뿐 label에 포함된 문자열은 비어 있다. helloworld.jspx 파일은 web root 디렉토리 밑에 jspx/helloworld.jspx 파일로 저장을 한다. (/JSPXTutorial/web/jspx/helloworld.jspx)

```html
<page controller="net.saltfactory.tutorial.jspx.HelloWorld">
    <html>
        <head>
            <title>JSPX Tutorial</title>
        </head>
    <body>
    <h1>JSPX</h1>
    <label id="message"/>

    </body>
    </html>
</page>
```

이제 모든 설정이 마쳤으니 서블릿 서버를 실행하고 http 요청을 해보자.

http://localhost:8080/jspx/helloworld.jspx

![](http://asset.blog.hibrainapps.net/saltfactory/images/785f55ae-b7fb-4d9a-bbfe-b9122f738e41)

jspx에 <label id="message"/>에 비어 있던 내용이 Hello Jspx World 라는 문자열을 포함해서 HTML이 생성된 것을 확인할 수 있다. 소스코드를 확인해보자. HelloWorld.java에서 Label에 setter했던 내용이 HTML 조립이 될 때 getter를 이용해서 가져와서 label element에 Hello Jspx World 문자열을 포함시켰다. 그리고 web.xml 서블릿에 리소스에 대한 url  Link 엘리먼트로 자동으로 생성되는 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/0af9b6cf-0fc7-4ea0-a980-e509ef1f13fa)

## 결론

JSPX는 Java web RAD framework이다. 그래서 비즈니스의 요구 사항에 코드가 빠르게 요구사항을 받아들여서 어플리케이션 개발에 적용되어야 되기 때문에 CASE별 독릭접으로 만들어서 조립을 하는 형태를 지원하고 있다. 기존의 JSP 개발은 Java Bean을 가져와서 JSP 문법과 HTML 코드를 혼합해서 사용을 했었다. 하지만 JSPX는 위와 같이 PageController가 페이지에 관한 내용을 추가하거나 조작할 수 있다. 이런 이유로 JSPX 디자인과 데이터 처리에 관련된 코드를 분리해서 View에 빠르게 적용을 할 수 있다. 뿐만 아니라 JSPX는 기본적으로 지원하는 설정들이 있는데, 이 포스팅은 JSPX 의 개발을 위한 기본 설정을 소개하고 있기 때문에 JSPX에 대한 자세한 사용법에 대해서는 소개하지 않았다. 더욱 자세한 내용은 앞으로 추가될 예정이다.

## 참고

1. http://jspx-bay.sourceforge.net/pages/tout/demo.html#
2. http://en.wikipedia.org/wiki/Jspx-bay
3. http://java.net/projects/jspx


