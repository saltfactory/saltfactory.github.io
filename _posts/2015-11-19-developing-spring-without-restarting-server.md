---
layout: post
title: '서버 재시작 없이 Spring 웹 프로젝트 개발하기 (Spring Boot, IntelliJ, spring-loaded)'
category: java
tags:
  - java
  - spring
  - springboot
  - springloaded
comments: true
images:
  title: 'http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/88cef926-acf7-45e9-b96d-bbad57bc21d0'
---


## 서론

Java 기반 웹 어플리케이션의 가장 큰 단점은 클래스나 정적파일(html, javascript, css)을 수정하고 난 이후 반드시 서버를 재시작해야 한다는 것이다. Node.js 나 Ruby on Rails로 웹 어플리케이션을 개발해본 경험이 있다면 Spring 프로젝트에서  라인 하나 수정하였다고 엄청난 클래스 파일과 정적 파일을 포함한 프로젝트를 모두 재시작 해야하는 것을 보고 놀라지 않을 수 없다. 하지만 Java 개발자들이 이런 불편함을 감수하면서 개발을 하지 않을 것이다. 불편함을 해소하기 위해서 다양한 방법들이 존재하고 빠른 Spring 프로젝트 개발을 위한 Spring Boot와 Idea의 IntelliJ를 사용하여 개발한다면 이런 불편함을 해소할 수 있다. 다시말해서

> Spring 프로젝트를 개발하면서 정적파일이나 클래스파일 변경 이후 서버 재시작 없이 변경된 사항을 바로 적용하여 확인할 수 있다.

이 포스팅에서는 Spring 프로젝트에서 정적파일이나 클래스 파일 수정 이후 서버 재시작 없이 개발을 할 수 있는 방법을 소개한다.

<!--more-->

## Spring Boot

Spring framework의 복잡한 XML 설정 파일에 대한 불편함이나 거부감이 있다면 [Spring Boot](http://projects.spring.io/spring-boot/)로 시작하면 Spring을 Ruby on Rails 만큼 빠르게 개발할 수 있다. 기본적인 설정 없이 바로 MVC 기반의 웹 프로젝트를 생성할 수 있기 때문이다. 우리는 앞에서 [IntelliJ에서 SpringBoot 웹 프로젝트 생성하기](http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html) 라는 글을 소개한 적이 있다. 이 글을 참조해서 Spring 웹 프로젝트를 생성한다.

## Hot swapping

Spring Boot 공식 문서에서도 파일 수정 이후 서버 재시작 없이 서비스에 바로 적용하는 방법으로 [Hot swapping](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-hotswapping.html)을 소개하고 있다.

Hot swapping은 크게 두가지 리로드를 생각해야한다. 하나는 정적 파일이 수정 되었을 때 이고, 다른 하나는 클래스 파일이 수정되었을 때 이다.

## spring-loaded

만약 IntelliJ를 사용하여 Spring Boot를 개발한다면 [spring-loaded](https://github.com/spring-projects/spring-loaded)라는 Java Agent를 사용하여 아주 쉽게 reload 메카니즘을 적용할 수 있다. 프로젝트 디렉토이 안의 **build.gradle** 파을 열어서 다음 내용을 추가한다. 이 글을 작성할 때 springloaded의 최신 버전은 *1.2.4.RELEASE*  이다.

```groovy
buildscript {
    repositories { jcenter() }
    dependencies {
        classpath "org.springframework.boot:spring-boot-gradle-plugin:1.3.0.RELEASE"
        classpath 'org.springframework:springloaded:1.2.4.RELEASE'
    }
}

apply plugin: 'idea'

idea {
    module {
        inheritOutputDirs = false
        outputDir = file("$buildDir/classes/main/")
    }
}
```

만약 템플릿을 사용한다면 다음과 같에 **src/main/resources/application.properties** 파일을 열어서 템플릿 캐시를 꺼둔다.

```java
spring.thymeleaf.cache=false
```



이제 Spring 프로젝트의 리로드 설정이 모두 끝났다. 정말 간단하지 않는가? 단 몇줄을 스크립트를 추가하는 것만으로 복잡한 리로드 메카니즘을 구현한 것이다. 이것인 Spring Boot와 gradle의 장점이라고 생각한다.

## 서버 시작

위의 build.gradle 수정이 끝나면 Gradle 패널에서 리로드 아이콘을 클릭하여 필요한 클래스가 자동으로 프로젝트에 설치될 수 있도록 적용한다. 그리고 Tasks 중에서 application 하위에 있는 **bootRun**으로 프로젝트를 실행한다. 중요한 부분이다. 그냥 run으로 실행하면 리로드가 되지 않는다. 반드시 **bootRun**으로 실행하여야 한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4d704ed6-614c-41e1-8a25-b182d66d41e4)


## 정적파일 수정

우리는 서버가 실행된 상태에서 정적 파일 수정이 적용되는지 알아보자. 앞에서 생성한 프로젝트에서 HTML 파일을 수정하자. 기존 예제에서는 style.css 파일을 포함하고 있지 않았는데 스타일을 적용하기 위해서 **src/main/resources/static/css/style.css** 파일을 추가한다.

```css
body {
    background-color: red;
}
```
다음은 **new.html** 파일을 열어서 정적파일을 추가한다.

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>RestTemplate Demo</title>
    <meta charset="utf-8"/>
    <link href="/css/style.css" rel="stylesheet"/>
</head>
<body>
<h1>New</h1>

<form action="#" th:action="@{/templates/posts}" th:object="${post}" method="post">
    <p>title: <input type="text" th:field="*{title}" /></p>
    <p>content: </p>
    <p><textarea th:field="*{content}" /></p>
    <p><input type="submit" value="Submit" /> <input type="reset" value="Reset" /></p>
</form>
</body>
</html>
```

수정한 결과가 서버 재시작 없이 반영되는지 브라우저를 리로드해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f759d640-768f-4218-9a20-15dc16b45005)

style.css 파일의 background-color를 수정해보자.

```css
body {
    background-color: blue;
}
```
![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6d375b34-e988-4eca-862f-c9595dd0a96d)

HTML 파일(Thymleaf) 수정, CSS 정적 파일 수정을 했을 경우 서버 재시작 없이 바로 적용되는 것을 확인할 수 있다.

## 클래스 파일 수정

이제 클래스 파일을 수정해보자. 우리는 기존의 예제 코드를 사용하여 **PostController** 에 JSON을 반환하는 http://localhost:8080/posts 컨트롤러를 추가하였다. 서버 재시작 없이 진행하였다.

```java
@Controller
@EnableAutoConfiguration
public class PostsController {

    @RequestMapping(value="/posts", method = RequestMethod.GET)
    public @ResponseBody List<Post> list(){
        List posts = Arrays.asList(new Post(),  new Post());
        return posts;
    }
… 생략…
```

컨트롤러 파일 수정 이후 정적파일과 동일하게 브라우저를 새로 고침하면 다음과 같이 찾을 수 없는 페이지로 나올 것이다. 컨트롤러에 URL을 매핑하는 것을 추가하였는데 왜 수정 사항이 적용되지 않았을까?

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8335a5a9-a001-45c8-a05d-47b7c6581077)

이유는 자바는 클래스로 컴파일이 되어야한다. 이런 이유로 서버는 재시작하지 않지만 파일은 컴파일하여 위에 build.gradle 파일에서 spring-loaded의 Java Agent가 참조하고 있는 빌드 타겟에 클래스 파일이 변경되어야 하기 때문이다. 그래서 클래스 파일은 수정후 IntelliJ의 빌드 메뉴에서 컴파일 파일 메뉴를 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/42255043-9d5c-4e72-9f6c-79579d18ec0b)

이제 다시 브라우저를 새로 고침해보자. 다음과 같이 컨트롤 클래스에 변경된 사항이 적용되어 찾을 수 없는 URL 매핑이 이젠 JSON을 반환할 수 있게 되었다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/055162d9-fb9e-495f-9fee-f7a0e5ef784d)

## 결론

Spring은 훌륭하고 매우 안정적인 웹 프레임워크를 만들 수 있다. Java 프레임워크 특징상 정적파일과 클래스 파일 변경후 서버를 재시작해야하는 불편함이 있는데, Spring Boot와 IntelliJ를 사용하여 **spring-loeaded** Java Agent를 사용하게 되면 IDE에서 Spring 웹 프로젝트를 개발하면서 서버 재시작 없이 빠르게 개발을 진행할 수 있다. Spring은 복잡하고 많은 라이브러리와 클래스를 포함하고 있기 때문에 서버를 재시작하면 서버 재시작 시간 비용이 굉장히 많이 들기 때문에 개발을 할 때 서버를 재시작한다면 매우 답답할 수 밖에 없다. 하지만 소개한 방법을 사용하면 빠르게 Spring 개발을 할 수 있을 것으로 기대된다.

## 참조

1. https://docs.spring.io/spring-boot/docs/current/reference/html/howto-hotswapping.html
2. http://tomaszjanek.pl/blog/2015/02/03/hot-reloading-in-spring-boot-with-spring-loaded/
3. http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html
4. https://github.com/spring-projects/spring-loaded

