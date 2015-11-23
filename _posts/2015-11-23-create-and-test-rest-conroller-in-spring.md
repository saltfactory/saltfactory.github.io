---
layout: post
title : Spring에서 REST 서비스를 위한 컨트롤러 생성과 컨트롤러 단위테스트 하기
category : java
tags : [java, spring, springboot, rest, controller, unittest]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/770?size=full
---

## 서론

[Spring Boot](http://projects.spring.io/spring-boot/)는 Spring의 복잡한 설정을 고려하지 않고 곧바로 stand-alone Spring 어플리케이션을 개발 할 수 있도록 해준다. 복잡한 Spring 설정의 비용을 들이지 않고도 Spring 기반으로 Ruby on Rails 나 Express.js 와 같이 빠르게 [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) 서비스를 만들수 있다. 이번 포스팅에서는 복잡한 설정 없이 곧바로 Spring 기반의 기본적인 REST컨트롤러를 생성하고 REST 컨트롤러를 단위테스트하는 방법을 소개한다.

<!--more-->


## IntelliJ에서 Spring Boot 프로젝트 생성하기

아마 앞으로도 Java 프로젝트를 설명할 때 IntelliJ 소개를 계속 할 것이다. IntelliJ는 Spring 개발에 훌륭한 도구이기 때문에 반드시 사용해보길 추천한다. 앞에서 [IntelliJ 기반의 Spring Boot 웹 프로젝트 생성하기](http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html)를 참조하여 Spring Boot 프로젝트를 생성한다. 최신 Gradle과 Java를 사용하기 위해서는 [IntelliJ에서 Java와 Gradle 버전 설정하기](http://blog.saltfactory.net/java/setting-java-and-gradle-version-in-intellij.html) 글을 참조하면 된다.

IntelliJ에서 SpringBoot 프로젝트를  만들어보자. 우리는 Java 8 기준으로 프로젝트를 만들 것이다. 이 포스트를 작성할 때 가장 최근 버전은 **1.8.0_66** 이였다.

![](http://assets.hibrainapps.net/images/rest/data/824?size=full&m=1448119541)

프로젝트는 다음 설정으로 만든다.

- **Name** : SpringBootDemo
- **Type** : Gradle Project
- **Packaging** : Jar
- **Java Version** : 1.8
- **Language** : Java
- **Group** : net.saltfactory.tutorial
- **Artifact** : spring-boot-demo
- **Version** : 0.0.1-SNAPSHOT
- **Description** : Demo project for Spring Boot
- **package** : net.saltfactory.tutorial

![](http://assets.hibrainapps.net/images/rest/data/825?size=full&m=1448119678)

Spring Boot 버전은 가장 최신 안저화 버전인 **1.3.0**을 선택하고 REST 서비스를 만들기 위해서 **web**을 체크한다.

![](http://assets.hibrainapps.net/images/rest/data/826?size=full&m=1448120398)

다음은 Project가 저장될 경로를 지정한다.

![](http://assets.hibrainapps.net/images/rest/data/827?size=full&m=1448120468)

다음은 Gradle 기반의 프로젝트를 선택하였기 때문에 Gradle을 설정하는 화면이 나온다. 가장 최신 **Gradle**과 **Gravle JVM**을 설정한다.

![](http://assets.hibrainapps.net/images/rest/data/828?size=full&m=1448120604)

모든 설정이 끝나면 다음과 같은 구조로 Spring Boot 프로젝트가 만들어진다.

![](http://assets.hibrainapps.net/images/rest/data/829?size=full&m=1448121947)

Spring Boot 프로젝트의 베이스 파일은 github에서 참조할 수 있다.

https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-base/SpringBootDemo

## 테스트를 위한 데이터 YAML 파일 만들기

우리는 [Spring에서 YAML 파일 데이터 객체에 매핑하여 로드하기](http://blog.saltfactory.net/java/load-yaml-file-in-spring.html) 글에서 Spring에서 YAML 파일에 데이터를 정의하고 객체에 매핑하여 로드하는 방법을 살펴보았다. **src/resources/fixtures.yml** 파일을 다음 내용으로 생성한다.

```yaml
fixtures:
  articles:
    - id: 1
      title: title1
      content: content1
      comments:
        -
          id: 10
          articleId: 1
          content: comment11
        -
          id: 11
          articleId: 1
          content: comment12
    - id: 2
      title: title2
      content: content2
      comments:
        - id: 20
          articleId: 2
          content: comment21
        - id: 21
          articleId: 2
          content: comment22
    - id: 3
      title: title3
      content: content3
      comments:
        - id: 30
          articleId: 3
          content: comment31
        - id: 31
          articleId: 3
          content: comment32
```
다음은 Comment와 Article 파일을 각각 생성한다.

```java
package net.saltfactory.tutorial;

import java.io.Serializable;

/**
 * filename : Comment.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15
 */
public class Comment implements Serializable {
    private long id;
    private String content;
    private long articleId;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getArticleId() {
        return articleId;
    }

    public void setArticleId(long articleId) {
        this.articleId = articleId;
    }
}
```

```java
package net.saltfactory.tutorial;

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
}
```

YAML 파일을 Article의 리스트로 로드할 FixtureProperty 클래스를 생성한다.

```java
package net.saltfactory.tutorial;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.context.properties.NestedConfigurationProperty;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Filename : FixturesProperty.java
 * Author   : saltfactory<saltfactory@gmail.com>
 * Created  : 11/23/15.
 */
@Component
@ConfigurationProperties(locations = {"fixtures.yml"}, prefix = "fixtures")
public class FixturesProperty {
    private List<Article> articles = new ArrayList<>();

    public List<Article> getArticles() {
        return articles;
    }
}
```

FixturesProperty 클래스가 fixtures.yml 파일을 잘 로드하는지 테스트 파일을 만들어서 확인해보자.

```java
package net.saltfactory.tutorial;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

/**
 * filename : FixutresPropertyTest.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class FixutresPropertyTest {
    @Autowired
    private FixturesProperty fixturesProperty;

    @Test
    public void testGetArticles() {
        List<Article> articles = fixturesProperty.getArticles();
        assertThat(articles.size(), is(3));
    }

    @Test
    public void testGetCommentsByArticle() {
        List<Article> articles = fixturesProperty.getArticles();
        Article article = articles.get(0);
        List<Comment> comments = article.getComments();
        assertThat(comments.size(), is(2));
    }
}
```

## @Service 객체 만들기

우리는 간단한 REST 컨트롤러가 데이터를 처리하는 ArticlesService 객체를 만들 것이다. 실제 서비스되는 어플리케이션에서는 이 객체가 Repsitory와 서로 연관되어 많은 처리를 담당하겠지만 데모를 위한 이 객체는 FixturesProperty에서 가져온 Articles의 리스트를 복사여 목록을 반환하거나 삭제하는 기능만 추가하였다. **getArticle()**과 **deleteArticle()** 메소드 안에 리스트를 탐색하여 처리하는 작업은 Java 8의 [lamda](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html) 표현식을 사용하여 구현하였다.

```java
package net.saltfactory.tutorial;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
@Service
public class ArticlesService {
    @Autowired
    FixturesProperty fixturesProperty;

    public List<Article> getArticles() {
        List<Article> articles = new ArrayList<>(fixturesProperty.getArticles());
        return articles;
    }

    public Article getArticle(long id) {
        List<Article> articles = this.getArticles();
        Article article = articles.stream()
                .filter(a -> a.getId() == id)
                .collect(Collectors.toList()).get(0);
        return article;
    }

    public List<Article> deleteArticle(long id) {
        List<Article> articles = this.getArticles();
        articles.removeIf(p -> p.getId() == id);
        return articles;
    }
}
```

ArticlesService 객체를 만들고 난 뒤 데이터를 바로 처리하는지 테스트 클래스를 만들어서 확인해보자.

```java
package net.saltfactory.tutorial;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class ArticlesServiceTest {

    @Autowired
    ArticlesService articlesService;

    @Autowired
    FixturesProperty fixturesProperty;

    @Before
    public void setUp() throws Exception {

    }

    @Test
    public void testGetArticles() throws Exception {
        List<Article> articles = articlesService.getArticles();
        assertThat(articles, is(notNullValue()));
        assertThat(articles.size(), is(3));
    }

    @Test
    public void testGetArticle() throws Exception{
        long id = 1;
        Article article = articlesService.getArticle(id);

        List<Article> articles = fixturesProperty.getArticles();
        Article demoArticle = articles.stream()
                .filter(a -> a.getId() == id)
                .collect(Collectors.toList()).get(0);

        assertThat(article.getId(), is(equalTo(demoArticle.getId())));
    }

    @Test
    public void testDeleteArticle() throws Exception {
        long id = 1;
        List<Article> demoArticles = new ArrayList<>(fixturesProperty.getArticles());
        List<Article> articles = articlesService.deleteArticle(id);
        assertThat(articles.size(), not(demoArticles.size()));
    }
}
```

![](http://assets.hibrainapps.net/images/rest/data/839?size=full&m=1448252288)

테스트를 실행하면 ArticlesService의 메소드들이 모두 정상적으로 처리를 하고 있는 것을 확인할 수 있다.

## REST 서비스를 위한 Controller 생성

이제 가장 중요한 Controller를 생성해보자. REST 서비스는 URL에서 리소스를 표현하면서도 기능을 처리하도록 하는 것이 중요하다.

우리는 REST 서비스 형태의 URL을 다음과 같이 정의한다.


| 메소드 | URL 패턴 | 설명 |
|----|----|----|
| GET | /api/articles/ | Articles 전체 목록을 표현 |
| GET | /api/articles/{id} | id 값을 가지는 Article을 표현 |
| POST | /api/articles | 새로운 Article을 저장 |
| PATCH/PUT | /api/articles/{id} | id 값을 가지는 Article을 업데이트 |
| DELETE | /api/articles/{id} | id 값을 가지는 Article을 삭제 |

## GET /api/articles

글 목록을 가져오는 **/api/articles**를 처리하기 위한 메소드를 추한다. 아무런 URL 없이 단순히 /api/articles 요청을 처리하기 위해서 **index()**라는 메소드로 이름 붙였다. Ruby on Rails에서 REST URL이 컨트롤러의 액션(메소드) 이름을로 만들어지는 것과 달리 [@RequestMapping](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html)으로 메소드 이름과 달리 URL이 들어오는 패턴을 메소드와 매핑 시킨다. [@ResponseBody](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-responsebody)는 컨트롤러에서 데이터를 응답을 줄 때 객체를 [HttpMessageConverter](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/remoting.html#rest-message-conversion)를 사용하여 ResponseBody에 자동으로 JSON 형태의 컨텐츠로 변환하여 반환한다. 예전 Spring에서는 객체를 직접 JSON으로 serialization을 해서 반환하였지만 이제 프레임워크 레벨에서 자동으로 처리할 수 있게 된 것이다. 우리는 단지 객체를 리턴하기만하면 클라이언트에서 JSON 으로 받을 수 있다.

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
}
```

컨트롤러를 테스트하는 테스트 클래스를 만들어서 테스트를 해보자. Spring에서 다른 테스트와 달리 컨트롤러 테스트는 몇가지 설정을 해야한다. 컨트롤러는 사용자의 HTTP request를 처리하고 HTTP response를 반환하는 객체이기 때문에 이를 테스트하기 위해서는 웹 서버가 동작해야하고 요청과 반환을 담당하는 HttpServletRequest/HttpServletResspone 를 직접 구현해야한다. 실제 이전 Spring 프레임워크에서 Mock 서버를 동작해서 복잡한 코드를 추가해서 컨트롤러를 테스트를 했었던 기억이 난다. 하지만 이젠 그렇게 복잡하던 컨트롤러 테스트가 매우 간단해졌다. [MockMvc](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/MockMvc.html)를 사용하면 아주 간단하게 URL요청을 GET,POST,PUT,PATCH,DELETE와 같은 REST 형태로 요청을 테스트할 수 있다. 자세한 내용을 [Unit Testing](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/unit-testing.html) 글을 참조한다.

```java
package net.saltfactory.tutorial;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.Logger;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import java.util.List;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

/**
 * Created by saltfactory<saltfactory@gmail.com> on 11/21/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class ArticlesControllerTest {

    Logger logger = Logger.getLogger(this.getClass());

    private MockMvc mockMvc;

    @Autowired
    private ArticlesController articlesController;

    @Autowired
    private ArticlesService articlesService;

    @Before
    public void setUp() throws Exception {
        mockMvc = standaloneSetup(articlesController).build();
    }

    private String jsonStringFromObject(Object object) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(object);
    }

    @Test
    public void testIndex() throws Exception {
        List<Article> articles = articlesService.getArticles();
        String jsonString = this.jsonStringFromObject(articles);

        mockMvc.perform(get("/api/articles"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(content().string(equalTo(jsonString)));
    }
}
```

위 테스트를 진행하면 마치 Spring 어플리케이션에 **/api/articles** Http 요청을 한 것과 동일한 테스트를 진행하게 된다. 만약 정상적으로 컨트롤러가 요청을 받아서 처리하고 다시 Http 응답을 돌려준다면 **status().isOk()**가 나올 것이다. 또한 response의 컨텐트 타입은 컨트롤러에서 @ResponseBody를 사용하여 만들어진 리턴객체를 포함하고 있기 때문에 JSON 타입으로 응답이 온다. 컨텐츠 내용을 확인할 때는 JSON 문자열로 결과가 올 것이기 때문에 JSON Mapper를 사용하여 객체를 JSON 문자열로 만들어서 response의 컨텐츠 문자열과 비교한다.

![](http://assets.hibrainapps.net/images/rest/data/840?size=full&m=1448254945)

만약 response의 문자열을 로깅하고 싶을 경우는 [MvcResult](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/MvcResult.html)를 사용하여 로깅을 할 수 있다.

```java
    @Test
    public void testIndex() throws Exception {
        List<Article> articles = articlesService.getArticles();
        String jsonString = this.jsonStringFromObject(articles);

        MvcResult result = mockMvc.perform(get("/api/articles"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(content().string(equalTo(jsonString)))
                .andReturn();

        logger.info(result.getResponse().getContentAsString());
    }
```

테스트를 실행하면 결과로 컨트롤러로 부터 받은 response의 content 의 JSON 문자열을 로깅으로 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/841?size=full&m=1448255255)

## GET /api/articles/{id}

REST 서비스에서 리소스의 단일 정보를 표현하는 URL 패턴으로 리소스 뒤에 {id}를 가지고 처리하는 패턴을 사용한다. ArticlesController에서 다음 메소드를 추가한다. 위에서 /api/articles 요청을 처리하기 위한 index() 메소드와 거의 동일하다. 실제 서비스에서는 메소드 내 복잡한 로직이 서로 다르겠지만 Http Request를 받아들이고 결과를 @ResponseBody로 리턴하는 것은 동일하다. 한가지 다른 것은 하나의 리소스의 아이템을 지정하기 위해서 [@PathVariable](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/PathVariable.html)을 인자값으로 받아 들이고 있다는 것이다. 이것은 URL 패턴에 정의한 {id} 인터폴레이션의 값을 URL의 변수로 판단하여 지정한 타입으로 매핑하는 것이다.

```java
    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Article show(@PathVariable(value = "id") long id) {
        return articlesService.getArticle(id);
    }
```

테스트 컨트롤러에 testShow() 메소드를 추가하여 테스트를 진행해보자. 우리는 테스트를 위해 fixtures.yml 파일에 준비한 데이터 중에서 id 값이 1인 Article을 조회하는 요청을 테스트로 진행한다.

```java
    @Test
    public void testShow() throws Exception {
        long id = 1;
        Article article = articlesService.getArticle(id);
        String jsonString = this.jsonStringFromObject(article);

        mockMvc.perform(get("/api/articles/{id}", id))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(content().string(equalTo(jsonString)));
    }
```

테스트를 실행 후 결과를 살펴보면 녹색으로 정상적으로 처리된 것을 확인할 수 있다. 필요에 따라서 로깅을 하여 응답 결과를 로깅으로 확인할 수도 있다.

![](http://assets.hibrainapps.net/images/rest/data/842?size=full&m=1448257752)

## POST /api/articles

REST에서 POST 메소드를 지원하는 것은 대부분 write 기능을 서비스하는 것이다. 여기에는 중요한 보안 이슈가 있기 때문에 OAuth2와 같은 인증을 같이 처리하는 것이 좋다. 하지만 이 글에서는 단순하게 새로운 Article의 내용을 POST로 전송하여 서버에 정상적으로 전송이 되는 것만을 확인한다. POST로 받은 객체를 POJO에 매팽하고 그것을 다시 @ResponseBody로 응답해주는 간단한 코드이다. 이후에 인증을 처리하는 것을 다시 소개할 예정이다. ArticlesController에 다음 메소드를 추가한다. 앞에서 추가한 메소드와 달리 이 메소드는 [RequestMethod.POST](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMethod.html#POST)를 매핑하고 있다. 앞에서 index() 메소드와 URL 패턴을 동일하지만 **RequestMethod.GET**과 **RequestMethod.POST**의 차이로 기능을 다르게 처리할 수 있다. 이런 부분이 바로 REST 서비스의 특징이다. 한가지 주의해서 볼 것은 [@ReqestBody](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestBody.html)라는 것이다. API를 살펴보면 @RequestBody는 @ResponseBody와 동일한 형태의 어노테이션을 가지고 있고  HttpMessageConverter 를 사용하여 JSON을 처리한다. 즉, 클라이언트에서 이 REST URL로 Article을 저장하기 위해서 새로운 Article을 전송할 때 Http Request의 Body에 JSON 타입으로 데이터가 넘어오게 되는 것이고, 컨트롤러에서 @RequestBody를 사용하여 JSON을 객체로 매핑하게 되는 것이다.

```java
    @RequestMapping(value = "/api/articles", method = RequestMethod.POST)
    @ResponseBody
    public Article create(@RequestBody Article article) {
        return article;
    }
```

POST를 처리하기 위한 컨트롤르를 테스트하기 위해서 다음과 같이 ArticlesControllerTest에 testCreate() 메소드를 추가한다. 새로운 Article을 서버로 POST로 요청하는 것이다. 이 때 Comment리스트 구조를 초함하고 있는 Article 의 데이터가 서버로 바르게 전송되는지 테스트를 하기 위해서 새로운 Article에 새로운 Comment를 포함한 List를 추가하한다.

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

JSON 타입으로 데이터를 POST로 REST 요청을 할 때 서버에 제대로 전송이 되어 지정한 Article 타입에 매핑되는지 확인하기 위해서 컨트롤러에서 브레이크 포인트를 지정하여 요청 중 클래스 내부를 살펴보자.

![](http://assets.hibrainapps.net/images/rest/data/843?size=full&m=1448259664)

컨트롤러에서 JSON 타입의 Http Request가 요청이 들어올 대 **@RequestBody**를 사용하여 객체로 바로 매핑을 되는 것을 확인할 수 있다.

## PATCH /api/articles/{id}

이전에는 REST 서비스에서 리소스 업데이트 요청을 하기 위해서 [PUT](https://tools.ietf.org/html/rfc2616#section-9.6) 메소드를 사용하였는데, 최근에는 부분 업데이트 개념으로 [PATCH](http://tools.ietf.org/html/rfc5789)를 많이 사용한다. PUT은 전체 리소스를 변경할 때 사용하는 것이고 PATCH는 부분 변경을 사용할 때 사용( https://restful-api-design.readthedocs.org/en/latest/methods.html#patch-vs-put )한다고 정의하지만 PATCH가 PUT을 포함하고 있기 때문에 Ruby on Rails에서도 정식으로 PATCH를 사용하여 업데이트가 이루어지고 있고, Spring에서도 [RequestMethod.Patch](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMethod.html#PATCH)를 사용하여 REST 요청을 받을 수 있다. ArticlesController에 PATCH와 PUT의 요청을 처리하는 메소드를 다음과 같이 추가한다. 두 메소드 모두 해당하는 Article id를 @PathVariable로 URL에서 받아오며 @RequestBody로 JSON 형태로 업데이트된 내용을 객체로 매핑하게 된다.

```java
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
```

테스트를 위해 ArticlesControllerTest에 테스트 메소드를 추가한다.

```java
    @Test
    public void testPatch() throws Exception {
        long id = 1;
        Article article = articlesService.getArticle(id);
        article.setTitle("testing create article");
        article.setContent("test content");

        String jsonString = this.jsonStringFromObject(article);

        MvcResult result = mockMvc.perform(patch("/api/articles/{id}", id)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonString))
                .andExpect(status().isOk())
                .andExpect(content().string(equalTo(jsonString))).andReturn();

        logger.info(result.getResponse().getContentAsString());
    }

    @Test
    public void testUpdate() throws Exception {
        long id = 1;
        Article article = articlesService.getArticle(id);
        article.setTitle("testing create article");
        article.setContent("test content");

        String jsonString = this.jsonStringFromObject(article);

        MvcResult result = mockMvc.perform(put("/api/articles/{id}", id)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonString))
                .andExpect(status().isOk())
                .andExpect(content().string(equalTo(jsonString))).andReturn();

        logger.info(result.getResponse().getContentAsString());
    }
```

테스트를 진행할 때 ArticlesController의 patch() 메소드 안에 브레이크 포인트를 추가하여 PATCH 요청을 처리할 때의 객체를 탐색해보기로 한다. 테스트를 위해서 Article id가 1인 객체를 JSON body로 Patch 요청을 하였고 컨트롤러에서 @RequestBody로 요청한 JSON을 해당 객체로 매핑한 것을 살펴볼 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/844?size=full&m=1448261461)

우리는 테스트에서 Http Request를 요청할 때 REST 요청으로 **PATCH** 를 정상적으로 요청했는지 살펴보기 위해서 컨트롤의 브레이크포인트 시점에서 클래스 내부를 좀 더 탐색하기로 한다. **NativeMethodAccessoryImpl**에서 HTTP Request PATCH의 요청을 Spring 내부에서 "method"를 "patch"로 매핑한 것을 살펴볼 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/845?size=full&m=1448261474)

PUT에 관련된 테스트를 진행하여도 동일하게 처리되는 것을 확인할 수 있을 것이다.

## DELETE /api/articles/{id}

REST에서 DELETE의 요청은 해당하는 리소스를 삭제하는 요청이다. ArticlesController에 **RequestMethod.DELETE** 요청을 처리하기 위한 메소드를 추가한다. 예제는 간단하다. 해당하는 id를 가지고 articlesService.deleteArticle() 메소드를 통해 리스트에서 해당 Article을 삭제하고 나머지 List를 다시 @ResponseBody를 통해 JSON으로 결과를 반환하는 내용을 포함하고 있다.

```java
    @RequestMapping(value = "/api/articles/{id}", method = RequestMethod.DELETE)
    @ResponseBody
    public List<Article> destroy(@PathVariable(value = "id") long id) {
        return articlesService.deleteArticle(id);
    }
```

테스트를 위해 ArticlesControllerTest에 테스트 메소드를 추가한다. HTTP로 DELETE 요청을 처리하고 반환되는 JSON이 Article List의 해당 article을 삭제한 이후의 List와 JSON의 내용이 같은지 테스트를 한다.

```java
    @Test
    public void testDestroy() throws Exception {
        long id = 1;
        List<Article> articles = articlesService.deleteArticle(id);
        String jsonString = this.jsonStringFromObject(articles);

        mockMvc.perform(delete("/api/articles/{id}", id)
                .content(jsonString))
                .andExpect(status().isOk())
                .andExpect(content().string(equalTo(jsonString)));
    }
```

테스트를 진행한 이후 실제 List에서 article을 삭제한 결과와 JSON이 일치하면 테스트가 성공적으로 끝나게 될 것이다.

## 단위 테스트 일괄적으로 테스트

단위 테스트는 하나의 메소드로 작은 테스트부터 시작해서 클래스 테스트 전체 테스트로 Test Suit로 만들어서 테스트를 진행할 수도 있다. 또는 Gradle을 사용하여 모든 테스트를 진행할 수도 있다. IntelliJ를 사용한다면 **Gradle projects** 패널을 열어서 **build setup > init**을 실행한 뒤  **verfication > test**를 선택하게 되면 모든 테스트를 일괄적으로 진행한다.

![](http://assets.hibrainapps.net/images/rest/data/846?size=full&m=1448262997)

## 결론

Spring으로 REST 서비스를 만들 때는 Ruby on Rails 만큼의 빠르게 자동으로 라우팅과 컨트롤러, 테스트를 만들 수 없지만 Spring Boot를 사용하면 일반적인 Spring으로 컨트롤러를 만들어서 테스트하는 것보다 빠르게 REST 서비스를 만들 수 있다. 컨트롤를 개발해서 만들 때는 단위테스트를 어떻게 진행해야할지 몰라서 컨트로러를 만든 후 Spring 어플리케이션을 서버로 실행해서 브라우저에서 HTTP 요청을 처리하는 일은 하지말자. 물론 이런 테스트도 진행해야 하지만 개발 단계에서는 **MockMvc**로 이런 작업과 동일하게 할 수 있다. 모든 단위 테스트가 끝나면 서버에 배포하기 전에 실제 브라우저나 클라이언트 프로그램으로 REST 요청이 잘 처리되는지 한번만 확인을 하면된다. 컨트롤러를 개발할 때 서버를 실행시키고 브라우저에서 URL을 요청한뒤 컨트롤러 내부에 System.out.println를 찍어가면서 디버깅을 한다면 개발 속도는 느릴 뿐만 아니라 완벽한 디버깅을 할 수 없어서 오류가 발생하기 마련다. IntelliJ를 사용하다면 IDE가 제공하는 편리한 툴을 기능을 익히면 좋다. gradle의 빌드나 breakpoint가 그런 것이다. 버튼 하나를 눌리면 여러가지 복잡한 일을 한번에 처리할 수 도 있다. REST 서비스를 만들기 위해서 더 복잡하고 더 다양한 일을 처리해야한데 기본적으로 REST 컨트롤러를 만들 줄 알아야하고, 이것을 어떻게 단위테스르로 확인할 수 있는지 선행학습을 해야 복잡하고 다양한 REST 요청을 처리할 수 있을 것이다.

다음 글에서는 Spring의 RestTemplate을 사용하여 REST 요청을 처리하는 것과 Form 요청을 처리한는 것에서 살펴볼 예정이다.

## 소소코드

- https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-rest/SpringBootDemo

## 참조

1. http://blog.saltfactory.net/java/load-yaml-file-in-spring.html
2. http://docs.spring.io/spring/docs/current/spring-framework-reference/html/integration-testing.html
3. https://spring.io/guides/gs/serving-web-content/
4. http://thswave.github.io/java/2015/03/02/spring-mvc-test.html
5. http://flystone.tistory.com/196
6. http://zeroturnaround.com/rebellabs/java-8-explained-applying-lambdas-to-java-collections/
7. http://apieceofmycode.blogspot.kr/2014/07/spring-integration-testing-under-spring.html

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
