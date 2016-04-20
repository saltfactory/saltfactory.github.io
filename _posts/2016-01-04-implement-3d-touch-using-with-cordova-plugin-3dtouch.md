---
layout: post
title: 'Ionic 하이브리드 앱 (PhoneGap, Cordova) iOS 3D Touch 적용하기'
category: ionic
tags:
  - ionic
  - cordova
  - hybrid
  - hybridapp
  - phonegap
  - ios
comments: true
images:
  title: https://s3.ap-northeast-2.amazonaws.com/hbn-blog-assets/screen-shot-2015-09-26-at-5-44-22-pm.png
---

## 서론
**iPhone 6s**의 가장 큰 특징 중에 하나가 [3D Touch](http://www.apple.com/iphone-6s/3d-touch/) 이다. 새로운 SDK가 발표되면 새로운 디바이스에 설치되는 앱에는 이런 기능을 추가하고 싶어질 것이다. **3D Touch** 는 마치 **단축키메뉴** 같은 역활을 한다. 앱을 터치하여 앱을 구동시키지 않고, 앱이 실행되고 있지 않아도 특정 메뉴에 접근하거나 특정 작업을 바로 할 수 있는 기능을 구현할 수 있다. 만약 Cordova 기반의 하이브리드 앱을 개발하고 있다면 iPhone 6s 디바이스에 어떻게 3D Touch 를 적용할 수 있을지 관심을 가져볼 수 있다. Cordova 개발자들 사이에서도 3D Touch를 사용하여 적용할 수 있는 방법에 대해서 연구하고 여러가지 플러그인을 내어 놓고 있다. 이 글에서는 Cordova 기반 Ionic 프레임워크로 하이브리드 앱에서 [cordova-plugin-3dtouch](https://github.com/EddyVerbruggen/cordova-plugin-3dtouch) Cordova 플러그인을 사용하여 간단하게 iPhone 6s 에서 3D Touch를 적용하는 방법을 소개한다.

<!--more-->

## Ionic 프로젝트 생성

Ionic은 기본적으로 Cordova 기반으로 만들어진 하이브리드 앱 개발 프레이워크이다. Corodva의 모든 명령을 사용할 수 있을 뿐만 아니다 AngularJS와 멋진 템플릿을 가지고 빠르게 앱을 개발할 수 있다. Ionic을 처음 시작한다면 http://blog.saltfactory.net/tags/ionic/ 에서 글을 참조하면 Ionic에 관해서 이해할 수 있을 것이다.

테스트를 위해서 ionic cli를 사용하여 프로젝트를 생성한다. 슬라이드 메뉴를 가지는 앱을 만들기 위해서 **sidemenu** 타입으로 프로젝트를 생성한다.

```text
ionic start myApp sidemenu
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/eb26ba95-4bf7-4571-bb37-f1a0e8e453cd)

ionic 으로 앱을 만들면 기본적으로 iOS 플랫폼을 추가하여 만들어진다. ionic은 cordova의 명령어를 그대로 사용할 수 있다. ionic 이나 cordova를 사용하여 설치된 플랫폼을 확인해보자.

```text
ionic platform list
```

```text
cordova platform list
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/12c53ba1-d024-4887-b894-6cc44d0c53ff)

앱을 빌드하고 실행시켜보자.

```text
ionic run ios --device
```

다음과 같은 화면이 디바이스에서 나타날 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4662498c-a1de-4eb8-913d-18e353181d2c)

## cordova-plugin-3dtouch

Cordova 기반의 프레임워크의 장점은 유용한 Cordova 플러그인을 사용하여 빠르게 개발할 수 있는 것이다. 3D Touch에 관한 플러그인은 이미 몇가지 개발되어 리파지토리에서 바로 설치를 할 수 있다. 다음 명령어를 실행하여 3D touch 플러그인을 설치한다. cordova 명령어도 그대로 사용할 수 있다.

```text
ionic plugin add cordova-plugin-3dtouch
```

ionic 명령어로 plugin을 설치하면 **package.json**에 어떤 플러그인을 설치했는지 저장을 하게 된다. 

```javascript
{
  "name": "myapp",
  "version": "1.1.1",
  "description": "myApp: An Ionic project",
  "dependencies": {
    "gulp": "^3.5.6",
    "gulp-sass": "^2.0.4",
    "gulp-concat": "^2.2.0",
    "gulp-minify-css": "^0.3.0",
    "gulp-rename": "^1.2.0"
  },
  "devDependencies": {
    "bower": "^1.3.3",
    "gulp-util": "^2.2.14",
    "shelljs": "^0.3.0"
  },
  "cordovaPlugins": [
    "cordova-plugin-device",
    "cordova-plugin-console",
    "cordova-plugin-whitelist",
    "cordova-plugin-splashscreen",
    "cordova-plugin-statusbar",
    "ionic-plugin-keyboard",
    "cordova-plugin-3dtouch"
  ],
  "cordovaPlatforms": [
    "ios"
  ]
}
```

명령어로 확인하기 위해서는 다음 명령어로 확인할 수 있다.

```text
ionic plugin list
```

또는

```text
cordova plugin list
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/059da844-4221-4b2f-ba31-dd5e60267e5e)

우리는 Cordova Plugin 설치로 어렵지 않게 iPhone 6s 에서 사용할 수 있는 3D Touch 기능을 JavaScript로 구현할 수 있게 되었다.

## 3D Touch 홈스크린 3D Touch 정의하기

플러그인 설치가 끝다면 3D Touch 설정을 하기 위해서 `$ionicPlatform.ready`  함수 안에 다음을 정의한다. 만약 Ionic을 사용하지 않고 Cordova 프로젝트에서 사용한다면 `document.addEventListener("deviceready", yourCallbackFunction, false);` 에서 **deviceready**의 이벤트가 발생할 때 사용되는 콜백함수 안에 정의한다. 하이브리드 앱은 WebKit 브라우저가 오픈된 이후에 JavaScript 코드가 동작하기 때문이다. 3D Touch 플러그인에서 3D Touch가 홈스크린에 나타나는 아이콘을 정의하기 위해서 **ThreeDeeTouch.configureQuickActions()** 메소드를 사용한다. 이 때 3D Touch Action을 정의하는 프포퍼티로는 다음과 같다.

- type : 3D Touch 이벤트의 타입을 정의해서 각 이벤트를 구분할 때 사용
- title : 3D Touch 할 경우 나타나는 액션들의 타이틀
- subtitle : 3D Touch 할 경우 나타나는 액션들의 서브타이틀 (생략가능)
- iconType : 3D Touch 할 경우 나타나는 액션의 아이콘

3D Touch의 기본 아이콘은 [UIApplicationShortcutIconType](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutIcon_Class/#//apple_ref/c/tdef/UIApplicationShortcutIconType)에서 참조할 수 있다. 
 

```javascript
… 생략…
angular.module('starter', ['ionic', 'starter.controllers'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }


       ThreeDeeTouch.configureQuickActions([
        {
          type: ‘onCompose’, 
          title: '글쓰기', 
          iconType: 'Compose'
        },
        {
          type: ‘onShare',
          title: '공유',
          iconType: 'Share'
        },
        {
          type: ‘onSearch',
          title: '검색',
          iconType: 'Search'
        }
      ]);

  });
})

.config(function($stateProvider, $urlRouterProvider) {
…생략…
```

이제 디비이스에 코드를 빌드해서 실행해보자. 이 때 주의해야할 점은 3D Touch 테스트는 **Simulator에서 가능하지 않다**는 것이다. 반드시 **iPhone 6s/6s plus** 에 실행해서 테스트를 해야 3D Touch가 실행되는 것을 확인할 수 있다.

```text
ionic prepare ios
```
```text
ionic build ios
```
```text
ionic run ios --device
```
디바이스에 앱이 실행되면 홈스크린에 설치된 아이콘을 꾹 눌러서 3D Touch 가 적용되었는지 살펴보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/159e92aa-70f7-4ebd-b50e-c30e44b215a5)

## 3D Touch 이벤트 처리하는 핸들러 정의하기

위에서 3D Touch 이벤트를 정의했다면 각 이벤트가 처리하는 핸들러를 정의해야한다. 위 3D Touch 정의 중에 **type** 이라는 것이 이벤트의 타입을 나타내는 ID라고 생각하면 된다. 즉 3D Touch로 Compose를 눌렀으면 **onCompose**라는 이벤트 타입이 발생하는 것이다. 3D Touch의 이벤트는 **ThreeDeeTouch.onHomeIconPressed()** 함수로 정의할 수 있다. 이 것 또한 위에서 3D Touch의 Quick Actions을 정의한 것과 동일하게 `$ionicPlatform.ready()` 안에서 정의한다. cordova의 경우 deviceready 이벤트에 해당한다. 간단한 테스트를 위해서 3D Touch에서 Search 액션을 선택하면 앱이 열리면서 검색화면이 열리게 하는 것이다. 화면의 페이지를 전환하기 위해서 ionic의 **$state.go()**를 사용한다.

```javascript
...생략...
angular.module('starter', ['ionic', 'starter.controllers'])

.run(function($ionicPlatform, $state) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }


       ThreeDeeTouch.configureQuickActions([
        {
          type: 'onWrite', 
          title: '글쓰기', 
          iconType: 'Compose'
        },
        {
          type: 'onShare',
          title: '공유',
          iconType: 'Share'
        },
        {
          type: 'onSearch',
          title: '검색',
          iconType: 'Search'
        }
      ]);

      ThreeDeeTouch.onHomeIconPressed = function (payload) {
      console.log("Icon pressed. Type: " + payload.type + ". Title: " + payload.title + ".");
        if (payload.type == 'onSearch') {
          $state.go('app.search');
        } else if (payload.type == 'onShare') {
          // open share page
        } else {
          // open compose page
        }
      }

  });
})

.config(function($stateProvider, $urlRouterProvider) {
...생략 ...
```

이벤트 핸들러를 정의하고 다시 디바이스에 빌드해서 실행해보자

```text
ionic prepare ios
```
```text
ionic build ios
```
```text
ionic run ios --device
```

3D Touch를 시작해서 Search 액션을 선택하면 검색 화면이 열리게 될 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/302e4473-2e17-4661-a76d-c6bed16d52e8)


## 결론

iPhone 6s 에서 3D Touch는 꽤 유용하다. 앱을 실행시키지 않고 홈 스크린에서 빠르게 자주 사용하는 메뉴로 들어갈 수 있다. iOS에서 3D Touch 기능을 네이티브 코드로 개발을 할 수 있는데 Corodva 하이브리드 앱을 개발하고 있다면 네이티브 코드로 Corodva 플러그인을 만들어서 사용해야한다. Cordova는 이미 꽤 방대한 에코시스템이 만들어져 있다. 여러 커뮤니터들은 자신의 플러그인을 개발하여 오픈소스로 플러그인을 공유하고 있고 있다. [cordova-plugin-3dtouch](https://github.com/EddyVerbruggen/cordova-plugin-3dtouch)도 이러한 플러그인 중에 하나로 iOS 네이티브 코드를 직접 만들지 않고 이 플러그인을 사용하여 3D Touch 기능을 JavaScript로 간단하게 구현할 수 있을 것이다.

## 참고

1. https://github.com/EddyVerbruggen/cordova-plugin-3dtouch
2. https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutIcon_Class/#//apple_ref/c/tdef/UIApplicationShortcutIconType
3. https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html

## 소스코드

- https://github.com/saltfactory/ionic-tutorial/tree/3d-touch

## ionic 책

- http://blog.saltfactory.net/books/ionic-edge/


