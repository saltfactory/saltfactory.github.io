---
layout: post
title: 자바스크립트 메소드 체이닝패턴
category: javascript
tags: [javascript, pattern]
comments: true
redirect_from: /222/
disqus_identifier : http://blog.saltfactory.net/222
---

## 서론

자바스크립트는 다른 언어에 비해서 쉬우면서도 어렵고 유연하면서도 복잡하다는 것을 사용하면 할 수록 느끼게 되는 것 같다. 한때 웹 개발을 중심으로 할 때는 자바스크립트 코드를 많이 사용했다. 이때는 지금의 자바스크립트와는 매우 다른 형태였다. 그렇게 복잡한 코드도 코드 양도 많지 않았던 그 시절과 다르게 이젠 자바스크립트 자체로 어플리케이션을 만들 수도 있고 서버 프로그램을 할 수 있는 세상이 되었다. 그렇다보니 자바스크립트 코드가 복잡해지고 방법도 다양해졌다. 그래서 자바스크립트 언어의 특징을 잘 이해하면서 간결하고 효율적인 코드를 생성하거나 사용할 수 있다.  뿐만 아니라 자바스크립트도 프로그래밍 언어로 기존의 프로그래밍 언어로 개발하는 패턴을 그대로 적용할 수 있다.

자바스크립트에서 `Object.function().function().function()` 이렇게 진행되는 코드를 보면서 하나의 Object의 메소드가 순차적으로 call 되는 코드를 만들 수 있다는 것을 알 수 있었다. 또한 이렇게 코드를 작성하면 코드량을 줄 일 수 있는 것도 가능하다. 그래서 이렇게 메소드가 순차적으로 진행되는 패턴을 찾아보니 메소드 체이닝(Method Chaining) 패턴이라는 것을 알게 되었다.

<!--more-->

## Method Chaining 예

일단 메소드 체이닝이 사용된 예제를 살펴보자.

우리는 흔히 이런 코드를 볼 수 있다. DOM API를 이용해서 body라는 노드 밑에 새로운 노드를 추가한다고 할 때 다음과 같이 추가할 수 있다. 여기서 DOM API를 잘 살펴보면 document가 가지고 있는 `getElementByTagName` 메소드로 body 노드를 찾아서 그중에 첫번째 배열의 값을 가져와서 DOM API가 가지고 있는 appendChild로 새로운 노드를 추가하는 것이다.

```javascript
document.getElementByTagName('body')[0].appendChild(newnode);
```

우리는 자바스크립트 코드를 객체처럼 사용하기 위해서 다음과 같은 코드로 프로그램을 만드는 방법을 즐겨 사용한다.
만약 JavaScript로 데이터베이스에 접근하는 객체를 만든다고 가정해보자.

```javascript
var DBConnector = function(){
	this._host = '';
	this._port = 0;
	this._user = null;
	this._password = null;
};

DBConnector.prototype.host = function(host){
	this._host = host;
};

DBConnector.prototype.port = function(port){
	this._port = port;
};

DBConnector.prototype.user = function(user){
	this._user = user;
};

DBConnector.prototype.password = function(password){
	this._password = password;
};

DBConnector.prototype.connect = function(){
	console.log("host : " + this._host);
	console.log("port : " + this._port);
	console.log("user : " + this._user);
	console.log("password : " + this._password);
};

```

host, port, user, password를 입력 받아서 데이터베이스에 접근하려면 우리는 위 코드를 다음과 같이 사용을 할 것이다. 우리는 하나의 객체에 메소드를 지정하고 순차적으로 메소드가 위에서 아래로 호출하면서 처리되는 것에 익숙해져 있기 때문이다.

```javascript
var dbconn = new DBConnector();
dbconn.host('localhost');
dbconn.port(80);
dbconn.user('saltfactory');
dbconn.password('password');
dbconn.connect();
```

위 코드를 실행을 해보자.

```
node chaining-demo.js
```

예상한 결과가 나오는 것을 확인 할 수 있다. 코드는 매우 간단하게 host, port, user, password를 입력 받고 connect라는 메소드가 호출되면서 저장된 멤버변수를 출력한 예제이다.

![](http://cfile6.uf.tistory.com/image/2734C83352EF4D6E0E424E)

그럼 우리는 메소드 체이닝을 해볼 것이다. 메소드 체이닝은 메소드를 순차적으로 호출할 수 있게 메소드에 메소드를 붙여서 사용한다. 그래서 우리는 위 실행코드를 다음과 같이 수정했다.

```javascript
dbconn.host('localhost').port(80).user('saltfactory').password('password').connect();
```

다시 실행해보자. 실행 결과는 다음과 같다. port 메소드가 호출되기 전에 에러가 발생하는데 이것은 port라는 메소드를 `host('localhost')`에서 찾기 때문에이다.

![](http://cfile29.uf.tistory.com/image/24274E4852EF507925CBF0)

그래서 다음과 같이 코드를 수정한다. 메소드에 객체 인스턴스인 this를 반환하게 넣어주는 것이다. 이렇게 되면 메소드가 호출하되고 난 다음 다음 메소드를 호출할 수 있게 되는 것이다.

```javascript
var DBConnector = function(){
	this._host = null;
	this._port = null;
	this._user = null;
	this._password = null;
};

DBConnector.prototype.host = function(host){
	this._host = host;
	return this;
};

DBConnector.prototype.port = function(port){
	this._port = port;
	return this;
};

DBConnector.prototype.user = function(user){
	this._user = user;
	return this;
};

DBConnector.prototype.password = function(password){
	this._password = password;
	return this;
};

DBConnector.prototype.connect = function(){
	console.log("host : " + this._host);
	console.log("port : " + this._port);
	console.log("user : " + this._user);
	console.log("password : " + this._password);
	return this;
};
```

다시 메소드 체이닝으로 만들어진 코드를 실행해보자.

```javascript
dbconn.host('localhost').port(80).user('saltfactory').password('password').connect();
```

![](http://cfile6.uf.tistory.com/image/2734C83352EF4D6E0E424E)

그럼 메소드 체이닝 패턴은 자바스크립트에서만 사용할 수 있는 패턴인가? 그렇지 않다. 다른 언어에서도 이와 같이 메소드 체이닝 패턴을 동일한 방법으로 구현할 수 있다.

다음은 동일한 방법으로 Ruby로 메소드 체이닝을 구현하였다.

```javascript
class DBConnector
  def host(value)
    @host = value
    self
  end

  def port(value)
    @port = value
    self
  end

  def user(value)
    @user = value
    self
  end

  def password(value)
    @password = value
    self
  end

  def connect
    puts "host : #{@host}"
    puts "port : #{@port}"
    puts "user : #{@user}"
    puts "password : #{@password}"

    self
  end
end


dbconn = DBConnector.new
# dbconn.host('localhost')
# dbconn.port(80)
# dbconn.user('saltfactory')
# dbconn.password('password')
# dbconn.connect()

dbconn.host('localhost').port(80).user('saltfactory').password('password').connect()
```

![](http://cfile10.uf.tistory.com/image/2478AF3A52EF587F253B7F)

Java에서는 메소드 체이닝을 사용할 수 있을까? 물론 가능하다 다음과 같이 메소드 안에서 자신을 리턴해 주면 된다.

```java
class DBConnector {
	private String host;
	private Integer port;
	private String user;
	private String password;

	public DBConnector host(String host){
		this.host = host;
		return this;
	}

	public DBConnector port(Integer port){
		this.port = port;
		return this;
	}

	public DBConnector user(String user){
		this.user = user;
		return this;
	}

	public DBConnector password(String password){
		this.password = password;
		return this;
	}

	public DBConnector connect(){
		System.out.println("host : " + this.host);
		System.out.println("port : " + this.port);
		System.out.println("user : " + this.user);
		System.out.println("password : " + this.password);
		return this;
	}
}


public class ChainingDemo{
	public static void main(String [] args){

		DBConnector dbconn = new DBConnector();
		dbconn.host("localhost").port(80).user("saltfactory").password("password").connect();

	}

}
```

## 결론

자바스크립트는 다른 언어보다 유연하기 때문에 같은 패턴이라고 할지라도 간결하고 유연하게 작성할 수도 있다. 메소드 체이닝 패턴은 자바스크립트에만 사용 가능한 패턴이 아니다. 우리가 jQuery나 DOM API를 사용하면서 익숙하게 느껴져서 마치 자바스크립트에서만 사용할 수 있는 패턴처럼 느껴지지만 다른 언어에서도 동일한 원리로 얼마든지 사용이 가능하다. 다만 리턴 타입을 지정해주는 Strongly typed language(자바와 같은) 에서는 이런 메소드 체이닝 패턴 사용하면 코드량이 오히려 많아지거나 리턴 타입을 신경써야하기 때문에 사용하기 불편할 수 도 있다. 하지만 실제 실행되는 코드를 사용할 때는 순차적으로 객체에 메소드를 호출하는 것 보다 이렇게 메소드 체이닝을 사용하면 코드가 간결해지고 사용하기 편리해지는 장점이 있다. 메소드 체이닝 패턴은 프로그램을 고차원적으로 수준 높게 만들어주는 패턴은 아니지만 사용하기 편리하고 간결하게 만들어주는 장점이 있으니 필요할 때 적절히 사용해보는 것도 괜찮을 것 같다. 우리가 사용하는 자바스크립트 라이브러리들은 대부분 메소드 체이닝을 지원하는 이유도 이와 같지 않을까? 사용자에게 간결하고 사용하기 편리한 인터페이스를 제공해주기 위함이라 생각이 든다.

## 참고

1. JavaScript Patterns, O'REILLY
2. http://en.wikipedia.org/wiki/Method_chaining
3. http://www.sitepoint.com/a-guide-to-method-chaining/

## 연구원 소개

* 작성자 : [송성광](http://about.me/saltfactory) 개발 연구원
* 블로그 : http://blog.saltfactory.net
* 이메일 : [saltfactory@gmail.com](mailto:saltfactory@gmail.com)
* 트위터 : [@saltfactory](https://twitter.com/saltfactory)
* 페이스북 : https://facebook.com/salthub
* 연구소 : [하이브레인넷](http://www.hibrain.net) 부설연구소
* 연구실 : [창원대학교 데이터베이스 연구실](http://dblab.changwon.ac.kr)
