---
layout: post
title: SQLite3를 이용하여 안드로이드 디바이스의 데이터베이스 디버깅하기
category: android
tags: [android, database, sqlite3, debugging]
comments: true
redirect_from: /217/
disqus_identifier : http://blog.saltfactory.net/217
---

## 서론

![](http://cfile7.uf.tistory.com/image/23277D3C52D89AD230AB96)

안드로이드 개발을 하면 emulator로 개발하는 개발자는 거의 없을것 같기도 하다. 이유는 안드로이드 에뮬레이터 속도가 정말 답답하게 느리기 때문이다. 뿐만 아니라 개발을 할 때 반드시 디바이스에 디버깅을 해야하는 경우도 있다. 이럴때, 안드로이드 앱 안의 데이터베이스에 접근할 때 문제가 생긴다. 그렇다고 매번 emualtor에서 데이터베이스를 조회하고 다시 디바이스로 빌드한다면 개발에 상당히 불편함을 느낀다. 이를 해결하기 위한 방법을 찾아서 개발에 직접 사용하고 있는 방법을 포스팅하기로 한다.

<!--more-->

### emulator 안에서 SQLite3 사용해서 데이터베이스 접근

먼저 emulator를 사용해서 개발할 때 adb로 접근해서 SQLite3를 사용하는 방법을 살펴보자. 테스트를 하기 위해서 안드로이드에서 데이터베이스를 사용하는 간단한 예제 프로젝트를 만들었다. 소스코드는 간단하다. strings.xml에 있는 문자열 배열을 읽어와서 테이블에 contact 정보를 입력하는 것이다.

프로젝트 소스코드는 github에서 공유하니 clone 받아서 테스트하면 된다.
소스코드 : https://github.com/saltfactory/saltfactory-android-tutorial/tree/sf-sqlite3-demo

```java
package net.saltfactory.tutorial.sqlite3demo;

import android.app.Activity;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;

public class MyActivity extends Activity {
    final String databaseName = "sf_db_sqlite3_demo.db";
    final String tableName = "sf_tb_contacts";

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        SQLiteDatabase database = null;
        if (database == null) {
            database = openOrCreateDatabase(databaseName, SQLiteDatabase.CREATE_IF_NECESSARY, null);
            database.execSQL("DROP TABLE " + tableName);
            database.execSQL("CREATE TABLE " + tableName + " (id INTEGER, contact TEXT)");
            database.execSQL("DELETE FROM " + tableName);


            String[] contacts = getResources().getStringArray(R.array.contacts);

            int i = 1;
            for (String contact : contacts) {
                database.execSQL("INSERT INTO " + tableName + "(id, contact) values (" + i + ", '" + contact + "')");
                i++;
            }
        }

        database.close();

    }
}
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">sf-sqlite3-demo</string>
    <string-array name="contacts">
        <item>saltfactory@gmail.com</item>
        <item>http://blog.saltfactory.net</item>
        <item>http://twitter.com/saltfactory</item>
        <item>http://facebook.com/salthub</item>
    </string-array>
</resources>
```

emulator를 실행해보자. emulator를 실행하고 난 뒤 터미널에서 adb로 접근하기 위해서 emulator 정보를 확인한다. 현재 안드로이드 개발중인 디바이스의 목록을 보기 위해서는 adb 명령어로 확인할 수 있다. `adb` 명령어는 안드로이드 sdk 디렉토리 밑에 `platform-tools` 안에 존재한다.

```
./adb devices
```

![](http://cfile24.uf.tistory.com/image/233B384352E1DA16046C37)

우리는 emulator를 실행했기 때문에 emulator-5554 라는 디바이스가 목록에 나타나게 된다. 이 디바이스에서 접근하기 위해서는 다음과 같이하면 된다.
```
./adb -s emulator-5554 shell
```

![](http://cfile6.uf.tistory.com/image/217E054452E1F13C0D8B4F)

이제 우리가 원하는 데이터베이스에 접근을 해보자. 개발중이 앱에서 사용하고 있는 데이터베이스에 접근하기 위해서는 다음과 같이 하면 된다.

```
cd data/data/{앱 패지키 이름}/databases
cd data/data/net.saltfactory.tutorial.sqlite3demo/databases
```

![](http://cfile9.uf.tistory.com/image/2228FA3452E1F24E364991)

위의 예제 코드에서 우리는 sf_db_sqlite3_demo.db 라는 sqlite 데이터베이스를 만들어 사용했기 때문에 앱이 가지고 있는 데이터베이스에 sf_db_sqlite3_demo.db 라는 파일이 보일 것이다. 이젠 이 데이터베이스 파일에 sqlite3로 접근해보자.

```
sqlite3 sf_db_sqlite3_demo.db
```

![](http://cfile21.uf.tistory.com/image/266C3A4752E201402C0D92)

이렇게 emulator에서는 sqlite3로 앱 개발하고 있는 데이터베이스에 접근할 수 있다.

### 디바이스에서 SQLite3 사용해서 데이터베이스 접근하기

이젠 emulator가 아닌 실제 디바이스를 연결해서 디바이스 쪽으로 앱을 빌드해보자. 디바이스를 연결하고 다시 디바이스 목록을 보면 다음과 같이 emulator가 아닌 serial number를 가진 실제 디바이스가 검색되는 것을 확인할 수 있다.

```
./adb devices
```

![](http://cfile5.uf.tistory.com/image/2506C23452E20CD7082539)

이제 emulator에서 접근한 방법과 동일하게 디바이스에 접근해보자.

```
./adb -s {디바이스 시리얼번호} shell
```

그리고 emulator와 동일한 방법으로 예제 프로젝트의 데이터베이스 디록토리로 이동한다.

```
cd /data/data/net.saltfactory.tutorial.sqlite3demo/databases
```

이동 후 데이터베이스 목록을 보기 위해서 ls 명령어 실행하면 emulator와 달리 opendir failed, Permission denied 에러가 나타난다.

![](http://cfile5.uf.tistory.com/image/2318544752E20E7C2F7BA1)

emulator에서 shell은 root 권한이지만, 디바이스에 접근할 경우 보안 문제 때문에 root 권한을 가질 수가 없다. rooting을 이용해서 root 권한을 얻을 수 있지만 이는 불법적인 방법이기 때문에 사용하기 꺼려진다. 그럼 sqlite3는 실행할 수 있을까? 우리는 데이터베이스 이름을 알기 때문에 sqlite3로 데이터베이스를 바로 열 수 있다.

```
sqlite3 sf_db_sqlite3_demo.db
```

이렇게 sqlite3를 실행하면 sqlite3 명령어를 찾을 수 없다고 나온다.

![](http://cfile25.uf.tistory.com/image/2329694152E20F8301F12A)

ICS 이상 버전에서는 run-as 명령어를 실행할 수 있는데 이것은 shell에서 어플리케이션을 동작시키는 명령어로 어플리케이션 동작 상태 환경으로 만들어준다.

```
run-as net.saltfactory.tutorial.sqlite3demo
```

그리고 ls 명령어를 실행하면 다음과 같이 어플리케이션이 사용하고 있는 디렉토리 목록을 살펴볼 수 있다.

![](http://cfile29.uf.tistory.com/image/2704ED4452E213C437627D)

디렉토리 접근은 가능하지만 여전히 sqlite3 명령어를 사용할 수 없다. 그래서 우리는 다음과 같이 sqlite3 바이너리 파일을 안드로이드 디바이스에 복사해서 넣는다. 단순히 sqlite3 파일을 복사하면 실행이 되지 않는다. sqlite3 파일은 실행 및 라이브러리가 모두 바이너리 파일로 포함된 파일이어야 하는데 다음 링크에서 sqlite3를 구할 수 있다. (SQLite3 다운로드 : Jelly Bean and later here)

```
adb -s {시리얼번호} push sqlite3 /data/local/tmp/sqlite3
```

이제 adb shell로 접근하자

```
adb -s {시리얼번호} shell
```

이제 sqltie3 명령어를 실행할 수 있도록 권한을 부여하자.

```
chmod 755 /data/local/tmp/sqlite3
```

복사한 sqlite3를 실행해보자

![](http://cfile24.uf.tistory.com/image/274C843A52E2198A341A55)

sqlite3 명령어가 먹히는 것을 확인할 수 있다.
이젠 sqlite3로 우리가 접근하고 싶어하는 디바이스내 데이터베이스에 접근해보자.

```
run-as net.saltfactory.tutorial.sqlite3demo
```

그리고 데이터베이스 디렉토리로 변경한다.

```
cd databases
```

이제 복사해둔 sqlite3를 실행하자.

```
/data/local/tmp/sqlite3 sf_db_sqlite3_demo.db
```

![](http://cfile23.uf.tistory.com/image/21636F4B52E21BE3198BBD)

위에서 emulator에서 sqlite3로 실행한 것과 동일하게 이젠 디바이스 안에 데이터베이스 안에 접근해서 디버깅을 할 수 있게 되었다.

## 결론

모든 경우에 emulator에서 데이터베이스 접근을 하면 좋겠지만, 상황에 따라서 디바이스에서 데이터베이스를 접근해서 데이터가 어떻게 변화는지 확인해 볼 필요가 있다. 반대로 디바이스에 접근해서 데이터를 조회할 수 있다는 것은 보안적인면에서 상당히 위험하다. 그래서 안드로이드 앱을 개발할 때 이렇게 외부에서 디바이스로 데이터베이스 접근이 가능하다는 것을 알고 다양한 보안적 측면을 강화해서 개발을 해야한다는 것도 명심해야할 것 같다.

## 소스코드

https://github.com/saltfactory/saltfactory-android-tutorial/tree/sf-sqlite3-demo

## 참고

1. http://developer.android.com/tools/help/adb.html
2. http://stackoverflow.com/questions/3645319/why-do-i-get-a-sqlite3-not-found-error-on-a-rooted-nexus-one-when-i-try-to-op

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
