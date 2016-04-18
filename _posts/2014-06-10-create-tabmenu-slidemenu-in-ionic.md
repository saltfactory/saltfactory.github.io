---
layout: post
title: Ionic framework를 이용하여 하이브리드 앱 개발하기 - 2. 탭메뉴, 슬라이드메뉴
category: hybridapp
tags: [javascript, hybrid, app, ionic, tabmenu, slidemenu]
comments: true
redirect_from: /240/
disqus_identifier : http://blog.saltfactory.net/240
---

## 서론

모바일 앱에서 가장 많이 사용하는 UI는 탭 메뉴와 슬라이드 메뉴이다. 만약 네이티브앱으로 Objective-C나 Java로 이런 UI를 만든다는 것은 꽤 복잡하고 어려운 일이 될 것이다. 하이브리드 앱은 HTML,CSS,JavaScript를 사용하여 웹 개발 기술로 UI를 만들 수 있다. 더구나 Ionic과 같은 프레임워크를 사용하면 built-in 되어 있는 템플릿을 사용하여 아주 간단하게 탭 메뉴와 슬라이드 메뉴를 제작할 수 있다. 이 포스트에서는 Ionic를 사용하여 이것을 개발하는 방법을 소개한다.

<!--more-->

![slidemenu in ionic](http://asset.hibrainapps.net/saltfactory/images/8bc6c9e2-8e8c-4a7d-9ef2-e4440801d7a8)

요즘 모바일 앱에서 흔히 볼 수 있는 메뉴가 바로 **슬라이드 메뉴(slide out menu)**이다. 이 메뉴는 모바일 SDK에 기본적으로 만들어진 메뉴는 아니다.

최근 안드로이드 SDK에서는 [fragments](http://developer.android.com/guide/components/fragments.html)를 이용하여 이전보다는 쉽게 구현할 수 있지만 역시나 기본적으로 만들어지는 컴포넌트는 아니다. 그래서 iOS 개발자나 android 개발자들은 오픈소스를 이용해서 슬라이드 메뉴를 구현하고는 한다.

웹 앱을 만들때도 마찬가지이다. jQuery나 또는 CSS transition animation을 이용해서 슬라이드 메뉴를 만들어 사용하는데 [Ionic](http://ionicframework.com/)에서는 개발자들이 가장 많이 사용하는 메뉴를 [템플릿](http://ionicframework.com/getting-started/)으로 만들어 두었다. 그래서 프로젝트를 생성할 때 어떤 메뉴를 가진 앱을 만들지 선택하여 간단하게 슬라이드 메뉴나 탭 메뉴 등 사용자들이 많이 사용하는 UX를 쉽게 구현할 수 있다. 우리가 Ionic을 선택한 가장 큰 이유중 하나가 바로 슬라이드 메뉴를 공식적으로 지원하고 있기 때문이다.

이전 글(http://blog.saltfactory.net/239)에서 우리는 Ionic을 이용해서 프로젝트를 생성하는 방법을 살펴보았다. Ionic은 프로젝트를 생성할 때 이미 템플릿으로 간단한 기본 앱을 만들어지게 해주는데 이것을 ionic에서는 app template 라고 부르고 있다. app templates는 크게 **blank**, **tabs**, 그리고 **sidemenu**가 있다.

## blank 템플릿

첫번째, blank를 살펴보자. ionic 프로젝트를 blank로 만들기 위해서는 프로젝트 생성할 때 app template로 blank로 지정한다.

```
ionic start sf-hybrid-demo blank
```

![blank app template](http://asset.hibrainapps.net/saltfactory/images/2e23accd-7bd9-4a7e-aa98-f297cd9fafd7)

blank 템플릿을 선택해서 프로젝트를 생성하면 ionic의 리파지토리에서 **ionic-starter-blank** 템플릿을 가져와서 프로젝트를 생성하는 것을 확인할 수 있다. 그럼 blank 템플릿으로 앱을 만들면 어떻게 만들어지는 확인해보자. 우리는 이전 포스팅에서 하이브리드 앱을 개발할 때, HTML, JavaScript, CSS와 같은 웹 코드는 디바이스에서 확인하지 않고 ionic serve를 이용해서 웹에서 확인 하는 방법을 살펴보았다. 다음과 같이 생성된 프로젝트 디렉토리 안에서 `ionic serve` 명령어를 실행한다.

```
ionic serve
```
![blank preview](http://asset.hibrainapps.net/saltfactory/images/0e0a783c-1ac6-40ad-9b78-087e9f59b06e)

blank 템플릿은 다른 특별한 메뉴 없이 header (또는 titlebar)를 가진 앱을 기본적으로 만들어 주는 것을 확인할 수 있다.

## tabs 템플릿

두번째, ionic는 iOS에 가장 기본이 되는 탭 메뉴를 app template로 만들어 두었다. 하이브리드 앱의 장점은 디바이스의 화면 비율에 상관없이 하나의 코드로 모든 디바이스에 동일한 UI를 만들어낼 수 있는 것이다. (물론 iOS UI를 android에 사용하는 것은 장점이라고 말하고 싶지 않다. 이미 각 디바이스의 사용자들은 특정 디바이스에 최적화된 UI에 익숙해져 있기 때문에 iOS와 android의 동일한 UI를 제공하는 것이 장점이라고는 생각하지 않는다. 하지만, 동일한 플랫폼에서 다른 디바이스들은 생각이 다르다. iPhone4와 iPhone3의 해상도 차이다, iPhone5, iPhone4의 스크린 사이즈 차이, 수많은 Android 디바이스의 해상도와 화면크기의 차이를 고려해보면 단일 코드로 여러 디바이스를 모두 최적화로 적용할 수 있다는 것은 한 개발자가 다양한 디바이스를 고려하지 않고 개발하기에 매우 큰 강점이라고 할 수 있다.)

ionic 명령어를 사용하여 프로젝트를 생성할 때 app template으로 tabs를 지정한다.

```
ionic sf-hybrid-demo tabs
```

![tabs in ionic](http://asset.hibrainapps.net/saltfactory/images/d425c493-de60-4557-8efe-9d9c1ebcb034)

탬플릿으로 tabs를 지정하여 프로젝트를 생성하면 ionic의 리파지토리에서 ionic-starter-tabs라는 템플릿을 가져와서 프로젝트를 생성하는 것을 확인할 수 있다. 위에서와 동일하게 ionic serve를 이용해서 앱을 실행시켜 확인해보자.

```
ionic serve
```

![tabs preview {width:45%}](http://asset.hibrainapps.net/saltfactory/images/442dc39e-b8d8-46e5-9fd5-4c99a1a4a87f)
![tabs preview {width:45%}](http://asset.hibrainapps.net/saltfactory/images/64aa8380-59db-4fa8-82c6-d66e279e7966)

tabs는 우리가 흔이 iOS 환경이 익숙해져 있는 UI이다. 뿐만 아니라 Android도 tab UI를 공식적인 컴포넌트로 지원하고 있지만 Android는 기본적으로 tab이 하단에 있는 것이 아니라 상단에 존재한다.

> tab을 상단에 배치시키려면 어떻게해야할까?

여기서 우리는 하이브리드 앱 개발의 장점을 확인할 수 있다. 우리는 UI를 웹 리소스로 만들었다. 그래서 UI를 CSS로 다룰수 있는데 `www/css/style.css` 파일을 열어서 다음과 같이 tabs의 css 속성을 추가한다.
`tabs`의 `position`을 `top:0` 으로 지정하여 화면의 최 상단에 위치시키려는 것이다.

```css
.tabs {top:0;}
```

우리는 ionic serve를 이용해서 확인하고 있는데 이것은 파일이 변경되면 자동으로 반영되기 때문에 다시 브라우저로 가서 변경된 사실을 확인해보자. 그런데 아래 그림과 같이 tabs은 화면의 상단에 위치되었는데 header(또는 titlebar)가 tabs 메뉴를 가려버리는 문제가 발생한다.

![tab hidden problem](http://asset.hibrainapps.net/saltfactory/images/5ed27145-8846-4dcd-b61e-8c1a161cc3b1)

우리는 android UI와 같이 구성하기 위해서 작업을 하고 있는데 android는 tabs를 사용하면 header가 보이지 않는다. 그래서 우리는 ionic 템플릿에서 tabs에 포함된 화면에 header를 보이지 않게 해본다. ionic에서 UI 템플릿 파일은 `www/templates` 안에 존재한다. 이후에 templates 구조와 화면에 출력되어지는 원리에 대해서 소개를 할 것이기 때문에 여기서는 간단히 `tabs.html`이 tabs 메뉴를 구성하는 템플릿이고 각각 메뉴를 눌렀을 때 나타나는 화면은 `tab-dash.html`, `tab-friends.html`, `tab-account.html` 이라고 생각하자. 그럼 앱이 실행할 때 첫번째 나타나는 화면은 `tab-dash.html`이다. 이 파일을 열어서 다음과 같이 네비게이션바(nav-bar)를 숨긴다고 `ion-view`에 속성을 추가하자. (이 HTML 코드를 보면 우리가 흔히보는 HTML의 엘리먼트가 아니라는 것을 보면 알 수 있다. 이것을 설명하기 위해서는 [AngularJS](https://angularjs.org/)의 [directive](https://docs.angularjs.org/guide/directive)를 설명해야한다. 이것은 이후에 ionic의 view 동작 원리에 대해서 설명할때 함께 설명하도록 하겠다.)

```html
<ion-view title="Dashboard" hide-nav-bar="true">
  <ion-content class="has-header padding">
    <h1>Dash</h1>
  </ion-content>
</ion-view>
```

변경된 내용을 확인해보자. 아래와 같이 tabs을 가렸던 header(또는 titlebar 또는 navigation bar)가 사라진 것을 확인 할 수 있다.

![tab top poistion](http://asset.hibrainapps.net/saltfactory/images/6ca2d12e-56a1-4117-aed3-2095c28dd2fe)

## slidemenu 템플릿

세번째로, sidemenu는 슬라이드 메뉴를 구성하는 템플릿이다. ionic을 선택한 가장큰 이유는 템플릿 자체에서 슬라이드 메뉴를 만들 수 있고 쉽게 메뉴별 html 템플릿을 따로 관리할 수 있기 때문이였다. 슬라이드메뉴를 가진 앱을 만들기 위해서는 프로젝트를 생성할 때 템플릿으로 sidemenu를 지정한다.

```
ionic start sf-hybrid-demo sidemenu
```

![slidemenu in ionic](http://asset.hibrainapps.net/saltfactory/images/d08faa84-44cb-4b31-8192-b24e66ab790a)

템플릿으로 sidemenu를 선택하면 리파지토리에서 ionic-starter-sidemenu 템플릿을 가져와서 프로젝트를 생성하는 것을 확인할 수 있다. 만들어진 프로젝트를 ionic serve로 확인해보자.

```
ionic serve
```

![slidemenu preview {width:45%}](http://asset.hibrainapps.net/saltfactory/images/43a6997e-8522-4a73-933b-f8b34085f849)
![sidemenu preview {width:45%}](http://asset.hibrainapps.net/saltfactory/images/b569d39e-1129-4d44-a6fb-1473c18013da)

간단하게 슬라이드 메뉴가 만들어진 것을 확인할 수 있다. 최근 슬라이드메뉴를 나타나게 하기 위해서 햄버그메뉴 아이콘도 자동으로 header에 toggle 버튼으로 만들어진 것을 확인할 수 있다. 뿐만 아니라 화면을 드래그해서 오른쪽으로 하면 슬라이드 메뉴가 나타나고 왼쪽으로 드래그하면 나타났던 메뉴가 닫히게 된다. 현재 우리는 ionic serve를 이용해서 디버깅하고 있는 것이지만 실제 이 앱이 모바일에 설치하게 되면 **touch**의 **swipe 제스쳐**를 인식해서 메뉴가 열리고 닫히게 된다. 이렇게 슬라이드 메뉴를 구성하는 것도 터치를 인식해서 프로그래밍하는 것도 상당하게 많은 시간이 소비되며 복잡하고 어려운 일인데, ionic은 이것을 매우 간단하게 프로젝트를 생성할 때 sidemenu라는 키워드 하나만 추가하면 만들어 준다. 개발자들은 슬라이드 메뉴를 구현하는데 더이상 골머리를 썩을 필요가 없게 되었다. 또한 슬라이드 메뉴에서 보이는 각 메뉴의 뷰들은 독립적은 template을 가지고 만들어진다. 즉, 메뉴에 보이는 화면마다 다른 html 파일로 분리해서 개발도 관리도 편리하다. 슬라이드메뉴를 구성할 때는 `www/templates/menu.html` 파일과 각각 해당되는 뷰 html 템플릿으로 구성된다는 것을 `www/templates` 디렉토리 확인하면 알 수 있다.

슬라이드 메뉴는 기본적으로 **왼쪽**에 나타나게 만들어진다. 하지만 페이스북 체팅화면이나 다른 앱들을 보면 슬라이드 메뉴가 **오른쪽**에 위치하는 것을 볼 수 있다. 그러면 오른쪽으로 슬라이드 메뉴를 위치시키기 위해서는 어떻게 해야할까? 다음과 같이 `www/templates/menu.html` 파일을 열어서 수정한다. 아래 수정하는 내용은 슬라이드 메뉴가 위치하는 곳을 `left`에서 `right`로 변경하겠다는 코드이다. 기본은 left 로 지정되어 있다.

```html
<ion-side-menus>

  <ion-pane ion-side-menu-content>
    <ion-nav-bar class="bar-stable nav-title-slide-ios7">
      <ion-nav-back-button class="button-clear"><i class="icon ion-ios7-arrow-back"></i> Back</ion-nav-back-button>
    </ion-nav-bar>
    <ion-nav-view name="menuContent" animation="slide-left-right"></ion-nav-view>
  </ion-pane>

  <ion-side-menu side="right">
    <header class="bar bar-header bar-stable">
      <h1 class="title">Right</h1>
    </header>
    <ion-content class="has-header">
      <ion-list>
        <ion-item nav-clear menu-close href="#/app/search">
          Search
        </ion-item>
        <ion-item nav-clear menu-close href="#/app/browse">
          Browse
        </ion-item>
        <ion-item nav-clear menu-close href="#/app/playlists">
          Playlists
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-side-menu>
</ion-side-menus>
```

슬라이드 앱의 슬라이드 메뉴 버튼은 각 화면의 **header**에 나나탄다. 이 앱이 처음 열릴 때 나타나는 뷰는 바로 `www/templates/playlists.html` 이다. 이 파일을 열어서 슬라이드 메뉴의 버튼의 위치를 `left`에서 `right`로 변경한다. 그리고 **menu-toggle의 방향**도 `left`에서 `right`로 변경한다. 이렇게 변경함으로 슬라이드 메뉴의 에니메이션이 오른쪽에서 왼쪽으로 동작하게 된다.

```html
<ion-view title="Playlists">
  <ion-nav-buttons side="right">
    <button menu-toggle="right" class="button button-icon icon ion-navicon"></button>
  </ion-nav-buttons>
  <ion-content class="has-header">
    <ion-list>
      <ion-item ng-repeat="playlist in playlists" href="#/app/playlists/{{playlist.id}}">
        {{playlist.title}}
      </ion-item>
    </ion-list>
  </ion-content>
</ion-view>
```

코드를 변경했으면 다시 브라우저로 가서 변경된 화면을 확인해보자. 아래와 같이 변경된 코드가 반영되어서 슬라이드 메뉴가 오른쪽에서 동작하고 슬라이드메뉴 버튼로 오른쪽으로 변경된 것을 확인할 수 있다.

![right slidemenu privew {width:45%}](http://asset.hibrainapps.net/saltfactory/images/a9ceb3ec-952f-408f-a9c8-dd28b410cd82)
![right slidemnu privew {width:45%}](http://asset.hibrainapps.net/saltfactory/images/fd0b5d20-bb04-4f63-a3f0-c66d5370880d)

## 결론

ionic framework는 하이브리드 앱을 개발하는데 최적화된 코드를 제공한다. ionic는 복잡하게 HTML과 CSS를 만들지 않아도 app templates를 이용해서 앱을 만들기에 필요한 코드를 최초 제공해준다. 이때 app templates는 현재 개발자들이 가장 많이 사용하고 있는 메뉴를 구성해서 만들어서 제공한다. 아무것도 없이 header만 존재하는 단일 blank, 여러 tab을 만들어서 tab을 눌러서 메뉴가 변경되고 각 메뉴마다 해당하는 화면을 구성하는 tabs, 그리고 최근 앱에서 쉽게 볼 수 있는 보편화된 슬라이드 메뉴를 sidemenu라는 app templates로 만들어서 프로젝트 생성할 때 쉽게 구성할 수 있게 제공한다. 개발자들은 더이상 처음 앱을 만들 때 앱의 레이아웃을 만들기 위해서 골머리를 썩지 않아도 된다. ionic에서 제공하는 기본 app templates는 안정적이며 기본 레이아웃을 바로 사용해도 될 만큼 디자인도 이쁘게 되어 있다. 더이상 고민하지 않고 ionic framework로 프로젝트를 바로 시작해보길 바란다.

