---
layout: post
title: HTML5의 selectors API로 jQuery selector 대신하기
category: html5
tags: [html5, api, selector]
comments: true
redirect_from: /201/
disqus_identifier : http://blog.saltfactory.net/201
---

## 서론

웹 개발을 할 때 HTML4의 selectors는 좀처럼 불편한게 아니다. document.getElementById와 document.getElementsByClassName 또는 document.getElementsByName 등으로 DOM element에 접근해서 데이터를 가져오거나 변경을 하는 것이 꽤 귀찮은 작업이기 때문에 대부분 jQuery나 다른 DOM selector를 지원하는 라이브러리를 사용하여 개발을 한다. 물론 jQuery는 selector 말고도 많은 강력한 기능이 있지만 이 포스팅에서는 HTML5의 selectors API를 비교 설명하기 위해서 jQuery의 selectors만 좁혀서 비교한다. (HTML5의 selector로 jQuery selector를 다 할 수 없을지 모르겠지만 HTML4에 비해서 매우 강력해졌다.)

이 포스팅으로 HTML5에 추가된 API들로 HTML5을 단순히 Markup이라고만 생각한다면 도대체 왜 HTML4 보다 좋은지 모르겠다. 라는 질문을 조금은 해소할 수 있지 않을까 생각한다. (사실 연구실에 HTML5가 도대체 왜 좋은지에 대한 논의가 많이 진행되고 있다.)

<!--more-->

## HTML4 selectors

우선 기존의 HTML4의 selector를 가지고 element에 접근하는 코드를 살펴보자. HTML selector를 테스트하기 위해서 아래 문서를 하나 만든다. 간단하게 li와 span의 element 집합들이 contents라는 id를 가지는 article 안에 ul 안에 존재하는 문서이다.

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>HTML5 selectors API</title>

<style type="text/css">
.activity { color : red; }
</style>

</head>
<body>
<header>
	<h1 id="title">HTML4, jQuery, HTML5 selectors</h1>
</header>
<section>
	<article id="contents">
		<h2 id="subject" class="subjects">HTML selectors</h2>
		<ul>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementById</span></li>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementByTagName</span></li>
			<li class="list_items html5">HTML5 : <span class="text">document.getQuerySelector</span></li>
			<li class="list_items html5">HTML5 : <span class="text activity">document.getQuerySelectorAll</span></li>
		</ul>
	</article>
</section>

</body>
</html>
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/0ba171b0-1eef-485f-88a1-8391d9ac7cc3)

이 문서에서 HTML4 selector API를 이용해서 contents 안의 첫번째 li 속에 있는 span의 내용을 가져오고 싶다고 할 때 javascript 코드를 다음과 같이 추가할 수 있다.

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>HTML5 selectors API</title>

<style type="text/css">
.activity { color : red; }
</style>

<script type="text/javascript">
	window.onload = function(){
		var html4_selector = document.getElementById("contents").getElementsByTagName("ul")[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML;
		console.log("html4 selector : " + html4_selector);
	};
</script>


</head>
<body>
<header>
	<h1 id="title">HTML4, jQuery, HTML5 selectors</h1>
</header>
<section>
	<article id="contents">
		<h2 id="subject" class="subjects">HTML selectors</h2>
		<ul>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementById</span></li>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementByTagName</span></li>
			<li class="list_items html5">HTML5 : <span class="text">document.getQuerySelector</span></li>
			<li class="list_items html5">HTML5 : <span class="text activity">document.getQuerySelectorAll</span></li>
		</ul>
	</article>
</section>

</body>
</html>
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/d3e678dc-a414-407e-b175-18dcea439fe2)

## jQuery selectors

꽤 많은 코드가 추가 되는 것을 확인할 수 있다. 그러면 jQuery를 이용해서 동일한 작업을 해보자. jQuery를 사용하기 위해서는 당연히 jquery 라이브러리가 필요하기 때문에 구글에서 호스팅해주고 있는 자바스크립트 라이브러리를 추가한 다음에 jQuery의 selector를 사용한다. jQuery의 selector는 HTML4의 interator의 번거러움과 getElementById의 단순함을 CSS selector 문법으로 간단하게 코드를 만들어서 접근할 수 있게 해주는 장점을 가지고 있다. 어떠한가? HTML4의 코드가 jQuery로 훨씬 간단하게 줄어들었다. 하지만 이러한 편리함을 위해서 수십kb 되는 jquery 라이브러리를 항상 문서를 열때 로드를 해야한다.

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>HTML5 selectors API</title>

<style type="text/css">
.activity { color : red; }
</style>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script type="text/javascript">
	window.onload = function(){
		var html4_selector = document.getElementById("contents").getElementsByTagName("ul")[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML;
		console.log("html4 selector : " + html4_selector);

		var jquery_selector = $("#contents ul li:first-child span").html();
		console.log("jquery selector : " + jquery_selector);

	};
</script>

</head>
<body>
<header>
	<h1 id="title">HTML4, jQuery, HTML5 selectors</h1>
</header>
<section>
	<article id="contents">
		<h2 id="subject" class="subjects">HTML selectors</h2>
		<ul>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementById</span></li>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementByTagName</span></li>
			<li class="list_items html5">HTML5 : <span class="text">document.getQuerySelector</span></li>
			<li class="list_items html5">HTML5 : <span class="text activity">document.getQuerySelectorAll</span></li>
		</ul>
	</article>
</section>

</body>
</html>
```

## HTML5 selectors

그럼 HTML5에 새롭게 추가된 selectors API는 어떻게 사용할 수 있을까? HTML5의 querySelector는 CSS의 selector를 이용해서 jQuery와 매우 유사한 방법으로 element에 접근할 수 있다. 다음 코드를 보면서 jQuery의 selector와 비교해보자. 매우 유사하다는 것을 확인할 수 있다.

```javascript
<script type="text/javascript">
	window.onload = function(){
		var html4_selector = document.getElementById("contents").getElementsByTagName("ul")[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML;
		console.log("html4 selector : " + html4_selector);

		var jquery_selector = $("#contents ul li:first-child span").html();
		console.log("jquery selector : " + jquery_selector);

		var html5_selector = document.querySelector("#contents ul li:first-child span").innerHTML;
		console.log("html5 selector : " + html5_selector);

	};
</script>
```

위 세가지 방법은 모두 동일한 결과를 가져온다는 것을 알 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/f0372194-3d08-40aa-bb05-fea4a99c66fe)

이제 selector API로 NODE_LIST(element의 집합들)을 접근하기 위해서는 어떻게 해야할까? 위 문서에서 빨간색 글자를 가진 className에 activity가 포함된 elements를 접근하고한다고 가정하자. 이때 HTML4 selectors API는 다음과 같이 사용할 수 있다.

```javascript
<script type="text/javascript">

	window.onload = function(){

		var html4_selectorAll = document.getElementById("contents").getElementsByTagName("span");
		var spans = new Array();
		for(var i=0; i<html4_selectorAll.length; i++){
			if(html4_selectorAll[i].className == "text activity"){
				spans.push(html4_selectorAll[i]);
			}
		}
		console.log("html4 selector all : " + spans.length);


	};
</script>
```

위와 동일한 작업을 jQuery로 구현해보자.

```javascript
<script type="text/javascript">

	window.onload = function(){

		var html4_selectorAll = document.getElementById("contents").getElementsByTagName("span");
		var spans = new Array();
		for(var i=0; i<html4_selectorAll.length; i++){
			if(html4_selectorAll[i].className == "text activity"){
				spans.push(html4_selectorAll[i]);
			}
		}
		console.log("html4 selector all : " + spans.length);

		var jquery_selectorAll = $("#contents span.activity")
		console.log("jquery selector all : " + jquery_selectorAll.size());


	};
</script>
```

jQuery는 확실히 HTML4의 selectors API보다 사용하기 편리하다는 것을 확인할 수 있다. 그럼 HTML5에서 동일한 작업을 하려면 어떻게할까? querySelectorAll을 사용해서 다음과 같이 jQuery와 유사하게 할 수 있다.

```javascript
<script type="text/javascript">

	window.onload = function(){

		var html4_selectorAll = document.getElementById("contents").getElementsByTagName("span");
		var spans = new Array();
		for(var i=0; i<html4_selectorAll.length; i++){
			if(html4_selectorAll[i].className == "text activity"){
				spans.push(html4_selectorAll[i]);
			}
		}
		console.log("html4 selector all : " + spans.length);

		var jquery_selectorAll = $("#contents span.activity")
		console.log("jquery selector all : " + jquery_selectorAll.size());

		var html5_selectorAll = document.querySelectorAll("#contents span.activity");
		console.log("html5 selector all : " + html5_selectorAll.length);

	};
</script>
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fdff3eda-af96-4dab-ab2f-46d801b6046a)

querySelectorAll는 위와 같이 CSS의 쿼리로 접근하는 기능 이외에도 여러개의 쿼리를 적용하여 한번에 여러개의 element를 접근할 수 있다. li의 className이 html4와 html5인 모든 element를 접근하기 위해서 다음과 같이 쿼리를 배열로 여러개 넣어주면 된다.

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>HTML5 selectors API</title>

<style type="text/css">
.activity { color : red; }
</style>

<script type="text/javascript">

	window.onload = function(){

		var html5_selectorAll = document.querySelectorAll(['li.html4', 'li.html5']);
		console.log(html5_selectorAll);

	};
</script>

</head>
<body>
<header>
	<h1 id="title">HTML4, jQuery, HTML5 selectors</h1>
</header>
<section>
	<article id="contents">
		<h2 id="subject" class="subjects">HTML selectors</h2>
		<ul>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementById</span></li>
			<li class="list_items html4">HTML4 : <span class="text">document.getElementByTagName</span></li>
			<li class="list_items html5">HTML5 : <span class="text">document.getQuerySelector</span></li>
			<li class="list_items html5">HTML5 : <span class="text activity">document.getQuerySelectorAll</span></li>
		</ul>
	</article>
</section>

</body>
</html>
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/d8eff9e4-8c4d-408d-a587-d57eb6bfd447)

## 결론

HTML5는 단순히 markup만 추가가 된 것이 아니라 웹 어플리케이션을 효과적이고 효율적으로 개발할 수 있는 여러가지 API가 추가가 되었다. HTML4에서는 DOM element에 접근하기 위해서 복잡한 과정을 많은 코드를 사용해서 처리해야했다. 그래서 jQuery와 같이 selecotor 메소드를 지원하는 다른 Javascript라이브러리를 사용했는데 이러한 라이브러리는 매우 많은 장점을 가졌지만 selector만 사용하기 위해서 수십 kb의 자바스크립트 코드를 웹 페이지에 삽입한다는 것은 비효율적이다. 물론 HTML5의  selectors API 이외 jQuery의 좋은 다른 기능들은 모두 사용한다면 당연히 jQuery를 사용하길 권유한다. 하지만 모바일환경에서 단순히 HTML4의 selectors API가 번거롭고 사용하기 불편해서 jQuery의 selector 기능만을 사용한다면 최근 모든 모바일 브라우저나 HTML5을 지원하는 PC 브라우에서는 HTML5의 selectors API를 사용해보길 권유한다. 이렇게 웹 개발의 편리한 API를 HTML5에는 여러개 추가가 되어 있기 때문에 보다 안전하고 빠르게 웹 어플리케이션을 개발하는데 HTML5의 매력을 느낄 수 있을 것이다.


## 참고

1. http://www.w3.org/TR/selectors-api/
2. http://www.webdirections.org/blog/html5-selectors-api-its-like-a-swiss-army-knife-for-the-dom/
3. 이광호, Interpress, 센차터치 입문에서 활용까지, p.75~p.76

