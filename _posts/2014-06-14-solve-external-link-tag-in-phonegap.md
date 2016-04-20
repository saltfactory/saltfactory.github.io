---
layout: post
title: PhoneGap(Cordova) 외부 링크(a link) 새창으로 열기
category: hybridapp
tags: [phonegap, cordova, link, browser]
comments: true
redirect_from: /243/
disqus_identifier : http://blog.saltfactory.net/243
---

## 서론

PhoneGap을 사용하여 크로스플랫폼 하이브리드 앱을 개발할 때, PhoneGap은 SDK의 **WebView** 기반으로 동작하는 어플리케이션으로 WebView 에 링크가 있을 경우 PhoneGap 내부의 URL은 해당 페이지를 이동하지만, 만약 외부 URL이 포함된 경우 링크를 터치하면 PhoneGap 하이브리드 앱에서 외부링크로 location이 변경되어 버린다. 이 문제를 해결하기 위해 PhoneGap 내부에서 외부 링크가 포함되었을 때 처리하는 방법에 대해서 소개한다.

<!--more-->

![phonegap](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d7b62578-c5c6-4987-8591-9f64b9533615)

[PhoneGap](http://phonegap.com) ([Cordova](http://cordova.apache.org)) 는 **하이브리드 앱 개발 플랫폼**이다. 모바일 앱 개발을 할 때 하이브리드 앱이라고 하면 통상 웹 자원과 네이티브 자원을 함께 사용해서 앱을 개발하는 것을 의미한다. PhoneGap은 UI 및 사용자의 이벤트를 HTML 나 JavaScript로 처리를 한다. 이 말은 다시말하면 PhoneGap은 내장 ***WebView***를 사용하고 WebView 안에 웹 자원을 사용하여 개발을 한다는 것이다. PhoneGap에서 웹 자원은 로컬 HTML, CSS, 그리고 JavaScript를 사용한다. 웹뷰에서 HTML으로 UI를 만들때 페이지 전환을 링크를 사용한다. 이 때 앱 안에 링크를 사용할 때 다음과 같은 문제를 가진다.

> HTML 파일 안에 a 링크로 외부로 연결하는 코드가 있으면 사용자는 이것을 선택하면 http 주소로 location을 변경하면서 PhoneGap의 UI가 모두 사라져 버리는 문제가 있다.

다시 말해서 앱 안에 `<a href="http://blog.saltfactory.net">blog</a>` 라는 링크가 앱 안에 있을 때 이 링크를 누르는 순간 새로운 창이 나나타는 것이 아니라 동작하던 앱의 화면은 사라지고 WebView는 블로그 페이지로 가득차버리는 문제가 발생한다. 예제로 PhoneGap 프로젝트를 만들어보자.

프로젝트 이름은 **sf-phonegap-demo**라고 만들어보자. 처음 PhoneGap으로 프로젝트를 만든다면 [[PhoneGap 하이브리드 앱 개발] #1. PhoneGap과 Node.js로 하이브리드 앱 개발환경 구축하기](http://blog.saltfactory.net/228) 글을 참조하여 만든다.

```
phonegap create sf-phonegap-demo -n Sf-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

우리는 UI를 [Ionic Framework](http://ionicframework.com)를 이용해서 만들것이다. PhoneGap은 `build`를 할 경우 자동으로 www 디렉토리 안에 있는 웹 자원을 각 플랫폼으로 복사하기 때문에 우리가 사용할 라이브러리를 `www/lib` 로 넣어둘 것이다. 우리는 웹 라이브러리를 [bower](http://bower.io)를 이용해서 설치할 것이다. 컴퓨터에 `bower` 명령어가 설치되지 않았으면 `npm`을 이용해서 bower를 설치한다.

```
npm install -g bower
```

`bower`를 설치하고 난 이후 bower의 컴포넌트 들의 설치 디렉토리를 `www/lib`로 지정하기 위해서 다음과 같이 `.bowerrc`를 만든다.

```
vi .bowerrc
```

```
{
  "directory": "www/lib"
}
```

이제 bower를 이용하여 ionic을 설치해보자.

```
bower install driftyco/ionic-bower
```

bower로 설치가 끝나면 `www/lib` 안에 다음과 같이 라이브러리들이 설치된 것을 확인할 수 있다.

![after install ionic using bower](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2dded45d-ad07-42f2-bfe4-26ff4626cba1)

이제 테스트를 위해서 www/index.html 파일을 다음과 같이 수정한다.

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">

        <link href="lib/ionic/css/ionic.css" rel="stylesheet">
        <script src="lib/ionic/js/dist/js/ionic.bundle.js"></script>
        <script>
          angular.module('SFApp', ['ionic'])
        </script>
        <title></title>

    </head>
    <body ng-app="SFApp">
<div class="bar bar-header bar-positive">
        <h1 class="title">a link demo</h1>
      </div>

      <ion-content class="has-header" padding="true">
        <a href="http://blog.saltfactory.net">Go saltfactor's blog</a>
      </ion-content>

    </body>

</html>
```

프로젝트를 만들고 ios 플랫폼을 만들어보자

```
phonegap build ios
```

그리고 테스트를 위해 작성한 앱을 iOS 시뮬레이터로 실행해보자.

```
phonegap run ios
```

실행을 해보면 아래 그림과 같이 ionic framework 안에 링크가 하나 있는 앱이 실행이 될 것이다. 이젠 링크를 클릭해보자. 어떻게 되는가?

> a 링크는 우리가 만든 앱을 사라지게 만들어버리고 a 링크가 가지고 있는 URL로 화면이 변경되어 버려 PhoneGap으로 만든 앱이 사라져 버리고 WebView에 새로운 사이트가 가득차 버리게 되는 문제가 발생한다.

![simple page with in a link {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/05042842-8628-47b3-8979-18962d7ed712)
![change new page after click link {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8b033733-7edf-4605-b31b-0d8dbbd8351e)

그럼 PhoneGap 으로 하이브리드 앱을 만들때 컨텐츠 안에 a 링크가 있을 경우 어떻게 대처해야할까?

> 보통 a 링크는 다른 사이트로 이동을 시키기 위해서 많이 사용하기 때문에 링크를 모바일이 가지고 있는 기본 브라우저로 새롭게 열게하면 된다.

##  InAppBrowser 플러그인을 사용

PhoneGap에서 새로운 브라우저를 열기 위해서는 [InAppBrowser](https://github.com/apache/cordova-plugin-inappbrowser) 플러그인이 필요하다. 다음과 같이 inappbrowser 플러그인을 설치한다.

```
phonegap plugin add org.apache.cordova.inappbrowser
```

inappbrowser로 외부링크를 브라우저로 열기 위해서는 HTML 코드 안에 a 링크에 다음과 같이 target이 반드시 필요하다. 그리고 `target`은 `_system`으로 한다. 위 HTML 코드를 다음과 같이 수정하자.

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">

        <link href="lib/ionic/css/ionic.css" rel="stylesheet">
        <script src="lib/ionic/js/dist/js/ionic.bundle.js"></script>
        <script src="cordova.js"></script>
        <script>
          angular.module('SFApp', ['ionic'])
        </script>
        <title></title>

    </head>
    <body ng-app="SFApp">
      <div class="bar bar-header bar-positive">
        <h1 class="title">a link demo</h1>
      </div>

      <ion-content class="has-header" padding="true">
        <!-- <a href="http://blog.saltfactory.net" target="_system">Go saltfactor's blog</a> -->
        <a href="#" onclick="window.open('http://blog.saltfactory.net', '_system');">Go saltfactor's blog</a>
      </ion-content>

    </body>
</html>

```
다시 ios 플랫폼에 코드를 적용해서 실행해보자.

```
phonegap run ios
```

앱이 실행되면 다시 a 링크를 클릭해보자. 아래 그림과 같이 이전과는 다르게 모바일 사파리 브라우저로 열리는 것을 확인할 수 있다. 위 코드는 iOS에서 사용할 경우 `window.open` 에 `target`을 `_system`으로 사용하면 되는 예제를 보여주고 있다. 안드로이드일 경우에는 다음과 같이 `navigator.app.loadUrl`과 `openExtenral:true`를 사용해야한다.

```html
<a href="#" onclick="navigator.app.loadUrl('http://blog.saltfactory.net', {openExternal:true});">Go saltfactor's blog</a>
```

![open safari browser {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/10522908-76f2-4f90-81c2-d7d29baa6641)
![backgroud navigation ios {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e7268fba-88ee-46d5-990b-77126abec6ae)
![background navigation ios {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f189c528-244e-4119-9a5a-a61ca1676925)

하지만 이 방법을 사용하기 위해서는 a 링크의 href를 분석해서 inappbrower를 사용해서 링크를 열수 있는 JavaScript 코드로 변경을 해줘야한다.
> 컨텐츠를 개발자가 만들때는 문제가 되지 않지만 HTML 코드를 서버에서 Ajax와 같은 것을 이용해서 HTML코드를 가져와서 PhoneGap을 적용할 때는 a 링크 사용의 문제는 여전히 존재하게 된다.

## 네이티브 코드 변경 - iOS

PhoneGap은 내부적으로 **WebView**를 열어서 사용하고 로컬의 웹 자원을 사용한다. 다시 말해서 `file://` 로 HTML을 불러오기 때문에
> scheme가 ***http***나 ***https***일 경우에는 브라우저의 새 창으로 열리게 하면 된다.

우리는 PhoneGap 프로젝트를 iOS 플랫폼을 추가해서 만들었는데 iOS 플랫폼 디렉토리에 들어가서 `MainViewController.m` 파일을 열어보자. 그리고 scheme를 분석해서 http와 https일 경우는 모바일 브라우저로 링크를 열게 다음과 같이 코드를 추가한다.

```objective-c
... (생략) ...

#pragma mark UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    // Black base color for background matches the native apps
    theWebView.backgroundColor = [UIColor blackColor];

    return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */

/*

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}
*/


- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];

    // Intercept the external http requests and forward to Safari.app
    // Otherwise forward to the PhoneGap WebView
    if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {
[[UIApplication sharedApplication] openURL:url];
return NO;
    }
    else {
        return [ super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType ];
    }

}

@end
... (생략)...
```

그리고 **InAppBrowser**를 더이상 사용하지 않기 위해서 플러그인을 삭제한다.

```
phonegap plugin remove org.apache.cordova.inappbrowser
```

마지막으로 HTML 코드도 InAppBrowser를 더이상 사용하지 않을 것이기 때문에 최초 a 링크 html 코드로 변경한다.

```html
<a href="http://blog.saltfactory.net">Go saltfactor's blog</a>
```

다시 phonegap으로 ios 시뮬레이터를 실행해보자.

```
phonegap run ios
```

앱을 실행한 후 링크를 클릭하면 다음 그림과 같이 모바일 브라우저로 링크가 열리게 되는 것을 확인할 수 있다.이 방법은 기존의 HTML에 들어있는 a 링크를 InAppB	rowser 플러그인을 사용해서 열도록 코드를 분석해서 태그를 변경하지 않아도 되는 장점이 있다.

![simple page within a link {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/99ed3b32-7659-4d33-a0bd-3805de822619)
![view safari new page from a link {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9cc108bc-cd56-4139-bca2-b9171ca77649)
![ios background navigator {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/41a20586-7cad-4283-a724-b49f951dc0a2)

## 네이티브코드 변경 - Android

위에서 우리는 iOS에서 네이티브 코드를 변경해서 ***WebView***의 이벤트를 핸들링하여 처리하였는데 그러면 Android에서는 어떻게 할 수 있을까? 원리는 동일하다. iOS에서 WebView에서 링크를 클릭하였을 경우 `shouldStartLoadWithRequest`에서 URL을 인터셉트하여 URL scheme를 분석한 것 같이 Android에서는 `shouldOverrideUrlLoading` 안에서 URL scheme를 분석하여 처리하면 가능하다.

먼저 안드로이드 PhoneGap 프로젝트에서 플랫폼을 추가하자.

```
phonegap build android
```

이렇게 안드로이드 플랫폼을 추가하면 자동으로 안드로이드 프로젝트 파일이 생성이 되는데 앱이 시작할때 열리는 Activity를 열어보자. 우리는 PhoneGap 프로젝트 이름을 SfPhoneGapDemo로 만들었기 때문에 Activity의 이름이 `SfPhoneGapDemo.java`로 만들어졌을 것이다. Activity 파일을 열어서 다음과 같이 수정한다.

```java
/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package net.saltfactory.tutorial.phonegapdemo;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import org.apache.cordova.*;

import java.net.MalformedURLException;
import java.net.URL;

public class SfPhoneGapDemo extends CordovaActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        // Set by <content src="index.html" /> in config.xml

        super.init();

        this.appView.setWebViewClient(new CordovaWebViewClient(this, this.appView) {
@Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                Uri uri = Uri.parse(url);

                if (uri.getScheme().equals("http") || uri.getScheme().equals("https")){
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(uri);
                    startActivity(intent);
                    return true;
                } else {
                    return super.shouldOverrideUrlLoading(view, url);
                }
            }

        });


        super.loadUrl(Config.getStartUrl());
        //super.loadUrl("file:///android_asset/www/index.html");
    }

}
```

이제 앱을 실행시켜보자.

```
phonegap run android
```

앱을 실행시켜서 a 링크를 클릭해보자. 그러면 안드로이드 디바이스의 디폴트 브라우저로 링크가 열리는 것을 확인할 수 있다.
이렇게 네이티브 코드를 수정하여 사용하면 InAppBrowser에서 새 창을 브라우저에서 열기 위해서 여러가지 HTML 코드를 다시 프로그램으로 수정할 필요 없이 기존의 HTML 코드의 a 링크를 그대로 사용하면서 새로운 브라우저에 열 수 있게 할 수 있다.

![android simple page within a link {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/253915d7-548e-4840-b277-87daa64fdfeb)
![android default brwoser new page {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d877b6e4-0976-475e-9308-700adf667583)
![android backgroud navigator {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4491441d-cc03-4d41-8588-32a9cff52701)

## 결론

기존의 iOS 앱과 Android 앱을 하나의 코드로 관리하기 위해서 [Ionic Framework](http://ionicframework.com) 를 이용하여 하이브리드 앱을 만들었다. Ionic은 [AngularJS](https://angularjs.org/)와 [Cordova](http://cordova.apache.org)([PhoneGap](http://phonegap.com)) 기반의 하이브리드 앱 개발 플랫폼인데 앱을 구현할 때 상세보기에서 서버로 부터 웹페이지코드(HTML)을 가져와서 뷰에 출력시켜주는 부분이 있었다. 그런데 상세보기 페이지 안에 사용자가 작성한 A 링크가 문제가 되는 것을 확인했다. 서버에서 HTML 코드를 받아오는 것이기 때문에 PhoneGap의 [InAppBrowser](https://github.com/apache/cordova-plugin-inappbrowser) 플러그인을 사용해서 HTML 코드를 변경시키는 것은 복잡하고 비용이 많이 발생하는 것으로 판단되었다. 그래서 서버로부터 받아오는 HTML 의 코드는 변경하지 않고 HTML 코드 안에 A 링크가 포함되어 있을 때 , 사용자가 링크를 클릭(터치)하게 되면 새로운 모바일 브라우저로 링크가 열리게 하려고 자료를 찾고 연구하였다. 방법은 PhoneGap은 네이티브코드의 WebView를 사용하고 있는데 이 WebView는 각각 플랫폼에서 이벤트를 받아서 처리하는 부분에 URL을 인터셉트할 수 있는 것을 확인하였고, iOS에서는 `shouldStartLoadWithRequest`를 이용하고 Android에서는 `shouldOverrideUrlLoading'을 사용하여 처리할 수 있는 것을 알게되었다. 이것이 하이브리드 앱의 장점이 아닌가 생각한다. 웹 자원의 코드를 변경하는 것도 가능하고 네이티브의 자원을 변경하여 사용하는 것도 가능해서 문제의 해결방법이 다양한 각도로 접근할 수 있는 것 같다. 하이브리드 앱을 개발한다면 컨텐츠 안에 들어있는 A 링크를 처리하는 문제를 반드시 겪게 될 것인데 이 포스팅에서 소개하는 내용으로 문제를 해결할 수 있기를 바래본다.

## 참고

1. https://developer.apple.com/library/ios/documentation/uikit/reference/UIWebViewDelegate_Protocol/Reference/Reference.html
2. http://developer.android.com/reference/android/webkit/WebViewClient.html
3. http://stackoverflow.com/questions/17887348/phonegap-open-link-in-browser
4. http://techiepulkit.blogspot.kr/2013/01/android-invoking-url-scheme-intent-from.html
5. http://stackoverflow.com/questions/12601491/android-phonegap-intercept-url-equivalent-of-ios-shouldstartloadwithrequest

