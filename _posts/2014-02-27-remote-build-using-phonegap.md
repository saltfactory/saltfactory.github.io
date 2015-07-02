---
layout: post
title : PhoneGap의 Remote Build로 멀티플랫폼 하이브리드 앱 반들기
category : hybridapp
tags : [phonegap, cordova, remote build, hybrid, hybridapp]
comments : true
redirect_from : /229/
disqus_identifier : http://blog.saltfactory.net/229
---

## 서론

PhoneGap을 시작하면서 복잡하게 생각드는 것은 Cordova이다. PhoneGap이면 PhoneGap 이거나 Cordova면 Cordova라면 되는데 공식 사이트 조차 이 두가지를 혼합해서 사용하고 있고 command도 sdk도 같이 업데이트 되고 있기 때문이다. PhoneGap이 Apache Foundation Software에 오픈소스로 등록해서 사용하고 있다는 것은 알겠지만 왜 두가지를 혼합해서 사용하고 있는 것일까? 이것은 꽤 혼란스런 사유가 되기도 한다. 단순하게 그냥 phonegap이나 cordova 메뉴얼을 보고 실행한다면 문제는 되지 않겠지만 분명 뭔가 다른 의도로 두가지를 나누어서 업데이트되고 있는 것은 아닐까? 라는 생각이 들기도 한다. 커뮤니티에서도 PhoneGap command는 Cordova command를 encapsulate 했고 PhoneGap Service를 추가했다는 이야기만 있을뿐 구체적인 이야기도 부족한 상태이다. 한번 시간을 내어서 이 두가지의 다른점을 자세히 조사해보고 싶은 마음이 든다. 이에 대한 설명은 이후에 하기로 기약하고 이 포스팅에서는 PhoneGap command의 기능 중에서 remote build에 대한 설명을 하려고 한다.

<!--more-->

### PhongeGap Build

PhoneGap comnand vs. Cordova command를 검색하면 PhoneGap command는 Cordova command를 포함하고 있으면서 PhoneGap Build와 같은 Adobe Service를 사용할 수 있는 기능이 추가되어 있다고 한다. PhoneGap Build에 대해서 먼저 알아보자.

![](http://cfile6.uf.tistory.com/image/2228704C5302B4283214B2)

[PhoneGap Build](https://build.phonegap.com/)는 Adobe에서 만든 **Cloud Build Service**이다. PhoneGap을 사용하여 앱을 Adobe의 PhoneGap Build 서비스로 업로드를 시키면  개발자가 직접 여러가지 플랫폼을 가진 디바이스에 빌드를 할 필요없이 자동적으로 여러가지 플랫폼에 동작하는 앱 설치 파일을 만들어주는 서비스이다. 실제 PhoneGap Build 사이트에 가면 간단하게 PhoneGap 프로젝트를 zip으로 압축해서 업로드를 시키면 자동적으로 빌드하는 프로그레스바를 확인할 수 있고 빌드가 끝나면 iOS, Android, Windows Phone 등 여러가지 플랫폼에 맞는 앱으로 자동적으로 만들어지는 것을 확인할 수 있다. 빌드가 마치고 나면 각각 해당하는 플랫폼에 맞게 빌드된 앱 설치 파일을 다운 받아서 디바이스에 설치할 수 있을 뿐만 아니라, 설치할 수 있는 QRCode를 만들어서 스마트 폰에서 QRCode Reader로 읽어서 바로 설치할 수 있는 방법도 제공하고 있다. 아래는 테스트로 만든 앱을 PhoneGap Build를 이용해서 iOS, Android, Windows Phone의 앱을 만들어낸 모습이다. PhoneGap 3 이상부터는 더이상 Blackberry, Symbian, WebOS의 앱으로 자동 빌드하는 것을 지원하지 않는다. 만약 이에 해당하는 플랫폼에 맞는 앱을 함께 만들고 싶으면 PhoneGap 3 밑의 버전으로 개발해서 PhoneGap Build로 빌드하는 것이 바람직하다.

![](http://cfile25.uf.tistory.com/image/267F543D5302B59B239129)


PhoneGap Build는 무료서비스라고 말하고 있지만 사실은 무료서비스는 하나의 private 앱을 등록할 수 있는 것을 제한하고 있다. 즉, 오픈소스 프로젝트가 아닐경우에는 개인 앱을 PhoneGap Build로 사용하고 싶을 경우 하나의 앱만을 빌드할 수 있다는 말이다. public 앱을 사용하고 싶을 경우는 Github의 repository를 이용해야만 한다. 제약 사항이 많지만 PhoneGap Build는 한번의 업로드로 여러개의 플랫폼에 맞는 앱을 자동적으로 빌드해주는 강력한 기능이 있기 때문에 여러 플랫폼 서비스에 맞는 앱을 배포할 경우 매우 유용하게 사용할 수 있을 것으로 예상된다.

![](http://cfile9.uf.tistory.com/image/2759BD4A5302B7EE1BFC79)

#### PhoneGap 프로젝트 생성

우리는 앞서 sf-phonegap-demo 라는 프로젝트를 만들어보았다. 자세한 설명은 이전 글을 참조하기 바란다. 혹시 PhoneGap 프로젝트를 생성하는 방법이나 Node.js를 이용해서 PhoneGap command를 사용하는 방법에 대해서 참고하고 싶을 경우 다음 글을 참조하면 된다. http://blog.saltfactory.net/228

PhoneGap 프로젝트를 만들지 않았다면 이전 글을 참조하던지 다음 PhoneGap command로 새로운 프로젝트를 만들어보자.

```
phonegap create sf-phonegap-demo -n SF-PhoneGap-Demo -i net.saltfactory.tutorial.phonegapdemo
```

#### PhoneGap Build 사이트를 이용하여 빌드하기

먼저 PhoneGap Build 서비스를 사이트를 통해서 이용해보자. 앞서 우리는 PhoneGap 개발 환경을 설명하면서 간단하게 PhoneGap 프로젝트를 만드는 것을 예제로 함께 해보았다. 이 PhoneGap 프로젝트로 생성한 앱을 PhoneGap Build에서 빌드를 해보자. 먼저 PhoneGap command로 만든 프로젝트 폴드를 압축한다.

```
zip -r sf-phonegap-demo.zip sf-phonegap-demo/
```

PhoneGap Build에 앱을 업로드하기 위해서 우리는 zip으로 압축을 했다. 다음은 PhoneGap Build 사이트를 연다.
https://build.phonegap.com

![](http://cfile28.uf.tistory.com/image/2219B83953035CDF135F7E)

만약 Adobe ID가 없으면 Register를 눌러 Adobe ID를 등록하고 ID가 있으면 ID로 로그인을 한다. 한번도 PhoneGap Build를 사용한 적이 없거나 기존에 앱을 등록하지 않은 상태라면 다음과 같은 화면이 나타날 것이다.

![](http://cfile27.uf.tistory.com/image/2721344C53035D570B2AA8)

앞에서 zip으로 압축한 파일을 Upload a .zip file 버튼을 눌러서 업로드한다. 업로드가 완료되면 다음과 같은 화면이 나타난다. Blackberry, Symbian, WebOS는 PhoneGap 3 이상에서 더이상 지원하지 않는다. PhoneGap은 다양한 플랫폼을 지원하기로 명성이 나있는데 이러면 왠지 멀티 플랫폼이라는 명성에 어울리지 않는것 같다. 아마도 하이브리드 앱 플랫폼으로 너무 많은 디바이스를 지원하기에는 자원이 많이 소비되는 것 같아서 가장 많이 사용하는 플랫폼에 집중하기 위해서인것도 같다. 국내의 Appspresso가 Android와 iOS를 집중해서 지원했던 것이 생각이 난다.

![](http://cfile6.uf.tistory.com/image/22292B3A5303602A0ECC7C)

zip 파일을 업로드한 것 만으로 PhoneGap Build가 빌드를 마친것은 아니다. 아래에 보면 Read to build라는 버튼이 보인다. 이제 빌드를 시작해보자. Read to build 버튼을 클릭한다. 아래는 PhoneGap Build에서 빌드를 하고 있는 화면이다. iOS는 붉은 색으로 표시 되어 있다. 나중에 설명하겠지만 빌드가 성공적으로 되지 않았다는 표시이다. 두번째 Android 아이콘은 회색으로 되어 있고 밑에 프로그레스바가 계속 움직이고 있다. 아직 Android는 빌드를 하지 않았거나 진행 중이라는 표시이다. 세번째 Windows Phone 아이콘은 파란색으로 되어 있는데 이것은 빌드가 성공적으로 마쳤다는 표시이다. 아마 모든 빌드가 끝나면 iOS를 제외하고 Android와 Windows Phone에 해당하는 빌드는 모두 성공적으로 마쳤다는 표시로 변경될 것이다. iOS는 code sign 때문인데 iOS 앱을 빌드해서 디바이스에 설치하기 위해서는 cert 파일과 provisioning 파일이 있어야하기 때문이다.

![](http://cfile2.uf.tistory.com/image/26736539530362F50C2989)

일단 앱이 빌드가 마치면 플랫폼에 설치할 수 있는 설치 파일을 다운로드 받을 수 있다. 플랫폼에 해당하는 아이콘을 클릭하면 아이콘이 가르키는 앱의 설치 파일을 다운로드 받을 수 있다. Android 아이콘을 클릭해보자. 그러면 SF-PhoneGap_Demo_debug.apk 파일이 다운로드 될 것이다. 실제 PhoneGap Build에서 빌드하여 만든 설치 파일을 디바이스에 설치할 수 있는 설치해보도록 하자. 우리는 Android SDK 디렉토리를 /Projects/Libraries/adt-bundle-mac-x86_64로 두고 있다. apk 파일을 디바이스에 설치하려면 Android SDK 디렉토리 밑에 /sdk/platform-tools/adb를 사용해야한다. USB로 Android 디바이스를 연결하고 터미널에 다음과 같이 명령어로 apk 파일을 디바이스로 설치한다.

```
/Projects/Libraries/adt-bundle-mac-x86_64/sdk/platform-tools/adb install SF_PhoneGap_Demo-debug.apk
```

![](http://cfile3.uf.tistory.com/image/2758ED3B530365AB1FCC53)

PhoneGap Build로 빌드하여 만든 apk 파일이 정상적으로 Android 디바이스에 설치된 것을 확인할 수 있다. 이제 디바이스에서 이 앱을 실행해보자.

![](http://cfile10.uf.tistory.com/image/231304455303663B339B27)

![](http://cfile25.uf.tistory.com/image/247ADC48530368392AB4A8)

위와 같이 PhoneGap Build는 앞의 포스팅에서 설명한 PhoneGap command로 build하고 install한 결과와 같다. PhoneGap Build 사이트에서는 설치를 좀 더 편리하게 하기 위해서 QRCode를 제공한다. PhoneGap Build에서 앱을 빌드해서 만들어진 QRCode를 QRCode Reader로 스캔해보자.
Naver 앱의 QRCode 검색을 해보자.

![](http://cfile22.uf.tistory.com/image/232B0E48530369641CB301)

![](http://cfile25.uf.tistory.com/image/2219573E53036A112368FB)

![](http://cfile24.uf.tistory.com/image/244DCF3453036A301E7F13)

![](http://cfile29.uf.tistory.com/image/2208323B53036A3F260CE4)

위에서 보듯이 QRCode를 스캔하면 PhoneGap Build 사이트에서 apk 파일을 자동으로 다운로드 되어서 설치되는 것을 확인할 수 있다. 그림에서는 SF_PhoneGap_Demo-debug-5.apk 파일을 다운로드 받는다고 되어 있는데 사실 너무 빨리 다운로드 되어서 스크린캡처한다고 한번에 여러 파일을 받아서 그런것이다. 아마 여러분들은 SF_PhoneGap_Demo-debug.apk 파일로 나타날 것이다. 다른 플랫폼 디바이스에 설치하는 방법은 생략하겠다. 다른 플랫폼 디바이스도 동일한 방법으로 설치할 수 있기 때문이다.

#### iOS 앱 빌드를 위한 signing key 등록

그런데 iOS는 왜 빌드 되지 않을까? PhoneGap Build 사이트에서 iOS 아이콘을 클릭해보자. 그러면 iOS 에 Error 버튼이 있는 것을 볼 수 있을 것이다. Error 버튼을 누르면 "You must provide a signing key, first." 라는 문구를 확인할 수 있다. 이것은 iOS 앱을 디바이스에 설치하기 위해서는 개발자 인증서와 provisioning 파일이 있어야하기 때문이다.

![](http://cfile27.uf.tistory.com/image/2436873453040A5208989A)

iOS 개발을 위해서는 Apple iOS 개발자에 등록이 되어 있어야 한다. 이미 등록되어 있다고 생각하고 계속 진행하겠다. 먼저 애플 개발자 사이트에 접속한다. 개발자 사이트 로그인 후에 나타는 Developer Program Resources에서 Certificates, Identifiers & Profiles 메뉴를 선택한다.

![](http://cfile27.uf.tistory.com/image/2652583C53040C62288BDE)

![](http://cfile10.uf.tistory.com/image/27152849530410151138BA)

iOS Apps 에서 Certificates를 선택한다. 그리고 만들어진 iOS Development를 다운받는다.

![](http://cfile1.uf.tistory.com/image/24603F4A53041153178862)

다운 받은 ios_devleopment.cer 파일을 더블클릭을 하면 Mac의 KeyChain Access 에 자동으로 등록이 된다. 그리고 등록된 Certificate를 선택해서 export 시킨다. 이때 iPhone Developer 인증서를 열어보면 개인키까지 포함이 되어 있는데 이 두가지를 모두 export 하도록 한다.

![](http://cfile4.uf.tistory.com/image/2308D64D530AB3CE253CE8)

export를 할때는 .p12(Personal Information Exchange) 타입으로 저장을 한다.

![](http://cfile25.uf.tistory.com/image/237BBB38530AB43701048B)

.p12로 export를 시킬 때 비밀번호를 입력하라는 화면이 나오는데 나중에 인증서를 열어보거나 확인하기 위해서 필요한 비밀번호이다.

![](http://cfile2.uf.tistory.com/image/227B693C530AB48A2EDF17)

다음은 provisioning 파일을 만들어보자. 애플 개발자 사이트에서 idenfifiers 메뉴를 클릭한다. 그리고 우리는 새로운 앱을 PhoneGap 프로젝트로 만들어서 빌드해서 배포할 것인데 그 때 우리는 net.saltfactory.tutorial.phonegapdemo 라고 지정했다. 애플 개발자 사이트에서 identifiers에서 + 버튼을 선택해서 iOS App ID를 등록한다.

![](http://cfile25.uf.tistory.com/image/26368A4C530DE83727496C)

App ID Description에 앱의 설명을 입력하고 App ID Suffix에 Explicit App ID PhoneGap 프로젝트를 생성할 때 사용한 번들 아이디(Bundle ID 또는 Package Name)을 net.saltfactory.tutorial.phonegapdemo 라고 지정하였기 때문에 이 이름으로 만든다.

![](http://cfile26.uf.tistory.com/image/22632F39530DE93F2DCCA4)

App ID 등록을 마치면 다음과 같이 App IDs에 방금 만든 App ID를 확인 할 수 있다.

![](http://cfile25.uf.tistory.com/image/216F5B4F530DE9E025A341)

App ID 등록이 마치면 Provisioning Profiles 메뉴의 Development를 선택한다. 그리고 App ID를 등록할 때와 동일하게 상단에 + 버튼을 눌러서 Provisioning Profile을 추가할 것이다.

![](http://cfile21.uf.tistory.com/image/22217133530DEA750668BF)

![](http://cfile22.uf.tistory.com/image/234A4141530DEB4F1CA9CB)

![](http://cfile8.uf.tistory.com/image/2126B43B530DEB82253236)

![](http://cfile27.uf.tistory.com/image/212AD448530DEBBF01D350)

![](http://cfile7.uf.tistory.com/image/266E8B43530DEBE303D706)

![](http://cfile21.uf.tistory.com/image/231AAE50530DEC2A2F8975)

![](http://cfile22.uf.tistory.com/image/270A2E46530DEC5F190D1B)

provisioning profile을 추가하였으면 Download를 눌러서 provisioning profile을 다운 받는다. 이제 PhoneGap Build에 iOS 앱의 key를 등록할 준비를 모두 마쳤다. 다시한번 요약하면 다음과 같다.

1. 애플 개발자 사이트에서 개발자 Certificates를 만들어서 다운받은 뒤 .p12 확장자로 export 한다.
2. 애플 개발자 사이트에서 PhoneGap 프로젝트에 사용한 번들 아이디(패키지이름)과 동일한 Provisioning Profile을 만들어서 다운받는다.

위 두가지를 모두 마치면 다시 PhoneGap Build 사이트로 이동한다. iOS 아이콘을 누르면 Error라는 빨간 버튼이 보이는데 클릭하면 You must provide a signing key, first. 라는 에러를 보여줄 것이다. 이제 key를 등록시켜보자.

iOS 아이콘 옆에 No key selected라고 셀렉트박스가 보일텐데 이것을 클릭해서 add a key를 선택한다.

![](http://cfile10.uf.tistory.com/image/220CA939530DEEBA36F2FB)

add a key를 선택하면 아래와 같이 title을 입력하라는 input 박스와 certificates(.p12) 파일과 provisioning profile을 선택하는 파일 선택박스가 나타날 것이다. 위에서 우리가 애플 개발자 사이트에 등록한 Certificates 파일(.p12)과 Provisioning Profile 파일을 선택해서 submit key를 누른다.

![](http://cfile10.uf.tistory.com/image/2445774C530DEF3713CEC9)

![](http://cfile25.uf.tistory.com/image/2732B04D530DEFCB1D4923)

Certificates(.p12)과 Provisioning Profile 파일을 업로드 했지만 아직 Error 버튼이 나타나있다. 이것은 Certificates를 export 시키면서 비밀번호를 지정하였기 때문인데 이렇게 만든 key는 처음 업로드하면 lock이 걸려있기 때문에 자물쇠 모양의 노란색 버튼을 클릭해서 lock을 해제한다.

![](http://cfile9.uf.tistory.com/image/2520224E530DF053178FFF)

이제 Rebuild 버튼을 누르면 iOS가 다시 build를 진행할것이다. 진행되는 동안 pending이라는 메세지를 보게 된다.

![](http://cfile24.uf.tistory.com/image/2565384F530DF0951C2CAA)

빌드가 모두 마치면 이젠 iOS에 설치할 수 있는 ipa 앱 파일이 만들어진 것을 확인할 수 있다. QRCode로 디바이스에 바로 설치할 수 있으니 확인해보기 바란다.

![](http://cfile22.uf.tistory.com/image/21299133530DF0D6223FE5)

### PhoneGap command로 remote build 하기

위에는 https://build.phonegap.com 사이트에서 zip 파일을 이용해서 cloud build를 보여주었다. PhoneGap Command에서는 위의 복잡한 방법을 아주 간단하게 처리할 수 있게 해준다. PhoneGap 프로젝트 파일로 이동한다.

```
cd sf-phonegap-demo
```

이제 PhoneGap remote build를 하기 위해서 login을 한다. 이때 아이디는 Adobe ID를 사용한다. Adobe ID는 https://build.phonegap.com 에 사용한 아이디와 동일하다.

```
phonegap remote login
```

![](http://cfile5.uf.tistory.com/image/2261924B530DF2420A4E22)

만약 PhoneGap command에서 remote logout을 하고 싶을경우는 다음과 같이 로그아웃을 하면 된다.

```
phonegap remote logout
```

![](http://cfile25.uf.tistory.com/image/220BB845530DF2B6342956)

만약 로그아웃된 상태라면 다시 로그인을 한다. 그리고 난 다음 이제 remote build를 실행한다.

```
phonegap remote build android
```

이렇게 phonegap command로 remote build를 실행하면 다음과 같은 에러를 보게 될 것이다. Private app limit reached. 이 에러는 우리는 PhoneGap Build에 free 서비스를 사용하고 있기 때문에 앞에서 PhoneGap Build를 설명하면서 등록한 앱이 이미 1개가 등록되어 있기 때문이다. PhoneGap Build는 free 서비스에서 개인용 앱을 1개만 빌드할 수 있기 때문이다.

![](http://cfile30.uf.tistory.com/image/23410735530DF34310A24C)

PhoneGap command를 테스트하기 위해서 PhoneGap Build 사이트에 등록된 앱을 삭제한다. Settings 메뉴를 클릭하면 나타나는 페이지의 맨 아래보면 Delete this app이라는 버튼이 보이는데 이 버튼을 클릭해서 앱을 삭제한다.

![](http://cfile26.uf.tistory.com/image/2432913C530DF403111490)

![](http://cfile28.uf.tistory.com/image/26062440530DF41A12FB76)

이제 등록된 앱이 하나도 없을 것이다. 다시 PhoneGap command를 이용해서 remote build를 해보자. 이젠 앞에와 같은 에러 없이 remote build가 진행될 것이다. 우리가 PhoneGap Build 사이트에서 복잡하게 하던 것을 PhoneGap command를 이용해서 자동화로 진행되는 것을 확인할 수 있다. 먼저 compressing the app을 진행하고 다음은 uploading the app을 하고 마지막으로 building the app을 진행하는 것은 사람이 수동으로 했던 일을 PhoneGap command가 자동으로 해주는 것이다.

```
phonegap remote build android
```

![](http://cfile4.uf.tistory.com/image/237C7B3F530DF497234D59)

이제 정상적으로 PhoneGap Build로 cloud build가 되었는지 확인해보자. 사이트에 들어가서 확인해보니 다음 아래와 같이 iOS, Android, Windows Phone 모든 앱이 정상적으로 빌드된 것을 확인할 수 있다.

![](http://cfile25.uf.tistory.com/image/2254194F530DF53F0423A9)


여기서 약간 이상하다고 생각되는 것이 왜 phonegap remote build android를 했냐는 것이다. 사실 이것은 별로 의미가 없다. 왜냐면 PhoneGap Build가 지양하는것이 바로 cloud build이다. 즉, 압축된 phonegap 프로젝트를 cloud build를 통해서 여러 플랫폼 디바이스에 동작하는 앱을 만들어내는 것이기 때문이다. 그래서 phonegap remote build android를 해도 상관 없고 다음과 같이 ios를 해도 상관 없이 remote build를 실행하면 여러 단말기로 자동으로 cloud build가 되기 때문이다.

```
phonegap remote build ios
```

![](http://cfile10.uf.tistory.com/image/2174474E530DF619104199)

위와 같이 remote build로 ios를 선택하더라도 PhoneGap Build 사이트에가서 확인하면 iOS, Android, Windows Phone 앱이 모두 cloud build된 것을 확인할 수 있다.

## 결론

PhoneGap Build는 cloud build 서비스로 PhoneGap 프로젝트로 만든 코드를 가지고 iOS, Android, Windows Phone 등 멀티 플랫폼 디바이스 앱을 한번에 빌드해주는 서비스이다. 나중에 PhoneGap API를 사용하는 예제를 보여주면서 설명하겠지만 특정 플랫폼에 종속적인 플러그인을 사용하지 않은 이상 PhoneGap API를 이용해서 단일 코드로 멀티 플랫폼 앱을 만들수 있다. 이 때 PhoneGap Build는 매우 매력적인 서비스이다. 이런 PhoneGap Build 서비스를 복잡한 과정을 거치지 않고 PhoneGap command의 remote build로 할 수 있다. PhoneGap command는 cordova command를 encapsulate 해서 adobe의 서비스를 추가한 것이라고 생각하면 된다. cordova는 PhoneGap을 오픈소스로 AFS(Apache Foundation Software)로 진행하고 있으며 PhoneGap은 cordova를 사용하면서 PhoneGap 의 특수한 서비스를 추가하고 있다. 이제 PhoneGap 프로젝트를 만들어서 테스트 기계에 deploy 하거나 또는 프로덕트를 만들어 낼 때 remote build를 사용해서 한번에 멀티 플랫폼 앱을 만들어 낼 수 있을 것이다.

## 참고

1. https://build.phonegap.com
2. http://docs.phonegap.com/en/3.0.0/guide_cli_index.md.html
3. http://docs.build.phonegap.com/en_US/3.3.0/signing_signing-ios.md.html#iOS%20Signing


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
