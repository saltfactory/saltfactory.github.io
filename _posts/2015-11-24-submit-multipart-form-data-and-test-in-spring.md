---
layout: post
title: Spring에서 REST 서비스를 위한 컨트롤러에 FORM과 파일업로드(multipart/form-data)를 함께 사용하기와 컨트롤러 테스트하기
category: java
tags:
  - java
  - spring
  - springboot
  - form
  - fileupload
  - unit-testing
comments: true
images:
  title: 'http://asset.blog.hibrainapps.net/saltfactory/images/spring_bean_bud.jpg'
---


## 서론

최근 REST 기반의 서비스가 인기를 누리고 있지만 기본적으로 웹 서비스에서 입력폼은 FORMs 기반 서비스가 많다. 우리는 앞에서 [Spring에서 REST 서비스를 위한 컨트롤러 생성과 컨트롤러 단위테스트 하기](http://blog.saltfactory.net/java/create-and-test-rest-conroller-in-spring.html) 글에서 Spring Boot로 웹 서비스를 구현할 때 REST 서비스를 위한 컨트롤러를 간단히 만들어보았다. Spring Boot에서 JSON 기반의 REST 서비스를 하기 위해서 [@RestController](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html), [@RequestBody](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestBody.html) 그리고 [@ResponseBody](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/ResponseBody.html) 를 가지고 컨트롤러를 작성하였다. 이번 포스팅에서는 Spring 기반에서 [FORMs](http://www.w3.org/TR/html401/interact/forms.html)을 다루기 위한 컨트롤러를 만들고 테스트하는 방법을 소개한다.

<!--more-->

## SpringBootDemo 만들기

우리는 앞에서 REST 서비스를 위해 간단히 만들었던 SpringBootDemo에 코드를 추가하면서 설명을 진행할 것이다. 먼저 githug에서 [spring-boot-rest](https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-rest) 예제를 clone하거나 다운로드 한다.

````
git clone https://github.com/saltfactory/saltfactory-java-tutorial.git
```

저장소를 clone 했다면 **spring-boot-rest** 브랜치로 브랜치 이동을 한다.

```
git checkout -t origin/spring-boot-rest
```

다운받은 디렉토리 안에 **SpringBootDemo** 디렉토리 안에 Gradle 기반의 Spring Boot 프로젝트가 존재한다. IntelliJ에서 build.gradle을 임포트하면 자동으로 Spring 프로젝트가 만들어지게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/192d6ae3-92e3-4368-b565-8413fd53ecdc)

![](http://asset.blog.hibrainapps.net/saltfactory/images/19af044e-3282-44dd-8198-00374e74a458)

## Thymeleaf 라이브러리 추가

앞에서 받은 REST 서비스를 위한 컨트롤러에서는 HTTP 요청의 응답으로 JSON의 결과만 받았기 때문에 뷰 템플릿이 필요하지 않았지만, FORM을 입력받는 HTML 웹 페이지 서비스를 위해서 보다 효율적인 개발을 위해서 뷰 템플릿이 필요하다. [IntelliJ에서 SpringBoot 웹 프로젝트 생성하기](http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html) 글에서 IntelliJ에서 Spring Boot 프로젝트를 처음 만들 때 **Dependencies** 를 선택하는 화면을 소개한적이 있다. 처음 프로젝트를 만들 때 **Template Engines**에서 Spring 프로젝트에서 사용할 수 있는 뷰 템플릿을 선택할 수 있는데 최근 많이 사용하는 뷰 템플릿이 [Thymeleaf](http://www.thymeleaf.org/)이기 때문에 이것을 선택하면 wizard가 끝나면 build.gradle 파일 안에 dependencies 안에 이 라이브러리가 자동으로 포함하게 된다.

우리는 이미 만들어진 Spring Boot 프로젝트에 뷰 템플릿을 추가할 것이다. 다운받은 소스 안에 **build.gradle** 파일을 열어서 다음과 같이 수정한다.

```groovy
buildscript {
    ext {
        springBootVersion = '1.3.0.RELEASE'
    }
    repositories {
        mavenCentral()
        maven { url 'http://repo.spring.io/plugins-release' }
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
        classpath 'org.springframework.build.gradle:propdeps-plugin:0.0.7'
        classpath('org.springframework:springloaded:1.2.4.RELEASE')
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'spring-boot'

jar {
    baseName = 'spring-boot-demo'
    version = '0.0.1-SNAPSHOT'
}
sourceCompatibility = 1.8
targetCompatibility = 1.8

idea {
    module {
        inheritOutputDirs = false
        outputDir = file("$buildDir/classes/main/")
    }
}

repositories {
    mavenCentral()
}


dependencies {
    compile('org.springframework.boot:spring-boot-starter-thymeleaf')
    compile('org.springframework.boot:spring-boot-starter-web')
    testCompile('org.springframework.boot:spring-boot-starter-test')

    compile('org.springframework.boot:spring-boot-configuration-processor')
}

compileJava.dependsOn(processResources)

configure(allprojects) {
    apply plugin: 'propdeps'
    apply plugin: 'propdeps-maven'
    apply plugin: 'propdeps-idea'
    apply plugin: 'propdeps-eclipse'
}


eclipse {
    classpath {
         containers.remove('org.eclipse.jdt.launching.JRE_CONTAINER')
         containers 'org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.8'
    }
}

task wrapper(type: Wrapper) {
    gradleVersion = '2.9'
}
```

뷰를 개발할 때는 HTML코드 변경을 자주하는데 그 때마다 어플리케이션에 적용되는 것을 확인하는 것은 매우 불편한 일이다. 그래서 우리는 앞에서 소개한 [서버 재시작 없이 Spring 웹 프로젝트 개발하기](http://blog.saltfactory.net/java/developing-spring-without-restarting-server.html) 글에서 [spring-loaded](https://github.com/spring-projects/spring-loaded)을 사용한 Spring의 [Hot swapping](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-hotswapping.html)을 build.gradle 파일에 추가하였다. 뷰 템플릿이 수정한 이후 자동으로 새로 컴파일된 파일을 참조하기 위해서 뷰 템플릿의 cache를 사용하지 않기 위해서 **src/resources/application.properties** 파일을 열어 다음과 같이 설정한다.

```java
spring.thymeleaf.cache = false
```

기본적으로 SpringBoot의 [application.properties](http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html)에서 뷰 템플릿의 파일 위치를 지정할 수 있는데 **src/resources/templates** 디렉토리 안에 위치하도록 설정되어져 있다. 만약 다른 위치에 템플릿 파일들을 위치하고 싶으면 **src/main/resources/application.properties** 파일에 템플릿 위치를 다음과 같이 수정하면 된다.

```java
spring.thymeleaf.prefix=classpath:/templates/
```

다운받은 프로젝트 안에 **src/resources/templates/articles/** 디렉토리를 만든다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/87bf1d09-0d6d-43d3-852c-e3a14f7ceb02)

build.gradle 설정을 모두 마쳤으면 IntelliJ의 Gralde project 패널에서 새로고침 버튼을 클하면 추가한 Dependencies에 관련된 라이브러리를 저장소로부터 자동으로 다운받을 수 있다.

## @RestController Vs. @Controller

Spring에서 컨트롤러 컴포넌트를 만들때 우리는 기본적으로 [@Controller](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html)를 사용하여 만든다. 하지만 앞에서 REST 서비스를 위한 컨트롤러를 자세히 살펴보면 [@RestController](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html)를 사용한 것을 확인할 수 있다.

[Spring Framework : @RestController Vs. @Controller](https://www.genuitec.com/spring-frameworkrestcontroller-vs-controller/) 글에서 @RestController는 간단한 객체를 JSON/XML 타입으로 반환하는 REST 서비스에 최적화된 간단한 컨트롤러라고 소개하고 있다. 앞에서 글 [Spring에서 YAML 파일 데이터 객체에 매핑하여 로드하기](http://blog.saltfactory.net/java/load-yaml-file-in-spring.html#comment-2375635760) 글에서 [@ResponseBody](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/ResponseBody.html)를 사용하여 객체를 JSON으로 반환하였는데, @RestController라고 지정을하게 되면 @ResponseBody 없이도 컨트롤러를 통해 반환되는 Http Response가 자동으로 JSON으로 변환이 된다는 것이다.

예제를 통해서 살펴보자. 우선 기존에 다운받은 소스 안에 **src/main/java/{패키지명}/ArticlesController.java** 파일을 열어보자.

```java
package net.saltfactory.tutorial;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
@RestController
public class ArticlesController {
    @Autowired
    ArticlesService articlesService;

    @RequestMapping(value = "/api/articles", method = RequestMethod.GET)
    @ResponseBody
    public List<Article> index() {
        return articlesService.getArticles();
    }

    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Article show(@PathVariable(value = "id") long id) {
        return articlesService.getArticle(id);
    }

    @RequestMapping(value = "/api/articles", method = RequestMethod.POST)
    @ResponseBody
    public Article create(@RequestBody Article article) {
        return article;
    }

    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.PATCH)
    @ResponseBody
    public Article patch(@PathVariable(value = "id") long id,  @RequestBody Article article) {
        return article;
    }

    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.PUT)
    @ResponseBody
    public Article update(@PathVariable(value = "id") long id,  @RequestBody Article article) {
        return article;
    }

    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.DELETE)
    @ResponseBody
    public List<Article> destroy(@PathVariable(value = "id") long id) {
        return articlesService.deleteArticle(id);
    }
}
```

우리는 새롭게 입력할 HTML 파일을 보여줄 메소드를 하나 추가할 것이다. 다음 메소드를 추가한다. 이 코드는 **http://localhost:8080/artlces/new**로 요청이 들어면 입력 폼에 값을 담을 객체를 [Model](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/ui/Model.html)에 객체를 포함하여 **src/resources/templates/articles/new.html** 뷰 템플릿을 렌더링하여 반환하라는 내용이다.

```java
    @RequestMapping(value = "/articles/new", method = RequestMethod.GET)
    public String newArticle(Model model){
        Article article = new Article();
        model.addAttribute("article", article);
        return "articles/new";
    }
```

간단히 뷰 템플릿에 대한 파일을 다음 내용으로 **src/resources/templates/articles/new.html** 생추가한다. [Thymeleaf](http://www.thymeleaf.org/) 뷰 템플릿에 관련된 자세한 내용은 다음에 소개를 하고 간단히 위 Controller에서 추한 **Model** 안의 객체를 **th:object**에 정의하고 form 안에 이름과 객체의 필드명을 매핑하기 위해서 **th:field**를 같은 이름으로 사용한다.

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>SpringBootDemo</title>
    <meta charset="utf-8"/>
</head>
<body>
<h1>New Article</h1>

<form action="#" th:action="@{/articles}"
      th:object="${article}"
      method="post">
    <p>title: <input type="text" th:field="*{title}" /></p>
    <p>content:
        <textarea th:field="*{content}"></textarea>
    </p>

    <input type="submit" value="submit" />
</form>

</body>
</html>
```

이제 ArticlesControllers에 추가한 HTML 뷰를 보여주기 위한 메소드를 테스트하기 위해서 **src/test/java/{패키지명}/ArticlesControllerTests.java**에 테스트를 추가한다. HTTP Get으로 /articles/new 를 요청하게 되면 위의 HTML 내용이 렌더링된 컨텐츠타입이 **text/html**인 HTML 페이지가 보여야하고 그 페이지 안에 `<input type="text" id="title" name="title" />` 소스코드가 있어야하기 때문에 테스트는 다음과 같이 작성이 되었다.

한가지 테스트에서 중요한 점은 기존의 REST 서비스를 위해 뷰 템플릿 없는 컨트롤러 테스트를 진행할 때는 테스트 환경을 **standardaloneSetup()** 메소드로 컨트롤러의 **MockMvc**를 만들어서 테스를 진행하였다. 하지만 뷰 템플릿까지 모두 테스트를 진행하기 위해서는 컨트롤러 객체만 필요한 것이 아니라 Web Application 전체의 자원이 필요하기 때문에 **webAppContextSetup()** 메소드로 **MockMvc**를 만들어서 테스트를 진행해야한다. 또한 테스트에서 Web Application 모든 설정을 가져오기 위해서 테스트 클래스 레벨에 **@WebAppConfiguration** 어노테이션을 추가해야하고 이것을 autowired 할 **WebApplicationContext** 변수를 추가 해야한다.

```java
package net.saltfactory.tutorial;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.Logger;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.context.WebApplicationContext;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
@WebAppConfiguration
public class ArticlesControllerTests {

    Logger logger = Logger.getLogger(this.getClass());

    private MockMvc mockMvc;

    @Autowired
    private ArticlesController articlesController;

    @Autowired
    WebApplicationContext wac;

    @Autowired
    private ArticlesService articlesService;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
//        mockMvc = standaloneSetup(articlesController).build();
        mockMvc = webAppContextSetup(wac).build();
    }

    private String jsonStringFromObject(Object object) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(object);
    }


    @Test
    public void testNewArticle() throws Exception {
        MvcResult result = mockMvc.perform(get("/articles/new"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_HTML))
                .andExpect(xpath("//input[@name='title']").exists())
                .andReturn();

        assertThat(result.getResponse().getContentAsString(), containsString("New Article"));

        logger.info(result.getResponse().getContentAsString());
    }
... 생략 ...
```

테스트를 진행해보자. 결과는 다음과 같이 실패가 된다. 소스코드에는 문제가 없는데 왜 HTML이 HTTP의 응답이 즉, 우리가 추가한 컨트롤러의 메소드에서 반환되는 객체가 뷰 페이지(**text/html**)가 아니라 문자열(**text/plain**)이 되었을까?

![](http://asset.blog.hibrainapps.net/saltfactory/images/795c5141-1305-4561-abe3-0b2592577290)

이유는 바로 **@RestController** 때문이다. 클래스 레벨에 붙여놓은 Spring Annotation인 @RestController 는 컨트롤러 내부에서 작성한 메소드가 반환하는 모든 객체를 Document 타입으로 반환하기 때문이다. 이 문제를 해결하기 위해서는 @RestController 를 @Controller 어노테이션으로 변경을 해야한다. ArticlesController 코드를 다음과 같이 수정한다. @RestController 대신에 @Controller로 변경한다.

```java
package net.saltfactory.tutorial;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
//@RestController
@Controller
public class ArticlesController {
    @Autowired
    ArticlesService articlesService;

    @RequestMapping(value = "/articles/new", method = RequestMethod.GET)
    public String newArticle(Model model){
        Article article = new Article();
        model.addAttribute("article", article);
        return "articles/new";
    }
... 생략 ...
```

여기서 @RestController에 사용한 JSON 타입을 반환하는 다른 메소드들에 영향을 주는지에 대한 궁금증이 생길 수 있는데 우리는 미리 메소드 앞에 반환 타입을 @ResponseBody로 정의하여 놓았기 때문에 컨트롤러를 @RestController가 아니고 @Controller 로 지정하더라도 메소드 레벨의 어노테이션에서 반환 타입을 JSON으로 변경하기 때문에 기존의 코드는 수정할 필요가 없다.

클래스 레벨에 @Controller로 어노테이션을 수정하고 다시 테스트를 진행한다. 테스트는 성공적인 결과가 나올 것이고 HTML 코드를 보기 위해서 뷰 결과를 로깅한 결과를 보면 Thymeleaf 뷰 템플릿을 사용하여 만든 뷰가 HTML 코드로 렌더링 될 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/4d4f2983-a4a6-40ba-a69e-3522df88b0a3)

## @RequestBody Vs. @ModelAndAttribute

앞에서 HTML Form을 보는 URL 요청을 위한 컨트롤과 뷰 템플릿을 추가하였다면 이제는 Form에 저장한 데이터를 POST로 전송할 때 처리하는 메소드를 추가해야한다. 우리는 REST 서비스를 위한 컨트롤러를 만들 때 **RequestMethod.POST**에 관한 메소드를 구현한 적이 있다. 이 때 코드를 다시 한번 살펴보자.

```java
    @RequestMapping(value = "/api/articles", method = RequestMethod.POST)
    @ResponseBody
    public Article create(@RequestBody Article article) {
        return article;
    }
```

 이 코드를 살펴보면 POST의 요청으로 함께 받는 파라미터는 [@RequestBody](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestBody.html) 를 Article에 매핑하고 있다. 다시 말해서 이 REST URL을 요청할 때 Article에 데이터를 JSON 타입으로 전송하겠다는 의미가 된다. 그래서 우리는 이 컨트롤러 메소드를 다음과 같이 Article 객체를 JSON으로 serialized 하여 테스트를 진행하였다.

```java
    @Test
    public void testCreate() throws Exception {
        Article article = new Article();
        article.setTitle("testing create article");
        article.setContent("test content");

        Comment comment = new Comment();
        comment.setContent("test comment1");
        List<Comment> comments = new ArrayList<>();
        comments.add(comment);

        article.setComments(comments);

        String jsonString = this.jsonStringFromObject(article);

        MvcResult result = mockMvc.perform(post("/api/articles")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonString))
                .andExpect(status().isOk())
                .andExpect(content().string(equalTo(jsonString))).andReturn();

        logger.info(result.getResponse().getContentAsString());
    }
```

하지만 우리가 웹 페이지에서 FORM에 들어가는 객체를 Submit으로 전송할 때는 @RequestBody 형태로 넘어가지 않는다. @RequestBody의 요청은 Content-Type이 **application/json** 이지만 HTML 기반의 컨텐츠 타입에서 데이터를 Submit할 때는 Content-Type이 **application/x-www-form-urlencoded** 방식으로 넘어가기 때문이다. 그래서 우리는 ArticlesController에 다음 메소드를 추가한다. 이 코드는 앞에서 GET으로 FORM 을 요청할 때 HTML 뷰를 렌더링할 때 사용한 Model 안에 들어간 데이터를 POST로 받게 될 때 Model 안의 Attribute에 함께 포함된 Article객체를 받아서 매핑하게 된다. 테스트를 위해서 넘겨 받은 데이터를 결과를 HTML 형태로 보여주게 한 것이 아니라 JSON 타입으로 만들어서 반환하게 했다. 다시말해 HTML 페이지에서 FORM으로 데이터를 Submit하면 결과로 넘겨 받은 데이터를 JSON으로 반환하게 만들었다. 이 때 객체를 넘겨 받는 커텐츠의 Content-Type의 형태는 **application/x-www-form-urlencoded** 나 **multipart/form-data** 의 형태가 되어야한다.

```java
    @RequestMapping(value = "/articles", method = RequestMethod.POST)
    @ResponseBody
    public Article submit(@ModelAttribute Article article){
        return article;
    }
```

추가한 메소드에 관한 테스트를 진행해보자. ArticlesControllerTests 파일에 다음 코드를 추가한다.

```java
    @Test
    public void testSubmit() throws Exception {

        MvcResult result = mockMvc.perform(post("/articles")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .param("title", "unittest title")
                .param("content", "unittest content"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andReturn();

        logger.info(result.getResponse().getContentAsString());
    }

```

테스트 결과는 정상적으로 진행이 될 것이다. 위에서 살펴보면 이전에 @RequestBody를 테스트하기 위해서 객체를 JSON 타입으로 변경한 것과는 달리 **.param()**을 통해서 Form 파라미터를 추가하는 것을 확인할 수 있다. 또한 post()를 요청할 때 contentType이 **APPLICATION_FORM_URLENCODED** 인것을 확인할 수 있다. 실제 파라미터 데이터가 ModelAndAttribute로 매핑되는지 확인해보기 위해서 컨트롤러에 브레이크포인트를 걸고 다시 한번 테스트를 진행해보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/277207a1-f122-4b2a-97dc-0c502d5f6a3b)

컨트롤러 안에서 RequestMethod.POST 요청이 들어오면 ModelAndAttribute의 데이터를 Article 객체에 매핑되어진 것을 확인할 수 있다.

## 파일 업로드

Spring 컨트롤러에서 파일 업로드를 위한 예제는 다양하게 존재하는데 대부분 MutipartFile을 컨트롤러의 인자로 받는 예제가 많다. 즉 Model 객체에 존재하는 것이 아니라 객체와 별개로 MUltipartFile을 메소드에서 인자로 받아서 처리하는 것이다. 예를 들면 다음과 같은 코드가 될 것이다.

```java
    @RequestMapping(value = "/articles", method = RequestMethod.POST)
    @ResponseBody
    public Article submit(@ModelAttribute Article article, MultipartFile file){
        return article;
    }
```

우리는 Model 객체에 실제 객체를 포함을 시켜서 객체 형태의 코드를 관리하고 싶어한다. 예를 들어 Article 안에 파일을 가지고 있다고 말이다. 실제 객체 관점에서는 Article이 파일을 포함하고 있는 것이지 Article 따로 첨부파일 따로는 아니라는 개념이다. 그래서 우리는 Article 객체에 File을 속성을 추가해보자. 만약 Article이 포함하고 있는 Comment에 파일을 가질 수 있다면 Comment 객체 안에도 파일을 추가하면 된다. 또는 여러개의 파일을 가지고 있다면 `List<MutlipartFile>`을 추가하면 될 것이다. 우리는 JSON 타입의 결과를 받는데 MultipartFile을 JSON으로 serialization 을 할 수 없기 때문에 JSON으로 변경될 때 무시하기 위해서 **@JsonIgnore** 를 사용하였고 대신 fileName이라는 필드가 file이라는 JSON 프로퍼티로 첨부파일의 이름을 가지고 만들어질 수 있도록 **@JsonProperty("file")**로 추가하였다.

```java
package net.saltfactory.tutorial;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;
import java.util.List;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */

public class Article implements Serializable {
    private long id;
    private String title;
    private String content;
    private List<Comment> comments;

    @JsonIgnore
    private MultipartFile file;

    @JsonProperty("file")
    private String fileName;

    public String getFileName() {
        return this.file.getOriginalFilename();
    }

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

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public MultipartFile getFile() {
        return file;
    }

    public void setFile(MultipartFile file) {
        this.file = file;
    }
}

```

다음은 브라우저에서 첨부파일을 선택할 수 있도록 HTML 코드에 `<input type="file"/>` 코드를 추가한다. new.html 파일을 열어서 다음 코드를 추가한다.

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>SpringBootDemo</title>
    <meta charset="utf-8"/>
</head>
<body>
<h1>New Article</h1>

<form action="#" th:action="@{/articles}"
      th:object="${article}"
      method="post" enctype="multipart/form-data">
    <p>title: <input type="text" th:field="*{title}" /></p>
    <p>content:
        <textarea th:field="*{content}"></textarea>
    </p>
    <p>file:
        <input type="file" th:field="*{file}"/>
    </p>

    <input type="submit" value="submit" />
</form>

</body>
</html>
```

마지막으로 입력 화면으로부터 첨부파일을 추가하고 Submit을 하면 파일을 받는 컨트롤러의 메소드에서 파일을 받을 수 있는지 컨트롤러 테스트를ArticlesControllerTests 파일에서 수정한다. 테스트 코드에서는 브라우저가 없기 때문에 사람이 직접 파일을 선택하여 첨부파일을 하듯 [MockMultipartFile](http://docs.spring.io/spring-framework/docs/2.0.8/api/org/springframework/mock/web/MockMultipartFile.html)로 마치 파일을 첨부하는 것과 동일하게 만들어준다. 이 때 필드 이름이 **file**이고 파일은 단순히 문자열을 저장한 텍스트 파일로 가짜 파일을 만들었다. 그리고 MockMvc에서 **post()**로 요청했던 메소드를 **fileUpload()**로 변경하였다. post() 함수는 Content-Type 요청이 **application/x-www-form-urlencoded** 요청인데 fileUpload() 함수는 Content-Type 요청이 **multipart/form-data** 데이터이기 때문이다. 전자는 파라미터 전송은 가능하지만 파일 업로드를 할 수 없기 때문에 테스트를 진행할 때는 fileUpload() 함수를 사용해야한다. 나머지는 post() 메소드와 동일하게 param() 함수로 폼에 들어가는 파라미터를 추가한다. 이때 Model에 포함된 Article의 필드이름과 동일하게 입력해야한다.

```java
  @Test
    public void testSubmit() throws Exception {

        MockMultipartFile file = new MockMultipartFile("file", "filename.txt", "text/plain", "some xml".getBytes());

        MvcResult result = mockMvc.perform(
                fileUpload("/articles").file(file)
                .param("title", "unittest title")
                .param("content", "unittest content"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andReturn();

        logger.info(result.getResponse().getContentAsString());
    }
```

실제 파일이 전송이 되어 컨트롤러에 들어가는지 확인하기 위해서 컨트롤러 메소드에 브레이크포인트를 걸어서 확인해보자. 테스트를 진행해서 브레이크포인트를 살펴보면 다음과 같이 파일이 컨트롤러에 저장되는 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/c97d549a-80dd-43be-bcb9-e7b495d081e7)

이제 FORM을 처리하기 위한 컨트롤러, 뷰 템플릿, 단위 테스트 코드가 모두 작성되고 테스트 되었다.

## 서버 실행

이제 서버를 직접 실행하여 브라우저에서 정상적으로 동작하는지 확인해보자. Gradle Projects 패널에서 **bootRun**을 실행한다. IntelliJ가 이니라면 터미널에서 다음과 같이 실행하면 된다

```
gradle bootRun
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/7f06b464-d103-4377-a697-d24857e0c786)

브라우저를 열어서 http://localhost:8080/articles/new 로 접근해보자

![](http://asset.blog.hibrainapps.net/saltfactory/images/416dfe17-022d-410c-8c69-04c9c80b08f4)

Form이 나타나면 입력 폼에 내용을 입력하고 첨부파일도 추가가 한 후, submit을 해보자. 결과는 정상적으로 Article 객체에 포함되어 컨트롤러에 도착하여 JSON으로 결과가 반환된 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/71d6ef31-9c83-4b25-828c-ca4020662a94)

## 결론

Spring은 점점 발전하여 이제 Spring Boot를 사용하면 빠르고 쉽게 REST 서비스를 만들 수 있다. 하지만 Form 입력이나 파일 업로드를 지원하기 위해서는 기존의 Spring에서 Model을 사용하여 객체에 입력한 데이터를 전송 받을 수 있어야한다. 우리는 기존의 REST 서비스를 위해서 만든 컨트롤러에 파일 업로드를 포함한 FORM 서비스를 위한 코드를 작성하고 FORM을 위한 컨트롤러와 파일 업로드를 할 때 단위 테스트를 어떻게 하는지 살펴보았다.

다음 포스팅에서는 **RestTemplate**을 사용하여 컨트롤러에 REST과 FORM 요청을 어떻게 하는지 살펴볼 예정이다.

## 소스코드

- https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-form/SpringBootDemo

## 참고

1. http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html
2. http://docs.spring.io/spring-test-htmlunit/docs/current/reference/html5/
3. https://youtrack.jetbrains.com/issue/IDEA-132738
4. https://www.genuitec.com/spring-frameworkrestcontroller-vs-controller/
5. http://stackoverflow.com/questions/16648549/converting-file-to-multipartfile
6. http://gaabbe.win/issue/4848552/multipart-file-upload-spring-boot
7. https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html
8. https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html
