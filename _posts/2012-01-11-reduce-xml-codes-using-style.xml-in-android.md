---
layout: post
title: Android에서 style.xml을 이용하여 반복적인 xml 줄이기
category: android
tags: [android, xml]
comments: true
redirect_from: /89/
disqus_identifier : http://blog.saltfactory.net/89
---

## 서론

아이폰 개발을 먼저 시작하고 나서 안드로이드 폰 개발을 하는 개발자라면 화면을 출력시키기 위해서 손수 XML 코딩을 하는 eclipse와 달리 Xcode가 얼마나 훌륭한 개발 툴이라는 느낄 것이다. 물론 아드로이드 개발에 공식적으로 지운하고 있는 eclipse 역시 매우 훌륭한 IDE이다. IDE는 재품의 개발과 유지 보수에 매우 큰 영향을 끼친다. 아직도 터미널에서 Java를 작성하는 개발자가 있거든 지금 바로 eclipse나 IntelliJ를 사용하시라. 그러면 지금 개발하는 코드의 몇배는 많이 개발하고 유지보수 할 수 있을 것이라고 말해주고 싶다.

XML 자체로 Java 코드와 UI 코드를 분리한다는 메타 프로그래밍 기법은 매우 훌륭한 방법이다. 처음 안드로이드를 개발할 때 main.xml을 열어서 Layout을 정의하는데 엄청난 수고가 들어간다. Xcode에서 XIB를 만들때의 장점은 GUI로 UI를 만들 수 있다는 것이다. (물론 iOS 개발을 할때 XIB 없이 개발하기도 한다.). Xcode의 XIB도 터미널에서 파일을 열어보면 XML로 되어 있다는 사실을 알 수 있다. 뿐만 아니라 AIR 프로그램을 개발할때도 이젠 이러한 메타 프로그램인은 아주 효과적으로 프로그램을 할 수 있는 방법으로 사용되고 있다.

<!--more-->

## Android 레이아웃 XML

기본적으로 안드로이드의 레이아웃을 구성하는데는 `/res/layout/{파일이름}.xml` 과 같이 XML 파일을 만들어서 화면 출력을 구성하고 widget의 id를 부여한다. 이러한 이유로 XML 파일에는 화면 출력에 대한 element의 속성을 지정하여한다. 이전 포스트인 [Android Draw 9-path 이미지 스트래칭을 이용하여 크기가 다른 버튼 만들기](http://blog.saltfactory.net/88) 를 살펴보면 타이틀 바에 버턴을 두개 올리고 제목을 출력시키기 위해서 우리가 설정했던 XML을 참조할 수 있다. 타이틀바에 버턴을 두개 올리고 제목을 출력시키기 위해서 상당히 많은 코드를 하나의 xml에 설정한 것을 알 수 있다. 마약 다음 그림과 같이 TextView 두개를 가지고 반복 적으로 출력되는 화면이 있는데 각각 이 TextView는 top과 bottom으로 나누어 다르게 출력시키고 싶어한다. 이런 모양을 출력하기 위해서는 기본적으로 다음 코드가 필요하다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/2d90fd1a-b2ef-4d90-b362-7dac5f6e2282)

우선 이 TextView 들은 ScrollView안에서 반복적으로 출력이 된다. 그리고 이 TextView는 각각 `@drawable/bg_box_top`과 `@drawable_bg_box_bottom`을 배경으로 사용하고 있고 이 두개의 TextView의 wrap하고 있는 LinearLayout이 반복적으로 생성되는 코드이다.

```xml
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
                android:layout_width="fill_parent"
                android:layout_height="fill_parent" android:scrollbarStyle="outsideOverlay"
                android:scrollbarSize="2040dip" android:background="#fff">

        <LinearLayout android:layout_height="fill_parent" android:layout_width="fill_parent"

android:paddingRight="5px" android:orientation="vertical">

           <LinearLayout android:layout_width="fill_parent" android:layout_height="wrap_content"

android:layout_margin="6dip" android:orienteation="vertical">
                   <TextView
                          android:layout_width="fill_parent"
                          android:layout_height="wrap_content"
                          android:text="안드로이드 스타일" android:textSize="18dip" android:padding="2dip"

android:textColor="#000" android:backgorund="@drawable/bg_box_top"
                          />
                   <TextView android:id="@+id/android_style" android:layout_width="fill_parent"
                          android:layout_height="wrap_content" android:textSize="16dip" android:padding="2dip"

android:background="@drawable/bg_box_bottom" android:textColor="#000"/>
            </LinearLayout>

        </LinearLayout>
    </ScrollView>
```

좀더 이렇게 반복되는 코드가 많이 발생된다고 생각하다면 아마 코드는 다음과 같을 것이다. 이런 코드는 계속적으로 생길수 있고 개발자는 copy & past를 반복하는 작업을 해야할지도 모른다.

```xml
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
                android:layout_width="fill_parent"
                android:layout_height="fill_parent" android:scrollbarStyle="outsideOverlay"
                android:scrollbarSize="2040dip" android:background="#fff">

        <LinearLayout android:layout_height="fill_parent" android:layout_width="fill_parent"

android:paddingRight="5px" android:orientation="vertical">

           <LinearLayout android:layout_width="fill_parent" android:layout_height="wrap_content"

android:layout_margin="6dip" android:orienteation="vertical">
                   <TextView
                          android:layout_width="fill_parent"
                          android:layout_height="wrap_content"
                          android:text="안드로이드 스타일" android:textSize="18dip" android:padding="2dip"

android:textColor="#000" android:backgorund="@drawable/bg_box_top"
                          />
                   <TextView android:id="@+id/android_style" android:layout_width="fill_parent"
                          android:layout_height="wrap_content" android:textSize="16dip"

android:padding="2dip" android:background="@drawable/bg_box_bottom"
                          android:textColor="#000"/>
            </LinearLayout>

           <LinearLayout android:layout_width="fill_parent" android:layout_height="wrap_content"

android:layout_margin="6dip" android:orienteation="vertical">
                   <TextView
                          android:layout_width="fill_parent"
                          android:layout_height="wrap_content"
                          android:text="제목" android:textSize="18dip" android:padding="2dip"

android:textColor="#000" android:backgorund="@drawable/bg_box_top"
                          />
                   <TextView android:id="@+id/subject" android:layout_width="fill_parent"
                          android:layout_height="wrap_content" android:textSize="16dip" android:padding="2dip"

android:background="@drawable/bg_box_bottom"
                          android:textColor="#000"/>
            </LinearLayout>

           <LinearLayout android:layout_width="fill_parent" android:layout_height="wrap_content"

android:layout_margin="6dip" android:orienteation="vertical">
                   <TextView
                          android:layout_width="fill_parent"
                          android:layout_height="wrap_content"
                          android:text="내용" android:textSize="18dip" android:padding="2dip"

android:textColor="#000" android:backgorund="@drawable/bg_box_top"
                          />
                   <TextView android:id="@+id/content" android:layout_width="fill_parent"
                          android:layout_height="wrap_content" android:textSize="16dip" android:padding="2dip"

android:background="@drawable/bg_box_bottom"
                          android:textColor="#000"/>
            </LinearLayout>

           <LinearLayout android:layout_width="fill_parent" android:layout_height="wrap_content"

android:layout_margin="6dip" android:orienteation="vertical">
                   <TextView
                          android:layout_width="fill_parent"
                          android:layout_height="wrap_content"
                          android:text="기타" android:textSize="18dip" android:padding="2dip"

android:textColor="#000" android:backgorund="@drawable/bg_box_top"
                          />
                   <TextView android:id="@+id/etc" android:layout_width="fill_parent"
                          android:layout_height="wrap_content" android:textSize="16dip" android:padding="2dip"

android:background="@drawable/bg_box_bottom"
                          android:textColor="#000"/>
            </LinearLayout>


        </LinearLayout>
    </ScrollView>
```

## style.xml

엔지니어는 이러한 반복 작업을 하는 것을 매우 싫어하기 이렇게 반복되는 작업을 하나의 작업으로 처리할 수 있는 기능을 만들기를 원한다. 안드로이드에서는 이러한 반복되는 코드를 style.xml 을 이용해서 한번에 처리할 수 있게 해준다. `/res/values/style.xml`을 만든다. 그리고 다음과 같이 resources안에 style을 정의한다.

```xml
<resources>  
    <style name="box_wrap">
        <item name="android:layout_width">fill_parent</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_margin">6dip</item>
        <item name="android:orientation">vertical</item>
    </style>
    <style name="box_top">
        <item name="android:background">@drawable/bg_box_top</item>
        <item name="android:layout_width">fill_parent</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:textSize">18dip</item>
        <item name="android:textColor">#000</item>
        <item name="android:padding">6dip</item>
    </style>

    <style name="box_bottom">
          <item name="android:layout_width">fill_parent</item>
        <item name="android:layout_height">fill_parent</item>
        <item name="android:textSize">16dip</item>
        <item name="android:textColor">#000</item>
        <item name="android:padding">6dip</item>
        <item name="android:background">@drawable/bg_box_bottom</item>
    </style>
</resources>
```

이젠 이렇게 반복적으로 출력을 위해서 사용한 코드를 style로 정의하였으니 실제 레이아웃을 설정하는 xml 파일에서 이 style을 사용하면 된다. 사용하는 방법은 `style="@style/{스타일 이름}"`으로 사용하면 가능하다. 이렇게 공통적으로 사용하는 스타일만 제외하고 실제 출력할때 유일하게 사용하는 것들만 다시 속성으로 정의해주면 스타일을 적용하고 추가적으로 적용이 가능하다.

```xml
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
                android:layout_width="fill_parent"
                android:layout_height="fill_parent" android:scrollbarStyle="outsideOverlay"
                android:scrollbarSize="2040dip" android:background="#fff">

        <LinearLayout android:layout_height="fill_parent" android:layout_width="fill_parent"
                      android:orientation="vertical">

            <LinearLayout style="@style/box_wrap">
                <TextView android:text="안드로이드 스타일" style="@style/box_top"/>
                <TextView android:id="@+id/android_style" style="@style/box_bottom"/>
            </LinearLayout>

            <LinearLayout style="@style/box_wrap">
                <TextView android:text="제목" style="@style/box_top"/>
                <TextView android:id="@+id/subject" style="@style/box_bottom"/>
            </LinearLayout>

            <LinearLayout style="@style/box_wrap">
                <TextView android:text="내용" style="@style/box_top"/>
                <TextView android:id="@+id/content" style="@style/box_bottom"/>
            </LinearLayout>

            <LinearLayout style="@style/box_wrap">
                <TextView android:text="기타" style="@style/box_top"/>
                <TextView android:id="@+id/etc" style="@style/box_bottom"/>
            </LinearLayout>

      </LinearLayout>
</ScrollView>
```

반복적인 소스 코드도 줄여 졌을 뿐만 아니라, 일괄적으로 스타일을 한번에 변경하는 것도 레이아웃 파일에 적용하는 것이 아니라 `style.xml` 파일만 변경함으로써 가능하게 되었다. 안드로이드 개발을 진행하면서 반복적인 코드의 사용이나 일괄적으로 스타일을 변경하고자 할때는 style.xml을 파일을 사용하면 xml 코드의 양도 줄일 수 있고, 반복으로 인한 코드 실수도 줄일 수 있다.


