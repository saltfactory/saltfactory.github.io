---
layout: post
title: Coda2에서 CakePHP의 ctp 템플릿파일 Custom Syntax Mode 적용하기
category: php
tags: [php, coda2, cakephp, ctp, syntax, highlgihting]
comments: true
redirect_from: /159/
disqus_identifier : http://blog.saltfactory.net/159
---

## 서론

Coda는 Mac 에서 PHP를 개발할 때 가장 아름다운 IDE가 아닌가 생각이 든다. 이번 Coda 2 릴리즈는 망설임 없이 바로 연구소에 신청해서 구매하게 되었다. 이번 프로젝트는 PHP로 개발하기 때문에 무거운 Eclipse의 PHP 플러그인이나 Editor Plus와 같은 단순한 IDE가 아닌 아름답고 강력한 개발 환경을 지원해주는 Coda 2 런칭 기념으로 반값 할인을 할 때 Mac용과 iPad 용 두가지 앱을 모두 구입했다. Air Play 로 Mac과 iPad의 소스를 공유할 수 있는 멋진 기능도 있기 때문이다. Coda 2에 대한 리뷰는 다시 정식으로 하나의 포스팅으로 소개하겠다.

<!--more-->

지금까지 프로젝트를 진행하는 동안에 여러 프레임워크를 도입해봤지만 Ruby on Rails와 Springframework MVC 를 가장 좋아한다. 이유는 아주 명확하게 MVC 패턴으로 개발할 수 있게 지원해주고 있기 때문인데, 이렇게 프레임워크에서 개발하면 내가 힘들게 MVC 패턴을 생각하면서 개발하지 않아도 프레임워크가 가지고있는 루틴으로 자동으로 MVC 로 개발할 수 있는 편리함을 제공받는다. 그래서 PHP 프로젝트를 진행하면서 CakePHP를 도입하기 생각하고 테스트를 진행하기로 했다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/98c347c7-374d-4d4f-8529-fff71e5e083c)

CakePHP는 MVC 패턴을 지원하면서 빠르고 신리성 있는 웹 어플리케이션을 만드는데 이미 많은 커뮤니티들에게 인기 좋은 프레임워크이다. 더구나 라이센스도 MIT License를 따르고 있어서 상용으로 사용하기에도 부담되지 않는 프레임워크이다. 이렇게 프레임워크를 선정하고나서 Coda를 이용해서 PHP 개발을 위해서 테스트를 진행하고 있는데 CakePHP에서는 View를 만들기 위해서 template으로 .ctp 라는 확장자를 가진 파일을 사용하는 것이다. 애썩하게도 Coda에서는 기본적으로 .ctp 파일에 대한 syntax를 지원하고 있지 않았다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/1b97a549-f494-4452-9b41-bf83ec10861c)

그래서 .ctp 파일을 Coda2 에서 syntax highlight 를 적용하기 위해서 custom syntax mode 기능을 사용해야한다.
1. Coda 2의 preferences를 연다. (command + ,)
2. Editor 탭을 선택한다.
3. Custom Syntax Modes 밑에 + 버튼을 클릭한다.
4. File Extension 에 ctp를 입력한다.
5. Syntax Mode 를 PHP-HTML 로 선택한다.
6. OK 버튼을 클릭한다.
7. Coda 2 를 종료하고 다시 실행한다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/10fdedee-3a69-4d82-87b9-7c998028f15f)

이렇게 Custom Syntax Modes를 설정하고 Coda 2를 종료하고 다시 Coda 2를 열게되면 .ctp 확장자를 가진 파일은 PHP-HTML 의 syntax mode와 같이 syntax highlight 기능을 사용할 수 있게 된다.

![](http://asset.blog.hibrainapps.net/saltfactory/images/f13b1780-7a14-4287-b7f8-fbecd8b689b4)

## 결론

CakePHP에 대한 자세한 사용법과 개발 방법에 대해서는 CakePHP tutorial 이라는 주제로 포스팅을 준하고 있다. Coda 2 는 훌륭한 PHP, HTML5 개발 툴이다. Coda 2는 Cocoa로 개발되어져 있기 때문에 Java로 만들어진 IDE보다 성능도 쾌적하다. 이렇게 두가지 좋은 장점을 개발하는데 발휘하기 위해서는 Coda 2 에서 지원하지 않는 .ctp 파일을 Custom Syntax Mode를 이용해서 설정할 필요가 있고, 이 것을 사용해서 View의 template을 개발하는데 더 효과적으로 개발할 수 있을 것이라 예상된다.

## 참고

1. http://www.mactricksandtips.com/2008/09/32-coda-tips-and-tricks.html

