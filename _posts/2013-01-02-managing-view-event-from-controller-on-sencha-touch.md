---
layout: post
title: Sencha Touch에서 View 이벤트를 Controller에서 관리하기
category: sencha
tags: [sencha, javascript, sencha touch]
comments: true
redirect_from: /210/
disqus_identifier : http://blog.saltfactory.net/210
---

Sencha Touch의 가장 큰 장점이 MVC 프레임워크 지원이 된다는 것이다. 그런데 사실 MVC라고 말해도 일부 사람들(개발자가 아니거나, 한 클래스에 모든 기능을 다 넣어두는 개발자)에게는 MVC 지원이 뭐 그리 대수냐고 말할 수 있을지도 모른다. 우리는 흔히 HTML 코드와 Javascript를 분리해서 markup에 최대한 집중하여 웹 자체를 문서로 만들어보자 라는 생각을 하고 있다. 그래서 HTML 코드 안에 onClick 대신에 javascript에서 DOM을 selector를 이용해서 접근해서 이벤트를 등록하는 코드를 만들어 사용한다.

<!--more-->

다음 코드를 살펴보자. button이라는 HTML 엘리먼트에 모두 onclick 이벤트를 추가하는 가장 간단한 방법이다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>

    <script type="text/javascript">
        function onButtonClick(element) {
            console.log(element.id)
        }
    </script>
</head>

<body>
<button id="1" class="buttons" onclick="onButtonClick(this);">button1</button>
<button id="2" class="buttons" onclick="onButtonClick(this);">button2</button>
<button id="3" class="buttons" onclick="onButtonClick(this);">button3</button>
<button id="4" class="buttons" onclick="onButtonClick(this);">button4</button>
<button id="5" class="buttons" onclick="onButtonClick(this);">button5</button>
</body>

</html>
```

하지만 위 코드는 뷰에 이벤트처리 코드가 포함이 되어 있다. 위 코드는 다음과 같이 HTML 코드와 이벤트 처리를 분리할 수 있다. <script>안에 코드는 script src로 외부 파일로 분리할 수 있으니 결국 이 HTML 문서에서는 이벤트에 관련된 코드를 분리해서 관리할 수 있게 된다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>

    <script type="text/javascript">
        function onButtonClick(element) {
            console.log(element.id)
        }


        window.addEventListener("load", function () {
            var buttons = document.getElementsByClassName("buttons");

            for (var i = 0; i < buttons.length - 1; i++) {
                buttons[i].addEventListener("click", function () {
                    console.log(this.id)
                });

            }

        }, false);
    </script>
</head>

<body>
<button id="1" class="buttons">button1</button>
<button id="2" class="buttons">button2</button>
<button id="3" class="buttons">button3</button>
<button id="4" class="buttons">button4</button>
<button id="5" class="buttons">button5</button>
</body>

</html>
```

위 문서에서 이벤트 처리 코드만 파일로 분리했을 경우 남게되는 코드는 다음과 같다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <script src="buttons_handler.js"></script>
</head>

<body>
<button id="1" class="buttons">button1</button>
<button id="2" class="buttons">button2</button>
<button id="3" class="buttons">button3</button>
<button id="4" class="buttons">button4</button>
<button id="5" class="buttons">button5</button>
</body>

</html>
```

이렇게 문서와 이벤트 처리 코드가 분리되면 문서와 이벤트의 결합도가 낮아지게 된다. 이와 마찬가지로 Sencha Touch에서도 View에 이벤트를 처리하는 코드를 Controller에서 처리할 수 있게 분리한다면 View를 관리하는 파일에서 이벤트 처리를 모두 분리할 수 있다. 이것이 MVC에서 Controller의 event firewire 기능이다. Sencha Touch에서는 Ext에서 특정 참조에 대해서 이벤트를 등록할 수 있게 되어 있다. [Sencha Touch 2 (센차터치)를 이용한 웹앱 개발 - 9. 컨트롤러(Controller)](http://blog.saltfactory.net/154) 글을 참조하기 바란다.


### Controller에서 Panel 이벤트 처리

그럼 Sencha Touch에서 Panel에 관련된 이벤트를 간단하게 Controller에서 처리하는 방법을 살펴보자. Ext의 container에 관련된 객체들은 모두 listeners를 이용해서 이벤트를 처리를 listeners에 등록할 수 있다. 다음 코드는 Panel이 만들어질 때 발생하는 이벤트를 listeners에 등록해서 처리하는 것을 확인할 수 있다.

```javascript
/**
 * filename : MainPanel.js
 */

Ext.define('Saltfactory.view.MainPanel', {
    extend: 'Ext.Panel',
    id: 'MainPanel',
    alias: 'widget.MainPanel',
    xtype: 'mainpanel',
    config:{
        html:'Main Panel',
        listeners:{
            activate:function(){
                console.log('onActivate');
            },
            show:function(){
                console.log('onShow');
            },
            painted:function(){
                console.log('onPainted');
            }
        }
    },

    initialize: function () {
        this.callParent(arguments);
    }

});
```

위와 같이 listeners에 이벤트를 등록하면 다음과 같이 console에 로그가 남는 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/c4de5141-ca23-40c3-900f-a98049c8add4)

이젠 View에서 처리하는 이벤트를 Controller에서 처리하도록 해보자. 먼저 activate를 controller 에 등록하는 경우이다. MainPanelController를 파일을 만들고 app.js에 다음과 같이 controller와 view 파일을 등록한다.

```javascript
/**
 * filename:app.js
 */
Ext.application({
    name: 'Saltfactory',

    appFolder : 'js/test/app',
    views: ['MainPanel'],
    controllers: ['MainPanelController'],
    launch: function() {

        var mainView = {xtype:'mainpanel'};

        Ext.Viewport.add(mainView);


    }
});
```

그리고 view 파일인 MainPanel.js 에서 listeners를 모두 주석처리를 한다.

```javascript
/**
 * filename : MainPanel.js
 */

Ext.define('Saltfactory.view.MainPanel', {
    extend: 'Ext.Panel',
    id: 'MainPanel',
    alias: 'widget.MainPanel',
    xtype: 'mainpanel',
    config:{
        html:'Main Panel'
//        listeners:{
//            activate:function(){
//                console.log('onActivate');
//            },
//            show:function(){
//                console.log('onShow');
//            },
//            painted:function(){
//                console.log('onPainted');
//            }
//        }
    },

    initialize: function () {
        this.callParent(arguments);
    }

});
```

마지막으로 Controller에서 뷰 객체를 refs에 등록하고 해당하는 refs에 등록된 객체에 control을 정의한다. View의 listeners 에 등록된 activate가 controller에 activate로 정의하고 해당하는 함수의 이름을 지정하면 refs에 등록된 객체에 이벤트 처리 핸들러가 바인딩되게 된다.

```javascript
/**
 * filename : MainPanelController.js
 */

Ext.define('Saltfactory.controller.MainPanelController', {
    extend:'Ext.app.Controller',
    alias:'MainPanelController',
    config:{
        refs:{
            mainPanel:'mainpanel'
        },
        control:{
            mainPanel:{
                activate:'onActivate'
            }
        }

    },

    onActivate:function(){
        console.log('onActivate');
    },


    init:function () {
        console.log('init MainPanelContorller');
    },

    launch:function () {

    }

});
```

웹 앱을 다시 리로드 시켜보자. View에서 listeners에 등록해서 사용할 때는 view에 있는 handler 함수가 동작했지만 controller에 추가한 handler가 동작하고 있는 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5d4e950b-6607-49c5-9d3d-076078312c01)

이렇게 View의 event를 Controller로 분리함으로 View에는 실제 display시키는 것에만 집주할 수 있게 되고 Controller에서 이벤트와 데이터를 처리해서 View 코드의 의존성은 낮출수 있게 된다.

## 참고

1. http://docs.sencha.com/touch/2-0/#!/api/Ext.app.Controller
2. http://miamicoder.com/2012/how-to-create-a-sencha-touch-2-app-part-1/

