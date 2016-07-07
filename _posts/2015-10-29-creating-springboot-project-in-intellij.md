---
layout: post
title: IntelliJ에서 SpringBoot 웹 프로젝트 생성하기
category: java
tags:
  - java
  - spring
  - springboot
  - intellij
comments: true
images:
  title: 'http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/edb55ce0-a86f-441f-acca-e855f681bdc9'
---


## 서론

Spring Framework 기반의 웹 프로젝트를 진행하게되면 최초 설정하는 부분에 가장 많은 시간이 들어간다고해도 과언이 아닐정도로 설정해야 하는 부분이 많다. SpringBoot는 Spring의 복잡한 설정을 최소화하여 빠르게 프로젝트 개발을 시작할 수 있게 해준다. IntelliJ 14.1 부터는 IntelliJ가 공식적으로 SpringBoot를 지원하게 되었다. 테스트를 위해 Spring 기반의 데모 프로젝트를 만들어야하는 일이 생겼는데 IntelliJ에 SpringBoot를 만들어서 테스트를 진행하게 되었다. 이 포스팅에서는 IntelliJ에서 SpringBoot를 시작하는 방법을 소개한다.

<!--more-->

## Intellij 프로젝트 생성

IntelliJ를 시작하여 **Create New Project**를 선택하고 새로운 프로젝트 다이얼로그를 연다. **New Project** 다이얼로그가 열리면 **Spring Initializr**를 선택하고 Next를 한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/16ff2604-0739-40a9-9c32-a89ede4e6e8e)

다음은 프로젝트 이름, 타입, 패키지 등 프로젝트의 기본 정보를 설정하는 화면이 나온다.

- **Name** :  프로젝트의 이름
- **Type** : 프로젝트 타입 (maven 이나 gradle)
- **Packaging** : 프로젝트 빌드 이후 패키징될 타입 (jar 나 war)
- **Language** : 프로젝트 언어 (Java 나 groovy)
- **Group** : 프로젝트의  artifact 그룹 (프로젝트 저장소와 관련)
- **Artifact** :  프로젝트의 artifact
- **Version** : 프로젝트의 버전
- **Description** : 프로젝트 설명
- **Package** : 프로젝트 패키지명

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e873c7f2-3e47-4e77-a0a5-6b27bc836e74)

다음은 SpringBoot 프로젝트를 생성할 때 추가할 라이브러리들을 설정하는 화면이 나온다. 지정한 라이브러리는 이후 maven이나 gradle의 스크립트에 추가되어 자동으로 라이브러리를 쉽게 추가할 수 있다. 우리는 Web 프로젝트를 만들어서 테스를 하기 위해 **Web**을 선택하였고, 뷰 템플릿 엔진으로 [Thymeleaf](http://www.thymeleaf.org/)를 선택하여 gradle 스크립트를 만들었다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e705e498-164f-48f6-842d-8f4622144255)

다음은 프로젝트가 저장되는 경로를 지정한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/26bfc8a2-8cce-4d28-ad5b-3358b0be2ead)

만약 프로젝트가 열릴 때 프로젝트에 gradle 정보가 없을 경우 다음과 같이 **Import Project from Gradle** 화면을 열어서 프로젝트를 임포트한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9aa44112-4bf0-4403-bdcc-52a9360e26a6)

gradle 프로젝트가 임포트되면 이제 IntelliJ에서 gradle을 사용하여 BootStrap을 개발할 준비가 끝났다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/db64a4c4-9919-465c-a380-4d4abe96abc8)

## 테스트를 위한 Post 객체

우리는 테스트를 위해서 **Post** 객체를 만들것이다. 간단하게 id, title, content, created_at, updated_at 필드를 가지고 있는 POJO 객체로 만든다. **src/main/java/net/saltfactory/demo/Post.java** 파일로 만든다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/296628fa-8cf0-457d-9b1f-1df623c68fb4)


```java
package net.saltfactory.demo;

import java.util.Date;

/**
 * Created by saltfactory on 10/29/15.
 */
public class Post {
    private long id;
    private String title;
    private String content;
    private Date created_at;
    private Date updated_at;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }
}
```

## 테스트를 위한 Get 컨트롤러와 뷰 만들기

먼저 우리는 테스트를 위해서 컨트롤러를 만들 것이다. 컨트롤러의 이름은 PostsController로 만들 것이다. **src/main/java/net/saltfactory/demo/PostsController.java**

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/cd9de38e-f9d7-4749-972d-8214eebd210b)

```java
package net.saltfactory.demo;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by saltfactory on 10/29/15.
 */
@Controller
@EnableAutoConfiguration
public class PostsController {
    @RequestMapping(value = "/posts/new", method = RequestMethod.GET)
    public String newPost(Model model) {
        model.addAttribute("post", new Post());
        return "new";
    }
}

```

테스트를 위해 Post를 입력하는 Form 화면이 필요하다. 우리는 Thymeleaf로 뷰 템플릿 엔진을 사용하기 때문에 다음과 같이 **src/main/resources/templates/new.html** 파일로 뷰 템플릿 파일을 만든다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ebfadb7f-7e41-4e5b-b87c-85615f123587)

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>RestTemplate Demo</title>
    <meta charset=utf-8”/>
</head>
<body>
<h1>New</h1>

<form action="#" th:action="@{/posts}" th:object="${post}" method="post">
    <p>title: <input type="text" th:field="*{title}" /></p>
    <p>content: </p>
    <p><textarea th:field="*{content}" /></p>
    <p><input type="submit" value="Submit" /> <input type="reset" value="Reset" /></p>
</form>
</body>
</html>
```

이제 gradle로 빌드하고 어플리케이션을 실행시켜보자. 터미널을 열어서 프로젝트 디렉토리 안에서 다음 명령어를 입력하면 gradle 프로젝트가 빌드가 될 것이다.

```
gradle run
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ead2cc65-f9ea-481d-a3f9-bebc94ff4a82)

우리는 IntelliJ를 사용하고 있고 이것은 여러가지 명령어라인에서 처리해야할 명령어들을 UI로 쉽게 처리할 수 있게 만들어져 있다. IntelliJ의 오른쪽 패널에서 **Gradle Projects** 패널을 열어보자. Gradle 프로젝트 안에 **Task** 중에 **run**을 실행시키면 위에 터미널에서 **gradle run**을 실행한 결과와 동일하게 프로젝트가 빌드되고 시작될 것이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ded8126c-5192-459b-8b76-3d3bd0598768)

어플리케이션 서버가 실행되면 브라우저에서 뷰와 컨트롤러를 확인해보자.

http://localhost:8080/posts/new

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/d9652b53-d1de-4e90-a0e3-5f7a5a99dc0d)

## Form submit 처리를 위해 POST 메소드와 결과 뷰 추가

우리는 앞에서 Post 의 입력을 처리하기 위한 PostsController에 GET 메소드를 처리하는 것과 form을 위한 뷰를 만들었다. 이제 form 의 input에 값을 입력하고 submit을 하게되면 HTTP POST를 처리하기 위해 컨트롤러에 POST를 위한 메소드를 추가할 것이다. POST를 처리하는 내용은 간단하다. 입력받은 내용을 show.html에 그대로 출력하게 만든다.

```java
package net.saltfactory.demo;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by saltfactory on 10/29/15.
 */
@Controller
@EnableAutoConfiguration
public class PostsController {
    @RequestMapping(value = "/posts/new", method = RequestMethod.GET)
    public String newPost(Model model) {
        model.addAttribute("post", new Post());
        return “new”;
    }

    @RequestMapping(value = "/posts", method = RequestMethod.POST)
    public String createPost(@ModelAttribute Post post, Model model) {
        model.addAttribute("post", post);

        return "show";
    }
}
```

컨틀로러에 POST를 처리하는 부분은 입력화면에서 Model에 담은 값을 그대로 다시 모델에 넣어서 show.html으로 보여주는 간단하는 코드가 들어가 있다. **src/main/resources/templates/show.html** 파일을 다음 내용으로 생성한다.

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>RestTemplate Demo</title>
    <meta charset="utf-8"/>
</head>
<body>
<h1>Post</h1>
    <p th:text="'title: ' + ${post.title}" />
    <p th:text="'content: ' + ${post.content}" />
    <a href="/posts/new">새글 작성하기</a>
</body>
</html>
```

gradle run을 사용하여 서버를 재시작한 후 브라우저를 열어서 테스트를 진행하자

```
gradle run
```

http://localhost:8080/posts/new

입력 폼에 값을 입력하고 submit을 클릭한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/4423cb95-425f-441f-86d9-8f2d99aed066)

PostsController에서 **RestMethod.POST** 를 처리하고 입력으로 받은 post를 다시 model에 저장하여 show.html 뷰 템플릿을 사용하여 결과를 보여준다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5aaae744-4def-4834-9153-ead5535911ac)


## 결론

우리는 Spring 기반 웹 프로젝트를 빠르게 테스트해야할 경우 SpringBoot를 사용하여 테스트를 진행한다. SpringBoot는 Maven과 Gradle 로 생성하여 프로젝트를 관리할 수 있는데 터미널에서 Java 프로젝트를 진행하기에는 약간 어려움이 있다. 그래서 우리는 IntelliJ 라는 IDE를 사용하여 Spring 관련 Java 프로젝트를 개발하고 있다. IntelliJ 14.1 버전 이상부터는 IntelliJ에서 공식적으로 SpringBoot 프로젝트를 지원한다. 이번 포스팅에서는 IntelliJ에서 간단한 SpringBoot 웹 프로젝트를 생성하여 GET, POST를 처리하는 방법을 살펴보았다. SpringBoot를 사용한 Spring 프로젝트 개발에 관련된 내용을 지속적으로 업데이트할 예정이다.


## 참고

1. http://projects.spring.io/spring-boot/#quick-start
2. https://spring.io/guides/gs/handling-form-submission/
3. http://blog.jetbrains.com/idea/2015/03/develop-spring-boot-applications-more-productively-with-intellij-idea-14-1/
4. https://www.jetbrains.com/idea/help/creating-spring-boot-projects.html


