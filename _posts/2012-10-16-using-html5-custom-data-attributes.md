---
layout: post
title: HTML5의 Custom Data Attributes를 이용하여 HTML을 의미있는 데이터로 사용하기
category: html5
tags: [html5, api, custom data attribute, attribute]
comments: true
redirect_from: /203/
disqus_identifier : http://blog.saltfactory.net/203
---

## 서론

HTML은 마커업언어이다. 즉 데이터를 표현하는 언어이지 데이터를 다루는 언어는 아니라는 것인데 우리는 HTML 문서가 좀더 Document 적으로 의미가 있는 데이터가 되길 바라면서 다양한 시도를 해왔다.

<!--more-->

### HTML4

id와 class 등 HTML4에서 지원하는 DOM의 attribute의 속성을 최대한 이용해서 HTML에 의미를 부여하고자 하는 노력을 했는데 예를 들어서 다음과 같은 경우이다.
다음은 코드는 myItems라는 items 집합중에서 각각 아이템의 데이터를 표현하기 위해서 HTML 문서의 스타일을 위한 class에다 style group으로 묶는 class를 사용하지 않고 의미를 부여하여 만든 것이다. 물론 id로 element를 구분할 수 있지만 개발자나 어플리케이션만 이해할 수 있는 특별한 이유로 class에 이런 방법으로 선언한 경험을 아마 한번쯤은 해봤을거라 예상된다.  

```html
<body>
	<ul id="myItems">
        <li class="items item1">item1</li>
        <li class="items item2">item2</li>
        <li class="items item3">1</li>
        <li class="items item4">4</li>
	</ul>
</body>
```

만약 이 아이텡들 중에서 타입이 number 인 것을 찾으려면 어떻게 해야 했을까? 아마 이렇게 사용을 했을 것이다.

```html
<body>
	<ul id="myItems">
        <li class="items item1 text">item1</li>
        <li class="items item2 text">item2</li>
        <li class="items item3 number">1</li>
        <li class="items item4 number">4</li>
	</ul>
</body>
```

위 코드를 XML로 표현하면 다음과 같이 표현할 수 있을 것이다. 좀더 의미는 분명하지만 XML 를 사용하기 위해서는 xlst 을 또 사용을 해야하는 불편함이 있다.

```html
<body>
	<ul>
		<li item="1" type="text">item1</li>
		<li item="2" type="text">item2</li>
		<li item="3" type="number">1</li>
		<li item="4" type="number">2</li>
	</ul>
</body>
```

이렇게 의미 있는 HTML의 문서를 표현할 수 있으면서도 엘리먼트 스타일 속성을 조작하지 않고도 HTML5에서는 Custom Data Attributes 라는 것으로 데이터 표현이 가능하게 되었다. 위의 코드를 다음과 같이 HTML5에서 `data-*`라는 속성을 이용해서 표현이 가능하다.

```html
<body>
	<ul id="myItems">
        <li class="items" data-item="1" data-type="text">item1</li>
        <li class="items" data-item="2" data-type="text">item2</li>
        <li class="items" data-item="3" data-type="number">1</li>
        <li class="items" data-item="4" data-type="number">4</li>
	</ul>
</body>

```

HTML에서 표현하기 힘들어서 css의 class를 이용해서 강제적으로 스타일과 상관없는 값을 추가해서 css 해석 속도도 떨어트리고 개발자들에게도 무슨 데이터를 어떻게 다룰지에 대한 명확한 표현이 떨어졌었는데, HTML5의 Custom Data Attributes 를 이용해서 마치 XML을 표현하듯 HTML 문서에 특정 엘리먼트의 설명을 구체적으로 할 수 있게 되었다. HTML의 의미있는 표현도 가능하고 이 의미로 만들어진 element에 identifier나 style class가 아닌 데이터의 표현과 관리가 가능해진 것이다.

HTML5에서는 header, section, article 등 태그가 몇개가 추가된 마크업언어의 확장판만을 지속적으로 강조하고 있는데 사실은 HTML5 API와 더불어 Custom Data Attributes는 HTML5의 매우 강력한 시멘틱 요소이면서 어플리케이션의 selector를 제공할 수 있게 해주어 HTML 문서 안의 데이터를 보다 효과적이고 효율적으로 관리할 수 있게 해주는 혁신이 일어난 것이다.

이렇게 만들어진 Custom Data Attributes로 만들어진 element에 접근은 다음과 같이 할 수 있다.

### css query

HTML5의 Custom Data Attribute를 CSS에서 쿼리하기 위해서는 다음과 같이 []로 표현할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<style type="text/css">
	[data-item] {
 		color:red;
 	}
	</style>
</head>
<body>
	<ul id="myItems">
        <li class="items" data-item="1" data-type="text">item1</li>
        <li class="items" data-item="2" data-type="text">item2</li>
        <li class="items" data-item="3" data-type="number">1</li>
        <li class="items" data-item="4" data-type="number">4</li>
	</ul>
</body>
</html>
```

[data-item]은 Custom Data Attributes에 data-item으로 지정된 모든 element를 쿼리한다는 의미이다. 위 파일을 HTML5를 해석할 수 있는 브라우저에서 열어보면 다음과 같이 출력되는 것을 확인할 수 있다.

![](http://cfile8.uf.tistory.com/image/0155424F507D1E14021EFA)

Custom Data Attributes에 해당하는 모든 element에 font:red;가 적용된 것을 확인할 수 있다. Custom Data Attributes를 이용하면 CSS 쿼리를 좀더 디테일하게 설정을 할 수 있다. 이유는 Custom Data Attributes가 바로 value를 가지고 있기 때문에 데이터의 값에 해당하는 element를 css로 쿼리를 할 수 있다는 것이다. 위 코드에서 data-item="4" 인 데이터를 HTML에서 문서에서 찾아서 스타일을 지정하려면 다음과 같이 css 쿼리를 사용한다.

```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<style type="text/css">
	[data-item="4"] {
		color:red;
	}
	</style>
</head>
<body>
	<ul id="myItems">
        <li class="items" data-item="1" data-type="text">item1</li>
        <li class="items" data-item="2" data-type="text">item2</li>
        <li class="items" data-item="3" data-type="number">1</li>
        <li class="items" data-item="4" data-type="number">4</li>
	</ul>
</body>
</html>
```

![](http://cfile3.uf.tistory.com/image/2074CE42507D49181382E4)

만약 data-type이 "text"로 지정한 여러개를 선택할 경우는 다음과 같이 하면 된다.

```css
[data-type="text"] {
		color:red;
}

```

![](http://cfile24.uf.tistory.com/image/126F3D3C507D496324EA82)

이렇게 여러개를 한번에 선택할 수 있는 css의 쿼리 뿐만 아니라 여러개의 속성 값을 지정하여 복합적인 데이터의 조건을 쿼리할 수 도 있다. `data-type`이 number 이고 그 중에서 `data-item` 이 3 인 것을 찾을 때 다음과 같이 할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<style type="text/css">
	[data-type="number"][data-item="3"] {
		color:red;
	}
	</style>
</head>
<body>
	<ul id="myItems">
        <li class="items" data-item="1" data-type="text">item1</li>
        <li class="items" data-item="2" data-type="text">item2</li>
        <li class="items" data-item="3" data-type="number">1</li>
        <li class="items" data-item="4" data-type="number">4</li>
	</ul>
</body>
</html>
```

![](http://cfile27.uf.tistory.com/image/1141FC34507D4A21288424)

이렇게 HTML5의 Custom Data Attributes를 HTML 문서를 좀더 의미적으로 데이터를 표현할 수 있을뿐만 아니라 data-* 의 element를 선택적으로 CSS 쿼리하여 스타일을 디테일하게 적용할 수가 있다는 것을 살펴보았다. 그럼 이 데이터들을 HTML selectors로 어떻게 접근할 수 있는지 확인해보자.

### Selectors

HTML5 Selectors API에서 querySelector를 사용할 수 있다는 것을 [HTML5의 selectors API로 jQuery selector 대신하기](http://blog.saltfactory.net/201) 글에서 소개했었는데 이 querySelector를 가지고 접근을 할 수가 있다.

```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
</head>
<body>
	<ul id="myItems">
        <li class="items" data-item="1" data-type="text">item1</li>
        <li class="items" data-item="2" data-type="text">item2</li>
        <li class="items" data-item="3" data-type="number">1</li>
        <li class="items" data-item="4" data-type="number">4</li>
	</ul>

	<script>
		var items = document.querySelectorAll('[data-type="number"]');
		console.log(items);

	</script>

</body>
</html>
```

위 코드를 실행시키면 HTML5의 Selectors API를 이용해서 HTML의 **Custom Data Attributes**로 정의한 element를 CSS 쿼리를 이용해서 접근 가능하다는 것을 확인할 수 있다.


![](http://cfile6.uf.tistory.com/image/1128634A507E0463168ED5)

## 결론

HTML5는 단순히 HTML의 화장판 마크업이 아니다. HTML5은 유용한 API가 많이 추가되었을 뿐만 아니라 HTML 문서 자체에 데이터를 의미적으로 표현하고 문서 안의 데이터를 사용자 정의로 보다 의미있는 데이터로 다루기 위해서 Custom Data Attributes라는 속성이 추가 되었다. HTML 문서로 RDF처럼 의미있는 문서를 정의하고 표현하는데 한계가 있었지만 HTML5에서는 Custom Data Attributes로 보다 element의 데이터를 의미 있게 표현할 수 있게 되었다. HTML5에서 의미기반으로 마크업을 한다, 문서를 표현한다는 라는 말은 단순하게 `<header>`,`<aside>`,`<section>` 등의 DOM element를 추가되어가 아니라 Custom Data Attributes를 이용해서 이렇게 문서를 사용자가 정의할 수 있는 데이터로, 문서의 형태로 표현할 수 있기 때문이다. 뿐만 아니라 이렇게 표현한 Custom Data Attributes는 CSS 쿼리를 이용해서 사용자 정의 문서를 기존의 CSS style 기법 그대로 적용을 할 수 있으며 더 구체적으로 스타일을 지정할 수 있게 되었다. 또한 querySelector를 이용해서 Javascript에서 data-* 에 관련된 데이터를 접근해서 데이터를 변경하거나 구조를 변경하는 등 다양한 웹 어플리케이션을 만들 수 있는 접근도 가능하다. HTML5의 Custom Data Attributes는 이미 다양한 Javascript Framework(Sencha, Dojo, jQuery 등)에서 사용을 하고 있다. HTML5 기반의 웹 페이지를 만들거나 웹 어플리케이션을 만든다면 더이상 HTML에 의미를 만들기 위해서 강제적으로 CSS 스타일링을 위한 코드에 스타일과 무관한 속성을 추가하거나 필요없는 `<div>`를 만들지 말고 Custom Data Attributes를 사용해보길 권유한다. 놀라울 정도로 HTML 문서를 의미있게 표현할 수 있을 뿐만 아니라 필요 없이 추가된 코드들이 줄어들 것이라 예상된다.


## 참고

1. 강요천, 프리렉, "상상력과 HTML5, CSS3, Javascript로 빚는 모바일 웹", p.31~p.35
2. http://dev.w3.org/html5/spec/global-attributes.html#custom-data-attribute
3. http://www.javascriptkit.com/dhtmltutors/customattributes.shtml
4. http://html5doctor.com/html5-custom-data-attributes/
5. http://css-tricks.com/multiple-attribute-values/


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
