---
layout: post
title : Spring 웹 프로젝트 컨트롤러 내부에서 RestTemplate을 사용하여 REST API (POST 메소드) 호출하기
category : java
tags : [java, spring, springboot, rest]
comments : true
images :
  title : http://assets.hibrainapps.net/images/rest/data/770?size=full
---


## 서론
Microservice 아키텍처와 유사한 서비스를 구현한 이후 웹 어플리케이션에서 컨트롤러에서 API 서버로 REST 요청을 해야하는 경우를 만날 수 있다. 만약 Spring 기반은 웹 어플리케이션을 사용하고 있다면 RestTemplate을 사용하여 이 과정을 간단하게 처리할 수 있다. 이 포스팅에서는 Spring 기반 프로젝트에서 웹에서 Form 요청을 처리할 때 내부적으로 API 서버로 요청하여 다시 Spring에 결과를 적용하는 방법을 소개한다.

<!--more-->

## 테스트를 위한 Spring 웹 프로젝트 생성

빠른 테스트를 진행하기 위해서 우리는 [IntelliJ에서 SpringBoot를 사용하여 웹 프로젝트를 생성하기](http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html)글에서 SpringBoot 프로젝트를 생성하는 것을 살펴보았다. 이 포스팅을 따라서 테스트를 위한 웹 프로젝트를 먼저 생성한다.

## 테스트를 위한 REST API 서버 만들기

우리는 Spring 웹 프로젝트에서 REST API 서버로 데이터를 전송하고 결과를 받은 후 결과 값을 Spring 웹 프로젝트 결과 뷰에 반영을하는 예제를 만들 것이다. 그래서 우리는 Spring 프로젝트 외 REST API 서버가 필요하다. 우리는 간단하게 Ruby on Rails를 사용하여 REST API 서버를 만들 것이다. 시스템에 Ruby가 설치되어 있고 gem 사용하여 Rails를 설치했다는 가정하에 설명을 한다. 만약 Rails가 설치되어 있지 않을 경우는 `gem install rails`로 먼저 설치를 진행한다.

```
rails new TestApp
```

![](http://assets.hibrainapps.net/images/rest/data/763?size=full&m=1446096463)

TestApp 프로젝트를 생성하면 간단하게 scaffold를 사용하여 Post에 관련된 REST API를 만들어보자.

```
rails g scaffold Post title:string content:text
````

![](http://assets.hibrainapps.net/images/rest/data/764?size=full&m=1446096539)

scaffold를 사용하여 Post 서비를 위한 기본 구조를 만들었으면 데이터베이스를 마이그레이션하여 테이블을 생성한다.

```
rake db:migrate
```

![](http://assets.hibrainapps.net/images/rest/data/765?size=full&m=1446096636)

REST API 서버로 만든 이 프로젝트의 **PostsController**를 열어보자. 그리고 다음과 같이 코드를 추가한다. Rails는 기본적으로 크로도메인 접근을 막기 위해서 auth_token을 사용하는데 REST API 테스트를 위해서 이 부분을 skip 하도록 코드를 추가하였다. 그리고 POST 처리를 담당하는 부분에 파라미터의 처리를 위하는 코드를 추가하였다. **title**과 **content** 라는 이름의 파라미트 값을 저장하기 위해서이다.

```ruby
class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?

	…

  # POST /posts
  # POST /posts.json
  def create
    # @post = Post.new(post_params)
    @post = Post.new
    @post.title = params[:title]
    @post.content = params[:content]

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
	…

  private
	…

    def json_request?
      request.format.json?
    end
end

```

이제 Rails 서버를 실행시켜보자

```
rails s
```

우리가 만든 REST API 서버가 정상적으로 동작하는지 테스트를 해보자. 우리는 POST로 값을 요청해서 해로운 글(Post)가 정상적으로 등록되어 결과를 JSON으로 주는지 확인할 것이다. CURL을 사용하여 POST 요청을 테스트해본다.

```
curl --data "title=API 테스트&content=테스트내용" http://localhost:3000/posts.json
```

결과는 다음과 같이 나타날 것이다.

![](http://assets.hibrainapps.net/images/rest/data/766?size=full&m=1446097599)

간단히 테스트를 위한 REST API 서버가 만들어졌다. 다시 SpringBoot 프로젝트로 가보자.

## RestTemplate를 사용하여 POST 처리하기

마이크로서비스와 비슷한 웹 프로젝트 구조를 다시한번 설명한다.

**Spring Web Server(new.html GET)** -> **Spring Web Server(POST)** -> **Rails REST API Server** -> **Spring Web Server(show.html 결과)**

Spring 기반의 웹 페이지인 http://localhost:8080/posts/new URL로 **GET**으로 요청한다. new.html 뷰의 입력폼에 데이터를 입력하고 submit을 클릭하면 http://localhost:8080/posts 로 **POST**를 요청한다. Spring 기반의 서버에서 POST 요청을 처리하는 메소드에서 내부적으로 http://localhost:3000/posts.json 으로 POST로 REST API를 요청하는데 이때 앞에서 FORM으로 요청한 모든 파라미터를 그대로 가지고 REST API 서버로 POST를 요청한다. 실제 데이터를 데이터베이스에 저장하는 것은 이곳에서 처리를하고 저장된 결과 값을 가지고 JSON을 만들어서 다시 Spring 컨트롤러에게 reponse를 돌려준다. 이제 Spring 서버의 컨트롤러는 받은 결과를 Model에 저장하여 show.html으로 결과 값을 화면에 보여주게 된다.

우선 POST 요청이 들어오면 내부적으로 REST API 서버로 데이터를 요청하는 것을 위해 다음과 같이 이전에 만든 코드를 수정한다.

```java
package net.saltfactory.demo;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestTemplate;

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

    @RequestMapping(value = "/posts", method = RequestMethod.POST)
    public String createPost(@ModelAttribute Post post, Model model) {
//        model.addAttribute("post", post);

        RestTemplate restTemplate = new RestTemplate(); // 내부적으로 새로운 서버에 REST API 요청을 하기 위한 Rest Template 도구
        restTemplate.getMessageConverters().add(new StringHttpMessageConverter());

        String url = "http://localhost:3000/posts.json"; // 새로운 서버의 URL 변경
        Post postObj = restTemplate.postForObject(url, post, Post.class); // 새로운 서버의 JSON 결과를 POJO로 매핑
        model.addAttribute("post", postObj); // View 업데이트를 위한 Model에 POJO 객체 저장

        return "show";
    }

}
```

SpringBoot 웹 어플리케이션을 다시 빌드하고 실행시켜서 브라우저를 열어보자.

http://localhost:8080/posts/new

![](http://assets.hibrainapps.net/images/rest/data/767?size=full&m=1446098277)

new.html 폼이 나타나면 입력폼에 값을 입력하고 submit을 클릭한다.


Rails로 만든 REST API 서버의 로그를 살펴보면 **/posts.json** 으로 POST 요청이 들어와서 데이터베이스에 저장을 하고 json으로 결과를 반환한 것을 볼 수 있다.

![](http://assets.hibrainapps.net/images/rest/data/768?size=full&m=1446098683)

REST API 서버로 부터 정상적이 JSON 응답을 받은 Spring 프로젝트의 PostsController는 restTemplate를 사용하여 POJO를 사용하여 Model에 저장하고 show.html을 화면에 보여준다.

![](http://assets.hibrainapps.net/images/rest/data/769?size=full&m=1446099658)


## 결론

API 기반 서버를 만들고 여러개의 웹 어플리케이션이 컨트롤러에서 내부적으로 API를 요청하고 결과를 View로 업데이트하는 기능이 필요하게 되었다. 우리는 HTTP 요청에 대한 이해가 필요하다. 특히 Spring에서 Form을 사용할 때는 ModelAttribute에 관한 이해가 필요한데 웹 폼에 사용했던 파라미터를 그대로 REST API 서버로 POST를 요청하기 위해서 가장 간단한 방법은 컨트롤러로 들어왔던 파라미터를 꺼내어 다시 REST API를 요청하는 request의 파라미터를 추가해서 POST를 요청하는 것이다. 하지만 이럴때 문제가 발생할 수 있다. FORM으로 입력 받은 문자열을 **request.getParameter()**로  추출한 뒤 다시 파라미터로 정의하여 입력할 때 문자열에 특수 문자나 URLEncoding에 대한 이해가 추가적으로 필요하게 될 수도 있다. 우리는 어플리케이션 개발자가 REST API 서버에서 명시한 스팩을 그대로 사용할 수 있는 Model을 만들어서 Form을 만든 후, 컨트롤러 내부에서 **RestTemplate**를 사용하여 넘어온 모델을 그대로 사용해서 REST API 서버로 POST를 요청한 후 json을 받아서 뷰에 반영할 ModelAndView를 업데이트 할 수 있도록 코드를 만들었다.

[RestTemplate](http://docs.spring.io/autorepo/docs/spring-android/1.0.x/reference/html/rest-template.html)는 REST API 요청을 간단히 처리할 수 있도록 설계된 모듈이다. Spring IO 기반으로 프로젝트를 진행한다면 내부적으로 REST API를 요청할 때 매우 유용하게 사용할 수 있을 것이다.


## 참고

1. http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html
2. http://docs.spring.io/autorepo/docs/spring-android/1.0.x/reference/html/rest-template.html

## 연구원 소개

- 작성자 : [송성광](http://saltfactory.net/profile) 개발 연구원
- 프로필 : http://saltfactory.net/profile
- 블로그 : http://blog.saltfactory.net
- 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
- 트위터 : [@saltfactory](https://twitter.com/saltfactory)
- 페이스북 : https://facebook.com/salthub
- 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
- 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
