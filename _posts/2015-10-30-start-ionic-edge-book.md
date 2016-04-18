---
layout: post
title: Ionic 하이브리드 앱 개발환경 설정 및 엣지있게 설명한 Ionic 책 예제 실습 방법
category: ionic
tags:
  - ionic
  - hybrid
  - html5
  - cordova
  - ios
  - android
comments: true
images:
  title: 'http://asset.hibrainapps.net/saltfactory/images/48133d68-b7e5-4434-b808-a81d59494aef'
---


## 서론

국내에 하이브리드 앱 개발 프레임워크인 [Ionic framework](http://ionicframework.com/)에 관한 책이 없는 가운데 Ionic의 개발자들이 직접 집필한 [Developing an Ionic Edge](http://bleedingedgepress.com/developing-ionic-edge/) 원서를  [엣지있게 설명한 Ionic](http://blog.saltfactory.net/books/ionic-edge/) 책으로 번역하게 되었다.

책이 나오는 것과 동시에 독자들이 책에 관해 궁금한 점을 메일로 문의를 하고 있다. 문의 내용중 가장 많은 질문 사항이 책에 포함된 Trendicity 앱을 빌드하는 방법이다.

이 책은 Ionic을 처음 접하거나 이제 막 하이브리드 앱 개발을 시작하는 개발자들에게 약간 이해하기 어려울 수도 있는 책이다. 특히 AngularJS, Node.js 그리고 Cordova에 대한 선행학습 없이 책을 접한다면 더욱 그럴 수 있는데 이메일로 문의하는 내용을 하나하나 답변하기에 시간이에는 답변이 지연되는 일이 생겨서 자주 하는 질문에 대한 내용을 따로 정리해서 책을 구입후 연구하시는데 도움이 드리고 싶어 포스팅을 하게 되었다.


<!--more-->

## 개발환경

하이브리드 앱을 개발하기 위해서 Ionic을 처음 접하시는 분들에 가장 많이 하는 질문이 어떻게 실행하는지에 대한 질문이다. 모든 프레임워크가 그러하듯 Ionic Framework 역시 기본적으로 필요한 패키지와 툴이 있다.

## Java

Ionic framework는 하이브리드 앱을 개발하기 위한 프레임워크이다. 가장 인기있는 디바이스는 iOS와 Android 디바이스인데 Ionic은 이 두가지 뿐만 아니라 다양한 디바이스에 크로스 플랫폼 앱을 개발할 수 있다. Android 앱을 개발하기 위해서는 Java 런타임 환경이 필요하다. 시스템에 Java가 설치되어 있지 않으면 http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html 에서 시스템에 맞는 Java를 설치한다. 개발을 위해 Java SE Development Kit을 다운 받아서 설치하는 것을 권장한다. **주의할 점은 Java 설치후 반드시 시스템에 JAVA_HOME 환경변수에 설치 경로를 지정해줘야한다.** 예를 들어 Mac에서는 최신 Java를 설치하면 다음과 같이 **JAVA_HOME** 환경변수가 만들어진다. **/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home**

그리고 PATH에 JAVA_HOME/bin 경로를 추가한다. **~/.bash_profile**을 열어 다음과 같이 JAVA 설정을 한다.

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home
export PATH=$PATH:$JAVA_HOME/bin
```

~/.bash_profile에 Java 설정이 끝나면 source로 시스템환경에 적용한다.

```
source ~/.bas_profile
```

Windows 사용자일 경우는 **시스템 환경변수** 등록하는 메뉴에서 지정하고 저장하면 된다.

## Android SDK

Ionic 프로젝트를 개발하면서 Android 에뮬레이터나 디바이스에 설치하거나 디버깅할 때 Android SDK가 필요하다. http://developer.android.com/sdk/installing/index.html 에서 SDK를 설치하면 된다. Android 플랫폼을 위한 플러그인 개발을 위해서는 Android Studio를 설치하면 되지만, Ionic이 Android 앱을 빌드하거 실행할 때는 Stand-Alone SDK Tools가 필요하다.

![](http://asset.hibrainapps.net/saltfactory/images/921e9a86-1f39-4f9b-a8a0-88d509b64dd9)

시스템에 맞는 SDK를 다운받아서 설치한다. **주의할 점은 JAVA_HOME과 마찬가지로 Android SDK를 설치한 이후에 ANDROID_HOME 을 환경변수로 등록해둬야한다.** 예를 들어 Android SDK 바이너리 파일을 다운받아 /Projects/Libraries/adt-bundle-mac-x86_64/** 경로에 압축을 풀었다면 ANDROID_HOME은 다음과 같이 된다. **/Projects/Libraries/adt-bundle-mac-x86_64/sdk**

위에 Java 설정과 마찬가지로 **~/.bash_profile** 파일을 열어서 Android SDK 설정을 한다. Android SDK는 안드로이드 앱을 개발할 때 사용하는 **tools/**와 **patform-tools/** 디렉토리를 시스템 PATH 변수에 추가를 해줘야한다.

```bash
export ANDROID_HOME=/Projects/Libraries/adt-bundle-mac-x86_64/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```
~.bash_profile 파일에 설정을 저장하고 시스템에 적용하기 위해서 source를 한다.

```
source ~/.bash_profile
```

## Node.js

Ionic의 개발 환경은 기본적으로 Node.js가 설치되어 있어야한다.

Node.js는 공식 사이트에서 다운로드하여 시스템에 맞는 설치파일을 가지고 설치하면 된다. https://nodejs.org/en/download/

![](http://asset.hibrainapps.net/saltfactory/images/426fe750-c0f2-4be0-a639-a7450e67256d)

```
node -v
```

![](http://asset.hibrainapps.net/saltfactory/images/7fb5911c-0fe5-4e0d-bb44-831a2cc72d89)

![](http://asset.hibrainapps.net/saltfactory/images/26f93107-88f5-47ee-8ee3-1aaa9e685c18)

최근 Node.js는 IO.js와 합쳐지면서 **v.4.x* 버전으로 업데이트 되었다. 아직 최신 node를 사용하게 되면 의존성 문제가 발생하기 때문에 **v0.12.x** 버전을 사용할 것을 추천한다.

또는 만약 Mac을 사용한다면 [Homebrew](http://brew.sh/)를 사용하여 간단하게 설치할 수 있다.

```
brew install node
```

또는 바이너리 파일을 다운 받아서 자신이 원하는 경로에 설치를 할 수 있다. 이 포스팅을 위해서 Node.js를 새롭게 설치했는데 바이너리 파일을 다운받아서 설치했다. Mac에서 **node-v0.12.7-darwin-x64.tar.gz**을 다운받아서 **/Projects/Libraries/node/node-v0.12.7-darwon-x64/** 경로에 설치를 할 경우, 다음과 같이 **~/.bash_profile** 파일에 node의 PATH을 추가한다.

```bash
export NODE_HOME=/Projects/Libraries/node/node-v0.12.7-darwin-x64
export NODE_PATH=$NODE_HOME/lib/node_modules
export PATH=$PATH:$NODE_HOME/bin:$NODE_PATH
```

위 내용을 저장하고 난 다음 시스템 환경 설정에 적용하기 위해서 source를 한다.

```
source ~/.bash_profile
```

## NPM 패키지 설치

Node.js가 설치되면 이제부터는 npm으로 필요한 패키지들을 설치할 수 있다. **npm install -g** 와 같이 **-g** 옵션이 붙은 것은 시스템 전체에서 사용할 수 있도록 Global 로 설치를 한다는 의미이다. 이런 패키지들은 대부분 CLI(command line interface)를 제공한다. Ionic 프로젝트를 개발할 때 기본적으로 필요한 npm 패키지들이 있다 Ionic을 설치하기 전에 미리 설치하는 것이 좋다.

## cordova

Ionic은 내부적으로 [Cordova](https://cordova.apache.org/)를 사용하여 디바이스에 디플로이를 시킨다. npm을 사용하여 cordova를 설치한다.

```
npm install -g cordova
```

![](http://asset.hibrainapps.net/saltfactory/images/d754e0cc-0a8f-4dbb-b92e-979ad109a70f)


## gulp

Ionic의 빌드시스템은 [gulp](http://gulpjs.com/)를 사용한다. gulp는 CLI 명령어를 제공하고 있기 때문에 global로 설치를 한다.

```
npm install -g gulp
```

![](http://asset.hibrainapps.net/saltfactory/images/999d14a0-a6ae-4a2b-9eb3-671c68254727)

## bower

Ionic은 내부적으로 하이브리드 앱 개발할 때 필요한 웹 컴포넌트들을 [bower](http://bower.io/)를 사용하여 가져오기 때문에 반드시 필요한 npm 패키지중에 하나이다.

```
npm install -g bower
```

## ios-sim

[ios-sim](https://github.com/phonegap/ios-sim) 은 PhoneGap 프로젝트를 iOS 시뮬레이터를 실행하기 위한 패키지이다. **npm install phonegap**을 설치하면 의존적으로 설치가 되기도 한다. cordova를 사용하는 ionic은 iOS 시뮬레이터로 테스트를 진행할 때 이 패키지를 사용하기 때문에 미리 설치하도록 한다. 이것은 Mac의 Xcode의 iOS simulator를 실행하는 것이기 때문에 Windows 사용자들은 설치할 수 없는 패키지이다.

```
npm install -g ios-sim
```

![](http://asset.hibrainapps.net/saltfactory/images/ac74fe14-2ada-4887-adcb-82f4e4d2eb0f)

## ios-deploy

[ios-deploy](https://github.com/phonegap/ios-deploy) 역시 PhoneGap 프로젝트를 Xcode 없이 iOS 디바이스로 앱을 설치하거나 디버깅하는 패키지이다. 실제는 하이브리드 앱을 iOS 디바이스에 설치하기 위해서는 Xcode를 열어서 설치해야하지만 이 패키지를 사용해 CLI(Command Line Interface)로 앱을 디바이스에 설치할 수 있다.

```
npm install -g ios-deploy
```

![](http://asset.hibrainapps.net/saltfactory/images/42620314-87c0-4282-8cd9-6b253c358f17)

만약 ios-sim과 ios-deploy 패키지를 설치하지 않은 상태에서 ionic 프로젝트를 생성하면 다음과 같은 warning을 보게 될 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/72800990-4eef-486d-a72b-b0ab1ccac9a4)

## ionic

Ionic 프로젝트를 개발하기 위해서 Ionic 패키지를 설치한다. Ionic 역시 CLI를 제공하고 있기 때문에 global로 설치를 한다.

```
npm install -g ionic
```

![](http://asset.hibrainapps.net/saltfactory/images/b9aed591-983f-4cf9-b16f-2a2ca495f924)

## Git

Ionic 프로젝트를 만들때, 반드시 필요한 것은 아니지만 관련된 소스를 가져오거나 소스 관리를 할 때 필요하다. https://git-scm.com/downloads 에서 시스템 환경에 맞는 설치 파일을 찾아서 설치하면 된다.

![](http://asset.hibrainapps.net/saltfactory/images/5fc2b345-9dda-4286-bd7d-bcde2e389e48)

또한 Mac 사용자는 Homebrew를 사용하여 간편하게 설치할 수 있다.

```
brew install git
```

## Mac과 Xcode

Ionic은 기본적으로 하이브리드 앱 개발 프레임워크로 iOS와 Androdi 앱을 동시에 패키징할 수 있다. 최근에는 Xcode 없이 iOS 앱을 패키징하는 라이브러리들이 존재하지만 기본적으로 Xcode가 설치되어 있는 Mac 환경에서 최적은 개발 환경을 만들 수 있다. 대부분의 하이브리드 앱 개발 환경이 Mac인 이유가 이러한 이유인데 하지만 Xcode 없이 iOS 패키징을 못하는 것은 아니다. 이부분에 대해서는 앞으로 자세하게 소개하는 포스팅을 작성할 것이지만 기본적으로 Mac을 사용하여 포스팅을 진행한다. Xcode의 필요는 꼭 패키징의 문제만 국한 된 것이 아니다. **iOS 시뮬레이터 테스트**와 **iOS 플랫폼을 위한 플러그인 개발** 등 Xcode가 꼭 필요한 사항이 있기 때문에 크로스플랫폼을 지원하는 하이브리드 앱을 개발하기 위해서는 Xcode가 설치되어 있는 Mac을 사용하기를 추천한다.

## Ionic 프로젝트 생성

npm으로 Ionic을 설치했다면 이젠 모든 준비가 완료되었다. 정상적으로 설치 되었는지 Ionic 프로젝트를 생성해보자. sidemu 형태의 앱을 만들어보자.

```
ionic start myApp sidemenu
```

![](http://asset.hibrainapps.net/saltfactory/images/236d5ceb-4521-481a-b4e5-6f9691a24d69)


ionic framework는 현재 가장 인기있는 하이브리드 앱 개발 플랫폼이다. 이런 이유로 ionic은 아주 빠른 속도로 버전이 업데이트되고 기능이 추가되고 있다. 아마 책에서 소개한 Ionic보다 최근 Ionic이 더 많은 기능이 추가되었고 환경이 변화 되었을 것이다. 그래서 이 블로그를 운영하면서 ionic의 기능들을 소개하려고 하는 것이다. ionic으로 프로젝트를 생성하면 기존과 달리 터미널에서 많은 정보를 보여준다.
Mac에서 ionic 프로젝트를 생성하면 기본적으로 iOS 어플레이션 플랫폼을 추가하여 만들어준다. 만약 android 플랫폼을 함께 개발하려면 프로젝트에서 android 플랫폼을 추가해줘야한다. 그리고 앱을 빌드하고 실행하는 방법도 보여준다. 그리고 최신에 추가된 ionic push notification을 사용하는 방법도 소개하고 있다. ionic 프로젝트를 생성하였으면 프로젝틀 빌드해보자.

Ionic은 하이브리드 앱을 개발하는 프레임워크이다. 다시 말해서 HTML5 기술로 앱을 개발할 수 있다. 이런 이유에서 Ionic은 HTML5 코드를 개발하고 확인할 수 있도록 자체적으로 server 기능을 가지고 있다. 프로젝트 디렉토리 안에서 다음과 같이 ionic serve를 실행시켜보자.

```
ionic serve
```
![](http://asset.hibrainapps.net/saltfactory/images/549c6ce3-9c07-4ead-8333-bdc6adfb7406)

서버가 실행되면 브라우저에서 프로젝트 확인이 가능하다.

http://localhost:8100

![](http://asset.hibrainapps.net/saltfactory/images/7f572899-bc10-4a80-89ac-a2d3b4f3922f)

Mac에서 Ionic 프로젝트를 생성하였으면 기본적으로 iOS 플랫폼이 추가되어 있기 때문에 iOS 앱으로 빌드를 해보자.

```
ionic build ios
```

![](http://asset.hibrainapps.net/saltfactory/images/30cddb2c-5f97-47fd-b591-236b6c243f11)

현재 앱에 iOS 플랫폼으로 빌드를 하면 다음과 같이 앱 빌드가 진행되어진다. 빌드가 마치면 iOS 시뮬레이터에 실행을 해보자.

```
ionic emulate ios
```

![](http://asset.hibrainapps.net/saltfactory/images/4a6afcc2-ddef-4a84-a1c7-e62615f70437)

기본적으로 target을 지정하지 않으면 Xcode의 기본 시뮬레이터로 앱을 런칭시키는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/9eddf515-140a-42cb-a158-b916dc41e573)

만약 특별한 디바이스에 특별한 iOS 버전으로 시뷸레이터에 설치해서 보고 싶은 경우 **ios-sim**의 정보를 확인하여 **—target** 옵션을 추가한다.

```
ios-sim showdevices
```

![](http://asset.hibrainapps.net/saltfactory/images/67908699-4af9-4efe-bef8-4b1f4e7c5134)

만약 iPhone-5s 에 앱이 설치되었을 때를 확인하고 싶을 경우 다음과 같이 target으로 디바이스를 지정하고 프로젝트를 simulator에 실행한다.

```
ionic emualte ios —target=“iPhone-5s”
```

![](http://asset.hibrainapps.net/saltfactory/images/49252c9e-6606-49fd-b660-a45549208b96)

실제 디바이스에 ionic 앱을 실행시키기 위해서는 USB로 디바이스를 Mac에 연결한 뒤 run 명령어를 실행하면 된다. 이때, 디바이스에 비밀번호가 걸려있을 경우 설치가 되지 않는다. 비밀번호를 해지하거나 비밀번호를 미리 열어둬야한다.

```
ionic run ios
```

만약 Android 디바이스에 테스트를 진행한다면 위와 동일하지만 플랫폼을 android로 지정하면 된다. Android 디바이스 테스트는 Mac이나 Windows 모두 동일하다. 먼저 Ionic 프로젝트에 iOS 플랫폼만 기본적으로 추가가 되어 있기 때문에 Android 플랫폼을 추가해야한다.

```
ionic platform add android
```

ionic 앱을 빌드하는 방법은 iOS 앱을 빌드하는 방법과 동일하다 플랫폼만 android로 지정하면 된다.

```
ionic build android
```

![](http://asset.hibrainapps.net/saltfactory/images/1285d33b-97ba-4456-bb87-294e7e7e3b00)

Android 에뮬레이터 앱을 런칭시켜보자 이 방법도 iOS 시뮬레이터에 앱을 런칭시키는 방법과 동일하다

```
ionic emulate android
```

![](http://asset.hibrainapps.net/saltfactory/images/17e1792f-afdd-4bf6-9027-1ce3c1408201)

위 명령어를 실행하면 Android 앱 파일인 **.apk** 파일이 자동으로 생성이 된다. 이 파일을 위에서 추가한 Andorid SDK를 사용하여 emulator를 실행하여 런칭하게 된다.

![](http://asset.hibrainapps.net/saltfactory/images/382804db-38fb-4dac-8865-9a81651b7bb0)


## 엣지있게 설명한 Ionic 책의 예제 실행방법

엣지있게 설명한 Ionic 책에는 Ionic의 현 개발자들이 최신 Ionic 기술을 소개하기 위해서 [Developing an Ionic Edge](http://bleedingedgepress.com/developing-ionic-edge/) 책을 집필할 때, 데모를 위해서 만든 [Trendicity](https://github.com/trendicity/trendicity)라는 앱의 소스코드를 가지고 설명을 진행한다.

> Trendicity 앱은 Instagram 과 연동하여 내 위치 주위의 사진을 가져와서 좋아하는 사진으로 등록을 할 수 있는 간단한 앱이다.

Ionic을 처음 접하거나 하이브리드 앱을 처음 개발하는 개발자들은 예제 소스를 실행하지 못하는 어려움을 메일로 문의를 많이하고 있어 예제를 실행하는 방법을 소개한다.

먼제 Trendicity 앱을 실행하기 위해서는 앞에서 설명한 Ionic을 위한 기본 설정이 선행되어야한다. 다시 말해서 다음 환경이 반드시 설정되어 있어야 한다.

- Java 설치 및 환경변수 등록
- Android SDK 설치 및 환경변수 등록
- Git 설치
- Node.js 설치
- cordova, gulp, ionic 설치 (Mac일 경우 ios-sim, ios-deploy 설치)

이 설정 방법은 앞에 글에서 소개하고 있다. 이 설정을 하지 않으면 예제 앱을 실행할 수 없다. 설정이 모두 되어 있으면 GitHub에 등록된 [Trendicity](https://github.com/trendicity/trendicity) 예제 앱을 clone한다. GitHub 저장소는 https://github.com/trendicity/trendicity 에서 확인할 수 있다.

```
git clone https://github.com/trendicity/trendicity.git
```

![](http://asset.hibrainapps.net/saltfactory/images/4422df34-644a-4863-ad57-8f1af36b3afb)

다음은 Trendicity 앱이 필요한 Node.js 패키지를 설치해야한다. 이런 이유 때문에 반드시 Node.js가 설치가 되어 있어야 한다. 프로젝트 디렉토리 안으로 들어가서 다음과 같이 npm을 사용하여 package.json 파일에 정의한 필요한 패키지를 한번에 설치한다.

```
npm install
```

![](http://asset.hibrainapps.net/saltfactory/images/d2e940c3-7e92-4073-897e-5d668237197a)

이 명령어를 실행하면 필요한 패키지들이 설치되는데 가장 먼저 설하는 패키지들은 cordova, ionic, gulp, bower 이다. 이것은 ionic 개발에 필수적인 패키지들이기 때문이다. 기타 모든 패키지와 웹 컴포넌트들이 설치되는데 약간의 시간이 걸릴 것이다. 모든 패키지가 설치되면 앱을 실행할 준비가 끝났다.

Trendicity는 대부분의 기능을 HTML5 기술로 만들었기 때문에 디바이스가 아닌 웹 브라우저에서도 충분히 확인이 가능하다. 앞에서 우리는 Ionic 앱이 HTML5 개발을 위해서 serve 명령어로 브라우저에서 실행되는 것을 확인하였다. Trendicity 프로젝트 디렉토리에서 이 명령어를 실행해보자

```
ionic serve
```
![](http://asset.hibrainapps.net/saltfactory/images/4e16150c-40d5-4e8e-a369-04e0c7ecc740)

http://localhost:8100

서버가 실행되면 브라우저에서 앱을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/1496b01f-c6d3-4fe0-9eee-dab9912e2fde)

책에서 나오는 OAuth2를 사용한 Instragram 로그인도 가능하다.

![](http://asset.hibrainapps.net/saltfactory/images/5f18095c-4bb6-425c-ba9f-fdc78fe1b4fd)

Trendicity는 HTML5 위치정보를 사용하여 주위에 있는 Instagram을 가져오는 앱인데 이 기능역서 Google Map과 연동하여 HTML5로 구현하였기 때문에 브라우저에서 확인이 가능하다.

![](http://asset.hibrainapps.net/saltfactory/images/db6e742f-0846-4307-b050-df62f7de253e)


다음은 iOS와 Android 플랫폼에서 동작하는 것을 확인해보자. Trendicity 소스는 기본적으로 플랫폼이 추가되어 있지 않다. 플랫폼에 동작하는 것을 확인하기 위해서 필요한 플랫폼을 추가한다. 우리는 iOS와 Android 플랫폼을 추가할 것이다.

```
ionic platform add ios android
```

![](http://asset.hibrainapps.net/saltfactory/images/4ea8e2ed-d2ca-44dc-a0b5-4a785a9bd484)

다음은 iOS 시뮬레이터에서 앱을 실행시켜보자.

```
ionic simulate ios
```

![](http://asset.hibrainapps.net/saltfactory/images/2c57d41f-975c-4e3e-88a8-6c640143a044)

Android 에뮬레이터에서 앱을 실행시켜보자.

```
ionic simulate android
```

![](http://asset.hibrainapps.net/saltfactory/images/65f101c5-8435-44cd-967e-056805c25464)

이렇게 데스크탑에서 브라우저로 실행하기, iOS 시뮬레이터 실행하기, Android 에뮬레이터 실행하기를 살펴보았다. 만약 실제 디바이스에 실행하고 싶을 경우 다음과 같이 실행하면 된다.

```
ionic run ios
```

또는

```
ionic run android
```

이제 데모 앱 Trendicity를 실행할 수 있게 되었다. 책을 펴서 코드를 보면서 어떻게 앱에 적용되는지 확인하면서 연구를 시작하면 된다.

## 결론

[엣지있게 설명한 Ionic](http://blog.saltfactory.net/books/ionic-edge/) 책에 역자로 이 책은 아주 초보자에게는 어려울 수 도 있다. 특히 Angular.js, Cordova, Node.js, Git 와 같은 선행학습이 없으면 데모앱을 실행하기도 힘들 수 있다. 역자로 모든 내용을 책에 추가적으로 넣을 수는 없었다. 또한 필요한 개발자들이 스스로 책을 가지고 여러가지 Ionic에 필요한 정보를 습득하길 바라면서 책에 대한 홍보역시 하지 않았지만 메일로 문의를 하면 답변할 수 있을 때 답장을 보내고 있었다. 하지만 같은 질문이 많아지게 되고 , 데모앱을 실행할 수 없어서 다음 장을 열어보지 못한다는 문의 메일을 확인하고 책에서는 소개하지 않았던 Ionic 개발을 위한 기본환경을 소개할 필요가 있다고 생각해서 포스팅을 하게 되었다.

Ionic은 급격하게 빠른 속도로 성장하고 버전 업데이트를 진행하고 있기 때문에 **Ionic-1.0-alpah**로 버전일 때 만들어진 이 책의 내용보다 더 많은 기능을 포함하게 되었다. 앞으로 블로그를 통해 Ionic에 대한 내용을 꾸준히 소개하려고 한다. 문의 메일에 대한 답변이 늦어지는 것과 하나하나 모두 답변을 드릴 수 없어 블로그의 포스팅으로 문의 내용 답변을 대신하려고 하는 이유도 있다.

이 책을 보면서 궁금한 점이나 여러 의견은 혼자 고민하시지 마시고 http://blog.saltfactory.net/books/ionic-edge/ 에 댓글로 남겨주시면 시간이 허락하는대로 답변을 드리겠습니다.

## 첨언

저는 연구원입니다. 다른 프로젝트 일정 및 연구활동으로 인해 답변이 늦어질 수는 있지만 최대한 질문에 성심껏 답변을 드릴려고 노력하고 있습니다. 같은 연구자로서 어려움이 있을 때 함께 연구하는 것이 제가 스승과 여러 분들에 받은 가르침입니다. 답변이 늦어도 양해부탁드립니다.

[교보문고 댓글](http://www.kyobobook.co.kr/product/detailViewKor.laf?ejkGb=KOR&mallGb=KOR&barcode=9791156003816&orderClick=LAG&Kc=) 에 누군가 답변이 없고 책 내용을 실행할 수 없다는 댓글을 달아 놓으셔서 미안하고 마음이 불편했습니다. 책에는 모든 내용을 담을 수도 없고, 모든 사람을 대상으로 집필을 할 수도 없습니다. 본업이 있기 때문에 문의 사항에 대해서 하나하나 빠르게 모든 답변을 드릴 수도 없지만 최대한 문의하시는 내용들에 늦어도 답변을 드리고 있습니다. 다시는 이렇게 오해를 가지는 분들이 생기지 않게 미리 양해를 부탁합니다.

참고로, [Developing an Ionic Edge](http://bleedingedgepress.com/developing-ionic-edge/) 을 책은 실제 Ionic 개발자들이 집필한 책이고 Trendicity의 소스코드는 매우 훌륭한 자료입니다. Ionic의 최신 기술이 모두 들어가 있다고 보시면 됩니다. 소스코드가 곧 개발의 좋은 자료가 될 것입니다. 기초내용과 기본적인 설정은 이 블로그나 다른 Ionic 자료를 가지고 병행해서 연구하시면 이 책에 나오는 코드를 가지고 훌륭한 앱을 만들 수 있게 될 것이라고 말씀드리고 싶습니다. 모든 것이 시작이 어렵지만 어려운 내용은 함께 고민하는 연구원이 되겠습니다. 문의하시는 내용들은 2판이 나올때 추가할 예정입니다.

감사합니다.

## 참고

1. http://ionicframework.com/getting-started/
2. https://cordova.apache.org/
3. https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md
4. https://github.com/phonegap/ios-sim
5.http://www.trendicity.co/

## 엣지있게 설명한 Ionc 데모 예제 Trendicity

- 앱스토어 : http://www.trendicity.co/
- 소스코드 :https://github.com/trendicity/trendicity

