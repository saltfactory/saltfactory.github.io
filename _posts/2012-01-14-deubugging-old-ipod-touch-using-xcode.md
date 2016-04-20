---
layout: post
title: 최신 Xcode에서 구형 iPod Touch를 이용하여 디바이스 디버깅하기
category: ios
tags: [ios, xcode, ipod, ipod touch, debugging]
comments: true
redirect_from: /93/
disqus_identifier : http://blog.saltfactory.net/93
---

## 서론

![{max-width:180px}](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/871d09ef-3ab8-4ccf-926e-0f97eb29f5fa)

iOS의 개발자에게 Xcode는 마법과 같은 개발 도구가 아닌가 생각이 든다. 지금 아이폰과 안드로이드를 동시에 개발하는데 안드로이드를 개발할 때 운영체제나 SDK가 아니라 Xcode와 같은 툴이 안드로이드를 지원해주지 않는다는 것이 가장 많이 아쉬웠다. Xcode는 빠르고 편리하고 아름답기까지 하기 때문에 개발자에게 개발을 즐겁게 해주는 멋진 개발툴이라는 것은 모두다 아는 사실이다. 이런 Xcode를 잠시 실망할뻔한 적이다. Mac OS X snow leopard에서 Mac OS X Lion으로 업데이트하고 App Store에서 배포하는 Xcode 4.2를 설치하고 나서 구형 iPod touch로 디바이스 디버깅을 할 수 없게 된 것이다. 애플은 새로운 상품이 나와도 이전의 상품을 무시하거나 구형으로 만들지 않는 철학이 있다. 지금까지도 iPhone 3gs의 업데이트를 계속 진행하고 있는것도 그 전략중에 하나이다. 하지만 iPod touch 2세대는 물리적한계 때문에 iOS 4.2에서 업데이트가 멈추어진 상태이다. 문제는 이 기계가 더이상 개발용 디바이스로 사용할수 없다는 것이 충격적인 문제였다. 왜냐하면 비록 구형 디바이스지만 iOS 4.2라는 iOS 4.x 버전대의 운영체제가 동작하고 있고 아직 iOS의 모든 운영체제 통계치를 보면 iOS 4.x 를 사용하는 사용자가 많기 때문이다. 그래서 iOS 개발을 할때 최소 target 버전을 항상 iOS 4.0버전을 타겟으로 두고 개발을 해왔다. 구형 iPod touch를 가지고 이러한 문제를 고민하는 사람들이 없을까 자료를 찾아보는 가운데 http://useyourloaf.com/blog/2012/1/10/xcode-42-building-for-ios-31x-and-older-devices.html 블로그에서 동일한 문제를 가지고 고민했고 해결한 글을 찾을 수 있었다. 하지만 이 포스팅대로 하니까 Xcode에서 디버깅을 할 수 있게 iPod touch를 인식하고 빌드할수 있게 되었으나 문제는 Build & Run을 하였을때 디바이쪽에 앱이 설치가 되지 않는 것이였다. Xcode에서 에러나 발생하지 않고 정상적으로 빌드되고 인스톨이 되었다고 나오는데 실제 디바이스에 앱은 설치가 되지 않고 디바이스의 console 로그를 살펴보면 **handle_connection: Could not receive USB message #6 from MDCrashReportTool.** 가 출력된다. 이 참조 블로그를 통해서 구형 iPod touch를 디바이스 디버깅을 사용하기 위해서 어떻게 했으면 이 문제를 어떻게 해결했는지를 포스팅하려고 한다.

<!--more-->

## iOS 프로젝트 생성

우선 테스트를 위해서 Xcode 4.2에서 iOS 프로젝트를 하나 만들자. TestApp이라는 이름으로 프로젝트를 만들었다. 우리는 최종 iPod touch 디바이스에 앱을 설치하여 디버깅할 것이기 때문에 provisioning profile이 필요하다. 본인에 맞는 프로비져닝 파일을 만들어서 Xcode에 추가하면 되겠다.

Mac OS X Lion을 설치하고 난 뒤에 Xcode 4.2를 앱 스토어에서 설치하면 iOS5.0 시뮬레이터가 기본적으로 설치가 되어 있다. Xcode4를 실행하고 scheme의 destination을 살펴보면 iOS 5.0을 디버깅하기 위한 iPad 5.0과 iPhone 5.0 Simulator 를 볼수 있다.  

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1336dac0-1d6e-4b86-9126-832bc54cb764)

## 하위 iOS 버전 Simulator 설치

처음 Xcode에는 iOS 5.0 Simulator만 설치가 되어 있기 때문에 iOS 4.3 Simulator는 command + , 를 눌러서 **Preferences**를 열어서 **Downloads** 중에 iOS 4.3 Simulatorㄹ르 설치하면 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ef9b6c36-2fe4-4203-a4e8-d00bd1fef621)

하지만 iOS 4.0 버전을 만들어서 배포하기 위해서 target 버전을 iOS 4.0으로 변경하여도 iOS 4.3을 디버깅할 수 있는 iPad 4.3과 iPhone 4.3 Simulator는 보이지만 그 이하의 iOS 버전을 테스트할 수 있는 Simulator가 보이지 않다는 사실에 당황하게 될 것이다. Xcode 4.2버전 부터는 iOS4.3 이전의 simulator를 삭제하고 더이상 지원하지 않는다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/e5668346-0bc4-469e-804e-d7b0e5f23c17)

뿐만아니라 iPod touch를 연결해도 Xcode에서는 디바이스를 인식하지 못하는 문제가 발생한다. organizer에서 iPod touch를 개발용 디바이스로 iTunes connect에 등록을하여도 organizer에서는 인식이되지만 Xcode의 scheme에서 destination을 살펴보면 iPod touch가 인식되지 않는 문제를 확인할 수 있다. 이유는 Xcode 4.2에서는 iOS 4.3 이전의 디바이스에 대해서 디버깅하는 툴이 옵션기능으로 다운받게 만들어 둔것이다. 즉, iOS 4.3 이전 버전의 디비아스는 Xcode 4.2에서 기본적인 설정에서는 디버깅을 할 수 없다는 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/c53ac585-fb66-43e3-80e2-a64f848dd3f4)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/629a47f9-ac18-46f9-97f8-8f9345040016)

그래서 iOS 4.3 이전 버전을 타겟으로 만들때는 디비이스에서 디버깅을 할 수 있게 옵션 기능으로 디바이스 디버깅 툴을 제공한다. **Preferences**에서 **Downloads** 중에서 **iOS 4.0-4.1 Device Debugging Support**와 **iOS 3.0-3.22 Device Debugging Support**를 각각 다운로드 받을 수 있다. 아마도 Xcode에서 여러 버전의 simulator를 제공하면 scheme를 선택해서 destination을 선택할때 너무 많은 Simulator 가 나타나니까 이전 버전은 사용 빈도도 적으니 디버깅은 디바이스에서만하고 최근 것만 simulator에서 디버깅할 수 있게한게 아닌가하는 생각이 든다. 우선 구형 iPod touch에도 앱을 설치해서 디버깅 할 수 있다는 것은 공식적으로 지원한다는 것이다. 이 디버깅 툴을 다운 받는다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9f576643-6497-4daf-b2f2-6523fba2b520)

## Provision Profile 생성

이제 우리는 iOS 4.3 이전 버전을 타겟으로 만들어서 디버깅할 때는 디바이스 디버깅을 해야한다는 것을 알았고 디버깅 툴도 다운받아서 준비를 했다. 디바이스 디버깅을 하기위해는서 애플개발자에 등록을해서 **iTunes Connect**에서 **provision profile**을 만들어서 Xcode에 추가를 해줘야 된다. 테스트 앱은 TestApp 이라는 이름으로 만들었고 앱의 identifier는 net.saltfactory.TestApp으로 만들었다. 이에 맞는 프로비져닝 프로파일을 만들어서 다운 받아서 Xcode에 추가를 해줬다. 이젠 디바이스 디버깅을 위한 준비를 모두 마쳤으니 Xcode에서 Build & Run을 실행시켜보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/43998a9e-de34-482f-b8d7-37cd4aff70e0)

Xcode에서 빌드과정과 인스톨과정은 모두 성공적으로 마쳤다. 하지만 이상한 점을 발견할 수 있는데 앱이 iPod touch에 설치가 되지 않는 다는 것이다. 처음에 이 때문 많이 당황했고 문제가 무엇 때문인지 몰라서 검색도 많이 했었다. 에러가 발생하지 않기 때문에 문제가 무엇인지 조차 알수가 없는 상황이였다. 그래서 organizer에서 실제 device console에서 생기 로그를 살펴보았다. 콘솔에서 생기는 에러메세지는 다음과 같은 에러가 계속적으로 반복한다는 것을 찾아볼 수 있다.

```
Sat Jan 14 12:49:50 unknown lockdownd[16] <Error>: 2ff68000 handle_connection: Could not receive USB message #6 from Xcode. Killing connection
Sat Jan 14 12:49:50 unknown com.apple.mobile.lockdown[16] <Notice>: Could not receive size of message
```

## ARM 설정

iPod touch 2세대와 요즘 최신형 아이폰은 **ARM** 아키텍처가 틀리게 제작이 되었다. 예전에는 **armv6**을 기본으로 사용하던 것을 이제는 **armv7**를 기본적으로 사용한다. 그래서 Xcode 4.2에서 artchtecture가 기본적으로 **$(ARCHS_STANDARD_32_BIT)**, 다시 말해서 armv7를 설정하고 개발할 수 있게 되어 있다. 생기는 문제점은 여기서 발생한다. 구형 iPod touch는 armv6 기반인데 프로그램은 armv7 기반으로 만든다고하였기 때문이다. 우리는 이제 이 문제를 해결할 것이다.

**target** 이미지를 선택하고 **build setting**을 선택한 후 architectures를 살펴보자. 기본적으로 **Standard (armv7)**가 설정되어 있다. **Architectures**를 클릭하고 Others를 선택한 후 **armv6**를 추가한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0e75ec63-5993-4c6f-b1ac-22c8b30385a0)

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b73ceff6-348c-486d-aa21-b0b7baea4aa9)

아마 인터넷의 대부분 문서는 이렇게까지 설명을 하고 마치는 글들이 대부분 많았던 것 같다. 하지만 디비깅을해도 문제는 해결되지 않고 Xcode에서는 여전히 에러가 발생하지 않는다.

## plist 파일 수정

앱에 관한 설정은은 `{앱이름}-info.plist`라는 파일에서 설정하게 된다. 우리는 TestApp이라는 이름으로 만들었으니 `Supporting Files`에 TestApp-info.plist라는 파일이 존재하게 되는데 이 파일을 살펴보자. 여기는 여러가지 앱에 관한 설정들이 포함되어 있다. 그중에서 이 앱이 요구하는 디바이스의 요구사항들을 정의하는 속성이 있는데 바로 [Required device capabilities](https://developer.apple.com/library/ios/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/DeviceCompatibilityMatrix/DeviceCompatibilityMatrix.html)라는 것이다. 보통 GPS, Network 등을 필요한 디바이스에서만 설치될 수 있게 만들기 위해서 여기에다 디바이스 요구사항들을 정의하는 곳이다. Xcode 4.2부터는 여기에 기본적은 디바이스 요구사항이 armv7이 정의되어 있는것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a414f669-1bca-423a-875d-3a13d3971407)

이 요구사항에서 **Items 0** 항목 **armv7**을 삭제하고 저장후 Build & Run을 실행시키면 구형 iPod touch에 앱이 설치되고 디버깅을 할 수 있게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0e051b8a-90d2-4fe2-93f6-e8a561905620)

## 결론

구형 iPod touch는 현재 iOS 4.2.1 버전이 설치되어 있고 더이상 높은 버전의 iOS는 업데이트를 할 수가 없다. 물리적으로 가능하지 않기 때문이다. 실제 "오라클 중심의 SQL 배움터라는" 오라클 SQL문을 공부하기 위한 책을 연구실에서 편찬한 것을 앱에서 사용할 수 있게 아이폰 용으로 만들어서 앱스토을 등록하고 가장 먼저 리뷰에 올라왔던 글이 iOS 3.2 에서도 돌아갈수 있게 해달라고 하는 것이였다. 아직 iOS 4.x과 iOS 3.x 디바이스를 사요하는 사람들이 있다는 것을 개발자들은 생각하고 지원 정책을 세워야한다. 만약 하위 버전을 무시하고 iOS 5.x 기반으로 개발하면 개발자가 좀더 편하고 풍부한 API로 개발하고 앱도 안정화하기 쉽지만 항상 주체는 사용자이기 때문에 사용자가 요구하면 하위 버전을 무시할 수가 없다. 이 포스트에서는 iOS 4.2이하 버전에서 디버깅을 할 수 있는 방법과 arm6 기반의 iOS4.2 이하 버전의 디바이스르 테스트하기 위해서 설정하는 방법을 포스팅했다. 이제 오래된 iPod touch로하위 버전 호환성을 디버깅할 수 있게 되었다. 이 포스팅으로 여러분의 개발에 조금이라도 도움이 되길 바래본다.


