---
layout: post
title : PhoneGap 프로젝트 생성할 때 id, Project Name 변경되지 않는 문제 해결
category : hybridapp
tags : [phonegap, hybrid, cordova]
comments : true
redirect_from : /234/
disqus_identifier : http://blog.saltfactory.net/234
---

## 서론

PhoneGap은 정말... 좋은 하이브리드 앱 개발 플랫폼이 맞는걸까? 지금 하이브리드 앱 개발을 연구하면서 하이브리드 앱 개발 플랫폼을 PhoneGap으로 밖에 할 수 없는 것은 정말.. 울며겨자 먹기인것 같다. 뭐... 문서대로 되는 것도 적고 Node.js로 PhoneGap command를 wrapping 한것 까진 좋은데 버그도 많다. 첫번째 블로그 포스팅을 할 때만해도 Node.js로 만들어진 PhoneGap에 흥미를 가지고, 내부적으로 module system을 Node.js 방법대로 개발해서 확장도 좋을거라 생각했는데 아직 가야할 길이 멀어보인다. 오늘은 PhoneGap command로 프로젝트를 생성하고 build를 하는데 이런...PhoneGap 프로젝트의 id와 Project Name이 변경되지 않는 버그를 만났다. 휴.. 이렇게 일일히 버그를 찾아가면서 수정한다고 실제 테스트는 아직도 들어가보지도 못했다. 그럼 PhoneGap command 에서 발견한 문제를 소개한다.

<!--more-->


## PhoneGap 버전에 따른 프로젝트명 문제

현재 설치되어 있는 PhoneGap command의 버전은 3.4.0-0.19.7 버전이다.

```
phonegap -v
```

그리고 npm에 최종 버전을 살펴보면 다음과 같다.

```
npm info phonegap version
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/d506e13f-004c-4208-9178-70b0d5eb5f9d)

PhoneGap의 버전은 3.4.0 이다. 그런데 PhoneGap은 정말 문서가 헷갈리게 작성되어 있다. PhoneGap 3.4.0 메뉴얼에서 The Command-Line Interface에서는 PhoneGap command로 사용하는 것이 아니라 Cordova command를 사용하는 것을 문서로 만들어 놓았다... 뭐지?

http://docs.phonegap.com/en/3.4.0/guide_cli_index.md.html#The%20Command-Line%20Interface

참 이상한 문서이다... 그런데 이 문서를 다시 PhoneGap 사이트에서 Getting Started Guides로 들어가면 이번에는 PhoneGap command로 설명하고 있다.

http://docs.phonegap.com/en/edge/guide_cli_index.md.html#The%20Command-Line%20Interface

도대체 뭘 보고 하란 말인가???

여하튼 PhoneGap command로 PhoneGap 프로젝트를 생성해보자. 블로그에서 PhoneGap command로 프로젝트를 생성하는 방법은 다음 글에서 설명했었다. http://blog.saltfactory.net/228

```
phonegap create sf-phonegap-demo -n SF-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

위의 PhoneGap 옵션은 디렉토리는 sf-phonegap-demo로 만들고 프로젝트 이름을 `SF-PhoneGap-Demo`로 만들고 identifier를 `net.saltfactory.tutorial.phonegapdemo`로 만든다는 말이다. 위 명령어를 실행해보자.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/fc8af540-eb19-4b42-9696-f5b7f0b547b4)

**SF-PhoneGap-Demo** 프로젝트가 `sf-phonegap-demo`라는 디렉토리에 만들어졌다. 이제 PhoneGap 프로젝트에 iOS 플랫폼 앱을 빌드해보자.

```
phonegap local build ios
```

PhoneGap command로 build ios를 하면 `./platforms` 라는 디렉토리 밑에 ios 플랫폼에 동작하는 앱의 자원들이 만들어진다. 파일이 제대로 만들어졌는지 살펴보자.

```
ls ./platforms/ios
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/dff91364-0218-482b-8858-165e003ca098)

그런데 우리가 프로젝트 이름으로 명시한 `SF-PhoneGap-Demo` 이름을 무시하고 HelloWorld라는 프로젝트 이름으로 만들어 버린다. iOS 프로젝트를 열어보자. 황당하다. PhoneGap command에 분명히 identifier를 net.saltfactory.tutorial.phonegapdemo라고 명시했는데 프로젝트 안에 identifier는 `com.phonegap.helloworld`로 만들어져있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/59e2166a-167b-4e51-b651-d3f59d29e7ec)

문제를 찾아보기로 했다. PhoneGap 프로젝트의 전체 설정은 `/www/config.xml`에서 설정하고 각각 플랫폼에 맞는 config로 복사가 되는데 /www/config.xml을 열어보자.

```
vi www/config.xml
```

PhoneGap command에서 우리가 명시한 것들을 무시하고 PhoneGap이 마음대로 **HelloWorld**를 만들어 버린것이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- config.xml reference: https://build.phonegap.com/docs/config-xml -->
<widget xmlns     = "http://www.w3.org/ns/widgets"
        xmlns:gap = "http://phonegap.com/ns/1.0"
        id        = "com.phonegap.helloworld"
        version   = "1.0.0">

    <name>HelloWorld</name>

    <description>
        Hello World sample application that responds to the deviceready event.
    </description>

    <author href="http://phonegap.com" email="support@phonegap.com">
        PhoneGap Team
    </author>

    <!--
        Enable individual API permissions here.
        The "device" permission is required for the 'deviceready' event.
    -->
    <feature name="http://api.phonegap.com/1.0/device" />

    <!--
        If you do not want any permissions to be added to your app, add the
        following tag to your config.xml; you will still have the INTERNET
        permission on your app, which PhoneGap requires.
    -->
    <preference name="permissions"                value="none"/>

    <!-- Customize your app and platform with the preference element. -->
    <!-- <preference name="phonegap-version"      value="3.4.0" /> -->      <!-- all: current version of PhoneGap -->
    <preference name="orientation"                value="default" />        <!-- all: default means both landscape and portrait are enabled -->
    <preference name="target-device"              value="universal" />      <!-- all: possible values handset, tablet, or universal -->
    <preference name="fullscreen"                 value="true" />           <!-- all: hides the status bar at the top of the screen -->
    <preference name="webviewbounce"              value="true" />           <!-- ios: control whether the screen 'bounces' when scrolled beyond the top -->
    <preference name="prerendered-icon"           value="true" />           <!-- ios: if icon is prerendered, iOS will not apply it's gloss to the app's icon on the user's home screen -->
    <preference name="stay-in-webview"            value="false" />          <!-- ios: external links should open in the default browser, 'true' would use the webview the app lives in -->
    <preference name="ios-statusbarstyle"         value="black-opaque" />   <!-- ios: black-translucent will appear black because the PhoneGap webview doesn't go beneath the status bar -->
    <preference name="detect-data-types"          value="true" />           <!-- ios: controls whether data types (such as phone no. and dates) are automatically turned into links by the system -->
    <preference name="exit-on-suspend"            value="false" />          <!-- ios: if set to true, app will terminate when home button is pressed -->
    <preference name="show-splash-screen-spinner" value="true" />           <!-- ios: if set to false, the spinner won't appear on the splash screen during app loading -->
    <preference name="auto-hide-splash-screen"    value="true" />           <!-- ios: if set to false, the splash screen must be hidden using a JavaScript API -->
    <preference name="disable-cursor"             value="false" />          <!-- blackberry: prevents a mouse-icon/cursor from being displayed on the app -->
    <preference name="android-minSdkVersion"      value="7" />              <!-- android: MIN SDK version supported on the target device. MAX version is blank by default. -->
    <preference name="android-installLocation"    value="auto" />           <!-- android: app install location. 'auto' will choose. 'internalOnly' is device memory. 'preferExternal' is SDCard. -->


    <!-- Plugins can also be added here. -->
    <!--
        <gap:plugin name="Example" />
        A list of available plugins are available at https://build.phonegap.com/docs/plugins
    -->

    <!-- Define app icon for each platform. -->
    <icon src="icon.png" />
    <icon src="res/icon/android/icon-36-ldpi.png"   gap:platform="android"    gap:density="ldpi" />
    <icon src="res/icon/android/icon-48-mdpi.png"   gap:platform="android"    gap:density="mdpi" />
    <icon src="res/icon/android/icon-72-hdpi.png"   gap:platform="android"    gap:density="hdpi" />
    <icon src="res/icon/android/icon-96-xhdpi.png"  gap:platform="android"    gap:density="xhdpi" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" gap:state="hover"/>
    <icon src="res/icon/ios/icon-57.png"            gap:platform="ios"        width="57" height="57" />
    <icon src="res/icon/ios/icon-72.png"            gap:platform="ios"        width="72" height="72" />
    <icon src="res/icon/ios/icon-57-2x.png"         gap:platform="ios"        width="114" height="114" />
    <icon src="res/icon/ios/icon-72-2x.png"         gap:platform="ios"        width="144" height="144" />
    <icon src="res/icon/webos/icon-64.png"          gap:platform="webos" />
    <icon src="res/icon/windows-phone/icon-48.png"  gap:platform="winphone" />
    <icon src="res/icon/windows-phone/icon-173.png" gap:platform="winphone"   gap:role="background" />

    <!-- Define app splash screen for each platform. -->
    <gap:splash src="res/screen/android/screen-ldpi-portrait.png"  gap:platform="android" gap:density="ldpi" />
    <gap:splash src="res/screen/android/screen-mdpi-portrait.png"  gap:platform="android" gap:density="mdpi" />
    <gap:splash src="res/screen/android/screen-hdpi-portrait.png"  gap:platform="android" gap:density="hdpi" />
    <gap:splash src="res/screen/android/screen-xhdpi-portrait.png" gap:platform="android" gap:density="xhdpi" />
    <gap:splash src="res/screen/blackberry/screen-225.png"         gap:platform="blackberry" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait.png"    gap:platform="ios"     width="320" height="480" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait-2x.png" gap:platform="ios"     width="640" height="960" />
    <gap:splash src="res/screen/ios/screen-ipad-portrait.png"      gap:platform="ios"     width="768" height="1024" />
    <gap:splash src="res/screen/ios/screen-ipad-landscape.png"     gap:platform="ios"     width="1024" height="768" />
    <gap:splash src="res/screen/windows-phone/screen-portrait.jpg" gap:platform="winphone" />

    <!--
        Define access to external domains.

        <access />            - a blank access tag denies access to all external resources.
        <access origin="*" /> - a wildcard access tag allows access to all external resource.

        Otherwise, you can specify specific domains:
    -->
    <access origin="http://127.0.0.1*"/> <!-- allow local pages -->
    <!--
        <access origin="http://phonegap.com" />                    - allow any secure requests to http://phonegap.com/
        <access origin="http://phonegap.com" subdomains="true" />  - same as above, but including subdomains, such as http://build.phonegap.com/
        <access origin="http://phonegap.com" browserOnly="true" /> - only allows http://phonegap.com to be opened by the child browser.
    -->

</widget>
```

iOS 프로젝트를 삭제해보자. 아쉽게도 PhoneGap command는 플랫폼을 제거하는 명령어가 없다. cordova command를 설치하자.

```
npm install -g cordova
```

이젠 cordova command로 iOS 플랫폼을 제거할 수 있다.

```
cordova platform remove ios
```

이젠 iOS 플랫폼 코드를 모두 제거했으니 www/config.xml을 다음과 같이 수정하자.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- config.xml reference: https://build.phonegap.com/docs/config-xml -->
<widget xmlns     = "http://www.w3.org/ns/widgets"
        xmlns:gap = "http://phonegap.com/ns/1.0"
        id        = "net.saltfactory.tutorial.phonegapdemo"
        version   = "1.0.0">

    <name>SF-PhoneGap-Demo</name>

    <description>
        Hello World sample application that responds to the deviceready event.
    </description>

    <author href="http://phonegap.com" email="support@phonegap.com">
        PhoneGap Team
    </author>

    <!--
        Enable individual API permissions here.
        The "device" permission is required for the 'deviceready' event.
    -->
    <feature name="http://api.phonegap.com/1.0/device" />

    <!--
        If you do not want any permissions to be added to your app, add the
        following tag to your config.xml; you will still have the INTERNET
        permission on your app, which PhoneGap requires.
    -->
    <preference name="permissions"                value="none"/>

    <!-- Customize your app and platform with the preference element. -->
    <!-- <preference name="phonegap-version"      value="3.4.0" /> -->      <!-- all: current version of PhoneGap -->
    <preference name="orientation"                value="default" />        <!-- all: default means both landscape and portrait are enabled -->
    <preference name="target-device"              value="universal" />      <!-- all: possible values handset, tablet, or universal -->
    <preference name="fullscreen"                 value="true" />           <!-- all: hides the status bar at the top of the screen -->
    <preference name="webviewbounce"              value="true" />           <!-- ios: control whether the screen 'bounces' when scrolled beyond the top -->
    <preference name="prerendered-icon"           value="true" />           <!-- ios: if icon is prerendered, iOS will not apply it's gloss to the app's icon on the user's home screen -->
    <preference name="stay-in-webview"            value="false" />          <!-- ios: external links should open in the default browser, 'true' would use the webview the app lives in -->
    <preference name="ios-statusbarstyle"         value="black-opaque" />   <!-- ios: black-translucent will appear black because the PhoneGap webview doesn't go beneath the status bar -->
    <preference name="detect-data-types"          value="true" />           <!-- ios: controls whether data types (such as phone no. and dates) are automatically turned into links by the system -->
    <preference name="exit-on-suspend"            value="false" />          <!-- ios: if set to true, app will terminate when home button is pressed -->
    <preference name="show-splash-screen-spinner" value="true" />           <!-- ios: if set to false, the spinner won't appear on the splash screen during app loading -->
    <preference name="auto-hide-splash-screen"    value="true" />           <!-- ios: if set to false, the splash screen must be hidden using a JavaScript API -->
    <preference name="disable-cursor"             value="false" />          <!-- blackberry: prevents a mouse-icon/cursor from being displayed on the app -->
    <preference name="android-minSdkVersion"      value="7" />              <!-- android: MIN SDK version supported on the target device. MAX version is blank by default. -->
    <preference name="android-installLocation"    value="auto" />           <!-- android: app install location. 'auto' will choose. 'internalOnly' is device memory. 'preferExternal' is SDCard. -->

    <!-- Plugins can also be added here. -->
    <!--
        <gap:plugin name="Example" />
        A list of available plugins are available at https://build.phonegap.com/docs/plugins
    -->

    <!-- Define app icon for each platform. -->
    <icon src="icon.png" />
    <icon src="res/icon/android/icon-36-ldpi.png"   gap:platform="android"    gap:density="ldpi" />
    <icon src="res/icon/android/icon-48-mdpi.png"   gap:platform="android"    gap:density="mdpi" />
    <icon src="res/icon/android/icon-72-hdpi.png"   gap:platform="android"    gap:density="hdpi" />
    <icon src="res/icon/android/icon-96-xhdpi.png"  gap:platform="android"    gap:density="xhdpi" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" />
    <icon src="res/icon/blackberry/icon-80.png"     gap:platform="blackberry" gap:state="hover"/>
    <icon src="res/icon/ios/icon-57.png"            gap:platform="ios"        width="57" height="57" />
    <icon src="res/icon/ios/icon-72.png"            gap:platform="ios"        width="72" height="72" />
    <icon src="res/icon/ios/icon-57-2x.png"         gap:platform="ios"        width="114" height="114" />
    <icon src="res/icon/ios/icon-72-2x.png"         gap:platform="ios"        width="144" height="144" />
    <icon src="res/icon/webos/icon-64.png"          gap:platform="webos" />
    <icon src="res/icon/windows-phone/icon-48.png"  gap:platform="winphone" />
    <icon src="res/icon/windows-phone/icon-173.png" gap:platform="winphone"   gap:role="background" />

    <!-- Define app splash screen for each platform. -->
    <gap:splash src="res/screen/android/screen-ldpi-portrait.png"  gap:platform="android" gap:density="ldpi" />
    <gap:splash src="res/screen/android/screen-mdpi-portrait.png"  gap:platform="android" gap:density="mdpi" />
    <gap:splash src="res/screen/android/screen-hdpi-portrait.png"  gap:platform="android" gap:density="hdpi" />
    <gap:splash src="res/screen/android/screen-xhdpi-portrait.png" gap:platform="android" gap:density="xhdpi" />
    <gap:splash src="res/screen/blackberry/screen-225.png"         gap:platform="blackberry" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait.png"    gap:platform="ios"     width="320" height="480" />
    <gap:splash src="res/screen/ios/screen-iphone-portrait-2x.png" gap:platform="ios"     width="640" height="960" />
    <gap:splash src="res/screen/ios/screen-ipad-portrait.png"      gap:platform="ios"     width="768" height="1024" />
    <gap:splash src="res/screen/ios/screen-ipad-landscape.png"     gap:platform="ios"     width="1024" height="768" />
    <gap:splash src="res/screen/windows-phone/screen-portrait.jpg" gap:platform="winphone" />

    <!--
        Define access to external domains.

        <access />            - a blank access tag denies access to all external resources.
        <access origin="*" /> - a wildcard access tag allows access to all external resource.

        Otherwise, you can specify specific domains:
    -->
    <access origin="http://127.0.0.1*"/> <!-- allow local pages -->
    <!--
        <access origin="http://phonegap.com" />                    - allow any secure requests to http://phonegap.com/
        <access origin="http://phonegap.com" subdomains="true" />  - same as above, but including subdomains, such as http://build.phonegap.com/
        <access origin="http://phonegap.com" browserOnly="true" /> - only allows http://phonegap.com to be opened by the child browser.
    -->

</widget>

```

다시 PhoneGap command로 iOS 프로젝트를 빌드해보자.

```
phonegap local build ios
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/784a21c2-8cae-4c90-8e2f-febd66b45c26)

www/config.xml에서 id와 name을 변경하고 다시 빌드하니 이젠 제대로 프로젝트 이름으로 만들어지는 것을 확인할 수 있다. iOS 프로젝트를 열어보자. 프로젝트를 열어보면 우리가 id를 변경한 대로 identifier가 변경되어 있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8b918b1f-fae8-4a60-a349-e64951e62292)

Cordova command를 사용해서 PhoneGap command 문제를 해결해야한다면 굳이 PhoneGap command를 사용해야하는걸까? Cordova command로 프로젝트를 생성해보기로 하자. 존재하던 PhoneGap 프로젝트 디렉토리를 삭제한다.

```
rm -rf sf-phonegap-demo
```

우리는 앞에서 Cordova command를 npm으로 설치했다.

```
npm install -g cordova
```

cordova command로 Cordova 프로젝트를 만들어보자

```
cordova create sf-phonegap-demo -n SF-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7f77441f-d6e7-4f3e-97cd-05840b853b4c)

Cordova command는 PhoneGap command와 프로젝트 생성하는 옵션이 다르다. Cordova command로 `-name`과 `-identifier` 옵션을 주고 마들면 이 옵션들이 모두 적용되지 않고 디폴트로 HellowCordova라는 이름과 id가 `io.cordova.hellocordova`로 만들어지는 것을 확인할 수 있다. Cordova 프로젝트는 PhoneGap 프로젝트와 디렉토리 구조가 약간 다른데 PhoneGap의 `www/config.xml`의 경로가 `config.xml` 경로로 만들어진다. config.xml을 열어보자.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="io.cordova.hellocordova" version="0.0.1" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>HelloCordova</name>
    <description>
        A sample Apache Cordova application that responds to the deviceready event.
    </description>
    <author email="dev@cordova.apache.org" href="http://cordova.io">
        Apache Cordova Team
    </author>
    <content src="index.html" />
    <access origin="*" />
</widget>

```

Cordova로 만든 프로젝트의 config.xml에 위와 같이 정의가 되어 있다. Cordova command로 iOS 플랫폼을 추가해보자.

```
cordova platform add ios
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/19e1cbd6-ea27-443c-8888-d81fac04df08)

디폴트로 만들어진 Cordova 프로젝트에서 iOS 플랫폼을 추가하면 config.xml에 적용된 HelloCordova라는 이름으로 iOS 프로젝트가 만들어진다. iOS 프로젝트를 열어보면 identifier가 io.cordova.hellocordova로 만들어진것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/bc9a969d-7821-4f0f-92b0-dd83231e21f2)

Cordova command로 프로젝트를 만들 때는 다음과 같이해야 한다. 만들어진 프로젝트 디렉토리를 삭제하고 다음과 같이 다시 만들자.

```
cordova create {프로젝트 디렉토리 이름} {프로젝트 identifier} {프로젝트 이름}
```

```
cordova create sf-phonegap-demo net.saltfactory.tutorial.phonegapdemo SF-PhoneGap-Demo
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/1d48ea32-3c42-4c99-b15f-b6059af5487d)

위와 같이 Cordova command로 생성하면 이젠 프로젝트 이름과 identifier가 정확하게 적용되어서 만들어진 것을 확인할 수 있다. config.xml을 열어보자. 아래와 같이 id와 name이 우리가 원하는 설정으로 만들어진 것을 확인할 수 있다.

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="net.saltfactory.tutorial.phonegapdemo" version="0.0.1" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>SF-PhoneGap-Demo</name>
    <description>
        A sample Apache Cordova application that responds to the deviceready event.
    </description>
    <author email="dev@cordova.apache.org" href="http://cordova.io">
        Apache Cordova Team
    </author>
    <content src="index.html" />
    <access origin="*" />
</widget>
```

이제 Cordova command로 iOS 플랫폼을 추가해보자.

```
cordova platform add ios
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/8d7dfbde-1de8-4d12-9cc1-036de0b30d6e)

위와 같이 id와 name 기반으로 iOS 플랫폼에 iOS 프로젝트가 SF-PhoneGap-Demo로 만들어진것을 확인할 수 있다. iOS 프로젝트를 열어보자. 프로젝트를 열어보면 아래와 같이 identifier가 net.saltfactory.tutorial.phonegapdemo로 만들어진 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/9c40b6d7-a669-4cff-94c8-8309047bbbb0)

## 결론

PhoneGap은 Node.js를 사용해서 PhoneGap command를 만들었다. PhoneGap은 CLI 시스템을 모두 Node.js로 마이그레션 했다. 앞으로 Node.js 모듈과 함께 여러가지 기능을 추가할 확장성을 생각하는 것 같은데, 현재 다양한 버그가 발견되고 있다. 최소한 프로젝트 생성은 바로 되어야지... PhoneGap command보다는 Cordova command가 좀더 안정적인것 같다. PhoneGap command는 Cordova command를 encapsulation하고 있는데 왜이런지 모르겠다. 버그라고 밖에 볼 수 없다. PhoneGap command로 프로젝트를 생성하고 관리하는데 아직 부족한것 처럼 보인다. 그럼 Cordova command로 프로젝트를 관리하면 어떨까? PhoneGap으로 프로젝트를 생성하면 phonegap.js가 PhoneGap API를 관리하지만 Cordova로 프로젝트를 생성하면 cordova.js로 API를 관리하게 된다. PhoneGap은 Cordova 를 사용하고 있다. 그래서 PhoneGap command와 Cordova command를 같이 사용할 수 있고 같은 API 접근이 가능하다. 하지만 계속 이렇게 이분화 적인 문서와 개발은 개발자에게 혼동을 주는 것 같다. 그리고 PhoneGap command에 버그 때문에 아직은 여러가지 찾아보고 수정해서 개발해야하는 불편함이 있다. PhoneGap처럼 대형 프로젝트 플랫폼이 좀더 안정적이고 명확한 사용 방법이 소개되면 좋겠다.

## 참조

1. http://docs.phonegap.com/en/edge/guide_cli_index.md.html
2. https://cordova.apache.org/docs/en/3.4.0/guide_cli_index.md.html#The%20Command-Line%20Interface


