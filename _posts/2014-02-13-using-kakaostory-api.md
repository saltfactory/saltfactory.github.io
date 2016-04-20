---
layout: post
title : KakaoStory API를 이용하여 카카오스토리 포스팅하기
category : mobile
tags : [kakaostory, api, mobile]
comments : true
redirect_from : /226/
disqus_identifier : http://blog.saltfactory.net/226
---

## 서론

이번 카카오 SDK에는 카카오 서비스의 핵심 서비스 중에 하나인 카카오스토리에 컨텐츠를 포스팅할 수 있는 기능이 포함되어 있다. 이것은 페이스북의 SDK로 페이스북에 컨텐츠를 포스팅하는 기능과 유사한데 이번 글에는 카카오 SDK를 가지고 카카오스토리에 포스팅하는 방법을 소개한다. 블로그에서 [카카오 Kakao SDK로 안드로이드 앱 개발] 이라는 제목으로 카카오 SDK의 사용 방법을 연재하고 있으니 앞서 작성한 "[카카오 Kakao SDK로 안드로이드 앱 개발] 1. 카카오링크 사용하기(kakaolink)" 글을 먼저 읽어보면 툴 설정과 SDK 설정 방법을 참조할 수 있다.

<!--more-->

### kakaostory-sample 실행해보기

카카오 SDK로 안드로이드 앱 개발 첫번째 글을 참조하면 IntelliJ에 카카오 SDK를 설치하는 방법과 카카오 개발자 사이트에 앱을 등록하는 방법에 대해서 이해했을 거라 보고 설명한다. 만약 첫번째 글을 참조하지 않았다면 반드시 첫번째 글을 읽어보길 바란다.

kakaostory-sample을 실행하기 위해서는 다음과 같은 설정이 필요하다. (이에 관련된 설명은 모두 앞 글에 설명이 되어 있다.)
1. 카카오 SDK 다운로드
2. 개발툴에 카카오 SDK 임포트
3. 카카오 개발자 사이트에 앱 등록
4. 앱 키 발급
5. 안드로이드 debug.keystore 기반의 카카오 서비스에 사용하는 key hash 생성 및 카카오 개발자 사이트에 키해시 등록

이렇게 설정이 되어 있다고 가정하고 설명을 진행한다.

#### 1) kakaostory-sample 프로젝트를 그냥 실행해본다.

kakaostory-sample을 열어서 `/res/values/kakao-strings.xml` 파일을 열어보면 다음과 같이 이미 `kakao_app_key`와 `kakao_scheme` 이 들어 있는데 이렇게 값이 들어 있다고 해서 샘플앱이 실행되는 것은 아니다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="kakao_app_key">0a0e05c7073ff55e402b1468d65d429b</string>
    <string name="kakao_scheme">kakao0a0e05c7073ff55e402b1468d65d429b</string>
    <string name="kakaostory_host">kakaostory</string>
</resources>
```

한번 아무런 수정 없이 실행해보자. 앱을 최초 실행하면 "카카오 계정으로 로그인"하기 버튼이 있는 `KakaoStoryeLoginActivity`가 실행이 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/dadddb33-a5f1-46a2-a13e-6047295d1c7c)

현재 kakao_app_key와 kakao_scheme을 수정하지 않은 상태이다. 카카오 계정으로 로그인을 눌러본다. 그러면 다음과 같이 카카오계정으로 로그인하려는 앱에서 접근하는 권한을 허용할거냐는 alert를 보게 된다. 마치 페이스북에서 앱이 페이스북의 권한을 얻는 것과 유사하다. "허용"을 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6f6e789b-f0e3-4545-9bc2-4dbc762053e5)

이렇게 카카오계정의 접근을 허용하면 다음은 `KakaoStoryMainActivity`가 열려야하는데 다시 `KakaoStoryLoginActivity`로 돌아가는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ecbb7ced-3900-495a-ae09-046ad4de5b95)

어떤 문제로 이와 같은 현상이 발생한 것일까? 화면상에서는 아무런 경고도 없고 이유도 알 수 없기 때문에 우리는 로그를 확인하기로 한다. 안드로이드 로그에서     kakao를 필터하면 kakao의 샘플 코드가 실행되면서 남기는 로그를 볼 수 있다. 밑에 녹색형광색 박스를 살펴보자. **AUTHORIZATION_FAILED**가 발생했고, **APIErrorResult**로 보여주고 있는 것을 확인 할 수 있다. 화면 캡처에서는 보이지 않지만 다음과 같은 메세지를 출력하고 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/dc019bda-6080-47b3-abcb-6ac5df917526)

```
APIErrorResult={requestURL='https://kauth.kakao.com/oauth/token?grant_type=authorization_code&code=uNKn1sPBFmbOp46d_uTR8kkYLgMcg6Fqf5X-jiL-fu6gSnYjZ7Mjjdw77DioVskxdBTV36wQQjQAAAFEHt2s9g&redirect_uri=kakao0a0e05c7073ff55e402b1468d65d429b%3A%2F%2Foauth&client_id=0a0e05c7073ff55e402b1468d65d429b&android_key_hash=fOb%2B%2Bhwpaq64Bn%2FG7q07yd%2B4Jaw%3D',
errorCode=-777,
errorMessage='http status =  Unauthorized msg = {"error":"misconfigured","error_description":"invalid android_key_hash or ios_bundle_id"}'
},
request_type = null
```

에러 내용을 잘 살펴보면 `redirect_uri`로 우리가 보았던 `kakao_scheme`이 포함되어 있고, `client_id`로 `kakao_app_key`가 전송되고 있는 것을 확인할 수 있다. 그리고 앞 글에 설명했던 key hash 값이 함께 전송이 되는데, `invalid_android_key_hash `에러가 발생하고 있다는 것을 확인할 수 있다. 즉, `kakao_app_key`와 `key hash`가 맞지 않아서 발생한 문제 때문에 앱에서 정상적인 로그인이 되지 않고 있는 것이다.

#### 2) kakaostory-sample에 앱키를 등록한다.

우리는 위에서 kakao_app_key와 key hash의 중요성을 알아보았다. 이제 개발자 사이트에 들어가서 앱 키와 키 해시 값을 확인한다. 자신이 등록한 앱의 기본설정을 열어서 앱키와 키 해시 값을 확인하다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3f106e0a-7e44-45a4-b454-3aea8a33fa6c)

확인한 값을 kakaostory-sample 프로젝트를 열어서 `/res/values/kakao-strings.xml`에 값을 입력한다. `kakao_scheme`에는 `kakao`를 앞에 붙이고  앱키를 입력하면 된다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="kakao_app_key">{등록한 앱의 앱키}</string>
    <string name="kakao_scheme">kakao{등록한 앱의 앱키}</string>
    <string name="kakaostory_host">kakaostory</string>
</resources>
```

이제 다시 디바이스로 빌드해보자. 위에서와 같은 `KakaoStoryLoginActivity`가 열리게 되고 "카카오톡 계정으로 로그인" 버튼을 누르면 정상적으로 로그인 인증을 마치고 `KakaoStoryMainActivity` 화면이 나타날 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/015f628c-fd82-4068-a229-c21eb3edb4cb)

프로필 버튼을 눌러보자. 그러면 현재 내가 사용하고 있는 카카오스토리의 배경화면과 프로필 화면 그리고 프로필 정보를 가져와서 업데이트한 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/305fb3a6-ac0a-4acd-a5de-0a101a652024)

다음은 포스팅 버튼을 눌러보자. 미리 지정한 글을 카카오스토리 내에 포스팅한 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a4bb77f4-a9cf-4639-baf4-cbf85c71c345)

컨텐츠를 자세히 눌러보면 앱 키가 내가 만든 앱의 키이기 때문에 내가 앱으로 등록한 **sf-kakao-demo**의 앱으로 등록된 것이라는 것을 확인할 수 있다. 다시 말해서 앱 키를 가지고 어떤 앱으로 글을 올렸는지 확인하는 것을 알 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/055f2d08-74c3-4692-bb08-f1fdb18c53b5)

마지막으로 "업로드" 버튼을 눌러보자. 그런데 좀 이상하다. 업로드가 완료 되었다고 하는데 업로드가 되지 않는 것을 확인할 수 있다. 소스코드를 살펴보자. `KakaoStoryMainActivity`를 열어본다. 그리고 `onClickUpload()` 메소드를 살펴보자. 카카오스토리에 이미지와 같이 포스팅을 할 경우 카카오스토리 SDK는 다음과 같이 동작을 한다.
1. 파일을 용량을 줄여서 카카오 서버로 전송한다.
2. 전송이 성공적으로 되면 글과 함께 포스팅을 완료한다.

하지만 kakaostory-sample 예제에 2번 항목이 빠져있다. 그래서 `onClickPost()` 메소드를 업로드가 완료되면 호출할 수 있게 추가한다.

```java
private void onClickUpload() {
        try {
            // TODO 갤러리나 카메라 촬영 후 image File을 올리도록
            Bitmap bitmap = BitmapFactory.decodeResource(getResources(), drawable.post_image);
            File file = new File(writeStoryImage(getApplicationContext(), bitmap));

            KakaoStoryService.requestUpload(new MyKakaoStoryHttpResponseHandler<KakaoStoryUpload>() {
                @Override
                protected void onHttpSuccess(final KakaoStoryUpload storyProfile) {
                    imageURL = storyProfile.getUrl();
                    Toast.makeText(getApplicationContext(), "success to upload image", Toast.LENGTH_SHORT).show();
                    onClickPost();
                }

            }, file);
        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }
```

다시 디바이스로 빌드해서 "업로드" 버튼을 눌러보자. 이젠 사진과 함께 `onClickPost()`가 동작되어 포스팅 예제 글과 함께 업로드가 완료된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a8ad66aa-b145-413c-803c-ff36b9d28021)

### 카카오스토리에 글 올리기 직접 구현해보기

위의 예제는 카카오 SDK에 포함된 예제인데 이제 실제 우리가 앱을 개발할 때 어떻게 사용할 수 있는지 자세히 살펴보자.
우리는 기본 프로젝트에 카카오링크를 테스트한 파일을 열어서 수정을 할 것이다. 소스코드는 다음에서 받을 수 있다.
https://github.com/saltfactory/saltfactory-android-tutorial/tree/kakaolink-demo

테스트로 작성할 클래스는 크게 4가지 이다.
1. `SFKakaoLoginActivity` : 카카오 SDK로 로그인하는 방법 포함
2. `SFKakaoProfileActivity` : 카카오스토리에서 Profile 정보를 가져오는 방법 포함
3. `SFKakaoPostActivity` : 카카오스토리에 사진과 글을 포스팅하는 방법 포함

#### 1) 앱 키수정, kakaostory_host 추가

가장 먼저해야할 일은 카카오 개발자 사이트에서 앱 키를 가지고 앱 키를 수정하는 것이다. `/res/values/strings.xml` 파일을 열어서 다음과 같이 수정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">saltfactory 카카오 SDK 데모</string>
    <string name="kakao_app_key">{앱키}</string>
    <string name="kakao_scheme">kakao{앱키}</string>
    <string name="kakaolink_host">kakolink</string>
    <string name="kakaostory_host">kakaostory</string>
</resources>
```

#### 2) SFKakaoLoginActivity 추가

카카오 SDK 로그인을 담당하는 `SFKakaoLoginActivity` 안드로이드 컴포넌트를 추가한다. 이 `SFKakaoLoginActivity`는 카카오 SDK의 로그인버튼을 이용해서 로그인하는 방법을 담고 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ecfb785f-0e6b-426a-8384-13173e85b276)

`/res/layout/login.xml` 파일에 다음 내용을 추가한다.

```xml
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="match_parent"
              android:layout_height="match_parent" android:padding="20dp">



    <com.kakao.widget.LoginButton
            android:id="@+id/sf_button_kakao_login"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:layout_marginBottom="30dp"
            android:layout_marginLeft="20dp"
            android:layout_marginRight="20dp"/>
</LinearLayout>
```

위 `login.xml` 레이아웃을 `SFKakaoLoginActivity`에 사용할 것이다. 그리고 다음과 같이 `SFKakaoLoginActivity`를 구현한다. 화면이 나타날 때 `login.xml` 을 레이아웃으로 적용하고 `loginButton`에 카카오 세션 콜백을 넣어줘서 로그인 후 세션 검사 후 세션이 존재하면 다음 화면인 MyActivity를 실행하게 하는 로직이다. 이 때 카카오 SDK에서 로그인을 `com.kakao.LoginActivity`를 내부적으로 열어서 처리한 이후 다시 닫기 때문에 현재 화면이 사라졌다가 다시 나타나는데 `onResume()`에서 세션 검사를 확인해야한다. 그렇지 않으면 로그인이 완료 되었음에도 불구하고 아무런 일을 할 수 없게 된다.

```java
package net.saltfactory.tutorial.kakaodemo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import com.kakao.Session;
import com.kakao.SessionCallback;
import com.kakao.exception.KakaoException;
import com.kakao.widget.LoginButton;

/**
 * Created by saltfactory@gmail.com
 * on 2/12/14.
 */
public class SFKakaoLoginActivity extends Activity {

    // 카카오 SDK에 포함된 카카오로그인 버튼 객체
    private LoginButton loginButton;

    // 카카오 세션콜백
    private final SessionCallback sessionCallback = new SessionCallback() {

        /**
         * 카카오 세션이 있을 경우 MyActivity를 새로운 intent로 시작한다.
         */
        @Override
        public void onSessionOpened() {
            final Intent intent = new Intent(SFKakaoLoginActivity.this, MyActivity.class);
            startActivity(intent);
            finish();
        }

        /**
         * 카카오 세션이 없을 경우
         * @param exception   close된 이유가 에러가 발생한 경우에 해당 exception.
         */
        @Override
        public void onSessionClosed(KakaoException exception) {
            loginButton.setVisibility(View.VISIBLE);
        }
    };

    /**
     * 카카오 SDK를 사용할 경우 카카오 SDK의 com.kakao.LoginActivity를 새로운 intent로 사용해서 로그인을 하는데,
     * 로그인 처리가 마치고 다시 이 클래스로 돌아오면 onResume()을 호출한다. 화면에서 사라졌다가 다시 나타날때 카카오 세션을 검사하도록 한다.
     */
    @Override
    protected void onResume() {
        super.onResume();

        if (Session.initializeSession(this, sessionCallback)) {
            loginButton.setVisibility(View.GONE);
        } else if (Session.getCurrentSession().isOpened()) {
            sessionCallback.onSessionOpened();
        }
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // login.xml 레이아웃에 안드로이드 로그인 버턴을 정의했다.
        setContentView(R.layout.login);

        loginButton = (LoginButton) findViewById(R.id.sf_button_kakao_login);
        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 카카오 로그인 버튼에 세션 콜백을 넘겨준다. 세션 콜백은 위에 정의해두었다.
                loginButton.setLoginSessionCallback(sessionCallback);
            }
        });
    }


}
```

이렇게 추가한 `SFKakaoLoginActivity`는 앱이 실행하면 가장 먼저 호출이 될 것이다. `AndroidManifest.xml` 파일을 열어서 이 컴포넌트를 추가하자. 카카오 SDK는 카카오에서 인증처리를 해야하기 때문에 `INTERNET` 권한이 필요하고 네트워크 상태를 확인하고, 사진을 가져오거나 저장하기 위해서 `STORAGE` 권한이 필요하다. 다음은 카카오 SDK가 내부적으로 `com.kakao.LoginActivity`를 사용하기 때문에 반드시 `AndroidManifest`에 등록한다. 만약 이 엑티비티를 등록하지 않으면 카카오 로그인 버튼을 아무리 눌러도 동작을 하지 않는다. 카카오 SDK를 사용할 때 빠질 수 없는 것이 앱 키이다. 다시 한번 확인하자. 그리고 이후에 다른 앱에서 앱 링크로 이 앱을 열수 있게 `android:scheme`에 카카오 스키마를 등록하는데 이 요청을 받을 수 있는 엑티비티 안에 `intent-filter` 안에 `data`로 설정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="net.saltfactory.tutorial.kakaodemo"
          android:versionCode="1"
          android:versionName="1.0">
    <!--<uses-sdk android:minSdkVersion="17"/>-->
    <uses-sdk android:minSdkVersion="11" android:targetSdkVersion="17"/>

    <!-- 카카오 SDK를 사용하기 위해서 필요한 디바이스 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application android:label="@string/sf_app_name" android:icon="@drawable/ic_launcher"
                 android:name="com.kakao.GlobalApplication" android:hardwareAccelerated="true">

        <!-- 카카오 SDK 내부적으로 로그인 처리시 com.kakao.LoginActivity를 열기 때문에 반드시 이 부분을 추가해야한다. -->
        <activity android:name="com.kakao.LoginActivity"/>

        <!-- 카카오 SDK의 로그인 버튼을 이용해서 로그인하는 엑티비티-->
        <activity android:name=".SFKakaoLoginActivity" android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <data android:host="@string/kakaostory_host" android:scheme="@string/kakao_scheme"/>
            </intent-filter>
        </activity>

        <!-- 카카오 SDK를 사용하기 위해서 카카오 개발자 사이트에 등록한 앱의 앱키 -->
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
    </application>

</manifest>
```

#### 3) MyActivity 수정

첫 번째 예제의 `MyActivity`를 좀 더 다양한 예제를 테스트하기 위해서 다음과 같이 변경했다. "카카오링크", "카카오스토리 프로파일", "카카오스토리 포스팅", "카카오 로그아웃" 버튼을 추가했는데 카카오링크는 첫 번 째 예제에서 소개한 내용이고, 카카오스토리 프로파일은 카카오스토리의 프로파일 내용을 요청하는 `SFKakaoStoryProfileActivity`를 열게되고, 카카오스토리 포스팅은 카카오스토리로 사진과 글을 포스팅할 수 있는 `SFKakaoStoryPostingActivity`를 열게 만들었다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/fb9b744d-6a7f-4963-a04a-0552f65fa628)

`/res/layout/mail.xml` 을 다음과 같이 수정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="fill_parent"
              android:layout_height="fill_parent">

    <!-- 카카오링크 테스트 버튼 -->
    <Button android:id="@+id/sf_button_kakao_link"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"
            android:text="카카오링크 테스트"/>

    <!-- 카카오스토리 프로파일 테스트 버튼 -->
    <Button android:id="@+id/sf_button_kakaostory_profile" android:layout_width="fill_parent"
            android:layout_height="wrap_content" android:text="카카오스토리 프로파일"/>

    <!-- 카카오스토리 포스팅 테스트 버튼 -->
    <Button android:id="@+id/sf_button_kakaostory_post" android:layout_width="fill_parent"
            android:layout_height="wrap_content" android:text="카카오스토리 포스팅"/>

    <!-- 카카오 SDK 로그아웃 버튼 -->
    <Button android:id="@+id/sf_button_kakao_logout"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"
            android:text="로그아웃"/>

</LinearLayout>
```

`MyActivity`를 열어서 다음과 같이 수정한다. 위의 `main.xml`을 적용하여 레이아웃을 설정하고 각 버튼마다 `onClickListener`를 설정하였다. 주의 깊게 사펴볼 것은 바로 카카오 SDK 로그아웃에 관련된 내용이다. 카카오 SDK 사용자 관리는 `UserManagement` 객체를 사용하는데 로그아웃 메소드를 호출하면서 로그아웃 응답에 대응하는 콜백 구현체를 넘겨주도록 한다.

```java
package net.saltfactory.tutorial.kakaodemo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import com.kakao.*;

public class MyActivity extends Activity {

    private final String TAG = "saltfactory.net";

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final MyActivity self = MyActivity.this;

        setContentView(R.layout.main);

        // 카카오링크 테스트 버튼
        Button buttonLink = (Button) findViewById(R.id.sf_button_kakao_link);
        buttonLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final Intent intent = new Intent(self, SFKakaoLinkActivity.class);
                startActivity(intent);
            }
        });

        // 카카오스토리 프로파일 테스트 버튼
        Button buttonProfile = (Button) findViewById(R.id.sf_button_kakaostory_profile);
        buttonProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final Intent intent = new Intent(self, SFKakaoStoryProfileActivity.class);
                startActivity(intent);
            }
        });

        // 카카오스토리 포스팅 테스트 버튼
        Button buttonPost = (Button) findViewById(R.id.sf_button_kakaostory_post);
        buttonPost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final Intent intent = new Intent(self, SFKakaoStoryPostActivity.class);
                startActivity(intent);
            }
        });

        // 카카오 SDK 로그아웃 버튼
        Button buttonLogout = (Button) findViewById(R.id.sf_button_kakao_logout);
        buttonLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                UserManagement.requestLogout(new LogoutResponseCallback() {
                    @Override
                    protected void onSuccess(long userId) {
                        final Intent intent = new Intent(self, SFKakaoLoginActivity.class);
                        startActivity(intent);
                        finish();
                    }

                    @Override
                    protected void onFailure(APIErrorResult errorResult) {
                        Log.e(TAG, errorResult.toString());
                    }
                });
            }
        });


    }
}

```

이제 `AndroidManifest.xml` 파일을 열어서 위 컴포넌트를 추가한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="net.saltfactory.tutorial.kakaodemo"
          android:versionCode="1"
          android:versionName="1.0">
    <!--<uses-sdk android:minSdkVersion="17"/>-->
    <uses-sdk android:minSdkVersion="11" android:targetSdkVersion="17"/>

    <!-- 카카오 SDK를 사용하기 위해서 필요한 디바이스 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application android:label="@string/sf_app_name" android:icon="@drawable/ic_launcher"
                 android:name="com.kakao.GlobalApplication" android:hardwareAccelerated="true">

        <!-- 카카오 SDK 내부적으로 로그인 처리시 com.kakao.LoginActivity를 열기 때문에 반드시 이 부분을 추가해야한다. -->
        <activity android:name="com.kakao.LoginActivity"/>

        <!-- 카카오 SDK의 로그인 버튼을 이용해서 로그인하는 엑티비티-->
        <activity android:name=".SFKakaoLoginActivity" android:label="@string/sf_app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <data android:host="@string/kakaostory_host" android:scheme="@string/kakao_scheme"/>
            </intent-filter>
        </activity>

        <!-- 테스트 메인 엑티비티 -->
        <activity android:name=".MyActivity"
                  android:label="saltfactory 카카오 SDK 데모"/>


        <!-- 카카오 SDK를 사용하기 위해서 카카오 개발자 사이트에 등록한 앱의 앱키 -->
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
    </application>


</manifest>
```

#### 4) 카카오스토리 프로파일을 가져오는 SFKakaoStoryProfileActivity 추가.

지금부터 눈여겨 봐야할 것이 바로 카카오 SDK 중에서도 카카오스토리의 기능을 사용할 수 있는 카카오스토리 API 사용법이다. 테스트로 만든 `SFKakaoStoryProfileActivity`는 크게 ImageView 2개 (프로파일 이미지, 배경화면 이미지)와 TextView 2개(닉네임, 생일)를 레이아웃으로 구성하고 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/beec9b11-7dd8-46f8-b78b-307d76d99072)

위와 같이 구성하기 위해서 `/res/layout/profile.xml`을 다음과 같이 추가한다.

```xml
<?xml version="1.0" encoding="utf-8"?>

<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
                android:orientation="vertical"
                android:layout_width="match_parent"
                android:layout_height="match_parent">

    <!-- 카카오스토리 대문화면(배경화면) 사진을 보여줄 이미지뷰 -->
    <ImageView android:id="@+id/sf_imageview_background" android:layout_width="fill_parent"
               android:layout_height="fill_parent" android:layout_alignParentTop="true"/>

    <!-- 카카오스토리 프로파일 사진을 보여줄 이미지뷰-->
    <ImageView android:id="@+id/sf_imageview_profile" android:layout_width="120dp"
               android:layout_height="120dp" android:layout_alignParentTop="true" android:layout_margin="20dp"/>

    <!-- 카카오스토리 닉네임을 보여줄 텍스트뷰-->
    <TextView android:id="@+id/sf_textview_nickname" anadroid:layout_width="fill_parent"
              android:layout_height="wrap_content" android:text="닉네임 : "
              android:layout_below="@id/sf_imageview_profile" android:layout_marginLeft="10dp"/>

    <!-- 카카오스토리 생일을 보여줄 텍스트뷰-->
    <TextView android:id="@+id/sf_textview_birthday" android:layout_width="fill_parent"
              android:layout_height="wrap_content" android:text="생일 : "
              android:layout_below="@id/sf_textview_nickname" android:layout_marginLeft="10dp"/>


</RelativeLayout>
```

`SFKakaoStoryProfileActivity`를 다음과 같이 추가한다. `KakaoStoryProfileActivity`는 생성이 될 때 카카오 SDK를 이용해서 카카오스토리 프로파일을 요청해서 그 결과를 레이아웃에 적용하는 내용을 포함하고 있다. 이때 카카오스토리에 프로파일을 요청하기 위해서 `KakaoStoryService.requestProfile()` 메소드를 요청한다. 이 때 요청응답의 결과를 처리하기 위해서 `KakaoStoryResponseHandler `구현체를 함께 넘겨주는데 처리가 완료되면 에러가 없을 경우 `KakaoStoryProfile` 객체로 결과를 받아서 처리할 수 있다.

```java
package net.saltfactory.tutorial.kakaodemo;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import com.android.volley.toolbox.NetworkImageView;
import com.kakao.*;
import org.w3c.dom.Text;

import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by saltfactory on 2/12/14.
 */
public class SFKakaoStoryProfileActivity extends Activity {

    private final String TAG = "saltfactory.net";

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.profile);

        // 카카오스토리 프로파일 사진을 보여줄 이미지뷰
        final ImageView imageViewProfile = (ImageView) findViewById(R.id.sf_imageview_profile);
        // 카카오스토리 배경화면 사진을 보여줄 이미지뷰
        final ImageView imageViewBackground = (ImageView) findViewById(R.id.sf_imageview_background);
        // 카카오스토리 닉네임을 보여줄 텍스트뷰
        final TextView textViewNickName = (TextView) findViewById(R.id.sf_textview_nickname);
        // 카카오스토리 생일을 보여줄 텍스트뷰
        final TextView textViewBirthday = (TextView) findViewById(R.id.sf_textview_birthday);


        // 카카오스토리 API 중에 프로파일 요청을 하기 위해서 KakaoStoryService.requestProfile()을 호출한다.
        // 이 때 결과응답을 처리하 수 있도록 KakaoStoryHttpResponsehandler 구현체를 보내어 요청한다.
        KakaoStoryService.requestProfile(new KakaoStoryHttpResponseHandler<KakaoStoryProfile>() {
            /**
             * 카카오 세션의 유저와 같지 않을 때, 즉 카카오스토리 계정으로 로그인 되지 않은 경우
             */
            @Override
            protected void onNotKakaoStoryUser() {
                final Intent intent = new Intent(SFKakaoStoryProfileActivity.this, SFKakaoStoryLoginActivity.class);
                startActivity(intent);
                finish();
            }

            /**
             * 카카오스토리 requestProfile 요청이 실패하였을 경우
             * @param errorResult 실패한 원인이 담긴 결과
             */
            @Override
            protected void onFailure(APIErrorResult errorResult) {
                Log.e(TAG, errorResult.toString());
            }

            /**
             * 카카오스토리 requestProfile 요청을 성공하였을 경우 KakaoStoryProfile 객체를 받아오게 된다.
             * KakaoStoryProfile 객체 안에 프로파일 이미지, 배경이미지, 닉네임, 생일 정보가 들어 있다.
             * @param kakaoStoryProfile
             */
            @Override
            protected void onHttpSuccess(KakaoStoryProfile kakaoStoryProfile) {
                String nickName = kakaoStoryProfile.getNickName();
                Log.d(TAG, "KakaoStory nickName : " + nickName);
                textViewNickName.setText("이름 : " + nickName);


                String profileImageURL = kakaoStoryProfile.getProfileImageURL();
                Log.d(TAG, "KakaoStory profileImageURL : " + profileImageURL);
                if (profileImageURL != null) {
                    new DownloadImageTask(imageViewProfile).execute(profileImageURL);
                }


                String backgroundURL = kakaoStoryProfile.getBgImageURL();
                Log.d(TAG, "KakaoStory backgroundURL : " + backgroundURL);
                if (backgroundURL != null) {
                    new DownloadImageTask(imageViewBackground).execute(backgroundURL);
                }


                Calendar birthday = kakaoStoryProfile.getBirthdayCalendar();
                if (birthday != null) {
                    StringBuilder displayBirthday = new StringBuilder(8);
                    displayBirthday.append(birthday.getDisplayName(Calendar.MONTH, Calendar.SHORT, Locale.US)).append(" ").append(birthday.get(Calendar.DAY_OF_MONTH));

                    KakaoStoryProfile.BirthdayType birthDayType = kakaoStoryProfile.getBirthdayType();

                    if (birthDayType != null)
                        displayBirthday.append(" (").append(birthDayType.getDisplaySymbol()).append(")");
                    textViewBirthday.setText("생일 : " + displayBirthday);
                    //Log.d(TAG, "KakaoStory birthday : " + displayBirthday);
                }

            }

            @Override
            protected void onHttpSessionClosedFailure(APIErrorResult errorResult) {
                Log.e(TAG, errorResult.toString());
            }
        });

    }


    /**
     * 비동기 방식으로 이미지 URL을 가지고 안드로이드 레이아웃에 등록한 ImageView에 사진을 로드 시키는 구현체
     */
    private class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
        ImageView bmImage;

        public DownloadImageTask(ImageView bmImage) {
            this.bmImage = bmImage;
        }

        protected Bitmap doInBackground(String... urls) {
            String urldisplay = urls[0];
            Bitmap mIcon11 = null;
            try {
                InputStream in = new java.net.URL(urldisplay).openStream();
                mIcon11 = BitmapFactory.decodeStream(in);
            } catch (Exception e) {
                Log.e("Error", e.getMessage());
                e.printStackTrace();
            }
            return mIcon11;
        }

        protected void onPostExecute(Bitmap result) {
            bmImage.setImageBitmap(result);
        }
    }
}
```

이제 `AndroidManifest.xml` 파일을 수정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="net.saltfactory.tutorial.kakaodemo"
          android:versionCode="1"
          android:versionName="1.0">
    <!--<uses-sdk android:minSdkVersion="17"/>-->
    <uses-sdk android:minSdkVersion="11" android:targetSdkVersion="17"/>

    <!-- 카카오 SDK를 사용하기 위해서 필요한 디바이스 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application android:label="@string/sf_app_name" android:icon="@drawable/ic_launcher"
                 android:name="com.kakao.GlobalApplication" android:hardwareAccelerated="true">

        <!-- 카카오 SDK 내부적으로 로그인 처리시 com.kakao.LoginActivity를 열기 때문에 반드시 이 부분을 추가해야한다. -->
        <activity android:name="com.kakao.LoginActivity"/>

        <!-- 카카오 SDK의 로그인 버튼을 이용해서 로그인하는 엑티비티-->
        <activity android:name=".SFKakaoLoginActivity" android:label="@string/sf_app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <data android:host="@string/kakaostory_host" android:scheme="@string/kakao_scheme"/>
            </intent-filter>
        </activity>

        <!-- 테스트 메인 엑티비티 -->
        <activity android:name=".MyActivity"
                  android:label="saltfactory 카카오 SDK 데모"/>

        <!-- 카카오스토리 프로파일 테스트 엑티비티 -->
        <activity android:name=".SFKakaoStoryProfileActivity" android:label="카카오스토리 프로파일 "/>

        <!-- 카카오 SDK를 사용하기 위해서 카카오 개발자 사이트에 등록한 앱의 앱키 -->
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
    </application>


</manifest>
```

#### 5) 카카오스토리로 사진과 글을 포스팅하는 SFKakaoStoryPostActivity 추가

카카오 SDK의 카카오스토리 API 테스트의 마지막 엑티비티인 이 객체는 사진첩에서 사진을 선택해서 글을 입력 받아 그 글을 카카오스토리에 올리는 엑티비티이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/3e816b0e-43a8-4f3c-b81e-b63a5117bd40)

`res/layout/post.xml` 파일을 다음 내용으로 추가한다.

```xml
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="match_parent"
              android:layout_height="match_parent" android:weightSum="1">


    <RelativeLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent">

        <!-- 카카오스토리에 포스팅할 내용을 적는 글상자 -->
        <EditText
                android:layout_width="fill_parent"
                android:layout_height="200dp"
                android:inputType="textMultiLine|textNoSuggestions"
                android:id="@+id/sf_edittext_content" android:layout_alignParentRight="true"
                android:layout_alignParentEnd="true"
                android:layout_alignParentLeft="true" android:layout_alignParentStart="true"
                android:layout_alignParentTop="true" android:gravity="top" android:autoText="false"
                android:autoLink="none" android:scrollHorizontally="false"/>

        <!-- 내 앨범에서 선택한 사진을 미리보는 이미지뷰 -->
        <ImageView
                android:layout_width="40dp"
                android:layout_height="40dp"
                android:id="@+id/sf_imageview_thumb"
                android:layout_alignBottom="@+id/sf_button_post" android:layout_alignParentLeft="true"
                android:layout_alignParentStart="true"/>

        <!-- 카카오스토리에 포스팅하는 버튼 -->
        <Button
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="포스팅"
                android:id="@+id/sf_button_post"
                android:layout_below="@+id/sf_edittext_content" android:layout_alignParentRight="true"
                android:layout_alignParentEnd="true"/>

    </RelativeLayout>
</LinearLayout>
```

다음은 `SFKakaoStoryPostActivity` 파일을 구현하여 추가한다. 카카오스토리 포스팅 과정은 다음과 같다. 카카오스토리에 사진을 전송하기 위해서 사진의 사이즈를 조절해서 카카오스토리에 업로드하면 정상적으로 업로드가 완료된 이후 업로드한 이미지 경로를 가지는 객체를 반환해준다. 그러면 카카오스토리에 포스팅하는 메소드를 가지고 앞에서 업로드에 성공해서 받은 이미지 경로와 글 내용을 카카오스토리 파라미터 빌드를 사용해서 파라미터를 만들어서 카카오스토리에 포스팅하게 되는 과정으로 처리된다.

```java
package net.saltfactory.tutorial.kakaodemo;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.*;
import com.kakao.*;
import com.kakao.helper.Logger;

import java.io.*;

/**
 * Created by saltfactory@gmail.com
 * on 2/12/14.
 */
public class SFKakaoStoryPostActivity extends Activity {
    private final String TAG = "saltfactory.net";

    private static int RESULT_LOAD_IMAGE = 1;

    // 사진 앨범에서 선택한 사진을 미리 보여주는 이미지뷰
    private ImageView imageView;
    // 사진 앨범에서 선택한 사진을 저장할 비트맵
    private Bitmap bitmapSelectedPhoto;
    // 카카오스토리에 글을 포스팅하기 위한 글상자
    private EditText editText;
    // 카카오스토리로 포스팅하기 위한 버튼
    private Button button;


    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.post);

        imageView = (ImageView) findViewById(R.id.sf_imageview_thumb);
        button = (Button) findViewById(R.id.sf_button_post);
        editText = (EditText) findViewById(R.id.sf_edittext_content);

        // 엑티비티가 실행하면 사진을 선택할 수 있도록 사집첩 앨범을 열도록 한다.
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, RESULT_LOAD_IMAGE);

        // 카카오스토리로 포스팅하는 버튼의 클릭리스너 등록
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    // 사진첩 앨범에서 선택한 사진을 카카오스토리에 올리기 위한 사이즈를 조절하고 그 파일을 업로드에 사용한다.
                    File file = new File(writeStoryImage(getApplicationContext(), bitmapSelectedPhoto));
                    KakaoStoryService.requestUpload(new MyKakaoStoryHttpResponseHandler<KakaoStoryUpload>() {
                        /**
                         * 카카오스토리에 사진 파일 업로드가 완료하면 이 메소드가 자동적으로 호출되어지는데
                         * 이때 사진 파일 업로드한 이미지 경로를 가지고 KakaoStoryPostParamBuilder로 파라미터를 설정해서 글 내용과 함께 포스팅을 요청한다.
                         * @param resultObj 성공한 결과
                         */
                        @Override
                        protected void onHttpSuccess(KakaoStoryUpload resultObj) {
                            String imageURL = resultObj.getUrl();
                            String storyPostText = editText.getText().toString();

                            final KakaoStoryPostParamBuilder postParamBuilder = new KakaoStoryPostParamBuilder(storyPostText, KakaoStoryPostParamBuilder.PERMISSION.PUBLIC);
                            if (imageURL != null)
                                postParamBuilder.setImageURL(imageURL);
                            Bundle parameters = postParamBuilder.build();

                            KakaoStoryService.requestPost(new MyKakaoStoryHttpResponseHandler<Void>() {
                                @Override
                                protected void onHttpSuccess(Void resultObj) {
                                 //   Toast.makeText(getApplicationContext(), "success to post on KakaoStory", Toast.LENGTH_SHORT).show();
                                    SFKakaoStoryPostActivity.super.onBackPressed();
                                }
                            }, parameters);
                        }
                    }, file);
                } catch (IOException e) {
                    e.printStackTrace();
                    Log.e(TAG, e.getLocalizedMessage());
                }


            }
        });
    }


    /**
     * 사진 앱범을 열어서 사진을 선택하고 닫으면 이 메소드가 호출 된다.
     * 파일을 카카오스토리에 올리기 전에 썸네일 이미지로 imageView에 보여주게 한다.
     * @param requestCode
     * @param resultCode
     * @param data
     */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == RESULT_LOAD_IMAGE && resultCode == RESULT_OK && null != data) {
            Uri selectedImage = data.getData();
            String[] filePathColumn = {MediaStore.Images.Media.DATA};

            Cursor cursor = getContentResolver().query(selectedImage,
                    filePathColumn, null, null, null);
            cursor.moveToFirst();

            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
            String picturePath = cursor.getString(columnIndex);
            cursor.close();

            bitmapSelectedPhoto = BitmapFactory.decodeFile(picturePath);
            imageView.setImageBitmap(bitmapSelectedPhoto);

        } else {
            super.onBackPressed();
        }
    }


    /**
     * 카카오스토리에 사진파일을 전송하기 위해서 사이즈를 변경하는 메소드
     * @param context
     * @param bitmap
     * @return
     * @throws IOException
     */
    private static String writeStoryImage(final Context context, final Bitmap bitmap) throws IOException {
        final File diskCacheDir = new File(context.getCacheDir(), "story");

        if (!diskCacheDir.exists())
            diskCacheDir.mkdirs();

        final String file = diskCacheDir.getAbsolutePath() + File.separator + "temp_" + System.currentTimeMillis() + ".jpg";

        OutputStream out = null;
        try {
            out = new BufferedOutputStream(new FileOutputStream(file), 8 * 1024);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
        } finally {
            if (out != null) {
                out.close();
            }
        }

        return file;
    }


    /**
     * 카카오스토리에 Http 요청을한 이후 응답받는 결과에 따라 동작하게 하는 구현체
     * @param <T>
     */
    private abstract class MyKakaoStoryHttpResponseHandler<T> extends KakaoStoryHttpResponseHandler<T> {

        @Override
        protected void onHttpSessionClosedFailure(final APIErrorResult errorResult) {
            Log.e(TAG, errorResult.toString());
        }

        @Override
        protected void onNotKakaoStoryUser() {
            Toast.makeText(getApplicationContext(), "not KakaoStory user", Toast.LENGTH_SHORT).show();
        }

        @Override
        protected void onFailure(final APIErrorResult errorResult) {
            final String message = "MyKakaoStoryHttpResponseHandler : failure : " + errorResult;
            Logger.getInstance().d(message);
            Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
        }
    }
}
```

마지막으로 `AndroidManifest.xml` 파일에 위 엑티비티를 등록한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="net.saltfactory.tutorial.kakaodemo"
          android:versionCode="1"
          android:versionName="1.0">
    <!--<uses-sdk android:minSdkVersion="17"/>-->
    <uses-sdk android:minSdkVersion="11" android:targetSdkVersion="17"/>

    <!-- 카카오 SDK를 사용하기 위해서 필요한 디바이스 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application android:label="@string/sf_app_name" android:icon="@drawable/ic_launcher"
                 android:name="com.kakao.GlobalApplication" android:hardwareAccelerated="true">

        <!-- 카카오 SDK 내부적으로 로그인 처리시 com.kakao.LoginActivity를 열기 때문에 반드시 이 부분을 추가해야한다. -->
        <activity android:name="com.kakao.LoginActivity"/>

        <!-- 카카오 SDK의 로그인 버튼을 이용해서 로그인하는 엑티비티-->
        <activity android:name=".SFKakaoLoginActivity" android:label="@string/sf_app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <data android:host="@string/kakaostory_host" android:scheme="@string/kakao_scheme"/>
            </intent-filter>
        </activity>

        <!-- 테스트 메인 엑티비티 -->
        <activity android:name=".MyActivity"
                  android:label="saltfactory 카카오 SDK 데모"/>

        <!-- 카카오스토리 프로파일 테스트 엑티비티 -->
        <activity android:name=".SFKakaoStoryProfileActivity" android:label="카카오스토리 프로파일 "/>

        <!-- 카카오스토리 포스팅 테스트 엑티비티 -->
        <activity android:name=".SFKakaoStoryPostActivity" android:label="카카오스토리 포스팅"/>

        <!-- 카카오 SDK를 사용하기 위해서 카카오 개발자 사이트에 등록한 앱의 앱키 -->
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
    </application>


</manifest>
```

이제 카카오스토리 테스트에 관한 모든 설정이 완료되었다. 카카오스토리 포스팅을 테스트해보자. 앱을 디바이스에 빌드하고 난 이후 로그인 버튼을 클릭한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/391849b5-50ea-4b6b-8596-874a5916f965)

그러면 카카오계정으로 로그인하려는 앱에서 접근 권한을 허용하는 문구가 나온다. 허용을 선택한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/eb5f3e9d-f312-4db4-97d4-6251bc746248)

그러면 테스트를 위해 추가한 MyActivity가 실행된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e79a5f21-897f-4be9-b2d6-19ad039bb844)

카카오스토리 포스팅 버튼을 눌러보자. 그러면 카카오에 글을 등록하기 이전에 먼저 앨번에서 사진을 선택할 수 있게 사진첩 앨범이 열리는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/afa1f527-a08c-4263-861d-80676f99d14b)

사진을 선택하고 글상자에 글을 입력한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/607a3ab8-b14f-4688-9161-9609de6e54af)

포스팅 버튼을 클릭해서 실제 포스팅이 완료 되었는지 확인한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4135b596-ca43-4b4c-a1f9-e2d27ab31a82)

## 결론

이번 카카오 SDK의 가장 핵심 기능은 카카오스토리에 사진과 글을 포스팅할 수 있는 기능이 아닌가 생각된다. 페이스북은 오래전에 페이스북 SDK로 다른 앱에서 컨텐츠를 포스팅할 수 있는 기능을 지원했기 때문에 여러가지 페이스북과 연동되는 앱이 많이 개발되었다. 이번 카카오 SDK에서 카카오스토리로 컨텐츠를 포스팅할 수 있는 기능을 제공하기 때문에 카카오 서비스와 연동되는 앱이 더욱 많아 질 것으로 예상된다.

## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial/releases/tag/kakaostory-demo

## 참고

1. https://developers.kakao.com/docs

