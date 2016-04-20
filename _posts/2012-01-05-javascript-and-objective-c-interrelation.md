---
layout: post
title: iPhone에서 하이브리드 앱 개발을 위해 JavaScript와 Objective-C의 상호 호출하는 방법
category: ios
tags: [ios, javascript, objective-c, objc]
comments: true
redirect_from: /86/
disqus_identifier : http://blog.saltfactory.net/86
---

## 서론

하이브리드 앱을 개발하기 위해서는 JavaScript와 네이티브 코드간 상호 호출하는 방법을 알아야한다. 이번 포스트에서는 iPhone 개발을 위해 JavaScript 와 Objective-C의 상호 호출하는 방법에 대해서 소개한다.

<!--more-->

**HTML5**의 인기 때문에 요즘 하이브리드 앱의 인기는 계속적으로 상승하는 분위기이다. HTML5에서 추가된 속성으로 마치 네이티브와 같은 개발을 웹 개발 방법으로 할수 있게 되었다. 또한 실제 네이티브 코드로 작성하면 복잡하고 어려운 부분도 JavaScript나 CSS3로 편리하게 구현할 수도 있다.

하지만 내장 브라우저(webkit)에서만 모든 프로세스를 처리하기에는 브라우저 자체도 하나의 app이기 때문에 메모리와 cpu 사용의 한계가 있다. HTML5로 만들어서 사용하는 웹 앱이 과연 성능이 네이티브 앱과 같은 성능을 내어 주는지 궁금하기도 해서 여러 자문을 구하는데 몇몇 기능을 제외하고 순수 JavaScript로만 구현하면 네이티브보다 성능이 좋게 나오지 않는다고 한다는 이야기를 들었다. JavaScript 인터프리터로 모든것을 처리하기에는 한계가 있기 때문에 핵심부분 데이터 처리나 device API를 호출하기 위해서 JavaScript에서 Objective-C 의 메소드를 호출해야하는 경우가 생긴다.
iOS는 이러한 webkit의 한계를 극복하기 위해서 Objective-C의 메소드를 호출하는 방법을 제공하고 있다. 물론 Objective-C에서 JavaScript를 호출하는 방법도 제공한다. iOS는 이러한 기능을 만들어 놓았기 때문에 개발자가 보다 더 나은 방법으로 네이티비브 코드의 한계와 웹 코드의 한계를 이해하고 더 나은 방법으로 하이브리드 앱을 개발할 수 있다.

## Objective-C에서 Javascript를 호출하는 방법
Objective-C에서 JavaScript를 호출하는 방법은 문자열을 evaluation 시키는 방법이다. `AppViewController`를 새로 생성하고 Outlet으로 **UIWebView**인 `appWebView`를 @property와 @synthesize를 만든다. 그리고 **UIBarButtonItem**을 누르면 `onCallJavascriptButton:` 이 호출될수 있게 선언한다. 그리고 구현클래스에서 IBAction와 연결된 `onCallJavascriptButton:` 메소드를 구현하는데 이때 `stringByEvaluationJavascriptFromString:` 메소드를 이용해서 JavaScript의 메소드를 문자열로 입력한다. 실제 JavaScript는 app.html 파일 안에 `<script>callJavascriptFromObjectiveC()</script>`에 구현이 된다. 즉, `thestringByEvaluationJavascriptFromString:` 메소드를 이용해 JavaScript의 이름을 이용하여 JavaScript 메소드를 호출하는 것이다.

![](http://blog.hibrainapps.net/saltfactory/images/1a0a66c4-fbdd-4caa-9e6f-062ef280d4f7)

```objective-c
/**
* file: AppViewController.h
* author: SungSwang Song
* email: saltfactory@gmail.com
*/

#import <UIKit/UIKit.h>

@interface AppViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *appWebView;
- (IBAction)onCallJavascriptButton:(id)sender;
@end

#import "AppViewController.h"

@interface AppViewController ()

@end
```

```objective-c
/**
* file: AppViewController.m
* author: SungSwang Song
* email: saltfactory@gmail.com
*/

#import <UIKit/UIKit.h>

@interface AppViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *appWebView;
- (IBAction)onCallJavascriptButton:(id)sender;
@end

#import "AppViewController.h"

@interface AppViewController ()

@end
```

```html
<!--
file : app.html
-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name = "viewport" content = "width = device-width"/>
        <title>Hybrid App</title>
        <script type="text/javascript">

            function callJavascriptFromObjectiveC() {
                alert('called javascript function by objective-c');
            }
        </script>
     </head>
    <body>
        <div id="container">
            Hello Hybrid App
        </div>
    </body>
</html>
```

![](http://blog.hibrainapps.net/saltfactory/images/34436836-87b0-403d-b7a0-8271d3bde3d8)

## JavaScript에서 Objective-C를 호출하는 방법
JavaScript에서 Objective-C를 호출하는 방법은 커스텀 Scheme를 이용하는 방법이다. 안드로이드에서도 URI로 리소스에 접근할수 있는데 이렇게 외부에서 URI scheme를 이용해서 특정 메소드에서 접근하는 방법을 사용하면 웹에서 JavaScript나 hyper text로 어플리케이션의 특정 메소드를 호출할 수 있는 브릿지를 구현할 수 있다. app.html에 button을 하나 만들고 버턴이 눌러지면 JavaScript에 구현한 `callObjectiveCFromJavascript()` 를 호출한다. 이 메소드 안에는 `window.location`를 이용해서 커스텀 scheme (ex. `jscall://callObjectiveCFromJavascript`)로 이동하는 코드를 넣어둔다. 그러면 webView의 delegate 메소드의 `webView: souldStartLoadWithRequest:navigationType` 메소드를 호출하는데 이때 특정 메소드가 실행되게 구현하면 된다. 예제 코드에서는 Objective-C 메소드 속에 단순하게 Log를 출력하는 것만 넣어 두었다.

![](http://blog.hibrainapps.net/saltfactory/images/4e123c7c-4f3e-4744-919c-a43bd3cc6680)

```html
<!--
file: app.html
-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name = "viewport" content = "width = device-width"/>
        <title>Hybrid App</title>
        <script type="text/javascript">

            function callJavascriptFromObjectiveC() {
                alert('called javascript function by objective-c');
            }

            function callObjectiveCFromJavascript(){
                window.location="jscall://callObjectiveCFromJavascript";
            }

        </script>
     </head>
    <body>
        <div id="container">
            <h3>Hello Hybrid App </h3>

            <button onclick="callObjectiveCFromJavascript();">Call Objective-C</button>

        </div>
    </body>
</html>
```

```objective-c
/**
* file: AppViewController.m
* author: SungSwang Song
* email: saltfactory@gmail.com
*/

- (void)callObjectiveCFromJavascript {
    NSLog(@"called objective-c from javascript");
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                        navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:@"jscall:"]) {

        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSString *functionName = [components objectAtIndex:1];

        [self performSelector:NSSelectorFromString(functionName)];

        return NO;
    }

    return YES;
}
```

![](http://blog.hibrainapps.net/saltfactory/images/8e96d058-aee9-4ca7-a9ea-b8be819dd6d4)

