---
layout: post
title: Ruby로 살펴보는 Mixin 이해
category: ruby
tags: [ruby, mixin, pattern]
comments: true
redirect_from: /209/
disqus_identifier : http://blog.saltfactory.net/209
---

## 서론

Ruby를 처음 접하게 된 것은 순수하게 컴퓨터전공을 하는 나의 학부시절 "Programming Languages Concepts"라는 과목의 과제로 조별로 각각 겹치지 않는 프로그램언어에 대한 조사를 해서 발표하는 시간 때문이였다. python, perl, xml, php, java 등 이미 익숙한 프로그래밍 언어에서 제외되어서 결국 찾게된 것이 Ruby Programming Lanaguage 였다. 처음은 그냥 이름이 마음에 들었는데 Perl과 Python의 조합으로 이루어진것 같은 이 언어는 모든게 객체인 이게 바로 진짜 객체 언어야 라고 박수를 치면서 Ruby의 매력에 점점 빠져들게 되었다. 얼마 지나지 않아서 Ruby on Rails가 scaffold를 이용해서 5분안에 블로그를 만드는 동영상이 인터넷에서 커다란 이슈를 만들었고 이후 agile 기반의 빠른 웹 개발 프레임워크로 웹 개발자들에게 가장 인기 있는 언어로 등극하게 되었다. 비록 학부 과제 때문에 Ruby를 알게 되었지만 Ruby의 빠르게 개발할 수 있고 확장성이 좋고 유연하며 코드량을 줄일 수 있다는 이유로 지금도 서버 프로그램은 대부분 Ruby로 만들고 있다.

오늘 Ruby를 다시 찾게 된 이유는 바로 [Mixin](http://en.wikipedia.org/wiki/Mixin) 이라는 개념 때문이다. 연구소에서 Java Web Application framework로 Spring MVC framework를 선택했고 수석 연구원께서 ROO를 적극적으로 도입하려고 해서 ROO에 대해서 찾아보았다. 그러던 도중에 ROO가 Mixin으로 구현되었다는 특징을 보게 되어서 Mixin의 개념을 회고하기 위해서 Ruby의 Mixin을 소개하려고 한다.

<!--more-->


### 상속

먼저 Java에서 상위 클래스의 속성을 그대로 상속받아서 확장된 서브 클래스를 만들어 사용하는 것에 익숙하다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/6f3c98e9-e999-4170-a89e-8f98415c317f)

Java 코드로 살펴보면 `Number`의 `intValue` 메소드를 상속받아서 `BigInteger`는 `inteValue` 메소드를 가지고 있지만, `stringfy`라는 `value` 값을 문자열로 출력하게 하는 메소드를 추가했다.

```ruby
public class Number {
	protected int value;

	public void intValue (int value){
		this.value = value;
	}
}

public class BigInteger extends Number {
	public BigInteger(int value){
		super.value = value;
	}

	public String stringfy(){
		String str = null;

		if (this.value == 1){
			str = "One";
		} else if (this.value == 2){
			str = "Two";
		} else if (this.value == 3){
			str = "Three";
		}

		return str;
	}
}

```

또는 Java에서는 추상클래스를 만들고 그것을 상속받아서 구현체를 만들어 가는 것 또 한 Java 객체 지향 프로그램에 익숙한 클래스의 사용 패턴이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/7e6e86f2-ab1c-404e-9f4a-2a02236cf8c5)

하지만 현실의 세계에서는 객체가 단일 상속만 이루어지지 않는다. 예를 들어 엄마, 아빠에게서 서로 좋은 점만 닮은 특징을 가져와서 같이 사용하고 싶은 경우가 충분히 있을 수 있다. 개발자와 디자이너의 메소드를 각각 가져와서 유니콘 같은 슈퍼개발자를 만들고 싶어한다면 Java와 같은 단일 상속만 지원하는 프로그래밍 언어에서는 절대 유니콘을 만들 수 없게 된다.

### Mixin

Mixin은 이러한 한계를 해결할 수 있는 개발 패턴이다. 즉 클래스에 새로운 특징을 더 추가해서 여러가지 기능을 필요한 곳에서 가져와서 새로운 클래스를 만드는 것이다. 우리가 지금까지 목말라해온 다중 상속의 문제를 아주 간단하게 해결할 수 있는 도깨비 방망이 같은 것이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/5fc73d39-592f-45f4-95cd-61b5d06f1fc8)

과연 Ruby는 어떻게 이런것이 가능할까? 루비는 **Class**와 비슷한 **Module** 이라는 것을 가지고 있다. Module는 Class와 비슷하게 메소드, 상수, 모듈, 클래스를 포함할 수 있다. 그러나 Class와 달리 모듈을 상속받아서 객체를 생성할 수는 없다. 하지만 이 Module의 인스턴스 메소드를 클래스에서 사용할 수 있다. 이렇게 상속을 하지 않고도 여러개의 Class가 같은 Module을 mixin해서 사용하거나 여러개의 Module을 하나의 클래스에 mixin하여 사용할 수 있다. 위에서 작성한 Java 코드의 한계를 Ruby에서는 이렇게 해결을 하였다.

예제 코드는 `Math`와 `Stringfy`라는 두가지 Module를 가지고 있고, `Number`라는 클래스를 상속받아서 만든 `BigInteger`에 Mixin을 해서 객체에 모듈의 메소드를 추가하는 예제이다.

Math 모듈은 `add`라는 메소드를 가지고 있는데 두 수를 더하는 값을 `BigInteger`에 초기 값으로 넘겨주는 메소드이다.

```ruby
# filename : Math.rb

module Math
  def add(value_one, value_two)
    BigInteger.new(value_one+value_two)
  end
end
```

`Stringfy` 모듈은 `stringfy`라는 메소드를 가지고 있는데 `@value`라는 객체 변수의 값에 따라서 문자열을 반환해주는 메소드이다.

```ruby
#filename : Stringfy.rb

module Stringfy
  def stringfy
    if @value == 1
      "One"
    elsif @value == 2
      "Two"
    elsif @value == 3
      "Three"
    end
  end
end
```

`Number` 클래스는 `inteValue`라는 메소드를 가지고 있는데 이것은 `@value `객체를 반환하는 메소드이다.

```ruby
# filename : Number.rb

class Number
  def intValue
    @value
  end
end
```

위의 `Number` 클래스를 상속해서 `BigInteger` 클래스를 만드는데 이 클래스에 `Stringfy`를 mixin하고 `Math` 메소드를 확장했다.

```ruby
#filename : BigInteger.rb

require 'Stringfy'
require 'Math'
require 'Number'

class BigInteger < Number
  include Stringfy
  extend Math

  def initialize(value)
    @value = value
  end
end
```

테스트를 해보자. 아래 코드는 단순하게 `BigInteger`를 사용해서 생성자에 10이라는 값을 넣고 객체를 생성해서 `Number`가 가지고 있었던 `intValue`로` @value`객체 변수의 값을 출력하는 코드이다.

```ruby
#filename test.rb
require 'BigInteger'

bigint1 = BigInteger.new(10)
puts bigint1.intValue
```

단순히 `BigInteger`가 가지고 있는 생성자 메소드인 `initialize` 에서 받은 value 값을 객체 변수 `@value`에 할당했다가 출력하는 Java와 같은 단순 상속의 예제이다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/aec489bd-01bc-4ddc-9ca3-a01d6006ad1a)

다음은 Math를 Mixin으로 추가된 `Math`의 `add`를 사용해서 `BigInteger` 객체를 생성해보자.

```ruby
#filename test.rb
require 'BigInteger'

bigint1 = BigInteger.new(10)
puts bigint1.intValue

bigint2 = BigInteger.add(-2, 4)
puts bigint2.intValue
```

Mixin으로 Math의 `add`가 실행되었는데 이 때 입력받은 두 인자값은 Math의 `add` 메소드안에 포함된 클래스 `BigInteger.new(a+b)`로 두 인자 값을 더해서 객체를 생성시키는 것이다. 그래서 결국은 `BigInteger`의 객체변수 `@value`에 두 인자를 더한 2의 값이 저장되어 있다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/58e8582d-c8c7-4acb-99f7-3696c153af31)

여기 생성된` bigint2`는 `Math` 뿐만 아니라` Stringfy`도 Mixin되어 있기 때문에 `Stringfy`의 `stringfy` 메소드를 사용할 수 있다. 결과는 `BigInteger`의 객체인 bigint2의 객체변수(@value)가 2이기 때문에 `Stringfy`의 인스턴스 메소드 `stringfy` 안에 `@value`를 비교해서 해당 문자열을 반환하는 메소드가 실행이 된 것이다.

```ruby
#filename test.rb
require 'BigInteger'

bigint1 = BigInteger.new(10)
puts bigint1.intValue

bigint2 = BigInteger.add(-2, 4)
puts bigint2.intValue
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/2345c876-d693-456c-bb9c-abed6df61ab3)

마지막 테스트로 생성된 객체에다 새로운 Module을 하나더 mixin 해보기로 하자. `BigInteger`로 생성한 객체 `bigint2`에 `format`이라는 메소드를 가진 Module을 Mixin했다. 그리고 `bigint2`에 mixin된 module의 메소드인 `format`으로 객체의 객체변수 `@value` 값 앞에 `$`를 붙여서 출력시키도록 했다.

```ruby
#filename test.rb
require 'BigInteger'

bigint1 = BigInteger.new(10)
puts bigint1.intValue

bigint2 = BigInteger.add(-2, 4)
puts bigint2.intValue
puts bigint2.stringfy

module CurrencyFormatter
  def format
    "$#{@value}"
  end
end

bigint2.extend CurrencyFormatter
puts bigint2.format
```

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/799d5164-7c25-4d54-9671-6d2c722d6a72)

그럼 `CurrecyFormatter`를 Mixin하지 않은` bigint1`이라는 `BigInteger`로 만든 객체는 과연 `format`이라는 메소드를 가지고 있을까? 아래와 같이 Mixin되지 않는 객체에서 format 메소드를 불렀기 때문에 에러가 발생한다.

![](http://hbn-blog-assets.s3.amazonaws.com/saltfactory/images/ec15928c-aa7a-4be1-9637-b9f3334a9e35)

결과가 놀랍지 않는가? 마치 JavaScript의 prototype 마냥 Module을 이용해서 무한정 메소드를 추가할 수 있게 되었다. 심지어 클래스로 생성된 객체에도 mixin이 가능하다는 것이다. 이런 이유로 Ruby는 Module과 Class를 잘 이용해서 유연하고 확정성 좋은 모듈과 라이브러리를 만들어서 쉽게 다양한 프로젝트에서 코드를 재사용할 수 있는 장점을 가지고 있다.

## 결론

객체 지향 언어의 장점은 클래스를 만들어서 다른 프로그램을 작성할 때 그 클래스를 재사용할 수 있다는 것이다. 하지만 클래스가 많아지고 여러자기 클래스의 속성들을 조합해서 하나의 클래스고 상속해서 코드도 줄이고 코드를 재사용하고 싶지만, Java와 같은 객체 지향 언어에서는 다중 상속을 할 수가 없다. 하지만 Mixin을 지원하는 객체지향 언어는 다중 클래스를 상속해서 객체를 만든는 것과 같은 방법을 Mixin을 이용해서 할 수 있다. 클래스와 객체에 여러개의 메소드를 가진 Module을 Mixin시켜서 Module이 가지고 있는 메소드를 클래스로 생성한 객체에서 멤버 메소드인것 처럼 객체의 변수와 모듈의 메소드를 서로 연결하여 하나의 클래스인것 처럼 사용 할 수 있다. 이러한 Mixin의 장점은 중복 코드를 제거하고 코드의 유연성을 높여서 기능별로 모듈을 만들어서 필요할 때 마치 레고 블럭을 맞추듯 필요한 모듈을 클래스에 조립해서 필요한 메소드를 사용할 수 있다는 것이다. ROO가 이런 Mixin으로 구현되어 있다는데 Ruby의 Mixin과 구현 방법은 다를지 몰라도 Mixin 패턴으로 개발이 되었다는 말은 클래스에 다른 모듈이나 클래스의 멤버 메소드나 멤버변수가 injection 된다는 이야기로 상상해볼 수 있을 것 같다. 좀더 자세한 내용은 ROO를 실험하고 테스트한 뒤 다시한번 Ruby의 Mixin과 비교해서 포스팅할 예정이다.

## 참고

1. http://www.silversoft.net/docs/dp/hires/chap1fso.htm
2. http://lambert.tistory.com/165
3. http://juixe.com/techknow/index.php/2006/06/15/mixins-in-ruby/
4. http://en.wikipedia.org/wiki/Mixin

