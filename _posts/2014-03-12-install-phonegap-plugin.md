---
layout: post
title : PhoneGap 프로젝트에 플러그인 설치하기기 (PhoneGap CLI, Plugman)
category : hybridapp
tags : [phonegap, hybrid, mobile, android, plugins]
comments : true
redirect_from : /233/
disqus_identifier : http://blog.saltfactory.net/233
---

## 서론

이 블로그에서는 PhoneGap 을 사용해서 하이브리드 앱을 개발하는 방법을 연재하고 있다. 하이브리드 앱이라는 말은 단순히 웹 개발 기술로 앱을 만들 수 있는 프레임워크를 사용한다고 해서 하이브리드 앱을 개발한다고 말하기는 어렵다. 하이브리드는 말 그대로 웹 기술과 네이티브 기술이 함께 접목되어져서 개발할 수 있는 개발 방법인데 PhoneGap에서는 이러한 일을 Plugins를 추가해서 사용하거나 새롭게 Plugins를 개발해서 할 수 있다. 즉, Plugins는 웹 자원과 네이티브 자원이 서로 상호 작용할 수 있는 하나의 연결도구로 PhoneGap이 만든 특정 프로토콜로 웹과 네이티브의 자원이 서로 연동할 수 있게 해준다. 국내에서 유일했던 하이브리드 앱 개발 플랫폼인 Appspresso에서도 PDK(Plugin Development Kit)으로 플러그인을 개발해서 웹과 네이티브의 상호 통신을 할 수 있는 기능을 제공 했었다.(참조. http://blog.saltfactory.net/129) 우리는 지금부터 하이브리드 앱을 만들기 위해서 PhoneGap 프로젝트에 Plugins을 설치하는 방법을 살펴보기로 한다.

<!--more-->

### PhoneGap CLI를 이용해서 PhoneGap Plugins 설치하기

PhoneGap을 사용하면서 가장 이상한것이 PhoneGap CLI와 Cordova CLI(command line interface)를 나누어서 사용하고 있다는 것이다. 쯥.. 두개가 사실 비슷한데 개발하고 있는 진영이 달라서 그렇다. PhoneGap은 Apache에 Cordova 라는 오픈소스 프로젝트로 PhoneGap을 두고 PhoneGap은 Cordova를 사용하고 있기 때문에 이런 이분화가 생기고 있다. 암튼, PhoneGap CLI로 설명을 하려고 한다. 우리는 앞에서 PhoneGap으로 **sf-phonegap-demo**라는 프로젝트를 만들었다.(만약 아직 PhoneGap 프로젝트를 만들지 않았다면 이글을 참조해서 프로젝트를 만들기 바란다. http://blog.saltfactory.net/228). **sf-phonegap-demo** 프로젝트 디렉토리 안을 살펴보자.

```
ls -l sf-phonegap-demo/
```

![](http://asset.hibrainapps.net/saltfactory/images/2054707f-3155-4e5c-98f4-205d3da6016e)

PhoneGap  프로젝트 디렉토리 밑에는 plugins라는 디렉토가 존재한다. 이 디렉토리에 우리가 사용할 plugins를 저장하는데 최초 PhoneGap 프로젝트를 생성하면 아무런 plugin을 사용하지 않기 때문에 `/plugins` 디렉토리 안에는 아무런 plugin이 존재하지 않는다. PhoneGap CLI로 Plugins을 설치하는 방법은 다음과 같다.

```
phonegap local plugin add {plugin repository}
```

웹 프로그램으로는 모바일 디바이스의 정보를 가져오는데 한계가 있다. 그래서 PhoneGap에서는 웹에서 디바이스의 정보를 가져오는 네이티브 코드를 plugin으로 만들어서 배포하고 있는데 Basic Device Information을 획득할 수 있는 **cordova-plugin-device** 플러그인을 추가해보자.

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-device.git
```

![](http://asset.hibrainapps.net/saltfactory/images/1f03080b-e17c-47cb-889e-5c3623f2c7f0)

우리는 디바이스 정보를 가져오기 위한 **org.apache.cordova.device** 플러그인을 설치했는데 이것을 직접 웹 코드에서 사용해보자. org.apache.cordova.device 플러그인을 사용하기 위한 API는 다음에서 확인할 수 있다. http://cordova.apache.org/docs/en/3.3.0/cordova_device_device.md.html#Device

/www/index.html 파일을 열어서 다음과 같이 수정하자.

```html
<!DOCTYPE html>
<!--
    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
     KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
-->
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="format-detection" content="telephone=no" />
        <!-- WARNING: for iOS 7, remove the width=device-width and height=device-height attributes. See https://issues.apache.org/jira/browse/CB-4323 -->
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
        <link rel="stylesheet" type="text/css" href="css/index.css" />
        <title>Hello World</title>
    </head>
    <body>
         <p id="deviceProperties">Loading device properties...</p>


        <script type="text/javascript" src="phonegap.js"></script>
        <script type="text/javascript">

             function onDeviceReady() {
                var element = document.getElementById('deviceProperties');
                element.innerHTML = 'Device Model: '    + device.model    + '<br />' +
                                    'Device Cordova: '  + device.cordova  + '<br />' +
                                    'Device Platform: ' + device.platform + '<br />' +
                                    'Device UUID: '     + device.uuid     + '<br />' +
                                    'Device Version: '  + device.version  + '<br />';
            }

            document.addEventListener("deviceready", onDeviceReady, false);
        </script>
    </body>
</html>
```

이전에는 device라는 오브젝트가 없었지만 org.apache.cordova.device 플러그인을 설치한 이후는 device 객체가 생성되었음을 알 수 있을 것이다. PhoneGap 프로젝트를 다시 build하고 install 해보자.

```
phonegap local build ios
```
```
phonegap local install ios
```

위와 같이 웹에서 device에 접근하는 코드를 추가하고 난 뒤에 다시 PhoneGap 프로젝트를 빌드하고 설치하면 이젠 웹에서 네이티브의 디바이스 정보를 가져올 수 있는 것을 확인할 수 있다. 아래는 아이폰 시뮬레이터에서 디바이스 정보를 획득한 화면인다.

![](http://asset.hibrainapps.net/saltfactory/images/b1dad475-54d1-4ee4-8003-701e0a530389)

그럼 Android 디바이스에도 하나의 코드로 동작하는지 살펴보자. 코드는 수정하지 않고 build와 install만 android로 변경해서 해보자.

```
phonegap local build android
```
```
phonegap local install android
```

![](http://asset.hibrainapps.net/saltfactory/images/533afacd-e512-49ef-8246-266e0575a9b4)

PhoneGap CLI를 실행해서 iOS와 android 디바이스의 정보를 가져오는 작업을 테스트해보았다. PhoneGap은 웹 기술로 네이티브 정보를 획득할 수 있다는 것을 확인했다. 다시 살펴보면 어떤 플랫폼인지 디바이스인지를 상관하지 않고 개발자는 웹 코드만 신경쓰고 작업하면 된다는 것이다. 웹 프로그램으로서는 디바이스의 자원을 사용할 수 없지만 PhoneGap에서는 Plugins 개념이라는 것을 사용해서 웹에서 접근할 수 있는 방법을 제공하고 있다.
PhoneGap에서 공식적으로 공개하고 있는 plugins은 다음과 같다.

1) Basic Device information (Device API)

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-device.git
```

2) Network connection

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-network-information.git
```

3) Battery Event

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-battery-status.git
```

4) Accelerometer

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-device-motion.git
```

5) Compass

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-device-orientation.git
```

6) Geolocation

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-geolocation.git
```

7) Camera

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-camera.git
```

8) Media

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-media.git
```

9) Media Capture

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-media-capture.git
```

10) Access File on Device(File API)

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-file.git
```

11) Access File on Network(File API)

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-file-transfer.git
```

12) Notification Dialog Box

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-dialogs.git
```

13) Notification Vibration

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-vibration.git
```

14) Contacts

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-contacts.git
```

15) Globalization

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-globalization.git
```

16) Splashscreen

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-splashscreen.git
```

17) Open new browser windows (InAppBrowser)

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-inappbrowser.git
```

18) Debug console

```
phonegap local plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-console.git
```

만약 플러그인을 삭제하고 싶으면 다음과 같이 하면 된다.

```
phonegap local plugin remove {플러그인 이름}
```

앞에서 설치한 org.apache.cordova.device 플러그인을 삭제해보자.

```
phonegap local plugin remove org.apache.cordova.device
```

![](http://asset.hibrainapps.net/saltfactory/images/9d852559-1a3d-4ce9-9345-b510ca9ca585)

### Plugman 으로 PhoneGap Plugins 설치하기

PhoneGap 3.3 이상부터는 [Plugman](http://docs.phonegap.com/en/4.0.0/plugin_ref_plugman.md.html)을 이용해서 PhoneGap의 플러그인을 설치할 수 있다. Plugman은 phonegap CLI의 phonegap local plugin install은 PhoneGap 프로젝트로 개발할 수 있는 모든 플랫폼에 해당하는 Plugin을 설치하는 것과 달리, ios 플랫폼이나 android 플랫폼등 특정 프랫폼에 해당하는 Plugin만 설치할 수 있다. Plugman을 사용하려면 NPM으로 Plugman을 설치해야한다.

```
npm install -g plugman
```

PhoneGap 프로젝트 디렉토리에서 다음과 같이 plugman을 이용해서 ios에 플랫폼에 해당하는 Plugin을 설치해보자. 기본적으로 plugman을 사용하려면 다음과 같은 입력해야한다.

```
plugman install --platform {플랫폼(ios, android)} --project {플랫폼의 프로젝트 디렉토리} --plugin {플러그인 소스 위치}
```

```
plugman install --platform ios --project ./platforms/ios --plugin https://git-wip-us.apache.org/repos/asf/cordova-plugin-device.git
```

이렇게 plugman으로 특정 플랫폼에 Plugin을 설치하면 다음과 같은 경로에 Plugin에 관련된 파일들이 생성이 된다.

1) ./platforms/ios/plugins/{Plugin ID 이름으로 만들어진 디렉토리}

```
예) ./platforms/ios/plugins/org.apache.cordova.device
```

2) ./platforms/ios/{XcodeProject}/Plugins/{Plugin ID 이름으로 만들어진 디렉토리}

```
./platforms/ios/SF-PhoneGap-Demo/Plugins/org.apache.cordova.device
```

3) ./platforms/ios/cordova_plugins.js 설정 추가

```javascript
cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/org.apache.cordova.device/www/device.js",
        "id": "org.apache.cordova.device.device",
        "clobbers": [
            "device"
        ]
    }
];
module.exports.metadata =
// TOP OF METADATA
{
    "org.apache.cordova.device": "0.2.8"
}
// BOTTOM OF METADATA
});
```

plugman은 특정 registry 안에서 Plugins을 검색할 수 있고 정보도 확인할 수 있다.

> plugman을 사용할 때, 주의할 것은 plugman search와 plugman info 명령어로 가능한데 현재 npm의 다운로드 최고 버전인 0.20.2에서는 이 두가지 명령어가 무조건 undefined를 발생하는 버그가 있다.

만약 plugman 버전이 0.20.2일 경우 가장 최근 버전으로 (현재 개발 최고 버전은 0.20.3-dev) 재설치하기 바란다.

plugman의 버전을 확인한다.

```
plugman -v
```

plugman의 버전이 0.20.2일 경우, plugman을 제거한다.

```
npm remove -g plugman
```

plugman의 가장 최근 소스를 받아온다.

```
git clone https://git-wip-us.apache.org/repos/asf/cordova-plugman.git
```

plugman 소스 디렉토리로 이동한다.

```
cd cordova_plugman
```

plugman을 전역에서 사용할 수 있도록 설치한다.

```
npm install -g
```

이제 plugman으로 여러가지 등록된 플러그인을 검색할 수 있다. device에 관련된 플러그인을 검사할 때 다음과 plugman search를 사용한다.

```
plugman search device
```

![](http://asset.hibrainapps.net/saltfactory/images/e0e38ebd-19da-4053-b739-514def6cf472)

plugman search는 http://plugins.cordova.io 라는 plugins 저장소에서 등록된 Plugins을 검색하게 해준다. 마치 npm이나 homebrew를 사용하는 것과 유사하다. 이 곳에 등록된 Plugin을 설치하기 위해서는 위에서와 같이 URI 경로를 모두 입력할 필요없이 다음과 같이 plugin의 ID로 설치가 가능하다.

```
plugman install --platform ios --project ./platforms/ios --plugin org.apache.cordova.device
```

현재 registry에 등록되어 있는 Plugin의 정보를 plugman info {Plugin ID}로 확인할 수 있다.

```
plugman info org.apache.cordova.device
```

![](http://asset.hibrainapps.net/saltfactory/images/bbb79dfb-df70-4b20-9b9a-5e549c3a9e93)

이렇게 Plugman으로 PhoneGap의 Plugins을 설치할 수 있다. 하지만 아직 Plugman으로 설치한 Plugin을 PhoneGap CLI로 빌드하면 사용할 수 있는 방법이 명확하지 않다.

현재 Plugman으로 테스트하면서 겪게된 문제는 다음과 같다. (만약 이 문제에 대해서 해결 방법을 아는 개발자나 연구원은 피드백을 주면 감사하겠습니다.)
> Plugman으로 Plugins을 설치하고 phonegap local build ios를 했을 때 PhoneGap이 Plugins을 사용하기 위해서 설정하는 ./platforms/ios/cordova_plugins.js가 초기화 되어 버리고 ./platforms/ios/plugins 디렉토리가 삭제되어 버린다. 하지만 Plugins의 네이티브 코드가 저장되어 있는 ./platforms/ios/{Xcode 프로젝트 디렉토리}/Plugins 디렉토리는 존재한다. 이런 이유 때문에 Plugman으로 Plugins을 설치후 PhoneGap CLI로 phonegap local build ios를 하면 Plugins을 사용할 수 있는 javascript가 올라오지 않는 문제가 있다. 아직 PhoneGap CLI가 이것을 처리하지 못하는 버그인지는 모르겠지만 현재 PhoneGap CLI 버전인 3.4.0-0.19.7 버전에서는 Plugman으로 설치한 Plugins을 로드하지 못하는 문제가 있다.

## 결론

PhoneGap은 PhoneGap CLI를 Node.js로 마이그레이션 했다. 실제 PhoneGap CLI를 npm으로 설치하고 파일을 살펴보면 node.js를 사용하고 있다는 것을 알 수 있다. PhoneGap CLI 동작 역시 Node.js 기반으로 동작한다. PhoneGap과 Cordova의 CLI는 Node.js로 만들어진만큼 Node.js의 라이브러리들을 사용해서 수정하거나 추가 개발할 수도 있다. PhoneGap 프로젝트에 Plugin을 설치하기 위해서 PhoneGap CLI를 이용하는 방법과 Plugman을 이용해서 설치하는 두가지 방법이 존재한다. PhoneGap CLI이 Node.js를 사용하듯 PhoneGap의 Plugins 역시 Node.js의 모듈을 관리하는 NPM 처럼 Plugman을 이용해서 Plugins을 관리하려고 하는 것 같다. 하지만 아직 Plugman은 버그가 많아서 실제 적용하기에는 무리가 있어보인다. NPM으로 배포하고 있는 Plugman 은 아직 plugman search와 plugman info등 plugman의 기능이 제대로 실행되지 않고, 현재 PhoneGap CLI에서는 Plugman으로 특정 플랫폼에 설치한 Plugins을 적용하기 위해 phonegap local build로 빌드하면 Plugins이 로드되지 않는 버그가 있다. 하지만 PhoneGap CLI로 Plugin을 설치하는데는 모든 플랫폼에 적용되는 Plugins을 한번에 설치하는 것이기 때문에 특정 플랫폼에 Plugins을 적용하거나 개발하기에는 Plugman이 더 유용할 것이라고 예상된다. 아직은 개발 단계인것 같다. Plugman이 보다 안정되고 PhoneGap CLI와 연동이 잘 이루어진다면 PhoneGap CLI로 Plugins을 설치하는 것 보다 편리하게 사용할 수 있을 것 같다.

PhoneGap의 궁극적 목표는 하나의 웹 코드로 여러가지 플랫폼에 동작하는 앱을 만들어 내는 것이다. 그렇기 위해서는 웹 코드와 네이트 코드를 플러그인으로 만들어서 사용해야하는데 PhoneGap에서 공식적으로 지원하고 있는 Plugins 말고도 http://plugins.cordova.io에 사용자들이 플러그인을 개발해서 등록할 수 있다. 이 때 역시 plugman을 이용해서 npm에 Node.js 모듈을 등록하는 것과 유사하게 할 수 있다. Plugins이 많다는 것은 웹 코드만 신경쓰고 네이티브 코드를 작성하지 않아도 된다는 말이다. 그래서 Plugins의 각각 사용법 역시 중요한데 Plugins의 사용법에 대해서는 이후에 Plugins을 사용하면서 포스팅으로 소개할 예정이다.

## 참고

1. http://docs.phonegap.com/en/edge/guide_cli_index.md.html#The%20Command-Line%20Interface
2. http://docs.phonegap.com/en/3.4.0/plugin_ref_plugman.md.html#Using%20Plugman%20to%20Manage%20Plugins
3. http://qnibus.com/blog/phonegap-3-0-사용-방법/

