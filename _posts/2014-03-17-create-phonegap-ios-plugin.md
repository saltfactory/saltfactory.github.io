---
layout: post
title : PhoneGap iOS 플러그인 개발
category : HybridApp
tags : [phonegap, hybrid, mobile, ios, plugins]
comments : true
redirect_from : /235/
disqus_identifier : http://blog.saltfactory.net/235
---

## 서론

[PhoneGap](http://phonegap.com)은 멀티 플랫폼 하이브리드 앱 개발 프레임워크이다. 하이브리드 앱이라는 말은 웹의 기술과 네이티브앱의 기술을 융합해서 사용하여 만든 앱이다. 웹에서 접근할 수 없는 네이티브 자원을 네이티브 코드로 만들고 웹에서 접근할 수 있는 인터페이스를 이용해서 웹과 네이티브의 자원을 함께 사용할 수 있는 것을 또는 반대의 개발 방법을 적용하여 앱을 만들 수 있는 것을  말한다. PhoneGap에서는 이런 일련의 과정을 Plugins이라는 것을 사용해서 구현할 수 있다. **Appspresso**에서는 **PDK**를 이용해서 Plugins를 만들수 있지만 **PhoneGap**에서는 PDK와 같은 Plugin Development Kit은 없지만 PhoneGap에서 Plugins을 만들 수 있는 네이티브 클래스를 상속받고 웹에서 접근할 수 있는 JavaScript 인터페이스를 제공하고 있다. 이번 포스팅에서는 iOS 용 앱을 개발을 할 때 네이티브 코드를 사용하는 Plugins을 만들어서 PhoneGap 프로젝트에서 웹과 네이티브 자원을 서로 사용할 수 있는 방법을 소개한다. 이전 포스팅(http://blog.saltfactory.net/233)에서는 PhoneGap의 Plugins 저장소에서 Plugins을 설치하는 방법을 살펴보았다. 이번 포스팅에서는 PhoneGap 프로젝트에 Plugins 저장소에서 가져와서 설치하는 것이 아니라 직접 만든 Plugins을 프로젝트에 설치하는 방법도 함께 소개한다.

<!--more-->

## PhoneGap Plugins 프로젝트 생성

Plugins을 만들기 위해서 먼저 PhoneGap CLI로 PhoneGap 프로젝트를 생성한다.

```
phonegap create sf-phonegap-plugin-demo -i net.saltfactory.tutorial.phonegap.plugindemo -n SF-PhoneGap-Plugin-Demo
```

![phonegap create {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/8167a771-5560-46bf-9e75-8c058e6ecf7c)

현재 PhoneGap CLI 버전( 3.4.0-0.19.7 )에서는 PhoneGap CLI로 프로젝트를 만들면 **identifier**와 프로젝트 이름이 디폴트에서 변경되지 않는 문제가 있다.(참조 : http://blog.saltfactory.net/234) 에디터로 `./www/config.xml` 을 열어서 다음을 수정하자.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- config.xml reference: https://build.phonegap.com/docs/config-xml -->
<widget xmlns     = "http://www.w3.org/ns/widgets"
        xmlns:gap = "http://phonegap.com/ns/1.0"
        id        = "net.saltfactory.tutorial.phonegap.plugindemo"
        version   = "1.0.0">

    <name>SF-PhoneGap-Plugin-Demo</name>

    <description>
        Hello World sample application that responds to the deviceready event.
    </description>

    <author href="http://phonegap.com" email="support@phonegap.com">
        PhoneGap Team
    </author>

    <!--
        Enable individual API permissions here.
        The "device" permission is required for the 'deviceready' event.
    -->
    <feature name="http://api.phonegap.com/1.0/device" />

    <!--
        If you do not want any permissions to be added to your app, add the
        following tag to your config.xml; you will still have the INTERNET
        permission on your app, which PhoneGap requires.
    -->
    <preference name="permissions"                value="none"/>

    <!-- Customize your app and platform with the preference element. -->
    <!-- <preference name="phonegap-version"      value="3.4.0" /> -->      <!-- all: current version of PhoneGap -->
    <preference name="orientation"                value="default" />        <!-- all: default means both landscape and portrait are enabled -->
    <preference name="target-device"              value="universal" />      <!-- all: possible values handset, tablet, or universal -->
    <preference name="fullscreen"                 value="true" />           <!-- all: hides the status bar at the top of the screen -->
    <preference name="webviewbounce"              value="true" />           <!-- ios: control whether the screen 'bounces' when scrolled beyond the top -->
    <preference name="prerendered-icon"           value="true" />           <!-- ios: if icon is prerendered, iOS will not apply it's gloss to the app's icon on the user's home screen -->
    <preference name="stay-in-webview"            value="false" />          <!-- ios: external links should open in the default browser, 'true' would use the webview the app lives in -->
    <preference name="ios-statusbarstyle"         value="black-opaque" />   <!-- ios: black-translucent will appear black because the PhoneGap webview doesn't go beneath the status bar -->
    <preference name="detect-data-types"          value="true" />           <!-- ios: controls whether data types (such as phone no. and dates) are automatically turned into links by the system -->
    <preference name="exit-on-suspend"            value="false" />          <!-- ios: if set to true, app will terminate when home button is pressed -->
    <preference name="show-splash-screen-spinner" value="true" />           <!-- ios: if set to false, the spinner won't appear on the splash screen during app loading -->
    <preference name="auto-hide-splash-screen"    value="true" />           <!-- ios: if set to false, the splash screen must be hidden using a JavaScript API -->
    <preference name="disable-cursor"             value="false" />          <!-- blackberry: prevents a mouse-icon/cursor from being displayed on the app -->
    <preference name="android-minSdkVersion"      value="7" />              <!-- android: MIN SDK version supported on the target device. MAX version is blank by default. -->
    <preference name="android-installLocation"    value="auto" />           <!-- android: app install location. 'auto' will choose. 'internalOnly' is device memory. 'preferExternal' is SDCard. -->

    <!-- Plugins can also be added here. -->
    <!--
        <gap:plugin name="Example" />
        A list of available plugins are available at https://build.phonegap.com/docs/plugins
    -->

    <!-- Define app icon for each platform. -->
    <icon src="icon.png" />
    <icon src="res/icon/android/icon-36-ldpi.png"   gap:platform="android"    gap:density="ldpi" />
    <icon src="res/icon/android/icon-48-mdpi.png"   gap:platform="android"    gap:density="mdpi" />
    <icon src="res/icon/android/icon-72-hdpi.png"   gap:platform="android"    gap:density="hdpi" />
    <icon src="res/icon/android/icon-96-xhdpi.png"  gap:platform="android"    gap:density="xhdpi" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" gap:state="hover"/>
    <icon src="res/icon/ios/icon-57.png"            gap:platform="ios"        width="57" height="57" />
    <icon src="res/icon/ios/icon-72.png"            gap:platform="ios"        width="72" height="72" />
    <icon src="res/icon/ios/icon-57-2x.png"         gap:platform="ios"        width="114" height="114" />
    <icon src="res/icon/ios/icon-72-2x.png"         gap:platform="ios"        width="144" height="144" />
    <icon src="res/icon/webos/icon-64.png"          gap:platform="webos" />
    <icon src="res/icon/windows-phone/icon-48.png"  gap:platform="winphone" />
    <icon src="res/icon/windows-phone/icon-173.png" gap:platform="winphone"   gap:role="background" />

    <!-- Define app splash screen for each platform. -->
    <gap:splash src="res/screen/android/screen-ldpi-portrait.png"  gap:platform="android" gap:density="ldpi" />
    <gap:splash src="res/screen/android/screen-mdpi-portrait.png"  gap:platform="android" gap:density="mdpi" />
    <gap:splash src="res/screen/android/screen-hdpi-portrait.png"  gap:platform="android" gap:density="hdpi" />
    <gap:splash src="res/screen/android/screen-xhdpi-portrait.png" gap:platform="android" gap:density="xhdpi" />
    <gap:splash src="res/screen/blackberry/screen-225.png"         gap:platform="blackberry" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait.png"    gap:platform="ios"     width="320" height="480" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait-2x.png" gap:platform="ios"     width="640" height="960" />
    <gap:splash src="res/screen/ios/screen-ipad-portrait.png"      gap:platform="ios"     width="768" height="1024" />
    <gap:splash src="res/screen/ios/screen-ipad-landscape.png"     gap:platform="ios"     width="1024" height="768" />
    <gap:splash src="res/screen/windows-phone/screen-portrait.jpg" gap:platform="winphone" />

    <!--
        Define access to external domains.

        <access />            - a blank access tag denies access to all external resources.
        <access origin="*" /> - a wildcard access tag allows access to all external resource.

        Otherwise, you can specify specific domains:
    -->
    <access origin="http://127.0.0.1*"/> <!-- allow local pages -->
    <!--
        <access origin="http://phonegap.com" />                    - allow any secure requests to http://phonegap.com/
        <access origin="http://phonegap.com" subdomains="true" />  - same as above, but including subdomains, such as http://build.phonegap.com/
        <access origin="http://phonegap.com" browserOnly="true" /> - only allows http://phonegap.com to be opened by the child browser.
    -->


</widget>
```

## iOS 플랫폼 추가

다음은 iOS용 PhoneGap Plugins을 만들기 위해서 iOS 플랫폼을 추가한다. PhoneGap CLI로 최초 프로젝트를 만들면 어떠한 플랫폼도 설치되지 않는다. PhoneGap CLI의 build를 해야 iOS 자원들이 만들어진다.

```
phonegap local build ios
```

위와 같이 `phonegap local build`를 실행하면 비어있던 `./platforms` 디렉토리에 iOS 플랫폼 자원이 만들어진 것을 확인할 수 있다. iOS 플랫폼의 자원중에 iOS 프로젝트 디렉토리를 살펴보자. 우리는 PhoneGap 프로젝트 이름을 **SF-PhoneGap-Plugin-Demo**로 만들었다.

```
ls -l ./platforms/ios/SF-PhoneGap-Plugin-Demo
```

![phonegap ios platform {max-width: 600px;}](http://asset.hibrainapps.net/saltfactory/images/2774593a-84c1-46b1-bf8f-87aa4c93b3a0)

`./platforms/ios/SF-PhoneGap-Plugin-Demo` 라는 디렉토리 안에는 iOS 프로젝트에 사용하는 파일들이 존재하고 `Plugins`라는 디렉토리가 있는 것을 확인할 수 있다. 현재 아무런 Plugins을 만들지 않았기 때문에 비어있는 상태이다.

## XCode를 이용해서 iOS 프로젝트 실행

iOS용 Plugins을 만들기 위해서는 **Xcode가** 필요하다. PhoneGap CLI로 local build ios를 이용해서 iOS 플랫폼 자원을 만들면 iOS 코드를 편집할 수 있는 Xcode 프로젝트 파일도 함께 만들어지는데 위치는 `./platforms/ios` 안에 `{PhoneGap 프로젝트 이름}.xcodeproj` 파일로 만들어진다.

![xcode project {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/d4679763-3330-4cfc-8426-ac893ca50ac1)

`./platforms/ios/SF-PhoneGap-Plugin-Demo.xcodeproj` 파일을 실행시켜보자. 아래와 같이 **SF-PhoneGap-Plugin-Demo** 프로젝트 안에 `CordovaLib.xcodeproj` 파일이 포함되어 있는 것을 알 수 있다. 또한 **Build Phases의 Link binary With Libraries**를 살펴보면 **libCordova.a**라는 cordova의 static library가 포함되어 있는 것을 확인할 수 있다. 이러한 이유로 Cordova에서 만든 Class를 우리는 별 다른 설정없이 사용할 수 있다.

![xcode build phases {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/b64c2311-cd71-4d3f-8b7a-bc9bb7a6128f)

우리는 이제 PhoneGap 공식 문서의 Echo 기능을 가진 Plugin을 만들어볼 것이다. (참조 : http://docs.phonegap.com/en/edge/guide_hybrid_plugins_index.md.html#Plugin%20Development%20Guide) 문서에서는 복잡하게 설명이 되어 있는데 간단하게 원리는 다음과 같다.

1. Xcode에서 iOS에 사용하는 Class를 만든다. 이 때 Cordova의 CDVPlugin을 상속 받아서 만든다.
2. 새롭게 추가한 Class에 method를 추가하고 method를 구현한다.
3. 웹에서 접근할 수 있기 위해서 cordova에서 네이티브 코드에 접근할 수 있는 JavaScript로 웹에서 접근할 수 있는 인터페이스를 만든다. 이때 cordova.exec 함수를 이용해서 접근하는데 "Class이름", "메소드이름", "문자열 배열 인자값"으로 접근하여 새롭게 추가한 Class의 method를 실행한다.

위의 Plugins 개발 순서를 기억하면서 진행해보자.

## Cordova의 CDVPlugin을 상속받은 Class 만들기

**SF-PhoneGap-Plugin-Demo** 안에 있는 `Plugins` 디렉토리에서 **New File** 을 한다.

![New file {max-width: 600px;}](http://asset.hibrainapps.net/saltfactory/images/06bda890-7951-4094-bf48-25d05bde7c03)

그리고 **Subclass of** 부분에서 우리는 Cordova의 CDVPlugin을 상속받아서 만들려하기 때문에 **CDVPlugin**을 입력한다. 그리고 새로운 파일의 Class 이름을 입력한다. 우리는 Echo 하는 클래스를 만들 것이기 때문에 편의상 이름을 **SFPluginEcho**라 입력하겠다.

![New file {max-width: 600px;}](http://asset.hibrainapps.net/saltfactory/images/38e1f854-e64b-47df-b5a3-4a7b5d4a2354)

![New file {max-width: 600px;}](http://asset.hibrainapps.net/saltfactory/images/9db90376-fe79-462e-86b5-3dd9eccda788)

위와 같이 새로운 Class 파일을 Plugins에 만들어 진것을 확인할 수 있다. 우리는 간단히 웹에서 넘겨준 문자열을 iOS 자원인 **UIAlertView**를 이용해서 경고창을 띄우는 것을 에제로 해볼 것이다. 메소드 이름은 echo로 하겠다. `SFPluginEcho.h`에 다음과 같이 메소들 선언한다.

메소드를 추가하기 전에 CDVPlugin를 상속 받은 `SFPluginEcho.h` 파일을 살펴보면 `#import<Cordova/Cordova.h>`에 에러가 발생한 것을 확인할 수 있다. PhoneGap CLI의 버그인지 알수 없지만 Cordova 라이브러리를 추가하여 사용할 때 `Cordova/CDV.h`를 import 해야하기 때문에 다음과 같이 변경한다.

![cordova header import {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/532462f1-5db4-4eb9-a948-415bd2e512f2)

아래와 같이 `Cordova/CDV.h`를 import하면 위의 에러가 사라진다. `Cordova/CDV.h`를 열어서 확인하면 그 안에 `CDVPlugin.h`를 import하고 있는 것을 확인할 수 있다.

![import header {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/8f958f3b-ec50-40d9-8de1-af277cee7c2f)

이제 echo 메소드를 추가하자. 메소드를 추가할 때 이 Class는 웹에서 Cordova가 제공하는 JavaScript 인터페이스로 접근을 할 것이다. 이 때, Cordova 내부에서 지정하기를 `CDVInvokedUrlCommand` 형태로 넘어오기 때문에 메소드를 추가할 때는 인자값을 `CDVInokedUrlCommand`를 받을 수 있게 정의 한다.

```objective-c
//
//  SFPluginEcho.h
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import <Cordova/CDV.h>

@interface SFPluginEcho : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;

@end
```

이제 `SFPluginEcho.m` 파일을 열어서 메소드를 구현하자. `CDInvokedUrlCommand`의 인자중에서 첫번째 문자열을 iOS의 자원인 `UIAlerView`를 열어서 출력시켜주는 코드를 추가했다.

```objective-c
//
//  SFPluginEcho.m
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import "SFPluginEcho.h"

@implementation SFPluginEcho

- (void)echo:(CDVInvokedUrlCommand *)command
{
    NSString* message = [command.arguments objectAtIndex:0];

    [[[UIAlertView alloc] initWithTitle:@"iOS 알림" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

@end
```

## 웹에서 네이티브 Class와 method에 접근할 수 있는 JavaScript 인터페이스 만들기

이제 웹에서 이 코드에 접근하기 위해서 JavaScript 코드를 추가할 것이다. `./www/js/sf_phonegap_plugin_demo_echo.js`를 만들어서 다음과 같이 추가한다. Cordova 인터페이스는 다음과 같이 `cordova.exec()`로 네이티브 class와 method에 접근할 수 있는 방법을 제공한다. 우리는 위에서 네이티브 class 이름을 **SFPluginEcho**라고 지정했고 method 이름을 `echo`라고 지정했다. `cordova.exec()`는 인자값은 다음과 같다.

```javascript
cordova.exec(성공후 실행될 콜백함수, 실패후 실행될 콜백함수, 서비스, 액션, 인자값배열);
```

간단한 예제를 위해서 콜백함수를 null로 입력하고 인자값은 하나만 입력 받기 위해서 다음과 같이 했다.

```javascript
//
//  sf_phonegap_plugin_demo_echo.js
//
//  Created by SungKwang Song on 3/12/14.
//
//


function SFPluginEcho(){}

SFPluginEcho.prototype.echo = function(message){
  cordova.exec(null, null, "SFPluginEcho", "echo", [message]);
}
```

## index.html 에 JavaScript 인터페이스 로드

위의 생성한 JavaScript를 로드해서 사용하기 위해서 `./www/index.html` 페이지를 다음과 같이 수정한다. 위에서 만든 `sf_phonegap_plugin_demo_echo.js`를 로드시키고 모든 자원이 로드 되고 나면 `runEcho` 함수를 실행시킨다. 이때 위에서 JavaScript 인터페이스에서 우리가 정의한 **SFPluginEcho** 오브젝트와 message를 인자로 받는 echo 함수를 **SFPluginEcho** 오브젝트에 연결해두었다. `runEcho`는 **SFPluginEcho** 오브젝트를 새로운 인스턴스로 만들고 정의한 `echo`를 message를 입력받아서 호출하게 한다.

```html
<!DOCTYPE html>
<!--
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
-->
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="format-detection" content="telephone=no" />
        <!-- WARNING: for iOS 7, remove the width=device-width and height=device-height attributes. See https://issues.apache.org/jira/browse/CB-4323 -->
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
        <link rel="stylesheet" type="text/css" href="css/index.css" />
        <title>Hello World</title>
    </head>
    <body>
        <div class="app">
            <h1>PhoneGap</h1>
            <div id="deviceready" class="blink">
                <p class="event listening">Connecting to Device</p>
                <p class="event received">Device is Ready</p>
            </div>
        </div>
        <script type="text/javascript" src="phonegap.js"></script>
        <script type="text/javascript" src="js/sf_phonegap_plugin_demo_echo.js"></script>
        <script type="text/javascript">

            var runEcho = function(){
              var pluginEcho = new SFPluginEcho();
              pluginEcho.echo("웹에서 보낸 메세지를 UIAlertView를 이용해서 보기");
            };


            document.addEventListener('deviceready', runEcho, false);
        </script>
    </body>
</html>
```

이제 웹과 네이티브 자원이 함께 사용할 준비를 모두 마쳤다. PhoneGap CLI로 빌드해서 실행해보자.

```
phonegap local build ios
```

```
phonegap local install ios
```

![ios simulator {max-width:320px;}](http://asset.hibrainapps.net/saltfactory/images/a62b28e7-64f8-4815-9c15-5886852b86c3)

## CDVPluginResult를 이용해서 네이티브의 데이터를 JavaScript에 넘겨서 사용하기

이젠 네이티브 코드에서 JavaScript로 데이터를 넘기는 것을 확인해보자. 위에서 구현한 echo 메소드는 단순하게 웹에서 문자열을 넘겨서 네이티브 자원인 `UIAlertView`를 열어서 문자열을 출력하기로 한 예제였다면, 이번 예제는 네이티브 코드에서 가져온 문자열을 웹으로 넘겨서 웹에서 문자열을 출력하게하기 위한 예제이다.

`SFPluginEcho.h` 파일을 열어서 다음과 `getMessage` 메소드를 추가한다.

```objective-c
//
//  SFPluginEcho.h
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import <Cordova/CDV.h>

@interface SFPluginEcho : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)getMessage:(CDVInvokedUrlCommand *)command;
@end
```

`SFPluginEcho.m` 파일을 열어서 `getMessage` 메소드를 구현한다. 네이티브코드에서 `NSDictionary` 타입으로 오브젝트를 만들어서 `CDPluginResult`에 `messageAsDictionary`에 `NSDictionary` 데이터를 넘겨서 `commandDelete`의 `sendPluginResult`로 넘겨주게되면 웹에서 callbackSuccess 함수에서 result 인자값에 json 오브젝트로 받을 수 있게 된다.

```objective-c
//
//  SFPluginEcho.m
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import "SFPluginEcho.h"

@implementation SFPluginEcho

- (void)echo:(CDVInvokedUrlCommand *)command
{
    NSString* message = [command.arguments objectAtIndex:0];
    [[[UIAlertView alloc] initWithTitle:@"iOS 알림" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

- (void)getMessage:(CDVInvokedUrlCommand *)command
{

    [self.commandDelegate runInBackground:^{

        NSDictionary *jsonInfo = @{@"name": @"iOS에서 만든 메세지"};

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}
@end
```

다음은 `sf_phonegap_plugin_demo_echo.js`를 열어서 `getMessage`를 prototype으로 추가한다.

```javascript
//
//  sf_phonegap_plugin_echo.js
//
//  Created by SungKwang Song on 3/12/14.
//
//


function SFPluginEcho() {}
SFPluginEcho.prototype.echo = function(message) {

  cordova.exec(null, null, "SFPluginEcho", "echo", [message]);
};


SFPluginEcho.prototype.getMessage = function(){
  var callbackSuccess = function(result){
    alert(result.name);
  };

  var callbackFail = function(error){
    alert(error);
  };

  cordova.exec(callbackSuccess, callbackFail, "SFPluginEcho", "getMessage", []);

}
```

마지막으로 `sf_plugin_demo_echo.js`를 로드하는 `index.html`을 열어서 다음과 같이 수정한다.

```html
<!DOCTYPE html>
<!--
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
-->
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="format-detection" content="telephone=no" />
        <!-- WARNING: for iOS 7, remove the width=device-width and height=device-height attributes. See https://issues.apache.org/jira/browse/CB-4323 -->
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
        <link rel="stylesheet" type="text/css" href="css/index.css" />
        <title>Hello World</title>
    </head>
    <body>
        <div class="app">
            <h1>PhoneGap</h1>
            <div id="deviceready" class="blink">
                <p class="event listening">Connecting to Device</p>
                <p class="event received">Device is Ready</p>
            </div>
        </div>
        <script type="text/javascript" src="phonegap.js"></script>
        <script type="text/javascript" src="js/sf_phonegap_plugin_demo_echo.js"></script>
        <script type="text/javascript">

        function runEcho() {
          var pluginEcho = new SFPluginEcho();
          // pluginEcho.echo("웹에서 보낸 메세지를 UIAlertView를 이용해서 보기");
          pluginEcho.getMessage();
        }

        document.addEventListener('deviceready', runEcho, false);

        </script>
    </body>
</html>
```

PhoneGap CLI로 build하고 install을 해보자.

```
phonegap local build ios
```

```
phonegap local install ios
```

![ios simulator {max-width:320px;}](http://asset.hibrainapps.net/saltfactory/images/6a153987-a8db-4a48-8f7b-b81c932bff92)

위와 같이 네이티브 코드에서 `CDVPluginResult`에 값을 Dictionary 넘겨서 JavaScript의 callback에서 JSON 값을 받아서 출력할 수 있다.

## 네이티브 코드에서 JavaScript 함수를 호출하기

위의 예제는 네이티브에서 처리한 결과를 **CDVPluginResult**를 이용하여 `cordova.exec()`를 실행할 때 넘겨받는 callbackSuccess에 값을 넘겨서 사용하는 예제였다. 하지만 하이브리드 앱은 네이티브 코드에서 JavaScript 함수를 호출하여 사용하는 경우도 필요하다. 즉, `cordova.exec()`로 처리후 callback을 사용하는 것이 아니라 네이티브 코드 자체에서 JavaScript를 호출할 수 있어야하기 때문이다. 이렇게 네이티브코드에서 JavaScript를 호출하는 방법은 두가지로 처리할 수 있다.

1. `[self.webView stringByEvaluatingJavaScriptFromString:]` 을 이용하는 방법이다. PhoneGap으로 프로젝트를 생성하여 Plugins을 만들 때 **CDVPlugin** 객체를 상속받아서 만들게 되는데 이때 CDVPlugin은 하이브리드 앱을 만들기 위해서 **UIWebView**를 참조하고 있기 때문에 `self.webview`로 UIWebView에 접근할 수 있다.
2. `[self.commandDelegate evalJs:]` 를 이용하는 방법이다. PhoneGap 프로젝트의 Plugins을 만들때 **CDVPlugin** 객체를 상속받아서 만들게 되는데 이 때 CDVPlugin 안에 JavaScript와 브릿지 역활을 하는 `commandDelegate`에 `evalJs`로 스트링타입으로 JavaScript를 호출할 수 있다.

이 두가지를 모두 확인해보자.

### [self.webView stringByEvaluatingJavaScriptFromString:] 을 이용해서 네이티브 코드에서 JavaScript 함수 호출하기

먼저 `SFPluginEcho.h`를 열어서 다음 코드를 추가한다.

```objective-c
//
//  SFPluginEcho.h
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import <Cordova/CDV.h>

@interface SFPluginEcho : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)getMessage:(CDVInvokedUrlCommand *)command;
- (void)runJavasScriptFuncion:(CDVInvokedUrlCommand *)command;
@end
```

다음은 `SFPluginEcho.m` 을 열어서 위에서 선언한 `runJavaScriptFunction`을 구현한다. `[self.webView stringByEvaulationgJavaScriptFromString:]`을 이용할 경우 JavaScript 함수를 호출할 때 무조건 String 으로 호출할 수 있다. 이때 JSON과 같은 파라미터를 넘기기 위해서는 NSDictionary를 String 타입으로 변경해서 넘겨줘야한다.

```objective-c
//
//  SFPluginEcho.m
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import "SFPluginEcho.h"

@implementation SFPluginEcho

- (void)echo:(CDVInvokedUrlCommand *)command
{
    NSString* message = [command.arguments objectAtIndex:0];
    [[[UIAlertView alloc] initWithTitle:@"iOS 알림" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

- (void)getMessage:(CDVInvokedUrlCommand *)command
{

    [self.commandDelegate runInBackground:^{

        NSDictionary *jsonInfo = @{@"name": @"iOS에서 만든 메세지"};

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}

- (void)runJavasScriptFuncion:(CDVInvokedUrlCommand *)command
{
    NSDictionary *jsonInfo = @{@"name": @"iOS에서 자바스크립트 실행"};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:&error];
    CDVPluginResult *pluginResult = nil;

    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *javaScriptString = [NSString stringWithFormat:@"print_message(%@)", jsonString];

        [self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

@end
```

다음은 `sf_phonegap_plugin_demo_echo.js`에 다음 코드를 추가한다.

```javascript
//
//  sf_phonegap_plugin_echo.js
//
//  Created by SungKwang Song on 3/12/14.
//
//


function SFPluginEcho() {}
SFPluginEcho.prototype.echo = function(message) {

  cordova.exec(null, null, "SFPluginEcho", "echo", [message]);
};


SFPluginEcho.prototype.getMessage = function(){
  var callbackSuccess = function(result){
    alert(result.name);
  };

  var callbackFail = function(error){
    alert(error);
  };

  cordova.exec(callbackSuccess, callbackFail, "SFPluginEcho", "getMessage", []);

}

SFPluginEcho.prototype.runJavaScript = function(){
  var callbackFail = function(error){
    alert(error);
  };

  cordova.exec(null, callbackFail, "SFPluginEcho", "runJavasScriptFuncion", []);

}

function print_message(result){
  alert(result.name);
}
```

마지막으로 `sf_phonegap_plugin_echo.js`를 로드하는 `index.html`을 수정한다.

```html
<!DOCTYPE html>
<!--
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
-->
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="format-detection" content="telephone=no" />
        <!-- WARNING: for iOS 7, remove the width=device-width and height=device-height attributes. See https://issues.apache.org/jira/browse/CB-4323 -->
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
        <link rel="stylesheet" type="text/css" href="css/index.css" />
        <title>Hello World</title>
    </head>
    <body>
        <div class="app">
            <h1>PhoneGap</h1>
            <div id="deviceready" class="blink">
                <p class="event listening">Connecting to Device</p>
                <p class="event received">Device is Ready</p>
            </div>
        </div>
        <script type="text/javascript" src="phonegap.js"></script>
        <script type="text/javascript" src="js/sf_phonegap_plugin_demo_echo.js"></script>
        <script type="text/javascript">

        function runEcho() {
          var pluginEcho = new SFPluginEcho();
          // pluginEcho.echo("웹에서 보낸 메세지를 UIAlertView를 이용해서 보기");
          // pluginEcho.getMessage();
          pluginEcho.runJavaScript();
        }

        document.addEventListener('deviceready', runEcho, false)
        ... 생략 ...
```

PhoneGap CLI로 build하고 install을 해보자.

```
phonegap local build ios
```

```
phonegap local install ios
```

![ios simulator {max-width:320px;}](http://asset.hibrainapps.net/saltfactory/images/ef40f399-3b5d-4de2-b2fb-bb9cf981affa)

위와 같이 iOS 네이티브 코드에서 JavaScript의 `print_message()` 함수를 호출한 것을 확인할 수 있다.

### [self.commandDelegate evalJs:] 로 네이티브에서 JavaScript 함수 호출하기

젠 PhoneGap에서 지원하는 `self.commandDelegate`의 **evalJs**를 이용해서 네이티브코드에서 JavaScript를 실행해보자.
`SFPluginEcho.m`을 열어서 다음과 같이 코드를 수정하자. 방법은 간단하다. `[self.webView stringByEvaluatingJavaScriptFromString:]`을 `[self.commandDelegate evalJs:]`로 변경만 하면 된다. 위의 예제는 동기 방식이고 아래는 `[self.commandDelegate runInBackground:]` 안에서 비동기 방식으로 실행하게 한것 외에는 동일하다.

```objective-c
//
//  SFPluginEcho.m
//  SF-PhoneGap-Plugin-Demo
//
//  Created by SungKwang Song on 3/12/14.
//
//

#import "SFPluginEcho.h"

@implementation SFPluginEcho

- (void)echo:(CDVInvokedUrlCommand *)command
{
    NSString* message = [command.arguments objectAtIndex:0];
    [[[UIAlertView alloc] initWithTitle:@"iOS 알림" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

- (void)getMessage:(CDVInvokedUrlCommand *)command
{

    [self.commandDelegate runInBackground:^{

        NSDictionary *jsonInfo = @{@"name": @"iOS에서 만든 메세지"};

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}

- (void)runJavasScriptFuncion:(CDVInvokedUrlCommand *)command
{
//    NSDictionary *jsonInfo = @{@"name": @"iOS에서 자바스크립트 print_message 실행"};
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:&error];
//
//    CDVPluginResult *pluginResult = nil;
//
//    if (!error) {
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSString *javaScriptString = [NSString stringWithFormat:@"print_message(%@)", jsonString];
//        [self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
//
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
//    }
//
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    [self.commandDelegate runInBackground:^{
        NSDictionary *jsonInfo = @{@"name": @"iOS에서 자바스크립트 print_message 실행"};

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:&error];

        CDVPluginResult *pluginResult = nil;

        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *javaScriptString = [NSString stringWithFormat:@"print_message(%@)", jsonString];

//            [self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
            [self.commandDelegate evalJs:javaScriptString];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
@end
```

수정이 모두 마치면 다시 PhoneGap CLI로 build하고 install 한다.

```
phonegap local build ios
```

```
phonegap local install ios
```

실행 결과는 위와 동일하다는 것을 확인할 수 있다.

## 다른 PhoneGap 프로젝트에서 사용할 수 있는 Plugins 설명 만들기

이젠 이렇게 만든 플러그인에 다른 PhoneGap 프로젝트에 플러그인으로 설치를 해보자. Plugins을 만들기 위해서는 Plugins을 설명하는 파일이 필요한데 다음과 같다.

1. **pacakge.json** : Plugins을 설명하는 메타 파일이다.
2. **plugin.xml** : PhoneGap 프로젝트에 Plugins 자원을 로드하기 위한 feature와 path를 설명하는 파일이다.
3. **export module** : 마지막으로 PhoneGap 프로젝트에서 자동적으로 로드된 Plugins을 사용할 수 있도록 우리가 만든 js를 export하는 일이 필요하다.

### package.json 생성

Plugins 에 관한 메타 정보를 입력하기 위해서 SF-PhoneGap-Plugin-Demo 프로젝트 디렉토리에 package.json을 다음 내용으로 생성한다.

```
{
    "version": "0.0.1",
    "name": "net.saltfactory.tutorial.phonegap.plugindemo",
    "cordova_name": "SFPluginEcho",
    "description": "saltfactory's Echo Plugin"
}
```

### plugin.xml 생성

Plugins의 자원을 상세 설명하고 JavaScript 모듈과 연결시키는 역활을 하는 `plugin.xml`은 다음과 같이 설정하여 프로젝트 디렉토리에 생성한다. 여기서 중요한 것은 `js-module`의 `clobbers`인데 나중에 Plugins을 설치하고 PhoneGap 프로젝트에서 우리가 만든 모듈을 사용할 때 `sf_phonegap_plugin_demo_echo`라는 이름으로 사용하게 된다.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<plugin xmlns="http://apache.org/cordova/ns/plugins/1.0"
    xmlns:rim="http://www.blackberry.com/ns/widgets"
    xmlns:android="http://schemas.android.com/apk/res/android"
    id="net.saltfactory.tutorial.phonegap.plugindemo"
    version="0.0.1">
    <name>SFPluginEcho</name>
    <description>saltfactory's Echo Plugin Demo</description>

    <js-module src="www/js/sf_phonegap_plugin_demo_echo.js" name="sf_phonegap_plugin_demo_echo">
        <clobbers target="sf_phonegap_plugin_demo_echo" />
    </js-module>


    <!-- ios -->
    <platform name="ios">
        <config-file target="config.xml" parent="/*">
            <feature name="SFPluginEcho">
                <param name="ios-package" value="SFPluginEcho"/>
            </feature>
        </config-file>

        <header-file src="platforms/ios/SF-PhoneGap-Plugin-Demo/Plugins/SFPluginEcho.h" />
        <source-file src="platforms/ios/SF-PhoneGap-Plugin-Demo/Plugins/SFPluginEcho.m" />
    </platform>


</plugin>
```

### JavaScript 모듈 export

마지막으로 PhoneGap 프로젝트에서 Plugins 을 자동으로 등록하고 사용할 수 있게 JavaScript 모듈을 export한다. 우리는 `sf_plugin_demo_echo.js`라는 파일에 `SFPluginEcho` 를 만들었는데 이것을 export 한다. 다음과 같이 `sf_plugin_demo_echo.js`에 코드를 추가한다.

```javascript
//
//  sf_phonegap_plugin_echo.js
//
//  Created by SungKwang Song on 3/12/14.
//
//


function SFPluginEcho() {}
SFPluginEcho.prototype.echo = function(message) {

  cordova.exec(null, null, "SFPluginEcho", "echo", [message]);
};


SFPluginEcho.prototype.getMessage = function(){
  var callbackSuccess = function(result){
    alert(result.name);
  };

  var callbackFail = function(error){
    alert(error);
  };

  cordova.exec(callbackSuccess, callbackFail, "SFPluginEcho", "getMessage", []);

}

SFPluginEcho.prototype.runJavaScript = function(){
  var callbackFail = function(error){
    alert(error);
  };

  cordova.exec(null, callbackFail, "SFPluginEcho", "runJavasScriptFuncion", []);

}

function print_message(result){
  alert(result.name);
}

module.exports = new SFPluginEcho();
```

이제 다른 PhoneGap 프로젝트에서 우리가 만든 Plugins을 사용할 준비를 모두 마쳤다. 이제 다른 PhoneGap 프로젝트에서 우리가 만든 Plugins을 설치해보자.

## PhoneGap 프로젝트에 생성한 Plugins을 설치하기

우리는 앞에서 **SF-PhoneGap-Demo** 프로젝트를 생성해보았다. 그 프로젝트 디렉토리에 들어가서 우리가 PhoneGap CLI로 Plugins를 설치하는 명령어에 생성한 SF-PhoneGap-Plugin-Demo를 설치하면 된다.

```
cd ../SF-PhoneGap-Demo
```

먼저 Plugins의 목록을 살펴보자. 현재는 아무런 Plugins 가 설치 되어 있지 않다.

```
phonegap plugin list
```

![plugins list {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/785d44cb-3b98-463f-aedb-942f1a97334b)

이제 우리가 만든 Plugins을 설치 해보자.

```
phonegap local plugin add ../sf-phonegap-plugin-demo
```

![add plugin {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/9c10fcdb-810c-4af7-ab82-01b321e5540b)

Plugins 설치가 마치면 다시 PhoneGap 프로젝트의 Plugins의 목록을 살펴보자.

```
phonegap plugin list
```

![plugins list {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/12b2a30c-08c5-4490-a2a5-71025af7cad7)

아무런 Plugins가 없었는데 설치후 우리가 생성한 **net.saltfactory.tutorial.phonegap.plugindemo** Plugins이 설치된 것을 확인할 수 있다.
`./plugins` 디렉토리 안을 살펴보자.

```
ls -l ./plugins
```

![plugins list {max-width:600px;}](http://asset.hibrainapps.net/saltfactory/images/607f860f-a319-491c-ade0-bec8eff01a9c)

PhoneGap 프로젝트의 `./plugins` 디렉토리 안에는 우리가 Plugins으로 생성한 **net.saltfactory.tutorial.phonegap.plugindemo**가 설치된 것을 확인할 수 있다. 그리고 `ios.json` 파일을 열어보자. 아래와 같이 `config.xml`에 자동적으로 feature를 추가하는 정보가 들어가 있다.

```
{
    "prepare_queue": {
        "installed": [],
        "uninstalled": []
    },
    "config_munge": {
        "config.xml": {
            "/*": {
                "<feature name=\"SFPluginEcho\"><param name=\"ios-package\" value=\"SFPluginEcho\" /></feature>": 1
            }
        }
    },
    "installed_plugins": {
        "net.saltfactory.tutorial.phonegap.plugindemo": {
            "PACKAGE_NAME": "net.saltfactory.tutorial.phonegapdemo"
        }
    },
    "dependent_plugins": {}
}
```

PhoneGap 프로젝트에서 Plugins으로 추가한 JavaScript 모듈은  `./platforms/ios/www/cordova_plugins.js` 에 설정이되어서 나중에 자동적으로 로드가 진행된다. 이 파일을 열어보자. 이 파일은 우리가 `plugin.xml`을 만든 내용을 바탕으로 만들어진다.

```javascript
cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/net.saltfactory.tutorial.phonegap.plugindemo/www/js/sf_phonegap_plugin_demo_echo.js",
        "id": "net.saltfactory.tutorial.phonegap.plugindemo.sf_phonegap_plugin_demo_echo",
        "clobbers": [
            "sf_phonegap_plugin_demo_echo"
        ]
    }
];
module.exports.metadata =
// TOP OF METADATA
{
    "net.saltfactory.tutorial.phonegap.plugindemo": "0.0.1"
}
// BOTTOM OF METADATA
});
```

이젠 PhoneGap 프로젝트에서 우리가 만든 Plugins을 사용해보자. `index.html`을 열어서 다음과 같이 수정한다. 우리는 `plugin.xm`에 `SFPluginEcho` 모듈을 `sf_phonegap_plugin_demo_echo`라고 사용할 것을 지정했다. 그래서 PhoneGap 프로젝트에서는 Plugins의 모듈을 로드한 뒤에는 앞으로 `sf_phonegap_plugin_demo_echo`라는 이름으로 사용해야한다. 그리고 우리가 Plugin을 만들 때 `runJavaScript()`는 네이티브코드에서 `print_message()`라는 JavaScript 함수를 호출하게 만들었기 때문에 `print_message()` 함수를 만들어줬다.

```html
<!DOCTYPE html>
<!--
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
-->
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="format-detection" content="telephone=no" />
        <!-- WARNING: for iOS 7, remove the width=device-width and height=device-height attributes. See https://issues.apache.org/jira/browse/CB-4323 -->
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
        <link rel="stylesheet" type="text/css" href="css/index.css" />
        <title>Hello World</title>
    </head>
    <body>
        <div class="app">
            <h1>PhoneGap</h1>
            <div id="deviceready" class="blink">
                <p class="event listening">Connecting to Device</p>
                <p class="event received">Device is Ready</p>
            </div>
        </div>
        <script type="text/javascript" src="phonegap.js"></script>
        <script type="text/javascript">

        function print_message(result){
          alert(result.name);
        }

        function runEcho() {
          sf_phonegap_plugin_demo_echo.runJavaScript();
        }

        document.addEventListener('deviceready', runEcho, false);

        </script>

    </body>
</html>
```

이제 PhoneGap 프로젝트에서 우리가 만든 Plugins을 사용하는 모든 과정이 끝났다. 빌드하고 설치해보자.

```
phonegap local build ios
```

```
phonegap local install ios
```

![ios simulator {max-width:320px;}](http://asset.hibrainapps.net/saltfactory/images/376a555b-fad0-4e5a-a385-9e4a60f0c0d4)

실행 결과 정상적으로 우리가 만든 Plugins을 새로운 PhoneGap 프로젝트에 설치해서 적용하는 것을 확인했다.

## 결론

**PhoneGap**은 하이브리드 앱을 개발하는 플랫폼이고 PhoneGap에 여러가지 네이티브 자원을 웹에서 사요할 수 있는 Plugins을 제공하고 있다. 즉, 하이브리드 앱을 개발할기 위해서는 PhoneGap Plugins을 개발하는 방법을 반드시 알아야 한다. 웹과 네이티브 코드를 서로 연결하는 방법은 JavaScript에서 PhoneGap이 제공하고 있는 `cordova.exec()`를 실행해서 네이티브의 클래스 이릅과 메소드 이름을 호출할 수 있으며, 네이티브 코드에서는 JavaScript를 ios에서 제공하는 `[self.webView stringByEvaluatingJavaScriptFromString:]`를 이용해서 호출하거나 PhoneGap에서 제공하는 `[self.commandDelegate evalJs:]`를 이용해서 호출할 수 있다. 개발자가 직접 네이티브 코드를 작성해서 Plugin으로 설치할 수 있는데 이때 Plugins을 정의하는 `pacakge.json`, `plugin.xml`을 지정해줘야하고 PhoneGap 프로젝트에서 `js-module`을 사용할 수 있도록 우리가 만든 JavaScript 인터페이스를 module.exports를 해줘야 한다는 것을 확인했다. 이렇게 PhoneGap 프로젝트에서 하이브리드하게 JavaScript에서 네이티브코드를 접근하고, 네이티브코드에서 JavaScript를 접근하는 것을 PhoneGap을 통해서 처리할 수 있는 것을 확인했다. 앞으로 PhoneGap으로 하이브리드 앱을 개발하기 위해서는 Plugins을 개발해서 사용해야하는 것을 이해했고 PhoneGap 에서 제공하지 않는 다양한 네이티브코드와 자원을 사용할 수 있을 것으로 기대된다.

## 참고

1. http://docs.phonegap.com/en/3.3.0/guide_hybrid_plugins_index.md.html
2. http://docs.phonegap.com/en/3.3.0/guide_platforms_ios_plugin.md.html#iOS%20Plugins


