---
layout: post
title : Java 에서 Interface를 사용하여 Callback 구현하기
category : java
tags : [java, interface, callback]
comments : true
redirect_from: /191/
disqus_identifier : http://blog.saltfactory.net/191
---

## 서론

프로그래밍에서 꽤 유용한 기능들이 있는데 그중에서 하나가 바로 Callback 이라는 것이다. Callback은 Windows 개발자라면 익히들 알고 있지만 Java 개발자라면 어쩌면 낯선 단어일수도 있다. 하지만 Java 개발자들에게 Listner와 비슷한거라고 하면 대략적인 Callback의 의미를 상상할 수 있을거라 예상된다. 보통 Callback과 Listener는 어떠한 일을 처리하기 위해서 프로세스가 진행하는 도중에 다른 이벤트 처리에 사용하기 때문이다. 하지만 은밀히 말하면 이 두가지는 디자인 패턴(Pattern)이 다르다. Callback은 Command Pattern을 따르고 있고 Listener는 Observer Pattern을 따르고 있기 때문이다. 이 두가지의 차이점은 나중에 다른 포스팅에서 Listener를 설명하면서 다시 한번 자세히 언급하겠다.

일반적으로 프로그래밍에서 Callback 이라는 용어를 다음과 같이 이야기 한다.

> 호출자(Caller)가 피호출자(Callee)를 호출하는 것이 아니라 피호출자(Callee)가 호출자(Caller)를 호출하는 것을 말한다.

(참조 http://cafe.naver.com/devctrl.cafe?iframe_url=/ArticleRead.nhn%3Farticleid=1727)

위키에서는 다음과 같이 정의하고 있다.

> 프로그래밍에서 콜백(callback)은 다른 코드의 인수로서 넘겨받는 서브루틴이다. 이를 통해 높은 수준의 층에 정의된 서브루틴(또는 함수)을 낮은 수준의 추상화층이 호출할 수 있게 된다. 일반적으로 먼저 높은 수준의 코드가 낮은 수준의 코드에 있는 함수를 호출할 때, 다른 함수의 포인터나 핸들을 넘겨준다. 낮은 수준의 함수를 실행하는 동안에 그 넘겨받은 함수를 적당히 회수, 호출하고, 부분 작업을 실행하는 경우도 있다. 다른 방식으로는 낮은 수준의 함수는 넘겨받은 함수를 '핸들러'로서 등록하고, 낮은 수준의 층에서 비동기적으로(어떠한 반응의 일부로서) 다음에 호출하는데 사용한다. 콜백은 폴리모피즘과 제네릭프로그래밍의 단순화된 대체 수법이며, 어떤 함수의 정확한 동작은 그 낮은 수준의 함수에 넘겨주는 함수 포인터(핸들러)에 의해 바뀐다. 이것은 코드 재사용을 하는 매우 강력한 기법이라고 말할 수 있다.

위의 정의에서 보듯 callback은 포인터나 핸들러를 넘겨줘서 피호출자(Callee)가 호출자(Caller)를 호출하는 기법으로 코드 재상용이 가능하고, 비동기적으로 처리할 수 있으며 함수를 추상화 할 수 있기 때문에 UI나 비동기 처리 시스템에서 callback 기법을 많이 사용한다.

<!--more-->

## Android에서 Callback

왜 Java에서 Callback을 포스팅하는가 하면 바로 Android 앱을 개발할 때 Fragment를 테스트하기 위한 샘플 코드를 만들게 되면 Activity와 Fragment가 바로 Callback을 사용하고 있기 때문이다. 아래는 이클립스에서 Fragment를 이용한 예제를 샘플로 만들면 만들어지는 코드이다.

```java
package net.saltfactory.tutorial;

import net.saltfactory.tutorial.dummy.DummyContent;

import android.R;
import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;


public class ItemListFragment extends ListFragment {

    private static final String STATE_ACTIVATED_POSITION = "activated_position";

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
    }

   ... 생략 ...

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        if (!(activity instanceof Callbacks)) {
            throw new IllegalStateException("Activity must implement fragment's callbacks.");
        }

        mCallbacks = (Callbacks) activity;
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mCallbacks = sDummyCallbacks;
    }

    @Override
    public void onListItemClick(ListView listView, View view, int position, long id) {
        super.onListItemClick(listView, view, position, id);
        mCallbacks.onItemSelected(DummyContent.ITEMS.get(position).id);
    }

    ... 생략
```


위 코드를 자세히 살펴보면 Callback을 사용하기 위해서 Java의 Interface를 사용한 것을 확인 할 수 있다.

## Interface를 사용하여 Callback 구현

Java에서는 Callback을 사용하기 위해서 interface를 사용한다. 좀더 이해를 돕기 위해서 다음 코드를 살펴보자.

처음으로 살펴볼 것은 Callback을 사용할 수 있는 Interface를 만드는 것이다. 그리고 그 안에는 callbackMethod를 추가한다.

```java
/**
 * filename : CallbackEvent.java
 *
 */
package net.saltfactory.tutorial;

public interface CallbackEvent {
	public void callbackMethod();
}
```

다음은 Callback을 외부에서 Callback method를 등록할 수 있는 EventRegistration 을 만든다. 이때 생성자에서 Callback으로 구현된 객체를 외부에서 전달 받아서 EventRegistration의 doWork() 메소드에서 외부에서 정의한 callbackMethod를 실행하게 한다.


```java
/**
 * filename : EventRegistration.java
 *
 */

package net.saltfactory.tutorial;

public class EventRegistration {
	private CallbackEvent callbackEvent;

	public EventRegistration(CallbackEvent event){
		callbackEvent = event;
	}

	public void doWork(){
		callbackEvent.callbackMethod();
	}
}
```

다음은 Main에서 호출자(Caller)와 피호출자(Callee)를 만들어서 콜백을 테스트한다. 아래와 같이 호출자(caller)에 구현된 callbackMethod를 등록해서 피호출자(callee)가 호출자(caller)에 구현된 callbackMethod를 실행할 수 있게 되었다.

```java
/**
 * filename :EventApplication.java
 *  
 */

package net.saltfactory.tutorial;

public class EventApplication {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		CallbackEvent callbackEvent = new CallbackEvent(){

			@Override
			public void callbackMethod() {
				// TODO Auto-generated method stub
				System.out.println("call callback method from callee");
			}

		};

		EventRegistration eventRegistration = new EventRegistration(callbackEvent);
		eventRegistration.doWork();
	}

}
```

이 코드를 실행하면 다음과 같은 결과를 확인 할 수 있다.

![](http://hbn-blog-assets.s3.ap-northeast-2.amazonaws.com/saltfactory/images/5ceb0086-f4c6-4033-a3e4-26490052248c)

이 코드를 유사하게 Android에서는 Activity와 Fragment에 Callback을 사용하고 있는데 이는 Fragment는 반드시 Activity를 가져야하고 Fragment는 Activity의 메소드를 비동기적으로 요청해야하기 때문이다. 이와 같은 상황을 콜백메소드를 이용해서 비동기적인 문제를 해결하고 코드를 재사용할 수 있게 Java의 Interface를 사용해서 Callback을 구현한 것이다.

## 결론

Callback은 호출자(Caller)에서 구현한 메소드를 피호출자(Callee)가 호출해서 사용할 수 있다. 이렇게 외부에서 메소드를 구현화 시키기 때문에 코드의 재사용성이 높아진다. 그리고 Callback는 피호출자(Callee)가 호출자(Caller)에게 비동기적으로 메세지를 보내어서 데이터처리를 비동기 적으로 처리할 수 있는 장점을 가진다.   자바에서 이러한 Callback 구현은 Java의 Interface의 특징을 이용하여 구현할 수 있다.

## 참고

1. http://blog.danieldee.com/2009/06/callback-vs-listener.html
2. http://cafe.naver.com/devctrl.cafe?iframe_url=/ArticleRead.nhn%3Farticleid=1727
3. http://ko.wikipedia.org/wiki/콜백
4. http://www.javaworld.com/javatips/jw-javatip10.html

