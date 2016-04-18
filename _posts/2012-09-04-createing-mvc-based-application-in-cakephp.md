---
layout: post
title: CakePHP를 이용하여 MVC 기반 웹 서비스 CRUD 개발하기
category: php
tags: [cakephp, php, mvc, crud]
comments: true
redirect_from: /181/
disqus_identifier : http://blog.saltfactory.net/181
---

## 서론

이번 포스팅은 이전 포스팅을 기반으로 CRUD ( Create, Retrieve, Update, Delete)를 기능을 추가하는 예제를 테스트한다. 이번 포스팅도 앞의 포스팅과 동일하게 CakePHP document를 기반으로 실험하도록 한다.

<!--more-->

웹 서비스에서 CRUD는 특별한 일이 없는 이상 URL 요청으로 처리가 된다. (예외는 API나 소켓 요청인데 이 또한 URL 기반으로 되어져 있다.) 요즘은 이러한 URL 요청대신에 RESTful 서비스라고 말을 하기도 하지만 이말을 쉽게 말하면 URL 과 헤더타입에 따라서 처리를 해주는 서비스라고 생각할 수 있다. 일축하고, 우리는 이러한 CRUD 요청을 처리하기 위해서 이것을 담당하는 것이 Controller라고 앞의 포스팅에서 다루었다. 앞의 포스팅에서는 Post의 전체를 가져와서 리스팅해주는 index 메소드를 하나 생성해 두었는데, 그 아래 CRUD를 처리하기 위해서 view, add, edit, update, delete 메소드를 추가할 것이다.


## Retrieve

앞에서 만들어둔 index 메소드는 블로그의 글을 리스팅하는데 우리는 블로그 제목을 클릭하면 해당되는 글의 상세 정보를 보기 위한 view 메소드를 추가할 것이다.

/app/Controller/PostController.php 파일을 열어서 다음과 같이 코드를 수정한다. 제목을 누르면 해당하는 글의 id 를 가지고 view 를 처리할 하는 View 파일을 호출할 것인데 이 때 Model 중에 id에 해당하는 데이터를 찾아서 View 파일에 post 라는 이름으로 저장하여 넘겨주게 된다.

```php
<?php
class PostsController extends AppController {
public $helpers = array('Html', 'Form');

    public function index() {
         $this->set('posts', $this->Post->find('all'));
    }

    public function view($id = null) {
        $this->Post->id = $id;
        $this->set('post', $this->Post->read());
    }
}
```

컨트롤러 작업을 마쳤으면 /app/View/Posts/view.ctp 파일을 추가하고 다음과 같이 코드를 저장한다. PostController의 view 메소드에서 id 기반으로 가져온 post의 값 중에서 title, created, body를 출력시키는 코드이다.

```php
<!-- File: /app/View/Posts/view.ctp -->

<h1><?php echo h($post['Post']['title']); ?></h1>

<p><small>Created: <?php echo $post['Post']['created']; ?></small></p>

<p><?php echo h($post['Post']['body']); ?></p>
```

이제 브라우저에서 바르게 동작하는지 확인해보자.
http://cake.saltfactory.local/posts

![](http://asset.hibrainapps.net/saltfactory/images/48762e77-fb8e-4e16-b83f-1820daa73e2c)

이 목록 중에서 1번째 "The title" 이라는 글을 클릭해보자. 그러면 http://cake.saltfactory.local/posts/view/1 URL이 요청될 것이다. 이 URL 요청은 PostsController의 view 메소드가 id 라는 파라미터와 함께 요청을 받아서 처리하게 된다. 이 때 Model Post에서 id 값이 1 인 post를 조회해서 처리하기 때문에 trace를 살펴보면 query 의 where 조건에 Post.id=1 인 쿼리가 실행 된 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/08282493-73d2-4bfa-9f63-b74776ed7868)

## Create

create를 처리하기 위해서는 두 가지 요청이 필요하다 하나는 데이터를 입력시키는 뷰를 보여주는 Form을 가진 URL 요청이고 하나는 데이터를 받아서 데이터베이스에 저장하는 URL 요청이다. 이 두 가지의 요청을 처리하기 위해서 우리는 동일한 URL 요청에 HTTP의 헤더의 method가 GET 일 경우와 Post 인 경우에 따라서 요청을 처리하는 것을 구분할 수 있도록 구현할 것이다.  우리는 add 라는 메소드를 추가하는데 $this->request->is('post') 라는 것으로 이 컨트롤러의 요청이 POST 인지를 비교해서 POST일 경우는 Post->save()를 통해서 request로 넘어온 data를 저장한다. 그리고 컨트롤러가 관장하는 Session에 flash 메세지를 저장해서 index URL 요청으로 redirect 시키도록 했다. flash는 데이터가 저장되고 난 다음 view에 저장이 성공적으로 되었다고 표시해주기 위한 영역이다.

```php
<?php
class PostsController extends AppController {
public $helpers = array('Html', 'Form');

    public function index() {
         $this->set('posts', $this->Post->find('all'));
    }

    public function view($id = null) {
        $this->Post->id = $id;
        $this->set('post', $this->Post->read());
    }

    public function add() {
            if ($this->request->is('post')){
                    if ($this->Post->save($this->request->data)){
                            $this->Session->setFlash('Your post has been saved.');
                            $this->redirect(array('action' => 'index'));
                    } else {
                           $this->Session->setFlash('Unable to add your post.');
                    }
            }
    }

}
```

그렇지 않고 GET 요청이 들어오면 단순하게 add를 할 수 있는 뷰 파일을 요청할 것이다. /app/View/Posts/add.ctp 파일을 추가하여 다음 코드를 추가한다.

```php
<!-- File: /app/View/Posts/add.ctp -->

<h1>Add Post</h1>
<?php
echo $this->Form->create('Post');
echo $this->Form->input('title');
echo $this->Form->input('body', array('rows' => '3'));
echo $this->Form->end('Save Post');
?>
```

MVC 기반의 어플리케이션에서 Model을 만들어서 사용하는 이유가 테이블의 매핑을 단순히 하기 위해서만 사용하는 것은 아니다. Model은 데이터의 저장되는 내용 뿐만 아니라 데이터의 관계, 그리고 속성 비즈니스 규칙까지 정의할 수 있다. Model의 관계 정의에 대해서는 이후에 설명하도록 하고 지금은 Model의 속성 validation 을 하는 것을 살펴보겠다. 쉽게 말하면 Post라는 Model이 데이터베이스에 저장되거나 어플리케이션에서 사용될 때 속성의 값의 형태가 어떤지 체크를 하는 것이다. Post는 반드시 제목과 내용이 있어야 한다고 비즈니스 규칙을 정했다고 하자. 이를 Model에 반영할 수 있는데 다음과 같은 코드로 반영할 수 있다.
/app/Model/Post.php 를 다음과 같이 수정한다.


```php
<?php
class Post extends AppModel {
    public $validate = array(
        'title' => array(
            'rule' => 'notEmpty'
        ),
        'body' => array(
            'rule' => 'notEmpty'
        )
    );
}
```

이렇게 Model의 validate로 title과 body의 비즈니스 규칙을 notEmpty라고 정의하게 되면 이후에 반드시 이 두가지 속성에는 빈 값이 들어가면 안된다는 체크를 실시하게 된다.

브라우저에서 http://cake.saltfactory.local/posts/add 라고 요청해보자. 단순하게 브라우저에 요청했으니 GET으로 요청하게 될 것이기 때문에 다음과 같이 PostsController에서 GET의 요청을 처리하는 뷰를 볼 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/7859e0d2-6646-4285-b78e-c5c29dda9cd5)

데이터를 저장하고 Save Post 버튼을 누르면 동일한 http://cake.saltfactory.local/posts/add 로 요청하는데 POST로 요청하기 때문에 데이터를 저장하고 flash 메시지를 만들어서 index 로 리다이렉트를 할 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/d5055579-5210-4e3d-a2d8-d70b5a91e194)

![](http://asset.hibrainapps.net/saltfactory/images/f5d3230a-2515-4343-8f9b-03085b9fd856)

만약 데이터의 값을 입력하는데 우리가 Model의 비즈니스 규칙에 맞지 않게 데이터를 입력했을 경우는 다음과 같이 validate의 체크에 의한 에러가 사용자에게 알려줄 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/9e5fc19b-c11b-4519-b0d9-008972353720)

## Update

update 처리는 create 처리와 비슷하다. http://cake.saltfactory.local/posts/edit/1 이라는 똑 같은 URL 요청에 GET일 경우는 id = 1 인 Post를 조회해서 업데이트할 수 있는 Form 에 데이터를 넣고 수정된 데이터를 POST로 요청하면 처리하는 edit 메소드를 PostsController에 추가할 것이다.


```php
<?php
class PostsController extends AppController {
public $helpers = array('Html', 'Form');

    public function index() {
         $this->set('posts', $this->Post->find('all'));
    }

    public function view($id = null) {
        $this->Post->id = $id;
        $this->set('post', $this->Post->read());
    }

    public function add() {
            if ($this->request->is('post')){
                    if ($this->Post->save($this->request->data)){
                            $this->Session->setFlash('Your post has been saved.');
                            $this->redirect(array('action' => 'index'));
                    } else {
                           $this->Session->setFlash('Unable to add your post.');
                    }
            }
    }

    public function edit($id = null) {
            $this->Post->id = $id;
            if ($this->request->is('get')){
                    $this->request->data = $this->Post->read();
            } else {
                    if ($this->Post->save($this->request->data)){
                            $this->Session->setFlash('Your post has been updated.');
                            $this->redirect(array('action' => 'index'));
                    } else {
                            $this->Session->setFlash('Unable to update your post.');
                    }
            }
    }

}
```

edit 메소드에서 Post를 찾아서 수정할 수 있도록 /app/View/Posts/eidt.ctp 파일을 생성하고 다음 코드를 추가한다.

```php
<!-- File:/app/View/Posts/edit.ctp -->
<h1>Edit Post</h1>
<?php
        echo $this->Form->create('Post', array('action' => 'edit'));
        echo $this->Form->input('title');
        echo $this->Form->input('body', array('rows'=>3));
        echo $this->Form->input('id', array('type'=>'hidden'));
        echo $this->Form->end('Save Post');
```

브라우저를 열어서 http://cake.saltfactory.local/posts/edit/1 을 요청해보자. 다음 그림과 같이 id 가 1인 post를 조회해서 수정할 수 있도록 edit.ctp의 Form에  데이터를 넣어서 뷰를 보여준다.

![](http://asset.hibrainapps.net/saltfactory/images/44021652-63dd-41ce-bcdd-686e657eb504)

Save Post를 하면 index URL 요청으로 리다이렉트를 하면서 flash를 보여 줄 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/65919c2d-35c6-4f70-8381-b9f2bf80ff01)


## Delete

delete  처리 또한 create나 update 처리와 동일하다. 다만 delete 처리는 http URL 요청이 GET으로 들어올 경우 보안상 문제가 있기 때문에 GET은 예외처리를 할 수 있도록 코드를 추가한다. 다음 코드가 CRUD를 모두 포함한 PostsController.php의 전체 코드이다.

```php
<?php
class PostsController extends AppController {
public $helpers = array('Html', 'Form');

    public function index() {
         $this->set('posts', $this->Post->find('all'));
    }

    public function view($id = null) {
        $this->Post->id = $id;
        $this->set('post', $this->Post->read());
    }

    public function add() {
            if ($this->request->is('post')){
                    if ($this->Post->save($this->request->data)){
                            $this->Session->setFlash('Your post has been saved.');
                            $this->redirect(array('action' => 'index'));
                    } else {
                           $this->Session->setFlash('Unable to add your post.');
                    }
            }
    }

    public function edit($id = null) {
            $this->Post->id = $id;
            if ($this->request->is('get')){
                    $this->request->data = $this->Post->read();
            } else {
                    if ($this->Post->save($this->request->data)){
                            $this->Session->setFlash('Your post has been updated.');
                            $this->redirect(array('action' => 'index'));
                    } else {
                            $this->Session->setFlash('Unable to update your post.');
                    }
            }
    }

    public function delete($id){
            if ($this->request->is('get')){
                    throw new MethodNotAllowedException();
            }
            if ($this->Post->delete($id)){
                    $this->Session->setFlash('The post with id: ' . $id . ' has been deleted.');
                    $this->redirect(array('action' => 'index'));
            }
    }
}
```

이제 CRUD를 모두 사용할 수 있도록 /app/View/Posts/index.ctp 파일을 다음과 같이 수정하자.

```php
<!-- File: /app/View/Posts/index.ctp -->

<h1>Blog posts</h1>
<p><?php echo $this->Html->link('Add Post', array('action' => 'add')); ?></p>
<table>
    <tr>
        <th>Id</th>
        <th>Title</th>
        <th>Actions</th>
        <th>Created</th>
    </tr>

<!-- Here's where we loop through our $posts array, printing out post info -->

    <?php foreach ($posts as $post): ?>
    <tr>
        <td><?php echo $post['Post']['id']; ?></td>
        <td>
            <?php echo $this->Html->link($post['Post']['title'], array('action' => 'view', $post['Post']['id'])); ?>
        </td>
        <td>
            <?php echo $this->Form->postLink(
                'Delete',
                array('action' => 'delete', $post['Post']['id']),
                array('confirm' => 'Are you sure?'));
            ?>
            <?php echo $this->Html->link('Edit', array('action' => 'edit', $post['Post']['id'])); ?>
        </td>
        <td>
            <?php echo $post['Post']['created']; ?>
        </td>
    </tr>
    <?php endforeach; ?>

</table>
```

다시 http://cake.saltfactory.local/posts 를 브라우저에서 열어보자. 이제 제법 블로그 서비스를 할 수 있는 모양을 갖추었다.

![](http://asset.hibrainapps.net/saltfactory/images/2b16d5cb-642f-4e17-becf-1ae55bbca40b)

## Routes 설정

/app/Config/routes.php 파일은 이 어플리케이션으로 들어오는 모든 URL요청을 특정 컨트롤러에게 매핑해주는 역활을 하는 파일이다.
우리는 http://cake.saltfactory.local/posts 로 PostsController에 URL 요청을 보내는 것을 만들었다. 만약 우리가 블로그 어플리케이션을 가지고 웹 서비스를 한다고 가정할 때 http://cake.saltfactory.local 이라는 디폴트 URL로 들어왔을때 블로그의 목록을 보여주는 http://cake.saltfactory.local/posts/index 의 요청과 동일하게 하고 싶을 것이다. 이 때 우리는 routes.php를 설정해서 이 요구사항을 해결할 수 있다. 다음과 같이 / 디폴트 URL 요청이 들어오면 controller를 posts 컨트롤러와 매핑하고 메소드는 action 이 index 메소드와 매핑되도록 설정한다.

```php
<?php
/**
 * Routes configuration
 *
 * In this file, you set up routes to your controllers and their actions.
 * Routes are very important mechanism that allows you to freely connect
 * different urls to chosen controllers and their actions (functions).
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Config
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
/**
 * Here, we are connecting '/' (base path) to controller called 'Pages',
 * its action called 'display', and we pass a param to select the view file
 * to use (in this case, /app/View/Pages/home.ctp)...
 */
/*         Router::connect('/', array('controller' => 'pages', 'action' => 'display', 'home')); */
        Router::connect('/', array('controller' => 'posts', 'action' => 'index'));
/**
 * ...and connect the rest of 'Pages' controller's urls.
 */
        Router::connect('/pages/*', array('controller' => 'pages', 'action' => 'display'));


/**
 * Load all plugin routes.  See the CakePlugin documentation on
 * how to customize the loading of plugin routes.
 */
        CakePlugin::routes();

/**
 * Load the CakePHP default routes. Remove this if you do not want to use
 * the built-in default routes.
 */
        require CAKE . 'Config' . DS . 'routes.php';
```

## 결론

아마 앞의 포스팅과 이 포스팅을 따라서 해봤을 때, 두가지 사실을 깨닫게 될 것이다. 첫번째로, MVC 기반의 웹 서비스 개발을 CakePHP를 사용하면 매우 간단하게 구축할수 있다는 것이다. 특히 ActiveRecord와 유사한 Model 메소드들은 Query를 직접사용하지 않고도 데이터를 저장하고 조회하는 기능을 처리할 수 있기 때문에 이후에 마이그레이션도 편리할 것이고 기대된다. 두번째는, CakePHP가 놀랄만큼 Ruby on Rails와 닮았다는 것을 느끼게 될 것이다. 파일의 구조 위미며, 라우터 설정, 모델 유효성 검사까지 모두 RoR과 매우 닮은 형태를 하고 있다. 하지만 CakePHP의 URL 요청은 RoR의 요청과 조금 다르다. URL 패턴이며 RESTful 형태의 요청이 다르다는 것을 알 것이다. 하지만 CakePHP는 MVC 기반의 웹 어플리케이션을 매우 쉽게 구조화해서 만들 수 있다는 것을 알 수 있다. 앞으로 RoR과 비교하면서 더 많은 테스트를 진행할 것이다. 다음은 RoR의 Scaffolding과 같은 기능을 CakePHP에서 어떻게 구현했는지에 대해서 살펴볼 예정이다.

## 참고

1. http://book.cakephp.org/2.0/en/getting-started.html#blog-tutorial

