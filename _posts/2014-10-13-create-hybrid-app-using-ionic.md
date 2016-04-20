---
layout: post
title : Ionic을 이용한 iOS, Android 하이브리드 앱 개발 사례
category : ionic
tags : [android, ios, hybrid, html5, ionic]
comments : true
redirect_from : /263/
disqus_identifier : http://blog.saltfactory.net/263
---

## 서론

**[하이브레인넷](http://www.hibrain.net) 부설 연구소**에서는 모바일 서비스를 위해 아이폰과 안드로이드 앱을 개발해서 배포하고 있었다. 우리는 아이폰 사용자와 안드로이드 사용자를 위해서 두가지 플랫폼을 개발해야 했다. 안드로이드와 아이폰은 버전과 디바이스의 파편화 때문에 많은 비용을 투자해서 예외처리를 해야했다. 제한된 개발 인력으로 두가지 디바이스를 개발해야하는 복잡한 프로세스를 개선하기 위해서 우리는 **하이브리드 앱** 개발 방법을 도입하기로 결정했다. 최근 우리는 하이브리드 앱 개발 기술을 사용하여  "하이브레인넷 앱(ver. 2.3)"을 [앱스토어](https://itunes.apple.com/kr/app/haibeuleinnes/id438616285?mt=8)와 [구글 플레이](https://play.google.com/store/apps/details?id=net.hibrain.apps.android.hibrainnet)를 통해 배포했다. 우리는 하이브리드 앱을 개발하여 제품으로 배포한 과정을 블로그로 공개한다.

<!--more-->

## 개발 배경

우리는 **하이브리드 앱**을 도입하기 위해  2013년부터 **HTML5**과 **하이브리드 앱** 기술에 관련된 컨퍼런스와 세미나를 참석했다. KTH에서는 웹 기술을 사용하여 모바일 앱을 개발하는 기술을 **H3** 컨퍼런스와 크고 작은 세미나를 통해서 공개했다. KTH의 **Pudding 카메라**가 하이브리드 앱으로 개발되어 많은 인기를 얻으면서 사람들은 웹 기술로 앱을 만들 수 있다는 것을 알게 되었고 이후 점점 웹 기술을 가지고 앱을 만드는 것에 관심을 갖게 되었다. 하이브리드 앱을 처음 도입하게 된 계기는 KTH의 **Appsresso** 라는 하이브리드 앱 개발 플랫폼 때문이였다. 지금은 공식 페이지도 찾아볼 수 없는 사라진 프로젝트이지만 핵심 소스는 [GitHub](https://github.com/kthcorp/Appspresso-SDK)에 공개되어 있다. (개인적으로 국내 소프트웨어로 가장 비전이 있어보이는 프로젝트였는데 중단되어서 너무 아쉬워하고 있다.). Appspresso는 하이브리드 앱을 개발하는 개발 장벽을 낮추는데 큰 영향을 주었다. Appspresso는 HTML5 기반의 웹 자원과 Plugin 형태로 네이티브 자원을 사용할 수 있는 메카니즘을 하나의 IDE에서 개발 할 수 있는 환경을 제공해 주었다. 이렇게 웹 자원이 네이티브 자원을 사용하는 플러그인 방법은 지금까지 [PhoneGap](http://phonegap.com)을 포함한 다른 하이브리드 앱 프레임워크의 대표적인 방법으로 제시되고 있다.

> 우리는 아이폰을 위한 앱을 먼저 개발하고 배포한 뒤 안드로이드 앱을 개발해서 배포하는 프로세스였다.

우리는 기존의 아이폰 앱과 안드로이드 앱을 네이티브로 각각 개발하고 있었다. 대형 포털회사와 달리 개발인력이 많지 않은 우리는 두가지 플랫폼을 개발하는데 어려움을 겪고 있었다. 이유는 간단히 아이폰의 에코 시스템이 편리했고 아이폰 개발이 익숙했기 때문에 아이폰용 앱을 먼저 개발한 것이다. 하지만 안드로이드 사용자가 급격하게 많아지면서 안드로이드 앱에서 발생하는 이슈들이 많아지기 시작했다. 우리는 익숙한 아이폰 개발 환경을 뒤로하고 안드로이드 앱 개발에 집중하기 시작했다. 안드로이드의 SDK에 대처하면서 일정 시간이 지나면 우리는 또 새로워진 iOS를 대처해야했다. 이 과정은 서로 반복되는 힘든 과정이였다.

> 우리는 아이폰과 안드로이드의 UI를 통합하고 싶었다.

우리는 아이폰과 안드로이드 앱을 두가지 다른 사용자 경험을 기반으로 개발을 했었다. 아이폰에서는 **Tab** 기반의 인터페이스를 제공했지만, 안드로이드 사용자는 **Tab** 메뉴 사용이 익숙하지 않고 물리 버튼을 사용하기 때문에 **Slide Out** 메뉴를 제공했다. 우리가 가장 먼저 고민한 것은 바로 UI모듈 통합이였다. 우리의 서비스를 각각 플랫폼에 전달되는 내용은 동일하고 아이폰 사용자가 안드로이드 폰으로 이동하거나 안드로이드 사용자가 아이폰으로 이동하더라도 동일한 UI를 제공하여 혼란을 줄이고 싶었다. 하지만 안드로이드와 아이폰은 사용자 경험이 다르기 때문에 이러한 이슈도 커버하길 원했다.

> 플러그인 형태로 모듈을 만들고 싶었다.

기존의 우리의 앱의 핵심 코어는 크게 **UI 모듈**, **네트워크 모듈**,  **저장 모듈** 그리고 **공유 모듈**을 만들어서 사용했는데 아이폰은 **Objectvie-C** 코드였고 안드로이드는 **Java**로 만들어졌다. 각각 모듈은 프로젝트에 의존적이여서 다른 프로젝트에 사용하기 힘든 문제가 있었다. 우리는 메인 앱을 개발한 이후 여러가지 다른 앱을 개발하기 시작했는데 기존에 사용하던 모듈을 재사용하고 싶어졌다. 그래서 우리는 모듈 프로젝트를 만들어서 가각 모듈을 분리하기 시작했는데 좀 더 효율적으로 사용할 수 있는 방법을 찾고 있었다.

정리하면 우리의 요구사항은 다음과 같다.

- 아이폰과 안드로이드 폰 개발과 업데이트를 동시에 진행하고 싶다.
- UI를 통합하여 단일 코드로 작성하고 싶다.
- 모듈은 플러그인 형태로 개발해서 재사용하고 싶다.

우리의 요구사항은 하이브리드 특징에 모두 포함되어 있다는 것을 여러 컨퍼런스와 세미나를 통해서 알게되었고 구체적인 자료 수집과 개발 환경을 만들기 시작했다.

## 하이브리드 개발 환경

우리는 처음 Appspresso 기반으로 하이브리드 앱을 만들려고 했지만 실제 개발에 들어가기 전에 Appspresso 프로젝트는 중단이 되어서 더이상 업데이트가 진행되고 있지 않았다. 우리는 다른 하이브리드 앱 개발 환경을 조사하기 시작했다. 우리가 개발 방법을 변경할 때, 우리는 이미 back-end와 front-end 개발 플랫폼을 Node.js로 마이그레이션하는 작업을 진행하고 있었다. **PhoneGap**은 **Node.js** 플랫폼으로 개발 할 수 있는 환경을 제공해주기 때문에 우리는 많은 부분을 고민하지 않고 PhoneGap을 하이브리드 개발 프레임워크로 도입하게 되었다.

우리가 생각하던 UI 프레임워크의 요구 사항은 다음과 같다.

-  SPA (Single Page Application)으로 만들고 싶다.
- Templates(Partial Page)를 사용하고 싶다.
- MVC 패턴으로 개발하고 싶다.
- Two-Way Bind를 지원하는 프레임워크를 찾는다.
- 네이티브에 최적화된 UI를 내장하고 있으면 좋겠다.

처음에는 [Sencha Touch](http://www.sencha.com/products/touch/), [jQuery Mobile](http://jquerymobile.com/) 두가지를 가지고 고민을 했었다. Sencha Touch는 라이브러리가 풍부하고 UI가 네이티브에 가깝고 안정성이 높았지만, 실제 디바이스에 올렸을때 무겁고 퍼포먼스가 생각했던 것 보다 좋게 나오지 못했다. jQuery Mobile은 수만은 jQuery 라이브러리를 사용할 수 있는 장점이 있었지만 우리는 MVC 또는 MVVM 패턴으로 개발을 진행하고 싶었고 아직초기 단계의 라이브러리라 안정성도 좋지 못했었다. UI 프레임워크에 대해서 고민을 하고 있을 때, 우리는 HTML5 컨퍼런스에 참석하면서 [AngularJS](https://angularjs.org/)를 알게 되었고 AngularJS의 **two-way bind**에 매료 되었다. 우리의 요구사항은  대부분 AngularJS로 해결할 수 있지만 CSS 개발자가 없기 때문에 AngularJS 기반으로 네이티브에 최적화된 UI를 내장하고 있는 프레임워크를 찾기 시작했다.

> 우리에게 Ionic Framework는 가장 우리의 요구 사항을 만족시켜주는 프레임워크였다.

우리는 [Ionic Framework](http://ionicframework.com/)를 찾을 수 있었다. Ionic은 다음과 같은 특징을 가진다.

- Cordova(PhoneGap) 환경을 제공한다.
- Cordova(PhoneGap) 플러그인을 사용할 수 있다.
- AngularJS 기반으로 SPA를  MVC나 MVVM 패턴으로 개발을 할 수 있다.
- 네이티브에 가까운 UI 컴포넌트들을 제공한다.
- HTML5 어플리케이션을 빠른 시간으로 개발할 수 있다.

우리는 최종적으로 Ionic을 선택했고 Ionic을 사용해서 하이브리드 앱 개발을 시작했다.

## Ionic Framework

[Ionic](http://ionicframework.com)은 Advanced HTML5 Hybrid Mobile App Framework이다. HTML5로 어플리케이션을 만들기 전에 우리는 가정 먼저 고려한 것이 UI를 웹 자원으로 개발하지만 성능과 안정성을 높이는 것이였다. 처음 우리는 직접 JavaScript를 이용해서 만들어보려고 했지만 성능과 안정성을 검증할 수 없었기 때문에 이미 성능과 안정성이 보장되어 있는 Ionic을 사용하여 개발하기로 했다. Ionic 블로그에서 Ionic에 대해서 다음과 같이 소개하고 있다. [Where does the ionic framework fit in](http://ionicframework.com/blog/where-does-the-ionic-framework-fit-in/) Ionic의 궁극적인 목표는 하이브리드 앱으로 알려진, HTML5를 이용해 네이티브 앱을 더욱 쉽게 개발하기 위한 것이라고 소개하고 있다.

### Ionic과 AngularJS

Ionic Framework는 AngularJS를 근간에 두고 만들어졌다. Ionic에서는 자신의 UI 컴포넌트들의 태그를 직접 만들어서 사용하기도 하는데 이 것은 AngularJS의 [directives](https://docs.angularjs.org/guide/directive)를 이용하여 만들어졌다. 이 것을 사용해서 Ionic은 UI 개발자에게 복잡한 CSS와 JavaScript를 나열하는 대신에 단순히 Ionic에서 정의한 Custom Element를 제공하여 개발자는 마치 Code Snippet과 같이 쉽게 사용할 수 있게 하였다.

예를 들어 각 View가 전환되고 전환되는 View에 엑션과 NavigationBar를 구현하는 코드를 만든다고 생각해보자. 단순히 `html` 파일을 하나 열어서 비어 있는 파일에 직접 코드를 작성한다면 쉽게 구현할 수 없을 뿐만 아니라 엄청난 코드 때문에 실제 서비스를 만들기 전에도 개발자는 지치고 말것이다. 하지만 Ionic에서는 이런 네비게이션이 가능한 뷰를 [ion-nav-view](http://ionicframework.com/docs/api/directive/ionNavView/) 로 정의를 하였고, 네비게이션이 일어난 뷰는 [ion-nav-bar](http://ionicframework.com/docs/api/directive/ionNavBar/)라를 네비게이션 바와 함께 사용하여 간단하게 구현할 수 있도록 도와준다. 실제 다음 코드로 네이게이션이 가능한 뷰의 레이아웃을 모두 만든 것이다.

```html
<body>
	<ion-nav-bar></ion-nav-bar>
	<ion-nav-view></ion-nav-vew>
</body>
```

`ion-nav-bar`와 `ion-nav-view`를 사용하면 자동으로 새로운 View를 요청하면 다음 네비게이션이 가능한 View가 열리고 상단에 뒤로가기 버튼과 새로운 타이틀을 가지는 View가 열리게 된다. 아래 그림은 우리가 구현한 네비게이션 뷰 중에서 한 부분이다. 우리는 **뒤로가기** 버튼이 있는 네비게이션 바를 직접 구현하지 않았고 Ionic에서 제공하는 `ion-nav-bar`와 `ion-nav-view`를 사용했다. 자세한 사용법은 다음 포스팅에서 소개하려고 한다.

![ion-nav-bar 예제 {width:320px}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/000fb7b8-8789-4491-98be-b5f5ae2e251b)

Ionic은 뷰의 네비게이션을 위해 다른 뷰로 이동하는 것을 SPA의 routing으로 한다. 즉 다시 말해서 새로운 뷰를 불러오는 것은 AngularJS의 templates로 만들어진 HTML 페이지를 AngularJS에서 routing으로 요청하여 불러오는 것이다. 아래는 Ionic의  slidemenu sample project의 Routing을 정의한 부분이다. Ionic의 AngularJS 기반의 이런 Routing은 완벽한 SPA 구현을 할 수 있게 도와준다. Ionic의 Routing을 사용하는 방법도 다음 포스팅에 자세히 소개하려고 한다.

```javascript
.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider

    .state('app', {
      url: "/app",
      abstract: true,
      templateUrl: "templates/menu.html",
      controller: 'AppCtrl'
    })

    .state('app.browse', {
      url: "/browse",
      views: {
        'menuContent' :{
          templateUrl: "templates/browse.html"
        }
      }
    })
    .state('app.playlists', {
      url: "/playlists",
      views: {
        'menuContent' :{
          templateUrl: "templates/playlists.html",
          controller: 'PlaylistsCtrl'
        }
      }
    })

    .state('app.single', {
      url: "/playlists/:playlistId",
      views: {
        'menuContent' :{
          templateUrl: "templates/playlist.html",
          controller: 'PlaylistCtrl'
        }
      }
    });
  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/app/playlists');
```



### Ionic과 Cordova

Ionic은 Cordova를 사용해서 여러가지 모바일 앱에 실행할 수 있는 빌드 시스템을 갖추었다. Ionic의 초기 버전에는 Cordova 명령어를 사용하여 프로젝트를 빌드하고 디바이스에 실행하였는데, Ionic은 ionic command를 자체적으로 만들었다. 사실 Ionic의 command는 Cordova의 command를 매핑하여 Cordova의 command를 확장하려고 하는 것 같다는 생각이 든다. Ionic은 Cordova를 기반으로 하기 때문에 cordova command를 사용한 경험이 있으면 대부분 같은 명령어로 사용할 수 있다. 예를 들어 프로젝트에 `ios` 플랫폼을 추가한다고 가정하면 Ionic command는 다음과 같다.

```
ionic platform add ios
```

이 command는 Cordova의 command로  `ios` 플랫폼을 추가하는 것과 동일하다.

```
cordova platform add ios
```

Ionic로 프로젝트를 개발할 때 HTML, JavaScript, CSS 파일이 수정될 때마다 디바이스에 빌드해서 디버깅을 한다면 빌드시간이 길어서 코드를 업데이트하는데 굉장히 많은 시간이 소요될 것이다. Ionic은 하이브리드 앱을 개발하는 프레임워크이다. 네이티브 자원을 사용하지 않는 코드는 디바이스에 빌드하지 않고 로컬 컴퓨터에서 Safari나 Chrome 브라우저를 이용해서 개발한다. 이 때 Ionic 프로젝트를 디버깅할 수 있게 앱을 실행시켜주는 서버를 구동해서 개발한다. Cordova에서는 `cordova serve`라는 명령어를 사용하여 프로젝트를 실행시키는데 이 때 웹 자원 소스가 업데이트 되면 이 명령어를 재시작해줘야한다. 하지만 `phonegap serve`와 `ionic serve` command를 이용하면 웹 자원이 수정될 때 수정된 파일을 반영해서 서버 재시작 없이 자동으로 업데이트 되기 때문에 이 명령어를 다시 실행시키지 않아도 된다. Ionic을 이용하여 개발을 진행하면 웹 자원의 디버깅을 가장 많이하는데, Safari나 Chrome의 **Developer Tool**로 디버깅을 하면 된다. 아래 그림은 `ionic serve`를 실행하고 **Chrome  Developer Tool** 로 디버깅하는 화면이이다.

![chrome debugging {width:320px;}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e59b9d6f-ac5c-4122-b1ad-3cc630ea1a1e)

Ionic은 Cordova 기반의 장점을 사용할 수 있다. Cordova의 장점 중에 하나는 Plugins 이라고 생각한다. 하이브리드 앱을 개발하기 위해서는 단순하게 HTML, JavaScript, CSS 만으로는 디바이스를 제어할 수 없다. 그래서 Cordova는 네이티브 브릿지와 같은 Cordova Plugins를 제공하고 이 것을 이용하여 웹과 네이티브간의 통신을 가능하게 한다. 예를 들어 Push Notification 서비스를 앱에 구현하고 싶을 경우 Push Notification은 디바이스의 자원을 사용해야만 가능하다. PhoneGap에서는 [PhoneGap Push Plugin](https://github.com/phonegap-build/PushPlugin)을 이미 만들어 두었다. 이것을 사용하면 많은 시간을 단축하고 간단하게 Push Notification 기능을 하이브리드 앱에서 구현할 수 있다. 다음 포스팅에서 **PushPlugin**을 어떻게 설정하고 사용하는지에 대한 글도 소개할 예정이다.

### Ionic과 Node.js

Ionic은 [Node.js](http://nodejs.org) 기반의 모듈을 사용하여 개발을 할 수 있다. PhoneGap과 Cordova의 command가 모두 Node.js 기반으로 만들었기 때문에 Node.js 모듈을 함께 사용하여 개발할 수 있듯 Ionic command 모두 Node.js로 만들어져 있기 때문이다. 예를 들어 Ionic 프로젝트를 모두 개발하고 JavaScript를 uglify를 할 때 [gulp.js](http://gulpjs.com)를 이용하여 uglify를 할 수 있다. 우리는 MVC 기반으로 만든 JavaScript 코드를 `all.min.js` 라는 하난의 파일로 만들어서 배포버전을 만들었는데 이때 Node.js의 스트림기반 task 모듈인 **gulp.js**를 이용했다.


### Ionic과 앱 스토어 등록

Ionic으로 만든 하이브리드 앱은 여러가지 디바이스에 실행할 수 있는데 우리는 iOS와 Android 디바이스만 고려했다. Ionic에는 앱의 정보를 설정하는 `config.xml` 파일이 있는데 여기에서 iOS와 Android 앱을 스토어에 등록하기 위한 정보를 입력해서 Ionic 프로젝트를 배포할 수 있게 만들어 놓았다. 이것은 Cordova 프로젝트를 앱 스토어에 등록하는 설정과 동일하다. 예를 들어 `net.hibrain.apps.hibrainnet` 이라는 패키지명으로 iOS와 Android 프로젝트를 스토어에 등록한 상태라면 다음 버전을 스토어를 통해서 배포할 때, 동일한 패키지명으로 개발을 해야한다. 아래는 우리가 프로젝트를 앱 스토어에 등록하기 위해서 `config.xml`에 설정한 정보의 일부분이다. 자세히 살펴보면 앺 패키지명을과 스토어에 등록할 버전 정보를 `<widget id="net.hibrain.apps.hibrainnet" version="2.4.0">`에서  지정한 것을 살펴볼 수 있다. 그리고  앱의 가로,세로 지원 모드, 아이콘 설정 등을 명시적으로 정의한 것을 살펴볼 수 있다.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="net.hibrain.apps.hibrainnet" version="2.4.0" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>하이브레인넷</name>
    <description>
        하이브레인넷 채용 정보 스마트폰 어플리케이션
    </description>
    <author email="apps@hibrain.net" href="http://www.hibrain.net">
      Hibrainnet Mobile Service Support
    </author>
    <content src="index.html" />
    <access origin="*" />
    <preference name="fullscreen" value="true" />
    <preference name="webviewbounce" value="false" />
    <preference name="UIWebViewBounce" value="false" />
    <preference name="DisallowOverscroll" value="true" />
    <preference name="Orientation" value="default" />
    <preference name="SplashScreen" value="screen" />
    <preference name="BackupWebStorage" value="none" />

    <feature name="StatusBar">
      <param name="ios-package" value="CDVStatusBar" onload="true" />
    </feature>

  <feature name="PushPlugin">
    <param name="ios-package" value="PushPlugin" />
  </feature>

    <platform name="android">
      <icon src="www/res/icons/android/icon-ldpi.png" density="ldpi" />
      <icon src="www/res/icons/android/icon-mdpi.png" density="mdpi" />
      <icon src="www/res/icons/android/icon-hdpi.png" density="hdpi" />
      <icon src="www/res/icons/android/icon-xhdpi.png" density="xhdpi" />
    </platform>

    <platform name="ios">
      <!-- iOS 7.0+ -->
      <!-- iPhone / iPod Touch  -->
      <icon src="www/res/icons/ios/icon-60.png" width="60" height="60" />
      <icon src="www/res/icons/ios/icon-60@2x.png" width="120" height="120" />
      <!-- iPad -->
      <icon src="www/res/icons/ios/icon-76.png" width="76" height="76" />
      <icon src="www/res/icons/ios/icon-76@2x.png" width="152" height="152" />
      <!-- iOS 6.1 -->
      <!-- Spotlight Icon -->
      <icon src="www/res/icons/ios/icon-40.png" width="40" height="40" />
      <icon src="www/res/icons/ios/icon-40@2x.png" width="80" height="80" />
      <!-- iPhone / iPod Touch -->
      <icon src="www/res/icons/ios/icon.png" width="57" height="57" />
      <icon src="www/res/icons/ios/icon@2x.png" width="114" height="114" />
      <!-- iPad -->
      <icon src="www/res/icons/ios/icon-72.png" width="72" height="72" />
      <icon src="www/res/icons/ios/icon-72@2x.png" width="144" height="144" />
      <!-- iPhone Spotlight and Settings Icon -->
      <icon src="www/res/icons/ios/icon-small.png" width="29" height="29" />
      <icon src="www/res/icons/ios/icon-small@2x.png" width="58" height="58" />
      <!-- iPad Spotlight and Settings Icon -->
      <icon src="www/res/icons/ios/icon-50.png" width="50" height="50" />
      <icon src="www/res/icons/ios/icon-50@2x.png" width="100" height="100" />
     </platform>

</widget>
```

## 결론

우리는 **Ionic Framework**를 이용한 첫번째 하이브리드 앱을 [앱스토어](https://itunes.apple.com/kr/app/haibeuleinnes/id438616285?mt=8)와 [구글 플레이](https://play.google.com/store/apps/details?id=net.hibrain.apps.android.hibrainnet)를 통해 배포했다. 기존에 iOS와 Android를 혼자 개발했을 때 개발 비용이 너무 많이 필요했다. 안드로이드 파편화 그리고 iOS와 Android 개발의 다른 플랫폼을 혼자서 처리하기에는 버거운 일이였다. 그래서 우리는 개발환경을 하이브리드 개발을 해보기로 결정을 했다. 사전 조사와 테스트 앱을 만들어보고 우리가 배포하는 앱은 고성능을 필요하기 보다 관리의 편리성과 개발 시간을 단축하는 것을 주요하게 생각했기 때문에 하이브리드 앱으로 결정을 내린것이다. 하이브리드 앱 개발 프레임워크를 조사하면서 Ionic은 우리가 원하는 환경을 가지고 있었다. Ionic은 AngularJS, Cordova, Node.js 기반으로 만들어졌기 때문에 우리가 요구조건을 대부분 갖추고 있었다. 이번 프로젝트에서 우리는 Cordova를 이용해서  Network와 Persistence 플러그인 두가지를 만들었고, Ionic을 사용해서 iOS와 Android 앱을 동시에 개발하였다. 개발 시간은 기존의 네이티브 앱을 개발하는 시간에 비해 상당한 시간을 줄일 수 있었다. 우리는 이 경험을 바탕으로 Ionic으로 하이브리드 앱을 개발한 과정과 개발하면서 겪게된 문제들 그리고 그것을 해결한 방법들을 계속해서 블로그를 통해 소개할 예정이다.

