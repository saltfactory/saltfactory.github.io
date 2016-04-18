---
layout: post
title: Adobe Edge Inspect CC를 사용하여 모바일 웹 디버깅하기
category: mobile
tags:
  - mobile
  - web
  - adobe
  - inspect
comments: true
images:
  title: 'http://asset.hibrainapps.net/saltfactory/images/7b052ffe-3eeb-4172-ade0-4a67cd263de0'
---

## 서론

모바일 웹을 개발할 때 보통 브라우저를 열어서 모바일 사이즈에 맞게 개발하거나, 반응형 웹으로 개발을 하려고 한다. 데스트탑에서 브라우저를 열어서 모바일 웹을 개발하려면 모바일 웹 사이즈에 맞게 브라우저를 줄여야한다. Google은 이런 불편함을 해결하기 위해서 Chrome 브라우저의 개발자 도구에 [Toggle Deivce Mode](https://developer.chrome.com/devtools/docs/device-mode)을 제공한다. 데스크탑에서 모바일 디바이스 사이즈에 최적화된 웹을 만들 수 있게 되었다. 하지만 이것은 데스크탑이다. 모바일 디바이스에서 동작하는 웹을 보기 위해서는 내 데스크탑을 서버로 동작시켜야하고, 디바이스에서 데스크탑의 URL을 입력해서 접근해야한다. [Adobe Edge Inspect CC](https://creative.adobe.com/products/inspect)를 사용하면 이 과정을 아주 쉽게 처리할 수 있고 모바일 디바이스에서 동작하는 웹을 디버깅할 수 있다.

<!--more-->

## Adobe 계정

Adobe는 CC 관련 소프트웨어를 사용하기 위해서는 반드시 Adobe 계정 로그인을 요구하고 있다. Adobe Edge Inspect CC는 Adobe 계정만 있으면 **무료**로 사용할 수 있기 때문에 Adobe 계정이 없으면 계정을 생성한다.

## Adobe Edge Inspect CC

우선 가장 먼저 해야할 것은 **Adobe Edge Inspect CC** 어플리케이션을 다운로드 받는 것이다. Adobe Edge Inspect CC는 기본적으로 세가지를 다운로드 받아야한다.

- [Adobe Edge Inspect 데스크탑 어플리케이션](https://creative.adobe.com/products/inspect)
- [iPhone](http://www.adobe.com/go/inspect_ios_app) 또는 [Android](http://www.adobe.com/go/inspect_android_app) 어플리케이션
- [Chrome Browser Extension](https://chrome.google.com/webstore/detail/adobe-edge-inspect-cc/ijoeapleklopieoejahbpdnhkjjgddem)


**Adobe Edge Inspect** 다운로드 페이지에서는 개발자의 경험 수준과 사용하는 곳을 입력한 이후 다운로드 받을 수 있다.

![Adobe Edge Inspect 다운로드](http://asset.hibrainapps.net/saltfactory/images/a4df3894-9c17-4f57-86cf-b01693d4aa01)

만약 데스크탑에서 [Adobe Creative Cloud](http://www.adobe.com/creativecloud.html)를 설치하지 않았다면 **Adboe Creative Cloud**를 다운로드 받아서 설치해야한다. 만약 **Adobe CC** 제품 중에 하나라도 설치가 되어 있다면 이것은 자동으로 설치가 되어 있을 것이다. 그리고 앞으로는 **Adobe Creative Cloud**에서 직접 필요한 애플리케이션을 설치하면 된다.

![Adobe Creative Cloud 애플리케이션 설치화면](http://asset.hibrainapps.net/saltfactory/images/edff5d90-bdc4-48fb-b419-604bc30dbd40)

**Adobe Creative Cloud** 설치를 완료하면 메뉴바에서 **Adobe Creative Cloud**아이콘이 생긴다. 이것을 클릭하면 Adobe Account 계정으로 로그인을 할 수 있다.

![Adobe Creative Cloud 로그인](http://asset.hibrainapps.net/saltfactory/images/e8186c0c-2d01-4129-9a80-766b37a856fd)

로그인 후 **Adobe Edge Inspect**가 다운로드가 된다.

![Adobe Edge Inspect 다운로드](http://asset.hibrainapps.net/saltfactory/images/f7a2d541-3062-4536-aaa3-f753e0e3e561)


다운로드가 완료되면 Adobe Inspect CC 데스크탑 어플리케이션을 실행한다. Mac OS X에서는 실행후 **메뉴바**에 실행되고 있는 상태가 나타난다. 메뉴바의 가장 첫번째 아이코인 **In** 이라고 표시된 것이 Adobe Inspect CC가 실행할 때 나타나는 것이다.

![menu bar](http://asset.hibrainapps.net/saltfactory/images/04de388d-de61-4d2f-9592-6ba744259bea)

## Chrome Browser Extension


다음은 **Adobe Edge Insect CC Chrome Browser Extension**을 설치한다. 크롬 웹 스토에서 Adobe Edge Inspect CC를 검색하여 설치하거나, http://www.adobe.com/go/inspect_chrome_app 를 클릭하여 설치한다.

![chrome browser Extension 설치](http://asset.hibrainapps.net/saltfactory/images/122f564a-a7ff-4604-bb88-67d2b4232f81)

설치 후 Chrome Browser Extension 도구 모음에 Adobe Edge Inspect 아이콘이 표시된다.

![Chrome browser extension 아이콘](http://asset.hibrainapps.net/saltfactory/images/098b7d41-a4da-4c4f-a012-191826db0d39)

아이콘을 클릭할 때 만약 **Adobe Edge Inspect**를 실행하지 않고 **Chrome Extension**을 실행하게 되면 다음과 같은 경고창이 나타난다.

![Inspect 경고창](http://asset.hibrainapps.net/saltfactory/images/4fdac3f4-8f3f-4ba7-a205-daf47b0c9731)

Chrome Extension을 사용하기 위해서는 반드시 위에서 다운받은 Adobe Edge Inspect 데스크탑 어플리케이션이 먼저 실행되어져야 한다. 실행되지 않았다면 데스크탑 어플리케이션을 실행하고, 실행되어 있다면 Chrome extension을 클릭하면 다음과 같은 화면이 나타날 것이다.

![Chrome extension 실행](http://asset.hibrainapps.net/saltfactory/images/9b5a9eb7-87ab-4d87-826e-83210becfe52)

이렇게 데스크탑의 내부 IP 정보와 함께 모바일 디바이스에서 엑세스 하기를 기다리고 있다.

## 모바일 앱 실행하기

모바일 에서 Adobe Edge Inspect CC 모바일 버전을 다운로드 받은 이후 같은 네트워크 상에서 실행하면 다음과 같은 화면이 나타난다. 블로그 포스팅을 위해서 iMac을 사용해 모바일 디바이스에서 탐색된 목록에 iMac도 나타나고 있고, 기존에 사용하여 저당된 MacBook Pro도 있다. 한번 연결을 시도한 이후는 그림과 같이 목록에 저장이 되어 있기 때문에 다음에 실행할 때는 특별한 연결 작업 없이 바로 시작할 수 있다.

![데스크탑 목록](http://asset.hibrainapps.net/saltfactory/images/69bd93e2-fca2-400a-a0d5-95e829dbbd5d)

새롭게 추가한 iMac을 연결하기 위해서 iMac을 선택했다. 모바일에서 데스크탑을 선택할 때, 만약 모바일 디바이스와 데스크탑의 연결이 처음이라면 다음과 같이 **PASSCODE**를 사용하여 모바일 디바이스와 데스크탑의 인증작업을 해야한다. Chrome Extension의 화면에는 다음과 같이 Passcode를 입력할 입력화면이 나타난다.

![chrome extension passcode](http://asset.hibrainapps.net/saltfactory/images/cc64c306-6aaa-451a-9a90-708266d36a3e)

모바일 디바이스에서는 다음 그림과 같이 Passcode가 나타난다.

![passcode](http://asset.hibrainapps.net/saltfactory/images/0ef7211a-81dc-4215-bc56-defd52b28ac5)

모바일에 나타난 Passcode를 Chrome extension의 Passcode 입력화면에 입력하면 두 디바이스간의 인증이 완료된다.


## 모바일 웹 디버깅


위에서 **Adobe Edge Inspect CC**를 사용하기 위한 Chrome Browser Extension을 설치했을 것이다. Chrome 도구 모음에 있는 Adboe Edge Inspect CC Extension을 클릭하면 다음과 같이 나타날 것이다.

> Adobe Edge Insepect CC는 데스트탑과 모바일 디바이스를 서로 연결하는데 같은 네트워크 상에 존재할 때 가능하다.

![adobe edge inecpt cc exension](http://asset.hibrainapps.net/saltfactory/images/4b6b5c7f-4b91-44a4-a0c2-ec1b85f33d19)

**Edge insepct CC** 오른쪽에 보이는 토글키를 **ON**으로 켠다. 그러면 *Synchronized Browsing is off*라고 되어 있던 메세지가 *Waiting for connection...*으로 변경이 되면서 extension 아이콘 색깔도 변경이 된다.

![turn on](http://asset.hibrainapps.net/saltfactory/images/bea67ba1-1af0-4ef2-9774-b056c9eb9ad4)

## 모바일 앱 실행하기

이제 모바일 디바이스에 설치한 **Edge Inspect**를 실행한다. 같은 네트워크 상에 데스크탑의 **Adobe Edge Inspect CC**가 실행되어 있고 **Chrome Extension**이 켜져 있다면 자동으로 다음과 같이 목록에 나타날 것이다. 만약 나타나지 않으면 **+** 버튼을 클릭하여 extension에 나타난 데스크탑 **IP**를 직접추가하면 된다.

![데스크탑 목록](http://asset.hibrainapps.net/saltfactory/images/8c35ae67-3e5d-45e5-a64f-e5502f88f2dd)

목록에 나타난 데스크 탑을 클릭해보자. connection이 진행되고 난 뒤 다음과 같이 Chrome Browser에 열고 있던 웹 사이트가 모바일 화면에 그대로 미러링 된 것을 볼 수 있다. 반응형 웹으로 만들어진 블로그라 모바일에 데스크탑과 다르게 나타난다. 실제 모바엘 웹을 개발하거나 반응형 웹을 개발할 때 데스크탑과 다른 모바일 웹을 실시간으로 비교해서 보면서 디버깅할 수 있게 되었다.

![테스크탑 커넥션](http://asset.hibrainapps.net/saltfactory/images/c8bfe0c2-55ce-4afd-b8e4-0db828a499a0)

Chrome extension은 다음과 같이 모바일 디바이스가 연결된 것을 확인할 수 있다.

![exteions의 모바일 연결정보](http://asset.hibrainapps.net/saltfactory/images/f7a569aa-c878-4cfc-aed0-5d979876ad8b)

모바일 화면을 살펴보면 **타이틀 바** 때문에 풀 스크린의 모습을 볼 수가 없다. Chrome extension을 다시 열어보면 extension 하단에 아이콘들이 있는데 첫번째부터 **Refresh**, **Show full screen on devices**, **Request screenshots** 그리고 **Open folder containning screenshots** 이다. 두번째 아이콘 **Show full screen on devices**를 클릭해보자. 그러면 다음과 같이 아이콘이  **Exit full screen on devices**로 변경이 된다.

![](http://asset.hibrainapps.net/saltfactory/images/8cb10b5e-f1a3-4973-8299-33bfebad9ff4)

모바일 디바이스 화면을 살펴보자. 다음과 같이 타이틀바가 사라지고 full screen 화면을 볼 수 있다.

![full screen on devices](http://asset.hibrainapps.net/saltfactory/images/fc630646-0c65-45d6-bfc3-6e0ca11aaf05)

Chome extension에 나타난 모바일 디바이스 옆에 **< >** 코드 아이콘을 클릭해보자. 다음과 같이 익숙한 창이 나타난다. 웹 개발을 할 때 자주보는 [Chrome DeveTools](https://developer.chrome.com/devtools) 와 아주 닮은 inspector를 볼 수 있다. [Weinre](http://people.apache.org/~pmuellr/weinre-docs/latest/) 로고가 나타나는데 이것은 Web Inspector Remote의 약자로 Webkit 기반의 브라우저를 원격 디버깅하기 위해서 개발된 프로젝트였다. iOS와 Android 디바이스 모두 사용 가능하다.

![weinre](http://asset.hibrainapps.net/saltfactory/images/833eec47-81be-4cdc-98af-9e0de347cba7)

Elements 탭을 클릭 후 console 창을 열어서 (또는 Console을 탭한 후) 다음과 같이 입력해보자.

```javascript
document.body.style.backgroundColor="pink";
```

![](http://asset.hibrainapps.net/saltfactory/images/fad52a47-451d-4676-b987-bfbddca80875)

모바일 디바이스를 살펴보자. 이것은 모바일에 나타난 웹에 바로 적용이 된다. **모바일 웹**에만 적용이 되는 것이다. 데스크탑에 열린 웹은 적용되지 않는다.

![](http://asset.hibrainapps.net/saltfactory/images/a87199e1-b05f-42ad-9204-721fadc457ed)


## 결론

모바일 웹을 디버깅하기 위해서 가장 훌륭한 방법은 모바일 디바이스 브라우저에서 직접 모바일 웹에 접근하는 것이다. 하지만 현실적으로 모바일 브라우저에서 개발을 하는 것은 어렵기 때문에 대부분의 개발자들은 데스크탑의 브라우저를 활용한다. 최신 모바일 웹 브라우저는 WebKit 기반으로 만들어져있기 때문에 데스크탑에서 WebKit 기반으로 만들어진 Chrome을 사용하여 개발을 많이 하지만 결국 마지막은 모바일 웹 브라우저에서 테스트를 진행해야한다. Adobe Edge Inspect는 데스크탑에서 모바일 웹을 개발하면서 모바일 디바이스에 모바일 웹이 동작하는 것을 디버깅할 수 있는 환경을 제공하고 있다. 데스크탑에서 모바일 웹을 모바일 디바이스에서 어떻게 적용되는지 실시간으로 확인할 수 있다. 데스크탑에서 모바일 브라우저에 열리 페이지의 DOM을 조작하거나 Style을 변경할 수 있고, JavaScript가 적용되는 것을 확인할 수 있다. Adobe Edge Inspect CC를 사용하여 모바일 환경에서 디버깅을 하기 위해서는 데스크탑 버전, Chrome Extension, 그리고 모바일용 Adobe Edge Inspect CC를 설치해야한다. 실험은 Mac과 iOS 디바이스에서 진행했지만 Windows와 Android 디바이스도 지원하고 있다. 이 어플리케이션을 사용하여 모바일 웹 개발에 많은 도움이 될 것으로 기대된다.


