---
layout: post
title: PhoneGap(Cordova) 앱 푸시 (Push Notification) 알람서비스 APN, GCM 구현
category: hybridapp
tags: [phonegap, cordova, push, apn, gcm]
comments: true
redirect_from: /245/
disqus_identifier : http://blog.saltfactory.net/245
---

## 서론

![phonegap](http://blog.hibrainapps.net/saltfactory/images/3b3f1517-58ab-482d-8115-4f6ae2b94e7b)

하이브리드 앱 개발은 웹 리소스와 네이티브 리소스를 함께 사용하는 개발 방법이다. 하이브리드 앱은 보통 UI를 웹 리소스로 만들기 때문에 디바이스가 가지는 특정한 기능을 핸들링하지 못한다. PhoneGap(Cordova)는 plugin을 사용해서 웹 리소스와 네이티브 리소스간 서로 통신하여 사용할 수 있도록 설계되어 있고 이 plugin을 사용해서 디바이스가 가지는 특정하는 기능을 웹 리소스에서 핸들링할 수 있다. 이번 포스팅에서는 모바일 앱 개발을 할 때 복잡하고 어렵지만 반드시 필요한 기능중에 하나인 알림 서비스를 PhoneGap(Cordova)에서 어떻게 구현할 수 있는지를 소개한다.
<!--more-->

## PhoneGap(Cordova) 프로젝트 생성하기

우선 알림(푸시)서비스를 테스트하기 위해서 PhoneGap이나 Cordova 프로젝트를 생성한다. PhoneGap이나 Cordova는 동일한 plugin을 함께 사용할 수 있기 때문에 어떤 프로젝트로 만들어도 상관없다. PhoneGap 프로젝트를 만드는 것은 이 글을 참조하면 된다. (http://blog.saltfactory.net/228)

```
phonegap create sf-phonegap-demo -n SF-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

## PushPlugin 플러그인 사용하기

PhoneGap(Cordova)에는 공식적으로 지원하는 plugin 들이 있고 이것들은 cordova 리파지토리에서 `phonegap plugin add` 명령으로 바로 다운받아서 PhoneGap 프로젝트에서 설치해서 사용할 수 있다. 예를 들어, ***org.apache.cordova.device*** 플러그인을 설치하기 위해서는 다음과 같이 하면 된다.
```
phonegap local plugin add org.apache.cordova.device
```
하지만 third party 플러그인이나 cordova 리파지토리에 저장되지 않은 플러그인은 URI(플러그인 위치)를 지정하여 설치할 수 있다. PhoneGap 플러그인 설치는 다음 글을 참조하면 된다. (http://blog.saltfactory.net/233). 직접 plugin을 개발하여 프로젝트에 설치할 때는 다음 글을 참조하면 된다. (http://blog.saltfactory.net/235, http://blog.saltfactory.net/236)

PhoneGap은 하이브리드 앱 개발 플랫폼이고 웹 리소스와 네이티브 리소스간 서로 통신을 하기 위해서 plugin을 만들어서 사용하는데, 알림(푸시)에 관한 plugin은 [PushPlugin](https://github.com/phonegap-build/PushPlugin)으로 제공하고 있다. 이 플러그인은 Android, iOS, WP8, Amazon Fire OS 의 알림을 모두 지원한다. 우리는 그 중에서 iOS와 Android에서 사용하는 방법을 살펴볼 것이다. 우선 ***com.phonegap.plugins.PushPlugin***을 설치하자. PhoneGap 프로젝트를 설치한 디렉토리 안에서 다음 명령어를 실행하자.

```
phonegap local plugin add https://github.com/phonegap-build/PushPlugin.git
```
![install push plugin](http://blog.hibrainapps.net/saltfactory/images/17d00d6b-8f3d-4c79-9878-21027440a16c)
위 명령어를 실행하고 난 다음에 plugins 디렉토리에 ***com.phonegap.plugins.PushPlugin***이 설치 되는 것을 확인할 수 있을 것이다.

![pluugins list](http://blog.hibrainapps.net/saltfactory/images/63ae5d57-9923-4e99-9017-57d89825ed36)

## PhoneGap iOS 플랫폼 PushPlugin 사용하기

다음은 iOS 플랫폼을 추가해보자. cordova를 이용하면 다음과 같이 추가할 수 있다.
```
cordova platform add ios
```
phonegap을 이용하면 다음과 같이 추가할 수 있다.
```
phonegap build ios
```
![create ios platform](http://blog.hibrainapps.net/saltfactory/images/6b6341d5-a534-44c2-9705-74bb8ac16419)
PhoneGap 프로젝트에 iOS 플랫폼이 추가되면 위와 같이 ***platforms/*** 디렉토리 밑에 ***ios/*** 디렉토리가 만들어지고 Xcode 프로젝트가 생성되는 것을 확인할 수 있다. Xcode 프로젝트를 열어보자 그리고 애플 개발자 사이트에서 프로비저닝 파일을 만들고 Xcode 프로젝트의 Code Sign을 변경해준다. 자세한 설명은 다음 글을 참조하자. (http://blog.saltfactory.net/215)

PushPlugin을 사용하기 위해서는 ***config.xml***에 `feature`를 추가해야한다. 다음과 같이 config.xml을 수정하자.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="net.saltfactory.tutorial.phonegapdemo" version="1.0.0" xmlns="http://www.w3.org/ns/widgets" xmlns:gap="http://phonegap.com/ns/1.0">
    <name>SF-PhoneGap-Demo</name>
    <description>
        Hello World sample application that responds to the deviceready event.
    </description>
    <author email="saltfactory@gmail.com" href="http://blog.saltfactory.net">
        SungKwang Song
    </author>
... (생략) ...

    <access origin="*" />

    <feature name="PushPlugin">
      <param name="ios-package" value="PushPlugin"/>
    </feature>

</widget>
```

변경된 사항을 플랫폼 프로젝트에 반영되게 `cordova prepare`를 사용하여 업데이트한다.

```
cordova prepare
```

다음은 index.html 에 JavaScript 코드를 다음과 같이 추가하자.

```html
<!DOCTYPE html>
<!--
    Copyright (c) 2012-2014 Adobe Systems Incorporated. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
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
        <!--<script type="text/javascript" src="js/index.js"></script>-->
        <script type="text/javascript">
            // app.initialize();

            /**
             * tokenHandler
             *
             * @param result
             *
             * 디바이스 토큰핸들러 콜백함수.
             * 푸시 서비스를 활성화 하였을 때, window.plugins.pushNotification.register 메소드가 실행되면서 디바이스 토큰을 가져와서 출력한다.
             * 만약에 푸시 서버로 디바이스 토큰을 보내야할 경우 이 함수 안에서 서버로 디바이스 토큰을 전송하면 된다.
             */
            function tokenHandler(result){
              console.log('deviceToken:' + result);
            }

            /**
             * errorHandler
             *
             * @param err
             *
             * 에러 핸들러 콜백 함수.
             */
            function errorHandler(err){
              console.log('error:' + err);
            }


            /**
             * successHandler
             *
             * @param result
             *
             * 디바이스로 푸시 메세지를 받았을 때 뱃지처리 이후 호출하는 콜백함수
             */
            function successHandler(result){
              console.log('result:'+result);
            }

            /**
             * onNotificationAPN
             *
             * @param event
             *
             * 디바이스로 푸시 메세지를 받을 때 호출되는 콜백함수 window.plugins.pushNotification.register 옵션 설정에서 ecb의 이름에 매칭된다.
             */
            function onNotificationAPN (event){
              // 푸시 메세지에 alert 값이 있을 경우
              if (event.alert){
                navigator.notification.alert(event.alert);
              }

              // 푸시 메세지에 sound 값이 있을 경우
              if (event.sound){
                var snd = new Media(event.sound);
                snd.play();
              }

              // 푸시 메세지에 bage 값이 있을 경우
              if (event.badge){
                window.plugins.pushNotification.setApplicationIconBadgeNumber(successHandler, errorHandler, event.badge);
              }
            }

            // 디바이스가 ready가 될때 실행될 수 있도록 이벤트 리스너에 등록한다.
            document.addEventListener("deviceready", function(){

              // PushPlugin을 설치했다면 window.plugins.pushNotification.register를 이용해서 iOS 푸시 서비스를 등록한다.
              window.plugins.pushNotification.register(tokenHandler, errorHandler, {
                "badge":"true", // 뱃지 기능을 사용한다.
                "sound":"true", // 사운드를 사용한다.
                "alert":"true", // alert를 사용한다.
                "ecb": "onNotificationAPN" // 디바이스로 푸시가 오면 onNotificationAPN 함수를 실행할 수 있도록 ecb(event callback)에 등록한다.
              });
            });

        </script>
    </body>
</html>
```

index.html을 수정하고 플랫폼에 적용하기 위해서는 `corodva prepare` 나 `phonegap build`를 사용해서 웹 리소스를 플랫폼 프로젝트에 반영한다.

```
phonegap build ios
```

이제 아이폰 디바이스를 USB로 연결하고 phonegap run을 실행시켜서 아이폰에 앱을 실행시켜보자. 푸시서비스는 디바이스 토큰을 획득해야하기 때문에 simulator에서는 테스트할 수 없다. 반드시 디바이스를 연결해서 실행시켜야한다.
```
phonegap run ios
```

만약 console.log를 확인하고 싶을 때, phonegap run을 실행시키면 console.log를 터미널에서 확인할 수 없다. 이럴 경우는 PhoneGap 프로젝트 안에 있는 platforms/ios 안에 있는 Xcode 프로젝트를 열어서 Xcode에서 빌드하고 실행하면 된다. 그리고 console.log를 Xcode의 로그 화면에서 출력하기 위해서는 웹 리소스의 console.log를 터미널로 로깅하기 위해서 wrapping한 ***org.apache.cordova.console*** 플러그인을 설치해야한다.
```
phonegap local plugin add org.apache.cordova.console
```

이제 Xcode 에서 아이폰 디바이스를 빌드하고 실행시켜보자. 최초 앱이 실행하면 앱에서 푸시서비스를 허용 할 것인지 물어보게 되는데 푸시서비스를 허용하도록 OK를 선택한다. 만약 빌드하는데 aps_entitlement 에러가 만나게 되면 code sign이 제대로 매칭되지 않았기 때문이기 때문에 provisioning 파일을 잘 생성해서 적용하고 있는지 확인할 필요가 있다.
![아이폰 푸시허용 {width:320px}](http://blog.hibrainapps.net/saltfactory/images/6652e278-37f8-43ae-9dea-2166994360ea)

푸시 서비스를 허용하고 난 다음에는 우리가 index.html에 작성한 readydevice 이벤트 리스너가 동작하게 된다. 우리는 여기서 ***window.plugins.pushnotification.register***를 실행하게 만들었고 이 메소드가 동작하면 디바이스 토큰을 획득해서 console.log를 출력하게 하였다. Xcode에서 실행한 결과는 다음 그림과 같다. 아래 그림을 확대해서 보면 deviceToken에 아이폰 디바이스 토큰 값이 출력되는 것을 확인할 수 있다. 푸시서버에서 아이폰으로 푸시 메세지를 보내기 위해서는 이 디바이스 토큰 값을 푸시 서버로 전송해야한다.
![디바이스토큰 획득](http://blog.hibrainapps.net/saltfactory/images/36174aa8-562f-4a35-b723-e7e6c6bd29dd)

푸시서버로 디바이스토큰을 저장했다고 가정하고 푸시 서비스에서 푸시 메세지를 보내는 코드를 작성해보자. Node.js로 푸시 서비스를 구현하는 방법은 다음 글에 자세하게 설명하고 있다. (http://blog.saltfactory.net/215)
간단하게 다시 설명하면 Node.js로 푸시 서비스를 구현하기 위해서는 ***node-apn*** 모듈을 사용하면 애플 푸시 프로바이더를 쉽게 구현할 수 있다. 먼저 node-apn 모듈을 npm으로 설치하자.
```
npm install apn
```
그리고 apn에서 푸시 프로바이더로 애플 푸시 서버로 푸시 메세지를 전송하기 위해서 필요한 aps_development.cer 파일과 Certifiacates.p12 파일을 만든다. 이 파일을 만드는 방법은 (http://blog.saltfactory.net/215) 글을 참조하기 바란다.
두 파일을 apn 모듈에서 사용하기 위해서는 .pem 파일로 변경해야하는데 다음과 같이 openssl 명령어로 만들 수 있다. 이 방법 또한 위에서 링크한 글을 참조하면 된다.

```
openssl x509 -in aps_development.cer -inform DER -outform PEM -out aps_development.pem
```
```
openssl pkcs12 -in Certificates.p12 -out Certificates-dev.pem -nodes
```

인증 파일도 모두 준비가 되었고 이제 푸시를 보내는 코드를 다음과 같이 만든다.

```javascript
/**
 * Created by saltfactory on 6/20/14.
 * filename : ios_pushprovider.js
 */
var apn = require('apn');

process.env['DEBUG'] = 'apn';

var options = {
  production: false,
  gateway: 'gateway.sandbox.push.apple.com',
  cert: '../keys/phonegapdemo/aps_development.pem', // aps_development.cert 파일을 .pem 파일로 변경한 경로
  key: '../keys/phonegapdemo/Certificates-dev.pem', // Certificates.p12 파일을 .pem 파일로 변경한 경로
  passphrase: "secret"
};


var apnConnection = new apn.Connection(options);


var deviceToken = "21a1efbdc6ccf6d6e1...02e1300c9"; // 디바이스토큰 문자열
var myDevice = new apn.Device(deviceToken);

var note = new apn.Notification();

note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
note.badge = 3;
//note.sound = "ping.aiff";
note.alert = "PhoneGap 푸시 테스트";
//note.payload = {'messageFrom': 'Caroline'};

apnConnection.pushNotification(note, myDevice);
```

Node.js로 만든 간단한 ios push provider 코드이다. 이 코드를 실행시켜보자. 잠시 후 다음 그림과 같이 아이폰으로 푸시 메세지가 전송된 것을 확인할 수 있다.
![아이폰 백그라운드 푸시 {width:320px}](http://blog.hibrainapps.net/saltfactory/images/16b8e50a-5f37-4d6f-a79b-f6adbe2929b2)

![아이폰 슬립모드 푸시 {width:320px}](http://blog.hibrainapps.net/saltfactory/images/029f7f2b-1ca6-41e6-9ff0-935f369b3aba)

![아이폰 노티피케이션 센터 {width:320px}](http://blog.hibrainapps.net/saltfactory/images/2e2620f6-bdc8-429a-be26-0173ecd4bb69)


푸시 프로바이더에서 badge 값을 3으로 지정하여 푸시 메세지를 보냈다. 우리는 PhoneGap 프로젝트에서 PushPlugin을 설정하면서 onNotificationAPN에 뱃지값을 어플리케이션에 반영할 수 있도록 코드를 작성하였기 때문에 뱃지가 앱에 표현되는 것을 확인할 수 있다. 위 결과는 앱이 백그라운드로 실행되고 있을 때나 앱이 실행되지 않았을 때 푸시 메세지가 왔을 때의 결과이다. 만약 앱이 실행되고 있을 때 푸시 메세지가 오면 onNotificationAPN에서 지정한 callback을 화면에서 실행할 것이다. index.html 코드에서 앱이 실행되고 있을 때 푸시 메세지에서 alert 값이 있을 경우에 ***navigator.notification.alert***를 실행하라고 했는데 이것은 PhoneGap의 ***org.apache.cordova.dialogs*** 플러그인을 설치하고 alert dialog를 보이게 하는 메소드를 호출하는 것이다. PhoneGap 프로젝트에 ***org.apache.cordova.dialogs*** 플러그인을 설치하자.

```
phonegap local plugin add org.apache.cordova.dialogs
```
그리고 PhoneGap 프로젝트에 플러그인 리소스들이 적용될 수 있게 다시 `cordova prepare` 나 `phonegap build`를 다시 실행한다.
```
phonegap build ios
```
다시 디바이스에 앱을 빌드해서 실행시켜보자. 앱이 백그라운드가 아니라 실행되고 있을 때 우리가 작성한 푸시 프로바이더에서 다시 푸시 메세지를 보내어보자. 그러면 다음 그림과 같이 앱이 실행되고 있을 때, 푸시 메세지가 왔을 경우 alert dialog가 보여지는 것을 확인할 수 있다.
![안드로이드 푸시 알림 {width:320px}](http://blog.hibrainapps.net/saltfactory/images/526650d4-535f-42b7-9023-f68af586ce31)

## PhoneGap android PushPlugin 사용하기

위에서 iOS 플랫폼에서 PushPlugin을 사용해서 푸시 서비스를 구현하는 방법을 살펴봤는데 이번에는 android 플랫폼에서 PushPlugin을 사용해서 푸시 서비스를 구현하는 방법을 살펴보자.

애플에서 푸시를 위해서 provisioning 파일을 생성한것 같이 구글의 GCM을 이용해서 알림 서비스를 구현하기 위해서는 Google Console에서 구글 GCM 서비스를 하기 위한 프로젝트를 생성해야한다. 자세한 방법은 다음 글을 참조한다. (http://blog.saltfactory.net/216)

먼저 PhoneGap 프로젝트에서 안드로이드 플랫폼을 추가한다.
```
phonegap build android
```

만약 cordova 프로젝트라면 다음과 같이 안드로이드 플랫폼을 추가한다.
```
cordova platform add android
```
가장 먼저 해야할 것은 iOS에서 설정과 동일하게 config.xml에 다음과 같이 feature를 추가한다.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="net.saltfactory.tutorial.phonegapdemo" version="1.0.0" xmlns="http://www.w3.org/ns/widgets" xmlns:gap="http://phonegap.com/ns/1.0">
    <name>SF-PhoneGap-Demo</name>
    <description>
        Hello World sample application that responds to the deviceready event.
    </description>
    <author email="saltfactory@gmail.com" href="http://blog.saltfactory.net">
        SungKwang Song
    </author>

... (생략) ...
    <access origin="*" />

    <feature name="PushPlugin">
      <param name="ios-package" value="PushPlugin"/>
      <param name="android-package" value="com.plugin.gcm.PushPlugin"/>
    </feature>
</widget>
```

하이브리드 앱은 하나의 웹 자원으로 여러가지 플랫폼에 사용을 한다. 그래서 index.html에 작성한 JavaScript 코드에 다음을 추가한다.

```html
<!DOCTYPE html>
<!--
    Copyright (c) 2012-2014 Adobe Systems Incorporated. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
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
        <!--<script type="text/javascript" src="js/index.js"></script>-->
        <script type="text/javascript">
            // app.initialize();

            /**
             * tokenHandler
             *
             * @param result
             *
             * 디바이스 토큰핸들러 콜백함수.
             * 푸시 서비스를 활성화 하였을 때, window.plugins.pushNotification.register 메소드가 실행되면서 디바이스 토큰을 가져와서 출력한다.
             * 만약에 푸시 서버로 디바이스 토큰을 보내야할 경우 이 함수 안에서 서버로 디바이스 토큰을 전송하면 된다.
             */
            function tokenHandler(result){
              console.log('deviceToken:' + result);
            }

            /**
             * errorHandler
             *
             * @param err
             *
             * 에러 핸들러 콜백 함수.
             */
            function errorHandler(err){
              console.log('error:' + err);
            }

            /**
             * successHandler
             *
             * @param result
             *
             * 디바이스로 푸시 메세지를 받았을 때 뱃지처리 이후 호출하는 콜백함수
             */
            function successHandler(result){
              console.log('result:'+result);
            }

            /**
             * onNotificationAPN
             *
             * @param event
             *
             * iOS 디바이스로 푸시 메세지를 받을 때 호출되는 콜백함수, window.plugins.pushNotification.register 옵션 설정에서 ecb의 이름에 매칭된다.
             */
            function onNotificationAPN (event){
              // 푸시 메세지에 alert 값이 있을 경우
              if (event.alert){
                navigator.notification.alert(event.alert);
              }

              // 푸시 메세지에 sound 값이 있을 경우
              if (event.sound){
                var snd = new Media(event.sound);
                snd.play();
              }

              // 푸시 메세지에 bage 값이 있을 경우
              if (event.badge){
                window.plugins.pushNotification.setApplicationIconBadgeNumber(successHandler, errorHandler, event.badge);
              }
            }

            /**
             * onNotificationGCM
             *
             * @param e
             *
             * 안드로이드 디바이스로 푸시 메세지를 받을 때 호출되는 함수, window.plugins.pushNotification.register 옵션에 설정에서 ecb의 이름에 매칭된다.
             */
            function onNotificationGCM (e){
              switch (e.event) {
              case 'registered': // 안드로이드 디바이스의 registerID를 획득하는 event 중 registerd 일 경우 호출된다.
                console.log('registerID:' + e.regid);
                break;
              case 'message': // 안드로이드 디바이스에 푸시 메세지가 오면 호출된다.
                {
                  if (e.foreground){ // 푸시 메세지가 왔을 때 앱이 실행되고 있을 경우
                    var soundfile = e.soundname || e.payload.sound;
                    var my_media = new Media("/android_asset/www/" + soundfile);
                    my_media.play();
                  } else { // 푸시 메세지가 왔을 때 앱이 백그라운드로 실행되거나 실행되지 않을 경우
                    if (e.coldstart) { // 푸시 메세지가 왔을 때 푸시를 선택하여 앱이 열렸을 경우
                      console.log("알림 왔을 때 앱이 열리고 난 다음에 실행 될때");
                    } else { // 푸시 메세지가 왔을 때 앱이 백그라운드로 사용되고 있을 경우
                      console.log("앱이 백그라운드로 실행될 때");
                    }
                  }

                  console.log(e.payload.title);

                  navigator.notification.alert(e.payload.title);
                }
                break;
              case 'error': // 푸시 메세지 처리에 에러가 발생하면 호출한다.
                console.log('error:' + e.msg);
                break;
              case 'default':
                console.log('알수 없는 이벤트');
                break;
              }
            }

            // 디바이스가 ready가 될때 실행될 수 있도록 이벤트 리스너에 등록한다.
            document.addEventListener("deviceready", function(){
              console.log(device.platform);

              if(device.platform.toUpperCase() == 'ANDROID'){
                window.plugins.pushNotification.register(successHandler,errorHandler, {
                  "senderID" : "45219...", // Google GCM 서비스에서 생성한 Project Number를 입력한다.
                  "ecb" : "onNotificationGCM" // 디바이스로 푸시가 오면 onNotificationGCM 함수를 실행할 수 있도록 ecb(event callback)에 등록한다.
                });
              } else {
                // PushPlugin을 설치했다면 window.plugins.pushNotification.register를 이용해서 iOS 푸시 서비스를 등록한다.
                window.plugins.pushNotification.register(tokenHandler, errorHandler, {
                  "badge":"true", // 뱃지 기능을 사용한다.
                  "sound":"true", // 사운드를 사용한다.
                  "alert":"true", // alert를 사용한다.
                  "ecb": "onNotificationAPN" // 디바이스로 푸시가 오면 onNotificationAPN 함수를 실행할 수 있도록 ecb(event callback)에 등록한다.
                });
              }

            });

        </script>
    </body>
</html>
```
PhoneGap  프로젝트에서 디바이스의 플랫폼을 알기 위해서는 org.apache.cordova.device 플러그인이 필요하다. 이 플러그인을 설치하자.
```
phonegap local plugin add org.apache.cordova.device
```
그리고 Media를 사용하기 위해서는 org.apache.cordova.media 플러그인이 필요하다.
```
phonegap local plugin add org.apache.cordova.media
```

PhoneGap 프로젝트에서 android 앱에 푸시 서비스를 구현하기 위한 준비는 모두 끝났다.
모든 자원을 안드로이드 플랫폼에 적용하기 위해서 cordova prepare를 실행하던지 `phonegap build`를 실행한다.

```
phonegap build android
```
안드로이드 디바이스를 연결하고 eclipse나 IntelliJ를 이용하여 PhoneGap의 안드로이드 프로젝트를 열어서 실행해보자. 안드로이드 디바이스로 빌드하고 실행하면 우리가 앞에서 window.plugin.pushnotification.register에 안드로이드 senderID를 등록한 것을 가지고 GCM에 사용할 수 있는 디바이스의 유일한 registerID를 획득한 것을 확인할 수 있다.
![registerID](http://blog.hibrainapps.net/saltfactory/images/bb74d45e-feb6-4d17-937b-4e7356d08613)


이제 안드로이드 디바이스로 푸시를 보낼 GCM 서버를 Node.js로 만들어보자. GCM 서버에 필요한 인증절차와 구축 방법은 다음 글을 참조하면 된다.(http://blog.saltfactory.net/216). 이 포스팅에서는 간단하게 GCM 서버로 안드로이드 디바이스로 푸시를 전송하는 예제를 설명한다. GCM 서버를 구축하기 위해서는 Google Console에서 안드로이드 GCM 프로젝트를 만들고 server API key를 만들어서 사용한다. 그리고 Node.js로 GCM 서버를 만들기 위해서는 ***node-gcm*** 모듈을 사용한다. server API key 를 만드는 방법은 (http://blog.saltfactory.net/216)글을 참조한다. node-gcm 모듈을 npm으로 설치하자.

```
npm install node-gcm
```

다음은 android_gcm_provider.js 파일을 다음과 같이 만들어서 저장한다.

```javascript
/**
 * Created by saltfactory on 6/20/14.
 */
/**
 * filename : android_gcm_provider.js
 */

var gcm = require('node-gcm');

// create a message with default values
var message = new gcm.Message();

// or with object values
var message = new gcm.Message({
  collapseKey: 'PhoneGapDemo',
  delayWhileIdle: true,
  timeToLive: 3,
  data: {
    title:'PhoneGap 푸시 테스트',
    message: 'PhoneGap 푸시 메세지',
    msgcnt: 3
  }
});

var sender = new gcm.Sender('AIzaSyBH...'); // 구글 프로젝트에 등록한 GCM 서비스에서 만든 server API key를 입력한다.
var registrationIds = [];
registrationIds.push('APA91...'); // PhoneGap 프로젝트의 안드로이드 프로젝트에서 획득한 registerID를 입력한다. 이 registerID를 이용하여 안드로이드 디바이스에 푸시를 전송한다.

/**
 * Params: message-literal, registrationIds-array, No. of retries, callback-function
 **/
sender.send(message, registrationIds, 4, function (err, result) {
  console.log(result);
});
```
node-gcm 모듈로 Node.js 기반의 안드로이드 GCM 서버를 간단히 만들 수 있다. 위 코드를 실행하면 안드로이드 다음 그림과 같이 디바이스로 푸시가 전송 되는 것을 확인할 수 있다.
![안드로이드 백그라운 알림 {width:320px;}](http://blog.hibrainapps.net/saltfactory/images/1171672c-4dee-44c8-8f1e-3f1bcee12d33)
![안드로이드 대시보드 {width:320px;}](http://blog.hibrainapps.net/saltfactory/images/28ff5734-31a7-4a63-92c1-7e66f4e1a53d)
![안드로이드 알림 {width:320px;}](http://blog.hibrainapps.net/saltfactory/images/12907e9a-3176-44db-89a4-514a030984d0)

## 결론

최근 모바일 앱 개발에서 푸시(알림)서비스는 반드시 필요한 기능중에 하나이다. 고객들은 푸시 서비스를 지원하는 앱을 사용하길 원하고 있다. 하이브리드 앱은 웹 리소스와 네이티브 리소스를 함께 사용하여 단일 웹 리소스로 여러 디바이스에 동일한 기능을 구현할 수 있다. PhoneGap에서는 웹 리소스로 네이티브 기능을 제어하기 위해서 plugin을 만들어서 사용하는데 모바일의 푸시 서비스 구현하기 위해 네이티브 자원을 사용할 수 있도록 ***PushPlugin***을 만들어서 배포하고 있다. PushPlugin을 사용하면 웹 리소스를 이용하여 디바이스의 토큰 정보나 registerID를 획득할 수 있고, 푸시 메세지가 디바이스로 전송되었을 때, 웹 리소스를 이용하여 푸시 받은 정보를 디바이스에 적용할 수 있다. 만약에 PushPlugin을 사용하지 않는다면 각 플랫폼마다 웹 리소스가 네이티브 리소스를 제어하기 위해서 복잡한 코드를 어렵게 작성해야하지만 PhoneGap(Cordova)의 PushPlugin을 사용하면 간단하게 푸시 서비스를 지원하는 하이브리드 앱을 만들 수 있다.

그리고 Node.js의 ***node-apn***과 ***node-gcm*** 모듈을 사용해서 PhoneGap(Cordova)에서 획득한 디바이스 정보를 가지고 쉽게 푸시를 발송할 수 있는 프로바이더 서버를 쉽게 만들 수 있는 것도 확인했다. 이제 하이브리드 앱을 만들때 더이상 푸시서비스를 어떻게 만들어야할지 걱정할 필요가 없을 것이다. 좀 더 네이티브에 가까운 서비스를 웹 리소스로 제어할 수 있으니 UI를 담당하는 웹 리소스를 가지고 푸시 서비스를 쉽게 만들 수 있을 것이다.

