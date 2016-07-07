---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 2.On The Fly로 디버깅하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c,on-the-fly]
comments: true
redirect_from: /126/
disqus_identifier : http://blog.saltfactory.net/126
---

## 서론

개발할 때 빌드 시간이 오래 건린다면 여러분은 어떻게 하시겠습니까? 오랫동안 개발 연구하면서 가장 큰 고민거리 중에 하나이다. PC 성능은 점점 좋아지고 클래스 API 는 점점 덩치가 커지면서 프로그램의 변경 사항을 한번 확인하기 위해서 컴파일 시켜서 기다리는게 너무나 지루한 싸움이기 때문이다. 그러한 이유로 토이 프로젝트를 진행할 때는 컴파일러가 따로 필요없이 인터프리터만 지원하면 개발할 수 있는 Ruby, Phython을 대부분 사용하고 있다. Xcode는 그나마 다행히 Android의 빌드 시간보다 짧다.(같은 라인코드 수라고 가정했을 경우). Appspresso의 IDE는 eclipse를 기반으로 만들어진 Java-based IDE 이다. 더구나 javascript와 deviceapi 를 내부적으로 패키징하여 .ipa나 .apk 파일을 만들어 내는데 한번 빌드하게되면 그 시간이 엄청나다. 처음에 Hello world를 우린 같이 살펴봤는데, 아마 실행하기 위해서 한번 빌드하고 나서 소감이 어떠했는가? 아마도 이정도의 빌드 속도라면 "Hello World"를 "Good bye World"로 단순히 글자만 변경해도 다시 빌드를 해야한다고 생각하면서 빌드 시간의 공포에 Appspresso를 두번다시 사용하기 싫다고 실망했을거라 예상된다. 처음 android의 emulator를 빌드,런을 하면서 거의 울먹거리며 한숨을 쉬었던 경험을 바탕으로 생각해보면 빌드의 시간은 프로덕트를 생산하는 생산성에 아주 큰 영향을 미친다.
다행히도 Appspresso는 웹 리소스의 변화를 감지해서 우리들히 데스크탑에서 새로 고침을하면서 php를 개발하듯 동일한 인터페이스를 제공해준다. 즉, 한번만 빌드해서 실행시켜두고 웹 자원에 변경이 일어면 빌드를 새로하는 것이 아니라 새로 고침을 할 수 있게 해주는 것이다. 이런 기능을 on the fly이라고 한다.

<!--more-->

앞에서 같이 테스트한 SaltfactoryHybridTutorial (http://blog.saltfactory.net/125) 을 다시 열어 보자. 그리고 preferences를 열어서 Appspresso의 Debug를 열어서 Debug Server Host를 지정한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/dc5ca502-8e5c-4baf-a135-64e784253710)

이제 프로젝트를 디버그 모드로 실행해서 테스트를 해보자.
프로젝트 디렉토리에서 오른쪽 마우스를 클릭해서 Debug as > Debug Appspresso application on iOS device를 선택한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5649b90f-723c-473c-a23d-0504111d529f)

그리고 eclipse의 하단에 있는 On The Fly 창을 확인한다. 밑에 빨간색으로 표시한 곳에 현재의 프로젝트명이 선택되어져 있어야 한다. 만약 그렇지 않을 경우는 on the fly의 target을 찾지 못한다는 에러가 발생하게 된다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/cb85a303-46f7-4661-8e0b-747f2161ef1c)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8a07f757-3c4b-423b-a77c-5d1d6f2453ce)

최초에 한번 빌드되어 실행되면서 Log가 남았다. 소스를 확인해보자.

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
		</script>
	</head>
	<body>
		<h1>Hello World</h1>
		<h3>net.saltfactory.hybridtutorial</h3>
	</body>
</html>
```

## On The Fly

ax.log("Hello World") 라는 appspresso의 예약된 객체의 메소드를 사용해서 로깅을 하였다. 우리는 빌드없이 Hello world를 Goodbye World로 변경을 해보자. 저장을 하고 On The Fly 창에서 주소창 왼쪽에 있는 "새로고침" 버턴을 클릭한다.

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
			ax.log("Goodbye World");
		</script>
	</head>
	<body>
		<h1>Goodbye World</h1>
		<h3>net.saltfactory.hybridtutorial</h3>
	</body>
</html>
```

새로고침을 실행하면 다음과 같이 "Goodbye World" 가 로그에 남게 되고 simulator를 확인해보면 Goodbye World 고 글자가 변경된 것을 확인 할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/302f5e83-1969-4d1c-a965-060b18f63475)

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/44079328-fe3f-4488-9b59-93806baf71fe)

## 결론

이렇게 Appsresso의 On The Fly 기능을 이용하면 프로그램을 변경시키더라도 새로 build의 시간을 사용하지 않고 간단하게 새로고침을 하여 변경되는 정보를 확인하고 개발할 수 있다. 웹 개발자들에게는 이 기능이 너무 단순한데 도대체 왜 이슈인가?라고 질문을 할지 모르지만, 안드로이드의 빌드와 런을 emulator에서 하는 과정을 한번 보여주면 곧바로 이해될 거라 예상된다. On The Fly를 이용해서 좀더 빠르고 편리하게 프로그램의 변경사항을 확인할 수 있게 되었으니 이제 실제 적인 예제를 가지고 테스트해볼 예정이다.

참고로, Appspresso 1.0.1 버전에서 On The Fly는 하나의 디바이스에만 적용이 된다. 앞에서 한번에 아이폰과 안드로이 디바이스를 빌드해서 런을 시키는 것을 테스트했는데 이렇게 두가지 디바이스를 모두 활성화시켜둔 상태에서 프로그램을 변경하고 두 디바이스에 어떻게 적용되는지 보고 싶어서 테스트해보니까 한군데만 적용이 되었다. 그래서 Appspresso 개발자 그룹에 문의하니 Appspresso 1.2 버전에 멀티 디바이스에 한번에 적용이 될거라는 답변 (https://groups.google.com/forum/#!searchin/appspresso-ko/시뮬레이터/appspresso-ko/dcbAin8THZY/TdQth4ztEpEJ) 을 받았으니, Appspresso의 업데이트 버전을 간절히 기다리고 있다. 하나의 코드를 작성하면서 동시에 두가지 디바이스에 가장 최적화 되는 모습을 바로 확인 할 수 있다는 것이라면 정말 멋지지 않는가? KTH에서 빠른 시간안에 이 기능을 업데이트해주면 Appspresso의 멋진 기능에 더 강력해질 것 같다고 생각해본다.


## 참고

1. http://appspresso.com/ko/archives/2575

