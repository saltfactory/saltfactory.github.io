---
layout: post
title: HAXM와 Atom x86 이미지로 안드로이드 에뮬레이터 속도 빠르게 하기
category: android
tags: [android, x86, atom, haxm]
comments: true
redirect_from: /187/
disqus_identifier : http://blog.saltfactory.net/187
---

## 서론

![](http://blog.hibrainapps.net/saltfactory/images/292fc306-95d5-41cc-a7a9-dc4ec1126e35)

안드로이드 앱을 개발하면 느린 안드로이드 에뮬레이터 때문에 답답함을 느끼는 개발자가 많을 것이다. 그렇다고 안드로이드 공기계를 구입해서 개발하는 여유가 없다면 안드로이드 개발에 대해서 크게 실망하고 있을지도 모르겠다. 그래서 학생이나 안드로이드 앱 개인 개발자들에게 도움이 되길 바라는 마음에 "안드로이드 앱 개발시 느린 에뮬레이터 대신 Android x86을 이용해서 개발환경 구축하기" 라는 글을 포스팅 했었다. 이 글의 내용은 안드로이드 에뮬레이터를 사용하는 것이 아니라 Virtual Machine 인 VirtualBox에 Android x86 이미지를 사용해서 가상머신으로 안드로이드 운영체제를 설치해서 느린 안드로이드 에뮬레이터 대신에 개발할 때 사용하는 방법이다. 이 포스팅이 작성되고 페이스북에서 몇가지 피드백을 받게 되었다. 박태웅 부사장님께서 Intel에서 배포하는 Atom x86 용  Android Image를 사용하는 방법을 링크로 가르쳐주셨다. 이 실험을 다하고 지나고 난 다음에 이제서야 부사장님의 링크가 무슨 의미인지 알게 되었지만,  이때까지만 해도 Atom x86 이미지를 사용한다고 하더라도 느린 에뮬레이터 문제 때문에 속도 문제는 여전할거라는 주장을 가지고 있었다. 그리고 박성서 대표님께서 안드로이드 에뮬레이터가 JVM의 문제가 아니라 QEMU 가상머신 때문이라는 것을  가르쳐주셨고, 안드로이드의 QEMU 가상머신을 HAXM을 이용해서 가속도를 낼 수 있다고 의견을 주셨다. 그래서 다음날 아침 연구소에 출근하자말자 HAXM에 대해서 조사하고 실험에 들어갔다.

<!--more-->

## HAXM(Hardware Accelerated Execution Manager)

HAXM을 이용해서 안드로이드 앱을 개발할 때의 이점은 다음 링크에서 동영상으로 이해하는데 도움을 받을 수 있다.
[The Benefits of Developing Android Apps with the Intel® Hardware Accelerated Execution Manager](http://software.intel.com/en-us/video/the-benefits-of-developing-android-apps-with-the-intel-hardware-accelerated-execution-manager?&CCID=20214700204366378&QTR=ZZf201208300721490Za20214700Zg255Zw0Zm0Zc204366378Zs8986ZZ&CLK=173120906181523222&WT.qs_dlk=UElJ1QrIZ2MAAAGsXmcAAAAn&&exp=y)


인텔 하드웨어 가속 실행 관리자 (인텔 ® HAXM)는 호스트 컴퓨터에서 Android 앱 에뮬레이션 속도를 인텔 가상화 기술 (인텔 ® VT)을 사용하는 하드웨어 지원 가상화 엔진이다. 기존의 CPU 가상화만 사용해서 QEMU 가상 머신에 동작하는 안드로이드 에뮬레이터에 HAXM driver가 지원이되어 하드웨어 가속도 가상화를 지원하게 되는 것인데 HAXM을 사용할 때와 사용하지 않을 때의 속도 차이는 위 동영상 뿐만 아니라 아래 자료에서 활인할 수 있다.

HAXM을 사용할 때와 사용하지 않았을때 부팅 속도를 비교하는 것이다. 안드로이드 에뮬레이터는 기본적으로 최초 부팅이 이후 부팅보다 조금 더 오래 걸린다. 빨간색으로 된 부분이 XHAM을 사용했을때 인데 부팅 시간차이가 많이 나는 것을 확인할 수 있다.


![](http://blog.hibrainapps.net/saltfactory/images/3b630654-d235-4322-b3a3-36b9ddd13ed3)
http://www.developer.com/ws/android/development-tools/haxm-speeds-up-the-android-emulator.html

## HAXM 설치

이제 HAXM을 설치해보도록 하자. 다음 링크에서 자신의 운영체제에 사용할 수 있는 HAXM 을 다운받아서 설치한다.

http://software.intel.com/en-us/articles/intel-hardware-accelerated-execution-manager/

![](http://blog.hibrainapps.net/saltfactory/images/b99ed808-2c26-4a81-ba9a-586c73974069)

![](http://blog.hibrainapps.net/saltfactory/images/abea89fe-9aed-4187-84e1-b99191576088)

다른 가상화 머신을 설치할 때와 마찬가지로 HAXM 도 메모리 사용에 대한 설정이 있다.

![](http://blog.hibrainapps.net/saltfactory/images/d4e79ddc-6fdf-4cc5-9b9d-335996632e52)

설치가 되었으면 터미널을 열어서 다음과 같이 haxm 로드 되어 있는지 확인한다.

```
kextstat | grep intel
```

![](http://blog.hibrainapps.net/saltfactory/images/e6f4245f-1945-42d0-bb7c-536de0bb1f6f)

이렇게 com.intel.kext.intelhaxm이 로드된 것을 확인할 수 있다.
만약 HAXM을 사용하고 싶지 않을 경우에는 kextunload를 다시 사용할 때는 kextload 명령어를 사용한다.

```
sudo kextunload -b com.intel.kext.intelhaxm
```

```
sudo kextload -b com.intel.kext.intelhaxm
```

이렇게 HAXM을 설치했으니 이제 Android VD(Virtual Devices)을 생성해서 X86을 사용하는 VD을 추가한다.
Android x86을 사용하기 위해서는 반드시 Intel x86 Atom System Image가 있어야한다.

![](http://blog.hibrainapps.net/saltfactory/images/64a55394-83e8-4b7c-b1dc-6d811ee7f469)

그리고 Android VM을 만든다. 이때 Target을 4.0.3으로하고 CPU 를 Intel Atom x86을 선택한다. 마지막으로 Hardware 옵션 사항에 GPU emulation을 추가한다.

![](http://blog.hibrainapps.net/saltfactory/images/570ff63c-bcd4-40bf-b115-24ab6685daa9)

이젠 XAHM 과 Android VD 준비를 모두 마쳤으니 안드로이드 개발 프로젝트에서 debugging을 새로 추가한 X86 안드로이드 Virtual Device를 선택한다.


![](http://blog.hibrainapps.net/saltfactory/images/90b1787f-3173-4d45-ac12-0de5eb1e1cca)

프로젝트를 빌드해서 x86 VD에 실행해보자. 안드로이드 에뮬레이터가 실행되면서 HAX 메세지가 출력되면서 에뮬레이터가 빠르게 부팅되는 것을 느낄 수 있을 것이다.


![](http://blog.hibrainapps.net/saltfactory/images/52b26773-d3ba-45f3-ac9b-daf90a0b71b0)

HAXM과 android x86 gpu를 설정하지 않은 새로운 Android VD를 추가해서 속도를 비교해보기 바란다. 속도차이를 느낄 수 있게 될 것이다.

## 결론

안드로이드 앱 개발할 때 에뮬레이터 속도의 문제를 극복하는 방법은 VM을 이용하는 방법과 HAXM을 이용하는 방법이 있다. 아직 많은 클래스르 테스를 하지 못했지만 VM을 이용해서 구동하고 빌드하는 것이 체감 속도는 빠르는것 같았다. 이번 안드로이드 에뮬레이터 속도를 향상시키는 방법을 연구하기 위해서 도움을 주신 KTH의 박태웅 부사장님과 Socail & Mobile의 박성서 대표님께 다시한번 감사하다는 말씀을 전하고 싶습니다. 연구하고 경험한 자료를 공개하면 더 많은 자료를 얻을 수 있는 것이라는것을 이번 실험으로 알게된 것 같다. 난 처음부터 앱 개발을 하는 개발자가 아니라 데이터베이스 연구실에서 데이터베이스를 연구하는 연구원이기 때문에 모바일 서비스를 개발할 때 처음 알게되는 부분들이 많은 것 같다. 안드로이드 에뮬레이터가 느린 이유가 java의 JVM 문제 인줄만 알았는데 박성서 대표님께서 QEMU 가상머신이라는 것도 바로 잡아주시고, XAHM에 대한 언급도 해주셔서 이번 실험을 할 수 있었다. 그리고 박태웅 부사장님의 Intel Android atom x86 링크를 참고할 수 있어서 XAHM과 android x86 이미지의 조합을 테스트할 수 있었다. 실험 결과는 정확한 수치로 표현할 수 없으나 HAXM을 사용하지 않을 때보다 HAXM을 사용할 때 부팅과 반응속도가 크게 향상되는 것을 경험할 수 있었다. 그리고 android x86 으로 VM을 설치해서 사용할 때도 반응속도가 빠르다는 것을 경험할 수 있었다. 개발자나 연구원들이 두가지 방법중에 선택해서 개발한다면 기존의 느린 안드로이드 에뮬레이터에서 느끼는 답답함을 해소할 수 있을 것으로 예상된다.

## 참조

1. http://www.developer.com/ws/android/development-tools/haxm-speeds-up-the-android-emulator.html
2. http://software.intel.com/en-us/articles/installation-instructions-for-intel-hardware-accelerated-execution-manager-macosx
3. http://developer.android.com/tools/devices/emulator.html
