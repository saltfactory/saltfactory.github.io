---
layout: post
title: CakePHP의 scaffolding 사용하기
category: php
tags: [cakephp, php, scaffolding, scaffold, mvc]
comments: true
redirect_from: /182/
disqus_identifier : http://blog.saltfactory.net/182
---

## 서론

CakePHP는 Ruby on Rails와 매우 닮았다고 모든 사람들은 공감을 할 것이라고 생각든다. 그래서 CakePHP를 사용하면서 당연히 RoR의 scaffoding을 찾아볼 수 밖에 없었다. scaffoding에 대한 내용은 [Scaffolding으로 빠르게 웹 개발하기](http://blog.saltfactory.net/177) 글을 참조하길 바란다. scaffolding은 MVC 프레임워크에서 마술사와 같이 알아서 척척 가장 기본이 되는 코드를 생성해서 구조화 시켜준다. 그럼 CakePHP에서 scaffolding은 어떠할까?

두가지 의문으로 접근한다.
1. RoR과 동일하게 shell command로 코드를 생성하는 것인가?
2. RoR과 동일하게 물리적인 코드를 생성해서 MVC 패턴에 맞게 파일을 추가하여 기본 코드를 만들어주는 것인가?

CakePHP 의 scaffoding는 다음과 같다.
1. RoR과 다르게 shell command를 사용하지 않는다. CakePHP는 PHP로 만들어진 프레임워크이기 때문에, 이말을 다시말하자면 웹 페이지에서 돌아가는 언어이기 때문에 PHP 코드 안에서 $ 변수로 scaffoding을 인식해서 CakePHP가 제공하는 템플릿으로 MVC가 자동으로 구현되어진다. (php shell 명령으로 커멘드 라인에서 명령어 수준으로 처리할 수 있지만 CakePHP에서는 public scaffod 변수 scaffolding을 한다.)
2. RoR과 달리 실제 물리적인 파일이 생성되는 것이아니라, CakePHP가 제공하는 scaffolding 템플릿 기반으로 Model, View, Controller가 내부적으로 구현되어지기 때문에 기본 Template이 아닌 custom scaffolding 파일을 추가해서 처리할 수도 있다.

우리는 앞서 [Scaffolding으로 빠르게 웹 개발하기](http://blog.saltfactory.net/177) 와 [CakePHP를 이용하여 MVC 기반 웹 서비스 CRUD 개발하기](http://blog.saltfactory.net/181) 글에서 간단한 블로그 예제를 해보았다. 이어서 scaffoding 기능을 가지고 코드를 추가해 나갈 것이다.

<!--more-->

우리는 Categories를 처리하기 위한 코드를 생성한다고 가정한다. 그래서 Categories의 테이블을 생성한다. RoR에서는 scaffolding 으로 Model과 동시에 migration 파일이 생성되는 CakePHP에서는 그렇지 않다. 다음 코드를 MySQL로 접속해서 실행한다.

```sql
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/833f7d68-6dae-40e3-901c-a56412ab2fe0)

다음은 /app/Controller/CategoriesController.php 파일을 추가한다. 앞의 포스팅에서 PostsController를 구현할 때 기억을 해보면 URL요청이 들어오는 패턴에 따라서 메소드를 추가해 주었는데, CategoriesController에서는 public $scaffold 변수를 추가했다.

```php
<?php
class CategoriesController extends AppController {
    public $scaffold;
}
```

이제 http://cake.saltfactory.local/categories 라고 요청을 해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/dfac0e9a-d43a-4545-9d9e-44f44a8a0f30)

마술이 일어났다. CategoriesController에 public $scaffold 변수 하나만 추가했을 뿐인데 MVC 코드들이 마치 생성이라도 된 것 처럼 URL 요청을 받아들이고 모델로 데이터베이스의 테이블을 조회하며, 뷰 파일까지 나타내어주고 있다. 앞에서 PostsController를 처리하기 위해서 많은 파일과 코드들을 힘들게 만든것이 허무하게 느껴질 정도이다. 그럼 CRUD가 동작되는지도 살펴보자.

## Create

http://cake.saltfactory.local/categories/add

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7e79f213-54c8-4924-9840-90e645a79a4d)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b8fa32f5-fd91-4fb2-8fb8-05d6fe4c8585)

## Retrieve

http://cake.saltfactory.local/categories/view/1

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4ceb33b9-16b4-46c4-bfe4-b12b9785ecf2)

## Update

http://cake.saltfactory.local/categories/edit/1

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c7cdbd94-2b90-4fd8-b275-678ca8baa586)

## Delete

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/dceff601-3faf-49da-b544-053fe89436a2)

CakePHP의 scaffolding RoR의 scaffolding보다 더 마술같이 MVC 패턴을 만들어준다. 코드를 생성하지 않아서 약가은 낯설지만 분명히 CRUD가 모두 가능할 수 있도록 자동으로 어플리케이션이 구현되어지는 결과를 만들어 냈다. RoR의 scaffoding은 MVC 코드를 생성하기 때문에 customization 하기 쉽지만 CakePHP는 어떻게 Customization을 해야할지 당황스러울 수 있다. 다음에는 CakePHP의 Scaffoding을 custom 하는 방법에 대해서 포스팅을 할 예정이다. 이 포스팅에서 소개하는 내용은 CakePHP도 scaffolding을 지원하고 있으며, scaffoding을 통애서 개발 속도가 빨라지고 개발 코드를 줄일 수 있는 효과를 얻을 수 있다는 것을 테스트해보았다.


## 참고

1. http://book.cakephp.org/2.0/en/controllers/scaffolding.html


