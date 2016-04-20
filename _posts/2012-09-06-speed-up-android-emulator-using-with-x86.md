---
layout: post
title: 느린 안드로이드 에뮬레이터 대신 Android x86을 이용하여 개발환경 구축하기
category: android
tags: [android, emulator, x86]
comments: true
redirect_from: /186/
disqus_identifier : http://blog.saltfactory.net/186
---

## 서론

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/36faf851-6551-4112-806f-662b76114a7a)

iOS를 개발하면서 Android를 개발할 때 가장 불편한 것이 바로 느린 emulator 문제이다. iOS의 simulator는 실제 디바이스 만큼은 아니지만 빌드하고 개발하는데 큰 불편함 없이 사용할 수 있기 때문에 개발 속도에 큰 영향을 미치지 않지만, android emulator는 참... 난감할 정도로 반응속도가 늦기 때문에 개발할 때 디바이스에 연결해서 개발하고 emulator는 거의 사용하지 않는다. 한동안 iOS만 개발하다가 안드로이드 개발을 시작하려고하니 당장 emulator 때문에 답답한데 android x86를 VM에 설치할 수 있다는 자료들을 읽게 되었다. android x86는 Mac OS X x86과 비슷하게 x86 시스템에 Android 운영체제를 포팅하는 일종의 개발자 운동이다. OSX x86는 해킨이라는 말을 사용하지만 android x86는 오픈소스 기반으로 개발자들이 다양한 디바이스에 포팅하는 운동이 벌어지고 있다. 이렇게 VM에 설치된 android를 개발용으로 사용할 수 있다는 자료들을 접하게 되었다. 그래서 이번 포스팅은 Android를 VM에 설치해서 안드로이드 앱을 개발하는 방법에 대해서 소개하려고 한다.

<!--more-->

이번 포스팅에서는 3가지 툴이 필요하다.

1. eclipse (안드로이드 앱을 개발하기 위해서 필요)
2. VirtualBox ( android-x86 이미지를 VM에 설치하기 위해서 필요, Oracle의 VM인 VirtualBox는 무료이다)
3. Android x86 (VMLite에서 공개한 Android v4 vm 이미지)

eclipse의 설치 및 사용 방법은 이미 대부분의 블로그를 통해서 익혔다고 생각하고 VirtualBox 설치부터 소개한다.

## VirtualBox 설치

VirtualBox 는 Mac 뿐만 아니라 PC(Windows), Linux 설치 파일을 제공하고 있기 때문에 VirtualBox VM을 가지고 Mac/PC/Linux 에서 모두 개발이 가능하다. 흔히 알고 있는 VMWare, Parallels 보다 기능이나 성능은 좋지 못하지만 개발을 하거나 연구를 하는데 사용하는데는 전혀 제한이 없는 무료 VM이다.

http://virtualbox.org 에서 Downloads 링크를 클릭하고 해당되는 바이너리를 다운 받는다. 맥 사용자는 OS X hosts x86/amd 를 선택해서 다운받으면 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/47b04aa8-2781-451f-b261-7c983a47a94e)

dmg 이미지를 다운 받게 되면 dmg 파일을 더블클릭하고 열어서 VirtualBox.mpkg 파일을 더블클릭해서 VirtualBox를 설치한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c99672ac-6ac9-4e19-a193-82e513776ea6)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6f46a4fb-8ff6-4447-94c9-b746ead65993)

## Android v4 vm 이미지 설치

http://www.vmlite.com/index.php?option=com_content&view=article&id=68:android&catid=17:vmlitenewsrotator 에서 Android V4 Ice Cream Sandwich (4.0.4 ICS) 이미지를 다운 받아서 압축을 해지한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/44ba087f-cb9a-4fa5-b14a-d9e9320eae54)

그리고 VMLite-Android-v4.0.4.vbox 파일을 더블 클리해서 VM 파일을 실행시킨다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b2896b89-deb2-4092-9570-1bdcfe8e07c9)

VirtualBox가 열리면서 Android-v4.0.4 이미지가 추가되는 것을 확인할 수 있다. VirtualBox의 start 버튼을 눌러 실행시키면 다음과 같은 에러가 발생한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1a210f75-358e-4187-a311-2a1c8d66fd1e)

이것은 VirtualBox에 USB 2.0의 패키지가 없기 때문에 Oracle VM VirtuablBox Extension Pack을 설치하라는 경고이다. VirtualBox 사이트에 가서 Downloads 링크를 클릭해서 VirtualBox Oracle VM Extension Pack을 다운 받는다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/88e1aed8-c2ee-4588-a8e3-84e391b5e0a6)

다운받은 Pack을 더블클릭해서 설치한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/98defd3c-5e71-412b-9533-2b26b9d19b11)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c3b9040a-72fa-47ff-af9b-fa0785ca867f)

Pack이 설치가 완료되면 다시 실행한다. 이제 정상적으로 Android VM 이미지가 VirutalBox에서 실행이되면서 Android x86 운영체제가 VM에서 동작하게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7495b5fc-383e-413e-b302-4cc73aff33e2)

이제 Android VM을 개발 디바이스로 사용하기 위해서 Settings > Developer options > USB debugging을 활성화 한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/aec2e846-e505-45e0-b287-6dd844fbf802)

## 안드로이드 앱 설치, 디버깅하기

안드로이드 앱 설치를 위해서 안드로이드 프로젝트를 하나 만들어보자. 그리고 adb 로 VM에 연결한다.

```
${ANDROID_SDK}/platform-tools/adb connect localhost
```

Android 4.0.3 기반의 HelloWorld 프로젝트를 만들기로 한다. 그리고 디버깅을 위해서 Debug Configurations를 열어서 virtualbox_debug 라는 android debug configuration을 추가한다. (포스팅에서는 예제를 위해서 eclipse에서 빌드할 때 디바이스를 선택하도록했다.) 그러면 빌드할 하고 실행할 때 디바이스의 선택하는 부분에서 android-x86 VM을 선택할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/683990f4-7df2-4711-9d4f-7384d0600d5a)

그리고 빌드가 끝나면 VirtualBox에 설치된 Android-x86에 안드로이드 앱이 설치되는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1ec53eeb-8343-4bf2-b689-4f198c4500c5)

이제 안드로이드가 제공하는 느린 Android emulator가 아닌 VM에 설치된 안드로이드를 가지고 앱을 개발할 수 있게 되었다. VirtualBox는 Mac 뿐만 아니라 PC나 Linux에서도 설치가 가능하기 때문에 어떠한 운영체제에서도 android-x86 VM 이미지를 가지고 보다 쾌적한 환경에서 앱을 개발할 수 있을 것으로 예상이 된다.

## 참조

1.http://osxdaily.com/2012/02/23/android-4-ics-virtualbox/

