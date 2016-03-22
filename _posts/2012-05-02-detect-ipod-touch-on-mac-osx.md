---
layout: post
title : 구형 iPod touch 디바이스 Xcode 인식 문제 해결
category : xcode
tags : [ipod, xcode, mac]
comments : true
redirect_from : /131/
disqus_identifier : http://blog.saltfactory.net/131
---

## 서론
맥 라이언 (Mac OS X) 편의상 Mac으로 말하기로한다. Mac 에서 Xcode 4.3 를 설치하고 난 뒤에 구형 iPod Touch 2nd 를 연결했는데 다음과 같은 에러가 발생하였다. armv6 단말기로 iPod touch는 iOS4.2 디바이스를 디버깅할 때 사용하고 있는데 Appspresso에서 armv6 기반의 구형 단말기에 정상적으로 설치되어 동작하는지를 테스트하려고 Mac 에 연결해서 Organizer를 열어보니 이렇게 DTDeviceKit 을 찾을 수 없다는 에러를 발생하면서 디바이스 인식이 되지 않는 것이다.

<!--more-->

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/707fa238-64ac-453d-8d5e-bbfdec7674b5)

보통 이렇게 하위 기종의 디바이스 인식 문제는 Xcode 4.3 에서 하위 기종의 디버깅 라이브러리를 옵션으로 설치할 수 있는데 설치를 제대로 하지 않았을 때 발생하는 문제로 알고 있다. 하지만 Xcode를 열어서 Components를 살펴보니 iOS4.0-4.1, iOS3.0-3.2 device debugging support 라이브러리가 설치가 되어 있는 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/abaa3e11-c7cb-4188-b334-7684d104a8de)

요즘 대부분의 개발자는 iPhone4 이상으로 iOS 5.0 이상에서 개발을 하고 있겠지만, 연구소에서 타겟으로 만드는 앱은 4.0 까지 지원하기로 되어 있기 때문에 오래된 디바이스와 구형 iOS 버전을 가지고 테스트를 계속 진행하는데 이렇게 구형 디바이스가 인식되지 않는 원인을 찾기 시작했다. 다행이 stackoverflow에 같은 고민을 하는 thread를 볼 수 있었다.  "Xcode 4.2: Error 0xC002 when trying to use a jailbroken iPhone 3G for development" (http://stackoverflow.com/questions/7922308/xcode-4-2-error-0xc002-when-trying-to-use-a-jailbroken-iphone-3g-for-developmen) 이라는 thread에서 의견들이 나오고 있는데 질문이 Xcode 4.2인 것을 보니  최근 Xcode가 아니더라고 비슷한 문제가 발생하는 것으로 보인다. jailbroken iPhone에 대한 질문인듯한데 아직까지 내가 테스트하는 디바이스들은 모두 jailbroken 된 것이 아니라 original 버전 디바이스들이다.

원인은 iPod touch를 USB로 연결하여 oranizer가 인식하면 새로 설치한 Xcode의 iOS DeviceSupport 안에 iOS 4.2.1에 맞는 파일들이 복사되어 설치가 되는데 이때 dyld cache을 찾지 못해서 발생하는 문제이다. 이러한 경우의 해결책은 다음과 같이 해결할 수 있다.

1. 디바이스를 다시 Mac에서 분리한다.
2.  cache 폴더로 이동한다.

```
cd ~/Library/Developer/Xcode/iOS\ DeviceSupport/4.2.1\ \(8C148\)/Symbols/System/Library/Caches/com.apple.dyld/
```
3. 다음 파일들을 생성한다.

```
touch .copied_dyld_shared_cache_armv6 && touch .processed_dyld_shared_cache_armv6 && touch dyld_shared_cache_armv6
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/c38fe452-7994-45ff-a431-bab679efb91f)

4. 디바이스를 연결하고 organizer를 확인한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/90aa4b2b-91fd-4483-9b9e-b2f400d65df6)

이제부터는 디바이스가 정상적으로 인식되기 때문에 구형 iPod Touch 2nd (iOS 4.2.1)를 가지고 디버깅을 할 수 있게 되었다.

## 참고
1. http://stackoverflow.com/questions/7922308/xcode-4-2-error-0xc002-when-trying-to-use-a-jailbroken-iphone-3g-for-developmen

