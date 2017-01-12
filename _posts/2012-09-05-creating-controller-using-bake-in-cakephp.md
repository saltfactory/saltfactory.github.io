---
layout: post
title: CakePHP의 bake로 빠르게 MVC 코드 생성하기 - Controller 생성
category: php
tags: [cakephp, php, bake, controller, mvc]
comments: true
redirect_from: /185/
disqus_identifier : http://blog.saltfactory.net/185
---

## 서론

앞의 포스팅 [CakePHP의 bake로 빠르게 MVC 코드 생성하기 - Model 생성](http://blog.saltfactory.net/183)에서 우리는 bake shell에 사용법에 대해서 이미 익숙하게 테스트를 했다. 이번 포스팅은 저번 포스팅에 이어 CakePHP의 bake를 이용해서 MVC 코드를 생성하는 두번째 포스팅으로 Model 코드에 이어서 Controller 코드를 생성하는 방법에 대해서 살펴보기로 한다.

<!--more-->


## bake

Model을 생성할 때 bake 명령어로 처리하는 방법과 bake shell을 이용하는 두가지 방법을 살펴보았는데 Controller로 동일하게 생성할 수 있다.

```
app/Console/cake bake controller Category
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/e02f2b17-3e87-4eba-8c18-86a29c47675f)

위의 그림 같이 cake bake controller Category를 하면 Category 모델이 처리하는 CategoriesController가 자동으로 만들어진다. app/Controller/CategoriesController.php 로 만들어진 파일을 열어보자.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e4ea88d6-c5cf-4f50-b8a4-e4afc3c31878)

디폴트로 생성한 CategoriesController은 scaffold로 컨트롤러가 만들어지는 것을 확인할 수 있다. 이렇게 scaffold로 만들어지는 컨트롤러는 따로 View 파일들이 필요하지 않기 때문에 Controller를 추가하고 바로 서비스를 할 수 있게 된다. 이제 bake shell로 Controller를 추가해보자.

```
app/Console/cake bake
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/640f4fb2-aaee-4224-afad-c8000756404d)

bake shell이 나타나나게 되면 Controller를 추가할 것이기 때문에 C를 선택한다. 그러면 Model을 추가할 때와 동일하게 Database를 선택하는 메뉴가 나타난다. default를 선택해서 개발하고 있는 데이트베이스를 선택한다.


![](http://asset.blog.hibrainapps.net/saltfactory/images/bfb0038d-f540-4be8-a0fd-4a4ce5b520b4)

데이터베이스를 선택하면 데이터베이스에서 가지고 있는 테이블을 기준으로 컨트롤러를 추가할 수 있는 목록을 보여준다. 우리는 Category를 처리하기 위해서 Categores를 선택한다. 이미 파일이 존재하면 overwrite 할지 물어보게 된다.
CakePHP에서는 컨트롤러를 만드는 방법이 두가지가 존재한다. 하나는 scaffold를 사용하는 방법이고 하나는 URL 패턴에 맞는 메소드를 추가하는 방법이다. 우선 scaffold 로 컨트로러를 만들어보자. y를 선택한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/865cc9bd-9728-4d44-96e9-6e047a7a8c50)

bake shell로 Model을 생성할 때와 동일하게 마지막에는 추가되는 Controller의 내부를 보여준다. public $scaffold 로 구성된 CategoriesController를 추가할지 마지막으로 확인한다. y를 선택해서 파일을 열어보면 위에서 bake 명령어로 추가한 코드와 동일하게 적용되어 있는 것을 확인할 수 있다.

만약 scaffold로 만들지 않는다고 할 때의 과정을 살펴보자. 위에서 Controller를 만들 때 scaffold를 사용할지 물어보는 화면에서 n을 선택한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/06e31a60-afbb-482a-bd12-753117556e00)

그러면 scaffold를 선택할 때와 달리 basic class methods 목록을 보여준다. CakePHP에서는 index(), add(), view(), edit()가 기본적인 메소드로 컨트롤러에 추가해서 만들어진다. 그리고 admin routing을 위한 메소드를 추가할지 물어보는데 admin에 관련된 자료는 다음에 테스트할 때 다시 설명하기로 하고 이번 테스트에서는 skip한다. 다음은 Controller를 추가할 때 HtmlHelper와 FormHelper를 추가할지 물어보는 메뉴와 component를 추가하는 메뉴가 나타나는데 이 역시 이후에 해당 포스팅에서 다시 자세히 설명하기로 하고 skip 한다. flash message를 사용할지 물어보는 메뉴에서 우리는 데이터 처리를 하고 flash message를 사용하기 때문에 y를 선택한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/eeca370e-497f-42c4-8900-3f7950ece1f6)

새로 생성된 CategoriesController.php를 열어보자.

```php
<?php
App::uses('AppController', 'Controller');
/**
 * Categories Controller
 *
 * @property Category $Category
 */
class CategoriesController extends AppController {

/**
 * index method
 *
 * @return void
 */
	public function index() {
		$this->Category->recursive = 0;
		$this->set('categories', $this->paginate());
	}

/**
 * view method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function view($id = null) {
		$this->Category->id = $id;
		if (!$this->Category->exists()) {
			throw new NotFoundException(__('Invalid category'));
		}
		$this->set('category', $this->Category->read(null, $id));
	}

/**
 * add method
 *
 * @return void
 */
	public function add() {
		if ($this->request->is('post')) {
			$this->Category->create();
			if ($this->Category->save($this->request->data)) {
				$this->Session->setFlash(__('The category has been saved'));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The category could not be saved. Please, try again.'));
			}
		}
	}

/**
 * edit method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function edit($id = null) {
		$this->Category->id = $id;
		if (!$this->Category->exists()) {
			throw new NotFoundException(__('Invalid category'));
		}
		if ($this->request->is('post') || $this->request->is('put')) {
			if ($this->Category->save($this->request->data)) {
				$this->Session->setFlash(__('The category has been saved'));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The category could not be saved. Please, try again.'));
			}
		} else {
			$this->request->data = $this->Category->read(null, $id);
		}
	}

/**
 * delete method
 *
 * @throws MethodNotAllowedException
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function delete($id = null) {
		if (!$this->request->is('post')) {
			throw new MethodNotAllowedException();
		}
		$this->Category->id = $id;
		if (!$this->Category->exists()) {
			throw new NotFoundException(__('Invalid category'));
		}
		if ($this->Category->delete()) {
			$this->Session->setFlash(__('Category deleted'));
			$this->redirect(array('action' => 'index'));
		}
		$this->Session->setFlash(__('Category was not deleted'));
		$this->redirect(array('action' => 'index'));
	}
}
```

## 결론

놀랍게도 bake shell 으로 몇번 과정을 거쳤을 뿐인데 멋지게 Database의 테이블과 매핑되는 Model을 기반한 Controller의 코드들이 생성이 되었다. CakePHP 에서는 기본적으로 bake 로 컨트롤러를 만들 때 CRUD 메소드를 만들어주는 것으로 확인된다. bake shell에서 scaffold로 만들지 않는다고 선택하고 basic class methods를 생성할지 물어보는 메뉴에서 n을 선택하면 비어있는 Controller가 만들어질 것이다. CakePHP는 개발자와 interactive하게 Controller를 간단하게 생성시키는 bake라는 기능을 추가함으로 MVC 기반 웹 개발을 매우 편리하고 빠르게 할 수 있게 실현한 것이다.


