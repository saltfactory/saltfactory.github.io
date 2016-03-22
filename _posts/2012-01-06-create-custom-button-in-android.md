---
layout: post
title: Android 사용자정의 버튼 만들기
category: android
tags: [android, button]
comments: true
redirect_from: /87/
disqus_identifier : http://blog.saltfactory.net/87
---

## 서론

안드로이드는 layout에 대헌 정의를 XML로 분리했고 이로인해 훌륭한 메타프로그램을 사용할 수 있게 되었다. 하지만 안드로이드 UI 정의는 아이폰의 xib 만큼 훌륭하지는 못한게 사실이다. Xcode의 IBOutlet과 IBAction을 정의하는 것과 같은 방법이 안드로이드 개발에 도입되길 간절히 바래본다.
하지만 안드로이드의 메타 프로그래밍도 매우 우연하고 훌륭하다. 또한 리소스 접근을 고유한 아이디로 접근할 수 있게 추상화 시킨것도 매우 훌륭하다. 마치 HTML에서 element에 id값을 부여하고 document.getElementById로 그 고유한 element에 접근하는 방법과 매우 유사하다. findByViewId 로 뷰에 접근할 수 있는 기능이 그러한 예이다.

아이폰과 안드로이드폰  두 디바이스를 동시에 개발하고 있으면서 항상 느끼는건데 안드로이드의 UI는 너무 안이쁘다는 것이다. 그렇지만 다행이도 이러한 안드로이드의 장점은 모든 리소스를 사용자가 변경할 수 있다는 것이다. 그것도 XML을 통해 UI코드를 소스 코드에서 분리해 낼 수 있다. 이는 아이폰 개발에서 아쉬운 부분을 해결해준다. UIViewController나 UIView안에 로직과 CGRectMake나 CGRectSize를 정의하는 코드를 많이 볼수 있는데 안드로이드에서는 .java 코드에서 이러한 UI 핸들링하는 코드를 분리할 수 있기 때문이다. 그렇다고 Activity 클래스에서 programtic하게 UI를 구현할수 있다는 것은 변함이 없다.

<!--more-->

## 버튼에 배경이미지 넣기

버튼에 배경이미지를 넣어보는 코드를 만들어 보자.
우선 `/res/drawable-hdpi/icon_compose.png` 라는 파일을 만들어서 넣었다. 다음은 `main.xml` (디폴트 레이아웃)의 코드를 수정하였다. 이 코드 주에서 버튼에 이미지를 넣는 것만 살펴보기 때문에 Button 태그만 중심으로 살펴보면 된다. 이 Button의 아이디는 `compose_button`이라고 정의하였다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="fill_parent"
              android:layout_height="fill_parent" android:background="#fff">

    <RelativeLayout android:layout_width="fill_parent" android:layout_height="wrap_content"
                    android:background="@drawable/bg_titlebar" android:padding="8dp">

        <TextView android:text="제목" android:layout_width="wrap_content"
                  android:layout_height="wrap_content" android:textColor="#fff" android:textSize="18dp"
                  android:gravity="center" android:height="40dp"/>

        <Button android:id="@+id/compose_button" android:layout_height="40dp"
                android:layout_width="53.3dp"
                android:layout_alignParentRight="true" android:background="@drawable/icon_compose"
                />

    </RelativeLayout>
    <ListView
            android:id="@android:id/android:list"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"/>
</LinearLayout>
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/650b4c40-553b-49c0-8153-7144b97d047c)

## 버튼 선택 여부 구현하기

위의 코드를 Activity 안에서 pragmatic하게 구현할수 있다.

```java
@Override
public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        composeButton = (Button) findViewById(R.id.compose_button);
        composeButton.setBackgroundResource(R.drawable.icon_compose);
}
```

이 코드로 만든 button은 눌려도 바르게 눌러졌는지 잘 못 눌렀는지 확인이 되지 않는다. 우리가 원하는 것은 사용자들이 좀더 버튼이라 의식하고 눌러졌는지를 사용자에게 인터렉티브하고 알려주고 싶다. 그래서 눌러졌을때 다른 이미지를 나타나게 하고 싶다. 그래서 우리는 selector를 정의하여 그 리소스를 사용할 것이다. `/res/drawable/selector_button_compose.xml`을 만들고 다음 코드를 생성한다. status\_pressed가 눌려졌을때, status\_focused는 가르켜질때, status가 없을때는 보통때의 이미지가 선택되게 하는 것이다. 이때 눌려졌을때 사용하는 `/res/drawable-hdpi/icon_compose_pressed.png`파일을 추가한다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true"
          android:drawable="@drawable/icon_compose_pressed"/>
    <item android:state_focused="true"
          android:drawable="@drawable/icon_compose"/>
    <item android:drawable="@drawable/icon_compose"/>
</selector>
```

이제 방금전에 작성했던 main.xml의 android:background 부분에서 특정 이미지를 할당하는것이 아니라 우리가 selector로 만든 리소스를 사용할 수 있게 변경할 것이다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="fill_parent"
              android:layout_height="fill_parent" android:background="#fff">

    <RelativeLayout android:layout_width="fill_parent" android:layout_height="wrap_content"
                    android:background="@drawable/bg_titlebar" android:padding="8dp">

        <TextView android:text="제목" android:layout_width="wrap_content"
                  android:layout_height="wrap_content" android:textColor="#fff" android:textSize="18dp"
                  android:gravity="center" android:height="40dp"/>

        <Button android:id="@+id/compose_button" android:layout_height="40dp"
                android:layout_width="53.3dp"
                android:layout_alignParentRight="true" android:background="@drawable/selector_button_compose"
                />

    </RelativeLayout>
    <ListView
            android:id="@android:id/android:list"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"/>
</LinearLayout>
```

![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/5af38bef-1fbe-49f9-9b9c-0a5ea31265c6)
![](https://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/001fbd79-6230-4d34-8d0f-facf663673d2)

이제 사용자는 버튼이 제대로 눌러졌는지를 버튼을 누르면서 확인할 수 있게 되어 버튼이 눌러졌는지 더이상 의심하지 않아도 되게 되었다. 그럼 selector를 Acitivity에서 사용하려고 할때를 살펴보면 단순히 button에다 이미지를 추가하는 방벙으로는 할수가 없다. xml에서 설정한 것과 마찬가지로 selector의 리소스를 background로 사용하면 된다.

```java
@Override
 public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        composeButton = (Button) findViewById(R.id.compose_button);
//        composeButton.setBackgroundResource(R.drawable.icon_compose);
        composeButton.setBackgroundResource(R.drawable.selector_button_compose);
}
```

