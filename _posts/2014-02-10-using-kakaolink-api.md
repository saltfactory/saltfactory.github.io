---
layout: post
title : KakaoLink API 사용하여 카카오톡에서 메세지보내기
category : mobile
tags : [kakaolink, api, mobile, intellij]
comments : true
redirect_from : /225/
disqus_identifier : http://blog.saltfactory.net/225
---

## 서론

며칠전 카카오가 드디어 API를 공개했다. 카카오는 모바일 플랫폼에만 국한된 라이브러리만 공개했다. 개인적으로 RESTful을 지원하는 Open API를 만들어주길 바랬지만.. 그래도 페이스북에서 SDK를 공개하듯 카카오도 이젠 iOS, Android SDK를 공개해서 배포하면서 개발자들을 개발할 수 있는 리소스를 공개했다. 카카오 개발자 페이지에서 좀더 자세한 설명은 참고하길 바란다. 블로그에서 카카오 개발에 관한 자료를 연재하려고한다. 첫번째로 안드로이드 개발을 하기 위한 설정 방법을 소개한다. 카카오 개발자 페이지에서 안드로이드 SDK를 설명하는 내용은 eclipse 기반이다. 하지만 우리는 IntelliJ로 안드로이드를 개발하고 있기 때문에 안드로이드 SDK 사용하는 방법을 IntelliJ로 개발하는 방법을 소개한다.

<!--more-->

### 카카오 개발자 등록

먼저 카카오 개발자 사이트에 개발자를 등록한다. https://developers.kakao.com/login

### 앱 등록

개발자 등록이 끝나면 내 애플리케이션을 등록한다. https://developers.kakao.com/apps
데모를 위해서 **sf-kakao-demo** 라는 이름으로 앱을 등록했다.

![](http://cfile21.uf.tistory.com/image/22320B4452F84D0F08DB4A)

다음은 개발 플랫폼을 추가한다. 먼저 Android 앱을 개발하는 예제를 만들것이기 때문에 Android 플랫폼을 추가한다. 등록한 앱을 선택하면 "설정"이라는 메뉴를 선택하면 플랫품을 추가할 수 있다.

![](http://cfile24.uf.tistory.com/image/2238374252F84DF22FAD09)

![](http://cfile3.uf.tistory.com/image/21476D4752F84E3717B281)

Android 플랫폼을 추가하면 Android 개발할 때 사용하는 패키지명을 입력한다. 우리는 데모용 앱을 만들것이기 때문에 `net.saltfactory.tutorial.kakaodemo` 라는 패키지명을 사용했다.

![](http://cfile2.uf.tistory.com/image/2360593D52F84E510C62F9)

![](http://cfile1.uf.tistory.com/image/2412AC4F52F84FD71A720B)

패키지명을 입력하면 마켓 URL까지 자동으로 추가되어진다. 이젠 키 해시를 만들어서 추가를 한다. Android 키 해시를 만드는 방법은 다음과 같다. 터미널에서 다음 명령어를 입력한다. 명령어를 입력하면 키해시가 만들어지는데 이것을 "키 해시" 란에 입력한다.

```
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

![](http://cfile3.uf.tistory.com/image/2257F24A52F8511D2D7898)

![](http://cfile1.uf.tistory.com/image/257A7A4A52F8522E2153FD)

### SDK 다운로드

이제 앱 등록은 모두 마쳤다. 개발에 필요한 SDK를 다운 받는다. https://developers.kakao.com/docs/sdk 에서 안드로이드 SDK를 다운받는다.

![](http://cfile28.uf.tistory.com/image/266BC35052F852F4058787)

![](http://cfile1.uf.tistory.com/image/2432013552F853A3122D0E)

다운 받은 zip 파일을 unzip 한다. 다운 받은 sdk 디렉토리 안에는 sdk, samples 그리고 templates 디렉토리가 존재한다.

![](http://cfile2.uf.tistory.com/image/24208E4A52F8542719B530)

### 안드로이드 프로젝트 생성

이젠 안드로이드 앱을 개발하기 위해서 안드로이드 프로젝트를 생성한다. **sf-kakao-demo**라는 이름으로 안드로이드 앱 프로젝트를 생성한다.
패키지 이름은 카카오 개발자 사이트에 안드로이드 앱을 등록한 패키지명을 입력한다. 우리는 `net.saltfactory.tutorial.kakaodemo`라고 지정했기 때문에 패키지를 `net.saltfactory.tutorial.kakaodemo`로 입력했다.

![](http://cfile27.uf.tistory.com/image/242B1F4252F8878B386026)

이렇게 입력한 후 Finish를 선택하면 비어있는 기본적인 안드로이드 프로젝트가 완성된다.

![](http://cfile21.uf.tistory.com/image/235B3D3552F887D30F8747)

이젠 다운 받은 SDK 를 import 한다. IntelliJ에서 File > import Module을 선택한다.

![](http://cfile10.uf.tistory.com/image/2578594652F887F928C55A)

import Module을 선택하면 import할 파일을 찾는 탐색기가 열리는데 이때 앞에서 다운받은 SDK 디렉토리 밑에 kakao-android-sdk-1.0.10 프로젝트를 선택한다.

![](http://cfile1.uf.tistory.com/image/2250A13652F8566512CCE9)

import할 모듈을 선택하면 Create module from existing sources를 선택한다.

![](http://cfile23.uf.tistory.com/image/2510594152F856CB3A3875)

그러면 관련된 모듈이 모두 체크된 것을 확인할 수 있다. 모든 모듈을 한번에 import할 수 있게 모두 체크한다.

![](http://cfile23.uf.tistory.com/image/2519AF4D52F857040D0A0F)

관련된 모듈을 선택하면 필요한 라이브러리들을 자동으로 찾아내는데 모든 라이브러리들을 가져올 수 있게 체크한다.

![](http://cfile22.uf.tistory.com/image/216D904152F8576104313C)

모듈간의 의존성을 검사해서 자동으로 의존성 모듈을 찾아낸다. 모두 체크한다음 Next를 누른다.

![](http://cfile28.uf.tistory.com/image/26167A3C52F857AA29BE82)

마지막으로 모듈이 어떤 프레임워크로 개발 되었는지 확인하는 작업에서 디렉토리를 검사해서 `AndroidManifest.xml`을 찾아내어 안드로이드 프로젝트인 것을 확인하는데 모두 안드로이드 프로젝트 이므로 체크한 상태에서 Finish 버튼을 누른다.

![](http://cfile3.uf.tistory.com/image/2758143652F857E01F953D)

이렇게 Import Module 작업을 마치면 우리가 개발하기로한 프로젝트가 담긴 워크스페이스에 SDK와 관련된 모듈들이 모두 import 된 것을 확인할 수 있다.

![](http://cfile26.uf.tistory.com/image/2264DF3F52F888692AFDEB)

### 샘플 프로젝트 실행

기본 모듈들을 import한 뒤에 샘플 프로젝트를 실행할 수 있게 된다. 샘플중에서 kakaolink-sample을 실행해보자. 먼저 kakaolink-sample 프로젝트의 `AndroidManifest.xml` 을 연다. AndroidManifest 파일 안에는 `com.kakao.sdk.AppKey`라는 엘리먼트가 보이는데 값이 `@string/kakao_app_key`를 사용하고 있다. `res/values/kakao-strings.xml` 파일을 열어보자. 예제로 만들어진 `kakao_app_key`와 `kakao_scheme`가 보일 것이다. kakao_app_key는 앱 고유 키이고, kakao_scheme는 카카오 어플에서 우리가 만들 카카오 연동 앱을 열어줄 스키마로 앱 키 앞에 kakao를 붙이는 것이다.

```xml
<resources>
    <string name="kakao_app_key">앱키</string>
    <string name="kakao_scheme">kakao앱키</string>
    <string name="kakaolink_host">kakaolink</string>
</resources>
```

안드로이드 폰으로 빌드해자. 카카오 연동 앱은 반드시 카카오 어플이 있어야만 한다. 즉, 안드로이드 폰에 카카오톡이 설치가 되어 있어야하기 때문에 에뮬레이터에서 사용은 할 수 없다. 카카오톡이 설치된 안드로이드 폰으로 빌드한다. 에러 없이 간단히 실행이 되는 것을 확인할 수 있다.

![](http://cfile3.uf.tistory.com/image/214F163952F85EFF13D7CA)

보내기 버튼을 클릭해보자. kakaolink-sample 프로젝트는 Text, Link, Image, 다시 앱으로 돌아오게 연결하는 button 이렇게 전송하는 것을 예제로 만들어져있다. 확인 버튼을 눌러보자.

![](http://cfile5.uf.tistory.com/image/240F284C52F860691A4674)

확인 버튼을 누르면 카카오톡의 친구 목록이 나타난다.

![](http://cfile1.uf.tistory.com/image/2462BB4752F8611901A48D)

친구 목록 중에서 한명을 선택하자. 우리는 연구소의 강승준 연구원을 선택했다.

![](http://cfile30.uf.tistory.com/image/27499B4252F861792CD471)

kakaolink로 전송할 수 있는 친구는 여러명을 동시에 선택할 수 있다. 예로 한명만 선택했는데 여러명을 체크하면 전송할 친구들이 여러면 체크가되고 전송 목록에 담길 것이다. 확인 버튼을 클릭한다. 그러면 선택한 친구에게 Text, Image, Link, 그리고 앱을 열수 있는 버튼이 만들어져서 전송되는 것을 확인할 수 있다.

![](http://cfile22.uf.tistory.com/image/2204504352F861C519FD69)

앱으로 이동이라는 버튼을 누르면 우리가 샘플로 실행한 kakao-sample 앱이 다시 열리는 것을 확인할 수 있다.

![](http://cfile3.uf.tistory.com/image/214F163952F85EFF13D7CA)

간단하게 kakaolink-sample 앱을 실행해봤다. 우리가 실행한 앱은 Kakao SDK에 들어있는 카카오 개발자가 배포한 간단한 kakao-sample 앱이였다. 이젠 우리가 직접 우리가 만든 앱에서 kakao link를 만들어서 실행해보자.

### 기본 설정

위의 예제에서 확인한 결과 카카오 연동 앱에서 kakaolink를 사용하기 위해서 `kakao_app_key`와 `kakao_scheme`가 필요하다는 것을 확인했다. sf-kakao-demo 프로젝트의 `res/values/strings.xml`에 다음을 추가한다. kakao_app_key에는 우리가 카카오 개발자 사이트에 등록한 앱의 app key를 입력하고 kakao_scheme에는 앱 키 앞에 kakao를 붙여서 입력한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">sf-kakao-demo</string>

    <string name="kakao_app_key">앱키</string>
    <string name="kakao_scheme">kakao앱키</string>
    <string name="kakaolink_host">kakaodemo</string>
</resources>
```

카카오 SDK를 사용하기 위해서는 AndroidManifest.xml 파일을 열어서 다음과 같이 메타 정보를 입력해야한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="net.saltfactory.tutorial.kakaodemo"
          android:versionCode="1"
          android:versionName="1.0">
    <!--<uses-sdk android:minSdkVersion="17"/>-->
    <uses-sdk android:minSdkVersion="11" android:targetSdkVersion="17"/>
    <application android:label="@string/app_name" android:icon="@drawable/ic_launcher">
        <activity android:name="MyActivity"
                  android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <data android:host="@string/kakaolink_host" android:scheme="@string/kakao_scheme"/>
            </intent-filter>
        </activity>

        <meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
    </application>


</manifest>
```

다음은 sf-kakao-demo 프로젝트를 열어서 기본적으로 만들어진 `MyActivity.java` 파일을 수정한다. sf-kakao-demo 프로젝트는 간단히 버튼을 누르면 카카오링크가 카카오톡으로 전달되는 예제이다. 우선 버튼을 하나 만들자. `res/layout/main.xml`을 열어서 버튼을 하나 추가하자.

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="fill_parent"
              android:layout_height="fill_parent"
        >
    <!--<TextView-->
    <!--android:layout_width="fill_parent"-->
    <!--android:layout_height="wrap_content"-->
    <!--android:text="Hello World, MyActivity"-->
    <!--/>-->

    <Button android:id="@+id/sf_button_kakao_link"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"
            android:text="카카오링크 테스트"/>
</LinearLayout>
```

`MyMainActivity` 코드를 다음 과 같이 수정하자.

카카오링크로 보낼 수 있는 컨텐츠는 Text, Image, Webs Link, App Link를 보낼 수 있다.
* **Text**는 `kakaoTalkLinkMessageBuilder.addText("텍스트");`
* **Image**는` kakaoTalkLinkMessageBuilder.addImage("이미지 URI", 가로크기, 세로크기);`
* **Web** Link는 `kakaoTalkLinkMessageBuilder.addWebLink("개발자 사이트에 등록된 web site");`
* **App Link**는 `kakaoTalkLinkMessageBuilder.addAppLink("버튼에 올라갈 텍스트");`

여기서 주의할 점은 Link는 똑같은 타입으로 두개 지정할 수 없다. 즉, Web Link와 App Link를 동시에 사용할 수 없다. 만약 두가지 Link를 동시에 사용하면 에러가 발생한다. 그럼 Web Link도 보내고 App Link 도 보낼려면 어떻게 하면 좋을까? 카카오는 `addWebButton()`과 `addAppButton()`을 지원한다. 즉 하나는 Link로 하나는 Button으로 보내면 된다. 아래 예제는 Web Link와 App Button을 사용한 예제이다.

```java
package net.saltfactory.tutorial.kakaodemo;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import com.kakao.AppActionBuilder;
import com.kakao.KakaoLink;
import com.kakao.KakaoLinkParseException;
import com.kakao.KakaoTalkLinkMessageBuilder;

public class MyActivity extends Activity {
    private KakaoLink kakaoLink;
    private KakaoTalkLinkMessageBuilder kakaoTalkLinkMessageBuilder;

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        final String stringText = "카카오링크 테스트 텍스트";
        final String stringImage = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/t1/p320x320/1377444_10200267928260600_37355712_n.jpg";
        final String stringUrl = "http://blog.saltfactory.net";

        try {
            kakaoLink = KakaoLink.getKakaoLink(this);
            kakaoTalkLinkMessageBuilder = kakaoLink.createKakaoTalkLinkMessageBuilder();
        } catch (KakaoLinkParseException e) {
            e.printStackTrace();
            alert(e.getMessage());
        }


        Button button = (Button) findViewById(R.id.sf_button_kakao_link);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    kakaoTalkLinkMessageBuilder.addText(stringText);
                    kakaoTalkLinkMessageBuilder.addImage(stringImage, 320, 320);
                    kakaoTalkLinkMessageBuilder.addWebLink("블로그 이동", stringUrl);

                    kakaoTalkLinkMessageBuilder.addAppButton("앱열기",
                            new AppActionBuilder()
                                    .setAndroidExecuteURLParam("target=main")
                                    .setIOSExecuteURLParam("target=main", AppActionBuilder.DEVICE_TYPE.PHONE).build());

                    kakaoLink.sendMessage(kakaoTalkLinkMessageBuilder.build());

                } catch (KakaoLinkParseException e) {
                    e.printStackTrace();
                    alert(e.getMessage());
                }


            }
        });
    }

    private void alert(String message) {
        new AlertDialog.Builder(this)
                .setIcon(android.R.drawable.ic_dialog_alert)
                .setTitle(R.string.app_name)
                .setMessage(message)
                .setPositiveButton(android.R.string.ok, null)
                .create().show();
    }
}

```

안드로이드 디바이스로 빌드해보자. 우리는 레이아웃에 버튼하나만 추가했기 때문에 다음과 같이 실행 될 것이다.

![](http://cfile28.uf.tistory.com/image/21647B4052F88DA7349189)

버튼을 누르면 카카오톡 친구 목록이 나타난다. 친구 목록중에 카카오링크를 보낼 친구를 선택하면 다음과 같이 카카오톡으로 text, image, link, 앱 연결 버튼을 보낼 수 있다.

![](http://cfile6.uf.tistory.com/image/2149344052F8804F2ACAB0)

## 결론

카카오는 이전보다 좀더 확장된 SDK를 공개했다. SDK를 다운 받아서 페이스북 SDK 처럼 카카오와 연동할 수 있는 방법을 제공하고 있다. 카카오 SDK에 관련된 내용은 계속 연재할 예정이다. 첫번째로 카카오 개발자 페이지는 이클립스로 개발하는 방법만 설명이 되어 있어서 우리가 개발하는 IntelliJ로 개발하는 방법을 소개했다. 그리고 첫번째 예로 카카오링크를 앱에서 사용하는 방법을 소개했다. 카카오링크는 카카오토크빌드를 이용해서 메세지를 만들어서 링크를 보낼 수 있는데 이 때 주의해야할 점은 Web Link와 App Link를 동시에 사용할 수 없다는 것이다. 하지만 Web Link와 App Button을 동시에 사용하면 두가지 링크를 모두 메세지로 전송 할 수 있다는 것도 확인했다. 앞으로 카카오 SDK에 대한 소개를 계속하며 iOS에 관련된 자료도 곧 포스팅할 예정이다.

## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial/releases/tag/kakaolink-demo

## 참고

1. https://developers.kakao.com/docs


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
