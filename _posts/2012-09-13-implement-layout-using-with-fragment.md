---
layout: post
title: Fragment를 이용하여 안드로이드 화면구성하기
category: android
tags: [android, fragment, java]
comments: true
redirect_from: /190/
disqus_identifier : http://blog.saltfactory.net/190
---

## 서론

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/070137db-ea73-4e33-8f22-a1e34944e37c)

만약 스마트 폰 앱을 개발할 때 세로모드(Portrait)에서는 단순하게 화면을 구성하지만 가로모드(Landscape) 화면 구성을 좀더 다양한 화면으로 구성 하고 싶다면 어떻게 할지 고민할 수 있다. 또는 해상도나 디바이스의 스크린크기, 디바이스 종류에 따라서 보여지는 것들을 다르게 구성하고 싶어할 수도 있다. 안드로이드 개발자들은 이러한 요구사항을 만족시켜줄 수 있는 것을 fragment라는 개념으로 추가하게 되었다. 안드로이드 2.3 이하 버전에서는 한 화면에 보이는 모든 것을 관장하는 것이 Activity라는 개념이였다. 이러한 Activity는 하나의 화면에 여러개 사용할 수 없게 설계가 되어있다. Activity 하나하나 마다 생명주기를 갖고 있기 때문이다. 만약 하나의 화면에 Activity와 비슷한 개념을 가지면서도 여러가지 화면을 넣을 수 있는 방법으로 fragment가 등장하게 되었다. 이 fragment 는 Android 3.0 부터 등장하였지만 Android 3.0은 태블릿을 위한 버전이라 Android 3.0 버전 때의 SDK를 사용하거나 개발하지 못했다. 하지만 Android 4.0 이상 부터는 안드로이드 개발자들이 스마트폰과 태블릿을 동시에 적용할 수 있게 지원하면서 Android 3.0 이상에서 부터 사용할 수 있는 fragment를 사용하여 개발할 수 있게 되면서 자료를 찾아서 실험하게 되었다.

<!--more-->

## Fragment 특징

Fragment를 이용해서 개발을 하기전에 몇가지 특징을 알아보자. 더 많은 특징이 있지만 이번 예제에서 다음 특징들을 살펴볼 것이다.

1. fragment는 activity 안에서만 존재할 수 있고 단독으로 존재할 수 없다.
2. fragment는 activity 안에서 다른 view와 함께 존재할 수 있다.
3. fragment는 back stack을 사용할 수 있다.
4. fragment는 반드시 default 생성자가 있어야 한다.


## Fragment 생명주기

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/fafedb5a-83ee-4507-8150-173727fcf508)

**onAttach()**

onAttach() 콜백 메소드는 fargment가 activity에 추가되고 나면 호출된다. 이때 Activity가 파라미터로 전달되게 된다. Fragment는 Activity가 아니다. 다시말해서 Activity는 Context를 상속받아서 Context가 가지고 있는 많은 있지만 Fragment는 android.app 의 Object 클래스를 상속받아서 만들어진 클래스이다. 그래서 Fragment에서는 Context의 기능을 바로 사용할 수 없다. 뿐만 아니라 Fragment는  Activity 안에서만 존재하기 때문에 Activity를 onAttach() 콜백으로 받아올 수 있다.

```java
@Override
public void onAttach(Activity activity) {
	super.onAttach(activity);
}
```

**onCreate()**

Fragment의 onCreate() 메소드는 Activity의 onCreate() 메소드와 비슷하지만 Bundle을 받아오기 때문에 bundle에 대한 속성을 사용할 수 있다.

```java
@Override
public void onCreate(Bundle savedInstanceState) {
	if(savedInstanceState != null) {
        for(String key : savedInstanceState.keySet()) {
            Log.v("bundle key : " + key);
        }
	}
	super.onCreate(savedInstanceState);
}
```

**onCreateView()**

Fragment의 onCreateView()는 Fragment에 실제 사용할 뷰를 만드는 작업을 하는 메소드이다. LayoutInflater를 인자로 받아서 layout으로 설정한 XML을 연결하거나 bundle에 의한 작업을 하는 메소드이다.

```java
@Override
public View onCreateView(LayoutInflater layoutInflater, ViewGroup viewGroup, Bundle savedInstanceState) {
	return super.onCreateView(layoutInflater, viewGroup, savedInstanceState);
}
```

**onActivityCreated()**

onActivityCreate() 메소드는 Activity에서 Fragment를 모두 생성하고 난 다음에 (Activity의 onCreate()가 마치고 난 다음)에 생성되는 메소드이다. 이 메소드가 호출될 때에서는 Activity의 모든 View가 만들어지고 난 다음이기 때문에 View를 변경하는 등의 작업을 할 수 있다.

```java
@Override
public void onActivityCreated(Bundle savedInstanceState) {
	if(savedInstanceState != null) {
        for(String key : savedInstanceState.keySet()) {
            Log.v("savedInstanceState key : " + key);
        }
	}
    super.onActivityCreated(icicle);

    // 뷰에 데이터를 넣는 작업 등을 할 추가할 수 있음
}
```

**onStart()**

이 메소드가 호출되면 화면의 모든 UI가 만들어진 지고 호출이 된다.

```java
@Override
    public void onStart() {
    	super.onStart();
    }
```

**onResume()**

이 메소드가 호출되고 난 다음에 사용자와 Fragment와 상호작용이 가능하다. 다시 말해서 이 곳에서 사용자가 버튼을 누르거나 하는 이벤트를 받을 수 있게 된다.

```java
@Override
public void onResume() {
	super.onResume();
}
```

**onPause()**

```java
@Override
public void onPause() {
  super.onPause();
}
```

**onSaveInstanceState()**

이 메소드에서는 Activity와 동일하게 Fragment가 사라질때 현재의 상태를 저장하고 나중에 Fragment가 돌아오면 다시 저장한 내용을 사용할 수 있게해주는 메소드이다.

```java
@Override
public void onSaveInstanceState(Bundle savedInstanceState) {
    super.onSaveInstanceState(savedInstanceState);
    savedInstanceState.putInt("text", "savedText");
}
```

**onStop()**

Fragment의 onStop() 메소드는 Activity의 onStop()메소드와 비슷하다. 이 콜백 메소드가 호출되면 Fragment가 더이상 보이지 않는 상태이고 더이상 Activity에서 Fragment에게 오퍼레이션을 할 수 없게 된다.

```java
@Override
public void onStop() {
	super.onStop();
}
```

**onDestroyView()**

Fragment의 View가 모두 소멸될 때 호출되는 콜백 메소드이다. 이때 View에 관련된 모든 자원들이 사라지게 된다.

```java
@Override
public void onDestroyView() {
	super.onDestroyView();
}
```

**onDestroy() **

Fragment를 더이상 사용하지 않을 때 호출되는 콜백 메소드이다.  하지만 Activity와의 연결은 아직 끊어진 상태는 아니다.

```java
@Override
public void onDestroy() {
	super.onDestroy();
}
```

**onDetach()**

Fragment가 더이상 Activity와 관계가 없을 때 두 사이의 연결을 끊으며 Fragment에 관련된 모든 자원들이 사라지게 된다.

```java
@Override
public void onDetach() {
	super.onDetach();
	activity = null;
}
```

Fragment의 생명주기를 테스트하기 위한 프로젝트를 만들어보자.
테스트를 위해서 android 4.0.3 기반으로 안드로이드 프로젝트를 생성했다(HAXM과 X86으로 빠른 에뮬레이터로 테스트하기 위해서이다. Fragment는 Android 3.0 이상부터 지원한다.) [HAXM(Hardware Accelerated Execution Manager) + Android Atom x86 이미지로 안드로이드 에뮬레이터 속도 빠르게하기](http://blog.saltfactory.net/187) 글을 참조해서 에뮬레이터 속도를 빠르게 설정한다. 설정이 완료되면 안드로이드 프로젝트를 추가한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/ca3ffb0e-2bf3-4cf3-b0df-36ea531decbd)

그리고 Activity를 만드는 화면에서 MasterDetailFlow를 선택한다. 그리고 Debug Configurations에 x86 AVD를 이용해서 빌드될 수 있게 한다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/91bc7ed9-5990-427c-b260-88a4a72cbefe)

에뮬레이터로 빌드해서 실행하게 되면 간단한 item의 목록이 나타나고 item을 선택하면 디테일화면으로 전환되는 예제이다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/9c1ae1cc-deae-439f-8238-35edb2d8e1c2)

디폴트로 생성된 클래스를 살펴보면 Fragment 클래스를 상속받아서 만든  ItemListFragment.java와 ItemDetailFragment.java가 생성된 것을 볼 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0cbf502c-1e64-4b3e-98b0-edc2d95cd7ff)

이후에 각 클래스마다 자세히 살펴볼 것이다. 클래스 이름에서도 상상이 되듯,  item의 목록을 나타내는 ItemListFragment가 있고 item을 select하게 되면 ItemDetailFragment가 나타나게 될 것이다.

Fragment가 Activity 안에서 어떻게 호출되는지 살펴보자.

이 테스트 앱은 ItemListActivity가 가장먼저 호출이 된다.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="net.hibrain.tutorial"
    android:versionCode="1"
    android:versionName="1.0" >

    <uses-sdk
        android:minSdkVersion="15"
        android:targetSdkVersion="15" />

    <application
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme" >
        <activity
            android:name=".ItemListActivity"
            android:label="@string/title_item_list" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity
            android:name=".ItemDetailActivity"
            android:label="@string/title_item_detail" >
            <meta-data
                android:name="android.support.PARENT_ACTIVITY"
                android:value=".ItemListActivity" />
        </activity>
    </application>

</manifest>
```

ItemListActivity를 살펴보자. 이 ItemListActivity는 activity_item_list라는 layout으로 ContentView를 구성한다. 이것은 /res/layout/activity_item_list.xml 파일을 가르키고 있다.

```java
package net.hibrain.tutorial;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

public class ItemListActivity extends FragmentActivity
        implements ItemListFragment.Callbacks {

    private boolean mTwoPane;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item_list);

        if (findViewById(R.id.item_detail_container) != null) {
            mTwoPane = true;
            ((ItemListFragment) getSupportFragmentManager()
                    .findFragmentById(R.id.item_list))
                    .setActivateOnItemClick(true);
        }
    }

    @Override
    public void onItemSelected(String id) {
        if (mTwoPane) {
            Bundle arguments = new Bundle();
            arguments.putString(ItemDetailFragment.ARG_ITEM_ID, id);
            ItemDetailFragment fragment = new ItemDetailFragment();
            fragment.setArguments(arguments);
            getSupportFragmentManager().beginTransaction()
                    .replace(R.id.item_detail_container, fragment)
                    .commit();

        } else {
            Intent detailIntent = new Intent(this, ItemDetailActivity.class);
            detailIntent.putExtra(ItemDetailFragment.ARG_ITEM_ID, id);
            startActivity(detailIntent);
        }
    }
}
```

activity_item_list.xml 파일을 살펴보자. 이 레이아웃은 Fragment를 사용할 수 있는 fragment 태그를 포함하고 있는데 ItemListActivity 에서 사용하게되는 것으로 net.hibrain.tutorial.ItemListFragment 에서 구현을 한 클래스를 참조하고 있다. 그리고 id는 item_list로 만들어지게 된다.

```xml
<fragment xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:name="net.hibrain.tutorial.ItemListFragment"
    android:id="@+id/item_list"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_marginLeft="16dp"
    android:layout_marginRight="16dp"
    tools:context=".ItemListActivity" />
```

더 자세한 코드는 나중에 살펴보기로 하고 위의 Fragment의 콜백 메소드를 테스트하기 위해서 Fragment마다 메소드들을 추가해서 Log를 작성해서 확인해보자.  

디폴트로 만들어진 ItemListFragment.java 파일에 다음 코드를 추가하자.

```java
package net.hibrain.tutorial;

import net.hibrain.tutorial.dummy.DummyContent;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class ItemListFragment extends ListFragment {

    private static final String STATE_ACTIVATED_POSITION = "activated_position";
    private static final String TAG = "saltfactorytutorial";
    private static final String CLASS_NAME ="ItemListFragment";

    private Callbacks mCallbacks = sDummyCallbacks;
    private int mActivatedPosition = ListView.INVALID_POSITION;

    public interface Callbacks {

        public void onItemSelected(String id);
    }

    private static Callbacks sDummyCallbacks = new Callbacks() {
        @Override
        public void onItemSelected(String id) {
        }
    };

    public ItemListFragment() {
    	Log.v(TAG, CLASS_NAME+ " : 생성자");
    }

    @Override
    public void onAttach(Activity activity) {

    	Log.v(TAG, CLASS_NAME +  ": onAttach(), activity : " + activity.getClass().getName());

        super.onAttach(activity);
        if (!(activity instanceof Callbacks)) {
            throw new IllegalStateException("Activity must implement fragment's callbacks.");
        }

        mCallbacks = (Callbacks) activity;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {

    	if(savedInstanceState != null) {
            for(String key : savedInstanceState.keySet()) {
                Log.v(TAG, CLASS_NAME + " : onCreate(Bundle savedInstanceState) : bundle key : " + key);
            }
    	} else {
    		Log.v(TAG, CLASS_NAME + " : onCreate(Bundle savedInstanceState) : bundle key is null");
    	}

        super.onCreate(savedInstanceState);
        setListAdapter(new ArrayAdapter<DummyContent.DummyItem>(getActivity(),
                R.layout.simple_list_item_activated_1,
                R.id.text1,
                DummyContent.ITEMS));
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
    	Log.v(TAG, CLASS_NAME + " : onViewCreated(View view, Bundle savedInstanceState) :  View : " + view.getClass().getName());

        super.onViewCreated(view, savedInstanceState);
        if (savedInstanceState != null && savedInstanceState
                .containsKey(STATE_ACTIVATED_POSITION)) {
        	 for(String key : savedInstanceState.keySet()) {
                 Log.v(TAG, CLASS_NAME + " : onViewCreated(View view, Bundle savedInstanceState) :  bundle key : " + key);
             }

            setActivatedPosition(savedInstanceState.getInt(STATE_ACTIVATED_POSITION));
        } else {
        	Log.v(TAG, CLASS_NAME + " : onViewCreated(View view, Bundle savedInstanceState) :  bundle is null");
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState){

    	if (savedInstanceState != null){
    		for(String key : savedInstanceState.keySet()) {
    			Log.v(TAG, CLASS_NAME + " : onActivityCreated(Bundle savedInstanceState) :  bundle key : " + key);
    		}
    	} else {
    		Log.v(TAG, CLASS_NAME + " : onActivityCreated(Bundle savedInstanceState) :  bundle key is null");
    	}

    	super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onStart(){
    	Log.v(TAG, CLASS_NAME +  ": onStart()");
    	super.onStart();
    }

    @Override
    public void onResume(){
    	Log.v(TAG, CLASS_NAME +  ": onResume()");
    	super.onResume();
    }

    @Override
    public void onPause(){
    	Log.v(TAG, CLASS_NAME +  ": onPause()");
    	super.onPause();
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {

    	if (outState != null){
    		for(String key : outState.keySet()) {
    			Log.v(TAG, CLASS_NAME + " : onSavedInstanceState(Bundle outState) :  bundle key : " + key);
    		}
    	} else {
    		Log.v(TAG, CLASS_NAME + " : onSavedInstanceState(Bundle outState) :  bundle key is null");
    	}


        super.onSaveInstanceState(outState);
        if (mActivatedPosition != ListView.INVALID_POSITION) {
            outState.putInt(STATE_ACTIVATED_POSITION, mActivatedPosition);
        }
    }

    @Override
    public void onStop() {
    	Log.v(TAG, CLASS_NAME +  ": onStop()");
    	super.onStart();
    }

    @Override
    public void onDestroyView() {
    	Log.v(TAG, CLASS_NAME + ": onDestroyView()");
    	super.onDestroyView();
    }

    @Override
    public void onDestroy() {
    	Log.v(TAG, CLASS_NAME + ": onDestroy()");
    	super.onDestroy();
    }

    @Override
    public void onDetach() {
    	Log.v(TAG, CLASS_NAME +  ": onDetach()");

        super.onDetach();
        mCallbacks = sDummyCallbacks;
    }

    @Override
    public void onListItemClick(ListView listView, View view, int position, long id) {
        super.onListItemClick(listView, view, position, id);
        mCallbacks.onItemSelected(DummyContent.ITEMS.get(position).id);
    }


    public void setActivateOnItemClick(boolean activateOnItemClick) {
        getListView().setChoiceMode(activateOnItemClick
                ? ListView.CHOICE_MODE_SINGLE
                : ListView.CHOICE_MODE_NONE);
    }

    public void setActivatedPosition(int position) {
        if (position == ListView.INVALID_POSITION) {
            getListView().setItemChecked(mActivatedPosition, false);
        } else {
            getListView().setItemChecked(position, true);
        }

        mActivatedPosition = position;
    }
}
```

이제 빌드하고 로깅을 살펴볼 차례이다. 우리는 안드로이드의 모든 로그가 필요 없다. TAG로 "satfactorytutorial"라고 지정했으니 이것을 필터해보자. 이클립스는 안드로이드를 개발하는데 많은 편리함을 준다.  Logcat을 확인하는 화면에서 filter를 추가할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/260db4bf-143b-412c-a737-db3317d1a492)

이렇게 로그의 필터를 추가하면 다음과 같이 설정이 된다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/f341943b-63a2-4f6a-a579-b3e06fb38680)

이제 빌드하고 실행해서 로그를 확인해보자.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/6c701e6e-604b-40b7-a210-d0cb93b2efd6)

## Fragment 실행 순서

로그로 확인하면 Fragment가 실행되면서 생성되는 순서를 보자.

```
최초 생성자를 호출 > onAttach() > onCreate() > onViewCreated() > onActivityCreated() > onStart() > onResume() 순으로 생성이된다.
```

아이템을 하나 선택해보자. 그러면 ItemDetailFragment가 실행될 것이다. 이 때 우리가 로깅하고 있는 ItemListFragment는 사라지게 되는데  다음 콜백 메소드를 순서대로 호출한다.

```
onPause() > onStop()
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/4206368f-fb8f-4036-bff0-257448b2c6d1)

ItemDetailFragment에서 백 버튼(Back Button)을 눌러서 다시 ItemListFragment로 돌아오면 다음 순서대로 콜백 메소드를 호출한다. 이때 새로 Fragment를 생성하면서 이전의 Fragment에 대한 자원을 모두 해지하고 새로 만든다.

```
onDestroyView() > onDestroy() > onDetach() > 생성자() > onAttach() > onCreate() > onViewCreate() > onStart() > onResume()
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/943ecede-57e0-447b-b41d-c71f26cdc86b)

그럼 Fragment를 매번 새로 생성시켜야 하는가하면 그런것은 아니다. 이 포스팅에서 말하는 것은 Fragment가 Activity 안에서 만들어지고, Activity 의 생명 주기처럼 Fragment에서도 생명주기가 있는데, 상태가 변화는 것에 따라 콜백 메소드가 호출되며 각각 콜백 메소드의 특성에 따라서 오퍼레이션을 추가할 수 있다는 것을 말하고 있다.
ItemDetailFragment 의 사용도 또하 동일한 방법으로 로깅을 해볼 수 있다. 다음 포스팅에서 Fragment를 이용해서 화면을 구성하는 방법에 대한 코드를 좀더 자세하게 살펴볼 예정이다.

## 참고

1. http://developer.android.com/reference/android/app/Fragment.html

