---
layout: post
title: Sencah Touch2를 이용한 하이브리드 앱 개발 - 8.Model
category: sencha
tags: [sencha, sencha touch, hybridapp, hybrid, view, model]
comments: true
redirect_from: /150/
disqus_identifier : http://blog.saltfactory.net/150
---

## 서론

Sencha 의 장점이 바로 사용 가능한 UI 컴포넌트를 내장하고 있는 것 말고 MVC 패턴으로 개발을 할 수 있게 프레임워크가 만들어져 있다는 것이라고 Sencha Touch 튜토리얼 가장 첫 번째 포스팅에서 이야기를 한 적이 있다. 우리는 이전 포스팅까지 MVC 중에서 View에 관한 내용에 대해서 중점적으로 테스트하면서 살펴보았다. 이번 포스팅은 MVC 중에서 Model에 관한 부분을 살펴볼 것이다.

<!--more-->

Model 이야기를 하기에 앞서 우리는 MVC 가 무엇인지 다시한번 이해하길 원한다. (http://ko.wikipedia.org/wiki/모델-뷰-컨트롤러, http://en.wikipedia.org/wiki/Model–view–controller)

위키피디아에서는 MVC에 대해서 다음과 같이 정의한다.

>MVC 는 소프트웨어 공학에 사용되는 아키텍처 패턴이다.이 패턴을 성공적으로 사용하면, 사용자 인터페이스로부터 비즈니스 로직을 분리하여 애플리케이션의 시각적 요소나 그 이면에서 실행되는 비즈니스 로직을 서로 영향 없이 쉽게 고칠 수 있는 애플리케이션을 만들 수 있다. MVC에서 모델은 애플리케이션의 정보(데이터)를 나타내며, 뷰는 텍스트, 체크박스 항목 등과 같은 사용자 인터페이스 요소를 나타내고, 컨트롤러는 데이터와 비즈니스 로직 사이의 상호동작을 관리한다.

우리는 지금까지 애플리케이션의 시각적 요소인 사용자 인터페이스 요소에 대해서 계속 테스트해 왔다. 이제 모델을 다룰것인데, 모델은 어플리케이션 내면에서 실행되는 비즈니스 로직을 담당하는 부분이다. 사람들은 Model을 일종의 데이터 저장하거나 데이터베이스 엑세스를 하는 공간으로 생각하기도 하는데, 그런 생각의 단적인예로 MVC 패턴으로 개발하면서 DAO(Data Access Object)만 Model로 분류해서 나눈 경우를 볼 수 있다. 하지만 Model은 데이터를 저장하는 것 뿐만 아니라 비즈니스 로직이 표현하는 부분이라고 말할 수 있다. 그래서 어떤 예제에서는 MVC 패턴으로 개발하기 위해 모듈을 나누면서 Model 패키지를 logic으로 표현하는 예제도 볼 수 있을 것이다.
그리고 또 한가자 오해하고 있는 부분이 있는데 MVC에서 Model은 데이터를 처리만 할 뿐이고 나머지는 Controller가 View에게 데이터를 주게 하고 View는 Controller를 통해서만 Model에게 데이터를 처리하도록 시킨다고 생각한다는 것이다. 아래 그림을 살펴보자. Model,View는 Controller를 매개체로 두어서 매핑하기도 하지만 Model이 View로 또는 View가 Model로 직접적으로 사용될 수 있다는 것이다.

![](http://cfile22.uf.tistory.com/image/1652603F4FBC38CA2746A2)

Model은 비즈니스 로직을 담당하는 영역이기도 하지만, Model은 실세계의 객체를 의미있는 집합으로 구성할수 있는 논리적인 객체로 표현하는 부분이기도 하다. 다시 말하자면 어 떤 객체를 표현하기 위한 논리적은 실체(Entity) 된다는 것이다. 더 쉽게 말하면 데이터가 저장되는 특징을 표현하는 부분이다. 이 부분에서는 객체가 다른 객체와 어떠한 관계가 있는지(Entity-Relationship)를 표현할 수 있다. 이렇게 객체와 객체의 관계를 표현하기 위해서 우리는 비즈니스 로직을 모델링할때 Class Diagram 이나 ERD(Entity-Relationshp Diagram)으로 표현할 수 있는 것이다.

그럼, 과연 Sencha에서는 어떻게 Model을 사용하는지 살펴보자.
우리의 앱에서는 학생의 정보를 관리하는 기능이 있다. 그래서 학생에 대한 정보를 저장해야할 모델이 필요하다고 가정하자.
우리는 Sencha에서 view를 다른 디렉토리로 분리해서 관리했다. Sencha에서는 MVC 패턴에 따라 디렉토리를 분리해서 저장할 수 있게 지원해주는데 /app/view, /app/model, /app/controller, /app/store 이렇게 나누어서 저장할 수 있다. 우리는 Model을 하나 만들 것이기 때문에 /app/model/Student.js를  생성하여 다음 코드를 저장해보자.

## Model 정의

학생의 정보를 표현하기 위해서 우리는 Student 라는 모델을 정의하는데 이름, 나이, 이메일주소, 성별을 저장할 수 있는 간단한 모델을 정의했다.

```javascript
/**
* file : Student.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.model.Student', {
	extend: 'Ext.data.Model',
	alias: 'Student',

    config: {
        fields: [
{name: 'name',	type: 'string'},
{name: 'age',	type: 'int'},
{name: 'email',	type: 'string'},
{name: 'gender',type: 'string'}
        ]
    }
});
```

이 모델에 데이터를 직접 넣어보기로 하자. Controller 를 이용해서 데이터를 넣을 수도 있지만 아직 controller에 대해서 언급하지 않았기 때문에 우리는 app.js에서 앱이 실행하면 바로 이 모델을 사용할 것이다. app.js 파일을 다음과 같이 수정하자.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	models: ['Student'],
    launch: function() {
		var student = Ext.create('Student',{
			name : '홍길동',
			age : 20,
			email : 'hongildon@test.com',
			gender : '남'
		});

		console.log(student)
	}
});
```

위에서 SaltfactorySenchaTutorial.model.Student를 Student로 alias를 만들어 뒀기 때문에 우리가 뷰에서 alias를 사용한 것과 동일하게 모델에서도 alias를 사용할 수 있다. 간단하게 학생 정보를 입력해서 생성하고 console.log 로 학생정보를 출력해보자. Ext.create('Student')로 만든 인스턴스 자체를 console로 출력해서 내용을 살펴보면 다음과 같이 출력이 된다. 이 중에서 Model의 data에 저장된 내용을 살펴보면, 우리가 Model을 정의한 속성이 나오고, app.js에서 입력한 속성의 값이 data에 저장된 것을 확인할 수 있다. 뿐만 아니라 이 Model에서 생성된 인스턴스의 identifier(id)가 자동으로 생성되어진것을 확인할 수 있다.

![](http://cfile25.uf.tistory.com/image/163A06434FBC4062273485)

위에는 Model에서 인스턴스를 생성하는 시점에 마치 Ext.Container를 생성할 때 지정하는 config 처럼 생성자와 함께 넣어주는 예인데, 이것을 인스턴스 생성 후 데이터를 입력할 때는 다음과 같이 할 수 있다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	models: ['Student'],
    launch: function() {
		var student = Ext.create('Student');
		student.name = '홍길동';
		student.age = 20;
		student.email = 'hongildong@gmail.com';
		student.gender = '남';

		console.log(student)
	}
});
```

## Model 유효성 검사

Model은 실체의 속성을 정의하는 기능 뿐만 아니라 속성의 값을 검사하는 비즈니스 로직을 포함할 수 있다. 다음 코드를 살펴보자.
Model에서 속성의 유효성 검사를 하기 위해서는 validations에 속성의 유효성 규칙을 지정하면 된다. 반드시 입력해야하는 값에는 'presence'를, 값의 길이는 'length', 어떤 집합의 하나일 경우는 'inclusion', 이외의 것은 'exclusion', 그리고 값의 입력되는 포멧을 정규식 규칙으로 지정해서 검사할 수 있다.

```javascript
/**
* file : Student.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.model.Student', {
	extend: 'Ext.data.Model',
	alias: 'Student',

    config: {
        fields: [
{name: 'name',	type: 'string'},
{name: 'age',	type: 'int'},
{name: 'email',	type: 'string'},
{name: 'gender',type: 'string'},
{name: 'userid',type: 'string'}
        ],

	validations: [
	{type: 'presence', field: 'age'},
	{type: 'length', field: 'name', min: 2},
	{type: 'inclusion', field: 'gender', list: ['남', '여']},
	{type: 'format', field:'userid', matcher:/([a-z]+)[0-9]{2,3}/}
]
    }
});
```

그리고 입력하는 데이터를 일부러 유효성 검사에 맞지 않게 수정해보자. app.js를 다음과 같이 수정하고 인스턴스를 Model의 유효성 검사를 하는 validate()를 이용해서 에러가 검출되는지 테스트 해보았다. 유효성 규칙에 바드시 age 가 있어야하는데 누락되었고, 성별은 '남','여' 둘중에 선택해야하는데 'Male'을 입력했고, userid에는 문자와 숮자만 되는데 + 특수기호를 입력했다.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.application({
    name: 'SaltfactorySenchaTutorial',
	models: ['Student'],
    launch: function() {
		var student = Ext.create('Student',{
			name: '홍길동',
			email: 'hongildong@gmail.com',
			gender: 'Male',
			userid: 'hongildong+'
		});

		var errors = student.validate();
		console.log(errors);
		//console.log(student)
	}
});
```

결과는 errors에 다음과 같이 유효성 검사 실패된 것을 message와 함께 가져와서 확인할 수 있다.

![](http://cfile27.uf.tistory.com/image/173FDD444FBC45A51DE816)

## Model Relationship(Association)

모델은 서로 다른 모델과의 관계를 표현할 수 있어야 한다. 그래서 관계성을 표현하기 위해서 학과와 학생의 모델을 가지고 예제를 들어보기로 하자. ERD에서도 마찬가지로 학과와 학생의 관계를 표현하기 위해서 1:M 의 관계를 표현할 수 있다. 객체 관계에서도 ERD와 마찬가지고 1:M 관계를 표현할 수 있으며 belongsTo, hasMany 라는 용어로 표현하기도 한다. Ruby on Rails 를 개발한 경험이 있는 개발자라면 ActiveRecord에서 제공하는 Model의 Association(or Relationship)을 표현하는 방법에 대해서 경험을 해본 적이 있을 것이다. 우리는 하나의 학과에 여러명의 학생을 가질수 있는 모델을 만들기 원하기 때문에 다음과 같이 두가지 모델을 가지고 표현을 해보자.

먼저 학과 모델이다. 학과는 여러명의 학생을 가질 수 있기 때문에 hasMany라는 것으로 정의할 수 있다. 그리고 어떤 모델을 M개 가질 수 있는지 model 이라는 키를 가지고 모델 타입을 지정한다. 그리고 관계(association)의 이름을 지정한다. 나중에 이 이름으로 assocation을 가져올 수 있는 getter 메소드가 만들어진다.

```javascript
/**
* file : Department.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.model.Department', {
extend: 'Ext.data.Model',
alias: 'Department',

config: {
fields: ['id','name'],
hasMany:{
model:'SaltfactorySenchaTutorial.model.Student',
name:'students'
}
}
});
```

반대로 학생은 학과에 종속된 모델이다. 학생은 반드시 학과에 포함이 되어야 하기 때문에 belongsTo라는 이름으로 관계를 정의할 수 있다. 아래는 학생모델이 학과 모델에 따른다는 관계의 의미로 belongsTo로 학과 모델을 지정하였다.

```javascript
/**
* file : Student.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.model.Student', {
extend: 'Ext.data.Model',
alias: 'Student',

config: {
fields: ['id','name'],
belongsTo: 'SaltfactorySenchaTutorial.model.Department',
}
});
```

이렇게 서로의 관계를 연결하기 위해서 RDBMS에서는 foreign key를 것을 사용한다. 이 예제들은 모두 identifier를 id라는 이름으로 사용하고 있어서 default identifier로 연결이 되는 것인데, 좀더 복잡하기 위해 foreign key의 이름을 지정하거 컬럼이름을 지정할 수 도 있다. (그에 대한 예제는 다음 기회에 다른 포스팅에서 볼수 있을 것 같다. 이 포스팅은 모델에 관한 간단한 개념을 설명하는게 목적이다.). 이해를 돕기 위해서 위에서 테스트한 vaildator, 타입 속성은 모두 제외하였다.

이제 두가지의 모델이 존재하고, 두 모델의 관계를 정의하였다. 그럼 모델의 관계를 실험해보기로 하자. 모델은 관리되는 데이터의 속성과 관계를 정의하고 있을 뿐이지 실제 데이터를 저장하고 있지 않다. 실제 데이터를 저장하는 것은 Sencha에서 Store라는 곳에서 데이터의 저장을 담당하고 있다. Store에 대해서는 다른 포스팅에서 Store를 가지고 UI에 데이터를 출력하는 예제를설명할 때 다시 자세히 설명하기로하고, Store 는 단지 Model 형태를 가진 데이터를 저장하는 공간이라고 이해하자. /app/model, /app/view 와 같이 /app/store에 Store를 지정할 수 있다. 학과 모델 정보를 저장하기 위한 store를 DepartmentStore라고 하고, 학생 모델 정보를 저장하기 위한 store를 StudentStore라고 정의해보자.

```javascript
/**
* file : DepartmentStore.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.define('SaltfactorySenchaTutorial.store.DepartmentStore', {
	extend: 'Ext.data.Store',
	requires: ['SaltfactorySenchaTutorial.model.Department'],

	config:{
		model:'SaltfactorySenchaTutorial.model.Department',
		proxy:{
			type:'ajax',
			url:'app/data/departments.json',
			reader:{
				type:'json',
				rootProperty:'departments'
			}
		}
	}
});
```

```javascript
/**
* file : StudentStore.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.define('SaltfactorySenchaTutorial.store.StudentStore', {
	extend: 'Ext.data.Store',
	requires: ['SaltfactorySenchaTutorial.model.Student'],

	config:{
		model:'SaltfactorySenchaTutorial.model.Student',
		proxy:{
			type:'ajax',
			url:'app/data/students.json',
			reader:{
				type:'json',
				rootProperty:'students'
			}
		}
	}
});
```

Ext.data.Store는 데이터를 저장하기 위한 것인데 model 형태로 저장하기 위해서 model을 지정하였다. 그리고 proxy는 어떠한 데이터를 획득해서 저장해야하는지에 대한 메카니지즘을 지정할 수 있는데, type이 localstorage는 브라우저내의 localstorage를 이용하는 것이고, type이 ajax는 같은 도메인 상의 데이터를 ajax 요청으로 데이터를 획득할 수 있는 방법을 지정하는 것이다. 그리고 url은 호스트의 주소이고, 그 URL을 요청하면 json 데이이터 타입을 읽기 위해서 reader에 type을 json 으로 지정하였다. 그리고 json의 속성중에서 root 속성이되는 것을 지정을 한다. 그럼 json 데이터를 살펴보자. 테스트에서는 학과가 포함한 학생들에 대해서 모델의 관계를 확인하는 작업을 할 것이다. 즉, 위에서 DepartmentStore.js 에 관련된 proxy만 사용하고 그 proxy에서 요청하는 json 데이터는 아래와 같이 생겼다. 만약 Students.json을 요청하면 최상위 속성이 students이고 학생 속성안에 학과 속성들이 포함되어 있을 것이다.

```javascript
/**
* file : departments.json
* author : saltfactory
* email : saltfactory@gmail.com
*/


{
	"departments":
 [
	{
            "id": 1,
            "name": "컴퓨터공학과",
            "students": [
                {
                    "id": 1,
                    "name": "홍길동"
                },
                {
                    "id": 2,
                    "name": "성춘향"
                }
            ]
        },
        {
            "id": 2,
            "name": "정보통신공학과",
            "students": [
                {
                    "id": 3,
                    "name": "이순신"
                },
                {
                    "id": 4,
                    "name": "이몽룡"
                }
            ]
        }
    ]
}
```

이렇게 연관관계를 나타내고 있는 json을 Sencha의 Model의 관계로 매핑을 바로 모델의 hasMany와 belongsTo로 만들어낼 수 있다.
테스트를 위해서 app.js를 다음과 같이 수정하자.

```javascript
/**
* file : app.js
* author : saltfactory
* email : saltfactory@gmail.com
*/


Ext.application({
name: 'SaltfactorySenchaTutorial',
models: ['Student', 'Department'],
stores: ['DepartmentStore', 'StudentStore'],

launch: function() {

var store = Ext.getStore("DepartmentStore");

store.load({
callback:function(){
department = store.first();
department.students().each(function(student){
console.log(student)
console.log(student.get("name"));
console.log(student.getDepartment().get("name"))
});

}
});

}
});
```

샘플 json을 보면 알듯, department의 첫번째 데이터는 "컴퓨터공학과"이다. 그리고 그 컴퓨터공학과에는 각각 "홍길동"과 "이순신"이 포함되어 있다. Ext.getStore로 이 앱에 등록된 Store를 가져오고 store.load를 실행시켜서 데이터를 획득한다. 이렇게 되면 ajax로 데이터를 가져오게 설정하였기 때문에 아래와 같이 departmets.json을 요청해서 json을 해석해서 Department와 Student의 Model 형태로 저장을 하게 된다.

![](http://cfile3.uf.tistory.com/image/145C23404FCC4015263400)

그리고 store가 load 된 이후 callback으로 메소드를 하나 구현했다. DepartmentStore에 데이터가 모두 저장이 되면 그 store에 저장된 데이터 중에서 첫번째의 데이터(여기선 "컴퓨터공학과")를 가져와서 그 학과가 가지고 있는 학생들을 가져오기 위해서 department.students() 메소드를 호출한다. 이것은 Department의 association으로 students라는 이름으로 정의를 했기 때문에 사용할 수 있는 것이다. 만약 이것을 정의하지 않았다고 하면 이런 에러가 나타날 것이다.

```javascript
/**
* file : Department.js
* author : saltfactory
* email : saltfactory@gmail.com
*/

Ext.define('SaltfactorySenchaTutorial.model.Department', {
	extend: 'Ext.data.Model',
	alias: 'Department',

     config: {
		 fields: ['id','name'],
		 // hasMany:{
		 // 			model:'SaltfactorySenchaTutorial.model.Student',
		 // 			 name:'students'
		 // }
     }
});
```

![](http://cfile9.uf.tistory.com/image/191427454FCC410E1636FB)

만약 설정이 모두 완벽하게 되었다면 아래와 같이 console에 로그가 출력될 것이다. Object는 department에서 students를 각각 each로 루프를 돌면서 한 학과에 포함된 학생 데이터를 나타나는 것이다. 그 안에 보면 DepartmentBelongsToInstance라고 우리가 Student Model에 Department와 관계를 정의한 내용이 적용되어 있음을 확인할 수 있다. 그리고 departmet.students()라고 사용할 수 있는 이유가 Department에서 hasMany로 studetns를 지정하였기 때문이다. 이렇게하여 컴퓨터공학과에서 홍길동과 이순신을 찾을 수 있고, 가각 학생들이 belongsTo 정의에 의해서 student.getDepartment()로 학생 데이터에서 바로 연결된 학과 데이터를 가져와서 get("name")으로 학과 이름을 출력할 수 있게 되었다.

![](http://cfile3.uf.tistory.com/image/16540E3F4FCC3EF5169FB0)

아마도 Ruby on Rails를 개발한적이 있는 분들이라면 이렇게 모델을 정의하는 방법과 데이터의 관계가 어핵하지 않을 수 있지만 ERD를 작성해본적만 있고 객체 모델링을 하지 않은 분은 약간 어색할 수도 있을 것 같다. 하지만 원리는 모델과 모델의 관계를 정의하는 것이고 모델간의 관계를 foreign key와 같이 객체와 매핑해서 지정한다고 생각하면 이해하기 쉬울 것이다. 하지만 여기서 한가지 말하고 싶은 것은 이 association 테스트는 json으로만 가능하다는 것이다. 이 포스팅을 준비하면서 json 데이터가 아닌 localstorage를 이용하는 방법으로 테스트를 보여주려고 여러번 테스트했지만, 버그인지 몰라도 localstorage에 저장된 데이터를 store로 올리고 난 다음에 assocation이 바르게 표현이 되지 않았다. 이는 storea에 데이터를 add하는 과정에서 생기는 이슈같은데, json은 reader로 파싱하면서 자동적으로 json의 nested한 데이터를 모델의 관계에 따라 각각 저장하는 반면에 localstorage에서는 foreign key 로 department_id 와 같은 식의 속성을 연결해주어야 하기 때문인 것으로 짐작된다. 물론 store에 데이터를 load할때 해당되는 students 객체를 바로 add 하고난 뒤에 프로그램을 동작시키면 되긴하지만, 이해를 돕기 위해서 json을 이용해서 자동으로 assocation이 만들어지는 것을 보여주려고 json을 이용한 Model과 Store응 사용법에 대해서 작성을 하였다.

## 결론

Sencha는 MVC를 지원하는 UI 프레임워크로 데이터를 Model로 분리해서 정의할 수 있고 Store를 통해서 데이터를 저장할 수 있게 설계되어져 있다. Model은 데이터를 저장하는 기능을 하는 것 뿐만 아니라 비즈니스 로직이 포함되어 있기 때문에 Validation을 체크하거나 다른 속성을 만들어내는 작업도 포함된다. 뿐만 아니라 Model은 View에 바로 전달되어 사용되기도 하고 Controller에 의해서 데이터를 전달하기도 한다. 다음 포스팅에서는 Sencha의 MVC 마지막으로 Controller에 대해서 소개하도록 하겠다.

## 참고

1.  http://docs.sencha.com/touch/2-0/#!/api/Ext.data.Model
2. http://docs.sencha.com/touch/2-0/#!/api/Ext.data.association.HasMany
3. http://docs.sencha.com/touch/2-0/#!/api/Ext.data.association.BelongsTo
4. http://docs.sencha.com/touch/2-0/#!/api/Ext.data.Store
5. http://www.cnblogs.com/Jackey_Chen/archive/2011/07/24/2115572.html

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
