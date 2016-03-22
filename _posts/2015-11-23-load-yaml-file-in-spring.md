---
layout: post
title: Spring에서 YAML 파일 데이터 객체에 매핑하여 로드하기
category: java
tags:
  - java
  - spring
  - springboot
  - yaml
comments: true
images:
  title: 'https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e2332bdb-1a94-4849-8dc3-8a81c73ec2ac'
---

## 서론

Spring 프로젝트를 진행할 때 외부에서 데이터를 로드할 경우가 종종 있다. 가장 쉽게는 Spring Boot에서 사용하는 Configuration Porperty를 로드하는 것이다. Spring Boot는 기본적으로 application.properties 파일을 추가하면 자동으로 [Common application properteis](http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html ) 로드하여 프로퍼티 값을 적용할 수 있다. 하지만 자바의 [Properties](https://docs.oracle.com/javase/tutorial/essential/environment/properties.html) 의 파일의 사용에는 표현의 한계가 있기 때문에 최근에는 Properties를 [YAML](http://yaml.org)을 많이 사용하고 있다. Spring Boot에서는 [SnakeYAML](https://bitbucket.org/asomov/snakeyaml)을 포함하고 있어서 쉽게 외부 파일을 YAML으로 작성하여 쉽게 로드하여 객체로 매핑할 수 있다. 이번 포스팅에서는 Spring Boot에서 YAML로 작성한 파일을 객체로 매핑하여 사용하는 방법을 소개한다.

<!--more-->

## 테스트를 위한 데이터 YAML 파일로 만들기

테스트를 위해 간단한 데이터가 필요하다. 이 때 처음부터 JPA와 같이 ORM을 가지고 데이터를 만들어서 사용하려면 꽤 여러가지 일을 해야한다. 우리는 테스트를 위한 파일을 쉽게 가져올 수 있게하기 위해서 YAML 파일을 사용하기로 한다. Spring Boot는 [application.properties 이나 application.yml](http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html) 파일에 필요한 설정을 정의하면 어플리케이션에서 자동으로 읽어들일 수 있다. Spring Boot 프로젝트를 생성하면 **src/main/resources/application.properties** 라는 어플리케이션 프로퍼티 파일이 만들어 진다. Spring에서 복잡한 XML 설정을 Spring Boot에서는 이 파일 안에서 간단하게 설정하여 어플리케이션에 적용할 수 있다. http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html 자세한 사항은 링크를 참조하면 된다.

Spring Boot에서는 [Snake YAML](https://bitbucket.org/asomov/snakeyaml) 라이브러리를 내장하고 있다. 이런 이유로 Spring Boot에서는 [YAML](http://yaml.org/) 파일을 로드하여 사용할 수 있다. http://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#boot-features-external-config-yaml (링크를 참조). 뿐만아니라  **src/main/resources/application.yml** 파일에 설정을 정의하면 application.properties와 같이 Spring Boot에서 자동으로 읽어와 필요한 곳에 매핑된다.

[YAML](http://yaml.org/) 파일은 .properties 파일과 달리 계층과 배열 구조의 데이터를 쉽게 만들 수 있고 이것을 Map, List 또는 Bean에 쉽게 편리하게 매핑할 수 있다. Ruby on Rails에서는 이미 오래전부터 YAML 파일을 사용하여 데이터베이스나 시스템 설정 파일로 사용해 왔다. YAML은 JSON과 비슷하지만 표현법이 더 간단하여 인기있기 사용되고 있다.

우리는 테스트를 위한 데모 데이터세트를 Spring Boot가 환경 설정을 읽어오는 것과 유사하게 로드하게 할 것이다. 먼저 데모 데이터를 **src/main/resources/fixtures.yml** 에 저장한다.

```yaml
fixtures:
  articles:
    -
      id: 1
      title: title1
      content: content1
    -
      id: 2
      title: title2
      content: content2
    -
      id: 3
      title: title3
      content: content3
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ca2e7301-f509-451b-93c0-96dc628186bf)


## YAML 파일을 Map으로 매핑하기

먼저 YAML 파일을 로드하기 위해서는 외부에서 Configuration을 로드 하기 위해 [Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html) (글을 참조) 설정을 해야한다. 간단하게 다시 말하자면 YAML 파일을 Spring 어플리케이션어 로드하기 위한 컴포넌트가 필요하다. 우리는 fixtures.yml 파일을 Configuration Property 파일 형태로 로드하기 위해서 **src/main/java/{패캐지명}/FixturesProperty.java** 파일을 만든다. 여기서 주의할 점은 앞에서 만든 **fixtures.yml** 파일을 로드하기 위해서 classpath 위치를 지정하는데 SpringBoot는 기본적으로 **src/main/resources/** 디렉토리를 클래스 패스로 가지고 있기 때문에 아래와 같이 지정한다. 그리고 fixtures.yml 파일 안에 articles는 **fixtures** 라는 Key의 List value로 만들어 놓았기 때문에 YAML 파일을 읽어들일 때 **prefix**로 **fixtures**를 정의하여 이 키 값 안의 데이터를 로드하게 한다. 그리고 우리가 만든 fixtures.yml 파일은 article 내용이 YAML의 배열로 작성했기 때문에 나중에 **List<Map>**로 매핑될 것이다. 외부 프로퍼티 파일(.propertis 나 .yml)을 Injection 로드하기 위해서는 Spring의 컴포넌트가 되어야하기 때문에 **@Component** 어노테이션을 추가하고 프로퍼티 파일을 로드하기 위한 클래스라는 것을 정의하기 위해서 **@ConfigurationProperties** 어노테이션을 추가한다.

```java
package net.saltfactory.tutorial;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.NestedConfigurationProperty;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Filename : FixturesProperty.java
 * Author   : saltfactory<saltfactory@gmail.com>
 * Created  : 11/23/15.
 */
@Component
@ConfigurationProperties(locations = {"fixtures.yml"}, prefix = "fixtures")
public class FixturesProperty {
    @NestedConfigurationProperty
    private List<Map> articles = new ArrayList<>();

    public List<Map> getArticles() {
        return articles;
    }
}
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e80dfa08-7164-48e9-ae50-784f8ed2a148)

스크린샷과 같이 Spring Boot Configuration Annoation Processor를 찾을 수 없다는 에러가 나타나면 다음과 build.gradle 파일을 열어서 다음 내용을 추가한다. 원래 Spring Boot에서 외부 프로퍼티 파일을 로드하기 위해서는 메타 정보를 파일로 만들어서 추가해야는데 [propdes-plugin](https://github.com/spring-projects/gradle-plugins/tree/master/propdeps-plugin)을 사용하면 메타 파일을 추가하지 않고 자동으로 적용할 수 있다. http://docs.spring.io/spring-boot/docs/1.3.0.RELEASE/reference/html/configuration-metadata.html#configuration-metadata-annotation-processor (글을 참조)

프로젝트 안의 **build.gradle** 파일을 열어서 다음과 같이 수정하고 gradle.properties 파일을 적용한다.(IntelliJ에서는 이 파일을 수정하고 Gradle projects 패널에서 새로고침 버튼을 누르면 의존성 있는 라이브러리를 자동으로 다운 받게 된다)

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
        classpath("org.springframework.build.gradle:propdeps-plugin:0.0.7")
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'propdeps'
apply plugin: 'spring-boot'
apply plugin: 'propdeps-idea'

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
    compile('org.springframework.boot:spring-boot-starter-web')
    optional("org.springframework.boot:spring-boot-configuration-processor")

    testCompile('org.springframework.boot:spring-boot-starter-test')
}

compileJava.dependsOn(processResources)


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

이제 외부 프로퍼티 파일을 로드하기 위한 설정을 모두 마쳤다. 우리가 만든 fixtures.yml 파일을 FixturesProperty 클래스가 잘 로드하는지 확인하기 위해서 Test 파일을 만들어보자. **src/test/java/{패키지경로}/FixturesPropertyTest.java**. 앞에서 FixtureProperty는 Spring의 **@Component**로 만들었기 때문에 스캐닝되고 **@ConfigurationProperty** 때문에 YAML 파일을 오브젝트에 매핑되어 반환하게 될 것이다. 우리는 fixtures.yml에 3개의 아이템을 리스트로 만들었기 때문에 테스트에서 리스트의 사이즈를 3이 맞는지 테스트를 진행하였다.

```java
package net.saltfactory.tutorial;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

/**
 * filename : FixturespropertyTest.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class FixturesPropertyTest {
    @Autowired
    private FixturesProperty fixturesProperty;

    @Test
    public void testGetArticles() {
        List<Map> articles = fixturesProperty.getArticles();
        assertThat(articles.size(), is(3));
    }

}
```

테스트 파일을 만들었으면 단위 테스트를 실행해보자.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/835e7b01-d634-46e1-9271-f7a1c4c0daa6)

## YAML 파일을 POJO로 매핑하기

위에 yaml로 만든 외부 파일을 Map으로 매핑을 할 수 있는 것을 살펴보았다. Spring 프로젝트에서는 데이터를 저장하는 객체를 POJO로 만들어서 setter/getter를 한다. YAML의 데이터를 POJO 객체로 바로 매핑하는 방법을 살펴보자. 우선 Article 객체를 fixtures.yml 파일에 정의한 key 값과 동일한 이름으로 field와 setter/getter를 만든다.

```java
package net.saltfactory.tutorial;

import java.io.Serializable;

/**
 * filename : Article.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15
 */
public class Article implements Serializable {
    private long id;
    private String title;
    private String content;

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
}
```

앞에서 외부 Configuration Property를 로드하기 위한 **FixturesProperty**를 열어서 로드할 타입을 **Map**에서 **Article**로 변경한다.

```java
package net.saltfactory.tutorial;

import org.springframework.boot.context.properties.ConfigurationProperties;
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

테스트를 위한 **FixturesPropertyTest** 파일을 수정하고 브레이크포인트를 걸어서 확인해보자.

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
 * filename : FixturespropertyTest.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class FixturesPropertyTest {
    @Autowired
    private FixturesProperty fixturesProperty;

    @Test
    public void testGetArticles() {
        List<Article> articles = fixturesProperty.getArticles();
        assertThat(articles.size(), is(3));
    }

}
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ef19c70b-b6a0-4ecb-92fc-f4c68ffb453d)

테스트의 브레이크 포인트를 확인하면 fixtureProperty.getArticles() 에서 YAML 파일에서 로드된 데이터가 Article의 객체로 매핑되어 로드된 것을 확인할 수 있다.

## 계층 구조의 YAML 파일을 POJO로 매핑하기

YAML의 장점은 계층 구조의 데이터를 잘 표현할 수 있는 것이다. properties 파일은 계층 구조를 표현하기 위해서 좀 더 복잡한 방법을 사용해야하지만 YAML을 사용하면 들여쓰기 기준으로 계층 구조를 쉽게 표현할 수 있다. 또한 계층 구조로 된 POJO로 데이터를 로드하여 사용할 수 있다. 만약 Article 안에 Comment를 리스트로 가지고 있는 구조가 있다고 가정해보자. fixtures.yml 파일을 다음과 같이 수정한다.

```yaml
fixtures:
  articles:
    -
      id: 1
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
    -
      id: 2
      title: title2
      content: content2
      comments:
        - id: 20
          articleId: 2
          content: comment21
        - id: 21
          articleId: 2
          content: comment22
    -
      id: 3
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

그리고 Comment가 매핑될 객체를 만든다.

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

그리고 Article 안에 Comment 리스트를 추가한다.

```java
package net.saltfactory.tutorial;

import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.List;

/**
 * filename : Article.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15
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

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
}
```

단위 테스트를 다음과 같이 수정하자.

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
 * filename : FixturespropertyTest.java
 * author   : saltfactory<saltfactory@gmail.com>
 * created  : 11/23/15.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = SpringBootDemoApplication.class)
public class FixturesPropertyTest {
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

단위 테스트를 실행시켜서 Article 객체 안에 Comment가 정상적으로 로드 되었는지 확인해보자.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/1c9895e3-83d0-4dbf-940b-4922bef5287b)

브레이크 포인트를 확인해보면 Article 객체 안에 Comment가 리스트로 정상적으로 로드된 것을 확인할 수 있다.

## 결론

최신 Spring은 좀더 계층구조를 표현하기 쉽고 사람이 읽기 쉬운 YAML 파일을 로드할 수 있는 기능을 포함하였다. Spring Boot에서는 Spring 어플리케이션의 설정을 **src/main/resources/application.properties**에서 정의하면 자동으로 어플리케이션에 적용이되는데 YAML 파일을 사용하여 **application.yml** 파일을 만들어도 자동으로 적용을 할 수 있다. **SnakeYAML** 라이브러리를 포함하고 있는 Spring Boot에서는 YAML 파일을 읽어들어 Map이나 POJO에 바로 매핑하여 데이터를 로드할 수 있다. 더구나 **@ConfigurationProperties**를 사용하면 Spring 어플리케이션에서 YAML 파일을 Configuration Property 파일로 인식하여 특별한 자바 코드 없이도 Spring annotation 만으로도 외부의 YAML 파일을 로드할 수 있다. 만약 데이터베이스가 없는 데모 어플리케이션을 만들거나 테스트를 위한 간단한 데이터를 외부 파일에서 조작하기 위해서 YAML 파일을 사용하여 데이터를 정의하여 사용하면 매우 간단하게 처리할 수 있다.

## 소스코드

- https://github.com/saltfactory/saltfactory-java-tutorial/tree/spring-boot-yaml/SpringBootDemo

## 참조

1. https://bitbucket.org/asomov/snakeyaml
2. http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html
3. https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html


