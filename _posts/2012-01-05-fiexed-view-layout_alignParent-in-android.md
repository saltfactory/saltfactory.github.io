---
layout: post
title : 안드로이드 layout_alignParent 속성을 이용하여 view 의 위치 고정시키기
category : android
tags : [android, layout, xml]
comments : true
redirect_from : /85/
disqus_identifier : http://blog.saltfactory.net/85
---

## 서론

안드로이드의 위젯은 모두 View를 상속받아서 만들어진다. 이러한 View를 왼쪽이나 오른쪽으로 위치 시키기 위해서 좌표를 위치시켜서 만들기도 한다. 하지만 안드로이드의 최고의 맹점은 디바이스의 크기가 아이폰과 같이 동일하지 않다는 것이다. 이러한 이유로 고정값으로 UI를 핸들링하게 되면 특정 디바이스에서는 개발할때의 의도와 다르게 나타나기도 한다.
<!--more-->

HTML으로 코드를 만들때도 마찬가지 이다. 예제 1과 같이 특정 button을 좌표 값으로 고정하여 위치를 만들 수 있다. 하지만 이건 고정 비율에서는 정상적으로 오른쪽에 고정되어 위차하게 나오게 설정할 수 있으나, button을 감싸는 div의 사이즈가 수정되어버리면 원하는 위치에 고정되는 것이 아니라 좌표 고정값에 고정되어서 문제가 생긴다.  예제 2와 같이 어떠한 사이즈가 되더라도 항상 오른쪽으로 고정할 수 있다면 N-Screen 사이의 문제를 해결할 수 있게 된다.

- 예제 1

```html
<style type="text/css">
.sample_div {width:300px; position:relative; border:1px solid #000;}
.sample_button {position:relative; left:100px;}
</style>

<div class="sample_div">
<button class="sample_button">New</button>
</div>
```


- 예제 2

```html
<style type="text/css">
.sample_div2 {width:300px; position:relative; border:1px solid #000; clear:both;}
.sample_button2 {position:relative; float:right;}
</style>

<div class="sample_div">
<button class="sample_button">New</button>
</div>
```

이와 비슷하게 안드로이드의 위젯을 align을 사용해서 조정할 수 있다.
android:layout_alignParentLeft, android:layout_alignParentRight라는 속성은 상위의 레이아웃에 관하여 align을 정하는 속성이다. 이렇게 layout_alignParent 속성을 가지고 위치 시키면 디바이스 크기와 가로와 세로와 상관 없이 원하는 위치에 고정시킬 수 있다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="fill_parent"
              android:layout_height="fill_parent">
    <RelativeLayout android:layout_width="fill_parent" android:layout_height="wrap_content"
                  android:background="#eee">
        <Button android:id="@+id/new_button" android:layout_height="wrap_content"
                android:layout_width="wrap_content"
                android:text="New" android:layout_alignParentRight="true"/>
    </RelativeLayout>
    <ListView
            android:id="@android:id/android:list"
            android:layout_width="fill_parent"
            android:layout_height="wrap_content"/>
</LinearLayout>
```

![](http://cfile23.uf.tistory.com/image/123B2D3F4F05342A26E577)

![](http://cfile26.uf.tistory.com/image/16625F3C4F0535B22CF2FD)


## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
