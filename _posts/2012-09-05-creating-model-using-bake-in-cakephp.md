---
layout: post
title: CakePHP의 bake로 빠르게 MVC 코드 생성하기 - Model 생성
category: php
tags: [cakephp, php, bake, model, mvc]
comments: true
redirect_from: /183/
disqus_identifier : http://blog.saltfactory.net/183
---

## 서론

CakePHP는 이름처럼 PHP 케익을 구워낼 수 있는 bake라는 기능이 있다. Ruby on Rails의 generate 명령어와 비슷한 기능을 하는 것이 CakePHP에서는 바로 bake 로 할 수 있다. 즉, RoR 에서 rails generate Model, View, Controller의 코드를 생성하는 것 처럼 bake로 Model, View, Controller 코드를 생성할 수 있는 것이다.

<!--more-->

## bake

bake 기능은 cake 명령어로 사용을 할 수 있다.


```
app/Console/cake bake
```

bake를 실행하면 Interactive Bake Shell이 동작한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0751de0c-5afe-4585-b7cd-af8cc1e5fdf3)

bake로 관리할 수 있는 부분은 Database Configuration, Model, View, Controller, Project, Fixture, Test case 등 대부분의 CakePHP의 코드를 관리할 수 있다.
우리는 바로 앞 포스팅에서 CakePHP의 scaffolding을 사용하는 방법을 알아보았다. CakePHP의 scaffolding은 RoR과 달리 Database에 테이블을 생성하고 컨트롤러에서 public $scaffold 변수만 선언하면 MVC 코드 없이 자동으로 MVC 동작을 할 수 있는 prototyping으로 서비스를 구현할 수 있었다는 것을 테스트했다.

## bake command

우리는 bake를 이용해서 scaffold로 구현했던 Category의 Model을 생성하도록 하고 싶다.
bake의 사용은 bake shell을 이용하는 방법과 command로 처리하는 방법이 있는데 우선 command로 처리하는 방법을 살펴보자.

다음 명령어를 터미널에서 실행해보자. 이 명령어는 어플리케이션이 가지고 있는 database의 테이블을 조회해서 해당되는 Model을 모두 생성해주는 bake 명령어이다. bake model은 bake로 Model 코드를 생성하는데 all 이라는 argument는 모든 테이블의 모델을 생성하겠다는 의미이다.

```
app/Console/cake bake model all
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7c842012-2064-4203-bc68-65263278fae3)

bake로 Model에 관련된 코드와 파일을 생성하는 trace를 확인할 수 있고 생성이 마치고 나면 실제 물리적인 코드가 생성되는 것을 확인할 수 있다.


![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ab173e92-b3c2-4bc3-a043-1dd4b91d4f29)

app/Model 안에 Category.php로 생성된  파일을 살펴보자. 생성된 코드는 AppModel을 상속받아서 만든 Post.php의 모델과 동일한 형태를 가지고 있다. 그리고 디폴트로 name 이라는 필드의 비즈니스 규칙으로 공란을 허용하지 않는 validate 까지 생성된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/25e60842-ffe1-4880-8032-bd0377dcd2b5)


## bake shell

그럼 이 과정은 어떻게 일어났는지 bake shell로 과정을 살표보자. 다음 명령어로 bake shell 로 들어간다.

```
app/Console/cake bake
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/4da0d521-479e-4fd3-a66e-d52ad6eff183)

다음은 Model을 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/777305fe-cf30-4763-8447-41de04942da2)

CakePHP에서 코드 prototyping은 데이터베이스의 테이블을 분석해서 생성이되기 때문에 Model을 prototyping할 데이터베이스를 선택하는 메뉴가 나온다.
app/Config/database.php에서 우리는 다음과 같이 설정을 했었다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/30314d60-b27f-46db-95b9-be1b3a973def)

살펴보면 DATABASE_CONFIG 안에 default와 test 두가지를 사용한다고 정의하고 있기 때문에 bake에서 Model을 적용할 데이터베이스를 defaut/test 둘중에 선택하라고 나오는 것이다. default를 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/58c9a307-a1d0-4a7d-90f8-e82a786d9322)

bake에서 데이터베이스를 선택하면 현재 선택된 데이터베이스에서 Model을 생성할 수 있는 목록을 보여준다. Category 모델을 생성하기 원하기 때문에 우리는 Category를 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/cacb188a-6841-4bad-9d0b-8bda6636c312)

모델을 Category로 만들 것이라고 선택하면 validation을 적용할지에 대해서 묻는 메뉴가 나온다. y를 입력해보자. 아마도 Model에 적용할 수 있는 validate 규칙이 어떤 것이 있는지 궁금했다면 이 항목을 보면서 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f5780bbf-8b3d-4bf7-b8f4-1705038a451d)

위 내용은 Category 모델에서 id 필드에 대한 validation rule을 지정하는 것인데 skip 하고 넘어가자. 34를 입력한다. 그리고 name 필드가 나오면 우리는 notempty 규칙을 추가할 것이기 때문에 23번을 입력한다. 그리고 다른 필드를 더 설정할지 물어보면 n을 치고 넘어간다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/a75cbf5e-927f-48c4-b71b-7e97ee8ad082)

Model에서는 validation rule을 설정하여 필드의 값과 상태를 체크할 수 있을 뿐만 아니라 객체(Model)의 관계도 설정할 수 있는데 1:M, M:M, M:1 등의 관계를 설정할 수 있다. Category는 여러개의 Post를 가질 수 있는 객체 관계를 설정하기 위해서 y를 선택한다. 그러면 어떤 모델과의 관계를 추가할 것인지 물어보는 메뉴가 나오는데 이 때 y를 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/50cf182e-cede-45cb-aaa4-5c284893f518)

이제 Category 모델안에 추가된 관계의 타입을 지정하게 되는데 Category안에는 Posts들을 여러개 가질 수 있기 때문에 1:M 관계가 필요하다. 그래서 hasMany 관계를 선택한다. 그리고 그 관계를 나타낼 alias를 지정하라고 하는데 흔히 우리가 객체 관계나 foreign key로 사용할 때의 이름을 사용하면 된다. 객체 관계에서 Category는 여래개의 Post를 가지고 있을 것이기 때문에 Post라고 alias를 지정하자. 그러면 이 Post라는 alias는 어떤 클래스(Model) 이름으로 사용할지에 대해서 묻는 메뉴가 나오는데 Post로 지정한다. 그러면 Post에 사용할 foreignKey를 물어보는데 Post 객체에서 id를 참조할 수 있게 한다. 다른 관계는 예제에서 필요하지 않기 때문에 n을 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/05583f00-45ce-49b2-8d59-74f5d9786798)

bake shell 에서 Model에 관련된 모든 설정이 끝나면 다시 마지막으로 Model의 내용을 보여주면서 맞게 설정되었는지 확인을 한다. 우리가 원하던 설정은 name 이라는 필드에 notempty validation rule이 적용되고 Post라는 모델을 여러개 관계를 할 수 있는 Associations에 Category가 Post를 여러개 가질 수 있도록 설정한 것을 확인했다. y를 선택하면 파일이 존재하면 overwrite할지 물어본다. 우리는 cake bake model all 로 이미 Category 모델을 만들었기 때문에 모두 덮어 쓰기로 한다.
app/Model/Cateogry.php 에 Category 모델 파일이 생성이 된다. 우리는 이미 만들어두어서 파일을 덮어서 만들어졌지만, 파일이 존재하지 않을 경우는 bake shell에 설정한대로 만들어 질 것이다. Category.php 파일을 열어보자.


```php
<?php
App::uses('AppModel', 'Model');
/**
 * Category Model
 *
 * @property Post $Post
 */
class Category extends AppModel {

/**
 * Display field
 *
 * @var string
 */
	public $displayField = 'name';

/**
 * Validation rules
 *
 * @var array
 */
	public $validate = array(
		'name' => array(
			'notempty' => array(
				'rule' => array('notempty'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
		),
	);

	//The Associations below have been created with all possible keys, those that are not needed can be removed

/**
 * hasMany associations
 *
 * @var array
 */
	public $hasMany = array(
		'Post' => array(
			'className' => 'Post',
			'foreignKey' => 'id',
			'dependent' => false,
			'conditions' => '',
			'fields' => '',
			'order' => '',
			'limit' => '',
			'offset' => '',
			'exclusive' => '',
			'finderQuery' => '',
			'counterQuery' => ''
		)
	);

}
```

이렇게 우리가 원하는 Model 객체를 bake shell을 이용해서 만들어 낼 수 있다.

## 결론

CakePHP에는 RoR의 scaffold과 다른 prototype 기능으로 MVC 서비스를 만들어낼 수 있는 scaffolding을 지원했다.  RoR 웹 개발을 할 때 scaffold 는 MVC 파일과 코드를 직접 생성시켜주기 때문에 커스터마이징 하기 쉬운 반면에 CakePHP의 scaffold 는 너무 추상화 되어 있어서 사용자가 임의로 정의하거 수정하기 힘들거라 예상이 되었다. 그래서 RoR에서도 scaffold와 달리 MVC 코드를 generate 할 수 있는 rails generate 기능과 같은 것을 CakePHP에서 찾게 되었는데 CakePHP에도 bake라는 이름으로 유사한 기능을 할 수 있다는 것을 알 수 있게 되어서 실험하게 되었다. CakePHP의 bake shell은 RoR 보다 더 발전되어 있는 느낌이 들었다. RoR에서는 아직도 Model의 관계를 정의하거나 validation rule을 설정하기 위해서는 개발자가 직접 Model 파일을 열어서 수정해줘야하는 반면에 CakePHP에서는 bake shell로 개발자와 interactive하게 설정을 할 수 있다는 것이 인상적이었다. CakePHP는 현재 2.2 버전으로 릴리즈되어 있는 상태이다. 점차 CakePHP는 RoR을 비슷하게 만든 MVC 웹 프레임워크가 아니라 독자적으로 더 편리하고 빠른 개발을 할 수 있는 웹 개발 프레임워크로 발전해가고 있다는 느낌이 들어서 향후 업데이트되는 기능들을 지켜볼 재미가 생길것 같다.

## 참조

1. http://book.cakephp.org/2.0/en/console-and-shells/code-generation-with-bake.html


