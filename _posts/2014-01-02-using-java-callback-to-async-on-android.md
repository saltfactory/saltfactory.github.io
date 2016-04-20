---
layout: post
title: 안드로이드 비동기 프로그램을 위해 Java로 Callback 구현하기
category: android
tags: [android, java, pattern, async, callback]
comments: true
redirect_from: /214/
disqus_identifier : http://blog.saltfactory.net/214
---

## 서론

Javascript로 프로그래밍을 할 때 가장 흥미로운 것이 바로 callback method를 파라미터로 넘겨서 call by name 으로 실행할 수 있다는 것이였다. 물론 다른 언어도 이런 function을 파라미너로 넘기로 실행할 수 있겠지만 다른 프로그램 언어로 프로그래밍을 할 때는 잘 사용하지 않았던 것을 javascript로 프로그래밍할 때는 자연스럽게 사용했던 것 같다. 연구소에서 iOS 개발을 하다가 android 어플을 개발하게 되었을 때 objective-c의 라이브러리에서 흔히 볼 수 있는 delegate pattern을 사용하여 개하는 코드를 Java의 interface로 objective-c의 delegate를 흉내내어 만들어 사용했다. 이때, delegate를 사용하기 위해서 interface에 메소드를 지정해야하는데 약간의 문제가 있었다. 바로 Java의 inaterface에 정의한 메소드들은 optional 할 수 없다는 말이다. 즉, interface에 지정한 메소드들은 모두 구현하는 객체에서 모두 구현하던지 비우던지 해야한다. 이 때문에 불필요한 코드가 많이 생성되는 문제를 겪었다. objective-c에서는 delegate 메소드를 구현하더라도 optional하게 사용할 수 있게 때문에 delegate를 보다 유연하게 사용할 수 있었다. 그래서 난 외부에서 구현메소드를 다른 객체의 메소드 안에 삽입해서 결합도를 난추고 외부에서 구체적인 메소드를 구현하면서도 여러곳에 사용할 수 있는 방법으로 코드를 변경하고 싶었는데 이때 Javascript에서 function을 파라미터로 넘겨서 구현체를 외부에서 작성하는 것에 대한 아이디어를 얻어서 Java Callback을 찾아보기로 했다.

<!--more-->

### JavaScript에서 Callback 사용

먼저 Javascript에서 힌트를 얻었던 callback 사용의 예제를 살펴보면 다음과 같다.

**1)  Javascript 일반 function 사용하는 예제**

```javascript
var SFApp = function(){
};

SFApp.prototype.start = function(message){
	console.log(message)
}

var app = new SFApp();
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/b0459b2d-7be0-493a-8ad7-f0579016bf34)

위와 같이 단순하게 SFApp 객체에 start라는 function을 사용해서 app이 시작될 때 message를 로깅하도록 하였다. 위의 간단한 코드는 다음과 같이 변경할 수 있다. 우리는 callback을 사용하기 원하기 때문에 function 하나를 선언하고 callback으로 호출하게 수정한다.

**2) Javascript 에서 function을 파라미터로 사용하는 예제**

```javascript
function callback(){
    console.log('hello callback in javascript');
}

var SFApp = function(){
};

SFApp.prototype.start = function(message, callback){
	console.log(message)

    if (callback && typeof(callback) === "function") {
        callback();
    }
}

var app = new SFApp();
app.start('saltfactory callback demo', callback);
```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/8b14ec9e-9629-4d6e-ab4f-9105a2c76bb9)

위 예제는 callback function을 만들어서 파라미터로 사용하는 예제 이다. callback을 객체에 넣고 사용할때 어떻게 사용할 수 있을까? 다음과 같이  proptype로 연결하거나 객체 안의 function도 파라미터로 넘겨서 callback을 사용할 수 있다.

```javascript
var SFCallback = function(){
}

SFCallback.prototype.callback = function(){
	console.log('hello callback in nodejs');
}


var SFApp = function(){
};

SFApp.prototype.start = function(message, callback){
	console.log(message)

    if (callback && typeof(callback) === "function") {
        callback();
    }
}

var app = new SFApp();
app.start('saltfactory callback demo', new SFCallback().callback);
```

### Java에서 Callback 사용

이젠 이와 동일한 방법을 Java에서 구현해보자. Javascript 객체의 function을 넘겨서 사용하듯 Javascript에서는 Interface를 사용해서 callback을 구현할 수 있다. 먼저 안드로이드 개발을 한다고 가정하자. 안드로이드 프로젝트를 만들어서 interface를 만든다.

### Callback 인터페이스 생성

```java
package net.saltfactory.tutorial.android.callback;

import java.io.Serializable;

/**
 * Created by saltfactory@gmail.com on 1/2/14.
 */
public interface SFCallback extends Serializable {
    public void callback();
}
```

생성한 Callback 인터페이스는 나중에 콜백이 필요할 때 new 생성자를 사용해서 호출하는 곳 외부에서 메소드를 상세 구현하여 넘기면 된다. 예를 들어서 안드로이드 앱이 실행되고 나서 두가지 숫자를 비교하는 `AynscTask`에서 작업을 마치고난 뒤, 구체적으로 구현한 callback 메소드를 실행하고 싶다고 생각하자.

#### AsyncTask 클래스 구현

예제로 준비한 `SFAsyncTaskComparedWithNumbers`는 두가지 숫자를 비교해서 `true`면 `successCallback`을 `fail`이면 `failCallback`을 호출하게 했다. 그리고 비교하기전에 사전처리를 위해서 `preprocessCallback`을 호출하게 했다. 이 모든 method의 구체적인 내용은 `AsyncTask`를 호출하는 `MainActivity`에서 구현할 것이다(즉, 사용하는 객체 내부에서 구현체를 구현하는 것이 아니라, 호출하는 외부에서 구현체를 구현할 것이다)

```java
package net.saltfactory.tutorial.android.task;

import android.os.AsyncTask;
import net.saltfactory.tutorial.android.callback.SFCallback;

/**
 * Created by saltfactory@gmail.com on 1/2/14.
 */
public class SFAsyncTaskComparedWithNumbers extends AsyncTask<Number, Void, Boolean> {

    private SFCallback preprocessCallback;
    private SFCallback successCallback;
    private SFCallback failCallback;

    public SFAsyncTaskComparedWithNumbers(SFCallback preprocessCallback, SFCallback successCallback, SFCallback failCallback){
        this.preprocessCallback = preprocessCallback;
        this.successCallback = successCallback;
        this.failCallback = failCallback;
    }

    @Override
    protected Boolean doInBackground(Number... numbers) {

        if (preprocessCallback != null){
            preprocessCallback.callback();
        }

        return numbers[0].equals(numbers[1]);
    }


    @Override
    protected void onPostExecute(Boolean success){
        if (success){
                successCallback.callback();
        } else {
            failCallback.callback();
        }
    }
}

```

#### MainActivity 구현

이제 실제로 사용할 callback 메소들의 실체를 호출하는 곳에서 필요한 형태로 구현해서 넘겨주는 작업을 한다.

```java
package net.saltfactory.tutorial.android;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import net.saltfactory.tutorial.android.callback.SFCallback;
import net.saltfactory.tutorial.android.task.SFAsyncTaskComparedWithNumbers;

public class MainActivity extends Activity {
    final private String TAG = "saltfactory.net";
    /**
     * Called when the activity@gmail.com is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        new SFAsyncTaskComparedWithNumbers(new SFCallback() {
            // preprecoessCallback 구현
            @Override
            public void callback() {
                Log.d(TAG, "call preprocessCallback from MainActivity");
            }
        },
        new SFCallback() {
            // successCallback 구현
            @Override
            public void callback() {
                Log.d(TAG, "call successCallback from MainActivity");
            }
        },
        new SFCallback() {
            // failCallback 구현
            @Override
            public void callback() {
                Log.d(TAG, "call failCallback from MainActivity");
            }
        }).execute(1, 1);

    }
}

```

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/0a449ed1-88dc-432b-a231-6610b213195f)

이렇게 callback 메소드를 외부에서 구체적으로 만들어서 사용할 수 있으니까 `SFCallback` 인터페이스는 여러가지 형태의 callback의 구현체로 사용할 수 있게 되는것이다. 만약 callback method로 파라미터를 받아서 호출하는 외부에서 좀더 자세한 구현을 하고 싶을 경우는 현재 callback의 인자가 없는데 callback 메소드의 인자로 내부에서 외부로 파라미터를 넘겨줘서 호출하는 곳에서 상세 구현을 하면 된다.

####  인자값을 가지는 callback

우선 callback에 인자값을 전달 할 수 있는 interface를 만든다. 여기서는 `SFCallbackWithParams` 라는 이름으로 만들었다. 그리고 callback 메소드에 HashMap을 인자로 넘길 수 있게 했다. 여러가지 데이터를 key, value 형태로 넣기 위해서 이다.

```java
package net.saltfactory.tutorial.android.callback;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by saltfactory on 1/2/14.
 */
public interface SFCallbackWithParams extends Serializable {
    public void callback(HashMap<String, Object> params);
}

```

이렇게 인자를 넘길 수 있는 callback을 위의 인자값이 없던 callback을 사용하던 `SFAsyncTaskComparedWithNumbers`에서 변경한다.

```java
package net.saltfactory.tutorial.android.task;

import android.os.AsyncTask;
import net.saltfactory.tutorial.android.callback.SFCallback;
import net.saltfactory.tutorial.android.callback.SFCallbackWithParams;

import java.util.HashMap;
import java.util.Observable;

/**
 * Created by saltfactory@gmail.com on 1/2/14.
 */
public class SFAsyncTaskComparedWithNumbers extends AsyncTask<Number, Void, Boolean> {

    private SFCallbackWithParams preprocessCallback;
    private SFCallbackWithParams successCallback;
    private SFCallbackWithParams failCallback;

    public SFAsyncTaskComparedWithNumbers(SFCallbackWithParams preprocessCallback, SFCallbackWithParams successCallback, SFCallbackWithParams failCallback){
        this.preprocessCallback = preprocessCallback;
        this.successCallback = successCallback;
        this.failCallback = failCallback;
    }

    @Override
    protected Boolean doInBackground(Number... numbers) {

        if (preprocessCallback != null){
            HashMap<String, Object>params = new HashMap<String, Object>();
            params.put("data", "preprocessCallback");
            preprocessCallback.callback(params);
        }

        return numbers[0].equals(numbers[1]);
    }


    @Override
    protected void onPostExecute(Boolean success){

        HashMap<String, Object>params = new HashMap<String, Object>();

        if (success){
                params.put("data", "successCallback");
                successCallback.callback(params);
        } else {
            params.put("data", "failCallback");
            failCallback.callback(params);
        }
    }
}
```

그리고 마지막으로 클래서 내부에서 처리한 데이터를 callback을 호출하는 외부에서 넘겨온 데이터를 가지고 어떻게 처리할지를 호출하는 곳에서 구현하면 된다.

```java
package net.saltfactory.tutorial.android;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import net.saltfactory.tutorial.android.callback.SFCallback;
import net.saltfactory.tutorial.android.callback.SFCallbackWithParams;
import net.saltfactory.tutorial.android.task.SFAsyncTaskComparedWithNumbers;

import java.util.HashMap;

public class MainActivity extends Activity {
    final private String TAG = "saltfactory.net";
    /**
     * Called when the saltfactory@gmail.com is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        new SFAsyncTaskComparedWithNumbers(new SFCallbackWithParams() {
            // preprecoessCallback 구현
            @Override
            public void callback(HashMap<String, Object> params) {
                Log.d(TAG, "call " + params.get("data") +" from MainActivity");
            }
        },
        new SFCallbackWithParams() {
            // successCallback 구현
            @Override
            public void callback(HashMap<String, Object> params) {
                Log.d(TAG, "call " + params.get("data") +" from MainActivity");
            }
        },
        new SFCallbackWithParams() {
            // failCallback 구현
            @Override
            public void callback(HashMap<String, Object> params) {
                Log.d(TAG, "call " + params.get("data") + " from MainActivity");
            }
        }).execute(1, 1);

    }
}

```

## 결론

이번 프로젝트에서 자바에서 Callback을 선택한 이유는 두가지 이다.

1. delegate pattern을 interface로 작성하니 optional을 지원하지 않아서 그 객체에 사용하지 않는 메소드까지 모두 구현해야해서 소스코드가 길어졌다.
2. AsyncTask나 Thread 등 비동기 처리를 다하고 난 다음에, 처리한 결과 데이터를 가지고 비동기 적으로 메소드를 실행해야하는 프로그램 코드가 많아졌고, 대부분 코드가 실행시키는 외부에서 구현이 되어지기 때문에 callback으로 처리하도록 하였다.

Javascript 기반의 어플리케이션을 개발하면서 사용하게 된 callback 형태를 Java에도 적용해봤는데, nodejs 등 비동기 처리 프로그램을 형태를 Java에도 적용시켜봤는데 UI thread를 비동기적으로 업데이트하는 안드로이드 프로그래밍에 callback은 참 유연하고 다양하게 사용될 수 있다는 것을 이번 프로젝트를 통해서 알게된 것 같다.


## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial

## 참고

1. Javascript에서 callback  구현하기, http://blog.saltfactory.net/192
2. http://www.javaworld.com/article/2077462/learn-java/java-tip-10--implement-callback-routines-in-java.html

