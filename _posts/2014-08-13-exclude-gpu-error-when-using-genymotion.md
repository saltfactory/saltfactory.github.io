---
layout: post
title : Android 앱 개발할 때 필요없는 로그 보이지 않게 하기
category : android
tags : [android, genymotion]
comments : true
redirect_from : /257/
disqus_identifier : http://blog.saltfactory.net/257
---

## 서론

Android를 개발할 때 IDE에서는 Android 디바이스의 모든 로그가 출력이 된다. filter를 어떻게 적용하는가에 따라서 현개 개발하고 있는 디바이스의 로그를 정확하고 간결하게 볼 수 있는데 이 포스트에서 Android를 개발하기 위해 genymotion을 사용할 때 필요없는 로그를 보이지 않게 하는 방법에 대해 소개한다.

<!--more-->

## LogCat

Android [LogCat](http://developer.android.com/tools/help/logcat.html)은 안드로이드 앱을 개발할 때 system output으로 출력되는 로그 메카니즘이다. LogCat을 잘 다루지 않게 되면 디바이스에 출력되는 여러가지 로깅을 개발 할 때 함께 봐야하는 불편함이 생긴다. 그래서 안드로이드 앱을 개발할 때 다양한 Logging 방법을 문서로 제공하고 있다. (http://developer.android.com/tools/debugging/debugging-log.html)

## Log 객체

안드로이드 앱을 개발할 때 가장 많이 사용하는 Logging 클래스는 [Log](http://developer.android.com/tools/debugging/debugging-log.html#logClass) 이다. Log 클래스는 LogCat에 메세지를 출력하는 android의 utility 클래스이고 다음과 같은 메소드를 사용할 수 있다.

- **v**(String, String) : verbose
- **d**(String, String) : debug
- **i**(String, String) : information
- **w**(String, String) : wranning
- **e**(String, STring) : error

예를 들면 다음과 같이 사용할 수 있다.

```
Log.i("MyActivity", "MyClass.getView() — get item number " + position);
```

위와 같이 Log 객체를 사용하면 다음과 같이 LogCat에 출력이 된다.

```
I/MyActivity( 1557): MyClass.getView() — get item number 1
```

## Log Foramt

LogCat은 다양한 출력 포멧을 지원한다.

- **brief** : priority/tag 그리고 PID(프로세스 ID)를 출력한다.(default)
- **process** : PID만 출력
- **tag** : priority/tag만 출력
- **raw** : 다른 metadata field 없이 raw log message만 출력
- **time** : date, invocation time, PID 출력
- **threadtime** : date, invocation time, priority, tag, PID, TID(thread ID)를 출력
- **long** : 모든 metadata field를 blank로 분리해서 출력

사용방법은 다음과 같다.

```
[adb] logcat [-v <format>]
```

## LogCat filter 설정

LogCat은 디바이스의 전체 시스템 출력을 보여주기 때문에 우리는 LogCat이 지원하고 있는 **filter**를 잘 사용해야 한다. 수 많은 로깅중에 warnning 메세지를 filter하여 보고 싶을 경우는 다음과 같이 한다.

```
adb logcat *:W
```
filter로 사용할 수 있는 priority 옵션은 다음과 같다.

- **V** : verbose (lowest priority)
- **D** : debug
- **I** : info
- **W** : warnning
- **E** : error
- **F** : fetal
- **S** : silent (highest priority, on which nothing is ever printed)

## 정규표현식 사용

LogCat의 filter는 옵션으로 정규표현식을 사용해서 보고 싶은 내용만 걸러서 볼 수도 있다. 우리가 프로젝트에서 [genymotion](http://www.genymotion.com/)을 도입했다. genymotion은 그래픽 가속기를 사용해서 기존의 Android emulator의 느린 속도를 보완해서 빠르게 디버깅을 할 수 있는 방법을 제공해준다. genymotion에 대해서는 다음 포스팅에서 자세하게 소개하겠다.

genymotion을 사용할 때 LogCat에서는 GPU에 대한 에러가 LogCat에 출력이 된다.

![eglCodecCommon error](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/cbf6dfa8-83c7-4079-b465-d3c33e1bb8b9)

이렇게 우리가 프로그램에 포함되지 않은 로깅이 디바이스의 문제로 수없이 많이 발생하기 때문에 정작 우리가 개발하면서 보고 싶은 로그를 스크롤을 하면서 찾아서 확인해야하는 불편함이 있다. 그래서 우리는 불필요한 genymotion의 GPU에 관련된 에러를 모두 제거하고 순수하게 우리가 남기고 싶은 로그만 보고 싶었다.

그래서 우리는 다음과 같이 LogCat에 정규 표현식 filter를 사용했다. 우리는 IntelliJ(Android Studio)를 이용해서 Android를 개발하고 있기 때문에 IntelliJ에서 제공하는 인터페이스로 LogCat의 filter를 적용했다.

genymotion을 사용하여 앱을 실행시키면 GPU에 관련된 에러가 포함되는데 TAG에는 **eglCodecCommon**, **OpenGLRender** 그리고 **EGL_genymotion**가 포함된 에러가 출력이 되고 있다. 그리고 message에 **GL_INVALID_OPERATION** 에러가 포함이 되어 있기 때문에 다음과 같이 filter를 적용할 수 있다.

![exclude filter](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/68c0e95f-0f9c-418d-bf13-2cb0e51c0b62)

이렇게 LogCat에 정규 표현식을 적용하면 노이즈로 포함되어있는 필요없는 로그를 모두 제거하고 우리에게 필요한 정보만 LogCat으로 출력되는 것을 확인 할 수 있다.

![remove exclude](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a599f405-cd07-4aac-9d34-bb3276bfb371)

## 결론

LogCat은 Android 앱을 개발할 때 아주 중요한 자료가 된다. 그런데 LogCat은 system logging 메카니즘으로 우리가 출력하고 싶은 메세지 외에도 우리가 필요하지 않는 로그도 함께 출력이 된다. 이럴 때 우리는 LogCat의 filter 기능을 잘 사용하면 우리가 필요한 정보만 출력시켜 개발할 때 편리하게 진행할 수 있다. LogCat의 priority와 tag만을 사용해서 출력하는 것 이외에도 **정규표현식**을 이용해서 필요없는 메세지를 보이지 않게 하거나 필요한 메세지만 출력할 수도 있다.

## 참고

1. http://developer.android.com/tools/debugging/debugging-log.html
2. http://developer.android.com/tools/help/logcat.html


