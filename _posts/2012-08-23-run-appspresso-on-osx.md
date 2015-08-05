---
layout: post
title : 앱스프레소(Appspresso) 마운틴 라이언 (Mountain Lion OS X 10.8.x)에서 바로 실행되지 않을 때
category : appspresso
tags : [appspresso, mac, osx, hybrid, mobile]
comments : true
redirect_from : /174/
disqus_identifier : http://blog.saltfactory.net/174
---

## 서론

Mountain Lion OS X (10.8.x) 버전부터는 맥에서 써드파티 어플리케이션의 보안이 강화되었다. 공식적으로 앱스토어를 통해서 앱을 다운로드 받지 않거나 애플에서 허가하지 않은 소프트웨어를 실행시키면 "알수 없는 개발자"가 만들었다는 경고를 보여주면서 앱을 실행할 수 없도록 한다. KTH의 Appspresso가 1.1.2 버전으로 업데이트되어서 마운틴 라이언에서 새로운 버전을 다운 받아서 앱스프레소를 실행시키는데 어플리케이션 보안 문제로 새로운 버전의 앱스프레소를 실행시킬 수 없는 문제를 만났다.
<!--more-->

![](http://cfile9.uf.tistory.com/image/153848495035E5FE3517DB)

하지만 이런 문제를 만나도 당황하지 말고 다음 방법으로 실행할 수 있다. 실제 KTH에서 배포하는 소프트웨어는 내 PC에 전혀 문제되는 코드를 가지고 있지 않고 보안상 문제되는 코드도 포함되어 있지 않다. 위의 경고는 Apple에서 아직 인증하지 못하거나, 맥 앱 스토어를 통해서 다운받지 않은 어플리케이션이기 때문에 사용자에게 알수 없는 개발자가 개발한 소프트웨어라고 확인시켜주는 화면이다.

앱스프레소를 다운받고 압축을 풀어서 /Applications 폴더에 넣고 난 다음에 Appspresso.app 을 오른쪽 마우스로 클릭해서 "Open"(열기)를 선택한다.

![](http://cfile24.uf.tistory.com/image/1904F5505035E6CE3100D2)

그러면 그냥 앱을 더블 클릭해서 보이는 경고창과 조금 다르게 나타나게 된다.

![](http://cfile6.uf.tistory.com/image/161244505035E5EF27AC95)

Opening "appsresso" will always allow it to run on this Mac 이라는 문구를 봐서 사용자가 개인적으로 안심하고 사용할 수 있는 소프트웨어라면 앞으로 확인하지 않고 계속적으로 사용할 수 있도록 하는 것을 알 수 있다. "Open" 버튼을 선택하서 앱스프레소를 실행시킨다.

![](http://cfile10.uf.tistory.com/image/193F15385035E76D294207)

그러면 앱스프레소가 정상적으로 열리게 되어 사용할 수 있게된다. 뿐만아니라, 앞으로는 오른쪽 마우스 버튼을 선택해서 열지 않고, 단순하게 더블클릭이나, dock에 아이콘을 추가하여 마운틴 라이언 이전과 동일하게 사용할 수 있다.

## 참고

1. http://osxdaily.com/2012/07/27/app-cant-be-opened-because-it-is-from-an-unidentified-developer/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
