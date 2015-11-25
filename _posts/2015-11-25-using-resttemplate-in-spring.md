---
layout: post
title : Spring에서 RestTemplate을 사용하여 REST 기반 서비스 요청과 테스트하기
category : java
tags : [java, spring, springboot, rest, resttemplate]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/770?size=full
---

## 서론

우리는 며칠간에 걸쳐 Spring Boot로 Spring 기반 REST 서비스와 템플릿 뷰를 사용하여 Multipart Form data를 사용하기 위한 컨트롤러를 구현하는 방법을 살펴보았다. 또한 컨트롤러를 테스트하기 위해서 **MockMvc**를 사용하여 짧은 코드로 간단하게 Spring 테스트 프레임워크에서 URL을 요청하여 컨트롤러를 테스트하는 방법도 살펴보았다.

Spring 기반 프로젝트를 진행하면 컴포넌트 내부에서 URL을 요청해야하는 경우가 있다. 이전에는 Apache의 [HttpClient](https://hc.apache.org/httpcomponents-client-ga/) 라이브러리를 포함시켜 Http Request를 컴포넌트 내부에서 사용했지만 최근 Spring에서는 Http Request 요청을 간단하게 사용할 수 있도록 [SpringTemplate](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html)라는 모듈을 포함하고 있다. 이번 포스팅에서는 **RestTemplate**을 사용하여 Spring 안에서 **GET**, **POST**, **PUT**, **PATCH**, **DELETE** REST 요청을 처리하는 방법을 살펴본다.

<!--more-->

## 데모를 위한 프로젝트 생성

우리는 앞에서 [spring-boot-rest](https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-form) 소스 코드에 REST 서비스를 위한 컨트롤러에 대한 예제 코드를 만들었다. 만약 이 글을 처음 보고 있다면 앞의 [Spring에서 REST 서비스를 위한 컨트롤러 생성과 컨트롤러 단위테스트 하기](http://blog.saltfactory.net/java/create-and-test-rest-conroller-in-spring.html)  글을 참조하여 RestTemplate 테스트를 하기 위한 REST 서비스를 위한 컨트롤러를 먼저 만들자.

## @WebIntegrationTest 로 RestTemplate 사용하기

우리는 앞에서 컨트롤러를 만들고 단위 테스트를 할 때 **MockMvc**를 사용하였다. MockMvc는 말 그대로 가짜 웹 서버와 Http request 만들어서 테스트하는 것이다. [@WebIntegrationTest](http://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/WebIntegrationTest.html)는 웹 서비스를 다르게 테스트할 수 있는 방법을 제시하고 있다. **@WebIntegrationTest**는 [@WebAppConfigration](http://docs.spring.io/spring-framework/docs/3.2.0.BUILD-SNAPSHOT/api/org/springframework/test/context/web/WebAppConfiguration.html)과 [@IntegrationTest](http://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/IntegrationTest.html)가 통합되어 만들어진 것으로 Web Application을 설정과 실제 웹 서버를 동작하여 테스트를 하는 것과 같이 테스트를 할 수 있는 방법을 제공하고 있다.

우리는 **RestTemplate**에 관한 테스트를 진행할 것이기 때문에 앞에서 **ArticlesControllerTests** 파일을 참조하여 **src/test/{패키지명}/RestTemplateTests.java** 파일을 다음과 같이 만들자.

**@WebIntegrationTest("server.port=0")** : 테스트를 위해서 동작하는 웹 서버 포트 번호를 지정할 수 있는데 이 값이 **0**이면 랜덤으로 테스트를 할 때 지정하여 동작하게 된다. 이 때 지정된 포트번호는 `@Value("{local.server.port}") int port;`  형태로 injection으로 값을 가져올 수 있다. WebIntegrationTest 방법으로 테스트를 진행할 때는 실제 테스트를 위한 웹 서버가 동작하는 것이기 때문에 서버에 접근할 수 있는 URL이 필요하다. 우리는 포트번호를 랜덤하게 정하였기 때문에 기본적으로 URL을 만들기 위해서 `String baseUrl`변수를 만들었고 이것은 테스트가 진행할 때 `@before` 테스트 시작 전에 포트번호를 가지고 URL의 앞부분을 만들 것이다. 예를 들면 http://localhost:81268 와 같은 식으로 만들어지는 것이다. 그리고 우리는 웹 서버에 접근하여 Http Request를 요청하는 것을 **RestTemplate**으로 사용할 것이기 때문에 테스트 전에 객체를 생성하도록 하였다.

```java
package net.saltfactory.tutorial;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.Logger;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.*;
import org.springframework.http.*;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsEqual.equalTo;

/**
 * filename : RestTemplateTests.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/25/15
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
@WebIntegrationTest("server.port=0")
public class RestTemplateTests {

    Logger logger = Logger.getLogger(this.getClass());

    @Value("${local.server.port}")
    int port;

    @Autowired
    ArticlesService articlesService;

    private String baseUrl;
    RestTemplate restTemplate;

    @Before
    public void setUp() {
        restTemplate = new RestTemplate();
        baseUrl = "http://localhost:" +  String.valueOf(port);
    }

    private String jsonStringFromObject(Object object) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(object);
    }
}

```

이제 **RestTemplate**을 사용하여 우리가 만든 REST 웹 서비스의 컨트롤러에 Http 요청을 해보자.

## GET /api/articles

MockMvc를 사용하여 테스트한 코드를 먼저 살펴보자.

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

이제 RestTemplate을 사용하여 실제 웹 서버로 GET 요청을 해보자. RestTemplate으로 Http GET 요청을 하는 방법는 여러가지가 있는데 크게 다음가 같다.

- **restTemplate.getForObject()** : 기본 Http Header를 사용며 결과를 객체로 반환 받는다.
- **restTemplate.getForEntity()** : 기본 Http Header를 사용하며 결과를 Http ResponseEntity로 반환 받는다.
- **restTemplate.exchange()** : Http Header 를 수정할 수 있고 결과를 Http ResponseEntity로 반환 받는다.
- **restTemplate.execute()** : Request/Response 콜백을 수정할 수 있다.

다음 예제는 http://localhost:{port}/api/articles 로 RestTemplate을 사용하여 **HttpMethod.GET** 요청을 하는 테스트이다. 이 때 결과 반환값을 JSON 문자열로 받고 싶어서 결과 반환 값을 **String.class**로 지정하였다. **restTemplate.getForObject(uri,반환될 객체 타입)** 으로 보면 된다. RestTemplate의 HttpMethod.GET의 결과를 확인하기 위해서 로깅을 해보았다. 만약 RestTemplate가 웹 서버에 정상적인 요청을 했다면 Articles의 List 타입이 JSON으로 만들어져 보일것이다. 컨트롤러를 요청한 결과과 맞는지 확인하기 위해서 ArticlesService.getArticles()로 가져오는 결과와 비교했다.

```java
@Test
public void testIndex() throws Exception {

    URI uri = URI.create(baseUrl+ "/api/articles");
    String responseString = restTemplate.getForObject(uri, String.class);

    // 컨트롤러 결과를 로깅
    logger.info(responseString);

    // 컨트롤러 결과를 확인하기 위한 데이터 가져오기
    List<Article> articles = articlesService.getArticles();
    String jsonString = jsonStringFromObject(articles);

    // 컨트롤러의 결과와 JSON 문자열로 비교
    assertThat(responseString, is(equalTo(jsonString)));
}
```

RestTemplate.getForObject()로 HttpMethod.GET을 요청한 결과는 정상적이고 컨트롤르에서 반환한 JSON을 로깅을 통해서 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/858?size=full&m=1448437139)

RestTemplate을 사용하여 API 서버에서 JSON 문자열로 반환받게 되면 우리는 이것을 어플리케이션에서 객체 타입으로 다시 JSON 라이브러리를 사용하여 POJO 객체로 변환하는 작업을 할 것이다. 하지만 RestTemplate은 이런 과정을 자동으로 할 수 있다. 우리는 테스트를 위해서 반환 타입을 String.class로 지정하였지만 만약 API를 요청한 결과를 객체에 매핑한 Article 형태로 받고 싶다면 반환 타입에 객체 타입을 지정하면 자동으로 JSON 결과를 객체로 매핑해서 반환해준다.

위 테스트를 다음과 같이 수정해보자.

```java
@Test
public void testIndex() throws Exception {

    URI uri = URI.create(baseUrl+ "/api/articles");
//  String responseString = restTemplate.getForObject(uri, String.class);
    List<Article> resultArticles = Arrays.asList(restTemplate.getForObject(uri, Article[].class));

// 컨트롤러 결과를 로깅
//  logger.info(responseString);

// 컨트롤러 결과를 확인하기 위한 데이터 가져오기
    List<Article> articles = articlesService.getArticles();
//  String jsonString = jsonStringFromObject(articles);

// 컨트롤러의 결과와 JSON 문자열로 비교
//  assertThat(responseString, is(equalTo(jsonString)));
    assertThat(resultArticles.size(), is(equalTo(articles.size())));
    assertThat(resultArticles.get(0).getId(), is(equalTo(articles.get(0).getId())));
}
```
브레이크 포인트를 가지고 RestTemplate가 컨트롤러에서 반환한 결과를 살펴보자.

![](http://assets.hibrainapps.net/images/rest/data/859?size=full&m=1448437993)

restTemplate.getObjectFor()에 반환되는 객체의 타입을 지정하면 JSON을 자동으로 반한되는 객체로 매핑해주는 것을 확인할 수 있다.

## POST /api/articles

앞에서 우리는 REST 서비스를 위한 컨트롤러에서 @RequestBody를 사용하여 객체를 JSON 타입으로 **HttpMethod.POST**를 보내는 것을 만들고 테스트를 통해 확인하였다. 먼저 MockMvc를 통해 테스트한 코드를 살펴보자. MockMvc 테스트를 통해서 보면 알 수 있듯 post() 요청을 할 때 content() 안에 Article 객체를 JSON 타입으로 변환해서 전송하는 것을 확인할 수 있다.

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

이제 RestTemplate으로 실제 웹 서비스 형태로 테스트를 해보자. RestTemplate에서 POST를 요청하는 방법는 위에서 GET을 요청하는 방법과 비슷하다. 다만 getFor 로 시작하는 것을 postFor 로 바꿔주면 된다. 나머지는 동일하다.

- **restTemplate.postForObject()**
- **restTemplate.postForEntity()**
- **restTemplate.exchange()**
- **restTemplate.execute()**

MockMvc에서 가짜로 테스트하는 것과 달리 RestTemplate를 사용하여 실제 서버로 객체를 POST로 보낼 때는 Article의 객체를 그대로 넘겨주면 된다. 아주 간단하다.

```java
@Test
public void testCreate() throws Exception {

  URI uri = URI.create(baseUrl + "/api/articles");

  Article article = new Article();
  article.setTitle("testing create article");
  article.setContent("test content");

  Comment comment = new Comment();
  comment.setContent("test comment1");
  List<Comment> comments = new ArrayList<>();
  comments.add(comment);

  article.setComments(comments);

  Article resultArticle = restTemplate.postForObject(uri, article, Article.class);

  assertThat(resultArticle.getTitle(), is(equalTo(article.getTitle())));


//        String responseString = restTemplate.postForObject(uri, article, String.class);
//        String jsonString = jsonStringFromObject(article);
//
//        assertThat(responseString, is(equalTo(jsonString)));
//        logger.info(responseString);
    }
```

테스트를 진행하면 성공적으로 새로운 Article이 POST로 전송되는 것을 확인할 수 있다. 하지만 한가지 중요한 조건이 있다. 이 때 웹 서버의 컨트롤러에서 이 POST 요청이 매핑되는 곳에서 Article 객체를 매핑하기 위해서는 반드시 **@RequetBody** 요청으로 되어 있어야 한다는 것이다. 다시 한번 서버에서 POST의 컨트롤러 코드를 살펴보자.

```java
@RequestMapping(value = "/api/articles", method = RequestMethod.POST)
@ResponseBody
public Article create(@RequestBody Article article) {
    return article;
}
```

나중에 다시 설명하겠지만 POST로 Article의 새로운 값을 받기 위해서 **@ModelAndAttribute**를 사용하는 것이 아니라 **@RequestBody**로 POST로 들어오는 객체를 매핑해야한다.

## DELETE /api/articles/{id}

다음은 **HttpMethod.DELETE**의 경우 RestTemplate에서 처리하는 방법을 살펴보자. 위에서 우리는 GET과 POST 요청을 할 때의 네이밍 규칙을 보고 DELETE 요청을 처리하기 위해서 restTemplate.deleteForObject() 라고 코드를 생각할지 모르지만 이것은 잘 못된 생각이다. RestTemplate에서 DELETE와 PUT에 관한 요청은 반환값을 가지지 않을 뿐만 아니라 파라미터 전송도 없다. 하지만 크게 당황하지 않아도 된다. 컨트롤러에서 반환값을 갖기 위해서는 template.exchange()를 사용하면 된다. 만약 반환값에 상관없이 단순하게 DELETE 요청을 할 때는 template.delete()을 사용하여 요청하면 된다.

- **restTemaplate.delete()**
- **restTemplate.exchange()**
- **restTemplate.execute()**

relateTemplate을 사용하여 HttpMethod.DELETE 요청을 처리하는 방법은 다음과 같다. 주석이 되어 있는 부분은 요청 후 반환값이 없을 때 간단하게 사용할 수 있는 방법이다.

만약 DELETE 요청 후 반환값이 필요하면 restTemplate.exchange()로 요청하면 되는데 이 것은 앞에서 restTemplate을 사용하는 방법과 달리 **HttpHeaders**와 **HttpEntity**를 사용하여 요청을 보내는 것을 확인할 수 있다. 그리고 exchange() 메소드에서 **HttpMethod.DELETE**를 보낸다고 method의 타입을 지정하는 것도 알 수 있단. 이유는 exchange()는 말 그대로 사용자가 직접 전달하는 것을 정의하여서 보내는 것이기 때문에 모둔 HttpMethod에서 동일하게 사용할 수 있는 방법이다.

```java
@Test
public void testDelete() throws Exception {

    long id = 1;
    URI uri = URI.create(baseUrl + "/api/articles/" + id);

//        Article article = articlesService.getArticle(id);
//        restTemplate.delete(uri);

    HttpHeaders headers = new HttpHeaders();
    HttpEntity entity = new HttpEntity(headers);

    ResponseEntity<String> responseEntity = restTemplate.exchange(uri, HttpMethod.DELETE, entity, String.class);

    String jsonString = jsonStringFromObject(articlesService.deleteArticle(id));

    assertThat(responseEntity.getStatusCode(), is(HttpStatus.OK));
    assertThat(responseEntity.getBody(), is(equalTo(jsonString)));

    logger.info(responseEntity.getBody());
}
```

## PUT /api/articles/{id}

**HttpMethod.PUT**의  요청 또한 위의 **HttpMethod.DELETE**의 방법과 동일하다 단지 PUT은 데이터를 업데이트하기 위한 요청을 하기 때문에 객체를 함께 보내는 것이 다르다. 이 때 주의할 점은 객체를 보낼 때 **HttpEntity**에 header와 함께 보내는 것을 주의한다.

```java
@Test
public void testPut() throws Exception {
    long id = 1;

    URI uri = URI.create(baseUrl + "/api/articles/" +id);

    Article article = articlesService.getArticle(id);
    article.setTitle("testing create article");
    article.setContent("test content");

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);

    HttpEntity<Article> entity = new HttpEntity(article, headers);

    ResponseEntity<String> responseEntity = restTemplate.exchange(uri, HttpMethod.PUT, entity, String.class);

    String jsonString = jsonStringFromObject(article);

    assertThat(responseEntity.getStatusCode(), is(HttpStatus.OK));
    assertThat(responseEntity.getBody(), is(equalTo(jsonString)));
}
```

## PATCH /api/articles/{id}

우리는 앞에서 컨트롤러를 만들 때 **PATCH** 는 **PUT**과 유사하다고 말했다. 그래서 RestTemplate으로 PUT을 보내는 방법고 동리하게 하며 exchange()에서 method를 **HttpMethod.PATCH**로 변경하면 될 것이라 생각하기 쉽다. 하지만 안타깝게 기본적으로 RestTemplate은 [POST, GET, PUT, DELETE, OPTIONS](http://www.springframework.net/rest/doc-latest/reference/html/resttemplate.html) 만 제공한다. 그래서 만약 이렇게 코드를 작성하면 다음과 같은 에러를 보게 된다.

```java
@Test
public void testPatch() throws Exception {
    long id = 1;

    URI uri = URI.create(baseUrl + "/api/articles/" +id);

    Article article = articlesService.getArticle(id);
    article.setTitle("testing create article");
    article.setContent("test content");

    HttpHeaders headers = new HttpHeaders();
    HttpEntity<Article> entity = new HttpEntity(article, headers);

    ResponseEntity<String> responseEntity = restTemplate.exchange(uri, HttpMethod.PATCH, entity, String.class);

    String jsonString = jsonStringFromObject(article);

    assertThat(responseEntity.getStatusCode(), is(HttpStatus.OK));
    assertThat(responseEntity.getBody(), is(equalTo(jsonString)));
}
```
위 코드를 실행하면
> org.springframework.web.client.ResourceAccessException: I/O error on PATCH request for "http://localhost:56447/api/articles/1":Invalid HTTP method: PATCH; nested exception is java.net.ProtocolException: Invalid HTTP method: PATCH

에러를 보게 된다. 이것은 RestTemplate이 기본적으로 **PATCH** 메소드를 지원하고 있지 않기 때문이다.

![](http://assets.hibrainapps.net/images/rest/data/860?size=full&m=1448440202)

RestTemplate은 **ClientHttpRequest** 감싸고 있는 모듈인데 기본적으로 [SimpleClientHttpRequestFactory](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/http/client/SimpleClientHttpRequestFactory.html)로 만들어져 있다. 우리는 [Apache HttpComponents HttpClient](http://hc.apache.org/httpcomponents-client-ga/)를 만들 때 사용하는 [HttpComponentsClientHttpRequestFactory](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/http/client/HttpComponentsClientHttpRequestFactory.html)으로 ClientHttpRequest를 바꾸어서 사용할 것이다. RestTemplate를 생성할 때 ClientHttpRequestFactory를 변경하여 생성한다. HttpComponentsClientHttpRequestFactory는 Apache HttpClient 라이브러가 필요하다. guild.gradle 파일을 열어서 라이브러리를 추가한다.

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

repositories {
    mavenCentral()
}


dependencies {
    compile('org.springframework.boot:spring-boot-starter-thymeleaf')
    compile('org.springframework.boot:spring-boot-starter-web')
    testCompile('org.springframework.boot:spring-boot-starter-test')

    compile('org.springframework.boot:spring-boot-configuration-processor')
    compile('org.apache.httpcomponents:httpclient:4.5.1')
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

gradle로 의존성있는 라이브러리를 자동으로 다운로드 받은 후 RestTemplate에서 **PATCH**을 사용하기 위해서 RestTemplate을 **HttpComponentsClientHttpRequestFactory**을 가지고  새롭게 생성한다.

```java
@Test
public void testPatch() throws Exception {
    long id = 1;

    URI uri = URI.create(baseUrl + "/api/articles/" +id);

    Article article = articlesService.getArticle(id);
    article.setTitle("testing create article");
    article.setContent("test content");

    HttpHeaders headers = new HttpHeaders();
    HttpEntity<Article> entity = new HttpEntity(article, headers);

    ClientHttpRequestFactory httpRequestFactory =  new HttpComponentsClientHttpRequestFactory();
    restTemplate = new RestTemplate(httpRequestFactory);

    ResponseEntity<String> responseEntity = restTemplate.exchange(uri, HttpMethod.PATCH, entity, String.class);

    String jsonString = jsonStringFromObject(article);

    assertThat(responseEntity.getStatusCode(), is(HttpStatus.OK));
    assertThat(responseEntity.getBody(), is(equalTo(jsonString)));
}
```

브레이크 포인트를 사용하여 컨트롤러에서 확인하면 RestTemplate을 사용하여 요청한 PATCH 요청이 정상적으로 컨트롤러에 요청되는 것을 확인할 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/861?size=full&m=1448440910)

## 결론

실제 우리는 Spring을 사용하는 프로젝트에서 컴포넌트 내에서 API 서버로 REST 요청을 한는 작업을 **RestTemplate**을 사용하여 구현하였다. RestTemplate은 이전에 상요하던 Apache의 **HttpClient** 보다 간단하고 짧은 코드로 쉽게 API 서버로 REST 요청을 처리할 수 있다. JSON 형태의 문자열 결과만 받아오는 것 뿐만 아니라 JSON객체나 POJO 객체로 변환하는 작업 없이 컴포넌트 내에서 사용하는 객체로 바로 매핑하여 사용할 수 있다는 점에서 객체 변환 코드 상당 수를 줄일 수 있었다. RestTemplate은 크레 getForObject(),  postForObject()와 같이 Object로 매핑할 수 있는 요청과 , getForEntity(), postForEntity()와 같이 Entity로 매핑할 수 있는 요청을 할 수 있다 그리고 delete()나 put()과 같이 반환 없는 요청을 할 수 있다. exchange()나 execute() 같은 함수는 모든 Http method 요청에 사용할 수 있고 사용자가 요청하는 객체를 새롭게 정의하거나 로직을 변경할 수도 있다. RestTemplate은 **PATCH** 메소드를 기본적으로 지원하고 있지 않기 때문에 PATCH 를 지원하기 위해서는 생성할 때 Apache HttpClient 라이브를 사용하여 만든 **HttpComponentsClientHttpRequestFactory**를 사용하여 생성하여 사용하면 된다.

다음에는 RestTemplate을 사용하여 FORM 객체를 컨트롤러의 **@ModelAndAttribute** 객체로 매핑하는 방법과 **Multipart/Form-data**를 사용하여 파일 업로드를 하는 방법에 대해서 소개할 예정이다.

## 소스코드

- https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-resttemplate/SpringBootDemo

## 참조

1. http://www.springframework.net/rest/doc-latest/reference/html/resttemplate.html
2. https://github.com/spring-projects/rest-shell/issues/21
3. https://hc.apache.org/httpcomponents-client-ga/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
