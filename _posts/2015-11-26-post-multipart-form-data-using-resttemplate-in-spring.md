---
layout: post
title: Spring에서 RestTemplate을 사용하여 웹(API 서버)에 Multipart/Form-data (첨부파일 포함) 전송하기
category: java
tags:
  - java
  - spring
  - springboot
  - rest
  - resttemplate
  - multipart
  - form
comments: true
images:
  title: 'http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/spring_bean_bud.jpg'
---

## 서론

Spring에서 **RestTemplate**을 사용하면 간단하게 REST 서비스 요청을 쉽게 처리할 수 있다. RestTemplate 모듈이 Spring 에 포함되고 난 이후 Apache HttpClient 등 다른 외부 라이브러리를 사용하지 않고 Spring에서 제공하는 것 만으로도 훨씬 효율적으로 개발할 수 있다. RestTemplate는 이름에서도 느껴지듯 REST 요청을 하는데 최적화 되어 있는 Http Request Template이라고 생각하면된다. JSON 형태의API를 요청하여 객체로 매핑하거나, 객체를 서버로 전송할 때 객체를 쉽게 JSON 형태로 전송할 수 있는 기능을 가지고 있다. 만약 Spring 컴포넌트 안에 Http Request 요청을 하는데 JSON 타입의 API 요청이 아닐 때는 RestTemplate을 사용할 수 없을까? 만약 그렇다고하면 Spring은 너무 제한적이고 무책임하게 RestTemplate을 설계하였다고 볼 수 있다. 하지만 Spring의 기본 철학은 AOP 이다. 이런 철학은 컴폰넌트간의 의존성이 유연하고 컴포넌트간의 상호작용과 확장성이 자유로운 구조로 모듈을 설계되게 만들었다. RestTemplate 역시 단순히 JSON 형태의 데이터를 처리하는 단순한 모듈이 아니라 일반 Http Request 요청을 처리할 수 있게 설계되었을 뿐만 아니라다 사용자가 직접 기능을 수정하거 확장하여 사용할 수 있게 설계되어 있다. 이렇게 유연한 RestTemplate을 사용하여 REST 서비스가 아닌 경우의 Http Request 요청과 Multipart/Form-data를 처리하는 방법고 **MultiValueMapConveter**를 사용하여 POJO 객체를 바로 POST 전송할 수 있는 방법을 소개한다.

<!--more-->

## 테스트를 위한 프로젝트와 컨트롤러 생성

우리는 앞에서 [Spring에서 REST 서비스를 위한 컨트롤러에 FORM과 파일업로드(multipart/form-data)를 함께 사용하기와 컨트롤러 테스트하기](http://blog.saltfactory.net/java/submit-multipart-form-data-and-test-in-spring.html) 글에서 Spring Boot를 사용하여 Spring에서 **Thymeleaf**를 사용하여 Form 입력 페이지를 만들고 **@ModelAttribute**를 사용하여 Multipart/Form-data로 파일 업로드를 포함하여 Submit을 할 때 처리하는 컨트롤러를 만들어보았다. 그리고 [Spring에서 RestTemplate을 사용하여 REST 기반 서비스 요청과 테스트하기](http://blog.saltfactory.net/java/using-resttemplate-in-spring.html) 글에서 **RestTemplate** 를 사용하여 REST 서비스를 위한 컨트롤러로 HTTP GET/POST/PUT/PATCH/DELETe 요청을 보내는 것을 만들어보았다. [spring-boot-resttemplate](https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-resttemplate/SpringBootDemo) 소스코드를 다운받아서 테스트를 진행하거나 직접 Form 처리를 하기위한 컨트롤러를 직접 만들어서 진행하여도 좋다.

## RestTemplate을 사용하여 GET 요청하여 HTML 문서 확인하기

우리는 앞의 글에서 RestTemplate을 사용하여 JSON 타입의 API 형태의 REST 서비를 요청하는 예제를 다루었다. 만약 GET으로 요청하면 HTML을 보여주는 컨트롤러를 만들어보자. 우리는 새로운 Article의 입력을 위해 Form을 가지고 있는 뷰를 Thymeleaf로 만들었다. 다운로드 받은 소스코드에서 Spring Boot 서버를 실행하고 http://localhost:8080/articles/new 를 요청하면 다음과 같이 입력화면이 브라우저에 나타난다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/e68b96c9-2a86-48a6-afcc-7177d11bf8b5)

우리는 이 화면을 위한 컨트롤르 메소드를 다음과 같이 ArticlesController 안에 newArticle() 이라는 이름으로 다음과 같이 만들었었다.

```java
@RequestMapping(value = "/articles/new", method = RequestMethod.GET)
public String newArticle(Model model){
    Article article = new Article();
    model.addAttribute("article", article);
    return "articles/new";
}
```

그리고 이 메소드를 테스트하기 위해 **MockMvc**로 다음과 같이 테스트를 하였다. **get()** 요청으로 받은 HTML 뷰를 **xpath()**를 가지고 테스트하는 코드이다.

```java
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

```

위 테스트를 RestTemplate으로 구현하면 다음과 같다. RestTemplate.exchange()를 사용하여 **ResponseEntity**를 받은 후에 Header에서 Content-Type을 확인하고, XPath를 사용하여 HTML 노드가 있는지 확인하는 방법은 동일하다. 다만 MockMvc 테스트를 할 때 테스트 프레임워크 자체에 **xpath()** 메소드가 있지만, **Hamcrest**의 [Matchers.assertThat()](http://hamcrest.org/JavaHamcrest/javadoc/1.3/org/hamcrest/Matchers.html)을 사용할 때의 [hasXPath()](http://hamcrest.org/JavaHamcrest/javadoc/1.3/org/hamcrest/Matchers.html#hasXPath(java.lang.String))는 XML 의 Document 개체에서만  테스트를 할 수 있다. 그래서 **assertThat()** 테스트 라이브러리에서 **XHTML**을 사용하여 XPath를 사용할 수 있는 라이브러리 [XhtmlMatchers.hasXPath()](http://matchers.jcabi.com/xhtml-matchers.html)를 사용하여 HTML 문서를 비교하면 된다.

테스트를 진행할 때 새로운 라이브러리가 필요하기 때문에 프로젝트 안의 **build.gradle** 파일을 열어서 **dependencies**에 다음 내용을 추가한다.

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

    testCompile('com.jcabi:jcabi-matchers:1.3')
    testCompile('com.jcabi:jcabi-xml:0.16.1')
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

gradle을 사용하여 자동으로 새로 추가한 라이브러가 다운받아지면서 테스트는 성공적으로 진행이 될 것이다. 테스트를 해보자.

```java
@Test
public void testNewArticle() throws Exception {
  URI uri = URI.create(baseUrl + "/articles/new");

  HttpHeaders headers = new HttpHeaders();
  headers.setContentType(MediaType.TEXT_HTML);
  MediaType mediaType = new MediaType("text", "html", Charset.forName("UTF-8"));
  HttpEntity<String> entity = new HttpEntity<>(headers);


//        String responseString = restTemplate.getForObject(uri), String.class);
  ResponseEntity<String> responseEntity = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

  assertThat(responseEntity.getStatusCode(), is(equalTo(HttpStatus.OK)));
  assertThat(responseEntity.getHeaders().getContentType(), is(equalTo(mediaType)));
  assertThat(responseEntity.getBody(), hasXPath("//input[@name='title']"));

  logger.info(responseEntity.getBody());
}
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/96c8ab42-83e6-42b5-ad08-09a19a5c49bf)

앞의 글에서 살펴본 것과 같이 RestTemplate을 사용하여 JSON 만 가져오는 것 뿐만 아니라 HTML 문서도 가져올 수 있다. 다시 말해서 모든 URI에 접근해서 HTTP Request로 요청할 수 있는 모든 일을 할 수 있는 것이다.

## RestTemplate을 사용하여 POST 로 FORM 데이터 보내기

> 이 기능을 소개하기 위해서 앞에 여러가지 많은 컨트롤러와 RestTemplate의 기능을 소개했다.

RestTemplate은 REST 요청에 최적화 되어 있다. 다시 말해서 JSON 타입의 GET/POST/PUT/PATCH/DELETE 메소드를 사용한 HTTP Request 요청에 최적화 되어 있다고 생각하면 된다.

하지만! 기존에 Spring 프로젝트에서는 POST로 데이터를 전송하면 **@ModelAttribute**를 사용하여 파라미터를 객체와 매핑하였다. 이전에는 API 서비스가 많지 않았고 대부분 웹에서 Form을 사용하여 Submit을 하기 때문에 기존의 컨트롤러는 **@RequestBody**와 같은 JSON 파라미터를 객체로 매핑하는 컨트롤러를 만들지 않았기 때문이다. 우리는 [Spring에서 REST 서비스를 위한 컨트롤러에 FORM과 파일업로드(multipart/form-data)를 함께 사용하기와 컨트롤러 테스트하기](http://blog.saltfactory.net/java/submit-multipart-form-data-and-test-in-spring.html) 글에서 HTML form을 사용하여 **Multipart/Form-data**를 전송하고 받는 컨틀롤와 뷰를 만들어보았다. Submit을 했을 때 매핑되는 컨트로러는 다음과 같다. 자세히 보면 클라이언트에서 객체의 데이터를 받는 것이 **@ModelAttribute** 라는 것을 살펴볼 수 있다.

```java
@RequestMapping(value = "/articles", method = RequestMethod.POST)
@ResponseBody
public Article submit(@ModelAttribute Article article){
    return article;
}
```

그럼 RestTemplate을 사용하여 이 컨트롤러에 요청을 하려면 어떻게 해야할지 살펴보자.

우선 앞에서 살펴보듯 RestTemplate에서 기본적으로 **POST**를 요청할 때 사용했던 restTemplate.postForObject() 방법으로 테스트를 진행해보자.

```java
 @Test
public void testSubmit() throws Exception {

  URI uri = URI.create(baseUrl + "/articles");

  Article article = new Article();
  article.setTitle("testing create article");
  article.setContent("test content");

  Comment comment = new Comment();
  comment.setContent("test comment1");
  List<Comment> comments = new ArrayList<>();
  comments.add(comment);

  article.setComments(comments);

  String responseString = restTemplate.postForObject(uri, article, String.class);
  String jsonString = jsonStringFromObject(article);

  assertThat(responseString, is(equalTo(jsonString)));

}

```
테스트 결과는 다음과 같다. 테스트 Fail 정보를 살펴보면 컨트롤에서 POST로 받은 Article의 객체를 JSON으로 매핑하여 반환할 때 Article의 필드에 값이 없는 것을 확인할 수 있다. 다시말해서 @ModelAttribute로 매핑되는 파라미터의 값이 하나도 들어오지 않았다는 말이 된다.
![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8b8b92f7-f4e4-4201-9628-98b789ce1e4f)

그럼 컨트롤러에 도착할 때, Request를 POST로 전송하여 컨트롤러까지 오는 객체를 알아보기 위해서 submit을 처리하는 메소드에 브레이크 포인트를 걸어서 확인해보자.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9b20d013-4ea0-4f70-8d3f-b7d2d2caac92)

브레이크 포인트를 확인해보면 @ModelAttribute에 매핑할 객체의 값이 모두 null인 것을 확인할 수 있다. 다시 말하자면 POST로 넘겨 받은 파라미터를 객체로 매핑할 때 정보를 제대로 확인할 수 없다는 것이다. 좀 더 HTTP 요청을 처리하는 객체의 내부를 살펴보자. Spring 클래스 중에서 **processRequest()** 메소드 안의 request 값을 살펴보면 RestTemplate에서 요청한 Content-Type이 **application/json;charset=UTF-8** 이란는 것을 알 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f025e8d6-1b94-4b4a-981b-d2946e611f12)

우리는 컨트롤러에 @ModelAttribute로 파라미터를 객체에 매핑하도록 하였는데 application/json 컨텐츠 타입의 바디 즉, @RequestBody로 객체를 매핑하는 구조가 아니기 때문에 이렇게 POST로 넘어온다면 객체에 매핑이 되지 않는다. 좀 더 구체적으로 로깅을 살펴보기 위해서 Spring 어플리케이션의 로깅 레벨을 **DEBUG**로 변경하고 실행해보자. **src/main/resources/application.properties** 열어서 다음과 같이 로깅 레벨을 지정한다.

```java
logging.level.=DEBUG
```
다시 테스트를 실행해보자. 로깅 레벨을 DEBUG로 지정하고 테스트를 진행하면 서버와 클래스 내부의 객체를 보다 자세하게 로깅할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/64236ddf-4ace-4dc6-9d31-b48f839eb950)

```text
2015-11-26 13:48:41.123 DEBUG 54749 --- [o-auto-1-exec-1] o.a.c.http11.InternalNioInputBuffer      : Received [POST /articles HTTP/1.1
Accept: text/plain, application/json, application/*+json, */*
Content-Type: application/json;charset=UTF-8
User-Agent: Java/1.8.0_25
Host: localhost:49497
Connection: keep-alive
Content-Length: 128

{"id":0,"title":"testing create article","content":"test content","comments":[{"id":0,"articleId":0,"content":"test comment1"}]}]
```

위와 같이 **RestTemplate.postForObject()**로 보낸 객체는 JSON 타입으로  요청이 되고 있는 것을 확인할 수 있다.

## MultiValueMap을 사용하여 application/x-www-form-urlencoded 전송하기

Spring의 컨트롤러에서 POST로 넘어오는 객체 파라미터를 **@ModelAttribute**에 매핑하기 위해서는 HTTP Request의 컨텐트타입이 **application/x-www-form-urlencoded** 이나 **multipart/form-data** 이어야만 한다. 만약 application/json 타입으로 POST 전송을 한다면 @ModelAttribute로 매핑되는 객체에는 아무런 값이 들어가지 않는다. application/json은 @RequestBody로 매핑한다. **application/x-www-form-urlencoded**와 **multipart/form-data**의 차이는 POST를 전송할 때 **MultipartFile** 파일을 함께 전송하는지에 따라 차이가 난다.

먼저 RestTemplate으로 application/x-www-form-urlencoded 타입으로 POST를 전송해보자. RestTemplate에서 객체를 application/x-www-form-urlencoded로 전송하기 위해서는 [MultiValueMap](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/util/MultiValueMap.html)를 사용하여 전송해야한다. 다음과 같이 Article의 객체를 MultiValueMap을 사용하여 Article을 POST 요청할 수 있도록 수정한다.

> 이 때 주의할 점은 객체 안에 계층 구조를 풀어서 MultiValueMap의 이름으로 지정해야한다는 것이다.

 Article 객체 안에 Comment는 List 타입으로 여러개의 Comment를 한번에 보내도록 객체 관계를 가지고 전송하도록 만들었는데, 이것을 컨트롤러에서 @ModelAttribute를 통해 Article 객체를 생성하고 Comment 리스트로 매핑하기 위해서는 restTemplate에서 MulitiValueMap을 만들때 파라미터의 이름을 **article.comments[0].id**, **article.comments[1].id** 와 같이 만들어서 보내야 한다는 것이다.

```java
 @Test
public void testSubmit() throws Exception {

  URI uri = URI.create(baseUrl + "/articles");

  Article article = new Article();
  article.setTitle("testing create article");
  article.setContent("test content");

  Comment comment = new Comment();
  comment.setContent("test comment1");
  List<Comment> comments = new ArrayList<>();
  comments.add(comment);

  article.setComments(comments);

  MultiValueMap<String, Object> multiValueMap = new LinkedMultiValueMap<>();
  multiValueMap.add("title", article.getTitle());
  multiValueMap.add("content", article.getContent());
  multiValueMap.add("comments[0].content", article.getComments().get(0).getContent());

//        String responseString = restTemplate.postForObject(uri, article, String.class);
  String responseString = restTemplate.postForObject(uri, multiValueMap, String.class);
  String jsonString = jsonStringFromObject(article);

  assertThat(responseString, is(equalTo(jsonString)));
}
```

테스트를 실행하면 다음과 같이 HTTPMethod.POST를 요청할 때 Content-Type이 **application/x-www-form-urlencoded**로 전송되고 Article의 객체가 POST의 Body 로 전송되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/03a7acb2-b2ef-4743-ba55-79b2c1357826)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/6ee56904-bc9a-4777-9af2-6b89c1c055fe)


## MultiValueMap을 사용하여 Multipart/Form-data 전송하기

위에서 RestTemplate로 POST를 전송할 때 application/x-www-form-urlencoded로 Content-Type을 지정하였다. 하지만 만약 파일을 함께 보낼때는 이것을 사용하면 파일을 매핑할 수 없다. 파일과 함께 보내기 위해서는 **multipart/form-data**로 Content-Type을 지정 해야하는데, RestTemplate은 이런 경우의 수를 생각하지 않아도 된다.  **MultiValueMap** 안에 첨부 파일이 들어 있으면 자동으로 Content-Type을 multipart/form-data로 요청하기 때문이다. 이것은 RestTemplate가 가지고 있는 [MessageConverters](http://docs.spring.io/autorepo/docs/spring-android/1.0.x/reference/html/rest-template.html) 라는 것 때문이다.

> 이 때 주의할 점은 MultiValueMap에 파일을 첨부하기 위해서는 **Resource** 타입으로 파일을 추가해야한다.

우리는 MultiPartFile을 ByteArrayResource로 변환하여 MutliValueMap에 추가하여 전송을 하였다.

```java
@Test
public void testSubmit() throws Exception {

  URI uri = URI.create(baseUrl + "/articles");

  Article article = new Article();
  article.setTitle("testing create article");
  article.setContent("test content");

  Comment comment = new Comment();
  comment.setContent("test comment1");
  List<Comment> comments = new ArrayList<>();
  comments.add(comment);
  article.setComments(comments);

  MockMultipartFile file = new MockMultipartFile("file", "filename.txt", "text/plain", "some xml".getBytes());
  article.setFile(file);

  MultiValueMap<String, Object> multiValueMap = new LinkedMultiValueMap<>();
  multiValueMap.add("title", article.getTitle());
  multiValueMap.add("content", article.getContent());
  multiValueMap.add("comments[0].content", article.getComments().get(0).getContent());

  ByteArrayResource resource = new ByteArrayResource(article.getFile().getBytes()){
      @Override
      public String getFilename() throws IllegalStateException {
          return article.getFile().getOriginalFilename();
      }
  };
  multiValueMap.add("file", resource);

//        String responseString = restTemplate.postForObject(uri, article, String.class);
  String responseString = restTemplate.postForObject(uri, multiValueMap, String.class);
  String jsonString = jsonStringFromObject(article);

  assertThat(responseString, is(equalTo(jsonString)));
}
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/dc36a145-ae15-47c0-90a9-f14977290af9)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/a5d748b8-61eb-473f-a05a-45717875574b)

이렇게 RestTemplate을 사용하여 JSON 타입으로 POST를 전송하거나 Multipart/Form-data 형태로 파일을 포함한 데이터를 서버로 전송할 수 있다.

## Java Reflection을 사용하여 자동으로 MultiValueMap 만들기

RestTemplate에서 Multipart/Form-data 를 전송하기 위해서는 POJO에 담겨져 있는 데이터를 MultiValueMap에 하나씩 꺼내어 다시 파라미터 이름을 만들어서 추가해야하고 그렇게 만들어진 MultiValueMap을 RestTemplate으로 POST 요청을 해야한다.

이 과정을 자동화 시키기 위해서 [MultiValueMapConverter](https://github.com/saltfactory/saltfactory-java-tutorial/blob/spring-boot-resttemplate/SpringBootDemo/src/main/java/net/saltfactory/tutorial/MultiValueMapConverter.java)를 만들었다. 다음과 같이 POJO에 들어있는 데이터를 가지고 자동으로 MultiValueMap을 만들어 주는 것이다.

```java
MultiValueMap multiValueMap = new MultiValueMapConverter(article).convert();
```

MultiValueMapConverter.java는 다음과 같이 Java [Reflection](https://docs.oracle.com/javase/7/docs/api/java/lang/reflect/package-summary.html)을 사용하여 만들었다.

POJO를 필드명과 오브젝트를 탐색하고 계층 구조일 경우 재귀적으로 탐색하면서 계층구조와 리스트의 경우 MultiValueMap에 들어가는 이름을 자동으로 만들어주고 객체를 add하게 만들었다. 이 MultiValueMap 클래스는 완벽하지 않지만 객체에서 값을 수작업으로 꺼내어 MultiValueMap에 넣지 않고 자동으로 처리할 수 있어 꽤 유용하게 사용할 수 있다.

```java
package net.saltfactory.tutorial;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.Map;
import java.util.Set;

/**
 * filename : MultiValueMapConverter.java
 * author   : saltfactory<saltfactory@gmail.com>
 * license  : MIT
 * created  : 11/25/15
 */
public class MultiValueMapConverter {
    private MultiValueMap<String, Object> multiValueMap;

    private Object bean;

    public MultiValueMapConverter(Object bean) {
        this.multiValueMap = new LinkedMultiValueMap<>();
        this.bean = bean;
    }

    public MultiValueMap convert() throws Exception {
        this.addMultiValueFromBean(this.multiValueMap, "", this.bean);
        return this.multiValueMap;
    }


    private boolean isPrimitiveType(Object object) {
        if ((object instanceof String) ||
                (object instanceof Integer) ||
                (object instanceof Float) ||
                (object instanceof Void) ||
                (object instanceof Boolean) ||
                (object instanceof Long)) {
            return true;
        } else {
            return false;
        }
    }

    private MultiValueMap addMultiValueFromBean(MultiValueMap multiValueMap, String name, Object object) throws IntrospectionException, InvocationTargetException, IllegalAccessException, NoSuchMethodException {
        MultiValueMap mvm = multiValueMap;

        Field[] fields = object.getClass().getDeclaredFields();

        for (Field field : fields) {
            String _name = (name.equals("")) ? field.getName() : name + "." + field.getName();
            Object value = new PropertyDescriptor(field.getName(), object.getClass()).getReadMethod().invoke(object);

            if (value == null) {
//                return mvm;
            } else {

//            if (!this.isPrimitiveType(value)) {
//                mvm = this.addMultiValueFromBean(mvm, _name, value);
//            } else {
                if (value instanceof Map) {
                    mvm = this.addMultiValueFromMap(multiValueMap, _name, (Map) value);
                } else if (value instanceof Iterable) {
                    mvm = this.addMultiValueFromIterable(multiValueMap, _name, (Iterable) value);
                } else if (value instanceof MultipartFile) {
                    MultipartFile multipartFile = (MultipartFile) value;
                    ByteArrayResource resource = null;
                    try {
                        resource = new ByteArrayResource(multipartFile.getBytes()){
                            @Override
                            public String getFilename() throws IllegalStateException {
                                return multipartFile.getOriginalFilename();
                            }
                        };
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    mvm.add(_name, resource);
                } else {
                    value = new PropertyDescriptor(field.getName(), object.getClass()).getReadMethod().invoke(object);
                    mvm.add(_name, value);
                }
//            }
            }
        }


        return mvm;
    }

    private MultiValueMap addMultiValueFromIterable(MultiValueMap multiValueMap, String name, Iterable iterable) throws NoSuchMethodException, IntrospectionException, IllegalAccessException, InvocationTargetException {
        MultiValueMap mvm = multiValueMap;

        int i = 0;
        for (Object object : iterable) {
            String _name = name + "[" + i + "]";
            if (object instanceof Map) {
                mvm = this.addMultiValueFromMap(mvm, _name, (Map) object);
            } else if (object instanceof Iterable) {
                mvm = this.addMultiValueFromIterable(mvm, _name, (Iterable) object);
            } else {
                mvm = this.addMultiValueFromBean(mvm, _name, object);
                i++;
            }

        }
        return mvm;
    }

    private MultiValueMap addMultiValueFromMap(MultiValueMap multiValueMap, String name, Map map) {
        MultiValueMap mvm = multiValueMap;
        Set<String> keys = map.keySet();

        for (String key : keys) {
            String _name = name + "." + key;

            Object value = map.get(key);
            if (value instanceof Map) {
                mvm = this.addMultiValueFromMap(mvm, _name, (Map) value);
            } else if (value instanceof Iterable) {
            } else {
                mvm.add(_name, value);
            }
        }

        return mvm;
    }
}
```

위의 RestTemplate으로 Multipart/form-data를 전송하는 코드를 다음과 같이 객체를 그대로 MultiValueMap으로 전송하게 간단하게 만들 수 있다.

```java
@Test
public void testSubmit() throws Exception {

    URI uri = URI.create(baseUrl + "/articles");

    Article article = new Article();
    article.setTitle("testing create article");
    article.setContent("test content");

    Comment comment = new Comment();
    comment.setContent("test comment1");
    List<Comment> comments = new ArrayList<>();
    comments.add(comment);
    article.setComments(comments);

    MockMultipartFile file = new MockMultipartFile("file", "filename.txt", "text/plain", "some xml".getBytes());
    article.setFile(file);

    MultiValueMap<String, Object> multiValueMap = new MultiValueMapConverter(article).convert();

    String responseString = restTemplate.postForObject(uri, multiValueMap, String.class);
    String jsonString = jsonStringFromObject(article);

    assertThat(responseString, is(equalTo(jsonString)));

}

```

## 결론

사실 이 글을 작성하기 위해서 앞에 여러가지 REST 컨트롤러와 RestTemplate을 구현하고 테스트하는 방법을 살펴보았다. 처음 우리는 Spring 컴포넌트에서 웹 페이지에서 FORM으로 POST를 전송 받은 데이터를 API 서버로 전송하는 과정에서 RestTemplate을 가지고 컨트롤러에 받은 객체를 그대로 전송하는 방법이 필요했다. 하지만 RestTemplate로 API 서버로 객체를 전송하기 위해서는 MultiValueMap을 사용해야하는데 객체의 크기가 다양하고 계층 구조가 다양했기 때문에 하드 코딩으로 객체 안의 데이터를 빼어내는 작업을 하고 싶지 않았다. 그래서 우리는 Spring의 컨트롤러와 RestTemplate 동작 원리에 대해서 연구를 하기 시작했고 이 포스팅에서 소개하는 방법으로 문제를 해결했다. 다음은 우리가 하고 싶었던 컨트롤러 컴포넌트 내부의 모습을 간단하게 만든 모양이다.

```java
@RequestMapping(value = "/articles", method = RequestMethod.POST)
@ResponseBody
public Article submit(@ModelAttribute Article article) throws Exception {

    URI uri = URI.create("http://API서버");
    RestTemplate restTemplate = new RestTemplate();
    MultiValueMap multiValueMap = new MultiValueMapConverter(article).convert();

    return restTemplate.postForObject(uri, multiValueMap, Article.class);

}
```

RestTemplate는 Spring 내부에서 다른 서버로 HTTP Request 요청을 처리하고 객체로 간단하게 매핑할 수 있기 때문에 효율적인 코드를 작성할 수 있고, **MultiValueMap**을 사용하여 Multipart/Form-data를 쉽게 전송하기 위해서 **MultiValueMapConverter**를 사용하면 특별한 코드를 추가하지 않고 객체를 바로 POST로 보내는 MultiValueMap으로 만들어서 전송할 수 있다.

## 소스코드

- https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-resttemplate/SpringBootDemo
- https://github.com/saltfactory/saltfactory-java-tutorial/blob/spring-boot-resttemplate/SpringBootDemo/src/main/java/net/saltfactory/tutorial/MultiValueMapConverter.java

## 참조

1. http://www.springframework.net/rest/doc-latest/reference/html/resttemplate.html
2. http://blog.saltfactory.net/java/submit-multipart-form-data-and-test-in-spring.html
3. http://blog.peecho.com/blog/java-s3-upload-using-spring-resttemplate
4. http://hamcrest.org/JavaHamcrest/javadoc/1.3/org/hamcrest/Matchers.html#hasXPath(java.lang.String)
5. http://matchers.jcabi.com/xhtml-matchers.html
6. http://docs.spring.io/autorepo/docs/spring-android/1.0.x/reference/html/rest-template.html
7. https://docs.oracle.com/javase/7/docs/api/java/lang/reflect/package-summary.html
8. https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/http/converter/FormHttpMessageConverter.html
9. http://stackoverflow.com/questions/4118670/sending-multipart-file-as-post-parameters-with-resttemplate-requests
