---
layout: post
title: 맥용 Google Chrome 브라우저 임시파일(Cache, Cookie) 관리
category: chrome
tags: [chrome, google, cache, cookie]
comments: true
redirect_from: /172/
disqus_identifier : http://blog.saltfactory.net/172
---

## 서론

Mac OS X (맥)에서는 맥용 소프트웨어 캐시 자원을 ~/Library/Caches 즉 /Users/사용자/Library/Caches 라는 디렉토리에 어플리케이션 폴더 형태로 관리를 하고 있다. 아마 윈도우즈도 소프트웨어 Caches 파일을 관리하는 디렉토리가 있을 것 같은데 윈도우즈를 주력으로 사용하지 않아서 정확하게 언급을 하지는 못하겠다. 다만 브라우저 소프트웨어 기준으로 봤을 때 Internet Explore가 가지고 있는 임시파일 디렉토리가 존재하는 것으로 알고 있다. 그래서 보안상 주기적으로 임시 디렉토리를 비우는 작업을 할 것으로 예상이 된다. 그럼 과연 Mac에서는 어디서 구글 크롬 브라우저 (Google Chrome Browser)의 임시파일을 저장하고 있는지 살펴보자.

원래 보안이라는 것은 사용자의 민감한 부분이고 개인적인 부분이다. 그래서 이 포스팅이 좋은 의도에서 작성되어졌고, 다른 의도에 사용되지 않고 개인정보 보호에 사용되기를 기대해본다. 웹 브라우저에서 사용되는 데이터는 프로그래머와 웹 서비스에 따라 임시 파일들이 보안상 취약하기 때문이다. 그래서 개인 노트북이나 개인 PC 사용을 하는 사용자에게는 특별히 문제되지 않겠지만, 공용 PC를 사용하거나 다른 사람의 랩탑을 잠시 사용해서 사용했더라면 개인이 사용한 웹 서비스의 데이터들을 삭제하는 것을 권유하고 싶다. 물론 임시 데이터( 캐시나 쿠키) 자체가 보안상 문제가 되거나 개인정보가 문제가 되지는 않지만, 보안상 자신의 사용 이력을 남겨두는 것 보다는 사용후 폐기하는 것이 좋기 때문이다.

이번 포스팅은 "구글 크롬 브라우저"에 관한 임시 파일 저장소 관리에 대한 방법이다.

<!--more-->

## Chrome Browser Preferences

먼저 크롬 브라우저 자체에서 사용자의 개인 데이터들 UI로 삭제할 수가 있다.

Chrome Browser에서 preferences를 열어보자.  command + ,  키를 사용하거나 검색창에서   chrome://chrome/settings  라고 입력하고 검색하면 크롬 브라우저의 환경설정 화면이 나타난다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/100ea7d8-323d-4195-b7b8-f57e1975d40a)

항목중에서 Users 라는 것이 있는데, Chrome Browser가 계속적으로 업데이트되면서 이젠 크롬 브라우저에서 여러면의 사용자들이 각자 자신에 맞는 맞춤형 서비스를 사용할 수 있게 되었다. 그래서 하나의 크롬에 다른 구글 계정으로 접속해서 개인의 검색과 통계를 가지고 맞춤형 서비스를 받을 수 있게 된다. User라는 항목이 바로 자신이 사용할 구글 계정을 추가하는 항목이다. Add new user로 추가할 수 있고, Delete this user로 삭제할 수 있는데 여기서 Delete this user를 한다고 해서 브라우저에서 사용하던 임시 데이터가 삭제되는 것이 아니라는 것을 기억하고 있어야한다.

## Profiles

브라우저의 사용자는 내부적으로 profile 이라는 디렉토리에 시퀀스한 번호로 사용자별로 구분되어져서 사용이 된다.

Mac 에서는 Application 에서 사용하는 데이터를 일괄적으로 관리하기 위해서 ~/Library/Application Support/소프트웨어이름 디렉토리에서 데이터를 저장하고 관리를 한다. Application Support 라는 디렉토리를 살펴보자.

```
ls ~/Library/Application\ Support
```

이렇게 사용자 디렉토리 밑에 있는 ~/Library/Application Support 안에는 지금 현재 내가 사용하고 있는 소프트웨어들의 폴더가 있는 것을 확인할 수 있을 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b5716dc1-1394-4247-ab81-bc560e76fa11)

이제 우리가 알고 싶어하는 Google Chrome에서 저장하고 있는 데이터를 확인하기 위해서 다음과 같이 크롬 디렉토리로 이동을 한다.
```
cd ~/Library/Application\ Support/Google/Chrome
```

크롬 디렉토리 목록을 살펴보면 다음과 같이 "Profile 시퀀스 번호"의 형태를 가지는 디렉토리가 생겨있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f885bd95-c5ba-4ee5-bac5-627c2e81b4e5)

위에서 언급한 새로운 사용자 추가 (Add new user) 나 사용자 삭제(Delete this user)를 하게되면 Profile 이라는 디렉토리가 생겨서 그때에 맞는 사용자의 데이터를 저장하게 된다. 현재 가장 최근에 만들어진 Profile 16 (이것은 실습하는 PC마다 번호가 다를것이다) 안을 살펴보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5ca7600d-d7aa-460a-8cf7-ce251b847879)

Cookie 파일 말고도 다른 여러가지 파일들이 존재한다. 다른 파일에 대한 상세한 설명을 지금은 생략하고 앞으로 하나씩 알아가보도록 하자. 이 포스팅의 요점은 사용자의 개인 정보를 쿠키를 이용해서 사용한다고 할 때 브라우저가 사용하는 쿠키 파일의 위치가 이곳에 있다는 것이다.


## Caches

다음은 Cache 파일을 저장되는 곳을 살펴보자.
앞에서 살펴본 것은 Chrome 브라우저가 사용하는 쿠키를 포함한 데이터정보가 ~/Library/Application Support/소프트웨어이름 안에 있다는 것을 알았다. 이 디렉토리 성격은 Mac OS X에서 해당 소프트웨어 어플리케이션이 자신의 데이터를 관리하는 곳이다. 다음은 Mac OS X 에서 Cache에 관한 데이터를 어디에서 저장하고 관리하는지 살펴보면 ~/Library/Caches/소프트웨어이름 에서 관리를하고 있다.
맥에서 관리하는 캐시 디렉토리로 이동을 해보자.


```
cd ~/Library/Caches
```

앞에서 본 ~/Library/Application Support 디렉토리처럼 현재 사용하고 있는 소프트웨어 이름들이나 패키지명들이 보이게 될 것이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4667e55d-6232-43e4-b6cd-4578fb172fdd)

다음은 우리가 궁금해하는 Chrome 캐시 디렉토리를 살펴보자.

```
cd ~/Libraray/Caches/Google/Chrome
```

우리가 위에서 살펴본 ~/Library/Application Support/Google/Chrome/Profile 시퀀스 디렉토리와 마찬가지로 ~/Library/Caches/Google/Chrome/Profile 시퀀스 디렉토리가 존재하는 것을 확인할 수 있다.


![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/2ba88d5e-33b8-46b7-bbba-4913e21f9d2a)

디렉토리 내부를 살펴보면 다음과 같이 data 파일들과 index 파일이 존재한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b753a228-ccec-4e95-a29c-3f1600ef95fa)

만약에 지금 브라우저를 열어서 현재 이 블로그를 열었다고 했을 때 Cache 디렉토리에는 다음과 같는 파일들이 추가적으로 더 발생한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/a997196e-fd96-425c-af24-f648276b99c3)

이렇게  크롬 브라우저가 웹 사이트를 열었을 때 캐싱해서 속도를 높이거나 재사용할 자원들이 저장이 된다. 또는 크롬브라우저의 캐싱정보를 보기 위해서는 검색창에다 다음과 같이  chrome://cache  라고 입력하면 캐싱된 되이터의 정보를 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/1b87b1e3-2dc9-40a2-a5c4-d6436c7c836c)

캐싱 정보를 보면 알겠지만 javascript, css, image 파일, 브라우저의 자동완성 데이터 등이 저장된다. 이런 데이터들이 단순하게 Preferences에서 Delete this user를 해서 사라지는 것이 아니다. Preferences의 가장 아래에보면 Show advance settings라고 되어 있는 링크를 클릭한다. 그러면 보이지 않았던 Privacy 항목이 나타나고 체크 항목이 나타나고 Clear browsing data 버튼이 보이게 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7b76ccd8-ded2-4260-9c05-89774fba3560)

그리고 Clear browsing data를 클릭하게 되면 삭제하고 싶은 items 들이 나타나고 체크박스로 선택을 하고 삭제하면 된다. items의 기간에 따라서 삭제를 할 수 있는데 1시간 이전부터 1주, 한달 등 선택을 할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f95d1185-92b6-43c9-a91d-1202e5425658)

Clear Browsing data를 클릭해서 캐시된 파일과 쿠키 파일을 모두 삭제 시켜보자. 그리고 다시 브라우저에 chrome://cache라고 검색하면 캐싱된 파일이 모두 삭제된 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6e88d4e5-1031-4b1e-a110-37e8cb2bab25)

마찬가지로 캐시 디렉토리를 검색하면 Profile 디렉토리에 캐싱된 파일이 지워졌고 기본 데이터 파일들만 있는 것을 확인할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/7d8c315f-0d2d-49bc-9583-a383250fa1ac)

## 참고

1. http://stackoverflow.com/questions/4528208/google-chrome-cookie-storage
2. http://superuser.com/questions/197786/location-of-chrome-cache-on-mac-os-x

