---
layout: post
title: IntelliJ 기반 공식 안드로이드 개발 툴 Android Studio 소개
category: android
tags: [android, ide, android studio]
comments: true
redirect_from: /227/
disqus_identifier : http://blog.saltfactory.net/227
---

## 서론

Android 앱을 개발 할 때는 **eclipse**로 개발하는 것이 당연하듯 공식화 되어 왔다. 안드로이드 개발자 사이트에서 [eclipse ADT(Android Development Tools)](http://developer.android.com/tools/sdk/eclipse-adt.html)를 포함해서 배포하고 무료로 사용할 수 있는 안드로이드 개발툴 중에서 단연 eclipse가 가장 훌륭했기 때문이다. 하지만 이젠 안드로이드 개발자 사이트에서 공식적으로 [android Studio](https://developer.android.com/sdk/installing/studio.html)를 정식으로 다운받아서 안드로이드를 개발할 수 있다.

Android Studio라는 툴은 [IntelliJ](http://www.jetbrains.com/idea/) 기반으로 만들어졌다. IntelliJ는 자바 개발자라면 대부분 알고 있을 것이다. IntelliJ는 eclipse와 같이 통합개발툴인데 안정성과 속도면에서 eclipse보다 월등히 좋기 때문이다. 우리 연구소에서도 eclipse를 개발 툴로 사용하다가 IntelliJ로 변경을 하였다. 원래 IntelliJ는 상용 툴이다. 그래서 소규모 회사나 개인 개발자들은 IntelliJ가 좋은 도구임에도 불구하고 라이센스 가격 때문에 무료로 사용할 수 있는 eclipse를 많이 사용했는데 지금은 IntelliJ에서 커뮤니티 버전을 무료로 다운 받아서 사용할 수 있다. 오픈소스 개발 또한 무료버전으로 사용할 수 있는데 아마 안드로이드 개발 진영에서 안드로이드 SDK를 오픈소스로 하기 때문에 IntelliJ 오픈소스 버전을 사용해서 Android Studio를 만든건 아닌가 생각된다. Android Studio는 IntelliJ 기반으로 만들어졌기 때문에 IntelliJ가 가지고 있는 IDE 기능을 대부분 사용할 수 있다.

IntelliJ는 설정도 기능도 굉장히 광범히 하다. 그래서 한번의 포스팅으로 부족하다 생각하기 때문에 Android Studio 사용방법은 연재로 하는게 좋다고 생각이 든다. 사용하면서 설명이 필요한 부분은 개인적으로 메일로 질문을 하거나 댓글을 달아두면 다음 포스팅에 소개하도록 할 예정이다.

그럼 이제 공식적으로 안드로이드 개발할 때 사용할 수 있는 Android Studio를 살펴보기로 하자.

<!--more-->

## Android Studio 다운로드

Android Studio 는 안드로이드 공식 사이트인 다음 링크에서 다운받을 수 있다. http://developer.android.com/sdk/installing/studio.html

![android studio download page](http://asset.hibrainapps.net/saltfactory/images/ab26e463-056e-4e68-966e-d2edaab75c06)

Android Studio 는 아직 1.0 버전이 아닌 preview 버전이다.

Android Studio 공식 사이트에서 eclipse에서 Android Studio로 마이그레이션하는 방법을 제공하고 있다. (https://developer.android.com/sdk/installing/migrate.html)

기존의 IntelliJ에서도 eclipse 프로젝트를 import하여 자동적으로 IntelliJ로 마이그레이션할 수 있는 기능이 있기 때문에 이전에 eclipse로 개발하던 안드로이드 프로젝트를 매우 간단하게 마이그레이션해서 개발할 수 있다. Download Android Studio 버튼을 누르면 다운로드가 진행된다. 예상하듯 IntelliJ는 맥용과 윈도우즈 버전 두가지가 존재하며 어느쪽에서든 동일한 설정으로 개발을 할 수 있다. 뿐만 아니라 IntelliJ는 Cocoa로 만들어졌기 때문에 64bit 맥에서 JRE로 만들어진 IDE보다 쾌적하게 개발을 할 수 있다.

![download android studio](http://asset.hibrainapps.net/saltfactory/images/26e0d344-648c-4299-ae99-7dba7de21319)

다운 받은 Android Studio.dmg 를 열어보면 Android Studio 가 보일 것이다. IntelliJ의 로고가 아닌 Android의 로고로 만들어져 있고 이 어플리케이션을 Applications로 드리그해서 넣으면 설치가 완료된다.

## Android Studio 실행

Applications로 드래그해서 넣으면 맥의 프로그램들이 모아있는 곳으로 자동적으로 복사가 되게 되는데 실행하기 위해서 더블클릭을 해보자.

![start android studio](http://asset.hibrainapps.net/saltfactory/images/1611985d-a930-4470-972a-e83fddd73d6d)

> 그런데 더블클릭해서 실행하려고하면 인증되지 않은 개발자가 만든 프로그램이라는 경고가 나타나면서 실행이되지 않을 것이다. 맥에서는 보안을 강화하면서 인증된 소프트웨어만 정상적으로 실행하기 때문인데 사용자가 직접 인증을 허가해서 사용하기 위해서는 어플리케이션에서 오른쪽 마우스를 클릭한다. 그리고 "Open" 을 선택한다. 아마 운영체제가 한글로 되어 있을 경우에는 "열기"로 되어 있을 것이다.

![manual open android studio](http://asset.hibrainapps.net/saltfactory/images/f07e6222-5869-4bb2-a3d2-5cb230251984)

그러면 다음과 같은 화면이 나타나는데 알수 없는 개발자가 만든 Android Studio를 열기를 희망하는지 물어본다. Open 버튼을 선택한다.

![manual open application](http://asset.hibrainapps.net/saltfactory/images/c16a0536-1627-47e2-907e-c3fb5fce4919)

이제 Android Studio가 열리게 될 것이다. 아래와 같은 시작화면이 나타나면서 필요한 정보를 로드하기 시작한다. Android Studio는 IntelliJ Platform에서 만들어졌다는 정보도 보일것이다.
![startup android studio](http://asset.hibrainapps.net/saltfactory/images/d4a0cf31-cc1c-4816-9083-de224dac5eac)

### Android Project 생성

안드로이드 프로젝트를 생성해보자. Android Studio를 실행하면 가장먼저 보이는 윈도우이다. 현재 개발하고 있는 프로젝트 목록들이 보인다. 테스트를 위해서 하나 프로젝트를 생성한 것이 있었는데 이것이 현재 개발 프로젝트 목록에 나타나고 있다. 새로운 프로젝트를 만들기 위해서는 ***New Project***를 선택한다.

![create new project](http://asset.hibrainapps.net/saltfactory/images/a26c48f1-c2ed-43a3-9f46-cb2513628e15)

![create new project step2](http://asset.hibrainapps.net/saltfactory/images/ea8b827e-4b13-4812-80e7-d2936fb5091f)

New Project를 선택하면 프로젝트를 생성하는 윈도우가 열린다. ***Application name***에 앱의 이름을 적는다. 그리고 ***Module name***에 이름을 입력하면 자동적으로 ***Package Name***의 뒤에 붙어서 안드로이드 패키지의 모듈이름으로 지정이된다. 물론 package 이름은 변경가능하다. 그리고 ***Project location***에 지금 프로젝트 소스파일이 만들어질 곳을 지정한다. 다음은 현재 개발할 안드로이드 SDK 버전을 설정하는 항목들이 나온다. ***Minimum required SDK***는 최소 SDK 그리고 Target SDK, 마지막으로 안드로이드 앱 개발을 할 때 컴파일할 ***SDK***를 설정한다. 다음은 ***Theme***를 설정할 수 있다.

테마는 다음과 같이 지정할 수 있다.
- None
- Holo Dark
- Holo Light
- Holo Light with Dark Action Bar

![android themes](http://asset.hibrainapps.net/saltfactory/images/24d3052c-b507-474a-a7e2-6e6391a85657)

리고 프로젝트를 생성할 때 런치 아이콘을 만들것인지, 기본 activity를 만들 것인지 체크하는 항목이다. 모두 체크한 상태에서 진행한다.지금 만드는 프로젝트는 ***Application 프로젝트***이다. 만약 안드로이드 Application이 아니라 안드로이드 ***Library Module 프로젝트***를 진행하려면 ***Mark this project as  a library***를 선택한다. 기회가 되면 이 내용에 대해서 상세하게 포스팅을 하겠다. 실제 우리 연구소에서 개발을 할 때에도 공통으로 사용하는 안드로이드 라이브러리를 hbn-anroid-lib 라는 모듈 프로젝트를 만들어서 import library를 해서 안드로이드 프로젝트에서 사용하고 있는데 매우 훌륭한 개발방법이다. 공통으로 사용하는 클래스와 리소스를 프로젝트마다 새로 만들지 않아도 되어서 개발 생산성에 큰 도움을 받을 수 있다.

마지막으로 ***Support Mode***를 체크해서 프로젝트를 어떤 모드로 개발할 지를 선택할 수 있다.
Next 버튼을 클릭한다. 그러면 ***Foreground 이미지***를 선택하는 윈도우가 나타난다. 기본적으로 안드로이드 프로젝트에 있는 ic_launcher.png가 나오는데 이것은 여러분들이 원하는 이미지로 변경할 수 있다. image file에서 필요한 이미지를 선택하면 된다. Additional padding에서는 이미지에 padding을 추가할지를 설정하는 것이다.

![android foreground image](http://asset.hibrainapps.net/saltfactory/images/617366ff-b20b-4476-9a2e-bf3853c1ddf8)

***Trim surrounding blank space***는 이미지에 빈공간을 추가로 넣을 것인지를 체크하는 것이다. 아래는 Trim surrounding blank space를 적용했을 때 화면이다.

![Trim surrounding blank space](http://asset.hibrainapps.net/saltfactory/images/d76397f8-6380-485c-bc97-352bb6b5a66d)

***Shape***를 지정할 수도 있다. Noe, Square, Circle을 지정할 수 있는데 각각 다음과 같다.

![shape image](http://asset.hibrainapps.net/saltfactory/images/278ef525-6f37-4979-9156-0ec2f77c0fc2)

![shape image 2](http://asset.hibrainapps.net/saltfactory/images/71438f86-29a3-44cd-9f1b-20bfe049c198)

***Background color***는 배경화면을 지정하는 것이데 색상을 더블클릭하면 팔렛트가 열려서 선택하면 된다.

![background color](http://asset.hibrainapps.net/saltfactory/images/4768e182-30ce-4df8-8e64-4a5b60e27848)

모든 설정이 마쳤으면 Next를 누른다. 다음은 Activity를 어떤 타입으로 만들지를 선택할 수 있는데 다음 세가지로 지정해서 기본적인 코드를 자동적으로 생성할 수 있다.
- Blank Activity
- Fullscreen Activity
- Master/Detail Flow
각각 선택했을 때의 화면은 다음과 같다.

***Blank Activity***

![blank activity](http://asset.hibrainapps.net/saltfactory/images/415e14b4-8f05-4c6a-9918-9139b7f3cfc7)

***Fullscreen Activity***

![fullscreen activity](http://asset.hibrainapps.net/saltfactory/images/0be196b1-5c8c-43de-9c5d-8a1bb4d919c1)

***Master/Detail Flow***

![master/detail flow](http://asset.hibrainapps.net/saltfactory/images/e5989ca8-84b8-496d-b64e-ad9ddefd7fb5)

위의 그림과 같이 Activity 타입을 지정하면 그에 맞는 소스코드가 자동적으로 생성이된다. **Master/Detail Flow**는 안드로이드 ***SDK level 11*** 부터 사용할 수 있는데, 최초 프로젝트에서 SDK를 선택할 때 minimum require SDK를 안드로이드 SDK level 9로 지정했기 때문에 Master/Detail Flow를 선택하면 The component Master/Detail Flow has a minimum SDK level of 11. 이라는 경고가 나타난다. 이 포스팅은 Android Studio의 간단한 소개를 할려고 SDK를 낮게 설정했지만 실제 개발에서 level 11를 지원한다면 이 화면에서 Master/Detail Flow를 경고 없이 선택할 수 있을 것이다. 예제는 Blank Activity를 선택한다.


Next 버튼을 누른다. 앞에서 프로젝트를 생성할 때 **Create Activity**를 체크했기 때문에 최초 Activity를 어떻게 만들것인지에 대해서 물어보는 윈도우가 열린다. Activity Name에는 시작할 때 처음 열리는 Activity의 이름을 지정한다. 기본적으로 MainActivity로 지정되어 있다. 그리고 이 Activity에서 사용하는 layout의 이름을 Layout Name에서 지정할  수 있다. 그리고 ***fragment Layout Name***을 지정하는데 기본적으로 fragment_main으로 지정되어져 있다.

다음은 Navigation Type을 설정하는데 Navigation Type은 다음과 같다.
- None
- Swipe Views (ViewPager)
- Action Bar Tabs (with ViewPager)
- Action Bar Spinner
- Navigation Drawer
각각 선택했을 때 미리보기 화면은 다음과 같다.

***Swipe View(ViewPager)***

![swipe view](http://asset.hibrainapps.net/saltfactory/images/0c51dae0-a4f6-4c03-8049-6758654c9c27)

***Action Bar Tabs(with ViewPager)***

![action bar tabs](http://asset.hibrainapps.net/saltfactory/images/48847a86-9259-4a05-9245-ca9842b325d9)

***Action Bar Spinner***

![action bar spinner](http://asset.hibrainapps.net/saltfactory/images/f7fb8fcc-7756-4f66-bdab-b2359f094c62)

***Navigation Drawer***

![navigation drawer](http://asset.hibrainapps.net/saltfactory/images/3193c3a7-6266-4c39-b03b-5e343768d996)

리는 예제를 Navigation Type을 None으로 설정하고 Finish 를 누른다. 만약 필요한 라이브러리가 모두 다운 받아져 있는 상태라면 필요한 라이브러리를 모두 로드해서 다음과 같이 Notification을 보게 될 것이다.

![gradle notification](http://asset.hibrainapps.net/saltfactory/images/5d2feb74-c9a2-4e05-b772-1769419fdb19)

Android Studio 는 [Gradle](http://www.gradle.org )을 포함하고 있고 필요한 라이브러리와 빌드를 Gradle이 하기 때문이다. Gradle은 일종의 자동화하는 소프트웨어이다. 만약 필요한 라이브러리들이 내 개발 환경에 다운받아 있지 않을 경우, 예를 들어서 android SDK나 라이브러리들이다. 이럴 경우는 gradle이 자동적으로 maven을 이용해서 필요한 리소스를 자동적으로 다운받아서 프로젝트 개발에 필요한 환경을 만들어준다. 아래는 Android Studio를 설치하고 최초 프로젝트를 생성할 때 gradle 이 maven 의 repository에서 필요한 리소스를 다운받는 모습이다.

![download library](http://asset.hibrainapps.net/saltfactory/images/118883df-48b7-4e43-95b2-366fcae6abda)

이제 프로젝트 생성 절차가 모두 마쳤다. Gradle이 필요한 모든 리소스를 다운 받고 나면 Android Studio IDE 화면으로 전환이 된다.

## Preview 윈도우

화면은 Project의 파일을 보는 Navigation 창과 Editor 창 그리고 안드로이드 Layout을 볼수 있는 Preview 창이 동시에 열릴 것이다.

![preview](http://asset.hibrainapps.net/saltfactory/images/77cd6e63-a553-4f2f-b5f4-04a0147887b5)

Preview는 실제 디바이스에서 어떻게 보이는지 확인할 수 있는데 디폴트로 **Nexus 4**로 설정이 되어 있다. 디바이스를 변경해보자.

![preview nexus 4](http://asset.hibrainapps.net/saltfactory/images/a1bd25f8-72be-431a-aab6-83ca552e834e)

Preview 디바이스를 Nexus One으로 설정해보자. Nexus 4 보다 해상도도 적고 화면크기도 적은데 올바르게 나타나는 지를 바로 디바이스 모습을 보면서 확인 할 수 있다.

![preview nexus one](http://asset.hibrainapps.net/saltfactory/images/8d9b1bb1-d396-4ab8-8ffb-e39ce1545d0f)

다음은 테블릿에서 나타나는 화면을 확인하기 위해서 Nexus 10을 설정해보자. 지금은 샘플 코드가 너무 간단해서 레이아웃의 변화가 없지만 preview를 변경하면 그 디바이스에 맞는 레이아웃을 바로 확인할 수 있을 것이다.

![preview nexus 10](http://asset.hibrainapps.net/saltfactory/images/75c87108-c83e-4c67-a780-c43cada0bd9d)

다음은 App Theme를 확인해보자. App Theme를 선택하면 Theme를 선택할 수 있는 윈도우가 열릴것이다.

![app theme](http://asset.hibrainapps.net/saltfactory/images/19a6abe6-743c-4157-adc4-96cdb77d0320)

여기서 모든 Theme를 소개할 수는 없기 때문에 간단하게 하나만 테스트해보자. AppCompt 를 선택한다. 그러면 Theme가 변경되어 적용된 모습을 preview를 통해서 바로 확인할 수 있다.

![AppCompt](http://asset.hibrainapps.net/saltfactory/images/751c1bc8-7a56-4f6a-b8fa-dac940a59efa)

## Build와 Run

실행 방법은 간단하다 **Run** 버튼을 누르면 되는데 우리는 보통 안드로이드를 개발할 때 지긋지긋한 에뮬레이터 속도 때문에 디바이스로 바로 빌드한다. 그래서 빌드할 때 타겟을 선택하는 방법이 필요하다. 그래서 다음과 같이 Run의 ***Edit Cofigurations***을 선택한다.

![edit run](http://asset.hibrainapps.net/saltfactory/images/7cd78087-1704-434d-bb0c-506cc18aa1ed)

![run edit window](http://asset.hibrainapps.net/saltfactory/images/b993fc70-cc6a-4cc5-886e-cbc1d66be451)

그러면 위에 그림과 같이 ***Target Device***를 선택할 수 있다. Show Chooser dialog는 빌드할때 어떤 디바이스를 선택할지 물어보는 창이 뜨게 하는 것이고 USB device는 현재 USB에 연결된 안드로이드 디바이스를 선택하는 것이고 Emulator는 내가 설정한 Emulator를 설정한다는 것이다. 대부분 개발 속도 때문에 USB device를 사용하지만 가끔 emulator를 사용하기 때문에 ***Show choose dialog***를 선택한다. 이제 run 버튼으로 빌드하고 실행해보자.

![show target device](http://asset.hibrainapps.net/saltfactory/images/3d4ec410-41e3-436c-ab9a-7996835e7910)

Run을 실행하면 우리는 Choose a running device에서 디바이스를 선택할 수 있다. 현재 우리 연구소에서 개발 폰으로 사용하고 있는 Galaxy S3가 보인다.

![run](http://asset.hibrainapps.net/saltfactory/images/8c594ecd-9f3a-4b4c-b6d6-599d6e1814e9)

빌드가 성공하고 앱이 실행하면 Android Studio에서는 Logcat을 확인할 수 있다. 로그보는 방법과 filter 사용법은 다음에 자세하게 포스팅하겠다.

## 결론

eclipse 기반의 안드로이드 개발을 지금까지 해온 개발자라면 반드시 Android Studio를 사용하길 권하고 싶다. IntelliJ는 indexing 속도가 매우 좋다. eclipse에서 점한번 잘못 찍었다가 IDE가 먹통이 되는 경우가 있다면 IntelliJ는 그런 경우를 찾기 힘들다. 물론 대용량 자바파일들이 많아지면 IntelliJ도 메모리 튜닝을 해야하지만 상용목적으로 나온 툴이라서 안정성과 속도면에서 eclipse보다 우세한건 사실이다. 지금까지 안드로이드 개발을 eclipse에서 IntelliJ로 개발을 해왔는데 개발 속도면 때문이였다. 이런 IntelliJ를 기반해서 안드로이드 진영에서 Android Studio를 공식 개발 툴로 배포를 하기 시작했다. IntelliJ는 자동 업데이트 기능이 있는데 Android Studio도 이 기능을 그대로 사용하고 있다. 즉, 새로운 업데이트가 나오면 툴을 실행할때 자동적으로 update를 할 수 있는 기능이다. 보다 안정되고 효과적인 개발을 Android Studio로 해보는 것은 어떨까? Android Studio 사용법에 대해서는 앞으로도 지속적으로 포스팅을 할 예정이다.

## 참고

1. http://developer.android.com/sdk/installing/studio.html

