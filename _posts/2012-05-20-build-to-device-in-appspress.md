---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 6.디바이스 빌드하기
category: appspresso
tags:  [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, request]
comments: true
redirect_from: /127/
disqus_identifier : http://blog.saltfactory.net/127
---

## 서론

Appspresso를 사용해서 하는 하이브리드 앱 개발은 대부분 디바이스 없이 진행 될거라고 예상이 된다. Xcode의 console이나 Android의 logcat 등으로 디버깅을 할 수 없기 때문에 유일하게 디버깅할 수 있는 것이 Appspresso의 on the fly이다. 다행이 Appsrpess 1.1 부터는 크롬 브라우저의 확장으로 ADE(Appspresso Debugging Extension)을 사용할 수 있지만 이것 역시 web inspector로 웹의 자원만 디버깅 할 수 있다. UI Framework 테스트를 하기 위해서 Sencha 2 touch를 시뮬레이터에서 테스트를 하고 실제 단말기로 로드했는데 시뮬레이터에서는 이상 없었던 버턴 이미지가 최초 로드가 늦게 되어서 찌그러지는 것을 확인할 수 있었다. 이렇게 단말기는 시뮬레이터와 메모리도 다리그 프로세서도 차이가 많이 나기 때문에 반드시 디바이스에 설치해서 동작하는 것을 확인 해야만 한다. 아쉽게 Appspresso에서 네이티브 레벨의 디바이스 디버깅은 될 수 없는 것 같다.

그럼 Xcode를 사용하지 않는데 어떻게 앱을 디바이스로 설치할 수 있을까?
Appspresso는 eclipse 기반으로 만들어져있기 때문에 android 앱을 android 디바이스로 설치하는데 큰 어려움이 없지만 iOS 디바이스는 상황이 좀 다른다. iOS는 Xcode를 가지고 개발할 수 있기 때문에 Xcode 없이 iOS 디바이스로 앱을 빌드하여 런칭시키는 것이 어렵기 때문이다. Appspresso에 내부적으로 command line tool을 이용해서 .ipa (DRM이 되어 있는 iPhone App) 파일을 빌드하여 iTunes에 추가하여 iPhone과 자동 동기화를 실행하여 iPhone으로 설치하는 과정으로 처리한다.

<!--more-->

## Android 빌드

우선 Android 부터 설명하면 다음과 같이 진행한다.

![](http://cfile8.uf.tistory.com/image/194DD7334FA0160201A8AA)

이렇게 project 디렉토리에서 오른쪽 마우스를 선택해서 Run as > Run Appspresso application on Android device를 선택한다.

![](http://cfile7.uf.tistory.com/image/12261E394FA016D90242FA)

만약 USB에 Android 디바이스가 연결이 되어 있으면 위에 그림과 같이 디바이스가 인식(Google Nexus One 모델)이 되는데 디바이스를 선택하고 실행하면 Android 디바이스로 빌드된 apk 파일이 launch 된다.

## iOS 빌드

그런데 iPhone으로 앱을 설치하려면 약간 복잡한 단계로 설치해야하고 설치하는데 시간이 오래걸린다.
우선 Run as 메뉴에서 오른쪽 아래로 된 화살표를 선택하여 Run configurations을 설정한다.

![](http://cfile1.uf.tistory.com/image/1515E2364FA01802224F8A)

![](http://cfile10.uf.tistory.com/image/2042A4414FA01810247626)

최초에 Run Configurations를 열어 Appspresso Application을 선택하고 + 가 있는 New launch configuration을 선택한다.

![](http://cfile6.uf.tistory.com/image/147CE7394FA018BE26FA5D)

그리고 Name에 Run Configrations의 이름을 지정한다. Run 설정을 여러개하여 실행할 수 있는데 이 때 구분할 수 있는 것이 여기에 작성하는 Run Configurations 이름이다.

![](http://cfile6.uf.tistory.com/image/191F0E404FA0191224DC84)

이름을 지정하고 나면 Target 탭을 선택한다. Target Platform에서 iOS를 선택한다.

![](http://cfile1.uf.tistory.com/image/202D31334FA01983143A68)

그리고 Target Device 옆에 있는 Browse를 선택한다. USB에 iPhone이 연결되어 있으면 나타나게 되는데 Certificate Name을 열어서 애플 개발자로 등록하여 만든 Certificates로 생성한 provisioning code sign을 선택한다.

![](http://cfile24.uf.tistory.com/image/201DB73A4FA01AA412D57F)

![](http://cfile10.uf.tistory.com/image/20780D354FA01A3121E790)

이렇게 디바이스를 선택하고 code sign을 선택하고 나서 apply를 하고 run을 하던지 아니면 바로 run을 실행한다.

![](http://cfile29.uf.tistory.com/image/11291C464FA01AFC0C26EA)

Appspress에서 빌드가 끝나면 iTunes가 열리면서 iTunes의 Apps라는 곳에 "하이브리드 연습"이라는 앱이 등록이 된다. (이 App이라는 메뉴는 iPhone 안에 설치된 app들과 동기화를 위해서 iTunes 내부 디렉토리에 .ipa 파일을 저장하여 목록화 하고 iPhone 안에 앱이 삭제되거나 재 설치할 때 사용하거나 App Store에서 업데이트할 때 사용할 수 있다)

![](http://cfile28.uf.tistory.com/image/141CB7344FA01D1E07031E)

![](http://cfile1.uf.tistory.com/image/13251F454FA01BF722AD7F)

디바이스를 선택해보자. 여기서 Apps라는 탭에 Sync Apps 가 반드시 체크가 되어 있어야 한다. 그래야 위에서 우리가 개발하는 앱을 iPhone과 자동으로 동기화 시킬수 있기 때문이다. (개인적으로 iCloud로 백업해서 iTunes와 동기화는 하지 않았는데... Appspresso에서 디바이스 테스트하려고 동기화 하려다가 기존에 설치되어 있던 앱들이 모두 다 증발하고 말았다 ㅠㅠ. 미리 백업하고 동기화하길 바란다.)

![](http://cfile29.uf.tistory.com/image/207AB43C4FA01CDD1C55B6)

이렇게 iTunes에 앱을 추가하고 동기화를 진행하면 이제 iPhone 실제 적으로 앱이 추가가 된다.

![](http://cfile3.uf.tistory.com/image/145D3B374FA01EFB2F7067)

![](http://cfile2.uf.tistory.com/image/173A363B4FA02233052708)

다음부터는 project 디렉토리에서 오른쪽 마우스를 선택해서 Run as > Run Appspresso application on iOS device를 선택하여 실행하거나 바로 Run을 실행하여 Run Configurations에서 만든 이름을 선택하여 설치하면 된다.

![](http://cfile23.uf.tistory.com/image/2019E1364FA0175F1ED15B)

디바이스로 on the fly를 이용해서 디버깅은 가능한데 네이티브 코드 디버깅은 어려워 보인다. 그리고 이렇게 앱을 iTunes에 복사하고 다시 iPhone과 동기화 하는 과정의 시간이 그렇게 짧지만은 않다. 이러한 이유로 실제 디바이스로 테스트를 할 때는 시뮬레이터에 충분히 테스트를하고 디바이스에 의존적인 테스트를 할 때만 디바이스로 설치하는게 좋다고 생각이 들었다. 하지만 반드시 디바이스 테스트는 필요하다. webkit 안에서 동작하는 HTML5의 속성 (html, javascript, css)의 렌더링 속도가 시뮬레이터랑 디바이스와 차이가 아주 많이 나기 때문이다.
개인적으로 Appspress 개발 팀에게 바라기는 Xcode와 연동이 되어서 Xcode 상에서 breakpoint도 사용할 수 있고 디버깅도 가능해지는 그런 기능이 포함되어지길 바래본다. phonegap은 아직 테스트하지 않아서 잘 모르겠지만 phonegap은 Xcode 안에 템플릿으로 만들어서 사용 가능한 것으로 알고 있다. phonegap은 그러면 네이티브 코드를 디버깅하면서 사용할 수 있는것일까? 이 문제 대해서는 테스트를 해보고 다시 포스팅을 해보겠다. Appspresso는 좋은 하이브리드 개발 프레임워크이다. 아직 1.1 버전이지만 iPhone과 Android를 동시에 하나의 IDE에서 개발하고 실행할 수 있다는 것만으로 충분히 메리트가 있다. 아쉬운 부분이 몇가지 있지만 동시에 개발하기에는 Appspresso가 좀 더 유리한것 같기도 하다. 다만 iOS 디바이스에 설치하는 복잡한 과정이 개선되어지면 하고 바래본다.

iOS 4.x 버전 디바이스를 테스트하기 위해서 구형 iPod Touch 2nd (iOS 4.2.1)를 연결하고 Run Configurations 에 추가할 때 iOS4.x 디바이스가 browser 되지 않는 버그가 있음. iOS 5.1로 선택하고 빌드하면 문제 없이 되기는 하지만 다음 버전에 수정되어져서 버전별로 디바이스가 인식되면 좋겠다고 생각이 든다. Appspresso가 좋은 하이브리드 앱 개발 환경이라고 생가하기 때문에 사소한 버그도 신경 써서 업데이트 해주길 바래본다.

![](http://cfile25.uf.tistory.com/image/140C073C4FA0C90C0AF5EE)

![](http://cfile25.uf.tistory.com/image/115BD5494FA0C91D275C4F)

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
