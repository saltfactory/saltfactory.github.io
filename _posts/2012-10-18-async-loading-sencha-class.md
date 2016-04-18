---
layout: post
title: Sencha Touch의 Ext.require 를 이용해서 비동기로 Javascript (센차클래스) 로딩하기
category: sencha
tags: [javascript, sencha, ext, async, hybrid]
comments: true
redirect_from: /205/
disqus_identifier : http://blog.saltfactory.net/205
---

## 서론

Sencha Touch는 Javascript Mobile Development Framework 로 현존하는 WebApp UI framework 중에서 가장 기능이 많고 좋은 아키텍처를 가지고 있지 않나 생강이 든다. 하지만 이러한 Sencha Touch를 익히고 자유롭게 사용하기가 그리 만만하지가 않다. 한국어로 번역되거나 Sencha Touch 2에 관한 도서가 이제 조금씩 나오기는 하지만 Sencha Touch 에 관한 자료가 많지 않아서 영어의 장벽이 높아서 쉽게 포기하는 framework 중에 하나로 알려져 있기도 하다. 하지만 정작 문제는 Sencha Touch는 Sencha Touch의 표현식 (물론 Sencha 도 Javascript의 표현을 그대로 따르고 있다)을 이해해야지만 자유롭게 사용할 수 있다는 것이다. 그중에서 Sencha Touch에 클래스를 정의해서 사용하는 방법과 새롭게 생성한 클래스를 Sencha Touch에 사용할 수 있게 로딩하는 방법에 대해서 알아보자.
<!--more-->

Sencha Touch에서 Javascript 파일을 추가할 때 application 구조가 아닌 특정 클래스를 만들어서 사용한다고 생각하면 다음과 같이 script를 html 파일 안에서 정의하여 사용할 수 있다.

다음은  Sencha Touch를 사용해서 사용자 정의 클래스 (Custom Class)를 생성해서 사용하는 예제 코드이다. Person.js 라는 클래스를 만들어서 사용한다고 했을 때, Sencha Touch의 Ext.define으로 클래스를 정의하고 Ext.create로 객체를 생성해서 사용할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>
    <script type="text/javascript">
        Ext.define("Person", {
            config:{
                name:null,
                email:null
            },
            constructor:function (options) {
                this.initConfig(options);
            }
        });

        document.addEventListener("DOMContentLoaded", function(){
            var person = Ext.create("Person", {
                            name:"saltfactory",
                            email:"saltfactory@gmail.com"
                        });

            document.getElementById("person-name").innerHTML = person.getName();
            document.getElementById("person-email").innerHTML = person.getEmail();
        }, false);


    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

![](http://asset.hibrainapps.net/saltfactory/images/524c0faa-4bd0-47fd-9c01-690a759cc872)

위 스크립트 코드를 HTML에 삽입하지 않고 Person.js 라는 파일로 관리한다고 하면 다음과 같이 Person.js 파일과 <script src="Person.js"></script>로 변경이 될 것이다.

```javascript
/**
 * filename : Person.js
 */
Ext.define("Person", {
    config:{
        name:null,
        email:null
    },
    constructor:function (options) {
        this.initConfig(options);
    }
});
```

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>

    <script src="Person.js"></script>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function(){
            var person = Ext.create("Person", {
                            name:"saltfactory",
                            email:"saltfactory@gmail.com"
                        });

            document.getElementById("person-name").innerHTML = person.getName();
            document.getElementById("person-email").innerHTML = person.getEmail();
        }, false);


    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

위 코드로 변경한 다음에 브라우저를 리로딩해도 결과는 동일하다는 것을 확인할 수 있을 것이다. Sencha Touch는 같은 경로에 클래스 이름과 동일한 Javascript 파일이 있으면 이름으로 객체를 구분하기 때문에 동일한 클래스로 생각하고 로드를 자동으로 해준다. 방금 추가한 <script src="Person.js">를 삭제시켜보자.
개발을 위해서 sench touch debug all javascript를 상용하고 있다면 아래와 같은 Warning이 발생하기는 하지만 같은 경로에 있는 Person.js를 로드해서 Person 클래스를 해석하고 객체를 만들 수는 있다는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/7e6141e3-3f98-4fbf-a0c4-05df6a03f589)

Sencha Touch는 클래스 파일을 동기모드와 비동기모드로 로드를 할 수 있는데 기본적으로는 동기모드로 로드를 한다. 만약 비동기모드로 로드를 하고 싶을 경우는 Ext.require를 이용해서 처리할 수 있다. 하지만 다음과 같이 Ext.require 만 사용해서 Sencha 의 클래스 파일을 로드시키면 비동기방식으로 로드를 하기 때문에 document의 로드와 순서적으로 비동기 적으로 로드가 발생해서 Ext.require로 로드가 된 것이 아니라 같은 경로의 Person.js 파일을 먼저 찾게 되어서 WARN 이 발생한 것을 확인할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>

    <!--<script src="Person.js"></script>-->
    <script type="text/javascript">
        Ext.require("Person");

        document.addEventListener("DOMContentLoaded", function(){
            var person = Ext.create("Person", {
                            name:"saltfactory",
                            email:"saltfactory@gmail.com"
                        });

            document.getElementById("person-name").innerHTML = person.getName();
            document.getElementById("person-email").innerHTML = person.getEmail();
        }, false);

    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

![](http://asset.hibrainapps.net/saltfactory/images/fe47bf80-8396-4ea6-a28c-0b2d2329ac20)

정말 Ext.require과 상관없이 Ext.create가 이름을 가지고 Person.js 찾는지 확인하기 위해서 Person.js 파일을 classes라는 폴더로 이동을 하고 다시 실행을 시켜보았다. 그러면 다음과 같은 에러를 보게 될 것이다. 즉, 클래스를 명시적으로 로드하는 것을 찾지도 못했고, 명시된 것이 없어서 클래스 이름과 같은 Person.js 파일을 같은 경로에서 찾아봤지만 찾을 수 없다는 에러이다.

![](http://asset.hibrainapps.net/saltfactory/images/29422cfe-22ad-42c3-a342-1691bc03e50d)

그래서 우리는 Sencha에게 Person이 ./classes/Person.js 라는 파일이라는 힌트를 주기로하자.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>

    <!--<script src="Person.js"></script>-->
    <script type="text/javascript">
        Ext.Loader.setConfig({
            paths:{
                'Person':'./classes/Person.js'
            }
        });

        Ext.require("Person");

        document.addEventListener("DOMContentLoaded", function(){
            var person = Ext.create("Person", {
                            name:"saltfactory",
                            email:"saltfactory@gmail.com"
                        });

            document.getElementById("person-name").innerHTML = person.getName();
            document.getElementById("person-email").innerHTML = person.getEmail();
        }, false);


    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

다음 코드를 추가한다. 아직 비동기문제로 발생하는 Ext.require의 문제는 해결되지 않았다.

![](http://asset.hibrainapps.net/saltfactory/images/3e48a209-5d86-4da0-a121-3da119167761)

Secnch는 어플리케이션 로드를 담당하는 Ext.application 이라는 객체를 가지고 있는데 이것을 이용해서 Ext.require의 비동기로드 문제를 해결할 수 있다. Ext.application은 센차가 필요한 모든 클래스를 로드하고 난 다음에 launch 라는 메소드를 callback 하기 때문에 Ext.application의 launch 메소드에서 위 코드를 구현하면 된다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>

    <!--<script src="Person.js"></script>-->
    <script type="text/javascript">
        Ext.Loader.setConfig({
            paths:{
                'Person':'./classes/Person.js'
            }
        });

        Ext.require("Person");

        Ext.application({
            name:"SenchaTutorial",
            launch:function () {
                var person = Ext.create("Person", {
                    name:"saltfactory",
                    email:"saltfactory@gmail.com"
                });

                document.getElementById("person-name").innerHTML = person.getName();
                document.getElementById("person-email").innerHTML = person.getEmail();
            }
        });

//        document.addEventListener("DOMContentLoaded", function(){
//            var person = Ext.create("Person", {
//                            name:"saltfactory",
//                            email:"saltfactory@gmail.com"
//                        });
//
//            document.getElementById("person-name").innerHTML = person.getName();
//            document.getElementById("person-email").innerHTML = person.getEmail();
//        }, false);



    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

이제 좀더 Sencha 스러운 코드가 완성이 되었다. Ext.application에서는 require라는 속성이 있기 때문에 Ext.require로 외부 클래스 파일을 로드한 것 처럼 Ext.application의 require 속성으로 외부 클래스를 로드해서 Sencha 어플리케이션 적용할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>sencha 테스트</title>
    <link href="../../lib/sencha-touch/sencha-touch.css" rel="stylesheet"/>
    <script src="../../lib/sencha-touch/sencha-touch-all-debug.js"></script>

    <!--<script src="Person.js"></script>-->
    <script type="text/javascript">
        Ext.Loader.setConfig({
            paths:{
                'Person':'./classes/Person.js'
            }
        });

//        Ext.require("Person");

        Ext.application({
            name:"SenchaTutorial",
            requires:["Person"],
            launch:function () {
                var person = Ext.create("Person", {
                    name:"saltfactory",
                    email:"saltfactory@gmail.com"
                });

                document.getElementById("person-name").innerHTML = person.getName();
                document.getElementById("person-email").innerHTML = person.getEmail();
            }
        });

//        document.addEventListener("DOMContentLoaded", function(){
//            var person = Ext.create("Person", {
//                            name:"saltfactory",
//                            email:"saltfactory@gmail.com"
//                        });
//
//            document.getElementById("person-name").innerHTML = person.getName();
//            document.getElementById("person-email").innerHTML = person.getEmail();
//        }, false);



    </script>
</head>
<body>
    <h1>Sencha Ext.require 테스트</h1>
    <ul>
        <li>name : <strong id="person-name"></strong> </li>
        <li>email : <strong id="person-email"></strong> </li>
    </ul>
    <p></p>
</body>
</html>
```

## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.Loader
2. 이광호, Interpress, "센차터치 2 입문에서 활용까지", p. 106~p. 126

