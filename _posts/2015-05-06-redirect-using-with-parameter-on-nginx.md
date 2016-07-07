---
layout: post
title: 모바일 앱 안에서 변화하는 외부 URL 문제를 NginX의 rewrite로 해결하기
category: nginx
tags: [nginx, mobile, rewrite]
comments: true
redirect_from: /270/
disqus_identifier : http://blog.saltfactory.net/270

---

## 서론

모바일 앱을 개발하면 외부 링크를 사용하여 터치를 하였을 때 모바일 브라우저로 링크를 열게 하는 코드를 작성할 수 있다. 때로는 외부 링크가 http 스키마가 아닌 어플리케이션을 열기 위한 스키마가 될 수 도 있다. 인터넷에서 URL은 URI의 서브셋으로 고유의 리소스 아이덴티티를 가지는 것임에도 불구하고 상황에 따라 URL이 사라지거나 변경될 수 있다. 예를 들면, http://blog.saltfactory.net 이었던 URL이 서비스 변경으로 http://weblog.saltfactory.net 으로 변경될 수 있다는 것이다. 또는 서비스가 종료되어 더이상 존재하지 않는 URL이 되는 경우도 있다. 이런 문제를 해결하기 위해서 링크를 관리하는 방법이 필요했고 NginX를 사용하여 이 문제를 해결하는 방법을 소개한다.

<!--more-->

## 외부 URL 링크 문제

모바일 앱을 개발할 때, 일반적으로 소개하는 메뉴에 외부 링크를 많이 사용한다. 예를들어, 사용자의 프로파일, SNS 링크, 게시판 연결등이다. 앱 내부에 네이티브하게 개발을 하기도 하지만 이미 만들어진 웹 사이트를 간단한 링크를 통해서 새로운 브라우저를 열어서 연결할 수 있도록 하는 경우가 많다. 만약 오래된 앱에 외부 URL을 터치 이벤트에 등록했다고 가정하자. 아래는 iOS 앱 속에 "개발자 홈페이지" 버튼을 누르면 사파리 브라우저를 열어서 링크를 보여주는 간단한 [swift](https://developer.apple.com/swift/)코드이다.


```swift
@IBOutlet weak var openBrowserButton: UIButton!

@IBAction func onOpenBrowserButton(sender: UIButton) {
	var url:NSURL;
	url = NSURL(string: "http://me2day.net/saltfactory")!;

	UIApplication.sharedApplication().openURL(url);
}

override func viewDidLoad() {
	openBrowserButton.setTitle("개발자 홈페이지", forState: UIControlState.Normal);
	super.viewDidLoad()
}
```

하지만 me2day 서비스가 종료되면서 인터넷 상에서 디이상 앱 속에 넣어둔 URL은 유효한 주소가 되지 못한다. 실제로 me2day 서비스는 종료되었고, URL을 요청하면 다음과 같은 화면이 나타난다.
![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/c3e8f451-46b0-47cc-8200-3c5277eff664)
아마도 앱을 업데이트하지 않는 이상, 사용자들이 개발자의 홈페이지를 절대 열어볼 수 없을 것이다. me2day DNS 서버와 웹 서버 모두 개인이 가지고 있는 서버들이 아니라 redirect 설정도 할 수 없는 문제가 생긴다. 유일한 해결 방법은 URL 하나를 변경하기 위해 앱을 다시 빌드해서 버전을 올려 스토어에 등록을 해야한다. 우리는 이런 문제를 해결하기 위해서 [NginX의 rewrite 모듈 사용](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)하여 외부 링크를 중개하는 웹 서버 환경을 구축하였다.

## NginX의 rewrite 사용하기

기존의 Apache 웹 서버를 사용해본 경험이 있으면 이미 해결 방법을 알고 있을 수도 있다. 우리는 NginX 서버를 사용하기 때문에 NginX의 rewrite를 사용하였다. NginX의 rewrite 모듈을 사용하는 방법은 아주 광법위하기 때문에 이 글에서 모두 소개한다는 것은 불가능하다. rewrite 모듈중에 우리가 사용한 특징은 특정 URL 요청이 들어오면 URL 이 포함하고 있는 [Query String](http://en.wikipedia.org/wiki/Query_string)에 있는 내용을 분석해서 파라미터로 넘어온 URL로 다시 요청을 시키도록 지시하는 것이다.

Nginx의 서버 설정은 `server` 안에서 이루어 진다.

```
server {
	listen 80;
	server_name dev.saltfactory.net
	rewrite_log on;
	access_log /var/log/nginx/dev.saltfactory.net_access.log combined;
	error_log /var/log/nginx/dev.saltfactory.net_error.log
}
```

우리는 http://dev.saltfactory.net/call 으로 들어오는 요청만 적용을 할 것이다. `server`에 `location` 을 추가한다.

```
server {
	... 생략 ...
	location ^~ /call  {

	}
	... 생략 ...
}
```

이제 웹서버로 `/call`로 시작하는 URL 요청이 들어오면 우리가 설정한 `location`의 설정을 따를 것이다. 우리는 외부 URL을 가지고 리다이렉트를 시켜줄 것이다. 그래서 외부 URL을 가지고 이 요청을 하도록 하기 위해서 `redirect_url`이라는 Query String으로 파라미터를 가질 수 있도록 하였다. 그리고 `redirect_url`이 있을 경우만 rewrite를 할 수 있도록 설정한다. 예를들면, http://dev.saltfactory.net/call?redirect_url=http://me2day.net/saltfactory.net 과 같이 요청을 하면 NginX가 파라미터를 분석해서 `redirect_url`로 페이지를 다시 요청하게 할 것이다.

```
server {
	... 생략 ...
	location ^~ /call  {
		if ($args ~ "redirect_url=(.*)" ) {
			return 302 $1;
		}
	}
	... 생략 ...
}
```

이제 NginX는 앱에서 요청하는 외부 URL 링크를 중간에서 외부 URL 링크로 다시 작성하게하는 중간자 역활을 하게 되었다.

## 앱에서 URL 설정

우리는 NginX 중간자에게 URL 요청을 할 것이고 중간자가 URL을 Rewrite 시켜줄 것이기 때문이다. 앱에서 코드는 다음과 같이 변경된다.

```swift
@IBOutlet weak var openBrowserButton: UIButton!

@IBAction func onOpenBrowserButton(sender: UIButton) {
	var url:NSURL;
	url = NSURL(string: "http://dev.saltfactory.net/call?redirect_url=http://me2day.net/saltfactory")!;

	UIApplication.sharedApplication().openURL(url);
}

override func viewDidLoad() {
	openBrowserButton.setTitle("개발자 홈페이지", forState: UIControlState.Normal);
	super.viewDidLoad()
}
```

우리는 이제 외부 URL이 변경되더라도 더이상 앱을 업데이트하지 않아도 된다. 예를 들어, http://me2day.net/saltfactory 라는 외부 URL이 더이상 유요하지 않게 되면, NginX 중간자에서 rewrite 하는 부분을 다음과 같이 수정하면 된다.

```
server {
	... 생략 ...
	location ^~ /call  {
		if ($args ~ "redirect_url=http://me2day.net/saltfactory") {
			return 302 http://blog.saltfactory.net/;
		}

		if ($args ~ "redirect_url=(.*)" ) {
			return 302 $1;
		}
	}
	... 생략 ...
}
```

이제 앱에서 http://me2day.net/saltfactory 라는 유효하지 않는 URL을 요청하더라도 NginX 중간자가 새로운 http://blog.saltfactory.net 으로 rewrite 시켜주기 때문에 앱을 수정하지 않고도 외부 URL 링크 문제를 해결할 수 있다.
![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7683239e-4dac-4b74-95ae-87fb40727d56)

## 결론

모바일 앱을 개발하면서 외부 URL 링크를 사용하는 것은 아주 사소하지만 큰 문제를 일으키기도 한다. 외부에 URL을 사용하는 것은 URL이 변화지 않는다는 전제 조건을 가지고 만들어야하지만, 최근 서비스들은 쉽게 사라지거나 형태가 변형되기 때문에 외부 URL 주소를 프로그램 안에 정적으로 만들어두면 문제를 일으키게 된다. 이 글에서는 간단한 예제를 보여줬지만 실제 민감한 서비스의 경우 외부 URL링크 때문에 큰 문제를 가져올 수도 있다. 우리는 그래서 앱을 수정하지 않고 NginX의 rewrite 모듈을 사용하여 URL을 다시 작성하는 중간자를 만들었다. 앱은 NginX 중간자에게 외부 URL을 redirect_url 파라미터로 요청할 것이고 NginX는 앱에서 부터 요청 받은 URL을 외부 URL로 rewrite하도록 해 준다. 이렇게 NginX로 만든 중간자를 사용해서 외부 URL이 문제가 발생했을 때, 다른 URL로 바꾸어서 rewrite하여 앱에서 유효하지 못한 URL을 찾는 문제를 해결할 수 있을 것이다.

