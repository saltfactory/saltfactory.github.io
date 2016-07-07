---
layout: post
title: PhoneGap(Cordova) 안드로이드 앱에서 외부 링크 새로운 브라우저 앱으로 열기
category: cordova
tags:
  - cordova
  - hybrid
  - hybridapp
  - phonegap
  - android
  - ionic
comments: true
images:
  title: 'http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/b8a17dba-2920-478c-9012-b5ab6f7deb6c'
---


## 서론

PhoneGap(Cordova)으로 만든 하이브리드 앱은 **WebView** 안에서 동작하기 때문에 앱 내의 링크가 아닌 외부 링크를 사용하면 앱이 사라지고 외부링크 페이지가 열리게 되는 문제가 있다. 이 문제를 간단하게 해결하기 위해 외부 링크를 클릭하면 외부링크 페이지가 앱의 **WebView**에서 열리지 않고 브라우저 앱을 통해 열릴 수 있는 방법을 앞에서 [PhoneGap(Cordova) 외부 링크(a link) 새창으로 열기](http://blog.saltfactory.net/hybridapp/solve-external-link-tag-in-phonegap.html) 라는 글로 소개를 한적이 있다. 이 글에서 iOS와 Android의 두가지 경우를 소개하였는데 Android 에서는 최신 Cordova 업데이트 이 후 이 글의 내용을 더이상 사용하지 못한다.  `appView.setWebViewClient()` 메소드를 더이상 사용할 수 없기 때문이다. 이 글에서는 최신 Cordova 버전에서 안드로이드 앱을 만들 때 안드로이드의 **shouldOverrideUrlLoading**를 사용하여 외부링크를 새로운 브라우저에 열리게 하는 방법을 소개한다.

<!--more-->

## Custom WebViewClient

가장 먼저 작업할 일은 [shouldOverrideUrlLoading](http://developer.android.com/reference/android/webkit/WebViewClient.html#shouldOverrideUrlLoading(android.webkit.WebView, java.lang.String))을 override 시킨  [WebViewClient](http://developer.android.com/reference/android/webkit/WebViewClient.html)를 만드는 것이다. 우리는 외부 링크를 클릭하면 새로운 브라우저를 열어서 링크를 열리게 할 것이다. 만약 이 작업을 하지 않고 Cordova 기반 하이브리드 앱 안에서 링크를 열면 앱 자체가 사라지고 링크의 페이지가 앱 안에 열리게 되는 끔찍한 일이 벌어진다. 다시 말하지만 Cordova 기반 하이브리드 앱은 HTML을 사용하여 뷰가 만들어지기 때문이다. HTML 뷰의 앱 안에서 링크를 클릭하면 새창을 띄워야 하는데 앱 안의 WebView에서는 새 창을 띄울수가 없다. 그래서 필요한 것이 바로 **shouldOverrideUrlLoading**이 호출될 때 외부 링크인 경우에 새로운 브라우저 앱으로 링크를 열도록 하는 것이다.

```java
class MyWebViewClient extends SystemWebViewClient {

    public MyWebViewClient(SystemWebViewEngine systemWebViewEngine) {
        super(systemWebViewEngine);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        Uri uri = Uri.parse(url);

        if (uri.getScheme().equals("http") || uri.getScheme().equals("https")) {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(uri);
            view.getContext().startActivity(intent);
            return true;
        } else {
            return super.shouldOverrideUrlLoading(view, url);
        }
    }
}
```

## MainActivity

Cordova 기반으로 하이브리드 앱을 만든다면 Android Plaform을 추가할 때 자동으로 **CordovaActivity**를 상속받은 **MainActivity**를 만들어준다. MainActivity는 사용자가 임의 이름으로 변경할 수 있는데 이것을 **AndroidManifest.xml**에 설정을 해주면 된다. 우리는 이 파일에서 WebView를 접근해 WebView에 우리가 정의한 **WebViewClient**를 설정하여 외부 링크를 클릭하면 새로운 브라우저가 열리게 할 것이다.

우선 이전 코드를 살펴보자. 이전 코드에서는  다음과 같이 **appView**를 사용하여 WebView  접근이 가능했고, WebView에 **shouldOverrideUrlLoading**을 정의하여 새로운 브라우저를 열리게 할 수 있었다.

```java
public class MainActivity extends CordovaActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        // Set by <content src="index.html" /> in config.xml

        super.init();

        this.appView.setWebViewClient(new CordovaWebViewClient(this, this.appView) {
@Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                Uri uri = Uri.parse(url);

                if (uri.getScheme().equals("http") || uri.getScheme().equals("https")){
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(uri);
                    startActivity(intent);
                    return true;
                } else {
                    return super.shouldOverrideUrlLoading(view, url);
                }
            }

        });


        super.loadUrl(Config.getStartUrl());
        //super.loadUrl("file:///android_asset/www/index.html");
    }

}
```

하지만 Cordova **5.0.0* 이상부터는 이전의 **appView**를 사용하는 방법으로 WebView에 접근할 수 없고 다음과 같이 **SystemWebViewEngine**을 사용하여 WebView에 접근할 수 있다.

```java
public class MainActivity extends CordovaActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Set by <content src="index.html" /> in config.xml
//        loadUrl(launchUrl);

        super.init();

        SystemWebViewEngine systemWebViewEngine = (SystemWebViewEngine) appView.getEngine();
        WebViewClient myWebViewClient = new MyWebViewClient(systemWebViewEngine);

        WebView webView = (WebView) systemWebViewEngine.getView();
        webView.setWebViewClient(myWebViewClient);

        super.loadUrl(launchUrl);

    }
}
```

## 결론

Cordova 앱에서 외부 링크를 브라우저로 열기 위한 방법은 기존의 [PhoneGap(Cordova) 외부 링크(a link) 새창으로 열기](http://blog.saltfactory.net/hybridapp/solve-external-link-tag-in-phonegap.html) 글과 동일하게 **shouldOverrideUrlLoading**를 정의한 **WebViewClient**를 만들어서 **appView** 의 **WebView**에 새롭게 정의한 WebViewClient를 사용하도록 하는 방법은 동일하다. 하지만 Cordova 5.0.0 이상부터는 기존의 **appView**에서 웹뷰를 전근하는 메소드를 사용할 수 없기 때문에 **SystemWebViewEngine**을 사용하여 웹뷰에 접근하는 방법을 사용해야한다. SDK는 보안의 문제와 성능의 문제로 이전에 사용할 수 있었던 메소드들이 Deprecated 되거나 사라지는 경우가 많다. SDK 버전이 올라갈 때 기존의 코드에 어떤 영향을 미치지는 확인하고 업데이트를 하거나 최신 SDK를 적용할 때 해결해야하는 문제를 빨리 파악하고 대처하는 것이 필요하다.


## 참고

1. http://stackoverflow.com/questions/29992669/accessing-appview-from-cordova-5-0-0
2. http://blog.saltfactory.net/hybridapp/solve-external-link-tag-in-phonegap.html
