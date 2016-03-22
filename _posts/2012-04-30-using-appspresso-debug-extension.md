---
layout: post
title: Appspresso를 사용하여 하이브리드앱 개발하기 - 4.ADE(Appspresso Debug Extension)으로 디버깅하기
category: appspresso
tags: [appspresso, hybrid, hybridapp, ios, android, javascript, java, objective-c, ade, debug]
comments: true
redirect_from: /128/
disqus_identifier : http://blog.saltfactory.net/128
---

## 서론

Appsresso가 1.0.1 버전으로 포스팅을 하고 있는 중에 주말에 1.1로 업데이트가 되었다. 1.1 부터 약간 설정하는 패널이 변경되었지만 사용방법은 대부분 비슷한것 같다. 기르고 1.1 부터는 언어 지역화를 지원하고, Appspresso의 IDE (이클립스 IDE)의 패널에서만 logging을 확인하는 것 말고도 Chrome Extension으로 Appspresso Debug Extension을 제공하고 있다. 지역화에 대한 테스트는 다음에 포스팅하기 하고 이 포스팅에서는 ADE 에 대한 사용 방법을 간단히 포스팅 한다.

<!--more-->

## ADE(Appspresso Debug Extension)

구글 크롬 브라우저를 사용한다면 구글 크롬 브라우저에서 다음 링크를 복사하여 Google Web Store를 방문하면  ADE에 대한 화면을 볼 수 있다.
https://chrome.google.com/webstore/detail/ndjecjkimojlfigobaibbffgoijajkeb

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/fdecc2f0-b165-49c1-aa59-1e3f01fbb65c)

그리고 설치하게 되면 아래와 같이 오른쪽 상단에 Appsresso Debug Extension (ADE)가 설치된 것을 확인 할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/4bbc5bce-a5f3-474f-bdb4-88eebf692fd4)

다른 google extension과 다르게 ADE는 브라우저에서 실행을 시키는 것이 아니다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/21269d2f-9e2d-467f-b123-457d7d661ef6)

처음에 이 방법을 몰라서 하참을 헤맸는데, 그때는 내가 가지고 있던 Appspresso 버전이 1.0.1이라서 아예 Appspresso에서 ADE를 실행 시킬 수 없었던 것이였다. 즉, ADE는 Appspresso 1.1에서부터 사용할 수 있으며 Appspresso 에서 Google Chrome 브라우저의 ADE 를 실행 시킨다는 것이다. Appspresso 1.1 버전 부터는 on the fly 패널에 다음과 같이 ADE 메뉴가 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/6c9141a2-11b6-4dfc-b551-5bb7b4434509)

이 버턴을 처음 누르면  다음과 같은 메세지가 나오는데 Appspresso에서 Google Chrome을 사용해야하기 때문에 Appspresso의 Chrome.app 의 위치를 설정해주기 위해서이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/d2a0f904-800c-459a-a4ea-5fe51297b5cf)

구글 크롬 브라우저 앱이 설치 되어 있는 곳을 지정하면 된다. 이 과정을 시작하기 전에 Google Chrome 에 Appspresso Debug Extension이 설치되어 있어야 한다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/9a5487ee-e192-4b30-8322-fb73ccfad495)

앞에서 테스트 하였던 프로젝트를 다시 디버깅 모드로 실행시켜보자. ADE 버턴이 활성화 되어 있는 것을 확인 할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/0973c8ee-b7ac-42c5-895c-b7a991f339b6)

이제 ADE 버턴을 눌러본다. 그럼 크롬 브라우저가 열리면서 디버깅을 할 수 있는 페이지가 열린다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/6fa3ac0c-57da-4921-a295-9f4fa435efb8)

그리고 debug라는 버턴이 있는데 이것을 클릭하면 디바이스에서 보이는 모습과 동일한 뷰 페이지가 열리는 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/ae95babb-0f67-430f-ab16-57248d7c79f1)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5fa5e248-457e-4c20-8122-d2ea66163143)

## Inspector

이제 웹 페이지 개발을 할 때 흔히 하용하는 Inspector를 열어서 디버깅하면 되는 것이다. 아래는 Scripts 디버깅을 하는 창인데 inspector 콘솔에 Appspresso의 on the fly 패널에 남는 로그와 동일한 것을 확인할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/f3f1a77a-9fb6-4e51-90f1-3709129f5533)

이렇게 inspector를 바로 사용할 수 있으니까 콘솔에서 javascript를 바로 적용하고 이벤트를 확인할 수도 있다. 다음은 콘솔에서 alert('test')를 테스트한 것이다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/4f766bc7-8e03-402c-8d35-27d4aa64e826)

뿐만 아니라 브레이크포인트(breakpoint)를 사용하여 변수의 변화를 확인 할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/596d49df-b27d-4fd3-ae03-ce45e118885c)

그리고 HTML의 내용을 수정할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/e360f13b-409c-4612-9b8f-47ff3f85a88a)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/49c51e63-97b5-47ff-a8e4-eeeb8b059168)

역시 브라우저의 inspector를 그대로 사용하기 때문에 CSS도 즉시 수정해서 적용되는 결과를 바로 확인 할 수 있다.

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/b5c6c020-3ce3-40da-9da6-c6e590ed0550)

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/48fadbf8-86b9-4508-81a5-a2907eb17757)

이렇게 크롬의 webkit 엔진에 적용되는 inspector를 이용해서 디버깅하는 것이 가능해진다. Appspresso에서 ax.log 만 가지고 디버깅을 하기는 무리가 있고 힘들었는데 Inspector를 사용할 수 있으니 breakpoint를 사용할 수 있어서 log를 찍어가며 테스트하지 않아도 변수의 변화를 확인할 수 있고 그리고 view를 업데이트하기 전에 HTML DOM의 변화를 실시간으로 변경되는 것을 확인할 수 있으니 개발하는데 더욱 편리해진 것 같다.
한가지 주의해야할 점은 inspector에서 디버깅한 코드가 실제로 디바이스에 바로 적용되지는 않는다는 것이다. 하지만 코드를 복사하거나 따로 저장해서 Appspresso에 수정을하고 다시 on the fly를 하거나 ADE 디버깅 브라우저를 새로 고침하면 바로 적용된 것을 확인할 수 있다. ADE로 디버깅이 많이 편리해 질 것으로 예상된다 좀더 바램이 있다면, 실제 디바이스에 바로 적용되는 ADE로 진화되어지길 간절히 바래본다.

## 도와주신분

ADE에 대해서 친절하게 답변해주신 KTH의 [@iolothebard](http://twitter.com/iolothebard) , []@appspresso_ko](http://twitter.com/appspresso_kr) 님 감사합니다. H3 컨퍼런스에서 설명 잘 들었고, 1.0.1로 안된다고 고민할 때 답변으로 힌트를 얻게되어 온전히 이해할 수 있었습니다.

