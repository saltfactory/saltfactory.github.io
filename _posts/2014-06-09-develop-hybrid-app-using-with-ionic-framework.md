---
layout: post
title: Ionic Framework를 이용하여 하이브리드앱 개발하기
category: ionic
tags: [ionic, hybrid, framework, angularjs, javascript]
comments: true
redirect_from: /239/
disqus_identifier : http://blog.saltfactory.net/239
---

## 서론

하이브리 앱은 이상적인 이론이다. 혼자서 iOS와 Android 앱을 동시에 개발하면서 개발하는 앱이 많아지면 많아질수록 유지 보수 부담은 점점 더 증가하게 되고 두가지 플랫폼을 고려해서 개발해야하기 때문에 새로운 프로젝트를 맡게 될 때마다 개발 기간에 대한 스트레스는 계속 쌓이게 되는것 같다. 성능과 개발비용, 유지보수에 대한 비용을 고려해볼때 개인 개발자가 한명에 두가지 플랫폼 (하지만 안드로이드에 들어가게 되면 결코 두자기 플랫폼이라고 말하기 힘들다. 이젠 곧 iOS 디바이스도 마찬가지겠지만..)을 완벽하게 커버하기는 비용은 만만치 않다. Appspresso를 연구하면서 하이브리드 연구를 계속 해왔지만 이젠 더이상 업데이트를 지원하지 않는 하이브리드 환경을 가지고 개발할 수 없게 되었다. 차선책으로 PhoneGap(Cordova)를 이용해서 Sencha Touch를 이용해서 개발하려고 해봤지만 Sencha Touch의 광범위한 파일과 풀 JS 스택으로 개발해서 UI를 만들어내기란 또한 쉬운 것이 아니였다. 이렇게 하이브리드 앱에 대한 연구를 계속 진행하는 동안 AngularJS라는 새로운 Web Application 라이브러리가 등장했다. 이것은 Sencha 의 복잡한 JS 풀 스택을 Two way Binding을 이용해서 HTML과 JavaScript의 개발을 매우 편리하게 해주어 Sencha Touch의 Store라는 복잡한 개념을 해소해 주었다. 다시 말해서 UI를 익숙한 HTML로 구현하고 MVC(또는 MVVM)로 분리해서 개발 할 수 있는 환경을 만들어 낼 수 있었다. 하지만 이것을 모바일에 하이브리드하게 개발하기 위해서는 크로스 플랫폼으로 빌드하기 위해서 여전히 PhoneGap(Cordova)를 이용해서 개발해야했다. 우리는 HTML을 개발하기에는 익숙했지만 스마트폰에 최적화 된 UI를 디자인하거나 HTML, CSS를 개발하는 전문 인력이 없었다. 그래서 우리는 스마트폰에 최적화된 UI를 제공해주는 UI 프레임워크가 필요하다고 생각했다. 그러면서도 크로스 플랫폼 개발을 할 수 있고, HTML5의 부족한 API를 네이트브 API로 보완할 수 있는 프레임워크를 찾고 있었다. 그렇게 AngularJS와 PhoneGap에 대한 연구를 진행하고 있을 때 ionic framework를 간단하게 소개하는 twitter의 글들을 보면서 ionic에 관련된 연구를 진행하게 되었다.

<!--more-->

하이브리드 앱은 국내에서 자주 사용하는 키워드였다. 그것도 HTML5가 처음 소개되면서 모바일 플랫폼에 새로운 핫 이슈로 떠올랐을 때 국내 대형 포털과 프론트엔드 개발자들에게 소개되었던 키워드 였다. 국외에서는 하이브리드라는 키워드가 그렇게 많지 않았는데 ionic framework 사이트에 들어가면 이렇게 소개하고 있다.

> The beautiful, open source front-end framework for developing hybrid mobile apps with HTML5

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/95e7952d-0bc7-4c64-bfd6-ce6c3ce215d8)

이 타이틀은 지금까지 기다려온 어떤 타이틀보다 가장 필요한 내용이였고 실제 ionic은 하이브리드 앱을 개발하기에 최적화된 환경을 제공한다. ionic은 HTML5 API를 사용할 수 있는 컴포넌트들과 클래스 플랫폼을 개발하는 Cordova 기반으로 구성된 하이브리드 앱 개발 프레임워크이다.

우리가 ionic을 선택한 이유는 다음과 같다.

- 모바일 앱을 개발하기에 최적화된 UI가 기본적으로 제공한다.
- HTML으로 UI를 만들고 JavaScript의 데이타 업데이트를 빠르게 적용할 수 있다.
- MVC 개발을 할 수 있는 환경을 제공한다.
- 네이티브 자원을 사용할 수 있는 plugins 사용을 허용한다.
- 크로스 플랫폼 빌드를 제공한다.
- Node.js 기반으로 개발할 수 있는 환경을 지원한다.
- 활발한 개발자 포럼을 지원하고 있다.

우리는 ionic framework를 이용해서 기존의 iOS와 Android로 따로 개발한 앱을 마이그레이션하는 프로젝트를 진행했고 지금은 스토어에 등록하여 심사를 대기하고 있다. 또한 우리는 기존의 개발한 컴포넌트와 플러그인을 재 사용하여 두번째 프로젝트를 시작하고 있다. 이렇게 하이브리드 앱을 개발하면서 겪은 기술과 이슈를 블로그로 포스팅하기로 결정했다. 개인 개발자가 iOS와 Android 개발을 좀 더 편리할 수 있도록 ionic framework를 사용하여 개발하는 방법들을 연재하려고 한다.

ionic framework 로 개발하기 위해서는 다음과 같은 사전 지식이 필요하다.

- **Node.js**
- **AngularJS**
- **PhoneGap (Cordova)**

위의 기술에 대한 소개글은 인터넷에서 쉽게 찾아볼 수 있기 때문에 각각 해당하는 기술을 소개하는 글은 생략한다.
ionic을 설치하기 위해서는 Node.js가 설치되어 있어야한다. Mac을 사용하고 있으면 Homebrew를 사용하여 간단하게 최신 Node.js를 설치할 수 있다. Homebrew를 사용하는 방법은 다음 글을 참조한다. (http://blog.saltfactory.net/109)

```
brew install node
```
Node.js가 설치가 되어 있으면 다음은 PhoneGap과 Cordova를 npm으로 설치한다. ionic은 cordova를 패키징하고 있지만 이후에 cordova 명령어를 자주 이용할 수 있기 때문에 설치하는 것이 좋다.

```
npm install -g cordova phonegap
```

마지막으로 ionic framework를 설치한다.

```
npm install -g ionic
```

ionic을 사용하기 위한 준비는 모두 끝났다. 의외로 매우 간단하다. ionic 뿐만아니라 cordova, phonegap 역시 모두 Node.js 기반으로 개발환경을 바꾸었기 때문에 이렇게 간단하게 설치할 수 있게 되었다. npm으로 global로 ionic을 설치하면 ionic 명령어를 사용할 수 있게 된다. ionic은 지금 정식 1.0 릴리즈를 앞두고 여러가지 기능과 컴포넌트를 빠르게 업데이트 하고 있다. 항상 최신 버전을 업데이트하는게 중요하다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/80db271c-dda2-429b-bc10-020fc65e3282)

명령어 옵션은 이후에 하나씩 사용하면서 설명하도록 한다.

이제 ionic 프로젝트를 한번 만들어보자. ionic의 명령어 중에 프로젝트를 생성하는 것은 start라는 명령어이다. 다음과 같이 ionic start {프로젝트명}을 입력하고 새로운 ionic 프로젝트를 만들어보자.

```
ionic start sf-hybrid-demo
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e4c65d6c-a5fb-4272-b16f-327e59be338a)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ba244159-ee39-44ed-8c06-8e96bfa3db7a)

ionic start로 새로운 프로젝트를 만들면 git에서 sample 소스가 다운로드되어 풀리면서 위와 같이 앱을 개발하는데 기본적으로 필요한 파일들이 프로젝트 이름으로 만들어진 디렉토리에 저장이 된다. ionic은 bower를 사용하여 웹 라이브러리를 다운 받을 수 있게 지원하고 있으며, gulpjs를 이용해서 자동화할 수 있는 환경을 제공하고 있다 또한 기본 디렉토리 구조는 PhoneGap(Cordova)프로젝트와 동일하다. ionic은 크로스 플랫폼 빌드를 지원하기 위해서 내부적으로 cordova를 사용하고 있기 때문이다. 또한 개발에 필요한 Node.js 모듈을 사용하기 위해서 package.json 파일이 존재하는 것도 볼 수 있다. 즉, ionic 은 Node.js 기반으로 개발하고 Cordova를 사용하고 있다는 것을 확인할 수 있다. 이러한 이유로 Cordova(PhoneGap)을 사용해서 개발해본 경험이 있다면 매우 친근하게 개발을 할 수 있다. guplfile.js를 열어보면 scss 파일을 컴파일하는 자동화 task가 정의된 것을 확인할 수 있다. css 개발을 scss를 이용하여 할 수 있는 환경도 가지고 있다. 또한 plugins 디렉토리에는 cordova plugins을 저장하는 곳으로 ionic이 하이브리드 앱을 개발하기 위한 framework라는 것을 확인할 수 있다.

ionic은 점점 자동화와 여러가지 편리한 개발 환경을 추가하고 있다. 이전 버전에는 없었지만 이젠 ionic 프로젝트를 웹에서 관리할 수 있는 기능도 추가적으로 개발하고 있는 것으로 확인된다. ionic 프로젝트에 대한 설정을 명시하기 위해서 ionic.project 파일에 프로젝트 정보를 입력한다. ionic.project 파일을 열어서 다음과 같이 수정한다.

- **name** : 프로젝트 이름을 입력한다.
- **email** : ionic 계정에 등록된 email을 입력한다.
- **app_id** : 프로젝트의 유일한 id로 이후에 iOS난 Android에 UUID로 사용되는 아이디를 입력한다.
- **package_name** : 이후에 android에 사용될 package 이름을 입력한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9f357e40-ad9d-4417-85d5-cf7f6fe58bda)

프로젝트에 관한 전체 설정은 config.xml을 사용하여 설정한다. config.xml을 열어보자. ionic start로 만들어진 프로젝트는 starter라는 이름으로 만들어진다.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.ionicframework.starter" version="0.0.1" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>HelloCordova</name>
    <description>
        An Ionic Framework and Cordova project.
    </description>
    <author email="hi@ionicframework" href="http://ionicframework.com/">
      Ionic Framework Team
    </author>
    <content src="index.html" />
    <access origin="*" />
    <preference name="fullscreen" value="true" />
    <preference name="webviewbounce" value="false" />
    <preference name="UIWebViewBounce" value="false" />
    <preference name="DisallowOverscroll" value="true" />

    <!-- Don't store local date in an iCloud backup. Turn this to "cloud" to enable storage
         to be sent to iCloud. Note: enabling this could result in Apple rejecting your app.
    -->
    <preference name="BackupWebStorage" value="none" />

    <feature name="StatusBar">
      <param name="ios-package" value="CDVStatusBar" onload="true" />
    </feature>
</widget>
```

widget id는 이후 iOS나 android 프로젝트에서 앱의 UUID로 지정된다. 그리고 widget name은 각 플랫폼의 앱의 이름으로 지정된다. 이 두가지를 우리가 원하는 정보로 변경해야 한다. 아래는 우리가 원하는 정보를 변경한 config.xml이다. 이 정보는 이후 각 플랫폼에 사용될 config.xml로 지정된다.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="net.saltfactory.tutorial.ioinc.sfhybridemo" version="0.0.1" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>SFHybridDemo</name>
    <description>
        Ionic Framework를 이용한 하이브리드 앱 데모
    </description>
    <author email="saltfactory@gmail.com" href="http://blog.saltfactory.net">
      하이브레인넷 부설연구소 모바일 서비스 연구지원
    </author>
    <content src="index.html" />
    <access origin="*" />
    <preference name="fullscreen" value="true" />
    <preference name="webviewbounce" value="false" />
    <preference name="UIWebViewBounce" value="false" />
    <preference name="DisallowOverscroll" value="true" />

    <!-- Don't store local date in an iCloud backup. Turn this to "cloud" to enable storage
         to be sent to iCloud. Note: enabling this could result in Apple rejecting your app.
    -->
    <preference name="BackupWebStorage" value="none" />

    <feature name="StatusBar">
      <param name="ios-package" value="CDVStatusBar" onload="true" />
    </feature>
</widget>
```

프로젝트를 생성한 이후 우리는 이제 우리가 원하는 iOS와 Android 앱을 개발하려고 한다. cordova를 사용하여 개발해본 경험이 있다면 cordova 프로젝트를 생성한 이후 target 플랫폼을 추가하는 명령어를 사용해서 플랫폼을 추가한다는 것을 알 것이다. ionic도 cordova를 기본으로 만들어진 것이기 때문에 cordova와 동일하게 target 플랫폼을 추가하는 명령어를 그대로 사용하고 있다. 다음과 같이 각각 iOS와 android 플랫폼을 추가한다.

```
ionic platform add ios
```
```
ionic platform add android
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/cd6dd929-b6cc-4f34-aacb-668042ca1702)

ionic platform add 명령어로 플랫폼을 추가하면 ionic 프로젝트에 개발되는 플랫폼이 추가되는 것을 확인할 수 있다. 우리가 만든 ionic 프로젝트 디렉토리 밑에 있는 plaforms라는 디렉토리 밑에 android와 ios 디렉토리가 생성된 것을 확이할 수 있고 각각 해당되는 파일들이 만들어진 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/08feb171-0959-480c-8008-55e18723bf56)

ioinc은 cordova를 이용하여 만들어진 framework이기 때문에 cordova의 명령어를 동시에 사용할 수 있다. 현재 프로젝트에 설치된 platform이 어떤 것이 있는지 확인하기 위해서 cordova의 명령어로 확인할 수 있다.

```
cordova platform list
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4b42fbbc-6847-42f1-aba1-12bb7b898e56)

cordova platforma list라는 명령어를 사용해서 확인하면 현재 ionic 프로젝트에 android와 ios 플랫폼이 설치되어 있고 cordova 3.5.0 으로 만들어진 것을 확인할 수 있다.

이제 iOS 디바이스로 빌드를 해보자. 다음과 같이 ionic 프로젝트를 iOS 플랫폼으로 빌드할 수 있다.

```
ionic build ios
```

에러 없이 빌드가 성공하면 ** BUILD SUCCEEDED ** 라는 메세지를 받게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/de89185c-ce3d-4850-a04c-ff8deb7cfd36)

빌드가 성공적으로 끝나면 앱이 성공적으로 빌드 되었는지 시뮬레이터를 이용해서 확인할 수 있다. 다음과 같이 ionic emulate 명령어로 iOS 앱을 실행해보자.

```
ionic emulate ios
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c3cd32e1-17b4-4e18-93c3-589389fbe2aa)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/40fc27f2-1cfd-480d-b93f-5da0fa1edfcf)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f2c28938-b1af-4204-b123-b238c5479a21)

ionic emulate ios 명령어를 실행하면 build된 앱이 ios 시뮬레이터에 설치가 되어서 기본적으로 만들어진 앱이 동작하는 것을 확인할 수 있다.

다음은 android 플랫폼을 빌드해보자.

```
ionic build android
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f7b7a082-20c1-4cba-a43c-31e399f6dc0f)

android 플랫폼 역시 빌드가 성공적으로 마치면 BUILD SUCCEEDED 라는 메세지를 보게 되는데 성공적으로 빌드가 마치면 android 에뮬레이터로 실행해보기로 한다.

```
ionic emulate android
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d73abc54-a741-4d73-bb69-0178400c0b9b)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/caf38c8e-d301-4621-8169-5204c01857aa)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8a7a42eb-b1ab-49a5-8e8b-777526d2c67c)

ionic emulate android 명령어로 android 플랫폼에 빌드에 성공한 앱을 성공적으로 실행해서 확인할 수 있다. 하지만 android 에뮬레이터는 정말... 최악으로 느리다. 아마 에뮬레이터로 android 앱을 개발하는 개발자는 없을 것 같다. 그래서 android는 디바이스로 실행시켜서 확인하는 작업이 반드시 필요하다.
ionic run은 안드로이드 디바이스로 앱을 실행할 수 있게 해준다. 다음과 같이 ionic run 명령어를 이용하여 앱을 android 디바이스로 설치를 할 수 있다. 먼저 android 디바이스를 컴퓨터에 USB로 연결한 뒤 다음 명령어를 실행해보자.

```
ionic run android
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6a35e411-a00f-4c15-9568-789b7c954290)

ionic 명령어로 빌드하고 에뮬레이터나 디바이스로 실행시켜서 앱의 구동을 확인할 수 있다. 하지만 하이브리드 앱을 개발하면 HTML이나 JavaScript, CSS와 같이 빌드가 새로 필요하지 않는 웹 자원 개발을 하는데 변경될 때마다 디바이스로 빌드하고 확인하는 작업은 정말 개발 생산성을 떨어트린다. 실제 빌드하여 설치하는 시간은 최소 몇분은 기다려야하기 때문이다. KTH에서 개발했던 Appspresso에서는 이러한 시간을 단축하기 위해서 On the fly라는 기능을 제공하였다. 이것은 가상의 서버를 동작시켜 HTML, JavaScript, CSS와 같이 컴파일이 필요하지 않는 웹 자원의 수정사항을 업데이트하면 바로 확인할 수 있게 해서 개발 생산성을 놀라울 정도로 올려주었다. ionic에서는 이와 비슷한 개념으로 cordova나 PhoneGap 이 제공하는 serve 기능을 사용하면 된다.
ionic 프로젝트 디렉토리에서 ionic serve 라는 명령어를 실행해보자.

```
ionic serve
```

이 명령어는 cordova가 가지고 있는 내장 서버가 동작하면서 웹 자원을 브라우저에서 업데이트를 확인 할 수 있게 도와준다. 위 명령어를 실행하면 서버가 동작하면서 컴퓨터의 디폴트 브라우저가 열리면서 앱이 실행되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2383043f-4f78-47f6-8978-4df6ca753d1a)


![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f18aeba1-17e2-4fcf-be1e-e08a02a07fa6)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/53ab6e2f-e0eb-481b-9181-f82f9530061f)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a7d3ef0d-5e53-4ad3-98b7-0ddbfc1dd2e3)

또한 이렇게 브라우저를 통해서 동작하는 앱을 web inspector를 이용해서 디버깅과 개발을 진행할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2246db93-d1e3-4cc2-a16e-02836045aaac)

이렇게 ionic serve 로 동작한 웹 앱은 웹 자원의 수정 사항이 있을 경우 자동으로 reloading을 하게 되어서 변경된 내용을 바로 웹에서 적용해서 변경된 사항을 확인할 수 있다. dash의 내용을 수정하기 위해서 www/templates/tab-dash.html의 파일을 열어서 다음과 같이 수정한다.

```html
<ion-view title="Dashboard">
  <ion-content class="has-header padding">
    <h1>ionic을 이용한 하이브리드 앱 개발</h1>
  </ion-content>
</ion-view>
```

HTML 파일을 수정하면 ionic serve는 변경된 파일을 감지하고 reloading를 실행한다. 그래서 브라우저에서 refresh 필요 없이 브라우저로 이동하면 다음과 같이 변경된 내용이 적용된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ce9b9c0e-3bc7-4271-8e8e-2b5ddf244054)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/97a0484d-4117-4e3d-92f6-5915ae4c664a)

이 기능은 하이브리드 앱 개발에서 매우 유용한 기능이다. 하이브리드 앱의 대부분 코드는 웹 코드로 진행되기 때문인데 네이티브 자원을 변경하지 않는 경우는 이렇게 쉽게 변경된 사항을 확인할 수 있기 때문이다. 주의할 점은 웹에서는 네이티브 코드의 사항을 확인할 수 없다. 디바이스의 자원을 사용한 네이티브코드는 웹 브라우저에서는 동작하지 않기 때문이다.

## 결론

하이브리드 앱 개발의 기술 발전은 PhoneGap(Cordova)와 AngularJS로 보다 편리하고 확장성 있는 개발 프레임워크를 점점 발전시켜가고 있다. 이전에 하이브리드 앱을 개발하기 위해서는 크로스 플랫폼 개발 프레임워크로 PhoneGap(Cordova)를 따로 사용하고 UI 개발을 위해서 AngularJS나 Sencha를 이용했지만 Ionic Framework는 이 두가지 개발환경을 통합하여 하이브리드 앱 개발에 최적화된 환경을 제공하고 있다. 앞으로 계속 연재로 Ionic Framework 를 사용하여 하이브리드 앱을 개발학 위한 방법을 소개하겠지만 Appspresso 이후 하이브리드 앱 개발에 가장 최적화된 프레임워크가 아닌가 생각이 된다. 좀더 자세히 Ionic framework를 이용하여 Cordova와 AngularJS를 기반의 하이브리드 앱을 개발하는 방법을 소개하고 이 두가지를 가지고 있는 Ionic framework의 장점을 소개하려고 한다.

## 참고

1. http://ionicframework.com/getting-started/

