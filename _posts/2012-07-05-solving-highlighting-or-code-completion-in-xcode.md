---
layout: post
title: XCode에서 하이라이팅과 자동완성되지 않을 때 해결방법
category: xcode
tags: [xcode]
comments: true
redirect_from: /163/
disqus_identifier : http://blog.saltfactory.net/163
---

## 서론

Xcode는 Objective-C 언어 기반의 iOS와 Cocoa를 개발할 때 사용하는 Apple에서 제공하는 통합 개발 IDE로 Objective-C 언어 뿐만아니라, Ruby, Python, HTML, Javascript, CSS,  등 많은 언어로 개발할 수 있는 환경을 제공하고 있다. XIB builder를 이용해서 UI를 개발하는 것을 Android 개발자들이 볼때 너무나 매력적으로 생각한다. 그리고 LLVM을 이용하여 코드를 analyze 하면 개발자가 미처 찾지 못하거나 놓쳤던 compiler level에서 코드를 분석해서 문제점을 알려주기도 한다. Xcode는 iOS보다 개발자에게 더 중요한 의미가 될지도 모른다. 그래서 WWDC에서는 iOS 세션과 더불어 Xcode 자체의 세션도 존재한다. Xcode는 그만큼 개발에 효과적이로 효율적이다. 더구나 Xcode 자체를 마치 아이폰에서 앱을 다운 받듯 App Store에서 다운받아서 바로 설치할 수 있다. 즉, Xcode 자체도 하나의 앱인것이다. 그러한 이유로 Xcode도 지속적으로 버그가 발생하고 업데이트가 실시되고 있다.  Xcode는 매우 매력적인 툴인 동시에 버그도 많은 툴이라는 것을 iOS 개발자들은 모두다 알고 있을 것이다. 하지만 또 Xcode 만큼 훌륭한 IDE가 존재하지 않기 때문에 코드가 날아갈지, 또는 Xcode가 개발 도중에 꺼지게 될지 염려하면서도 정말 편리하고 유용한 툴이라고 생각하면서 사용한다. Xcode는 여러가지 버그가 있고 대처해야할 방법도 여러가지 존재한다.

이번에 소개할 문제는 바로 Xcode에서 갑자기 코드의 Syntax Highlighting 기능과 Code completion이 동작하지 않게 되는 문제에 대처하는 방법이다. Xcode 에서 Syntax Highlighting 과 Code completion은 매우 훌륭하다. 이 기능이 너무 훌륭하기 때문에 이 기능이 갑자기 동작하지 않게되면 개발자들은 많이 당황하게 된다. 하지만 Xcode에서는 이런 상황이 종종 발생한다.

<!--more-->

## DerivedData

Xcode는 Xcode에서 제작한 project 정보는 project 를 생성한 디렉토리에 {프로젝트이름}.xcodeproj 폴더에 정보가 저장된다. 그리고 Xcode에서 작업하던 파일과 빌드 파일등 Xcode에서 발생되는 Derived Data를 특정 디렉토리에 저장하게 된다. 이러한 Derived Data는 다음 경로에 저장이 된다.

```
cd ~/Library/Developer/Xcode/DerivedData/
```

DerivedData 디렉토리에서 프로젝트 이름으로 검색해보면 여러가지 Xcode에서 제작된 프로젝트마다 생긴 파일들이 특정 디렉토리에서 저장되고 있다는 것을 확인할 수 있다.

![](http://cfile6.uf.tistory.com/image/17786F374FF4E9470F067E)

이 Derived Data의 정보는 Xcode의 Oranizer에서도 확인이 가능하다.
Xcode에서 Window > Oranizer를 선택하면 Organizer 화면이 나타나는데 Projects 탭을 선택하면 Project의 Location이 나오게 되고 프로젝트의 파일들이 저장되는 Derived Data와 Snapshot의 정보를 보여준다.

![](http://cfile25.uf.tistory.com/image/17785A334FF4E93B11CB76)

그리고 각각 오른쪽에 Delete 버턴들이 존재하는데 Syntax Highlighting과 Code Completion의 문제가 발생하면 현재 작업중인 프로젝트의 Derived Data를 삭제하고 다시 Xcode에서 Project를 열어서 보면 다시 Syntax Highlighting과 Code Completion이 정상적으로 동작하는 것을 확인할 수 있다.


## 참고

1. http://stackoverflow.com/questions/1627033/xcode-code-sense-color-completion-not-working


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
