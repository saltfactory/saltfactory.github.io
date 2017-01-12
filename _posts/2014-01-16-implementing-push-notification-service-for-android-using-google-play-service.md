---
layout: post
title: Node.js와 Google Play Service를 이용하여 안드로이드 푸시서비스 구현하기(GCM)
category: node
tags: [node, node.js, android, push, notification, gcm, google play service]
comments: true
redirect_from: /216/
disqus_identifier : http://blog.saltfactory.net/216
---

## 서론

번 사내 프로젝트는 아이폰, 안드로이드 푸시 프로바이더를 springframework에서 Node.js로 마이그레이션하는 작업이 진행되었다. 첫번째 포스팅으로 "Node.js로 푸시서비스 구현하기 1. 아이폰(iOS) 푸시서버 구현하기"에서는 node-apn을 이용해서 아이폰 푸시 프로바이더를 구현한 간단한 예제를 소개하였고, 이번 포스팅에서는 node-gcm을 이용해서 안드로이드 푸시 프로바이더를 구현하는 방법을 소개하고자 한다.

우리는 기존에 C2DM(https://developers.google.com/android/c2dm/?csw=1)을 사용해서 안드로이드 푸시를 구현했었다. 그러나 링크를 보면 알겠지만 C2DM은 2012년 6월 26일부터 더이상 업데이트를 지원하고 있지않다. 그럼 안드로이드 푸시는 어떻게 구현할 수 있는가? 구글에서는 푸시서비스를 위해서 GCM(Google Cloude Messaging) http://developer.android.com/google/gcm/index.html 을 제공하고 있다.

> 이 글은 [2015-06-09-최신 Android Studio, GCM(Google Cloud Messaging), Node.js를 이용하여 Android 푸시 서비스 구현하기](http://blog.saltfactory.net/android/implement-push-service-via-gcm.html) 글로 업데이트 되었습니다.

<!--more-->

### GCM 프로젝트 등록

우선 GCM을 사용하기 위해서는 GCM에 프로젝트를 등록하고 API를 획득해서 사용해야한다. GCM에 프로젝트를 등록하기 위해서는 [Google Developers Console](https://cloud.google.com/console)을 연다.

CREATE PROJECT 를 눌러서 안드로이드 푸시 프로젝트를 생성한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/b29366a1-49d6-4607-8c2b-2744a954a440)

![](http://asset.blog.hibrainapps.net/saltfactory/images/58d4c51f-95ca-4cd2-87b0-e28f66d09b4c)

프로젝트를 생성하면 고유 **Project ID**를 입력하고(Project ID는 고유한 값으로 직접 등록할 수 있다.) **Project Number**를 획득한다.

### Google Cloud Messaging for Android 활성화

다음은 APIs & Auth 메뉴를 선택한다. 기본적으로 Google Cloud 서비스 API가 활성화 되어 있는데 GCM을 사용할 때는 필요없기 때문에 모두 비활성화 시킨다. 우리가 필요한 것은 **Google Cloud Messaging for Android API** 이기 때문에 이 항목을 찾아서 활성화 시킨다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/d2133a86-4a76-42a2-b5f3-7a9177f36b4e)

## API Access Key 생성

다음은 **Credentials** 메뉴를 선택해서 API access key를 생성한다. **CREATE NEW KEY** 를 선택하면 여러가지 환경에 사용할 key를 만들 수 있는데, 우선 안드로이드 디바이스에서 API access key를 생성해야하기 대문에 **Android Key**를 선택한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/c64f8107-8a83-4146-a48e-99cd596e7250)

![](http://asset.blog.hibrainapps.net/saltfactory/images/966b57c2-a248-4626-bd52-bbe45b0aaf0f)

![](http://asset.blog.hibrainapps.net/saltfactory/images/aee5e224-76f1-4f24-bad8-9203c6d0c3fa)

이렇게 등록한 Android API access key는 안드로이드 디바이스에서 GCM을 이용해서 푸시를 받을 수 있는 **registration_id** 값을 획득하는데 사용된다. 아이폰에서는 device token과 같은 개념이 registration_id 이다. 다음은 안드로이드에 registration_id를 획득하는 라이브러리를 추가하고 코드를 작성한다.

### GCM 예제 코드 다운로드

구글에서는 GCM에 관련된 클라이언트 코드를 이미 제공하고 있으니 그 코드를 사용하기로 하자.
https://code.google.com/p/gcm/

구글도 이젠 소스코드를 git로 관리하고 있다. GCM에 관련된 코드를 git를 사용해서 clone을 할 수 있다.

```
git clone https://code.google.com/p/gcm/
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/51c5964c-0f36-46d7-a57f-ae1a851cdd60)

### Google Play Service SDK 다운로드

인터넷에서 GCM 구현에 관련된 글들을 찾아보면 대부분 gcm.jar를 사용하는데 gcm.jar 역시 deprecate 되었다. 그래서 위에서 다운받은 gcm-client-deprecated를 살펴보면 dist 디렉토리 안에 gcm.jar가 포함되어 있는 것을 확인할 수 있다. 하지만 Google에서는 Cloud Messaging Service는 모두 **Google Play Service** 로 통합되었기 때문에 gcm.jar를 사용하는 포스팅을 참조하기 보다는 Google Play Service SDK를 사용한 예제를 참조하는것이 좋다. Google Play Service SDK는 기본적으로 android SDK를 다운 받는다고 설치되는 것이 아니라 extra 로 따로 다운 받아야 한다. android SDK Manager를 열어서 Google Play Service SDK를 다운로드한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/5b2d9a80-1e69-412a-9ce1-0c566775e3be)

이렇게 다운받은 파일은 `android-sdk-mac/sdk/extras/google/google_play_services/libproject/google-play-services_lib/libs` 라는 디렉토리 안에 존재하게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/d3ad4859-042a-49b5-ad52-032e74d75c19)

### 안드로이드 프로젝트 생성

이제 안드로이드 프로젝트를 생성해서 GCM 획득하는 코드를 추가할 것이다. 이름은 sf-push-demo 라고 만들었다. 안드로이드 개발은 여러가지 IDE로 개발할 수 있으니 보통 eclipse로 한다. 우리는 연구소에서 IntelliJ를 Java IDE를 사용하고 있기 때문에 IntelliJ 환경으로 설명하도록 하겠다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/3767843e-cf27-4df6-a46c-70cbda5ff2e1)

![](http://asset.blog.hibrainapps.net/saltfactory/images/72500313-fb59-4ec0-9b2f-3e672561788e)

프로젝트 이름은 sf-push-demo 라고 하였고, 패키지이름은 net.saltfactory.tutorial.sfpushdemo로 지정하였다.

### Google Play Service SDK 라이브러리 복사

그리고 앞에서 다운받은 Google Play SDK를 프로젝트 디렉토리의 libs 안으로 복사한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/98df94b6-9ea9-4220-a5c5-b496812c1240)

### Google Play Service version.xml 파일 복사

Google Play Service를 사용하기 위해서는 `AndroidManifest.xml` 파일 안에 `<application>`태그 안에 `<meta-data>` 값으로 Google Play Service 버전 정보를 넣어줘야하는데 이 정보는 `android-sdk-mac/sdk/extras/google_play_services/libproject/google-paly-services_lib/res/values/version.xml` 에 존재한다. 이 파일을 복사해서 새로 생성한 프로젝트의 `res/values/` 디렉토리 안에 추가한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/33f93e6b-36c4-4bcd-95eb-88c6410369de)

### Android Support 라이브러리 추가

안드로이드에서는 다양한 sdk 버전을 커버하기 위해서 android에서도 확장 라이브러리를 가지고 있는데 GCM 구현에서는 android v4 확장 라이브리가 필요하다. 이것은 `android-sdk-mac/sdk/extras/android/support/v4/android-support-v4.jar` 에 존재하는데 이것도 libs 디렉토리에 복사해서 넣는다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/9aab28ea-dddb-4edd-8e0e-c1d2427d9267)

### 예제 Resources 파일 추가

그리고 앞에서 clone 받은 gcm-client 디렉토리에서 resources들을 복사한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/c3fb5700-2153-4931-9ce4-1fc7ed4b66fc)

### GCM 클래스 추가

이젠 GCM을 사용할 준비를 마쳤으니 코드를 추가하자. gcm-client 안에 있는 소스 중에서 `src/com/google/android/gcm/demo/app/` 디렉토리 안에서 `GcmBroadcastReceiver.java`와 `GcmIntentService.java`를 복사해서 프로젝트에 생성된 패키지 안에다 넣는다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/147f4ba9-ed1a-44b2-a5a0-a01945919a20)

#### GcmIntentService 파일 수정

그러면 다음과 같이 GcmIntentService 파일에 에러가 발생하는데 예제로 사용된 gcm-client에서 푸시가 도착하면 DemoActivity를 열려고해서 그런것이다. 이것을 우리가 예제로 생성한 MyActivity가 열리도록 수정을 한다.

```java
// Put the message into a notification and post it.
    // This is just one simple example of what you might choose to do with
    // a GCM message.
    private void sendNotification(String msg) {
        mNotificationManager = (NotificationManager)
                this.getSystemService(Context.NOTIFICATION_SERVICE);

        PendingIntent contentIntent = PendingIntent.getActivity(this, 0,
                new Intent(this, MyActivity.class), 0);

        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
        .setSmallIcon(R.drawable.ic_stat_gcm)
        .setContentTitle("GCM Notification")
        .setStyle(new NotificationCompat.BigTextStyle()
        .bigText(msg))
        .setContentText(msg);

        mBuilder.setContentIntent(contentIntent);
        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }
```

### AndroidManifest.xml 파일 수정

다음은 안드로이드에 GCM을 사용할 수 있는 설정을 해야하기 때문에 `AndroidManifest.xml`을 열어서 다음과 같이 수정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="com.example.sfpushdemo"
          android:versionCode="1"
          android:versionName="1.0">

    <!--<uses-sdk android:minSdkVersion="19"/>-->
    <!-- GCM requires Android SDK version 2.2 (API level 8) or above. -->
    <!-- The targetSdkVersion is optional, but it's always a good practice
         to target higher versions. -->
    <uses-sdk android:minSdkVersion="8" android:targetSdkVersion="16"/>

    <!-- GCM connects to Google Services. -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- GCM requires a Google account. -->
    <uses-permission android:name="android.permission.GET_ACCOUNTS" />

    <!-- Keeps the processor from sleeping when a message is received. -->
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <!--
     Creates a custom permission so only this app can receive its messages.

     NOTE: the permission *must* be called PACKAGE.permission.C2D_MESSAGE,
           where PACKAGE is the application's package name.
    -->
    <permission
            android:name="com.google.android.gcm.demo.app.permission.C2D_MESSAGE"
            android:protectionLevel="signature" />
    <uses-permission
            android:name="com.google.android.gcm.demo.app.permission.C2D_MESSAGE" />

    <!-- This app has permission to register and receive data message. -->
    <uses-permission
            android:name="com.google.android.c2dm.permission.RECEIVE" />

    <application android:label="@string/app_name" android:icon="@drawable/ic_launcher">
        <meta-data
                android:name="com.google.android.gms.version"
                android:value="@integer/google_play_services_version" />

        <activity android:name="MyActivity"
                  android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!--
          BroadcastReceiver that will receive intents from GCM
          services and handle them to the custom IntentService.

          The com.google.android.c2dm.permission.SEND permission is necessary
          so only GCM services can send data messages for the app.
        -->
        <receiver
                android:name=".GcmBroadcastReceiver"
                android:permission="com.google.android.c2dm.permission.SEND" >
            <intent-filter>
                <!-- Receives the actual messages. -->
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                <!-- Receives the registration id. -->
                <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
                <category android:name="com.google.android.gcm.demo.app" />
            </intent-filter>
        </receiver>

        <!--
          Application-specific subclass of GCMBaseIntentService that will
          handle received messages.

          By default, it must be named .GCMIntentService, unless the
          application uses a custom BroadcastReceiver that redefines its name.
        -->
        <service android:name=".GcmIntentService" />
    </application>
</manifest>
```

긴 작업이였지만 위의 순서대로 진행하면 오류없이 안드로이드 디바이스로 빌드가 될 것이다. 그리고 빌드가 성공하면 TextView에 안드로이드 디바이스 정보가 나오는 것을 확인할 수 있다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/5877d9ec-7922-403f-bc8e-db5bfdc33b7c)

이렇게 획득한 **registration_id** 는 푸시 프로바이더에서 푸시를 발송할 때 사용된다.

## node-gcm 설치

이제 안드이드 디바이스는 푸시를 받을 준비를 모두 마쳤다. 이젠 안드로이드 디바이스로 푸시를 발송하는 푸시 프로바이더를 구현할 것이다. 우리는 Node.js를  이용해서 푸시 프로바이더 구현하기로 했다. node-gcm은 이 과정을 매우 간단하게 만들어준다. 먼저 node-gcm을 설치하자.

```
npm install node-gcm
```

![](http://asset.blog.hibrainapps.net/saltfactory/images/c44a340c-160c-4fc5-b038-0157a6cff723)

## Push Provider GCM Server Access Key 생성

우리는 앞에서 안드로이드의 registration_id를 획득하기 위해서 엑세스키를 만드는 과정을 한번 진행했었다. 이제 동일한 작업으로 server key를 생성한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/15315f59-5a94-41e9-9ed9-96c0127ea672)

서버는 IPs 접근을 제한하는 항목이 보일것이다. 이제 푸시 프로바이더의 access key를 구했으니 푸시 프로바이더 코드를 작성하자.

```javascript
var gcm = require('node-gcm');

// create a message with default values
var message = new gcm.Message();

// or with object values
var message = new gcm.Message({
    collapseKey: 'demo',
    delayWhileIdle: true,
    timeToLive: 3,
    data: {
        key1: '안녕하세요.',
        key2: 'saltfactory push demo'
    }
});

var server_access_key = '푸시 프로바이더 서버 access key 값';
var sender = new gcm.Sender(server_access_key);
var registrationIds = [];

var registration_id = '안드로이드 registration_id 값';
// At least one required
registrationIds.push(registration_id);

/**
 * Params: message-literal, registrationIds-array, No. of retries, callback-function
 **/
sender.send(message, registrationIds, 4, function (err, result) {
    console.log(result);
});
```

이제 이 파일을 실행한다.

```
node sf-push-provider.js
```

잠시 후 안드로이드 디바이스로 GCM으로 메세지가 전송된 것을 확인할 수 있다. (아래와 같이 출력하기 위해서는 안드로이드의 GCM 코드에 약간의 변경을 가해야한다. 구글에서 제공하는 기본 코드는 푸시 프로바이더의 payload로 전송한 key값을 출력하는 것이 아니라 object자체를 출력하게 되어 있다.) 이 포스팅에 진행된 모든 소스코드는 github를 통해서 공개하고 있으니 참조하기 바란다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/e828510c-963a-458a-aedd-70851fbcd830)

## 결론

안드로이드 푸시는 아이폰의 푸시보다 복잡하게 구현한다. 더구나 이전에 C2DM과 gcm.jar를 이용하는 방법의 포스팅이 많아서 대부분 deprecate 되어 있는 자료로 푸시를 구현하고 있어서 Google Play Service를 이용하여 푸시를 전송하는 방법을 소개했다. 더구나 푸시의 핵심은 바로 Push Provider를 구축하는 것인데 기존의 구글에서 제공하는 GCM-Server를 열어보면 Java로 매우 긴 코드로 복잡하게 되어 있다. 우리는 사내 프로젝트로 Springframework를 도입했는데, 단순히 푸시 서버를 구현하는데 너무 많은 자원을 사용하고 복잡도가 높았기 때문에 이번에 Node.js로 마이그레이션을 진행하였다. 이에 우리 연구소에서 진행한 자료를 보다 간단하게 만들어서 공개하기로 결정했으며, 안드로이드 및 아이폰 푸시 서비스를 구축하는 개인 개발자와 소규모 중소기업에 조금이라도 도움이 되길 바란다.

> 이 글은 [2015-06-09-최신 Android Studio, GCM(Google Cloud Messaging), Node.js를 이용하여 Android 푸시 서비스 구현하기](http://blog.saltfactory.net/android/implement-push-service-via-gcm.html) 글로 업데이트 되었습니다.


## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial/tree/sf-push-demo

## 참고

1. http://developer.android.com/google/gcm/index.html
2. http://developer.android.com/google/gcm/gs.html
3. https://github.com/ToothlessGear/node-gcm


