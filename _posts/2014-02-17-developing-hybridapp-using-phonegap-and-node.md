---
layout: post
title : PhoneGap과 Node.js를 이용하여 하이브리드 앱 개발환경 구축하기
category : hybridapp
tags : [phonegap, node, nodejs, hybridapp, hybrid]
comments : true
redirect_from : /228/
disqus_identifier : http://blog.saltfactory.net/228
---

## 서론

모바일 앱 개발자라면 누구든지 이런 생각을 할 것이다. 하나의 코드로 다른 종류의 모바일 앱을 개발 할 수 없을까? 우리 연구소에서 이 질문에 대한 숙제를 지속적으로 생각하고 있고 또 필요로 하고 있다. 특히나 앱이 만들어지고 난 다음 유지보수를 할 때 개발한 앱들이 많아지게 되면 적은 인력으로 모든 앱을 네이티브하게 다른 언어의 플랫폼을 가지고 있는 앱들을 관리하고 업데이트하기가 쉽지 않다. 작년 하이브리드 앱 이라는 핫 이슈가 있었다. KTH에서는 Appsresso(앱스프레소)라는 eclipse 기반의 크로스 하이브리드 앱 개발 플랫폼을 정식으로 릴리즈하였고 앱스프레소를 이용하여 하이브리드 앱을 마켓에 올리기도 하였다. 하지만 Asspresso 프로젝트는 현재 개발이 멈추어진 상태이다. 개인적으로 가장 아쉬운 프로젝트이다. 국내에서 크로스 플랫폼을 지원하는 하이브리드 앱 개발 프레임워크로 비전이 있는 프로젝트였는데 말이다.. Appsresso는 항상 PhoneGap과 비교되어 왔다. PhoneGap은 Adobe에서 웹 개발 기술로 네이티브 앱을 개발할 수 있는 오픈소스 프레임워크이다. PhoneGap 공식 사이트에서 PhoneGap을 다음과 같이 설명하고 있다.

> PhoneGap is a free and open source framework that allows you to create mobile apps using standardized web API for the platforms you care about

간단히 말하면 PhoneGap은 웹 API로 모바일 앱을 개발 할 수 있는 프레임워크이다. 즉 웹 개발 기술로 프로그램을 작성해서 네이티브 앱을 만든다는 개념인데 다음 그림으로 가장 쉽게 이해할 수 있다. HTML5 (Javascript, CSS) 로 만든 웹 앱을 PhoneGap으로 랩핑해서 모바일 플랫폼에 디플로이 시킨다. 이러게 모바일 웹에 돌아가 만든 모바일 앱(하이브리드 앱)은 마켓에 정식으로 등록도 가능하다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7789d698-3ac6-4d1d-ad2c-3996778bd66a)

처음 하이브리드 앱 개발을 연구할 때 PhoneGap과 Appsresso 둘 중에 Appspresso를 선택한 이유는 바로 On the Fly 기능 때문이였다. On the Fly 기능은 일종의 새로고침이다. 즉, 하이브리드 앱 개발을 할 때 컴파일이 필요한 네이티브코드를 제외한 나머지 리소스는 On the Fly 기능을 가지고 컴파일 타임없이 앱에 새로 고친 자원을 적용할 수 있는 것이다. 하이브리드 앱은 많은 량의 코드가 JavaScript로 만들어지기 때문에 이 기능을 가진 Appspresso는 PhoneGap 보다 빠른 개발 속도를 낼 수 있었다. PhoneGap은 리소스가 변경되면 항상 rebuild를 해야하기 때문에 단순하게 한줄을 고쳐도 늘 컴파일을 다시 해야하는 컴파일타임이 필요했기 때문이다. 하지만 Appsresso는 더이상 정식으로 릴리즈 되지 않는다. 그래서 하이브리드 앱에 관한 연구도 차츰 시들해지고 있었는데 역시나 네이티브 앱을 안드로이드와 아이폰 개발을 하면서 다시 하이브리드 앱의 필요성을 느끼게 되었다. Adobe는 Flash 공격 타격을 받으면서 점점 JavaScript 기술에 대응하기 위해서 JavaScript 사용하는 방법에 대해서도 연구를 많이 하기 시작했다. PhoneGap도 Node.js를 이용해서 phonegap command를 만들었다. 다시 PhoneGap에 대한 연구를 할 필요성을 느껴서 사용하면서 알게되는 정보를 공유하고자 한다. 연재가 끝내기 전에 PhoneGap에서도 On the Fly 기능을 아니명 이와 유사한 기능이라도 보기를 간절히 바라면서 말이다. 우선 PhoneGap으로 하이브리드 앱을 개발하기 위해서 앱 개발 환경 설정하는 부분이 필요하다. 이번 포스팅에서는 PhoneGap을 이용해서 하이브리드 앱 개발 환경을 설정하는 방법을 소개하고자 한다.

<!--more-->

### 모바일 개발 도구 다운로드

먼저 PhoneGap은 여러가지 모바일 플랫폼을 지원한다. 즉, 아이폰, 안드로이드, 블랙베리, 기타 등등.. 다음 링크에가면 PhoneGap이 지원하는 모바일 디바이스를 확인할 수 있다. http://phonegap.com/about/feature/
우리는 모든 디바이스를 설명할수도 없고 개발 대상 디바이스를 이렇게 광범히하게 생각하고 있지는 않지만 현재 존재하는 대부분의 스마트폰을 모두 지원하다고봐도 과언은 아닐것이다. 우리는 두가지 디바이스만 생각하고 연구를 진행한다. 첫번째는 iOS 디바이스고, 하나는 Android 디바이스이다.

#### Xcode 다운로드

iOS 앱을 개발하기 위해서는 Xcode가 필요하다. 하이브리드 앱 개발을 하면 네이티브 프로그래밍도 필요하기 때문이다. 물론 다른 에디터에 작성하고 컴파일을 하면되지만 iOS 플랫폼을 지원하기 위해서 필요한 개발 툴과 라이브러리 그리고 시뮬레이터를 확인하기 위해서 Xcode를 설치한다. Mac AppStore에서 무료로 다운 받을 수 있으니 Xcode를 다운 받아서 설치한다.

#### Android SDK 다운로드

Android 앱을 개발하기 위해서는 Android SDK가 필요하다. Android SDK 에서는 안드로이드 앱 개발에 필요한 SDK 뿐만 아니라 안드로이드 개발에 필요한 툴들이 들어 있는데 PhoneGap에서는 이 툴들을 사용하기 때문에 반드시 필요한 것이기 때문에 Android SDK를 다운 받도록 한다.
http://developer.android.com/sdk/

나중에 PhoneGap을 설치하면 PhoneGap은 다운 받은 SDK 안에 여러가지 툴을 사용하기 때문에 PATH에 추가하여 PhoneGap이 접근할 수 있도록 해야한다. 다음과 같이 PATH를 추가할 수 있는 ``$HOME/.profile` 을 연다.

```
vi ~/.profile
```

그리고 PATH에 다음과 같이 추가한다. 예로 Android SDK를 다운받아서 압축을 푼 경로가 `/Projects/Libraries/adt-bundle-mac-x86_64` 라고 가정하면 다음과 같이 추가한다.

```
export PATH=$PATH:/Projects/Libraries/adt-bundle-mac-x86_64/sdk/platform-tools:/Projects/Libraries/adt-bundle-mac-x86_64/sdk/tools
```

`.profile`에 설정을 마쳤으면 현재 열려있는 쉘에 적용을 해야하기 때문에 `source`를 한다.

```
source ~/.profile
```

#### Android Studio 다운로드

하이브리드 앱은 네이티브 코드 프로그래밍도 필요하다. Android 네이티브 코드 작성을 위해서 **Android Studio**를 다운받는다. Android Studio에 대한 글은 다음 글을 참조한다. (http://blog.saltfactory.net/227)

## Node.js 설치

PhoneGap은 Archive된(압축파일) 라이브러리를 제공하기도 하지만  Node.js로 만들어어진 모듈을 사용한다. 앞으로 다양한 Node.js의 모듈을 이용해서 확장 가능할 것으로 생각이 된다. Mac에서 Node.js를 설치하는 방법은 Homebrew로 설치하는 것이 가장 편리하다. Homebrew에 관한 자료는 이 블로그의 다음 글을 확인한다. (http://blog.saltfactory.net/109) Homebrew로 Node.js를 설치한다.

```
brew install node
```

### NPM으로 PhoneGap 설치

NPM(Node Packaged Modules)은 CentOS의 yum, Ubuntu의 apt-get, Ruby의 gem과 같은 것이다. 필요한 모듈을 원격 리파지토리에서 바로 다운받아서 설치할 수 있다. PhoneGap은 전역에서 사용할 수 있도록 `-g` 옵션으로 설치해야한다. 이유는 PhoneGap은 PhoneGap command를 사용하는데 npm 에서 모듈을 설치할때 전역에서 사용하려면 -g 옵션으로 설치해야하기 때문이다.

```
npm install -g phonegap
```

### NPM으로 ios-sim 설치

PhoneGap은 PhoneGap 개발 프레임워크로 PhoneGap에 하이브리드 앱 소스 코드를 각각 해당하는 모바일 디바이스로 빌드를 하고 실행을 할 수 있다. PhoneGap이 iOS 에 동작하는 앱으로 만들어서 테스트를 진행하기 위해서 iOS simulator를 동작해야하는데 [ios-sim](https://github.com/phonegap/ios-sim)은 Node.js로 iOS simulator를 실행할 수 있는 모듈이 포함이 되어 있다. 만약 ios-sim을 설치하지 않고 PhoneGap으로 빌드하고 실행하면 다음과 같은 에러를 보게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/402639a6-9cc0-43d4-b381-c7670d0eb2fd)

이 에러는 PhoneGap이 디바이스를 찾을 수 없으니 ios-sim을 설치해라는 이야기이다. ios-sim을 npm으로 설치한다.
```
npm install ios-sim
```
이제 PhoneGap으로 하이브리드 앱을 개발 할 수 있는 모든 준비는 마쳤다. 환경설정이 바로 되어 있는지 간단한 예제를 만들어서 실행해보자.

### PhoneGap 프로젝트 생성

우리는 PhoneGap을 `npm install -g`로 Node.js 모듈을 전역으로 사용할 수 있게 설치했다. 그래서 우리는 이제 phonegap command를 사용할 수 있는데 PhoneGap 프로젝트는 다음과 같이 만들 수 있다.

```
phonegap create {프로젝트이름} -n {프로젝트 디스플레이 이름} -i {패키지이름(app identifier)}
```

우리는 예제 프로젝트를 sf-phonegap-demo라고 이름하고 **net.saltfactory.tutorial.phonegapdemo** 라고 패키지명으로 앱을 만들것이다.

```
phonegap create sf-phonegap-demo -n Sf-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

phonegap command를 실행하면 다음과 같이 phonegap 프로젝트가 만들어진 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ed258524-d7bf-43df-86cd-d92f0cdfa6b9)

생성된 프로젝트 디렉토리로 이동을 한다.

```
cd sf-phonegap-demo
```

PhoneGap 프로젝트 안에는 다음과 같은 디렉토리들이 존재한다. 지금은 간단히 설명하고 나중에 실제 개발에 들어가면 자세히 설명하도록 한다.

1. merge : 빌드 이후에 www 밑에 있는 리소스들이 이 디렉토리 안으로 존재해서 나중에 앱이 동작할때 이 곳 안에 있는 리소스에 접근하게 된다.
2. platforms : iOS, android 등 여러 모바일 플랫폼 소스코드들이 존재한다.
3. plugins : 각종 플러그인을 추가하면 존재한다.
4. www : 웹 앱에 관련된 코드와 리소스가 존재한다.

PhoneGap 프로젝트로 만들어진 디렉토리 안에 존재하는 이 디렉토리는 www를 제외하고 모두 비워져 있다. 확인해보자.

```
tree merges/ platforms/ plugins/
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8559e9f6-1d80-40ea-bbec-73c83eed61d0)

### PhoneGap 으로 iOS 플랫폼 앱 빌드하고 설치하기

먼저 iOS 개발 플랫폼으로 빌드를 해보자. phonegap command를 다음과 같이 입력한다.

```
phonegap build ios
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e89cb751-92f7-49e6-ad3d-cc950a47311a)

이 phonegap build ios 실행하면 iOS 앱 개발에 필요한 codesign에 접근할 수 있는 권한을 물어보는데 Allow을 누른다. 매번 물어보는게 싫으면 Always Allow를 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3190003d-dff7-468e-b9d1-3ac5af26387f)

phonegap command를 실행하면 iOS SDK 환경을 찾아서 phonegap 프로젝트에 iOS platform을 추가한다. 그리고 iOS 프로젝트로 컴파일을 진행한다. 이 명령어 이후에 platforms 디렉토리를 열어서 확인해보자. platforms 디렉토리 안에는 ios라는 디렉토리가 생겼고 안에 iOS 기반의 Xcode로 만들어진 프로젝트 파일들이 생성된 것을 확인할 수 있다. 여기서보면 우리가 앞에 PhoneGap command로 프로젝트를 생성할때 -n 다음에 넣었던 프로젝트 디스플레이 이름으로 프로젝트가 생성된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7dd4c697-cb24-42f3-84c7-d905c595a63d)

빌드한 앱을 iOS 디바이스에 설치해보자. 다음과 같이 PhoneGap install command를 실행한다. PhoneGap command의 install 명령어는 특별한 모바일 플랫폼에 빌드한 프로젝트를 설치하는 명령어이다.

```
phonegap install ios
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/782340f4-db84-4c14-9437-bb06678fa583)

디바이스에 설치되고 있는 로그를 확인할 수 있고, 설치후 시뮬레이터가 동작해서 설치된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/64e56bcb-0cd4-4965-9a24-09536c97486c)

위의 앱의 빌드와 설치를 PhoneGap의 build와 install로 처리했는데 이 두가지를 run으로 한번에 처리할 수 있다. PhoneGap run command를 실행해보자. run 명령어는 install 명령어와 달리 compiling iOS... 라는 로그를 볼 수 있을 것이다 run은 build를 다시하고 install을 실행하기 때문이다.

```
phonegap run ios
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b5b80252-7ac1-4b2e-9de9-4ef8318fad13)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a3d83072-cbc6-4320-8e5a-43f9352f302f)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/30a72e92-ab60-4838-8255-0c34fceb0e43)

가장 기본적인 웹 앱이 아이폰 디바이스 인스톨된 모습이다. 웹 앱의 소스는 나중에 PhoneGap API를 설명할 때 자세히 설명하겠다. 지금은 단지 www 안에 존재하던 웹 리소스들로 만들어진 웹 앱이 모바일 앱의 형태로 모바일 디바이스에 설치 되었다는 정도만 알고 있자.

### PhoneGap으로 Android 디바이스에 빌드하고 설치하기

위에서 우리는 PhoneGap 프로젝트로 생성한 앱을 iOS 플랫폼에 맞게 빌드하고 설치하고 실행을 했다. PhoneGap의 장점은 같은 방법으로 다른 디바이스 맞는 앱을 똑같이 빌드하고 설치하고 실행할 수 있다는 것이다. Android 플랫폼에 작업을 해보자. 위에서 우리는 iOS 플랫폼에 맞는 앱을 빌드하기 위해서 PhoneGap command 중에 build를 사용했다. Android도 동일한 명령어로 앱을 빌드할 수 있다. 현재 위치는 PhoneGap 프로젝트 디렉토리 안이다. 우리는 위에서 예제로 sf-phonegap-demo 라는 프로젝트를 만들었고 현재 그 디렉토리 안이다.

```
phonegap build android
```

여러분이 Android SDK 경로 설정을 위에서와 똑같이 진행하였다면 문제 없이 안드로이드 앱이 정상적으로 빌드가 되어질 것이다. iOS 플랫폼에 맞게 빌드하던 것과 동일하게 빌드가 진행되었음 로그를 통해서 알 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7cd7732f-a9a7-4498-8faa-695f47ce6235)

다음은 iOS 디바이스에 앱을 설치할때 사용한 PhoneGap command의 install 명령어를 동일하게 실행해보자.

```
phonegap install android
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/006c06d3-124f-4955-8886-919598e36cbe)

위의 iOS 빌드를 살펴보면 기본적으로 USB로 연결된 디바이스를 찾지 못하는 경우는 PhoneGap command는 emulator를 찾아서 실행을 하게 한다. 안드로이드에서 phonegap install 명령을 실행한 결과를 보면 위의 iOS와 달리 successfully installed onto device라는 로그를 볼 수 있고 emulator에 설치했다는 로그를 볼 수 없을 것이다. 이것은 디바이스에 설치했기 때문에 emulator에 설치하는 과정까지 진행하지 않은 것이다. 그럼설치된 안드로이드 디바이스의 화면을 살펴보자. Android 화면을 캡처하기 위해서 ddms를 실행했다. 우리는 Android SDK를 `/Projects/Libraries/adt-bundle-mac-x86_64`라는 디렉토리에 두고 있다. Android SDK 디렉토리 안에 `/sdk/tools/ddms`를 실행한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ad9e2afc-7195-4f0f-a2a8-5261ac468173)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d70f4995-bfc8-4d7b-af97-4b28ada86362)

위의 iOS와 같이 Android 디바이스에도 동일한 앱이 설치되어 진 것을 확인할 수 있다. 이렇게 같은 코드 하나로, 동일한 PhoneGap command로 랫폼 target만 달리해서 같은 앱을 다른 플랫폼을 가진 디바이스에 개발해서 설치할 수 있다는 것을 확인할 수 있다.


## 결론

이 포스팅은 PhoneGap과 Node.js로 만들어진 PhoneGap command로 PhoneGap 프로젝트를 간단하게 스케폴딩으로 만들고, 빌드하고, 설치하고 실행하는 예제를 소개했다. 이번 포스팅은 멀티 플랫폼 디바이스를 지원하는 앱을 개발하고 설치하기 위해서 설정해야하는 것들을 소개했다. 다음 포스팅에는 하이브리드 앱을 개발하기 위한 설정 방법을 소개할 것이다 그리고 PhoneGap이 가지고 있는 웹 API를 사용하는 방법은 이후에 자세히 설명을 할 것이다. 여러가지 PhoneGap의 장점 중 PhoneGap은 대부분의 단일 코드로 (실제 하이브리드 앱을 개발하면 플랫폼에 맞는 언어로 플러그인을 개발해야한다.) 여러가지 디바이스에 설치할 수 있는 앱을 한번에 만들 수 있다는 것이다. 위에 예제를 살펴보면 target만 iOS와 Android로 설정했을 뿐 그 어디에서 다른 플랫폼이기 때문에 그것에 맞는 종속적인 코드를 만들지 않았다는 것을 확인할 수 있다. 이렇게 PhoneGap은 웹 개발 리소스를 가지고 네이티브에 설치할 수 있는 앱을 빠르고 편리하게 만들어낼 수 있다는 장점을 가졌다. PhoneGap은 Appspresso를 연구하고 사용하는 동안 많은 발전이 있었을 것이라고 예상한다. 지금부터 PhoneGap에 대해서 좀더 자세하게 연구를 하기로 생각한 이유는 네이티브 앱의 속도의 어느정도 성능을 만들어줄 수 있다면 단일 코드로 여러 플랫폼에 돌아가는 하이브리드 앱을 개발하는 것이 향후 유지보수도 편리할 것이라고 생각하기 때문이다. PhoneGap은 Node.js 개발 방법을 지원하기 시작했다. 이말은 수 많은 Node.js 모듈을 사용할 수 도 있고 앞으로 Node Module을 확장해서 다른 개발 방법을 보여줄 수 있을 것으로 예상되기도 한다. 아직은 아무것도 예상할 수 없지만 Adobe에서 여러가지 개발 방법과 환경을 지원하고 있기 때문에 앞으로 발전될 가능성도 기대된다. 이런 기대감을 안고 PhoneGap을 좀 더 자세히 연구할 것이다.


> PhoneGap command 3.4.0 버전에서 PhoneGap으로 프로젝트를 만들 경우 id와 package name이 지정되지 않는 버그가 있습니다. 다음 글을 반드시 확인하세요. http://blog.saltfactory.net/234

## 참고

1. http://docs.phonegap.com/en/3.0.0/guide_cli_index.md.html

