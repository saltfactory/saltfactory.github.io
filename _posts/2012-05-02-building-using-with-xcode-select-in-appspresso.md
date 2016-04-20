---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 7.xcode-select를 사용하여 빌드하기
category: appspresso
tags:  [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, xcode, xcode-select]
comments: true
redirect_from: /132/
disqus_identifier : http://blog.saltfactory.net/132
---

## 서론

Appspresso를 사용해서 [ Appspresso를 사용하여 하이브리드앱 개발하기 - 6.디바이스 빌드하기](http://blog.saltfactory.net/130) 글에서보면 Appspresso에서 Android와 iOS 디바이스로 빌드하여 설치하는 것을 살펴보았다. 만약 Xcode4.2 이전 버전을 사요하던 개발자가 Mac OS X 10.6에서 10.7로 마이그레이션 (스노우 레오파드에서 라이언 마이그레이션) 후 Xcode 4.3을 사용하였다면 Xcode가 두가지 경로에 설치가 되어 있을 것이다. Xcode가 4.3부터는 /Applications/Xcode.app으로 맥 앱 형태로 배포하고, 이전에는 package installer로 /Developer에 설치가 되었기 때문이다. 우리는 그래서 [Appspresso를 사용하여 하이브리드앱 개발하기 - 1.iOS와 Android 앱 빌드](http://blog.saltfactory.net/125) 글에서 Appsspresso의 preferences를 열어서 iOS SDK를 /Applications/Xcode.app/Contents/Developer 로 잡아 주었던 것을 기억할 것이다.
이렇게 사용하면 Appspresso에서 iOS 시뮬레이터로 테스트하는데 문제가 생기지 않는다. 하지만 Mac의 운영체제에서 Xcode command가 인식하는 경로가 /Developer 이면 iOS 디바이스에 설치하기 위해서 Appspresso 내부에서 .ipa 파일을 만들 때 문제가 발생한다.

<!--more-->

다음 캡처를 살펴보자. 정상적으로 build가 성공되었으면 디바이스에 설치하기 전에 project 디렉토리 밑에 output 디렉토리 안에 설치하기 실제 앱 파일이 존재한다. android 디바이스에 설치하기 위해서 .apk  파일이 만들어지고 iOS 디바이스에 설치하기 위해서 .ipa 파일이 만들어 진다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/d4d6bbf2-38d9-4fb6-9beb-5b5a29efccc4)

하지만 Mac 운영 체제에서 사용하는 command line의 경로가 /Developer를 가르키고 있으면 .ipa 파일을 생성하지 못하는 문제가 발생한다.
iOS 디바이스에 설치하기 위해서 빌드를 실행하면 다음과 같은 에러가 발생한다.


```text
-run-iphoneos:
     [echo] run on iOS Device
     [exec] sh: /Developer/usr/bin/xcodebuild: No such file or directory
     [exec] /Developer/usr/bin/xcodebuild fails with 32512 - Unknown error: 32512
     [exec] Result: 69
     [echo] open itunes
     [exec] The file /Volumes/Data/Projects/Workspaces/Saltfactory/Repository/saltfactory-appspresso-tutorial/workspace/SaltfatoryHybridTutorial/output/net.saltfactory.hybridtutorial-1.0.0.app.ipa does not exist.
```

```text
BUILD FAILED
/Applications/Appspresso1.1/plugins/com.appspresso.cli_1.0.0.201204272328/axhome/build-app.xml:302: The following error occurred while executing this line:
/Applications/Appspresso1.1/plugins/com.appspresso.cli_1.0.0.201204272328/axhome/platforms/ios/build-app.xml:256: exec returned: 1

Total time: 1 second
/Applications/Appspresso1.1/plugins/com.appspresso.cli_1.0.0.201204272328/axhome/build-app.xml:302: The following error occurred while executing this line:
/Applications/Appspresso1.1/plugins/com.appspresso.cli_1.0.0.201204272328/axhome/platforms/ios/build-app.xml:256: exec returned: 1
Widget Launch(run) >>: SaltfatoryHybridTutorial project launch failed.
```

이 문제는 Appspresso가 command line 명령어를 사용해서 .ipa 파일을 만들어야하는데 이를 만들지 못해서 발생하는 문제이다. 이럴 경우에는 터미널을 열고 다음을 확인한다.

## xcode-select

우리는 xcode-select를 이용할 것이다. xcode-select는 python-select와 비슷하게 여러가지 버전의 Xcode가 설치되어 있을 경우 특정 버전의 Xcode를 Activity하게 환경변수를 변경시켜 주는 명령어이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2a300b55-60a1-4ef3-91c3-896a7effcb6b)

현재 Xcode가 설정된 경로를 확인하기 위해서 -print-path를 사용한다.

```
xcode-selet -print-path
```

현재 Xcode의 설정된 경로가 /Developer 라면 잘못된 경로를 가르키고 있으므로 -switch 명령어를 이용해서 Xcode 경로를 변경해준다.

```
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
```

다시 -print-path로 경로를 확인하면 Xcode의 경로가 변경되어 있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ddad9577-dd16-44fa-8427-8ca2097941b3)

## 결론

이제 다시 Appspresso에 가서 디바이스를 target으로하고 빌드 실행하면  .ipa 파일이 이상없이 만들어지고, iTunes가 열리면서 iOS 디바이스와 동기화를 시작하여 디바이스 쪽으로 .ipa 파일을 동기화 설치하여 테스트할 수 있게 된다.

## 참고

1. http://appspresso.com/ko/archives/3934


