---
layout: post
title: 안드로이드에서 https 요청 구현하기
category: android
tags: [android, https, sslsocketfactory, httpsurlconnection]
comments: true
redirect_from: /220/
disqus_identifier : http://blog.saltfactory.net/220
---

## 서론

현재 시중에 나와 있는 안드로이드 책은 모두 Http로 데이터를 요청하는 예제만 수록하고 있다. 하지만 안드로이드 앱을 개발할 때 http 요청만 처리하는 것이 아니다. https 요청을 http와 동일하게 사용할수는 없다. 이번 프로젝트에서 https로 로그인 관련 작업을 하면서 우리가 안드로이드를 개발할 때 흔히 사용하는 **HttpClient**로 https를 요청할 수 없다는 것을 확인하고 방법을 찾아서 해결했는데 그 방법에 대해서 포스팅하고자 한다.

<!--more-->

### Https 서버구축

첫번째로 우리가 해야할 일은 Https 서버를 구축해야한다. 하지만 개인 앱 개발자는 대부분 서버를 가지고 있지 않거나, 서버 작업을 하기 힘든 상황이다. 그래서 이전 포스팅에 OpenSSL과 Node.js를 사용해서 Https 서버를 구축할 수 있는 방법을 소개했다. http://blog.saltfactory.net/221 글을 참조해서 Https 서버를 만들어보자. https로 로그인하는 예제를 만들것이기 때문에 다음과 같이 POST로 /login 요청이 들어오는 부분을 수정한다.

```javascript
var http=require('http'),
	https = require('https'),
	express = require('express'),
 	fs = require('fs');

var options = {
	key: fs.readFileSync('key.pem'),
	cert: fs.readFileSync('cert.pem')
};


var port1 = 80;
var port2 = 443;

var app = express();
app.use(express.urlencoded());
app.use(express.logger());

http.createServer(app).listen(port1, function(){
  console.log("Express server listening on port " + port1);
});


https.createServer(options, app).listen(port2, function(){
  console.log("Express server listening on port " + port2);
});


app.get('/', function (req, res) {
	res.writeHead(200, {'Content-Type' : 'text/html'});
	res.write('<h3>Welcome</h3>');
	res.write('<a href="/login">Please login</a>');
	res.end();
});

app.get('/login', function (req, res){
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write('<h3>Login</h3>');
	res.write('<form method="POST" action="/login">');
	res.write('<label name="userId">UserId : </label>')
	res.write('<input type="text" name="userId"><br/>');
	res.write('<label name="password">Password : </label>')
	res.write('<input type="password" name="password"><br/>');
	res.write('<input type="submit" name="login" value="Login">');
	res.write('</form>');
	res.end();
})

// app.post('/login', function (req, res){
// 	var userId = req.param("userId");
// 	var password = req.param("password")
//
// 	res.writeHead(200, {'Content-Type': 'text/html'});
// 	res.write('Thank you, '+userId+', you are now logged in.');
// 	res.write('<p><a href="/"> back home</a>');
// 	res.end();
// });

app.post('/login', function (req, res){
		var userId = req.param("userId");
		var password = req.param("password")

	res.json({userId:userId, password:password});
});
```

### 테스트 프로젝트 생성 및 HttpClient 요청

Https 요청을 테스트하기 위해서 간단한 안드로이드 프로젝트를 생성한다. 버튼을 가지고 있고 버튼을 누르면 https를 요청하는 간단한 예제이다. 최종 소스코드는 github에 공개할 예정이다. 우선 간단히 안드로이드 프로젝트를 생성해서 onCreate 메소드 안에 다음과 같이 버튼을 클릭할때 온클릭 리스너를 등록한다. 서버로 넘기는 데이터는 userId와 password 이다. 서버로 데이터를 넘기면 json 데이터를 받아와서 console에 출력하는 간단한 코드이다.

#### HttpClient를 DefaultHttpClient로 요청

흔히 우리가 http 요청을 처리할 때 DefaultHttpClient를 사용한다. 다음 코드는 HttpClient를 DefaultHttpClient로 사용하는 예제이다.
여기서 urlString은 여러분들이 테스트하는 ip를 입력하면 된다. 공유기로 사설네트워크에서 테스트를 진행했기 때문에 현재 맥북프로의 http 서버 ip는 192.168.1.101 이다.

```java
public class MyActivity extends Activity {
    final String TAG = "saltfactory.net";

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Button buttonGet = (Button) findViewById(R.id.sf_button_post);
        buttonGet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Thread thread = new Thread() {
                    @Override
                    public void run() {
                        HttpClient httpClient = new DefaultHttpClient();


                        String urlString = "http://192.168.1.101/login";
                        try {
                            URI url = new URI(urlString);

                            HttpPost httpPost = new HttpPost();
                            httpPost.setURI(url);

                            List<BasicNameValuePair> nameValuePairs = new ArrayList<BasicNameValuePair>(2);
                            nameValuePairs.add(new BasicNameValuePair("userId", "saltfactory"));
                            nameValuePairs.add(new BasicNameValuePair("password", "password"));

                            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));


                            HttpResponse response = httpClient.execute(httpPost);
                            String responseString = EntityUtils.toString(response.getEntity(), HTTP.UTF_8);

                            Log.d(TAG, responseString);

                        } catch (URISyntaxException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        } catch (ClientProtocolException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        } catch (IOException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        }

                    }
                };


                thread.start();
            }
        });

    }

}
```

결과는 다음과 같다. 단순하게 http요청을 DefaultHttpClient로 요청한 데이터는 POST를 정상적으로 처리하고 응답을 json으로 받아 왔다.

![](http://asset.hibrainapps.net/saltfactory/images/7f12c30f-841f-497e-a661-855c618728c5)

그러면 http 요청이 아닌 https를 DefaultHttpClient로 요청하면 어떤 결과가 나타나는지 살펴보자. urlString을 http://에서 https://로 변경하고 실행한다.

![](http://asset.hibrainapps.net/saltfactory/images/fd0a8101-e10e-438a-92dd-8fbff26f8e1c)

결과는 No Peer Certificate라는 에러를 발생시키면서 요청을 제대로 완료하지 못한다는 것을 확인할 수 있다. 왜냐면 https는 인증서를 인증하는 과정이 있어야하는데 http는 단순 http 요청만 처리하기 때문이다.

#### HttpClient에 SSLSocketFactory 속성 추가

흔히 우리가 Http 요청을 할 때 사용하는 HttpClient는 DefaultHttpClient 이다. 하지만 이렇게 구현하면 Https 요청을 할 수 없다. 그래서 HttpClient에 SSLSocketFactory를 사용해서 SSL 인증을 할 수 있도록 속성을 추가한다. 먼저 SSLSocketFactory를 상속받아 다음과 같이 SSLSocketFactory를 만든다.

```java
package net.saltfactory.tutorial.httpsdemo;

import org.apache.http.conn.ssl.SSLSocketFactory;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

/**
 * Created by saltfactory on 1/27/14.
 */
public class SFSSLSocketFactory extends SSLSocketFactory {
    SSLContext sslContext = SSLContext.getInstance("TLS");

    public SFSSLSocketFactory(KeyStore truststore) throws NoSuchAlgorithmException, KeyManagementException, KeyStoreException, UnrecoverableKeyException {
        super(truststore);

        TrustManager tm = new X509TrustManager() {
            public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
            }

            public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
            }

            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }


        };

        sslContext.init(null, new TrustManager[]{tm}, null);
//        sslContext.init(null, new TrustManager[] { tm }, new SecureRandom());
    }

    @Override
    public Socket createSocket(Socket socket, String host, int port, boolean autoClose) throws IOException, UnknownHostException {
        return sslContext.getSocketFactory().createSocket(socket, host, port, autoClose);
    }

    @Override
    public Socket createSocket() throws IOException {
        return sslContext.getSocketFactory().createSocket();
    }
}
```

다음은 https를 요청하기 위해서 DefaultHttpClient를 생성한 곳에 다음과 같이 수정한다.

```java
package net.saltfactory.tutorial.httpsdemo;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.List;

public class MyActivity extends Activity {
    final String TAG = "saltfactory.net";

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Button buttonGet = (Button) findViewById(R.id.sf_button_post);
        buttonGet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Thread thread = new Thread() {
                    @Override
                    public void run() {
                        //HttpClient HttpClient = new DefaultHttpClient();
                        HttpClient httpClient = getHttpClient();


                        String urlString = "https://192.168.1.101/login";
                        try {
                            URI url = new URI(urlString);

                            HttpPost httpPost = new HttpPost();
                            httpPost.setURI(url);

                            List<BasicNameValuePair> nameValuePairs = new ArrayList<BasicNameValuePair>(2);
                            nameValuePairs.add(new BasicNameValuePair("userId", "saltfactory"));
                            nameValuePairs.add(new BasicNameValuePair("password", "password"));

                            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));


                            HttpResponse response = httpClient.execute(httpPost);
                            String responseString = EntityUtils.toString(response.getEntity(), HTTP.UTF_8);

                            Log.d(TAG, responseString);

                        } catch (URISyntaxException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        } catch (ClientProtocolException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        } catch (IOException e) {
                            Log.e(TAG, e.getLocalizedMessage());
                            e.printStackTrace();
                        }

                    }
                };

                thread.start();
            }
        });


    }

    private HttpClient getHttpClient() {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);

            SSLSocketFactory sf = new SFSSLSocketFactory(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);

            return new DefaultHttpClient(ccm, params);
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
    }
}
```

이렇게 코드를 SFSSLFactory를 추가해서 HttpClient에 Scheme을 두가지로 추가했다. http와 https를 처리할 수 있는 Scheme을 가지게 하였고 SSL 인증을 TLS로 HostNameVerifier를 처리하게 했다. 이제 다시 실행을 해보자.

![](http://asset.hibrainapps.net/saltfactory/images/486e4dca-a1be-4da5-8f30-49631b5811ed)

정상적으로 https로 데이터를 요청해서 응답을 받아 온 것을 확인할 수 있다. WireShark로 패킷을 캡쳐해보면 테스트를 진행한 안드로이드 디바이스에서 https로 요청했고 TLS로 보안 요청을 처리한 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/22d27b8c-a027-4661-81b0-ddc63ed8fe35)

### HttpURLConnection 사용

안드로이드에서 Http 요청을 처리하는데 HttpClient를 사용하는 방법 말고 또다른 방법이 있는데 바로 HttpURLConnection을 사용하는 방법이다. 위에서 DefaultHttpClient를 사용한 코드를 다음과 같이 HttpURLConnection으로 변경한다.

```java
@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Button buttonGet = (Button) findViewById(R.id.sf_button_post);
        buttonGet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Thread thread = new Thread() {
                    @Override
                    public void run() {
//                      HttpClient HttpClient = new DefaultHttpClient();


                        String urlString = "http://192.168.1.101/login";
//                        try {
//                            URI url = new URI(urlString);
//
//                            HttpPost httpPost = new HttpPost();
//                            httpPost.setURI(url);
//
//                            List<BasicNameValuePair> nameValuePairs = new ArrayList<BasicNameValuePair>(2);
//                            nameValuePairs.add(new BasicNameValuePair("userId", "saltfactory"));
//                            nameValuePairs.add(new BasicNameValuePair("password", "password"));
//
//                            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
//
//
//                            HttpResponse response = httpClient.execute(httpPost);
//                            String responseString = EntityUtils.toString(response.getEntity(), HTTP.UTF_8);
//
//                            Log.d(TAG, responseString);
//
//                        } catch (URISyntaxException e) {
//                            Log.e(TAG, e.getLocalizedMessage());
//                            e.printStackTrace();
//                        } catch (ClientProtocolException e) {
//                            Log.e(TAG, e.getLocalizedMessage());
//                            e.printStackTrace();
//                        } catch (IOException e) {
//                            Log.e(TAG, e.getLocalizedMessage());
//                            e.printStackTrace();
//                        }
//
                        try {
                            URL url = new URL(urlString);

                            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                            connection.setRequestMethod("POST");
                            connection.setDoInput(true);
                            connection.setDoOutput(true);

                            List<BasicNameValuePair> nameValuePairs = new ArrayList<BasicNameValuePair>(2);
                            nameValuePairs.add(new BasicNameValuePair("userId", "saltfactory"));
                            nameValuePairs.add(new BasicNameValuePair("password", "password"));

                            OutputStream outputStream = connection.getOutputStream();
                            BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
                            bufferedWriter.write(getURLQuery(nameValuePairs));
                            bufferedWriter.flush();
                            bufferedWriter.close();
                            outputStream.close();

                            connection.connect();


                            StringBuilder responseStringBuilder = new StringBuilder();
                            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK){
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                                for (;;){
                                    String stringLine = bufferedReader.readLine();
                                    if (stringLine == null ) break;
                                    responseStringBuilder.append(stringLine + '\n');
                                }
                                bufferedReader.close();
                            }

                            connection.disconnect();

                            Log.d(TAG, responseStringBuilder.toString());



                        } catch (MalformedURLException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }


                    }
                };

                thread.start();
            }
        });
    }

    private String getURLQuery(List<BasicNameValuePair> params){
        StringBuilder stringBuilder = new StringBuilder();
        boolean first = true;

        for (BasicNameValuePair pair : params)
        {
            if (first)
                first = false;
            else
                stringBuilder.append("&");

            try {
                stringBuilder.append(URLEncoder.encode(pair.getName(), "UTF-8"));
                stringBuilder.append("=");
                stringBuilder.append(URLEncoder.encode(pair.getValue(), "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }

        return stringBuilder.toString();
    }

```

디바이스에서 실행을 해보자. 앞에서 HttpClient에 DefaultHttpClient로 요청한 결과를 HttpURLConnection으로 동일하게 받을 수 있는 것을 확인할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/10322d3a-234d-477f-806d-ec89d1eb6b2d)


### HttpsURLConnection을 사용하기

앞에서 살펴봤듯 안드로이드에서 http요청을 HttpClient를 사용하는 대신에 HttpURLConnection을 사용하듯, Https를 요청하는 방법은 HttpClient를 SSLSocketFactory를 사용하는 방법 말고도 HttpsURLConnection을 이용하는 방법이 있다. 위의 HttpURLConnection을 사용한 코드를 다음과 같이 수정한다.

```javascript
package net.saltfactory.tutorial.httpsdemo;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import javax.net.ssl.*;
import java.io.*;
import java.net.*;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.List;

public class MyActivity extends Activity {
    final String TAG = "saltfactory.net";

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Button buttonGet = (Button) findViewById(R.id.sf_button_post);
        buttonGet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Thread thread = new Thread() {
                    @Override
                    public void run() {
                        //HttpClient HttpClient = new DefaultHttpClient();
//                        HttpClient httpClient = getHttpClient();

                        String urlString = "https://192.168.1.101/login";

                        try {
                            URL url = new URL(urlString);

//                            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

                            trustAllHosts();

                            HttpsURLConnection httpsURLConnection = (HttpsURLConnection) url.openConnection();
                            httpsURLConnection.setHostnameVerifier(new HostnameVerifier() {
                                @Override
                                public boolean verify(String s, SSLSession sslSession) {
                                    return true;
                                }
                            });

                            HttpURLConnection connection = httpsURLConnection;

                            connection.setRequestMethod("POST");
                            connection.setDoInput(true);
                            connection.setDoOutput(true);

                            List<BasicNameValuePair> nameValuePairs = new ArrayList<BasicNameValuePair>(2);
                            nameValuePairs.add(new BasicNameValuePair("userId", "saltfactory"));
                            nameValuePairs.add(new BasicNameValuePair("password", "password"));

                            OutputStream outputStream = connection.getOutputStream();
                            BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
                            bufferedWriter.write(getURLQuery(nameValuePairs));
                            bufferedWriter.flush();
                            bufferedWriter.close();
                            outputStream.close();

                            connection.connect();


                            StringBuilder responseStringBuilder = new StringBuilder();
                            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK){
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                                for (;;){
                                    String stringLine = bufferedReader.readLine();
                                    if (stringLine == null ) break;
                                    responseStringBuilder.append(stringLine + '\n');
                                }
                                bufferedReader.close();
                            }

                            connection.disconnect();

                            Log.d(TAG, responseStringBuilder.toString());



                        } catch (MalformedURLException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }


                    }
                };

                thread.start();
            }
        });

    }

    private static void trustAllHosts() {
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[]{};
            }

            @Override
            public void checkClientTrusted(
                    java.security.cert.X509Certificate[] chain,
                    String authType)
                    throws java.security.cert.CertificateException {
                // TODO Auto-generated method stub

            }

            @Override
            public void checkServerTrusted(
                    java.security.cert.X509Certificate[] chain,
                    String authType)
                    throws java.security.cert.CertificateException {
                // TODO Auto-generated method stub

            }
        }};

        // Install the all-trusting trust manager
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection
                    .setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getURLQuery(List<BasicNameValuePair> params){
        StringBuilder stringBuilder = new StringBuilder();
        boolean first = true;

        for (BasicNameValuePair pair : params)
        {
            if (first)
                first = false;
            else
                stringBuilder.append("&");

            try {
                stringBuilder.append(URLEncoder.encode(pair.getName(), "UTF-8"));
                stringBuilder.append("=");
                stringBuilder.append(URLEncoder.encode(pair.getValue(), "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }

        return stringBuilder.toString();
    }


}
```

이제 디바이스에서 실행을 해보자. 다음과 같이 HttpURLConnection을 실행한 결과와 동일하게 동작하는 것을 확인 할 수 있다.

![](http://asset.hibrainapps.net/saltfactory/images/b8c54243-42fb-472a-bbc4-068be99ab807)


## 결론

우리는 안드로이드 앱을 개발할 때 Http 요청을 HttpClient를 사용했다. 그리고 DefaultHttpClient를 사용해서 POST나 GET 요청을 했는데 Http 요청은  HttpURLConnection으로도 할 수 있다는 것을 확인 했다. 하지만 Https는 DefaultHttpClient와 HttpURLConnection을 사용할 수 없다. 이유는 인증처리하는 속성이 있어야하는데 DefaultHttpClient와 HttpURLConnection은 SSL 인증 처리가 없기 때문이다. 그래서 HttpClient에 SSLSocketFactory를 사용했고 HttpURLConnection을 HttpsURLConnection으로 사용해서 인증처리 속성을 가지게 할 수 있다는 것을 확인했다.


## 소스코드

* https://github.com/saltfactory/saltfactory-android-tutorial/tree/sf-https-demo

## 참고

1. http://stackoverflow.com/questions/9767952/how-to-add-parameters-to-httpurlconnection-using-post
2. http://cafe.naver.com/jzsdn/21091
3. http://stackoverflow.com/questions/2642777/trusting-all-certificates-using-httpclient-over-https

