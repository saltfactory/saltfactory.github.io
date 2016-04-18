---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 10.Android C2DM 푸시 적용하기
category: appspresso
tags:  [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, c2dm]
comments: true
redirect_from: /135/
disqus_identifier : http://blog.saltfactory.net/135
---

## 서론

이번 글에서는 Appsresso (앱스프레소)에서 안드로이드 앱에서 설치될 경우 푸시 적용을 어떻게 하는지에 대해 설명한다. [Appspresso를 사용하여 하이브리드앱 개발하기 - 9.iOS 푸시 적용하기](http://blog.saltfactory.net/134) 글에서 우리는 PDK(Plugins Development Kit)를 이용해서 iOS (iPhone, iPad, iPod touch) 앱에서 푸시를 설정하는 방법을 살펴 보았다. 혹시 PDK을 이용하여 네이티브 코드를 사용하는 방법을 참고 하고 싶으면 [Appspresso를 사용하여 하이브리드앱 개발하기 - 5.PDK(Plugin Development Kit)를 이용하여 네이티브 코드 사용](http://blog.saltfactory.net/129) 글을 참조하기 바란다.

<!--more-->

Appspresso에서 푸시를 적용하기 위해선 PDK를 이용해서 Appspresso Plugins Project를 생성하여 연결해야한다. 이 과정에 대해서는 이전의 글들을 살펴보면 될 것이다. 이전에 우리는 SaltfactoryPushPlugin이라는 plugin 프로젝트를 만들었고 SaltfactoryPushPlugin_ios 와 SaltfactoryPushPlugin_android 안드로이드 모듈 프로젝트가 만들었다.

![](http://asset.hibrainapps.net/saltfactory/images/b3a63242-2949-4d8d-ae92-d0b205d802fb)

Appspresso에서 Android module project를 생성하면 다음과 같이 에러가 날 것이다.

![](http://asset.hibrainapps.net/saltfactory/images/144f3b63-fac6-447c-b69c-ec00b1803acc)

이 것은 Appspresso에서 안드로이드 모듈을 생성하는 프로젝트만 만들어주고 library path를 자동으로 잡아주지 않기 때문에 발생하는 문제이다. 그래서 JRE와 android.jar 추가한다.

![](http://asset.hibrainapps.net/saltfactory/images/f86a57cd-ac0f-4947-8b36-6475172f398e)

이때 주의할 것은 안드로이드에서 C2DM을 사용하기 위해서는 android-8 버전 이후 부터 사용이 가능하기 때문에 이후의 android.jar를 추가한다.

![](http://asset.hibrainapps.net/saltfactory/images/fd1660bf-3d20-48c9-bbb5-bd92f5bf3b67)

이 글 앞에 설명한 [Appspresso를 사용하여 하이브리드앱 개발하기 - 9.iOS 푸시 적용하기](http://blog.saltfactory.net/134)과 동일한 과정으로 해보자. iOS에서 마찬가지로 디바이스 토큰을 가져와야하는데, 안드로이드에서는 디바이스토큰 대신에 registration_id라는 용어를 사용한다. 디바이스마다 고유한 아이디를 C2DM 서비스에서 획득해서 푸시를 보낼때 그 아이디를 사용하는 것인데, android는 iOS와 다르게 delegate method로 구현되는 것이 아니라 Services 라는 것을 사용해서 iOS와 동일한 과정으로 registration_id를 획득할 수 있다. (C2DM을 사용하기 위해서 구글에 서비스 등록 신청서를 작성해서 전송해야하는데 그 과정은 생략한다.)

우리는 두가지 클래스를 만들 것이다. 하나는 registration_id를 획득하기 위한 C2DMRegistrationReceiver와 푸시가 안드로이드 디바이스로 왔을때 푸시를 처리할 C2DMReceiver 클래스를 생성한다. net.saltfactory.tutorial 이라는 패키지 안에다 두 클래스를 만들었다.

![](http://asset.hibrainapps.net/saltfactory/images/54f6bc63-8561-434a-99c6-0d5def685196)

이제 regsistration_id를 획득하기 위해서 C2DMRegistrationReceiver 클래스를 구현한다. iOS에서 디바이스 토큰을 NSUserDefaults에 저장하듯, android에서는 SharedPreferences에 "registration_id" 라는 키로 저장을 한다.

```java
package net.saltfactory.tutorial;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

/**
 * User: saltfactory
 * Date: 11/23/11
 * Time: 3:06 PM
 * Email: saltfactory@gmail.com
 */
public class C2DMRegistrationReceiver  extends BroadcastReceiver{

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.d("net.saltfactory.tutorial", "Registration Receiver called");

        if ("com.google.android.c2dm.intent.REGISTRATION".equals(action)) {
            Log.d("net.saltfactory.tutorial", "Received registration ID");

            final String registrationId = intent.getStringExtra("registration_id");

            Log.d("net.saltfactory.tutorial", "net.saltfactory.tutorial:"+ registrationId);

            if (registrationId != null) {
                SharedPreferences preference = PreferenceManager.getDefaultSharedPreferences(context);
                SharedPreferences.Editor editor = preference.edit();
                editor.putString("registration_id", registrationId);
                editor.commit();
            } else {
                String error = intent.getStringExtra("error");

                Log.d("net.saltfactory.tutorial", "dmControl: registrationId = " + registrationId+ ", error = " + error);
            }
        }
    }
}
```

안드로이드에서는 C2DM을 사용하기 위해서 AndroidManifest.xml를 C2DM을 사용한다고 설정을 해야한다. Appspresso 1.1 버전부터는 각각의 앱 환경 설정을 외부에서 설정할 수 있게 업데이트가 되었는데 AndroidManifest.axml 이라는 파일에서 설정을 추가할 수 있게 되었다.

![](http://asset.hibrainapps.net/saltfactory/images/778194b5-a3a4-4984-89de-c17e31d76ee8)

AndroidManifest.axml 파일을 열어서 C2DM을 사용할 수 있게 설정을 추가한다. 기존의 C2DM을 사용했던 개발자나 연구원들은 패키지명 규칙에 대해서 잘 알고 있지만 처음 C2DM을 접하는 분은 꼭 패키지명에 대해서 주의하길 바란다. 그런 의미에서 패키지 명에 대해서 다시 다른 색으로 표시하였다. 이 포스팅의 예제에서 C2DM의 기본 패키지는 net.saltfactory.tutorial이라고 지정하였다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="@PACKAGE@"
    android:installLocation="@INSTALL_LOCATION@"
    android:versionCode="@VERSION_CODE@"
    android:versionName="@VERSION_NAME@" >

    <application
        android:icon="@drawable/ax_icon"
        android:label="@string/ax_name" >
        <activity
            android:name="@ACTIVITY@"
            android:configChanges="orientation|keyboard|keyboardHidden"
            android:screenOrientation="@ACTIVITY_ORIENTATION@"
            android:theme="@ACTIVITY_THEME@" >

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

        </activity>

        <!-- If you want to add another android components, please let them be here. -->
		<receiver android:name=".C2DMRegistrationReceiver"
                  android:permission="com.google.android.c2dm.permission.SEND">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.REGISTRATION"/>
                <category android:name="net.saltfactory.tutorial"/>
            </intent-filter>
        </receiver>


        <receiver android:name=".C2DMReceiver"
                  android:permission="com.google.android.c2dm.permission.SEND">
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE"/>
                <category android:name="net.saltfactory.tutorial"/>
            </intent-filter>
        </receiver>
    </application>

    <receiver android:name="C2dmReceiver" android:permission="com.google.android.c2dm.permission.SEND">
    <intent-filter>
        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
        <category android:name="net.saltfactory.tutorial" />
    </intent-filter>
    <intent-filter>
        <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
        <category android:name="net.saltfactory.tutorial" />
    </intent-filter>
	</receiver>

    <permission android:name="net.saltfactory.tutorial.permission.C2D_MESSAGE" android:protectionLevel="signature"/>
    <uses-permission android:name="net.saltfactory.tutorial.permission.C2D_MESSAGE"/>
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE"/>

    <uses-permission android:name="android.permission.INTERNET" />
    @USES_PERMISSION@

   	@USES_SDK@

</manifest>
```

이제 C2DM을 등록하고 받기 위해서 설정하는 부분을 마쳤다. 실제 푸시가 왔을 때 디바이스에 어떠한 일을 처리하기 위해서 C2DMReceiver를 구현하도록 하자. iOS는 기본적으로 푸시가 오면 Alert 창이 나타나거나 Push Notification Center에 목록으로 나타나지만, 안드로이드는 푸시가 왔다는 이벤트만 감지하지 다른 모든 것은 직접 구현을 해야한다. 이 포스팅의 예제에서는 Toast 를 하나 띄워서 푸시에서 받는 텍스트를 출력시키도록 한다.

```java
package net.saltfactory.tutorial;

import android.content.*;
import android.util.Log;
import android.widget.Toast;

/*
 * User: saltfactory
 * Date: 11/23/11
 * Time: 1:35 PM
 * Email: saltfactory@gmail.com
 */
public class C2DMReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();

        Log.d("net.saltfactory.tutorial", "Message Receiver called");
        if ("com.google.android.c2dm.intent.RECEIVE".equals(action)) {
            Log.d("net.saltfactory.tutorial", "Received message");

            final String payload = intent.getStringExtra("payload");
            Log.d("net.saltfactory.tutorial", payload);

            Toast.makeText(context, payload, Toast.LENGTH_LONG);
        }
    }

}
```

C2DM을 등록하거나 디바이스에서 푸시가 왔을 때 받는 클래스를 모두 정의하였다. 이제 앱이 실행될 때 registration_id를 획득할 수 있게 설정해줘야한다. iOS용 푸시를 설정할 때 AxPlugin 프로토콜에 UIApplicationDelegate를 MyPlugin 클래스에서 추가한 것을 기억할 것이다. Android에서도 동일하게 MyPlugin 클래스에 iOS와 비슷한 방법으로 등록을 할 것이다. iOS에서는 protocol이라는 것을 사용해서 정의된 delegate 메소드를 사용할 수 있지만 android에는 listener라는 방법을 사용한다. 안드로이드의 MyPlugin 클래스는 AxPlugin 이라는 interrface에 의해 정의된 클래스이다. 그중에서 activate는 iOS의 - activate: 와 동일한 메소드가 존재하고 iOS의 plugin과 마찬가지로 AxRuntimeContext 를 받아서 사용한다. AxRuntimeContext에는 -addActivityListener라는 메소드가 존재하는데 이것은 Android의 Activity의 이벤트를 wrapping하여 핸들링할 수 있게 만든 AcitivityListener를 runtimeContext에 추가할 수 있게 하는 메소드 이다. 아래와 같이 MyPlugin의 activate 메소드 안에서 activityListener를 만들어서 runtimeContext에 addActivityListener로 추가한다. ActivityListener는 Activity의 이벤트를 각각 onActivity이벤트 로 래핑되어져 있다. 그중에서 우리는 activity가 처음 생성될 때 registration_id를 획득하기 원하기 때문에 onActivityCreate 메소드 안에서 registration_id를 획득할 수 있는 코드를 추가한다. 마지막으로 우리는 HTML로 되어진 web에서 registration_id를 가져올 것인데, 이 방법도 iOS에서 javascript에서 call by name으로 획득하는 방법과 동일하게 execute 메소드 안에서 getDeviceToken이라는 이름으로 접근하여 받아오게 할 것이다.

```java
public class MyPlugin implements AxPlugin {

	private AxRuntimeContext runtimeContext;
	private ActivityListener activityListener;

	@Override
	public void activate(AxRuntimeContext runtimeContext) {
		this.runtimeContext = runtimeContext;

		// TODO: addActivityListener
		this.activityListener = new ActivityListener(){

			@Override
			public void onActivityCreate(Activity activity,
					Bundle savedInstanceState) {
				// TODO Auto-generated method stub
		        Intent registrationIntent = new Intent("com.google.android.c2dm.intent.REGISTER");
		        registrationIntent.putExtra("app", PendingIntent.getBroadcast(activity, 0, new Intent(), 0)); // Application ID
		        registrationIntent.putExtra("sender", "saltfactory@gmail.com");  // Sender ID
		        activity.startService(registrationIntent); //서비스 시작 (Registration ID 발급 받기)
			}

			@Override
			public void onActivityDestroy(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onActivityPause(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onActivityRestart(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public boolean onActivityResult(Activity activity, int requestCode,
					int resultCode, Intent imageReturnedIntent) {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public void onActivityResume(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onActivityStart(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onActivityStop(Activity activity) {
				// TODO Auto-generated method stub

			}

			@Override
			public boolean onBackPressed(Activity activity) {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public boolean onCreateOptionsMenu(Activity activity, Menu menu) {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public void onNewIntent(Activity activity, Intent intent) {
				// TODO Auto-generated method stub

			}

			@Override
			public boolean onOptionsItemSelected(Activity activity,
					MenuItem item) {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public boolean onPrepareOptionsMenu(Activity activity, Menu menu) {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public void onRestoreInstanceState(Activity activity,
					Bundle savedInstanceState) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onSaveInstanceState(Activity activity, Bundle outState) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onWindowFocusChanged(boolean hasFocus) {
				// TODO Auto-generated method stub

			}};
		this.runtimeContext.addActivityListener(activityListener);

		// TODO: addWebViewListener
	}

	@Override
	public void deactivate(AxRuntimeContext runtimeContext) {
		this.runtimeContext = null;

		// TODO: removeActivityListener
		this.runtimeContext.removeActivityListener(activityListener);
		// TODO: removeWebViewListener
	}

	@Override
	public void execute(AxPluginContext context) {
		String method = context.getMethod();

		if ("echo".equals(method)) {
			String message = context.getParamAsString(0, null);
			context.sendResult(message);
		} else if("getDeviceToken".equals(method)){
 			SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(this.runtimeContext.getActivity());
 			String registeration_id = preferences.getString("registration_id", null);
 			context.sendResult(registeration_id);
 		}
		else {
			context.sendError(AxError.NOT_AVAILABLE_ERR);
		}
	}

}
```

C2DM에 관한 안드로이드 설정은 모두 끝났다. 저 포스팅에서도 이야기 했지만 Asspresso의 현재 버전은 디바이스 디버깅을 할 수가 없다. 그러한 이유로 이전 포스팅 (iOS 디바이스를 디버깅하는 방법 포함) 에서는 organizer를 이용해서 디바이스 콘솔 로그를 확인하였다. Android SDK를 다운 받으면 Xcode의 organizer와 동일하게 사용할 수 있는 것이 바로 ddms 라는 툴이다. ddms는 Dalvik Debug Monitor 라는 툴로 디바이스의 여러가지 상태를 디버깅 할 수 있다. HTC의 NexusOne의 net.saltfactory.tutorial이라는 예제 앱을 디버깅할 때 다음과 같이 로그를 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/63388556-e86c-49d7-bffa-13c02cbba6bb)

이렇게 ddms를 켜둔 상태에서 Appspresso에서 Android 디바이스로 빌드와 설치를 진행하면 디바이스 로그를 모니터링 할 수 있다. 우리는 앱이 실행될 때 registration_id를 획득하게 프로그램을 작성하였다. 그리고 registration_id를 획득하면 로깅하도록 했기 때문에 ddms에서 registration_id를 로깅하는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/e9b9cb54-27ef-47f5-bbc2-f5b50fbaf18d)

디바이스에서 획득한 registration_id를 index.html으로 가져오기 위해서 stub 메소드는 구현되어져 있다. iOS 푸시 예제를 만들때 사용한 stub를 그대로 사용하는데 이 때 "getDeviceToken"이라는 이름으로 네이티브 클래스와 통신하게 했었던 것을 기억할 것이다. 혹시 이전 포스팅을 확인하지 못했을 경우를 위해서 코드를 다시 보여주면 SaltfactoryPushPlugin 플러그인 프로젝트에서 axplugin.js에 stub 메소드를 추가한다.

```javascript
/*
 * JavaScript Stub Appspresso Plugin
 *
 * id: net.saltfactory.hybirdtutorial.pushplugin
 * version: 1.0.0
 * feature: <feature id="" category="Custom" />
 */

(function(){
	function echoSync(message) {
		if(!message) {
			throw ax.error(ax.INVALID_VALUES_ERR, 'invalid argument!');
		}
		return this.execSync('echo', [ message||'' ]);
	}

	function echoAsync(callback, errback, message) {
		if(!message) {
			throw ax.error(ax.INVALID_VALUES_ERR, 'invalid argument!');
		}
		return this.execAsync('echo', callback, errback, [ message||'' ]);
	}

	function getDeviceToken(callback, errback){
 		return this.execAsync('getDeviceToken', callback, errback);
 	}

	window.myplugin = ax.plugin('net.saltfactory.hybirdtutorial.pushplugin', {
		'echoSync': echoSync,
		'echoAsync': echoAsync,
		'getDeviceToken' : getDeviceToken
	});
})();
```

그리고 index.html이 로드될 때 stub를 이용해서 네이티브 코드에서 획득한 registration_id를 이 stub 메소드를 이용해서 가져오게 한다.

```html
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="/appspresso/appspresso.js"></script>
<script>
	function errback(err) {
		alert(err.code + " : " + err.message);
	}
	//
	myplugin.getDeviceToken(function(result) {
		ax.log(result);

	}, errback);

	//activate ax.log(), comment out when you release app
	ax.runMode = ax.MODE_DEBUG;
	ax.log("Hello World");
</script>
</head>
<body>
	<h1 id="title">Hello</h1>
	<h3>net.saltfactory.tutorial</h3>
</body>
</html>
```

이제 Appspresso를 디바이스로 빌드하여 설치하면 Appspresso 콘솔과 ADE (Appspresso Debugging Extension)에서 javascript에서 사용되는 appspresso의 ax.log를 이용하여 확인할 수 있게 된다.

![](http://asset.hibrainapps.net/saltfactory/images/907b5ee2-1e96-4ada-92d4-8c90062a8a2f)

![](http://asset.hibrainapps.net/saltfactory/images/811e4c0d-9bd2-4bb1-a259-5f2bdffe3b63)

이제 우리는 regisration_id를 획득하는 방법에 대해서 모두 테스트를 완료하였다. 마지막으로 우리는 서버에서 C2DM으로 메세지를 registration_id를 이용해서 디바이스로 푸시를 보내는 것을 테스트할 것이다. 테스트를 위해서 ruby gem을 이용해서 c2dm을 사용하였지만 다른 c2dm 라이브러리를 이용해서 java나 python으로 전송해도 무관하다.

```text
gem install c2dm
```

푸시 전송 코드는 이전에 iOS에서 사용하던 ruby 파일에 c2dm을 추가해서 사용했다.

```ruby
# encoding: UTF-8
require 'rubygems'
require 'apns'
require 'c2dm'

# APNS.host = 'gateway.sandbox.push.apple.com'
# APNS.pem  = 'development_cert.pem'
# APNS.port = 2195
#
# device_token = '488fca..51ea' # 아이폰 디바이스 토큰
# APNS.send_notification(device_token, :alert => 'Appspresso Push Test', :badge => 1, :sound => 'default')

C2DM.authenticate!("안드로이드 개발자 메일", "안드로이드 개발자 메일 비밀번호", "SaltfactoryTutorial-1.0")
c2dm = C2DM.new

notification = {
  :registration_id => "APA91b...._qYmU", # 안드로이드 registration_id
  :data => {
    :payload => "Hello, Appspresso Notification"
  },
  :collapse_key => "SFM12" #optional
}

c2dm.send_notification(notification)
```

이렇게 서버에서 전송하게 되면 Android 네이티브 플러그인 코드에서 추가한 C2DMReciver에서 푸시를 받게 되는데 ddms를 확인해서 푸시자 제대로 전송되었는지 확인해보자.

![](http://asset.hibrainapps.net/saltfactory/images/0ff1c34e-2c41-49a9-add9-750dccb35a49)

서버에서 registration_id를 가지고 C2DM을 이용해서 보낸 푸시가 디바이스에 정상적으로 도착한 것을 확인할 수 있다. 그리고 우리는 예제에서 푸시가 전송되면 Toast를 나타나게 코드를 추가했기 때문에 디바이스 화면에서 Toast가 나타나는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/a9d28e23-f445-4e2b-be3b-7e39201764db)

## 결론

Appspresso에서 안드로이드 C2DM을 이용해서 푸시를 적용하는 방법에 대해서 포스팅을 했었다. iOS와 마찬가지로 개발자로 Google에 푸시 서비스를 하기위해서 C2DM 양식을 작성하는 방법은 생략했다.

Appsrpesso에서는 네이티븡 앱과 동일하게 푸시 서비스를 지원한다. iOS 푸시 적용 방법과 Android 푸시 적용방법에 대해서 2가지 포스팅을 걸쳐 설명했지만 잘 살펴보면 네이티브 코드만 다를 뿐 index.html에서 axplugin.js에서 디바이스 코드를 가져오기 위한 stub는 동일하게 사용한다는 것을 확인할 수 있을 것이다. 푸시는 디바이스의 독립적인 방법으로 구현할 수 밖에 없기 때문에 PDK (Plugin Development Kit)으로 Appspresso 플러그인 프로젝트로 추가해서 사용해야한다. 이 때 방법은 AxPlugin을 따르는 interface(안드로이드)와 protocol(아이폰) 처럼 ActivityListener(안드로이드)와 UIApplication(아이폰)을 추가하여 구현한다. 네이티브 코드에서 획득한 디바이스 토큰은 인터페이스와 axplugin.js 에 등록된 stub 메소드를 이용해서 가져올 수 있다.

이제 앱스프레소를 이용해서 푸시 기능을 모두 구현할 수 있게 되었다. 디바이스의 센서를 제외하고 일반적인 앱 서비스를 개발하는데 모두 10가지 Appspresso에 대한 포스팅을 연재하였다. 아직 UI framework에 관한 이야기는 추가하지 않았지만 부록으로 UI framework에 대한 포스팅을 추가할 예정이다. 이 글을 포스팅하는 개발 연구원인 본인은 조그만 부설 연구소에서 혼자 아이폰과 안드로이드 폰 앱을 개발하고 있는데, 개발 비용과 유지보수 비용이 혼자서는 감당하기 힘들어서 하이브리드 앱에 대한 도입을 검토하는 과정에서 앱스프레소와 PhoneGap을 비교하기 하기 위한 글로 하이브리드 앱 개발에 관한 내용을 연재 중이다. 추가적인 질문은  아래의 트위터나 페이스북(댓글, wall)로 질문하면 연구하면서 겪게되는 문제 해결 방법을 같이 나눌 수 있을 것이라 생각된다. 본 연구원은 처음부터 앱 개발자가 아니고 데이터베이스 연구실에서 서버와 데이터베이스를 연구하는 연구원에서 출발 했기 때문에 소프트웨어 개발자보다 코드가 잘 못되거나 성능에 대해서 좋지 못한 코드를 예제로 만들 가능성이 높다. 이 점에 대해서는 양해 바라며, 본 연구원이 연구하면서 알게된 방법을 같이 공유하고자 포스팅을 작성한다는 것을 알아주길 바란다.

