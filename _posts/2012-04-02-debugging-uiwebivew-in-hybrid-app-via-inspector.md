---
layout: post
title: 하이브리드 앱 개발을 할 때 UIWebView 에서 JavaScript 디버깅하기
category: hybrid
tags: [hybrid, debugging, uiwebview, javascript]
comments: true
redirect_from: /113/
disqus_identifier : http://blog.saltfactory.net/113

---

## 서론
이전에는 Native 앱 (순수 Objective-C와 C 기반 라이브러리를 이용하여 만든 앱)을 주로 만들었다면, 최근 HTML5 앱 기술이 발달하고 자료가 많아지면서 Hybrid 앱 (웹 개발 기술과 클라이언트 개발 기술을 접목하여 개발하는 앱)이 큰 인기를 얻고 있다. 실제 앱을 개발하면서 느낀 것인데 각각의 장점을 충분히 살릴 수 있으면 어렵게 구현할수 밖에 없는 코드를 아주 효과적으로 개발할 수 있기도 한다. HTML은 Native 앱과 랄리 UIWebView 안에서 HTML, Javascript, CSS로 개발이 되어 렌더링되기 때문에 순수 Objective-C로 개발한 것 보다는 속도가 느리지만 유연하고 상대적으로 개발하기 편리한 언어로 C의 복잡함을 단순하게 구현할 수 있다. 또한 웹 언어로(HTML, Javascript, CSS)로 개발된 코드는 다른 디바이스에서 재사용성이 가능하기 때문에 이론적으로는 코드 재사용성의 장점도 가지고 있다. 왜 이론적이라고 이야기하냐면 사실 각각 디바이스마다 가지고 있는 내장 브라우저 앤진의 해석능력이 다르기 때문에 100% 호환된다고는 말할 수 없기 때문이다. 하지만 Objective-C를 Java로 구현하는 것 보다 상대적으로 매우 완벽하게 재사용성이 가능한것은 사실이다.
<!--more-->

웹언어는 표현력과 개발속도를 빠르게 할 수는 있을지 모르나 물리적인 제약이나 빠른 성능을 요구하는 연산에는 Native 코드보다 비교적 한계가 있기 때문에 그런 작업은 Native 코드에게 맡기기로 한다. 이러한 이유에서 순수 웹 기술로 개발하거나 클라이언트 개발 기술로 개발하는 것 보다 서로의 장점을 접목해서 개발하려는 시도가 많이 일어나고 있다. 이전에 소개한 아이폰 앱을 개발할 때  iPhone에서 하이브리드 앱 개발을 위해 Javascript와 Objective-C의 상호 호출하는 방법에 대한 글을 역시 그러한 방법중에 한가지로 사용이 된다.

그런데 실제 Hybrid 앱을 개발하려면 두가지 환경에서 개발을 해야한다. 하나는 웹기반이고 하나는 클라이언트 기반이다. 더 쉽게 말하면 하나는 웹브라우저에서 실행되는 결과를 확인해야하고 하나는 Xcode에서 결과를 확인해야한다는 이야기다. Xcode는 LLVM의 훌륭한 컴파일 때문에 에러라던지 디버깅을 매우 편리하게 할 수 있다. 하지만 UIWebView 안에 들어있는 코드들에 대한 디버깅은 전혀할 수 가 없다.

웹 프로그램을 개발할때 웹 개발자들은 웹 화면에 나타나는 코드를 분석하거나 브라우저 앤진에서 연산되는 코드들을 디버깅한다.  이 때 사용되는 대표적인 툴이 Firebug나 Webkit Inspector 가 있다. Firebug는 Firefox 브라우저에서 동작하는 웹 개발툴로 현재의 Firefox의 명성을 유지하는데 가장 큰 역활을한 플러그인이 아닌가 생각이 든다. 그리고 오픈소스 WebKit 기반의 브라우저는 Inspector라는 툴로 Firefox의 Firebug과 동일한 작업을 할 수 있다. 현재 구글의 Chrome과 애플의 Safari는 WebKit 기반의 브라우저로 개발되어있고 두 브라우저 모두 Inspector를 사용할 수 있다. 아래는 지금 글을 작성하는 이 화면을 Web Inspector의 화면으로 열어본 것이다. Eelements는 HTML의 DOM의 구조를 보여주고 Resources는 웹을 표현하는데 사용되는 리소스들을 보여준다. 그리고 Network는 리소스들이 사용자에게 표현되기 까지의 시간을 보여준다. Scripts는 javascript 코드를 보거나 디버깅(브레이크 포인트 등)을 할 수 있는 메뉴이다. 그리고 console은 Javascript가 동작하는 것을 확인하거나 변수의 내용을 출력시킬 수 있는 콘솔이다. (다른 메뉴들도 각각 기능이 있지만 이 포스트에서 소개는 하지 않겠다.)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/1e66ecc5-b55c-4136-9445-36d4b766223c)

이렇게 웹을 개발할때는 Web Inspector를 사용할 수 있으니가 UIWebView에 이것을 이용하면 될거라는 생각을 하고 찾아보기 시작했다. 하지만 UIWebView는 Safari 브라우저가 아니다. UIWebView는 iOS SDK의 UIKit에 포함된 웹뷰이기 때문에서 Web Inspector를 바로 실행시킬 수 없다. 더구나 Web Inspector는 Mac 에 포함된 기능이지 아이폰 자체에 포함된 기능은 아니기 때문이다. 그래서 조사하던 도중에 [@kenu0000](http://twitter.com/kenu0000) [@iolothebard](http://twitter.com/iolothebard) 께서 조언을 해주신 weinre를 사용할 수 있게 되었다. (다시 한번 링크와 조언 감사드립니다)

weinre 의 사이트는 http://phonegap.github.com/weinre/ 이다. 그리고 다음 그림은 weinre 첫 화면에 나타내는 그림인데, 아이폰 시뮬레이터 속에 있는 웹페이지의 내용을 맥에 있는 Safari 브라우저에서 디버깅을 하는 화면이다. 다시 말하면 로컬 PC에 디버깅 서버를 동작시키고 그 서버에서 분석한 결과를 웹으로 확인하는 방법이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/919b4f0d-2ef6-424c-8384-c9bd0104ccc0)

하지만 위에 슬라이드나 그림들은 모두 시뮬레이터의 브라우저에서 코드를 실행한 결과를 확인하는 것인다. 우리의 목적은 UIWebView 안에 Hybrid 앱을 만들기 위한 코드를 작성하면서 디버깅을 하고 싶은 것이다. 그래서 예제를 준비 했다.

우선 weinre를 다운받는다. 맥 버전을 받아도 좋고 jar 버전을 받아도 괜찮다. 다음 링크로 가서 zip 파일을 다운 받아서 unzip을 한다.

https://github.com/callback/callback-weinre/archives/master

맥 버전을 사용한다고 가정하고 weinre-mac을 다운받아서 실행한다. 실행하면 Safari에서 Web Inspector과 거의 동일한 메뉴들이 보일 것이다. 만약 jar 버전을 다운 받으면 아래 명령어로 실행하고 http://localhost:8080/client 로 브라우저를 열어서 확인할 수 있다. boundHosts 에는 자동으로 host가 탐색되는데 IP 정보가 나와서 잘라 내었다. 원래는 IP 주소 목록이 나온다.

```
java -jar weinre.jar --boundHost -all-
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/af48f273-ae42-413f-affc-669a74578956)

Single View Application을 하나 만들고 UIWebView를 추가하도록 하자. 그리고 Web 이라는 폴더 안에 index.html 파일을 만들고 프로젝트에 추가를 하는데 파을을 복사하지 않고 Xcode 프로젝트 내에서 참조만 할 수 있게 다음과 같이 설정한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/540cc95f-2c7d-474b-8be1-31d8bb34d60d)

index.html에는 다음과 같은 코드를 입력한다. weinre 서버가 디폴트로 8080 포트로 운영되기 때문에 localhost 의 8080 으로 접근해서 디버깅을 하기 위한 javascript를 받아온다. 그리고 우리가 테스트할 메소드를 하나 만들었다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>UIWebView Debugging Tutotial</title>
    <meta name="viewport" content="initial-scale=1.0,user-scalable=no">

    <script src="http://localhost:8080/target/target-script-min.js"></script>
    <script type="text/javascript">
        function callPrint() {
            console.log('first');
            console.log('second');
        }
    </script>
</head>
<body>
    <button onclick="callPrint();">call print</button>
</body>
</html>
```

viewController에는 물러적으로 만든 index.html 파일을 가져오도록 다음 코드를 추가한다. 위에 것은 .h 파일이고 밑에 것은 .m 파일이다.

```objective-c
//  SFViewController.h
//  SaltfactoryiOSTutorial
//
//  Created by SungKwang Song on 4/2/12.
//  Copyright (c) 2012 saltfactory@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *appWebView;
@end
```

```objective-c
//
//  SFViewController.m
//  SaltfactoryiOSTutorial
//
//  Created by SungKwang Song on 4/2/12.
//  Copyright (c) 2012 saltfactory@gmail.com. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()

@end

@implementation SFViewController
@synthesize appWebView;

- (NSString *) getFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Web"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *uri = [NSURL fileURLWithPath:[self getFilePath]];
    [appWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[uri absoluteString] stringByAppendingString: @"?"] stringByAppendingString: [uri absoluteString]]]]];
}

- (void)viewDidUnload
{
    [self setAppWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
```

실행시키면 간단한 버턴만 눈에 보일 뿐 아무러 동작을 하지 않는다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/607ff981-d595-4ae5-aeb4-01eca4c47083)

우리는 프로젝트를 만들고 UIWebView를 추가하기 전에 UIWebView를 디버깅하기 위해서 weinre를 실행하였었다. 그 화면으로 돌아가보면 Targets에 시뮬레이터가 감지되고 번들 밑에 Web 폴더 안의 index.html을 타게팅하는 정보를 얻게 된다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/61f2d043-6d44-4d50-88ae-54d5bbd89855)

Inspector의 Elements를 열어서 특정 DOM을 선택하면 UIWebView 안에서 해당되는 엘리먼트가 선택되는 것을 확인할 수도 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/79e7957c-dbc1-4222-9340-8a10a16038fb)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/940be16f-9d29-468b-8080-69d52eb44aea)

그리고 버턴을 눌렀을때 console에 메세지를 출력하게 함수를 만들었는데 버턴을 눌러보면 콘솔에 로그가 찍히는 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/f5363be4-bbd0-4168-bc16-24b045997de0)

뿐만아니라 만약에 Javascript 에서 에러가 발생하면 콘솔에서 에러 메세지를 확인할 수 있다. 에러를 발생시키기 위해서 일부러 console.log를 consol.log로 만들어서 테스트 하였다. Can't find variable: consol 이라는 에러가 나타난다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/80699b7a-3eec-468d-bff4-1b7ea3df4644)

자바스크립트 코드만 확인할 수 있는 것이 아니라 Elements 창에서 실시간으로 HTML 코드를 변경할 수 있고 CSS를 변경하여 확인할수도 있다. 아래는 버턴의 글자 크기를 Inspector에서 변경하여 바로 확인한 결과 이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/a4ef02b7-d634-4935-b985-c931575df207)

이제 하이브리드 앱을 개발할 때 UIWebView 안에 HTML, CSS, Javascript의 값을 확인하거나 변경할 수 있게 되었다. 다만 개발자들에게 좀 아쉬운 부분은 javascript의 변수들이 어떻게 변화되는지를 console.log로 계속 확인해야한다면 약간 부담스럽다. 그래서 개발자들은 breakpoint 기능이 있기를 원한다. 하지만 아쉽게도 weinre에서는 Web Inspector에서 제공하는 Scripts 메뉴가 없어서 javasctipt 디버깅을 하기에 약간 아쉬운 감이 있다. 이럴 경우에는 애플에서만 사용하는 private API를 이용하여 아쉬운 부분을 해결할 수 있다. 하지만 지금 소개하는 것은 private API 이기 때문에 이 코드를 남겨두고 앱스토어에 등록하면 reject를 당하게 된다. 앱스토어에 등록할때는 반드시 이 코드를 제외시켜야 함을 기억하자.

AppDelegate.m 파일에서 앱이 구동되면 호출되는 application:didFinishLaunchingWithOptions: 메소드에 다음 코드를 추가하는 것이다.

```
[NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
```

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SFViewController alloc] initWithNibName:@"SFViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
```

Javascript의 변수의 값이 변화되는 것을 디버깅하기 위해서 index.html의 코드를 다음과 같이 변경한다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>UIWebView Debugging Tutotial</title>
    <meta name="viewport" content="initial-scale=1.0,user-scalable=no">

    <script src="http://localhost:8080/target/target-script-min.js"></script>
    <script type="text/javascript">
        function callPrint(message) {
            console.log(message);
            console.log('second');
        }
    </script>
</head>
<body>
    <button onclick="callPrint('saltfactory');">call print</button>
</body>
</html>
```

이제 다시 Build & Run을 하여 시뮬레이터를 실행시킨다. 그리고 http://localhost:9999 로 Safari 브라우저에서 접속한다. weinre를 사용할 때와 비슷한 것이 나오며 디버깅이 시작된다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ab49073d-681c-4b85-9a02-7517b932a53f)

링크를 클릭해서 들어가서  Scripts 메뉴에서 breakpoint를 linenumber가 나오는 패널에다 추가할 수 있고 실행하여 breakpoint에 걸렸을 때 변수에 어떤 값이 들어있는지 변수 값의 변화를 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/a92b168e-e120-4bc5-b0bf-476106b2e1ad)

Hybrid 앱을 개발하기 위해서는 UIWebView라는 객체의 사용은 필수조건이 된다. 물론 html 파일을 로컬 에디터에서 작성하고 Safari  브라우저에서 작업하여 최종 결과물을 Xcode 프로젝트에 넣어서 활용하기도 하지만 Safari 브라우저와 UIWebView가 100% 똑같이 해석되지 않는다. 더구나 Hybrid 앱을 작성하면 Native 코드와 데이터를 주고 받게 되는데 이것을 동작시키면서 디버깅하는 방법이 필요한데 이때 반드시 UIWebView 상에서 디버깅이 이루어져야한다. 이 때 weinre와 WebView의 private API가 디버깅을 하는데 많은 도움이 될거라 예상된다.

## 참고

1. http://phonegap.github.com/weinre/Installing.html

2. http://atnan.com/blog/2011/11/17/enabling-remote-debugging-via-private-apis-in-mobile-safari/

3. [@kenu0000](http://twitter.com/kenu0000) [@iolothebard](http://twitter.com/iolothebard)  조언 감사합니다.

