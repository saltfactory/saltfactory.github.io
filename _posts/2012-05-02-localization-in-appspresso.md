---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 8.지역화(Localization) 적용하기
category: appspresso
tags:  [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, localization]
comments: true
redirect_from: /133/
disqus_identifier : http://blog.saltfactory.net/133
---

Appspresso는 1.1 버전 부터 지역화 기능이 추가되었다. 앱 스토어나 안드로이드 마켓등 더이상 개발자에게 마켓은 국내만 타겟이 아니기 때문에 앱 스토어에 앱을 등록하면 국내 사용자 뿐만 아니라 미국, 중국, 일본 등 다른 언어를 사용하는 사용자가 고객의 대상이 된다. 지역화 기능은 이렇게 다른 언어를 사용하는 사용자의 디바이스의 Local 정보를 인식해서 그 디바이스에 사용하고 있는 언어가 출력되어서 사용자에게 거부감 없이 사용의 편리성을 높여주는 것을 말한다. Appspresso는 Project를 생성할 때 Localization 형태의 탬플릿을 선태하면 자동적으로 지역화를 할 수 있는 프로젝트 구조로 만들어 진다.

<!--more-->

![](http://asset.blog.hibrainapps.net/saltfactory/images/2b274e81-f3cf-4597-a185-e1fe8ff0d82e)

지역화 템플릿으로 프로젝트를 만들면 디렉토리 구조가 지역정보대로 분리가 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/4a4d4165-600b-4935-9783-c313e2b82d89)

뭔가 엄청나게 많아 보인다. 지역화는 크게 platform 디렉토리와 src 디렉토리로 나누어서 살펴볼 수 있는데 tree라는 명령어를 사용해서 살펴보면 다음과 같다. 안드로이드와 아이폰 내부가 동일하기 때문에 android의 경우 살펴보자. resources라는 디렉토리 밑으로 icon과 splash 디렉토리가 있다. 각각 앱이 설치될 때의 icon과 앱이 실행될 때의 splash이다. 이렇게 지역별로 디렉토리로 구분해서 만들어두었는데 디바이스의 지역화 정보를 확인해서 자동으로 해당되는 자원을 사용하게 해주는 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/6901df2b-374d-4db5-8226-01e05442545f)

현재 splash.en 과 splash.ko에 들어 있는 이미지를 살펴보면 다음과 같다. splash.en 안에 들어있는 이미지는 하단에 en 로고가 있고 splash.ko 에 들어 있는 이미지는 ko라는 로고가 들어 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/818e48b3-bc38-4911-a49d-274ce8ac4f02)

![](http://asset.blog.hibrainapps.net/saltfactory/images/372f4083-519c-442b-9fee-cffc6cf20a51)

실제 디바이스에 테스트하면 지역정보에 다르게 첫 화면이 다르게 나오게 된다. platform이라는 디렉토리 안의 지역화 디렉토리들은 이렇게 resource에 관한 지역화 파일들이 디렉토리별로 존재하게 된다.

다음은 src 안에 들어 있는 지역화 구조이다. 예제 소스는 locale-example.js 가 각각 지역화 디렉토리 안에 들어가 있다. 이것도 마찬가지로 디바이스의 지역정보를 보고 해당되는 .js 파일을 사용하게 되는 것이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/d432158e-03a0-48d3-ab34-4349498f6a37)


우리는 이해를 좀더 돕기 위해서 다음과 같이 소스를 변경해보자.
원래 기본적으로 작성된 예제는 다음과 같다.
/src/locales/en/locale-example.js

```javascript
window.onload = function() {
	document.getElementById('title').innerHTML = 'Hello';
};
```

/src/locale/ko/locale-example.js
```javascript
window.onload = function() {
	document.getElementById('title').innerHTML = '안녕하세요';
};
```

그리고 index.html 에서 사용되는 코드를 보면 다음과 같다. locale-example.js 를 사용한다고 설정을 했는데, 지역화 정보를 확인해서 src 밑의 locales 안에서 각각 해당되는 en/locale-example.js 이나 ko/locale-example.js 를 자동으로 찾아서 사용하게 된다.

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
		</script>
	</head>
	<body>
		<h1 id="title"></h1>
		<h3>net.saltfactory.hybridtutorial</h3>


	</body>
</html>
```

하지만 약간 이상한 점이 있다. 똑 같은 코드인데 /src/locales/en/locale-example.js 와 /src/locales/ko/locale-example.js 모두 가지고 있다면 프로그램이 큰 .js 같은 경우는 용량도 크고, 단순히 언어만 다르게 설정하면 되는데 프로그램 코드가 모두 포함이 된다는 것이다. 그래서 이렇게 사용하면 어떨까? 프로그램 코드는 따로 분리하고 locales 밑에는 언어 설정만 하는 json 언어 딕셔너리만 존재하게 한다.

/src/locales/en/locale-example.js
```javascript
//window.onload = function() {
//	document.getElementById('title').innerHTML = 'Hello';
//	document.getElementById('notice').innerHTML = 'This device use an english';
//};

var Language = {
		title:  'Hello',
		notice: 'This device use an english'
};
```
/src/locales/ko/locale-example.js
```javascript
//window.onload = function() {
//	document.getElementById('title').innerHTML = '안녕하세요';
//	document.getElementById('notice').innerHTML = '이 디바이스는 한국어를 사용하고 있습니다.';
//};

var Language = {
		title: '안녕하세요',
		notice: '이 디바이스는 한국어를 사용하고 있습니다.'
};
```

그리고 프로그램 파일을 분리한다.
/src/js/app.js
```javascript
window.onload = function() {
	document.getElementById('title').innerHTML = Language.title;
	document.getElementById('notice').innerHTML = Language.notice;
};
```

마지막으로 index.html 파일에 설정을 한다. 디바이스로 테스트하기 위해서 notice 를 추가하였다.

/src/index.html
```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<script src="/appspresso/appspresso.js"></script>
		<script src="locale-example.js"></script>
		<script src="/js/app.js"></script>
		<script>
			//activate ax.log(), comment out when you release app
			ax.runMode = ax.MODE_DEBUG;
			ax.log("Hello World");
		</script>

		<style>
			#notice {color:red;}
		</style>


	</head>
	<body>
		<h1 id="title"></h1>
		<h3>net.saltfactory.hybridtutorial</h3>
		<p id="notice">notice</p>
	</body>
</html>
```

앱의 이름 또한 지역화에 맞춰서 변경할 수도 있다. platform/Android/resources/appName.xml 과 platform/iOS/resources/appName.xml에서 설정하는데 위의 지역화 각각의 디렉토리가 아니라 xml 구조로 설정을 한다. 한국어에서만 한글 앱 이름이 나오게 하였고 나머지는 모두 영어가 나오도록 하였다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
	<app-name lang="en">HybridTutorial</app-name>
	<app-name lang="es">HybridTutorial</app-name>
	<app-name lang="ja">HybridTutorial</app-name>
	<app-name lang="ko">하이브리드연습</app-name>
	<app-name lang="zh-Hans">HybridTutorial</app-name>
</resources>
```

위의 예제를 실행 하였을 때의 지역화가 적용된 모습이다. 왼쪽 iPod touch는 한글을 설정하였고 오른쪽 Android Nexus one은 영어로 설정되어 있는 상태이다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/6c8d85d0-48ba-4440-96db-c9ce9efe4d50)

앱이 설치된 아이콘도 이렇게 한글 설정이 되어 있는 iPod touch에는 한글로 설치가 되고 영어가 설정되어 있는 Android Nexus one에는 영어로 된 이름이 설치가 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e3058f6a-7b32-4aaa-b93a-44f60de941ce)

## 결론

현재 버전에서는 on the fly로 지역화를 테스트를 할 수 없다고 한다. 언어 설정을 위해서 디바이스에 매번 설치하면서 확인한다는 것은 현재는 많이 불편한건 사실이지만 지역화를 지원해서 개발할 때 언어와 프로그램을 분리해서 개발할 수 있게 되었다는 것에는 매우 의미 있는 업데이트라고 생각한다. 다만 지역화를 하기 위해서 언어만 따로 설정할 수 있는 언어 파일이 존재한다면 어떨까 생각해봤다. 이미지나 리소스 자원들은 분리해서 디렉토리 구조로 나누어서 사용할 수 있을 것 같은데, 언어 설정을 하는 파일은 appName.xml 처럼 뭔가 정해진 곳에 언어를 설정하면 좋지 않을까? 생각도 해봤다. 하지만 대부분의 지역화를 지원하는 프레임워크는 이렇게 디렉토리 구조화가 되어 있는 것으로 안다. 앱스프레소의 업데이트 마다 새로운 기능이 추가되고 개발하기 편리해지는 것 같아서 이젠 앱스프레소를 사용하여 기존에 서비스하는 앱을 하이브리드 앱으로 마이그레이션 할 수 있을 것이라고 조심스레 생각해본다. 하나의 코드로 여러가지 디바이스에 적용하고 지역화까지 하나로 개발할 수 있으니 개발 공수가 많이 줄어 들것 같다는 생각도 해본다.

