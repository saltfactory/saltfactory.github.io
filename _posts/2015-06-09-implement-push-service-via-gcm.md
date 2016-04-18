---
layout: post
title: '최신 Android Studio, Google Cloud Messaging 3.0(GCM)을 이용하여 Android 푸시 서비스 구현하기'
category: android
tags:
  - android
  - gcm
  - java
  - push
  - notification
comments: true
images:
  title: 'https://hbn-blog-assets.s3.amazonaws.com/Screen%20Shot%202016-03-23%20at%2012.04.01%20AM.png'
---

## 서론

블로그에서 가장 많이 검색되는 글이 [Node.js와 Google Play Service를 이용하여 안드로이드 푸시서비스 구현하기(GCM)](http://blog.saltfactory.net/node/implementing-push-notification-service-for-android-using-google-play-service.html) 이다. 이 글은 2014년 1월에 작성한 글로 그동안 [Google Cloud Messaging](https://developers.google.com/cloud-messaging/) 서비스는 진화를 하여 더욱 편리하고 다르게 개발이 되고 있다. 오늘은 새롭게 바뀐 GCM 서비스를 개발하는 방법을 소개한다.

Android는 [eclipse](https://eclipse.org/)에서 [Android Studio](http://developer.android.com/tools/studio/index.html)로 IDE를 바꾸었고, [Ant](http://ant.apache.org/) 기반 빌드 방식을 [Gradle](https://gradle.org/)로 변경하였다. 이에 따라 기존의 문서들을 참조해서 개발할때 혼란스러운 부분들이 있고 아직 이것을 반영한 자료들이 그렇게 많지 않기 때문에 이 글을 통해서 안드로이드 GCM 서비스를 개발하는데 도움이 되길 바란다.

<!--more-->

## 앱 만들기

GCM을 테스트하기 위한 Android 프로젝트를 하나 만들도록 한다. 완성된 예제는 [saltfactory-android-tutorial의 gcm-demo 브랜치](https://github.com/saltfactory/saltfactory-android-tutorial/tree/gcm-demo)에서 받을 수 있다.

**Android Studio**를 열어서 기본 프로젝트를 만든다.

### Start New Android Studio project

![Start New Android Studio](http://asset.hibrainapps.net/saltfactory/images/9ceb0e11-523f-44cc-b5df-a34b4d7118e4)

### New Project

* **Application name** : SF-GCM-DEMO
* **Company Domain** : saltfactory.net
* **Package name** : **net.saltfactory.demo.gcm**
* **Project location** : /Projects/Repository/Saltfactory/saltfactory-android-tutorial/sf-gcm-demo

으로 프로젝트를 만든다. 위 입력은 자신에 맞게 수정하여 입력한다. 주의할 점은 **Pacakge name**이다. Android의 어플리케이션의 유일한 identifier는 package name으로 인식하기 때문에 자신의 앱과 중복되지 않은 이름을 입력한다.

![New Project](http://asset.hibrainapps.net/saltfactory/images/07381211-7b35-48c2-8ca1-c6f9396af0a7)

### Target Android Device

다음은 개발하고 싶은 **SDK**를 선택한다. 우리는 Android 스마트폰 GCM을 테스트할 예정이기 때문에 **Phone and Tablet Minimum SDK**를 선택한다. 현재 연구에 사용하고 있는 Android 디바이스가 최신형이 아니기 때문에 **API 14(Android 4.0)**을 선택했다. 자신에 맞는 SDK를 선택하면 된다.

![Phone and Table Minimum SDK](http://asset.hibrainapps.net/saltfactory/images/70dd0a1f-a710-414f-b1cb-bf9948c45196)

### Add an activity to Mobile

단순히 GCM을 테스트하기 위해서 우리는 **Blank Activity**를 선택한다. 실제 프로젝트를 새롭게 진행한다면 자신에게 필요한 Activity를 선택하면 된다.

![Add an activity to Mobile](http://asset.hibrainapps.net/saltfactory/images/0375db27-256c-45e9-af2b-c7180c24ce6d)

### Customize the Activity

특별히 다른 작업을 하지 않기 때문에 기본 Activity 이름을 그대로 사용하기로 한다. Title만 **GCM demo**로 입력한다.

* **Activity Name** : MainActivity
* **Layout Name** : activity_name
* **Title** : **GCM demo**
* **Menu Resource Name** : menu_main

![Customize the Activity](http://asset.hibrainapps.net/saltfactory/images/8300184b-bb71-4b5c-b997-9fabdedf6309)

간단하게 **Gradle** 기반의 Anroid 프로젝트가 만들어졌다.

![created android project](http://asset.hibrainapps.net/saltfactory/images/b45c7903-31b6-481a-8647-9693f55e3f07)

## 앱 등록하기

Android GCM 서비스를 개발하기 전에 GCM을 사용하기 위해 앱을 등록해야한다. Android GCM 사이트에 접속해보자. https://developers.google.com/cloud-messaging/

![](http://asset.hibrainapps.net/saltfactory/images/c5c19610-b2fc-43f1-8168-d73ff8e34d57)

Google Cloud Messasing은 이제 **Android** 디바이스 뿐만 아니라 **iOS** 디바이스에도 동일한 로직으로 GCM 서비스를 이용하여 메세지를 보낼 수 있다. **iOS**를 위한 GCM의 소개는 다음 포스트에서 소개하도록 하고 우선 **Android GCM**을 소개한다. Google의 서비스는 점차적으로 [Material Design](http://www.google.com/design/spec/material-design/introduction.html)으로 디자인을 변경하고 있다. GCM 사이트 역시 **Material Design**이 적용되어 있다. [TRY IT ON ANDROID](https://developers.google.com/cloud-messaging/android/start) 버튼을 클릭한다.

우리는 **SF-GCM-demo**라는 프로젝트를 이미 만들었고 GCM을 추가할 것이기 때문에 [add Cloud Messaging to your existing app](https://developers.google.com/cloud-messaging/android/client)를 클릭한다.

![add Cloud Messasing to your exsiting app](http://asset.hibrainapps.net/saltfactory/images/9ab6adf4-f822-4ab0-b7fe-928b17d12706)

### Get a configuration file

앞에 설명은 각자 읽어보도록 하고 가운데 정도가면 [Get a configuration file](https://developers.google.com/cloud-messaging/android/client#get-config)이 보일 것이다. [GET A CONFIGURATION FILE](https://developers.google.com/mobile/add?platform=android&cntapi=gcm&cnturl=https:%2F%2Fdevelopers.google.com%2Fcloud-messaging%2Fandroid%2Fclient&cntlbl=Continue%20Adding%20GCM%20Support&%3Fconfigured%3Dtrue) 버튼을 클릭하자.

### Enable Google services for your app

페이지가 전환되면서 Android 앱을 등록하는 화면이 나온다. **GCM**을 사용하기 위해서 앱을 등록하는 화면이다.

* **App name** : 앱 이름을 입력한다. 영문으로만 등록이 가능하다.
* **Android package name** : **net.saltfactory.demo.gcm**

![Create or Choose an app](http://asset.hibrainapps.net/saltfactory/images/a01fdb5e-1eb5-481b-82c0-0f46898f3a93)

**Continue Choose an configure services** 버튼을 클릭한다. 등록하는 시간을 기다리면 다음과 같이 **SF-GCM-DEMO** 앱이 **net.saltfactory.demo.gcm** 패키지명으로 등록된 것을 확인할 수 있다. 앱을 등록하면 Google Sigin-in, Cloud Messaging, Analytics 서비스를 사용할 수 있다. 우리는  **Cloud Messaging**를 상용할 것이기 때문에 다른 설명은 생략한다.

![Registration Android App](http://asset.hibrainapps.net/saltfactory/images/a1583124-beeb-4f3a-acfc-093779911535)

**Google Cloud Messaging** 탭을 보면 **ENABLE GOOGLE CLOUD MESSAGING** 버튼이 보인다. 이 버튼을 눌러줘야 GCM 서비스가 활성화 된다. 버튼을 클릭하자. 그러면 아래와 같이 GCM 서비스가 활성화 된 것을 확인할 수 있다. 이제 Google 서비스에 GCM에 관한 설정은 모두 마친 것이다.

![Enable google cloud messaging](http://asset.hibrainapps.net/saltfactory/images/67833730-0f41-4f95-bece-0ec13fcc2dd1)

아래에 보면 **Generate configuration files** 라는 버튼이 보인다. 이전 GCM에서의 복잡한 설정을 간단하게 configuration file로 처리를 할 수 있게 GCM 서비스가 업그레이드 되었다. 설정 파일을 만들어보자.

### Generate Configuration files

GCM 서비스가 업그레이드 되면서 설정하는 프로세스가 매우 직관적으로 변경되었다. 앞에서 설명하듯 차례차례 문서대로 진행하면 다음과 같이 **Server API key**와 **Sender ID**를 만들 수 있다. 이전에 블로그에 포스팅한 글의 가장 많은 질문이 **Project ID**를 어떻게 생성하는지에 대한 질문이였는데 GCM 업그레이드 이후 간단하게 생성할 수 있게 되었다.

![](http://asset.hibrainapps.net/saltfactory/images/cde4e93e-795b-48e5-990f-0963cb0f751f)

설정 파일 또한 쉽게 생성이 되었다. 상단에 **Download google-services.json** 버튼을 클릭해서 설정파일을 다운로드한다. 다운로드 받은 `google-services.json` 파일은 앞에서 만든 Android 프로젝트 디렉토리 안에 `app/` 디렉토리 안으로 복사한다. 이 파일이 `/app` 디렉토리안에 들어있지 않으면 GCM 프로젝트를 빌드할 때 `R.string.gcm_defaultSenderId` 리소스를 찾을 수 없다는 에러가 발생하면서 빌드가 되지 않는다.

![copy google-services.json](http://asset.hibrainapps.net/saltfactory/images/224e057c-8880-4b53-8aa4-8702c6a36c4d)

### google-services.json

설정 파일을 열어보자. 이전에 질문이 가장 많았던 **Project ID**와 **Project Number**가 자동으로 만들어진 것을 확인할 수 있다.

```javascript
{
  "project_info": {
    "project_id": "sf-gcm-demo-ae3be",
    "project_number": "636926190444",
    "name": "SF-GCM-DEMO"
  },
  "client": [
    {
      "client_info": {
        "client_id": "android:net.saltfactory.demo.gcm",
        "client_type": 1,
        "android_client_info": {
          "package_name": "net.saltfactory.demo.gcm"
        }
      },
      "oauth_client": [],
      "services": {
        "analytics_service": {
          "status": 1
        },
        "cloud_messaging_service": {
          "status": 2,
          "apns_config": []
        },
        "appinvite_service": {
          "status": 1,
          "other_platform_oauth_client": []
        },
        "google_signin_service": {
          "status": 1
        },
        "ads_service": {
          "status": 1
        }
      }
    }
  ]
}
```

## build.gradle 설정

다음은 **Build**를 설정해야한다. Android Studio로 Android 프로젝트를 개발하게 되면 이전과 다리 **Gradle**을 사용하게 되는데, 처음에는 복잡해 보일지 모르지만 기존의 **Ant** 방식과 달리 다양한 설정을 할 수 있고, 프로젝트에 필요한 **dependencies** 라이브러리를 자동으로 다운받기 때문에 **classpath**를 설정해주는 복잡한 과정을 생략할 수 있는 장점이 있다.

Google Cloud Messaging 문서에서는 [Add the configuration file to your project](https://developers.google.com/cloud-messaging/android/client#add-config)를 참고한다.

Android Studio에서 `build.gradle` 파일을 열어서 아래와 같이 `classpath`를 추가한다. Android Studio에서 gradle 파일을 수정하면 자동으로 변경된 내용을 반영한다. 만약 자동으로 반영이 되지 않을 경우 Android Studio 오른쪽 Gradle Projects 패널을 열어서 **새로 고침** 버튼을 클릭하면 Gradle이 자동으로 갱신되어 필요한 라이브러리들을 다운받고 빌드를 진행할 준비를 하게 된다.

```
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
//        classpath 'com.android.tools.build:gradle:1.2.3'
        classpath 'com.android.tools.build:gradle:1.3.0-beta1'
        classpath 'com.google.gms:google-services:1.3.0-beta1'
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}


allprojects {
    repositories {
        jcenter()
    }
}
```

![Android Studio gradle fresh button](http://asset.hibrainapps.net/saltfactory/images/2e35a3a3-cb7d-4233-aae0-c1530b7df258)

## Set Up Google Play Services

GCM은 **Google Play Services**로 통합이 되었다. 이전 글에서도 Google Play Services 라이브러리를 사용하여 GCM 서비스를 만드는 방법을 소개했는데 Gradle을 사용하면 아주 쉽게 설정할 수 있다.

**app**을 설정하는 `build.gradle`을 열어서 필요할 라이브러리 `play-services`를 다운 받기 위해서 다음과 같이 `dependencies`에  `compile "com.google.android.gms:play-services:7.5.+”`을 추가한다. 이것은 컴파일할 때 `play-services` 라이브러리가 필요하니 없으면 다운 받아서 컴파일할 때 사용하라는 의미이다.

```
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 22
    buildToolsVersion "22.0.1"

    defaultConfig {
        applicationId "net.saltfactory.demo.gcm"
        minSdkVersion 14
        targetSdkVersion 22
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile 'com.google.android.gms:play-services-gcm:7.5.+'
    compile 'com.android.support:appcompat-v7:22.1.1'

}

```

이제 필요한 **라이브러리 설치**와 **클래스패스 설정**을 모두 완료하였다. Gradle을 사용하여 아주 쉽게 설정을 하였다.


## AndroidManifest.xml 설정

이젠 Android 앱의 메타정보를 설정하는 `AndroidManifest.xml` 파일을 열어서 GCM 서비스를 만들기 위한 메타정보를 정의해야한다.

`AndroidManifest.xml`에 추가해야할 핵심 내용은 다음과 같다.

* **GCM Permission** : 디바이스에 GCM 서비스를 사용하기 위한 권한 설정
* **GCM Receiver** : GCM을 받았을 때 동작하기 위한 리시버
* **GCM Listener Service** : GCM을 요청을 대기하고 있는 리스너 서비스
* **InstanceID Listener Service** : InstanceID 요청을 대기하고 있는 리스너 서비스
* **GCM Registration Service** : GCM을 등록하기 위한 서비스

위 내용을 입력하기 전에 우선 `<!-- comment -->`로 `AndroidManifest.xml`에 추가해보자.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="net.saltfactory.demo.gcm">

    <!-- [START gcm_permission] -->
    <!-- [END gcm_permission] -->

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- [START gcm_receiver] -->
        <!-- [END gcm_receiver] -->

        <!-- [START gcm_listener_service] -->
        <!-- [END gcm_listener_service] -->

        <!-- [START instanceId_listener_service] -->
        <!-- [END instanceId_listener_service] -->

        <!-- [START gcm_registration_service] -->
        <!-- [END gcm_registration_service] -->
</manifest>
```
### uses-permission

먼저 **GCM Permission**을 설정하자. 디바이스에서 GCM을 사용하기 위해서는 `com.google.android.c2dm.permission.RECEIVE`와 `android.permission.WAKE_LOCK` 권한이 필요하다.

* **com.google.android.c2dm.permission.RECEIVE** : GCM은 원래 [c2dm](https://developers.google.com/android/c2dm/) 이름으로 베타 운영되다가 정식으로 GCM 이름으로 변경이된다. 그래서 패키지 이름이 c2dm 그대로 유지하게 된듯핟.
* **android.permission.WAKE_LOCK** : 디바이스가 잠금이되어 화면이 꺼져있을 경우에도 GCM을 받을 수 있기 위해서 디바이스를 깨우는 권한이 필요하다.

```xml
    <!-- [START gcm_permission] -->
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <!-- [END gcm_permission] -->
```

### GCM Reciever

GCM을 받기 위한 리시버를 만들어야하는데 GCM 리시버는 특별히 구현할 필요가 없다. GCM 라이브러리 안에 이미 구현체가 있기 때문에 정의만하면 된다.

```xml
        <!-- [START gcm_receiver] -->
        <receiver
            android:name="com.google.android.gms.gcm.GcmReceiver"
            android:exported="true"
            android:permission="com.google.android.c2dm.permission.SEND">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                <category android:name="net.saltfactory.demo.gcm" />
            </intent-filter>
        </receiver>
        <!-- [END gcm_receiver] -->
```

### GCM Listener Service

GCM 리스너 서비스는 GCM 메세지가 디바이스로 전송이되면 메세지를 받아서 처리하는 프로그램을 서비스로 정의한다. GCM 받아서 실제 Notification Center에 어떻게 나타내는지를 정의한다. 이후에 살펴볼 `MyGcmListenerService.java`에 내용을 구현할 것이다.

```xml
        <!-- [START gcm_listener_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.MyGcmListenerService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
            </intent-filter>
        </service>
        <!-- [END gcm_listener_service] -->
```

### InstanceID Listener Service

최근 GCM 서비스에서는 [Instance ID](https://developers.google.com/instance-id/)를 사용한다. 이것은 Android, iOS의 고유한 ID로 GCM에서 디바이스를 구분하기 위한 것이다. Instance ID를 위한 리서너를 `MyInstanceIDListener.java`에서 구현할 것이다.

```xml
        <!-- [START instanceId_listener_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.MyInstanceIDListenerService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.android.gms.iid.InstanceID" />
            </intent-filter>
        </service>
        <!-- [END instanceId_listener_service] -->
```

### GCM Registration Service

실제 디바이스에서 **Instance ID**를 사용하여 디바이스를 GCM에 등록하고 **디바이스 고유 토큰**을 생성하기 위한 서비스를 `RegistrationIntentService.java`에서 구현할 것이다.

```xml
        <!-- [START gcm_registration_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.RegistrationIntentService"
            android:exported="false"></service>
        <!-- [END gcm_registration_service] -->
```

### AndroidManifest.xml

GCM을 사용하기 위한 메니페스트 파일 전체 내용은 다음과 같다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="net.saltfactory.demo.gcm">

    <!-- [START gcm_permission] -->
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <!-- [END gcm_permission] -->

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- [START gcm_receiver] -->
        <receiver
            android:name="com.google.android.gms.gcm.GcmReceiver"
            android:exported="true"
            android:permission="com.google.android.c2dm.permission.SEND">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                <category android:name="net.saltfactory.demo.gcm" />
            </intent-filter>
        </receiver>
        <!-- [END gcm_receiver] -->

        <!-- [START gcm_listener_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.MyGcmListenerService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
            </intent-filter>
        </service>
        <!-- [END gcm_listener_service] -->

        <!-- [START instanceId_listener_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.MyInstanceIDListenerService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.android.gms.iid.InstanceID" />
            </intent-filter>
        </service>
        <!-- [END instanceId_listener_service] -->

        <!-- [START gcm_registration_service] -->
        <service
            android:name="net.saltfactory.demo.gcm.RegistrationIntentService"
            android:exported="false"></service>
        <!-- [END gcm_registration_service] -->
    </application>

</manifest>
```

## GCM Demo

**GCM Demo**를 좀더 사용할만한 데모 앱을 만들기 위해서 [Button](http://developer.android.com/reference/android/widget/Button.html), [TextView](http://developer.android.com/reference/android/widget/TextView.html) 그리고 [ProgressBar](https://developer.android.com/reference/android/widget/ProgressBar.html)를 사용하여 UI를 구성하였다.

![GCM Demo start](http://asset.hibrainapps.net/saltfactory/images/5f8c146a-9cb4-4750-9112-21e2dcc03db1)

![GCM Demo finish](http://asset.hibrainapps.net/saltfactory/images/1fd7d2d1-8bab-4258-90d4-87d73e834e70)

### string.xml

데모에 사용하기 위한 스트링을 정의한 `app/src/main/res/values/string.xml`을 다음 내용으로 저장한다.

```xml
<resources>
    <string name="app_name">GCM Demo</string>
    <string name="registering_message_ready">InstanceID 토큰 가져오기</string>
    <string name="registering_message_generating">InstanceID 토큰 생성중...</string>
    <string name="registering_message_complete">완료!</string>
</resources>
```

### style.xml

데모에 사용하기 위한 스타일을 정의한 `app/src/main/res/values/style.xml`을 다음 내용으로 저장한다.

```xml
<resources>

    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <!-- Customize your theme here. -->
        <item name="android:textColor">@android:color/white</item>
        <item name="android:textSize">16sp</item>
    </style>

</resources>
```

### demens.xml

데모에 사용하기 위한 크기를 정의한 `app/src/main/res/values/dimens.xml`을 다음 내용으로 저장한다.

```xml
<resources>
    <!-- Default screen margins, per the Android Design guidelines. -->
    <dimen name="activity_horizontal_margin">16dp</dimen>
    <dimen name="activity_vertical_margin">16dp</dimen>
</resources>
```

### layout.xml

`app/src/main/res/layout/activity_main.xml` 레이아웃 파일을 열어서 다음 내용을 입력하고 저장한다.

```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:paddingBottom="@dimen/activity_vertical_margin"
    android:background="@color/blue_grey_700"
    android:orientation="vertical" tools:context=".MainActivity">

    <Button android:id="@+id/registrationButton"
        android:layout_width="fill_parent"
        android:layout_height="wrap_content" android:text="@string/registering_message_ready" />

    <TextView android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/informationTextView"
        android:textAppearance="?android:attr/textAppearanceMedium"/>

    <ProgressBar
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/registrationProgressBar" />

</LinearLayout>
```

### QuickstartPreferences.java

이 파일은 **GCM Demo**에서 사용하는 LocalBoardcast의 액션을 정의한 파일이다. `app/src/main/java/net/saltfactory/demo/gcm/QuickstartPreferences.java`에 아래내용을 저장한다.

```java
package net.saltfactory.demo.gcm;

/**
 * Created by saltfactory on 6/8/15.
 */
public class QuickstartPreferences {

    public static final String REGISTRATION_READY = "registrationReady";
    public static final String REGISTRATION_GENERATING = "registrationGenerating";
    public static final String REGISTRATION_COMPLETE = "registrationComplete";

}

```

### MainActivity.java

**GCM Demo**의 메인 엑티비티 클래스를 정의하자. `app/src/main/java/net/saltfactory/demo/gcm/MainActivity.java` 파일을 열어서 다음 내용을 추가한다. 핵심 메소드는 다음과 같다.

* **onCreate()** : UI를 정의하고 이벤트와 핸들러를 정의한다.
* **onResume()** : 화면이 보여질때 LocalBroadcastManager를 정의한다.
* **onPause()** : 화면이 사라질때 LocalBoradcastManager에 등록된 것을 제거한다.
* **checkPlayService()** : Google Play Service를 사용할 수 있는 환경인지 체크한다.
* **registBroadcastReciever()** : LocalBroadcast 액션에 해당하는 작업을 정의한다.
* **getInstanceIdToken()** : GCM을 등록하고 Instance ID에 해당하는 token을 가져온다.

자세한 내용은 코드의 주석으로 대신하고 다음 내용을 저장한다.

```java
package net.saltfactory.demo.gcm;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;

public class MainActivity extends AppCompatActivity {

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "MainActivity";

    private Button mRegistrationButton;
    private ProgressBar mRegistrationProgressBar;
    private BroadcastReceiver mRegistrationBroadcastReceiver;
    private TextView mInformationTextView;

    /**
     * Instance ID를 이용하여 디바이스 토큰을 가져오는 RegistrationIntentService를 실행한다.
     */
    public void getInstanceIdToken() {
        if (checkPlayServices()) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        }
    }

    /**
     * LocalBroadcast 리시버를 정의한다. 토큰을 획득하기 위한 READY, GENERATING, COMPLETE 액션에 따라 UI에 변화를 준다.
     */
    public void registBroadcastReceiver(){
        mRegistrationBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();


                if(action.equals(QuickstartPreferences.REGISTRATION_READY)){
                    // 액션이 READY일 경우
                    mRegistrationProgressBar.setVisibility(ProgressBar.GONE);
                    mInformationTextView.setVisibility(View.GONE);
                } else if(action.equals(QuickstartPreferences.REGISTRATION_GENERATING)){
                    // 액션이 GENERATING일 경우
                    mRegistrationProgressBar.setVisibility(ProgressBar.VISIBLE);
                    mInformationTextView.setVisibility(View.VISIBLE);
                    mInformationTextView.setText(getString(R.string.registering_message_generating));
                } else if(action.equals(QuickstartPreferences.REGISTRATION_COMPLETE)){
                    // 액션이 COMPLETE일 경우
                    mRegistrationProgressBar.setVisibility(ProgressBar.GONE);
                    mRegistrationButton.setText(getString(R.string.registering_message_complete));
                    mRegistrationButton.setEnabled(false);
                    String token = intent.getStringExtra("token");
                    mInformationTextView.setText(token);
                }

            }
        };
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        registBroadcastReceiver();

        // 토큰을 보여줄 TextView를 정의
        mInformationTextView = (TextView) findViewById(R.id.informationTextView);
        mInformationTextView.setVisibility(View.GONE);
        // 토큰을 가져오는 동안 인디케이터를 보여줄 ProgressBar를 정의
        mRegistrationProgressBar = (ProgressBar) findViewById(R.id.registrationProgressBar);
        mRegistrationProgressBar.setVisibility(ProgressBar.GONE);
        // 토큰을 가져오는 Button을 정의
        mRegistrationButton = (Button) findViewById(R.id.registrationButton);
        mRegistrationButton.setOnClickListener(new View.OnClickListener() {
            /**
             * 버튼을 클릭하면 토큰을 가져오는 getInstanceIdToken() 메소드를 실행한다.
             * @param view
             */
            @Override
            public void onClick(View view) {
                getInstanceIdToken();
            }
        });

    }

    /**
     * 앱이 실행되어 화면에 나타날때 LocalBoardcastManager에 액션을 정의하여 등록한다.
     */
    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
                new IntentFilter(QuickstartPreferences.REGISTRATION_READY));
        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
                new IntentFilter(QuickstartPreferences.REGISTRATION_GENERATING));
        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
                new IntentFilter(QuickstartPreferences.REGISTRATION_COMPLETE));

    }

    /**
     * 앱이 화면에서 사라지면 등록된 LocalBoardcast를 모두 삭제한다.
     */
    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(mRegistrationBroadcastReceiver);
        super.onPause();
    }


    /**
     * Google Play Service를 사용할 수 있는 환경이지를 체크한다.
     */
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }
}

```

### RegistrationIntentService.java

이 파일은 **Instance ID**를 가지고 **토큰**을 가져오는 작업을 한다. **GCM Demo** 앱을 위해 토큰을 가져오기 전에 **ProgressBar**를 동작시키고, 토큰을 가져오는 작업을 완료하면 ProgressBar를 멈추고 **TextView**에 토큰 정보를 업데이트하기 위한 **LocalBoardcast** 액션을 추가하였다.  `app/src/main/java/net/saltfactory/demo/gcm/RegistrationIntentService.java`  파일에 아래 내용을 저장한다. 자세한 내용은 주석으로 대신한다.

```java
package net.saltfactory.demo.gcm;

import android.annotation.SuppressLint;
import android.app.IntentService;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;

import java.io.IOException;

/**
 * Created by saltfactory on 6/8/15.
 */
public class RegistrationIntentService extends IntentService {

    private static final String TAG = "RegistrationIntentService";

    public RegistrationIntentService() {
        super(TAG);
    }

    /**
     * GCM을 위한 Instance ID의 토큰을 생성하여 가져온다.
     * @param intent
     */
    @SuppressLint("LongLogTag")
    @Override
    protected void onHandleIntent(Intent intent) {

        // GCM Instance ID의 토큰을 가져오는 작업이 시작되면 LocalBoardcast로 GENERATING 액션을 알려 ProgressBar가 동작하도록 한다.
        LocalBroadcastManager.getInstance(this)
                .sendBroadcast(new Intent(QuickstartPreferences.REGISTRATION_GENERATING));

        // GCM을 위한 Instance ID를 가져온다.
        InstanceID instanceID = InstanceID.getInstance(this);
        String token = null;
        try {
            synchronized (TAG) {
                // GCM 앱을 등록하고 획득한 설정파일인 google-services.json을 기반으로 SenderID를 자동으로 가져온다.
                String default_senderId = getString(R.string.gcm_defaultSenderId);
                // GCM 기본 scope는 "GCM"이다.
                String scope = GoogleCloudMessaging.INSTANCE_ID_SCOPE;
                // Instance ID에 해당하는 토큰을 생성하여 가져온다.
                token = instanceID.getToken(default_senderId, scope, null);

                Log.i(TAG, "GCM Registration Token: " + token);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // GCM Instance ID에 해당하는 토큰을 획득하면 LocalBoardcast에 COMPLETE 액션을 알린다.
        // 이때 토큰을 함께 넘겨주어서 UI에 토큰 정보를 활용할 수 있도록 했다.
        Intent registrationComplete = new Intent(QuickstartPreferences.REGISTRATION_COMPLETE);
        registrationComplete.putExtra("token", token);
        LocalBroadcastManager.getInstance(this).sendBroadcast(registrationComplete);
    }
}
```

## MyInstanceIDListenerService.java

이 파일은 **Instance ID**를 획득하기 위한 리스너를 상속받아서 토큰을 갱신하는 코드를 추가한다. `app/src/main/java/net/saltfactory/demo/gcm/MyInstanceIDListenerService.java` 파일에 아래 내용을 저장한다.


```java
package net.saltfactory.demo.gcm;

import android.content.Intent;

import com.google.android.gms.iid.InstanceIDListenerService;

/**
 * Created by saltfactory on 6/8/15.
 */
public class MyInstanceIDListenerService extends InstanceIDListenerService {

    private static final String TAG = "MyInstanceIDLS";

    @Override
    public void onTokenRefresh() {
        Intent intent = new Intent(this, RegistrationIntentService.class);
        startService(intent);
    }
}
```

### MyGcmListenerService.java

이 파일은 GCM으로 메시지가 도착하면 디바이스에 받은 메세지를 어떻게 사용할지에 대한 내용을 정의하는 클래스이다.
* **onMessageReceived()** : GCM으로부터 이 함수를 통해 메세지를 받는다. 이때 전송한 **SenderID**와 `Set` 타입의 데이터 컬렉션 형태로 받게된다.
* **sendNotification()** : GCM으로부터 받은 메세지를 디바이스에 알려주는 함수이다.
`app/src/main/java/net/saltfactory/demo/gcm/MyGcmListenerService.java` 파일에 아래 내용을 저장한다. 자세한 내용은 주석으로 대신한다.

```java
package net.saltfactory.demo.gcm;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.android.gms.gcm.GcmListenerService;

/**
 * Created by saltfactory on 6/8/15.
 */
public class MyGcmListenerService extends GcmListenerService {

    private static final String TAG = "MyGcmListenerService";

    /**
     *
     * @param from SenderID 값을 받아온다.
     * @param data Set형태로 GCM으로 받은 데이터 payload이다.
     */
    @Override
    public void onMessageReceived(String from, Bundle data) {
        String title = data.getString("title");
        String message = data.getString("message");

        Log.d(TAG, "From: " + from);
        Log.d(TAG, "Title: " + title);
        Log.d(TAG, "Message: " + message);

        // GCM으로 받은 메세지를 디바이스에 알려주는 sendNotification()을 호출한다.
        sendNotification(title, message);
    }


    /**
     * 실제 디바에스에 GCM으로부터 받은 메세지를 알려주는 함수이다. 디바이스 Notification Center에 나타난다.
     * @param title
     * @param message
     */
    private void sendNotification(String title, String message) {
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.ic_stat_ic_notification)
                .setContentTitle(title)
                .setContentText(message)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }
}
```
기타 필요한 resources들은 github에 올려놓은 예제에서 받아서 복사하여 사용하면 된다.

## GCM Demo 실행

이제 GCM 서비스를 만들기 위한 Android에 관한 모든 설정이 끝났다. **gradle**을 사용하여 디바이스로 실행하면 앱이 실행이 될 것이다. 간단하게 Android Studio에서 Run을 실행하면 된다. 앱을 실행하여 토큰을 획득하면 아래와 같이 **Instance ID**에 해당하는 **token**을 가져올 것이다.

![GCM Demo finish](http://asset.hibrainapps.net/saltfactory/images/58c6c243-badf-4b19-951d-e1257af2a789)

## Node.js를 이용한 GCM Provider 만들기

Android 디바이스에서 GCM을 사용하기 위한 **토큰**을 획득하였다. 이제 서버에서 Android 디바이스에 GCM을 사용하여 메세지를 보내도록 하자. 이전 블로그에서도 Node.js로 GCM을 사용하여 메세지를 보내기 위한 코드를 소개한적이 있는데 그대로 사용하면 된다.

우선 [node-gcm](https://github.com/ToothlessGear/node-gcm) 이 필요하기 때문에 설치를 한다. (시스템에 node.js가 설치되어 있다고 가정한다.)

```
npm install node-gcm
```
이제 GCM을 사용하여 메세지를 보내기 위한 간단한 provider 소스코드를 작성하자. `gcm-provider.js`라는 파일로 다음 내용을 저장한다. 서버에서 GCM을 사용하여 메세지를 보낼때 2가지 중요한 변수가 있다.

* **Server API Key** : 처음 GCM 웹 페이지에서 앱을 등록하고 획득한 Server API Key 이다.
* **InstanceID token** : Android 디바이스에서 Instance ID의 token을 획득한 것을 사용한다.

![](http://asset.hibrainapps.net/saltfactory/images/b6e4fd95-f775-4560-acb2-b80ecafae1d8)

```javascript
var gcm = require('node-gcm');
var fs = require('fs');

var message = new gcm.Message();

var message = new gcm.Message({
    collapseKey: 'demo',
    delayWhileIdle: true,
    timeToLive: 3,
    data: {
        title: 'saltfactory GCM demo',
        message: 'Google Cloud Messaging 테스트’,
        custom_key1: 'custom data1',
        custom_key2: 'custom data2'
    }
});

var server_api_key = ‘GCM 앱을 등록할때 획득한 Server API Key’;
var sender = new gcm.Sender(server_api_key);
var registrationIds = [];

var token = ‘Android 디바이스에서 Instance ID의 token’;
registrationIds.push(token);

sender.send(message, registrationIds, 4, function (err, result) {
    console.log(result);
});
```

이제 메세지를 발송해보자. 정상적으로 발송되면 아래와 같은 화면이 나타난다.

```
node gcm_provider.js
```
![gcm_provider](http://asset.hibrainapps.net/saltfactory/images/e8b95a14-84d4-4165-8730-b25e811d517c)

이제 Android 디바이스에 GCM으로 메세지가 전송되었는지 Notification Center를 확인하자.

![GCM message](http://asset.hibrainapps.net/saltfactory/images/de43ac19-a66d-4fdf-9b07-5c63777a6b88)


## HTTP Connection Server

**GCM** 서비스가 지속적으로 업그레이드되면서 더이상 GCM 서버를 만들 필요가 없게 되었다. 이제 서버구현없이 [HTTP](https://developers.google.com/cloud-messaging/http)로 바로 GCM 메시지 전송을 보낼 수 있기 때문이다. 아래와 같이 GCM에서 제공하는 **HTTP Conection Server**를 사용하기 위해서 터미널에서 특별한 프로그램없이 바로 GCM을 사용할 수 있다. **Server API Key**만 있으면 https://gcm-http.googleapis.com/gcm/send 로 인증과 함께 메세지를 바로 전송할 수 있다.

* **$server_api_key** : GCM에 앱을 등록할 때 획득한 Server API Key
* **$token** : 디바이스 Instance ID의 token 값

```bash
curl --header "Authorization: key=$server_api_key" \
--header Content-Type:"application/json" \
https://gcm-http.googleapis.com/gcm/send \
-d "{\"data\":{\"title\":\"saltfactory GCM demo\",\"message\":\"Google Cloud Messaging 테스트\"},\"to\":\"$token\"}"
```
![HTTP Connection Server](http://asset.hibrainapps.net/saltfactory/images/22a6ef72-9164-4939-90a8-2bdd158e7ec7)

## 결론

이전에 블로그에 [Node.js와 Google Play Service를 이용하여 안드로이드 푸시서비스 구현하기(GCM)](http://blog.saltfactory.net/node/implementing-push-notification-service-for-android-using-google-play-service.html) 라는 글을 작성하고 많은 질문을 받았다. Google의 푸시 서비스는 [C2DM](https://developers.google.com/android/c2dm/) 부터 설정이 꽤 복잡했다. GCM이라는 이름을 변경하고 **Google Play Service**로 GCM을 통합하면서 `gcm.jar`를 사용하여 그 방법을 개선하다가, Android Studio와 **Gradle**의 조합으로 최근에 GCM 서비스를 개발하기에는 매우 간편해졌다. (아직 조금은 복잡하지만) 이 블로그의 글로 최신 GCM을 사용하는데 조금이라도 도움이 되길 바란다. 이번 GCM 업데이트에서는 [Instance ID](https://developers.google.com/instance-id/)와 [HTTP connection Server](https://developers.google.com/cloud-messaging/http)의 등장으로 GCM을 위한 서버를 구축하지 않아도 되어 GCM 서비스를 구축하는데 더욱 간편해졌다. 한간지 더! 이번 GCM 업데이트로 iOS도 GCM으로 푸시서비스를 구현할 수 있다는 것이다. 이제 Android, iOS 디바이스로 푸시를 발송하기 위해서 따로 푸시 서버(Push Provider)를 구축하지 않아도 된다는 말이다. iOS 디바이스에 GCM을 사용하여 푸시 서비스를 구현하는 방법은 이후에 블로그를 통해 소개할 예정이다.

## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial/tree/gcm-demo

## 참고

1. http://blog.saltfactory.net/node/implementing-push-notification-service-for-android-using-google-play-service.html
2. https://developers.google.com/cloud-messaging/
3. https://developers.google.com/cloud-messaging/android/start
4. https://developers.google.com/cloud-messaging/registration
5. https://developers.google.com/cloud-messaging/android/client
6. https://developers.google.com/cloud-messaging/http

