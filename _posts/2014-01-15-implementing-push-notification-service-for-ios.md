---
layout: post
title: Node.js를 이용하여 iOS 푸시서비스 구현하기
category: node
tags: [node, node.js, ios, apns, push, notification]
comments: true
redirect_from: /215/
disqus_identifier : http://blog.saltfactory.net/215
---

## 서론

이번 프로젝트에서는 Springframework고 구현되어 있는 Push Provider를 nodejs로 마이그레이션하는 작업을 진행하였다. Provider는 일단 간단하게 푸시 전송할 데이터를 사내 데이터베이스 서버에서 RESTful API로 푸시 전송할 항목을 가져와서 Provider 서버의 데이트베이스에 저장하고 순차적으로 push를 전송하는 간단한 로직을 가지고 있는데 Springframework로 구현하니 단순히 Push 서비스만하는데 너무 큰 프레임워크를 도입한 것 같아서 보다 간단한 프레임워크 선정이 필요했고, async push provider를 구현하기 위해서 nodejs를 최종으로 결정해서 구현하기로 했다. 다른 내부적인 로직은 다른 포스팅에서 소개하기로 하고, nodejs 푸시서비스 구현하기 글에서는 Node.js로 아이폰과 안드로이드 Push Provider 서버를 구현하는 글을 소개한다. 첫번째로 아이폰 푸시서버 구현하기에서는 iOS 기계에 푸시를 전송하기 위해서 Push Provider 서버를 구현하는 방법을 간단히 소개한다.

<!--more-->

### iOS 프로젝트를 생성

데모를 보여주기 위해서 SFPushDemo 라는 이름으로 프로젝트를 만들었다. 단순하게 푸시가 아이폰으로 전송되는 것만 테스트할 것이기 때문에 빈 프로젝트로 만들었다.

![](http://asset.hibrainapps.net/saltfactory/images/a8ea994f-cb31-499c-9775-e34e7c1a2a42)

![](http://asset.hibrainapps.net/saltfactory/images/317d3538-b451-4ef1-a3b3-b54023bd6667)

### Code Sign

Xcode는 버전이 올라가면서 눈에 띄는 업데이트가 많이 일어나는 것 같다. 이젠 Xcode 툴 자체에서 개발자 인증 및 프로비저닝 코드 싸인을 검사하고 keychain에 없을경우 웹에서 등록하고 추가하는 대신에 Xcode 자체에서 되도록 업데이트 된것 같다. 점점 웹 없이 Xcode 자체로 개발될 수 있는것 같은 느낌이 든다.

![](http://asset.hibrainapps.net/saltfactory/images/9bc832a1-d91d-496c-a9d7-292adf59418b)

프로젝트의 code sign이 맞지 않을 겨우 No matching code signing identify found 에러가 나타나는데 이때, Fix issue를 누른다.

![](http://asset.hibrainapps.net/saltfactory/images/87a10f24-e560-41cc-a7c7-d0c072fa464b)

개발자 등록이 되어 있으면 개발자 계정을 Xcode에 추가하면 된다. 이번 포스팅에서 이 내용을 더 깊게 다루지는 않겠다. 다만 이렇게 Xcode가 많이 발전하고 있다는 소개를 잠시 했다.

다시 본론으로 돌아와서 아이폰 앱을 개발하기 위해서는 개발 프로비저닝 파일이 필요하고, 푸시를 보내기 위해서는 푸시 Cetificates 파일이 필요하다.
애플개발자 사이트에 들어가본다.

http://developer.apple.com

#### App Identifiers 추가

iOS 앱은 유일한 Identifier를 가지고 있고 이것을 이용해서 앱을 식별할 수 있게 된다. 푸시 데모 앱을 위해서 `net.saltfactory.tutorial` 이라는 identifier를 만들었다. 여기서 identifier는 통상 도메인 이름을 거꾸로 적는다. 여러분들의 필요에 따라서 다른 이름으로 생성하면된다.

![](http://asset.hibrainapps.net/saltfactory/images/57a7bd32-a4a1-4e93-b72e-47dabad324b1)

#### Provisioning Profile 추가

이제 Xcode에서 아이폰 개발을 할 때 사용할 provisioning profile을 추가한다. 추가하고 난 뒤 Download를 눌러 프로비저닝 파일을 다운 받아서 Xcode에 드래그해서 넣어주거나, 프로비저닝 파일을 더블클릭하면 자동적으로 Xcode에 추가된다.

![](http://asset.hibrainapps.net/saltfactory/images/8083322d-3f3d-4bbe-a27e-0c7654379687)

#### iOS Certificates(Development) APNs Development iOS 추가

마지막으로 나중에 Push Provider 서버에 사용하기 위한 Certificates 파일을 추가한다. 나중에 푸시 프로바이더 서버를 구현할때 Cetificates 파일이 필요하다. 다운받아 둔다. `apn_development.cer` 이란 파일로 저장이 될 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/7dec21a9-18cb-4b56-89a2-77425a295063)

### AppDelegate.m에서 device token 획득

Xcode에서 AppDelegate.m 파일을 열어서 device token을 획득하는 코드를 추가한다.

```objective-c
//
//  SFAppDelegate.m
//  SFPushTutorial
//
//  Created by saltfactory@gmail.com on 1/14/14.
//  Copyright (c) 2014 saltfactory.net. All rights reserved.
//

#import "SFAppDelegate.h"

@implementation SFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // 푸시서비스 등록
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                                        UIRemoteNotificationTypeAlert|
                                        UIRemoteNotificationTypeBadge|
                                        UIRemoteNotificationTypeSound];

    return YES;
}

// 디바이스 토큰 획득
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken : %@", deviceToken );
}
```

이제 아이폰을 Xcode에 연결해서 빌드를 실행한다. 아이폰에서는 푸시서비스를 허용할 것인지 알람이 뜨고 확인을 하면 Xcode 콘솔에서 로그를 확인하면 디바이스 토큰 정보를 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/9db57d66-3097-423b-8b17-32a9e6b1e3f9)

이제 모바일 디바이스에서는 푸시를 받을 준비를 다 했으니, 푸시 프로바이더 서버를 만들 차례이다.

### node-apn 설치

node package는 npm을 이용해서 간단히 설치할 수 있다. 만약 맥을 사용하는데 npm이나 node 명령어가 없을 경우 homebrew를 이용해서 설치하면 간단하게 설치할 수 있다. 맥에서 Node.js는 (http://blog.saltfactory.net/197) 글을 참조해서 설치하면 된다. 푸시 프로바이더 서버는 node라는 디렉토리를 생성 후 그 밑에서 작업을 하였다.

```
npm install apn
```

![](http://asset.hibrainapps.net/saltfactory/images/cbb86502-e36b-4d84-824f-6f6d308eabd2)

### APNs Certificates 파일과 인증키 생성

우린 앞에서 APNs Development Certificates 을 하나 생성해서 다운 받은 파일이 있다. `aps_development.cer` 이란 파일이다. 이 파일을 더블 클릭하면 Mac에서 key를 관리하는 KeyChain Access 라는 프로그램에 자동으로 등록이 된다. 열어서 확인해보자.

![](http://asset.hibrainapps.net/saltfactory/images/cee43845-7493-4b43-acbe-9c2233b57897)

Apple Development iOS Push Service:net.saltfactory.tutorial 을 선택하여 오른쪽 마우스를 클릭하여 export를 한다. 그러면 Certificates.p12 파일로 저장이 될 것이다. 이름은 변경해도 무방하다.

![](http://asset.hibrainapps.net/saltfactory/images/5f4b7f7c-319b-48ce-b8f0-b3eca5904fb8)

파일을 저장할 때 인증 비밀번호를 물어보는데 비밀번호를 입력하고 기억해둔다.

![](http://asset.hibrainapps.net/saltfactory/images/10a9e198-de40-48e5-81ec-ea88c92d7cc8)

위의 두 파일을 keys라는 디렉토리를 만들고 파일을 디렉토리에 복사를 한다.

![](http://asset.hibrainapps.net/saltfactory/images/0e2f6673-7dea-40a4-b49f-23b45c9772c8)

node-apn은 pem 파일 포멧을 사용하기 때문에 다음과 같이 두 파일을 pem 파일로 변경한다.

```
openssl x509 -in aps_development.cer -inform DER -outform PEM -out cert.pem
openssl pkcs12 -in Certificates.p12 -out key.pem -nodes
```

![](http://asset.hibrainapps.net/saltfactory/images/734d1438-347e-4ccb-811d-11574d857854)

### 푸시 프로바이더 구현

이제 푸시 프로바이더를 구현해보자. 소스코드는 간단하게 node-apn에서 제공하는 예제 코드를 이용하면 된다.

```javascript
var apn = require('apn');

var options = {
		gateway : "gateway.sandbox.push.apple.com",
		cert: './keys/cert.pem',
		key: './keys/key.pem'
	};

var apnConnection = new apn.Connection(options);


var token = '앞에서 Xcode로 build 하면서 획득한 아이폰 디바이스 토큰을 입력한다.'
var myDevice = new apn.Device(token);

var note = new apn.Notification();
note.badge = 3;
note.alert = 'saltfactory 푸시 테스트';
note.payload = {'message': '안녕하세요'};

apnConnection.pushNotification(note, myDevice);
```

이제 이 코드를 실행시켜보자.

```
node sf_push_provider.js
```

![](http://asset.hibrainapps.net/saltfactory/images/8ca07335-1522-46de-8208-04db68517c20)


## 결론

이번 포스팅에서는 node-apn을 이용해서 간단한 푸시 프로바이더를 구현하였고, 아이폰 디바이스에 푸시를 전송하는 방법을 소개하였다. 이번 포스팅에 사용된 Node.js 의 모듈은 node-apn을 사용하였다. 우리가 푸시 프로바이더를 동작하기 위해서는 간단한 몇줄의 코드와 인증파일을 생성하는 일이 전부였다. 물론 이렇게 간단한 코드로 서비스를 구현했다고 말하기 어렵다. 앞으로 많은 코드와 결합해서 더욱 멋진 푸시 프로바이더가 만들어질 것인데, APNs 서비르를 구현하기 위해서 가장 필요하면서도 복잡한 부분이 바로 푸시 프로바이더가 애플 푸시 서버로 디바이스정보와 함께 푸시 발송을 요청하는 부분인데 이 부분을 node-apn으로 할 수 있음을 소개하였다. 다음 포스팅은 node-gcm을 이용해서 안드로이드 디바이스에서 푸시 프로바이더를 구현하는 간단한 예제를 소개하도록 하겠다.

## 소스코드

* https://github.com/saltfactory/saltfactory-ios-tutorial

## 참고

1. https://github.com/argon/node-apn

