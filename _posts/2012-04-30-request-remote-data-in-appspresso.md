---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 3.원격데이터 요청하기
category: appspresso
tags:  [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, request]
comments: true
redirect_from: /127/
disqus_identifier : http://blog.saltfactory.net/127
---

## 서론

Appsresso를 프로젝트에 적용하기 위해서 필요한 기능을 먼저 테스트해보기로 했다. 아마도 서버 프로그램과 데이터베이스를 사용하여 프로젝트를 많이 하는 우리 연구소에서 첫번째로 필요한 기능은 서버로 데이터를 전송하고 데이터를 받아오는 것일 것이다. Appspresso는 하이브리드 앱 개발을 할 수 있는 프레임워크이다. 이 하이브리드라는 말 속에서는 "웹" + "네이티브" 라는 특징이 포함되어져 있다. 그래서 이번 테스트는 두가지 방법으로 테스트를 한다. 바로 "웹" 프로그램으로 서버에 데이터를 요청하는 방법과 "네이티브" 프로그램으로 서버에 데이터를 요청하는 방법이다.  이번 포스팅에서는 웹 프로그램으로 서버에 데이터를 요청하는 방법을 포스팅하고 다음 포스팅에서는 Appspresso의 PDK(Plugin Development Kit)을 사용해서 사용자 정의 Plugin을 만들어서 네이티브 프로그램으로 서버의 데이터를 요청하는 방법을 포스팅하겠다.

<!--more-->

## Javascript로 URL 요청하기

우리는 웹에서 데이터를 요청한다면 크게 두가지를 생각한다. 웹 페이지를 다른 주소로 옮기는 것과 페이지는 움직이지 않고 비동기 데이터를 요청하는 방법이다. 전자는 sync, 후자는 async라 생각하고 웹 페이지 이동은 location을 변경하여 할 수 있고 비동기는 ajax를 사용하여 할 수 있다고 생각할 것이다. (물론 ajax로도 sync 요청을 할 수 있다). Ajax는 표준 프로토콜은 아니지만 이미 디펙트로 모든 브라우저와 웹 서비스에 표준과 같이 사용되고 있는 방법이다. Ajax를 사용해서 데이터의 비동기 요청이 가능하고, 이로 인해서 사용자에게 더욱 유연하고 높은 정보성의 서비스를 제공해 줄 수 있게 되었다. 그런데 이런 Ajax에는 한가지 제한이 있는데 바로 Cross Domain에서는 사용할 수 없는 제한이 있다. 이것은 보안상 이유로 같은 도메인이 아니라면 비동기 데이터 요청을 할 수 없게 되어 있는 것이다. 실제 이것이 된다면 스크립트로 사용자가 원하지 않게 다른 도메인으로 데이터를 전송할 수 있게 되어 사용자의 정보를 몰래 보내게 되거나, 또는 다른 데이터를 가져올 수 있게 되기 때문에 보안상 다른 도메인으로 데이터를 전송할 수 없게 되어 있다. 물론 JSONP 나 proxy를 사용해서 이 방법을 우회할 수는 있지만 공식적으로는 크로스 도메인을 지원하지 않는다.
보통 하이브리드 앱을 개발한다는 이야기는 웹 프로그래밍 기법을 이요하는 것인데, 이 때 웹 페이지가 필요하게 된다. 하지만 서버에서 웹 페이지를 만들어서 (javascript, css 파일을 포함) 웹에서 전송받게 되는 것을 말하지 않고 로컬의 자원을 이용한다. 그럼 로컬 도메인에서 서버쪽인 다른 도메인으로 데이터를 전송해야하는데 이 때 크로스 도메인 문제가 발생하게 된다. 이러한 문제를 해결하기 위해 Appspresso 에서는 개발자가 특별하게 다른 방법을 사용하지 않고 다른 도메인의 서버와 데이터를 요청할 수 있게 플러그인을 제공하고 있다.

## ax.ext.net.curl

Asspresso에서 다른 네트워크 데이터를 전송하기 위해서 Appspresso에서 제공하는 플러그인에서 ax.ext.net 라는 플러그인의 ax.ext.net.curl을 사용하면 된다. Appspresso에서 플러그인을 추가하기 위해서 project 디렉토리 안에 있는 project.xml 파일을 선택하여 Feature라는 탭을 선택한다. 그리고 Add Built-in Plugin을 선택한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/51eba37d-ab20-46af-874b-9cc3201e6709)

Add Built-in Plugin 버턴을 누르면 Appspresso에서 제공하고 있는 플러그인들이 보이는데 그 중에서 ax.ext.net 플러그인을 선택하고 OK를 누른다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/afb078e0-2346-454f-94da-9aa972b62c8c)

Feature List에 extension  에 http://appspresso.com/api/ax.ext.net 플러그인이 추가된 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9d090fef-35dd-4159-948b-b74054b172c6)

ax.ext.net.curl을 테스트하기 위해서 Twitter Search API를 이용한 json 요청을 http://search.twitter.com 도메인으로 요청을 해보자.
프로젝트 폴더 아래의 index.html을 열어서 다음 코드를 추가한다.

```html
<!DCOTYPE html>
<html>
	<head>
        <script type="text/javascript" src="/appspresso/appspresso.js"></script>
        <meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
			ax.log("Hello World");

			var request = {
					'url': 'http://search.twitter.com/search.json?q=appspresso',
					'success': function(response){
						var json = JSON.parse(response.data);
						ax.log(json.results[0].text);
					},
					'error': function(error){
						ax.log(error);
					},
					'method':'GET'
			};

			ax.ext.net.curl(request);


		</script>
	</head>
	<body>
		<h1>Hello World</h1>
		<h3>net.saltfactory.hybridtutorial</h3>
	</body>
</html>
```

on the fly 로 디버깅 모드를 빌드하고 실행해보자, 실행하는 방법은 [Appspresso를 사용하여 하이브리드앱 개발하기 - 2.On The Fly로 디버깅하기](http://blog.saltfactory.net/126) 글을 참조한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/12abc9fd-5086-4789-b33c-7c4c8c5233e3)

ax.ext.net.curl 은 URL을 기반하는 http 요청을 처리한다. http://appspresso.com/api/extension/symbols/ax.ext.net.html 를 참조하면 ax.ext.net.curl에 대한 설명이 나오고, http://appspresso.com/api/extension/symbols/ax.ext.net.CurlOpts.html 를 참조하면 파라미터 옵션들의 설정 값들을 확인할 수 있다. 예제는 간단하게 url, success callback method, fail callback method를 지정하였다. Http 요청을 처리할 때 method가 'GET' 일 경우는 다음과 같이 ax.ext.net.get 으로도 사용할 수 있다. 단지 ax.ext.net.curl에 사용한 해시형태의 파라미터가 아니라 다음과  같이 ax.ext.net.get을 사용할 수 있다.

```html
<!DOCTYPE html>
<html>
	<head>
        <script type="text/javascript" src="/appspresso/appspresso.js"></script>
        <meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
			ax.log("Hello World");

/* 			var request = {
					'url': 'http://search.twitter.com/search.json?q=appspresso',
					'success': function(response){
						var json = JSON.parse(response.data);
						ax.log(json.results[0].text);
					},
					'error': function(error){
						ax.log(error);
					},
					'method':'GET'
			};

			ax.ext.net.curl(request);
 */
		ax.ext.net.get('http://search.twitter.com/search.json?q=appspresso',
				function(response){
					var json = JSON.parse(response.data);
					ax.log(json.results[0].text);
				},
				function(erorr){
					ax.log(error);
				},
				'utf-8');
		</script>
	</head>
	<body>
		<h1>Hello World</h1>
		<h3>net.saltfactory.hybridtutorial</h3>
	</body>
</html>
```

이 글을 작성할 때 Appsspresso 가 1.1로 업데이트가 되었다. 1.1 버전 부터는 plugin을 추가하는 패널이 조금 다르게 보이는 다음과 같은 화면으로 추가할 수가 있다. (Appsresso의 1.1 새로운 기능은 다음 포스트에 자세히 언급하겠다.)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/1f9ebffd-c78c-4b61-9f9a-c01507d63b23)

Appsresso 1.1버전 부터는 다국어 지원이 가능한데 다국어 지원하는 탬플릿을 선택하고 프로젝트를 만들면 다음과 같은 샘플 코드가 들어가 있다. 하지만 기존의 ax.ext.net 을 사용하는 방법은 동일하다. ax.ext.net.curl 이나 ax.ext.net.get을 사용하면 간단하게 javascript에서 cross domain 문제를 해결하고 데이터를 가져올 수 있다.

이렇게 ax.ext.net 으로 가져온 데이터들은 callback 함수에서 HTML DOM을 사용해서 view를 업데이트 할 수 있다. 소스 코드를 사음과 같이 수정해보자.


```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<script src="/appspresso/appspresso.js"></script>
		<script src="locale-example.js"></script>
		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
			ax.log("Hello World");

			ax.ext.net.get('http://search.twitter.com/search.json?q=saltfactory',
					function(response){
						var json = JSON.parse(response.data);
						var text = json.results[0].text;
						ax.log(text);
						document.getElementById("text").innerHTML = text;
					},
					function(erorr){
						ax.log(error);
					},
					'utf-8');

		</script>
		<style type="text/css">
			#text {
				color:blue;
			}
		</style>
	</head>
	<body>
		<h1 id="title"></h1>
		<h3>net.saltfactory.hybridtutorial</h3>
		<div id="text"></div>
		<!--
		/platforms			  ... Metafile, icon, application name FOR PLATFORM(Android, iOS, ...)
		/src
		   /appspresso
		      /appspresso.js  ... AUTO-GENERATED FILE.
		   /locales           ... Directory for Localized content.
		                          SEE ALSO, http://www.w3.org/TR/widgets/#folder-based-localization
		      /en
		         /locale.js
		      /ko
		      /...
		   /index.html        ... this page
		   /locale-example.js ... sample javascript
		   /widget-icon.png   ... icon for widget.
		                          IF YOU WANT TO CHANGE ICON FOR ANDROID or IOS,
		                          YOU CAN DO IT in 'platforms' DIRECTORY.
		/project.xml          ... application configuration file
		 -->
	</body>
</html>
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/533ed0f7-8862-4d76-920d-d8e32f87cb27)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e64aea38-388a-4cc6-9045-920960ba91e2)

## 결론

아마 Appspresso를 이용해서 하이브리드로 개발하지 않았더라면 아마도 iOS와 Android 각각의 네이티브 코드로 (Objective-C나 Android) 만들어서 요청하는 작업을 했어야 할 것이다. 하지만 Appspresso를 사용하면 이렇게 ax.ext.net 내장 플러그인을 사용해서 cross domain에 문제없이 데이터를 요청해서 뷰를 업데이트할 수 있고 동일한 코드로 아이폰과 안드로이드 모두에 동일하게 적용할 수가 있다.

다음 포스팅에서는 Appspresso의 PDK (Plugin Development Kit)을 이용해서 Native code(Objective-C, Java)를 사용하는 방법과 네이티브 프로그램으로 URL 요청을 하는 방법에 대해서 포스팅할 예정이다.

