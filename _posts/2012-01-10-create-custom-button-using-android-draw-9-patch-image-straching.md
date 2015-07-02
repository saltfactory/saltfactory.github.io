---
layout: post
title: Android Draw 9-patch 이미지 스트래칭으로 크기가 다른 버튼튼 만들기
category: android
tags: [android, draw, 9-patch, stretch]
comments: true
redirect_from: /88/
disqus_identifier : http://blog.saltfactory.net/88
---

## 서론

프로그램으로 이미지를 다루다 보면 하나의 이미지를 다르게 표현 하는 방법이 필요할 때가 있다. css로 배경이미지를 만들때는 repeat라는 기능을 이용해서 같은 패턴의 이미지를 x나 y로 반복시켜 이미지를 늘렸다 줄였다할 수 있지만 아이폰 개발할때나 안드로이드 개발할 때 Button이라는 것 객체가 가지는 속성을 가지고 만들어야하기 때문에 다른 방법이 필요하다. 기존에는 프로그램을 작성하다가 이미지가 필요하면 디자이너에게 이미지를 요청할 것이다. 아마도 이미지 패턴은 같은데 이미지 크기가 다를때마다 매번 다른 이미지를 디자이너에게 만들어 달라고 해야한다. 하지만 이것은 어떤 관점으로 보면 같은 일을 반복하는 관점으로 보일 수도 있다. 엔지니어적 관점으로 이러한 반복된 작업은 당연 다른 대처 방법이 있을거라 생각할 수 있다.  

우선 아이폰에서는 이러한 문제점을 해결하기 위해서 iOS5 부터는 **UIImage** 객체의 `resizableImgeWithCapInsets:UIEdgeInsetMake:` 메소를 이용해서 이미지를 pragmatic하게 스트래칭할 수가 있다. 이에 대한 예제는 이전 포스트인   iOS5에서 UINavigationBar에 배경이미지와 타이틀 색깔 변경하기에서 이 메소드에 사용하는 방법을 설명한적 있다. 아이폰을 먼저 개발하고 같은 앱을 안드로이드용으로 개발하다보니 아이폰의 기능을 안드로이드에서 구현할 수 있는 방법에 대해서 찾는일이 많아 졌다. 그래서 아이폰의 이러한 기능을 안드로이드에서 어떻게 구현하고 있는지 찾아보는 가운데 [@krazyeom](https://twitter.com/karzyeom) 님께서 나인페치에 대해서 힌트를 주셨고, 다시 안드로이드 문서와 구글링으로 [Android Draw 9-path](http://developer.android.com/tools/help/draw9patch.html)에 대한 자료를 찾게 되었다. (안드로이드의 9-path가 먼저 구현되었고 아이폰 5에서 이 기능을 지원하였다는 이야기도 해주었다. 사용하는 사람마다 차이가 있겠지만 개인적으로 아이폰의 이미지 스트래칭 방법이 좀더 pragmatic하게 처리할 수 있어서 더 편리한것 같다.)

<!--more-->

## Android Draw 9-patch

[Android Draw 9-path](http://developer.android.com/tools/help/draw9patch.html)는 특이하게 `$ANDROID_SDK/tools/draw9path` 라는 툴을 이용해서 스트래칭될 패턴을 만든다. 안드로이드 공식 문서는 http://developer.android.com/guide/developing/tools/draw9patch.html 에서 확인할 수 있다. 이렇게 draw9path 툴로 만든 이미지는 `{파일명}.9.png`로 저장이 되고 레이아웃에서 `@drawable` 속성을 사용할때는 `{파일명}`으로 사용하면 된다.

아래 그림은 draw9path를 이용해서 패턴을 정의하고난 이미지 이다. 실제 이미지는 다음과 같다.  이 이미지를  draw9path를 이용해서 양쪽으로 늘이거나 상하로 늘릴때 이미지가 어떻게 스트레칭 될지의 패턴을 정의할 수 있다. 이 때 empty 영역에 마우스를 클릭하면 검은색 점이 찍히면서 패턴이 변경하게 된다. 만약 패턴을 삭제 싶으면 검은색 점에다 오른쪽 마우스를 클릭하면 패턴이 삭제 된다.

![](http://cfile10.uf.tistory.com/image/182C71464F0BD7B20CEC8B)

![](http://cfile1.uf.tistory.com/image/135CE9444F0BD75F04C20F)

이렇게 이미지를 draw9path 툴로 선택되기 전과 선택되고 난 후의 이미지를 두가지를 만들어서 `/res/drawable-hdpi`에 저장을 했다.

![](http://cfile24.uf.tistory.com/image/202B23374F0BD6D9070B2A)

그리고 버턴을 선택하면 pressed 된 느낌을 구현하기 우해서 `selector_default_button.xml`을 만들어서 방금 draw2path로 만든 이미지들을 각각 지정하였다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true"
          android:drawable="@drawable/bg_default_button_pressed"/>
    <item android:state_focused="true"
          android:drawable="@drawable/bg_default_button"/>
    <item android:drawable="@drawable/bg_default_button"/>
</selector>
```

이제 layout을 설정하는 xml에서 button의 background를 방금 만든 `select_default_button.xml`으로 지정한다.

```xml
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:layout_width="fill_parent"
              android:layout_height="wrap_content" android:orientation="vertical">

    <RelativeLayout android:layout_width="fill_parent" android:layout_height="wrap_content"
                    android:background="@drawable/bg_titlebar" android:padding="8dp">

        <Button android:id="@+id/view_close_button" android:layout_height="40dp"
                android:layout_width="53.3dp"
                android:layout_alignParentLeft="true"
                android:text="닫기"
                android:textColor="#fff"
                android:background="@drawable/selector_default_button"
                />

        <TextView android:id="@+id/view_title" android:text="제목" android:layout_width="fill_parent"
                  android:layout_height="wrap_content" android:textColor="#fff" android:textSize="18dp"
                  android:gravity="center_vertical|center_horizontal" android:height="40dp"/>

        <Button android:id="@+id/view_modify_button" android:layout_height="40dp"
                android:layout_width="53.3dp"
                android:layout_alignParentRight="true"
                android:text="수정"
                android:textColor="#fff"
                android:background="@drawable/selector_default_button"
                />

    </RelativeLayout>

    <TextView android:layout_width="fill_parent" android:layout_height="wrap_content" android:text="제목"
              android:layout_margin="10dip"/>

    <RelativeLayout android:layout_width="fill_parent" android:layout_height="wrap_content"
                    android:background="@drawable/bg_titlebar" android:padding="8dp">


        <Button android:id="@+id/view_delete_button" android:layout_width="fill_parent"
                android:layout_height="40dip"
                android:background="@drawable/selector_default_button"
                android:textColor="#fff"
                android:text="삭제" android:gravity="center_horizontal|center_vertical"
                />
    </RelativeLayout>
</LinearLayout>
```

이렇게 Draw 9-path 방법으로 구현한 버튼은 다음과  같다. "닫기", "수정","삭제" 버턴 모두 동일한 `selector_default_button.xml` 리소스로 구현되어진 것이다.  그리고 이 selector의 각각 아이템의 {피알명은} draw9path에서 만든 `{파일명}.9.png`로 지정되어져 있다.

이제 우리는 Draw 9-path를 이용해서 같은 패턴의 버턴을 가로로 늘리거나, 세로로 늘리거나 아니면 완벽하게 스케일을 변화 시켜도 동일한 패턴의 버턴을 만들 수 있게 되었다. 아마도 디자이너에게 더이상 각각의 버턴을 만들어 달라는 시간이 줄어 들것이라 생각이 들고, 같은 이미지로 좀더 유연하고 다양한 이미지를 프로그래밍적으로 만들어 낼 수 있을거라 생각이 든다.

![](http://cfile27.uf.tistory.com/image/17149C4D4F0BD8D80185E5)

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
